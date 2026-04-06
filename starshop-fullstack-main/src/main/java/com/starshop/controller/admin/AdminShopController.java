package com.starshop.controller.admin;

import com.starshop.entity.Shop;
import com.starshop.service.ShopService;
import lombok.extern.slf4j.Slf4j;
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

@Slf4j
@Controller
@RequestMapping("/admin/shops")
public class AdminShopController {

    @Autowired
    private ShopService shopService;

    @GetMapping
    public String listShops(Model model, @RequestParam(value = "keyword", required = false) String keyword) {
        List<Shop> shops;
        if (keyword != null && !keyword.trim().isEmpty()) {
            shops = shopService.searchShops(keyword);
            model.addAttribute("keyword", keyword);
        } else {
            shops = shopService.getAllShops();
        }
        model.addAttribute("shops", shops);
        return "admin/shop/list";
    }

    @PostMapping("/approve/{id}")
    public String approveShop(@PathVariable("id") Integer id, RedirectAttributes ra) {
        try {
            shopService.approveShop(id);
            ra.addFlashAttribute("successMessage", "Đã duyệt shop #" + id + " thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi duyệt shop: " + e.getMessage());
        }
        return "redirect:/admin/shops";
    }

    @PostMapping("/reject/{id}")
    public String rejectShop(@PathVariable("id") Integer id, RedirectAttributes ra) {
        try {
            shopService.rejectShop(id);
            ra.addFlashAttribute("successMessage", "Đã từ chối shop #" + id + " thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi từ chối shop: " + e.getMessage());
        }
        return "redirect:/admin/shops";
    }

    @PostMapping("/lock/{id}")
    public String lockShop(@PathVariable("id") Integer id, RedirectAttributes ra) {
        try {
            shopService.lockShop(id);
            ra.addFlashAttribute("successMessage", "Đã khóa shop #" + id + " thành công! Chủ shop đã được chuyển về role USER.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi khóa shop: " + e.getMessage());
        }
        return "redirect:/admin/shops";
    }

    @PostMapping("/unlock/{id}")
    public String unlockShop(@PathVariable("id") Integer id, RedirectAttributes ra) {
        try {
            shopService.unlockShop(id);
            ra.addFlashAttribute("successMessage", "Đã mở khóa shop #" + id + " thành công! Chủ shop đã được khôi phục role VENDOR.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi mở khóa shop: " + e.getMessage());
        }
        return "redirect:/admin/shops";
    }

    @PostMapping("/hide-products/{id}")
    public String hideAllProductsInShop(@PathVariable("id") Integer id, RedirectAttributes ra) {
        try {
            shopService.hideAllProductsInShop(id);
            ra.addFlashAttribute("successMessage", "Đã ẩn tất cả sản phẩm của shop #" + id + " thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi ẩn sản phẩm: " + e.getMessage());
        }
        return "redirect:/admin/shops";
    }

    @PostMapping("/show-products/{id}")
    public String showAllProductsInShop(@PathVariable("id") Integer id, RedirectAttributes ra) {
        try {
            shopService.showAllProductsInShop(id);
            ra.addFlashAttribute("successMessage", "Đã hiện tất cả sản phẩm của shop #" + id + " thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi hiện sản phẩm: " + e.getMessage());
        }
        return "redirect:/admin/shops";
    }
}
