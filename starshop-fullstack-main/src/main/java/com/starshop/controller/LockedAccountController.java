package com.starshop.controller;

import com.starshop.entity.User;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class LockedAccountController {

    @Autowired
    private UserService userService;

    @GetMapping("/locked-account")
    public String showLockedAccountPage(@RequestParam(value = "username", required = false) String username, Model model) {
        // Nếu username được truyền qua parameter (từ AuthenticationFailureHandler)
        if (username != null && !username.isEmpty()) {
            model.addAttribute("username", username);
        } else {
            // Thử lấy từ authentication context nếu có
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.isAuthenticated() && !authentication.getPrincipal().equals("anonymousUser")) {
                username = authentication.getName();
                model.addAttribute("username", username);
            }
        }

        // Lấy kháng cáo mới nhất của user để hiển thị trạng thái
        if (username != null && !username.isEmpty()) {
            userService.findLatestAppealByUsername(username).ifPresent(appeal -> {
                model.addAttribute("latestAppeal", appeal);
            });
        }

        return "locked-account";
    }

    @PostMapping("/locked-account/appeal")
    public String submitAppeal(@RequestParam("reason") String reason,
                                @RequestParam("username") String username,
                                RedirectAttributes ra) {
        // Kiểm tra username có được cung cấp không
        if (username == null || username.isEmpty()) {
            ra.addFlashAttribute("errorMessage", "Không thể xác định người dùng để gửi kháng cáo. Vui lòng thử lại.");
            return "redirect:/locked-account";
        }

        try {
            userService.submitAppeal(username, reason);
            ra.addFlashAttribute("successMessage", "Kháng cáo của bạn đã được gửi thành công. Chúng tôi sẽ xem xét sớm nhất có thể.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Có lỗi xảy ra khi gửi kháng cáo: " + e.getMessage());
        }
        return "redirect:/locked-account?username=" + username;
    }
}
