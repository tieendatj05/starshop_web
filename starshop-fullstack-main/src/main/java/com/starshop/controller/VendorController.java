package com.starshop.controller;

import com.starshop.config.CustomUserDetails;
import com.starshop.dto.ShopCommissionDTO;
import com.starshop.dto.VendorDashboardStatsDTO;
import com.starshop.entity.Order;
import com.starshop.entity.Shop;
import com.starshop.entity.User;
import com.starshop.service.OrderService;
import com.starshop.service.ShopCommissionService;
import com.starshop.service.ShopService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/vendor")
public class VendorController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    @Autowired
    private ShopService shopService;

    @Autowired
    private ShopCommissionService commissionService;

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        try {
            VendorDashboardStatsDTO stats = orderService.getVendorDashboardStats(currentUser);

            if (currentUser.getShop() != null) {
                ShopCommissionDTO currentCommission = commissionService.getCurrentMonthCommission(currentUser.getShop().getId());
                if (currentCommission != null) {
                    stats.setCurrentMonthCommissionRate(currentCommission.getCommissionPercentage());
                    stats.setCurrentMonthCommissionAmount(currentCommission.getCommissionAmount());
                    stats.setCurrentMonthNetAmount(currentCommission.getNetAmount());
                    stats.setCurrentMonthTotalOrders(currentCommission.getTotalOrders());
                }
                model.addAttribute("shop", currentUser.getShop());
            }

            model.addAttribute("stats", stats);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Không thể tải dữ liệu thống kê: " + e.getMessage());
        }

        return "vendor/dashboard";
    }

    @GetMapping("/shop/edit")
    public String showUpdateShopForm(Model model, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }
        if (currentUser.getShop() == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn chưa đăng ký shop.");
            return "redirect:/vendor/dashboard";
        }

        model.addAttribute("shop", currentUser.getShop());
        return "vendor/edit-shop";
    }

    @PostMapping("/shop/edit")
    public String updateShop(@ModelAttribute("shop") Shop shop, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser();
        if (currentUser == null || currentUser.getShop() == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Yêu cầu không hợp lệ.");
            return "redirect:/vendor/dashboard";
        }

        if (!Objects.equals(currentUser.getShop().getId(), shop.getId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền cập nhật shop này.");
            return "redirect:/vendor/dashboard";
        }

        try {
            shopService.updateShopInfo(shop.getId(), shop.getName(), shop.getDescription());
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin shop thành công!");

            // Làm mới thông tin người dùng trong phiên đăng nhập (SecurityContext)
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            if (principal instanceof CustomUserDetails) {
                User userInSession = ((CustomUserDetails) principal).getUser();
                Shop updatedShop = shopService.findById(shop.getId())
                        .orElseThrow(() -> new IllegalStateException("Không thể tải lại shop sau khi cập nhật."));
                userInSession.setShop(updatedShop);
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật shop: " + e.getMessage());
        }

        return "redirect:/vendor/dashboard";
    }


    @GetMapping("/orders")
    public String listOrders(Model model, @RequestParam(value = "status", required = false) String status) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        try {
            List<Order> orders = orderService.findOrdersForVendor(currentUser);
            if (orders != null && status != null && !status.isBlank() && !"ALL".equalsIgnoreCase(status)) {
                final String viLabel = mapStatusCodeToLabel(status);
                if (viLabel != null) {
                    orders = orders.stream()
                            .filter(o -> viLabel.equalsIgnoreCase(Objects.toString(o.getStatus(), "")))
                            .collect(Collectors.toList());
                }
            }
            model.addAttribute("orders", orders);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Không thể tải danh sách đơn hàng: " + e.getMessage());
        }

        return "vendor/vendor-orders";
    }

    @PostMapping("/orders/confirm")
    public String confirmOrder(@RequestParam("orderId") Integer orderId, RedirectAttributes ra) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        try {
            orderService.confirmOrderAndSeekShipper(orderId, currentUser);
            ra.addFlashAttribute("successMessage", "Đã xác nhận đơn hàng #" + orderId + " và đang tìm shipper.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi xác nhận đơn hàng: " + e.getMessage());
        }

        return "redirect:/vendor/orders";
    }

    @PostMapping("/orders/cancel")
    public String cancelOrder(@RequestParam("orderId") Integer orderId, RedirectAttributes ra) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        try {
            orderService.cancelOrderAsVendor(orderId, currentUser);
            ra.addFlashAttribute("successMessage", "Đã hủy đơn hàng #" + orderId + " thành công.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi hủy đơn hàng: " + e.getMessage());
        }

        return "redirect:/vendor/orders";
    }

    @PostMapping("/orders/update-status")
    public String updateOrderStatus(@RequestParam("orderId") Integer orderId,
                                    @RequestParam("status") String status,
                                    @RequestParam(value = "currentStatus", required = false) String currentStatus,
                                    RedirectAttributes ra) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";
        try {
            String viLabel = mapStatusCodeToLabel(status);
            if (viLabel == null) {
                ra.addFlashAttribute("errorMessage", "Trạng thái không hợp lệ.");
            }
            else {
                orderService.updateOrderStatus(orderId, viLabel, currentUser);
                ra.addFlashAttribute("successMessage", "Đã cập nhật trạng thái đơn #" + orderId + " thành: " + viLabel + ".");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
        }
        String redirect = "redirect:/vendor/orders";
        if (currentStatus != null && !currentStatus.isBlank()) {
            redirect += "?status=" + currentStatus;
        }
        return redirect;
    }

    @GetMapping("/commissions")
    public String viewCommissions(Model model) {
        User currentUser = getCurrentUser();
        if (currentUser == null) return "redirect:/login";

        try {
            if (currentUser.getShop() == null) {
                model.addAttribute("errorMessage", "Bạn chưa có shop!");
                return "vendor/commissions";
            }

            List<ShopCommissionDTO> commissions = commissionService.getCommissionsByShop(currentUser.getShop().getId());
            ShopCommissionDTO currentMonthCommission = commissionService.getCurrentMonthCommission(currentUser.getShop().getId());

            model.addAttribute("commissions", commissions);
            model.addAttribute("currentMonthCommission", currentMonthCommission);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Không thể tải dữ liệu chiết khấu: " + e.getMessage());
        }

        return "vendor/commissions";
    }

    private String mapStatusCodeToLabel(String code) {
        if (code == null) return null;
        switch (code) {
            case "NEW": return "Đơn hàng mới";
            case "PENDING_CONFIRMATION": return "Chờ xác nhận";
            case "READY_FOR_PICKUP": return "Chờ lấy hàng";
            case "DELIVERING": return "Đang giao";
            case "DELIVERED_SUCCESSFULLY": return "Giao thành công";
            case "DELIVERY_FAILED": return "Giao thất bại";
            case "CANCELLED": return "Đã hủy";
            default: return null;
        }
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication.getPrincipal().equals("anonymousUser")) {
            return null;
        }

        // Lấy User từ CustomUserDetails
        Object principal = authentication.getPrincipal();
        if (principal instanceof CustomUserDetails) {
            return ((CustomUserDetails) principal).getUser();
        }

        // Fallback: tìm user theo username nếu không phải CustomUserDetails
        return userService.findByUsername(authentication.getName()).orElse(null);
    }
}
