package com.starshop.controller.admin;

import com.starshop.entity.Product;
import com.starshop.service.ProductService;
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
@RequestMapping("/admin/products")
public class AdminProductController {

    @Autowired
    private ProductService productService;

    @GetMapping
    public String listProducts(Model model, @RequestParam(value = "keyword", required = false) String keyword) {
        List<Product> products;
        if (keyword != null && !keyword.trim().isEmpty()) {
            products = productService.searchProducts(keyword);
            model.addAttribute("keyword", keyword); // Giữ lại từ khóa trên form tìm kiếm
        } else {
            products = productService.findAllProducts();
        }
        model.addAttribute("products", products);
        return "admin/product/list"; // Trả về trang list.jsp trong thư mục admin/product
    }

    @PostMapping("/toggle-visibility/{id}")
    public String toggleProductVisibility(@PathVariable("id") Integer id, RedirectAttributes ra) {
        try {
            productService.toggleProductVisibility(id);
            ra.addFlashAttribute("successMessage", "Đã cập nhật trạng thái hiển thị của sản phẩm #" + id + " thành công.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái sản phẩm: " + e.getMessage());
        }
        return "redirect:/admin/products";
    }
}
