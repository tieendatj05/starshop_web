package com.starshop.controller;

import com.starshop.dto.CheckoutInfoDTO;
import com.starshop.entity.Order;
import com.starshop.entity.PaymentTransaction;
import com.starshop.entity.User;
import com.starshop.repository.PaymentTransactionRepository;
import com.starshop.service.OrderService;
import com.starshop.service.UserService;
import com.starshop.service.VnpayService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private VnpayService vnpayService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    @Autowired
    private PaymentTransactionRepository paymentTransactionRepository;

    @GetMapping("/vnpay-return")
    public String vnpayReturn(HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        Map<String, String> vnpayResponse = vnpayService.handleVnpayReturn(request);

        if (vnpayResponse == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Chữ ký VNPAY không hợp lệ.");
            return "redirect:/order/checkout";
        }

        String responseCode = vnpayResponse.get("vnp_ResponseCode");
        String transactionRef = vnpayResponse.get("vnp_TxnRef");

        if ("00".equals(responseCode)) {
            CheckoutInfoDTO checkoutInfo = (CheckoutInfoDTO) session.getAttribute("checkoutInfo");
            User currentUser = getCurrentUser();

            if (checkoutInfo == null || currentUser == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Phiên làm việc của bạn đã hết hạn. Vui lòng thử lại.");
                return "redirect:/order/checkout";
            }

            try {
                List<Order> newOrders = orderService.createOrders(currentUser, checkoutInfo);
                session.removeAttribute("checkoutInfo");

                for (Order order : newOrders) {
                    PaymentTransaction transaction = PaymentTransaction.builder()
                            .order(order)
                            .transactionRef(transactionRef)
                            .vnpTransactionNo(vnpayResponse.get("vnp_TransactionNo"))
                            .amount(order.getTotalAmount())
                            .status("SUCCESS")
                            .responseCode(responseCode)
                            .transactionInfo(vnpayResponse.toString())
                            .build();
                    paymentTransactionRepository.save(transaction);
                }

                if (newOrders.size() == 1) {
                    redirectAttributes.addFlashAttribute("orderId", newOrders.get(0).getId());
                    redirectAttributes.addFlashAttribute("successMessage", "Thanh toán và đặt hàng thành công!");
                } else {
                    StringBuilder orderIds = new StringBuilder();
                    for (int i = 0; i < newOrders.size(); i++) {
                        if (i > 0) orderIds.append(", ");
                        orderIds.append("#").append(newOrders.get(i).getId());
                    }
                    redirectAttributes.addFlashAttribute("successMessage",
                        "Thanh toán và đặt hàng thành công! Đơn hàng của bạn đã được tách thành " + newOrders.size() +
                        " đơn hàng riêng biệt: " + orderIds.toString());
                    redirectAttributes.addFlashAttribute("orderCount", newOrders.size());
                }

                return "redirect:/order/order-success";
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Đã xảy ra lỗi khi tạo đơn hàng sau khi thanh toán: " + e.getMessage());
                return "redirect:/order/checkout";
            }
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Thanh toán VNPAY không thành công. Mã lỗi: " + responseCode);
            return "redirect:/order/checkout";
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
