package com.starshop.controller;

import com.starshop.dto.ShipperStatsDTO;
import com.starshop.entity.Order;
import com.starshop.entity.User;
import com.starshop.service.OrderService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/shipper")
public class ShipperController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    // Trang dashboard thống kê
    @GetMapping("/dashboard")
    public String getDashboard(Model model, Authentication authentication) {
        User shipper = getCurrentShipper(authentication);
        ShipperStatsDTO stats = orderService.getShipperStats(shipper);
        model.addAttribute("stats", stats);
        return "shipper/dashboard";
    }

    @GetMapping("/orders")
    public String getAssignedOrders(Model model, Authentication authentication) {
        User shipper = getCurrentShipper(authentication);
        List<Order> assignedOrders = orderService.findOrdersForShipper(shipper);
        model.addAttribute("orders", assignedOrders);
        return "shipper/orders";
    }

    @GetMapping("/available-orders")
    public String getAvailableOrders(Model model) {
        List<Order> availableOrders = orderService.findAvailableOrders();
        model.addAttribute("orders", availableOrders);
        return "shipper/available_orders";
    }

    @PostMapping("/accept-order/{orderId}")
    public String acceptOrder(@PathVariable("orderId") Integer orderId, Authentication authentication, RedirectAttributes redirectAttributes) {
        User shipper = getCurrentShipper(authentication);
        boolean success = orderService.assignOrderToShipper(orderId, shipper);

        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "Bạn đã nhận đơn hàng #" + orderId + " thành công!");
            return "redirect:/shipper/orders";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể nhận đơn hàng này. Đơn hàng có thể đã được người khác nhận hoặc không còn hợp lệ.");
            return "redirect:/shipper/available-orders";
        }
    }

    @PostMapping("/orders/update-status")
    public String updateOrderStatusByShipper(@RequestParam("orderId") Integer orderId, 
                                           @RequestParam("status") String status, 
                                           Authentication authentication, 
                                           RedirectAttributes redirectAttributes) {
        User shipper = getCurrentShipper(authentication);
        try {
            orderService.updateOrderStatusByShipper(orderId, status, shipper);
            redirectAttributes.addFlashAttribute("successMessage", "Đã cập nhật trạng thái đơn hàng #" + orderId + " thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }
        return "redirect:/shipper/orders";
    }

    private User getCurrentShipper(Authentication authentication) {
        if (authentication == null) {
            throw new IllegalStateException("Yêu cầu đăng nhập để thực hiện thao tác này.");
        }
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        return userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy thông tin shipper."));
    }
}
