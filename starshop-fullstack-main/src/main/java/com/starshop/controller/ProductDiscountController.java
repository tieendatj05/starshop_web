package com.starshop.controller;

import com.starshop.entity.Product;
import com.starshop.entity.ProductDiscount;
import com.starshop.entity.User;
import com.starshop.service.ProductDiscountService;
import com.starshop.service.ProductService;
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
@RequestMapping("/vendor/discounts")
public class ProductDiscountController {

    @Autowired
    private ProductDiscountService discountService;

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String listDiscounts(Model model, Authentication authentication) {
        User vendor = getCurrentUser(authentication);
        List<ProductDiscount> discounts = discountService.getDiscountsByVendor(vendor);
        model.addAttribute("discounts", discounts);
        return "vendor/discount/list";
    }

    @GetMapping("/add")
    public String showAddForm(Model model, Authentication authentication) {
        User vendor = getCurrentUser(authentication);
        List<Product> vendorProducts = productService.findByVendor(vendor);
        model.addAttribute("discount", new ProductDiscount());
        model.addAttribute("vendorProducts", vendorProducts);
        model.addAttribute("pageTitle", "Tạo Chương Trình Giảm Giá Mới");
        return "vendor/discount/form";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, Authentication authentication, RedirectAttributes ra) {
        User vendor = getCurrentUser(authentication);
        Optional<ProductDiscount> discountOpt = discountService.findByIdAndVendor(id, vendor);
        if (discountOpt.isEmpty()) {
            ra.addFlashAttribute("errorMessage", "Không tìm thấy chương trình giảm giá.");
            return "redirect:/vendor/discounts";
        }
        List<Product> vendorProducts = productService.findByVendor(vendor);
        model.addAttribute("discount", discountOpt.get());
        model.addAttribute("vendorProducts", vendorProducts);
        model.addAttribute("pageTitle", "Chỉnh Sửa Chương Trình Giảm Giá");
        return "vendor/discount/form";
    }

    @PostMapping("/save")
    public String saveDiscount(@ModelAttribute("discount") ProductDiscount discountFromForm,
                               @RequestParam("productId") Integer productId,
                               Authentication authentication,
                               RedirectAttributes ra) {
        User vendor = getCurrentUser(authentication);
        try {
            // 1. Fetch the Product entity using the provided productId
            Product product = productService.findById(productId)
                    .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại."));

            ProductDiscount discountToSave;

            if (discountFromForm.getId() != null) {
                // This is an update. Fetch the existing discount from the DB.
                Optional<ProductDiscount> existingDiscountOpt = discountService.findByIdAndVendor(discountFromForm.getId(), vendor);
                if (existingDiscountOpt.isEmpty()) {
                    ra.addFlashAttribute("errorMessage", "Chương trình giảm giá không tồn tại hoặc bạn không có quyền chỉnh sửa.");
                    return "redirect:/vendor/discounts";
                }
                discountToSave = existingDiscountOpt.get();
                // Update fields from the form to the managed entity
                discountToSave.setDiscountPercentage(discountFromForm.getDiscountPercentage());
                discountToSave.setStartDate(discountFromForm.getStartDate());
                discountToSave.setEndDate(discountFromForm.getEndDate());
                discountToSave.setActive(discountFromForm.isActive());
            } else {
                // This is a new discount
                discountToSave = discountFromForm;
            }

            // 2. Set the fetched Product to the discount object (for both new and existing)
            discountToSave.setProduct(product);

            // 3. Save the discount object via service
            discountService.saveDiscount(discountToSave, productId, vendor); 
            ra.addFlashAttribute("successMessage", "Đã lưu chương trình giảm giá thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi lưu: " + e.getMessage());
        }
        return "redirect:/vendor/discounts";
    }

    @GetMapping("/delete/{id}")
    public String deleteDiscount(@PathVariable("id") Integer id, Authentication authentication, RedirectAttributes ra) {
        User vendor = getCurrentUser(authentication);
        try {
            discountService.deleteDiscount(id, vendor);
            ra.addFlashAttribute("successMessage", "Đã xóa chương trình giảm giá thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi xóa: " + e.getMessage());
        }
        return "redirect:/vendor/discounts";
    }

    private User getCurrentUser(Authentication authentication) {
        String username = authentication.getName();
        return userService.findByUsername(username).orElseThrow(() -> new IllegalStateException("Không tìm thấy người dùng."));
    }
}
