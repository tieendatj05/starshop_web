package com.starshop.controller.admin;

import com.starshop.entity.Product;
import com.starshop.entity.ProductDiscount;
import com.starshop.service.ProductDiscountService;
import com.starshop.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/product-discount")
public class AdminProductDiscountController {

    @Autowired
    private ProductDiscountService productDiscountService;

    @Autowired
    private ProductService productService;

    // READ: Hiển thị danh sách giảm giá sản phẩm
    @GetMapping
    public String listDiscounts(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<ProductDiscount> discounts;
        if (keyword != null && !keyword.trim().isEmpty()) {
            discounts = productDiscountService.searchDiscounts(keyword);
            model.addAttribute("keyword", keyword);
        } else {
            discounts = productDiscountService.findAllDiscounts();
        }
        model.addAttribute("discounts", discounts);
        return "admin/product-discount/list";
    }

    // CREATE: Hiển thị form thêm mới
    @GetMapping("/add")
    public String showAddForm(Model model) {
        List<Product> products = productService.findAllProducts();
        model.addAttribute("discount", new ProductDiscount());
        model.addAttribute("products", products);
        model.addAttribute("pageTitle", "Thêm Giảm Giá Sản Phẩm");
        return "admin/product-discount/form";
    }

    // UPDATE: Hiển thị form chỉnh sửa
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, RedirectAttributes redirectAttributes) {
        try {
            ProductDiscount discount = productDiscountService.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy chương trình giảm giá với ID: " + id));
            List<Product> products = productService.findAllProducts();

            model.addAttribute("discount", discount);
            model.addAttribute("products", products);
            model.addAttribute("pageTitle", "Chỉnh Sửa Giảm Giá Sản Phẩm");
            return "admin/product-discount/form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy chương trình giảm giá!");
            return "redirect:/admin/product-discount";
        }
    }

    // Xử lý việc SAVE (cả create và update)
    @PostMapping("/save")
    public String saveDiscount(@ModelAttribute("discount") ProductDiscount discount,
                               @RequestParam("productId") Integer productId,
                               RedirectAttributes redirectAttributes) {
        try {
            productDiscountService.saveDiscountByAdmin(discount, productId);
            redirectAttributes.addFlashAttribute("successMessage", "Lưu chương trình giảm giá thành công!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra khi lưu chương trình giảm giá: " + e.getMessage());
        }
        return "redirect:/admin/product-discount";
    }

    // Xử lý việc DELETE
    @GetMapping("/delete/{id}")
    public String deleteDiscount(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            productDiscountService.deleteDiscountByAdmin(id);
            redirectAttributes.addFlashAttribute("successMessage", "Xóa chương trình giảm giá thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra khi xóa chương trình giảm giá: " + e.getMessage());
        }
        return "redirect:/admin/product-discount";
    }

    // Toggle trạng thái active/inactive
    @GetMapping("/toggle-status/{id}")
    public String toggleStatus(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            productDiscountService.toggleDiscountStatus(id);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        return "redirect:/admin/product-discount";
    }
}
