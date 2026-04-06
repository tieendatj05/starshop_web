package com.starshop.controller.admin;

import com.starshop.entity.Appeal;
import com.starshop.entity.User;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/appeals")
public class AdminAppealController {

    @Autowired
    private UserService userService;

    @GetMapping
    public String listPendingAppeals(Model model) {
        List<Appeal> pendingAppeals = userService.findAllPendingAppeals();
        model.addAttribute("appeals", pendingAppeals);
        return "admin/appeal/list";
    }

    @GetMapping("/view/{id}")
    public String viewAppeal(@PathVariable("id") Integer id, Model model, RedirectAttributes ra) {
        Optional<Appeal> appealOpt = userService.findAppealById(id);
        if (appealOpt.isEmpty()) {
            ra.addFlashAttribute("errorMessage", "Không tìm thấy kháng cáo.");
            return "redirect:/admin/appeals";
        }
        model.addAttribute("appeal", appealOpt.get());
        return "admin/appeal/detail";
    }

    @PostMapping("/approve/{id}")
    public String approveAppeal(@PathVariable("id") Integer id, Authentication authentication, RedirectAttributes ra) {
        User adminUser = getCurrentAdminUser(authentication);
        try {
            userService.approveAppeal(id, adminUser);
            ra.addFlashAttribute("successMessage", "Đã duyệt kháng cáo và mở khóa tài khoản người dùng.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi duyệt kháng cáo: " + e.getMessage());
        }
        return "redirect:/admin/appeals";
    }

    @PostMapping("/reject/{id}")
    public String rejectAppeal(@PathVariable("id") Integer id,
                               @RequestParam("adminNotes") String adminNotes,
                               Authentication authentication,
                               RedirectAttributes ra) {
        User adminUser = getCurrentAdminUser(authentication);
        try {
            userService.rejectAppeal(id, adminUser, adminNotes);
            ra.addFlashAttribute("successMessage", "Đã từ chối kháng cáo.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi từ chối kháng cáo: " + e.getMessage());
        }
        return "redirect:/admin/appeals";
    }

    private User getCurrentAdminUser(Authentication authentication) {
        String username = authentication.getName();
        return userService.findByUsername(username)
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy người dùng admin."));
    }
}
