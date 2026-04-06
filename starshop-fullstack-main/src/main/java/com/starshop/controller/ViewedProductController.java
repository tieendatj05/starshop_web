package com.starshop.controller;

import com.starshop.entity.User;
import com.starshop.entity.ViewedProduct;
import com.starshop.service.UserService;
import com.starshop.service.ViewedProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ViewedProductController {

    private final ViewedProductService viewedProductService;
    private final UserService userService;

    @Autowired
    public ViewedProductController(ViewedProductService viewedProductService, UserService userService) {
        this.viewedProductService = viewedProductService;
        this.userService = userService;
    }

    @GetMapping("/viewed-products")
    public String getViewedProducts(
            Model model,
            Authentication authentication,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "20") int size
    ) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }

        User currentUser = userService.findByUsername(authentication.getName())
                .orElseThrow(() -> new IllegalStateException("User not found."));

        Pageable pageable = PageRequest.of(page, size);
        Page<ViewedProduct> viewedProductPage = viewedProductService.findViewedProductsByUser(currentUser, pageable);

        model.addAttribute("viewedProductPage", viewedProductPage);
        model.addAttribute("pageTitle", "Sản phẩm đã xem");

        return "product/viewed-products";
    }
}
