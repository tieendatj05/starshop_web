package com.starshop.controller.admin;

import com.starshop.entity.User;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public String listUsers(Model model, @RequestParam(value = "keyword", required = false) String keyword) {
        List<User> users;
        if (keyword != null && !keyword.trim().isEmpty()) {
            users = userService.searchUsers(keyword);
            model.addAttribute("keyword", keyword); // Giữ lại từ khóa trên form tìm kiếm
        } else {
            users = userService.findAllUsers();
        }
        model.addAttribute("users", users);
        return "admin/user/list";
    }

    @PostMapping("/toggle-status/{id}")
    public String toggleUserStatus(@PathVariable("id") Integer id, RedirectAttributes ra) {
        try {
            User user = userService.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại với ID: " + id));
            
            if (user.isActive()) {
                userService.lockUser(id, ra); // Đã thêm tham số ra
                ra.addFlashAttribute("successMessage", "Đã khóa tài khoản " + user.getUsername());
            } else {
                userService.unlockUser(id);
                ra.addFlashAttribute("successMessage", "Đã mở khóa tài khoản " + user.getUsername());
            }
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi thay đổi trạng thái: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }
}
