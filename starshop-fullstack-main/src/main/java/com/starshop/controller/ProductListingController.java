package com.starshop.controller;

import com.starshop.entity.Category;
import com.starshop.entity.Product;
import com.starshop.entity.User;
import com.starshop.service.CategoryService;
import com.starshop.service.ProductService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
public class ProductListingController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private UserService userService;

    @ModelAttribute("allCategories")
    public List<Category> populateCategories() {
        return categoryService.findAllActiveCategories();
    }

    @GetMapping({"/products", "/products/category/{categorySlug}"})
    public String listProducts(
            Model model,
            @PathVariable(name = "categorySlug", required = false) String categorySlug,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "20") int size,
            @RequestParam(name = "sort", defaultValue = "newest") String sortBy,
            Authentication authentication
    ) {
        Sort sort = Sort.by(Sort.Direction.DESC, "createdAt"); // Default sort

        switch (sortBy) {
            case "newest":
                sort = Sort.by(Sort.Direction.DESC, "createdAt");
                break;
            case "bestselling":
                sort = Sort.by(Sort.Direction.DESC, "soldCount"); // Assuming a 'soldCount' field
                break;
            case "toprated":
                sort = Sort.by(Sort.Direction.DESC, "averageRating"); // Assuming an 'averageRating' field
                break;
            case "price_asc":
                sort = Sort.by(Sort.Direction.ASC, "price");
                break;
            case "price_desc":
                sort = Sort.by(Sort.Direction.DESC, "price");
                break;
            // 'wishlisted' is handled by a separate service method, so no direct sort needed here for Pageable
            default:
                sort = Sort.by(Sort.Direction.DESC, "createdAt");
                break;
        }

        Pageable pageable = PageRequest.of(page, size, sort);
        Page<Product> productPage;

        if ("wishlisted".equals(sortBy) && authentication != null && authentication.isAuthenticated()) {
            String username = authentication.getName();
            User currentUser = userService.findByUsername(username)
                    .orElseThrow(() -> new IllegalStateException("User not found."));
            // For wishlisted products, you might want a specific default sort or pass the constructed 'pageable'
            // If findWishlistedProducts has its own sorting logic, 'pageable' sort might be overridden.
            productPage = productService.findWishlistedProducts(currentUser, pageable);
            model.addAttribute("pageTitle", "Sản phẩm yêu thích".toUpperCase());
        } else {
            productPage = productService.findProducts(categorySlug, pageable); // Corrected call
            if (categorySlug != null && !categorySlug.isEmpty()) {
                Optional<Category> categoryOpt = categoryService.findAll().stream()
                        .filter(c -> c.getSlug().equals(categorySlug))
                        .findFirst();
                if (categoryOpt.isPresent()) {
                    String categoryName = categoryOpt.get().getName();
                    String sortTitle;
                    switch (sortBy) {
                        case "newest":
                            sortTitle = "Mới nhất";
                            break;
                        case "bestselling":
                            sortTitle = "Bán chạy";
                            break;
                        case "toprated":
                            sortTitle = "Đánh giá cao";
                            break;
                        case "price_asc":
                            sortTitle = "Giá tăng dần";
                            break;
                        case "price_desc":
                            sortTitle = "Giá giảm dần";
                            break;
                        default:
                            sortTitle = "Tất cả";
                            break;
                    }
                    String pageTitle = ("Sản phẩm: " + categoryName + " - " + sortTitle).toUpperCase();
                    model.addAttribute("pageTitle", pageTitle);
                } else {
                    model.addAttribute("pageTitle", "Tất cả sản phẩm".toUpperCase());
                }
            } else {
                String pageTitle;
                switch (sortBy) {
                    case "newest":
                        pageTitle = "Sản phẩm mới nhất";
                        break;
                    case "bestselling":
                        pageTitle = "Sản phẩm bán chạy";
                        break;
                    case "toprated":
                        pageTitle = "Sản phẩm đánh giá cao";
                        break;
                    case "price_asc":
                        pageTitle = "Sản phẩm giá tăng dần";
                        break;
                    case "price_desc":
                        pageTitle = "Sản phẩm giá giảm dần";
                        break;
                    default:
                        pageTitle = "Tất cả sản phẩm";
                        break;
                }
                model.addAttribute("pageTitle", pageTitle.toUpperCase());
            }
        }

        model.addAttribute("productPage", productPage);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("categorySlug", categorySlug);

        int totalPages = productPage.getTotalPages();
        if (totalPages > 0) {
            List<Integer> pageNumbers = IntStream.rangeClosed(1, totalPages)
                    .boxed()
                    .collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);
        }

        return "product/list";
    }
}
