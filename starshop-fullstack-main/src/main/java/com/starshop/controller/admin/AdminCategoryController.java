package com.starshop.controller.admin;

import com.starshop.entity.Category;
import com.starshop.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/category") // Tất cả URL trong class này sẽ bắt đầu bằng /admin/category
public class AdminCategoryController {

    @Autowired
    private CategoryService categoryService;

    // READ: Hiển thị danh sách
    @GetMapping
    public String listCategories(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            model.addAttribute("categories", categoryService.searchCategories(keyword));
            model.addAttribute("keyword", keyword);
        } else {
            model.addAttribute("categories", categoryService.findAll());
        }
        return "admin/category/list"; // Cập nhật đường dẫn view: trỏ tới file list.jsp trong thư mục admin/category
    }

    // CREATE: Hiển thị form thêm mới
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("category", new Category());
        model.addAttribute("pageTitle", "Thêm mới Danh mục");
        return "admin/category/form"; // Cập nhật đường dẫn view: trỏ tới file form.jsp trong thư mục admin/category
    }

    // UPDATE: Hiển thị form chỉnh sửa
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Category category = categoryService.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Invalid category Id:" + id));
            model.addAttribute("category", category);
            model.addAttribute("pageTitle", "Chỉnh sửa Danh mục");
            return "admin/category/form"; // Dùng chung file form.jsp, trỏ tới file form.jsp trong thư mục admin/category
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy danh mục!");
            return "redirect:/admin/category";
        }
    }

    // Xử lý việc SAVE (cả create và update)
    @PostMapping("/save")
    public String saveCategory(@ModelAttribute("category") Category category, RedirectAttributes redirectAttributes) {
        try {
            categoryService.save(category);
            redirectAttributes.addFlashAttribute("successMessage", "Lưu danh mục thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra khi lưu danh mục: " + e.getMessage());
        }
        return "redirect:/admin/category"; // Chuyển hướng về trang danh sách
    }

    // DELETE: Xử lý xóa với kiểm tra ràng buộc
    @GetMapping("/delete/{id}")
    public String deleteCategory(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            // Kiểm tra xem có thể xóa danh mục không
            if (!categoryService.canDeleteCategory(id)) {
                long productCount = categoryService.countProductsInCategory(id);
                redirectAttributes.addFlashAttribute("errorMessage",
                    "Không thể xóa danh mục này vì đang có " + productCount + " sản phẩm thuộc danh mục này. " +
                    "Vui lòng di chuyển hoặc xóa các sản phẩm trước khi xóa danh mục.");
                return "redirect:/admin/category";
            }

            categoryService.deleteById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Xóa danh mục thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra khi xóa danh mục: " + e.getMessage());
        }
        return "redirect:/admin/category"; // Chuyển hướng về trang danh sách
    }
}
