package com.starshop.controller;

import com.starshop.entity.User;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @GetMapping("/login")
    public String showLoginPage() {
        return "auth/login";
    }

    @GetMapping("/register")
    public String showRegisterPage(Model model) {
        model.addAttribute("user", new User());
        return "auth/register";
    }

    @PostMapping("/register")
    public String processRegistration(@ModelAttribute("user") User user, Model model, RedirectAttributes ra) {
        try {
            String username = userService.registerUserWithOtp(user);
            ra.addFlashAttribute("success", "Đăng ký thành công! Vui lòng kiểm tra email để lấy mã OTP.");
            ra.addFlashAttribute("email", user.getEmail());
            return "redirect:/verify-otp?username=" + username;
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("user", user);
            return "auth/register";
        }
    }

    @GetMapping("/verify-otp")
    public String showVerifyOtpPage(@RequestParam("username") String username, Model model) {
        model.addAttribute("username", username);
        return "auth/verify-otp";
    }

    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam("username") String username,
                           @RequestParam("otpCode") String otpCode,
                           Model model,
                           RedirectAttributes ra) {
        try {
            boolean verified = userService.verifyOtpAndActivate(username, otpCode);
            if (verified) {
                ra.addFlashAttribute("success", "Xác thực thành công! Vui lòng đăng nhập.");
                return "redirect:/login";
            } else {
                model.addAttribute("error", "Mã OTP không chính xác!");
                model.addAttribute("username", username);
                return "auth/verify-otp";
            }
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("username", username);
            return "auth/verify-otp";
        }
    }

    @PostMapping("/resend-otp")
    public String resendOtp(@RequestParam("username") String username,
                           Model model,
                           RedirectAttributes ra) {
        try {
            boolean sent = userService.resendOtp(username);
            if (sent) {
                ra.addFlashAttribute("success", "Đã gửi lại mã OTP mới. Vui lòng kiểm tra email!");
                return "redirect:/verify-otp?username=" + username;
            } else {
                model.addAttribute("error", "Không thể gửi lại OTP!");
                model.addAttribute("username", username);
                return "auth/verify-otp";
            }
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("username", username);
            return "auth/verify-otp";
        }
    }

    // ========== FORGOT PASSWORD ENDPOINTS ==========

    @GetMapping("/forgot-password")
    public String showForgotPasswordPage() {
        return "auth/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email,
                                        Model model,
                                        RedirectAttributes ra) {
        try {
            String username = userService.requestPasswordReset(email);
            ra.addFlashAttribute("success", "Mã OTP đã được gửi đến email của bạn!");
            return "redirect:/reset-password-verify?username=" + username;
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "auth/forgot-password";
        }
    }

    @GetMapping("/reset-password-verify")
    public String showResetPasswordVerifyPage(@RequestParam("username") String username, Model model) {
        model.addAttribute("username", username);
        return "auth/reset-password-verify";
    }

    @PostMapping("/reset-password-verify")
    public String verifyResetPasswordOtp(@RequestParam("username") String username,
                                         @RequestParam("otpCode") String otpCode,
                                         Model model,
                                         RedirectAttributes ra) {
        try {
            boolean verified = userService.verifyPasswordResetOtp(username, otpCode);
            if (verified) {
                // OTP hợp lệ, chuyển sang trang đặt mật khẩu mới
                ra.addFlashAttribute("username", username);
                return "redirect:/reset-password-new?username=" + username;
            } else {
                model.addAttribute("error", "Mã OTP không chính xác!");
                model.addAttribute("username", username);
                return "auth/reset-password-verify";
            }
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("username", username);
            return "auth/reset-password-verify";
        }
    }

    @GetMapping("/reset-password-new")
    public String showResetPasswordNewPage(@RequestParam("username") String username, Model model) {
        model.addAttribute("username", username);
        return "auth/reset-password-new";
    }

    @PostMapping("/reset-password-new")
    public String processResetPassword(@RequestParam("username") String username,
                                       @RequestParam("newPassword") String newPassword,
                                       @RequestParam("confirmPassword") String confirmPassword,
                                       Model model,
                                       RedirectAttributes ra) {
        try {
            // Kiểm tra mật khẩu khớp
            if (!newPassword.equals(confirmPassword)) {
                model.addAttribute("error", "Mật khẩu xác nhận không khớp!");
                model.addAttribute("username", username);
                return "auth/reset-password-new";
            }

            // Kiểm tra độ dài mật khẩu
            if (newPassword.length() < 6) {
                model.addAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
                model.addAttribute("username", username);
                return "auth/reset-password-new";
            }

            userService.resetPassword(username, newPassword);
            ra.addFlashAttribute("success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
            return "redirect:/login";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("username", username);
            return "auth/reset-password-new";
        }
    }

    @PostMapping("/resend-reset-otp")
    public String resendResetOtp(@RequestParam("email") String email,
                                 RedirectAttributes ra) {
        try {
            String username = userService.requestPasswordReset(email);
            ra.addFlashAttribute("success", "Đã gửi lại mã OTP mới. Vui lòng kiểm tra email!");
            return "redirect:/reset-password-verify?username=" + username;
        } catch (RuntimeException e) {
            ra.addFlashAttribute("error", e.getMessage());
            return "redirect:/forgot-password";
        }
    }
}