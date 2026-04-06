package com.starshop.controller;

import com.starshop.entity.User;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ProfileController {

    @Autowired
    private UserService userService;

    @GetMapping("/profile")
    public String viewProfile(Model model) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", currentUser);
        return "user/profile"; // Sửa đường dẫn
    }

    @GetMapping("/profile/edit")
    public String showEditProfileForm(Model model) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", currentUser);
        return "user/edit-profile"; // Sửa đường dẫn
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute("user") User user, RedirectAttributes redirectAttributes) {
        try {
            userService.updateUserProfile(user);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin thành công!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/profile/edit"; // Quay lại trang edit nếu có lỗi
        }
        return "redirect:/profile";
    }

    /**
     * Phương thức tiện ích để lấy thông tin người dùng đang đăng nhập.
     */
    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication.getPrincipal().equals("anonymousUser")) {
            return null;
        }
        String username = authentication.getName();
        return userService.findByUsername(username).orElse(null);
    }
}
