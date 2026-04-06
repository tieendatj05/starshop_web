package com.starshop.controller.admin;

import com.starshop.entity.Promotion;
import com.starshop.entity.Shop;
import com.starshop.service.PromotionService;
import com.starshop.service.ShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/promotion")
public class AdminPromotionController {

    @Autowired
    private PromotionService promotionService;

    @Autowired
    private ShopService shopService;

    // READ: Hiển thị danh sách khuyến mãi
    @GetMapping
    public String listPromotions(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<Promotion> promotions;
        if (keyword != null && !keyword.trim().isEmpty()) {
            promotions = promotionService.searchPromotions(keyword);
            model.addAttribute("keyword", keyword);
        } else {
            promotions = promotionService.findAllPromotions();
        }
        model.addAttribute("promotions", promotions);
        return "admin/promotion/list";
    }

    // CREATE: Hiển thị form thêm mới
    @GetMapping("/add")
    public String showAddForm(Model model) {
        List<Shop> shops = shopService.getAllShops();
        model.addAttribute("promotion", new Promotion());
        model.addAttribute("shops", shops);
        model.addAttribute("pageTitle", "Thêm Mã Khuyến Mãi");
        return "admin/promotion/form";
    }

    // UPDATE: Hiển thị form chỉnh sửa
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Promotion promotion = promotionService.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy mã khuyến mãi với ID: " + id));
            List<Shop> shops = shopService.getAllShops();

            model.addAttribute("promotion", promotion);
            model.addAttribute("shops", shops);
            model.addAttribute("pageTitle", "Chỉnh Sửa Mã Khuyến Mãi");
            return "admin/promotion/form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy mã khuyến mãi!");
            return "redirect:/admin/promotion";
        }
    }

    // Xử lý việc SAVE (cả create và update)
    @PostMapping("/save")
    public String savePromotion(@ModelAttribute("promotion") Promotion promotion, RedirectAttributes redirectAttributes) {
        try {
            promotionService.savePromotionByAdmin(promotion);
            redirectAttributes.addFlashAttribute("successMessage", "Lưu mã khuyến mãi thành công!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra khi lưu mã khuyến mãi: " + e.getMessage());
        }
        return "redirect:/admin/promotion";
    }

    // Xử lý việc DELETE
    @GetMapping("/delete/{id}")
    public String deletePromotion(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            promotionService.deletePromotionByAdmin(id);
            redirectAttributes.addFlashAttribute("successMessage", "Xóa mã khuyến mãi thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra khi xóa mã khuyến mãi: " + e.getMessage());
        }
        return "redirect:/admin/promotion";
    }

    // Toggle trạng thái active/inactive
    @GetMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            promotionService.togglePromotionStatus(id);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        return "redirect:/admin/promotion";
    }
}
