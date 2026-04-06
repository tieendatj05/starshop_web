package com.starshop.config;

import com.starshop.entity.Category;
import com.starshop.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.ui.Model;
import java.util.List;

@ControllerAdvice
public class GlobalModelAttributes {
    @Autowired
    private CategoryService categoryService;

    @ModelAttribute
    public void addCategoriesToModel(Model model) {
        List<Category> allCategories = categoryService.findAll();
        model.addAttribute("allCategories", allCategories);
    }
}

