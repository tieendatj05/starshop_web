package com.starshop.controller.admin;

import com.starshop.dto.AdminDashboardStatsDTO;
import com.starshop.entity.Order;
import com.starshop.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private OrderService orderService;

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        try {
            AdminDashboardStatsDTO stats = orderService.getAdminDashboardStats();
            model.addAttribute("stats", stats);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Không thể tải dữ liệu thống kê: " + e.getMessage());
        }
        return "admin/dashboard";
    }

    @GetMapping("/orders")
    public String listAllOrders(Model model) {
        try {
            List<Order> orders = orderService.findAllOrdersForAdmin();
            model.addAttribute("orders", orders);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Không thể tải danh sách đơn hàng: " + e.getMessage());
        }
        return "admin/orders/list";
    }
}
