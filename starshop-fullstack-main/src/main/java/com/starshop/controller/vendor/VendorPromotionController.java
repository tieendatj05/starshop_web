package com.starshop.controller.vendor;

import com.starshop.entity.Promotion;
import com.starshop.entity.User;
import com.starshop.service.PromotionService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/vendor/promotions")
public class VendorPromotionController {

    @Autowired
    private PromotionService promotionService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String listPromotions(Model model, Authentication authentication) {
        User vendor = getCurrentUser(authentication);
        List<Promotion> promotions = promotionService.findPromotionsByVendor(vendor);
        model.addAttribute("promotions", promotions);
        return "vendor/promotion/list";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("promotion", new Promotion());
        model.addAttribute("pageTitle", "Tạo Khuyến Mãi Mới");
        return "vendor/promotion/form";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, Authentication authentication, RedirectAttributes redirectAttributes) {
        User vendor = getCurrentUser(authentication);
        return promotionService.findByIdAndVendor(id, vendor)
                .map(promotion -> {
                    model.addAttribute("promotion", promotion);
                    model.addAttribute("pageTitle", "Chỉnh Sửa Khuyến Mãi");
                    return "vendor/promotion/form";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy khuyến mãi hoặc bạn không có quyền truy cập.");
                    return "redirect:/vendor/promotions";
                });
    }

    @PostMapping("/save")
    public String savePromotion(@ModelAttribute("promotion") Promotion promotion, Authentication authentication, RedirectAttributes redirectAttributes) {
        User vendor = getCurrentUser(authentication);
        try {
            promotionService.savePromotion(promotion, vendor);
            redirectAttributes.addFlashAttribute("successMessage", "Đã lưu khuyến mãi thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi lưu khuyến mãi: " + e.getMessage());
        }
        return "redirect:/vendor/promotions";
    }

    @GetMapping("/delete/{id}")
    public String deletePromotion(@PathVariable("id") Integer id, Authentication authentication, RedirectAttributes redirectAttributes) {
        User vendor = getCurrentUser(authentication);
        try {
            promotionService.deletePromotion(id, vendor);
            redirectAttributes.addFlashAttribute("successMessage", "Đã xóa khuyến mãi thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa khuyến mãi: " + e.getMessage());
        }
        return "redirect:/vendor/promotions";
    }

    private User getCurrentUser(Authentication authentication) {
        return userService.findByUsername(authentication.getName())
                .orElseThrow(() -> new IllegalStateException("Không thể xác định người dùng hiện tại."));
    }
}
