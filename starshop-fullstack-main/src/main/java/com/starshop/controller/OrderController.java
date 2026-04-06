package com.starshop.controller;

import com.starshop.dto.CartDTO;
import com.starshop.dto.CheckoutInfoDTO;
import com.starshop.dto.PromotionDTO;
import com.starshop.entity.Order;
import com.starshop.entity.OrderDetail;
import com.starshop.entity.User;
import com.starshop.repository.ShippingCarrierRepository;
import com.starshop.service.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/order")
public class OrderController {

    private static final Logger log = LoggerFactory.getLogger(OrderController.class);

    @Autowired
    private UserService userService;
    @Autowired
    private CartService cartService;
    @Autowired
    private AddressService addressService;
    @Autowired
    private ShippingCarrierRepository shippingCarrierRepository;
    @Autowired
    private OrderService orderService;
    @Autowired
    private PromotionService promotionService;
    @Autowired
    private ReviewService reviewService;
    @Autowired
    private VnpayService vnpayService;

    @GetMapping("/checkout")
    public String checkout(Model model) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        CartDTO cartDTO = cartService.getCartForUser(currentUser);
        if (cartDTO.getItems() == null || cartDTO.getItems().isEmpty()) {
            return "redirect:/cart";
        }

        if (!cartDTO.isCheckoutAllowed()) {
            model.addAttribute("errorMessage", "Giỏ hàng của bạn chứa sản phẩm không hợp lệ. Vui lòng kiểm tra lại.");
            return "redirect:/cart";
        }

        List<PromotionDTO> applicablePromotions = promotionService.findApplicableSavedPromotions(currentUser, cartDTO);

        model.addAttribute("cart", cartDTO);
        model.addAttribute("addresses", addressService.getAddressesForUser(currentUser));
        model.addAttribute("carriers", shippingCarrierRepository.findByIsActiveTrue());
        model.addAttribute("applicablePromotions", applicablePromotions);

        return "order/checkout";
    }

    @PostMapping("/checkout/place-order")
    public String placeOrder(@ModelAttribute CheckoutInfoDTO checkoutInfo, HttpServletRequest request, HttpSession session, RedirectAttributes ra) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        if ("VNPAY".equalsIgnoreCase(checkoutInfo.getPaymentMethod())) {
            // Store checkout info in session to retrieve after payment
            session.setAttribute("checkoutInfo", checkoutInfo);
            String paymentUrl = vnpayService.createPaymentUrl(currentUser, checkoutInfo, request);
            return "redirect:" + paymentUrl;
        } else {
            try {
                List<Order> newOrders = orderService.createOrders(currentUser, checkoutInfo);

                if (newOrders.size() == 1) {
                    ra.addFlashAttribute("orderId", newOrders.get(0).getId());
                    ra.addFlashAttribute("successMessage", "Đặt hàng thành công!");
                } else {
                    StringBuilder orderIds = new StringBuilder();
                    for (int i = 0; i < newOrders.size(); i++) {
                        if (i > 0) orderIds.append(", ");
                        orderIds.append("#").append(newOrders.get(i).getId());
                    }
                    ra.addFlashAttribute("successMessage",
                        "Đặt hàng thành công! Do sản phẩm đến từ " + newOrders.size() +
                        " cửa hàng khác nhau, đơn hàng của bạn đã được tách thành " + newOrders.size() +
                        " đơn hàng riêng biệt: " + orderIds.toString());
                    ra.addFlashAttribute("orderCount", newOrders.size());
                }

                return "redirect:/order/order-success";
            } catch (Exception e) {
                ra.addFlashAttribute("errorMessage", "Đã xảy ra lỗi khi đặt hàng: " + e.getMessage());
                return "redirect:/order/checkout";
            }
        }
    }

    @GetMapping("/order-success")
    public String orderSuccess(Model model) {
        if (!model.containsAttribute("orderId") &&
            !model.containsAttribute("orderCount") &&
            !model.containsAttribute("successMessage")) {
            return "redirect:/home";
        }
        return "order/order-success";
    }

    @GetMapping("/orders")
    public String orderHistory(
            Model model,
            @RequestParam(name = "status", required = false) String statusFilter
    ) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }

        List<Order> orders = orderService.findOrdersForUser(currentUser, statusFilter);
        model.addAttribute("orders", orders);
        model.addAttribute("currentStatusFilter", statusFilter);

        Map<Long, Boolean> hasReviewedMap = new HashMap<>();
        if (currentUser != null) {
            for (Order order : orders) {
                for (OrderDetail detail : order.getOrderDetails()) {
                    boolean reviewed = reviewService.hasUserReviewedProduct(currentUser.getId(), detail.getProduct().getId());
                    hasReviewedMap.put(detail.getId(), reviewed);
                }
            }
        }
        model.addAttribute("hasReviewedMap", hasReviewedMap);

        List<String> allOrderStatuses = Arrays.asList(
            "Đơn hàng mới",
            "Chờ xác nhận",
            "Chờ lấy hàng",
            "Đang giao",
            "Giao thành công",
            "Giao thất bại",
            "Đã hủy"
        );
        model.addAttribute("allOrderStatuses", allOrderStatuses);

        return "order/orders";
    }

    @PostMapping("/checkout/apply-discount")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> applyDiscount(
            @RequestBody Map<String, Object> payload) {

        Map<String, Object> response = new HashMap<>();

        User currentUser = getCurrentUser();
        if (currentUser == null) {
            response.put("success", false);
            response.put("message", "Vui lòng đăng nhập để áp dụng mã giảm giá.");
            return ResponseEntity.status(401).body(response);
        }

        try {
            String discountCode = (String) payload.get("discountCode");

            Object cartTotalObj = payload.get("currentCartTotal");
            BigDecimal currentCartTotal;

            if (cartTotalObj instanceof String) {
                currentCartTotal = new BigDecimal((String) cartTotalObj);
            } else if (cartTotalObj instanceof Number) {
                currentCartTotal = BigDecimal.valueOf(((Number) cartTotalObj).doubleValue());
            } else {
                throw new IllegalArgumentException("Invalid currentCartTotal type");
            }

            CartDTO cartDTO = cartService.getCartForUser(currentUser);
            BigDecimal discountAmount = orderService.applyDiscountCode(discountCode, cartDTO, currentCartTotal);

            if (discountAmount.compareTo(BigDecimal.ZERO) > 0) {
                response.put("success", true);
                response.put("discountAmount", discountAmount.doubleValue());
                response.put("message", "Áp dụng mã giảm giá thành công!");
            } else {
                response.put("success", false);
                response.put("discountAmount", 0.0);
                response.put("message", "Mã giảm giá không hợp lệ hoặc không áp dụng được.");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("discountAmount", 0.0);
            response.put("message", "Lỗi khi áp dụng mã giảm giá: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    @PostMapping("/cancel")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> cancelOrder(@RequestBody Map<String, Object> payload) {
        Map<String, Object> response = new HashMap<>();
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            response.put("success", false);
            response.put("message", "Vui lòng đăng nhập để hủy đơn hàng.");
            return ResponseEntity.status(401).body(response);
        }
        try {
            Object idObj = payload.get("orderId");
            if (idObj == null) throw new IllegalArgumentException("Thiếu mã đơn hàng.");
            Integer orderId = (idObj instanceof Number) ? ((Number) idObj).intValue() : Integer.valueOf(idObj.toString());

            orderService.cancelOrderAsUser(orderId, currentUser);

            response.put("success", true);
            response.put("message", "Hủy đơn hàng thành công.");
            return ResponseEntity.ok(response);
        } catch (SecurityException se) {
            response.put("success", false);
            response.put("message", se.getMessage());
            return ResponseEntity.status(403).body(response);
        } catch (IllegalStateException | IllegalArgumentException ie) {
            response.put("success", false);
            response.put("message", ie.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (Exception e) {
            log.error("Lỗi khi hủy đơn hàng", e);
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra, vui lòng thử lại sau.");
            return ResponseEntity.internalServerError().body(response);
        }
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication.getPrincipal().equals("anonymousUser")) {
            return null;
        }
        return userService.findByUsername(authentication.getName()).orElse(null);
    }
}
