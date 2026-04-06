package com.starshop.controller;

import com.starshop.entity.Product;
import com.starshop.entity.Review;
import com.starshop.entity.User;
import com.starshop.service.ProductService;
import com.starshop.service.ReviewService;
import com.starshop.service.UserService;
import com.starshop.service.ViewedProductService;
import com.starshop.service.WishlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.*;

@Controller
public class HomeController {

    private final ProductService productService;
    private final ReviewService reviewService;
    private final WishlistService wishlistService;
    private final UserService userService;
    private final ViewedProductService viewedProductService;

    @Autowired
    public HomeController(ProductService productService, ReviewService reviewService, WishlistService wishlistService, UserService userService, ViewedProductService viewedProductService) {
        this.productService = productService;
        this.reviewService = reviewService;
        this.wishlistService = wishlistService;
        this.userService = userService;
        this.viewedProductService = viewedProductService;
    }

    @GetMapping({"/", "/home"})
    public String homePage(Model model) {
        List<Product> featuredProducts = productService.findTop8BestSellingProducts();
        // Shuffle to randomize order
        List<Product> shuffled = new ArrayList<>(featuredProducts);
        Collections.shuffle(shuffled);

        // Split into two unique rows without overlap
        int total = shuffled.size();
        int firstRowCount = Math.min(4, total);
        int secondRowCount = Math.min(4, Math.max(0, total - firstRowCount));

        List<Product> row1Products = shuffled.subList(0, firstRowCount);
        List<Product> row2Products = shuffled.subList(firstRowCount, firstRowCount + secondRowCount);

        model.addAttribute("row1Products", row1Products);
        model.addAttribute("row2Products", row2Products);
        return "home/home";
    }

    @GetMapping("/product/{id}")
    public String productDetail(@PathVariable("id") Integer id, Model model, Authentication authentication) {
        Optional<Product> productOptional = productService.findById(id);

        if (productOptional.isPresent()) {
            Product product = productOptional.get();
            List<Review> reviews = reviewService.getReviewsByProductId(id);

            // Re-fetch to get the most up-to-date product data (e.g., review counts)
            // and assign to a final variable to be used in lambdas.
            final Product freshProduct = productService.findById(id).orElse(product);

            boolean isWishlisted = false;
            if (authentication != null && authentication.isAuthenticated()) {
                User currentUser = userService.findByUsername(authentication.getName()).orElse(null);
                if (currentUser != null) {
                    isWishlisted = wishlistService.isProductInWishlist(currentUser.getId(), id);
                    viewedProductService.addViewedProduct(currentUser, freshProduct);
                }
            }

            // Fetch, shuffle, and select related products
            List<Product> potentialRelated = productService.findTop8BestSellingProducts();
            List<Product> relatedProducts = new ArrayList<>(potentialRelated);
            // Exclude the current product from the related list
            relatedProducts.removeIf(p -> p.getId().equals(freshProduct.getId()));
            Collections.shuffle(relatedProducts);
            int count = Math.min(4, relatedProducts.size());
            List<Product> finalRelatedProducts = relatedProducts.subList(0, count);

            model.addAttribute("product", freshProduct);
            model.addAttribute("reviews", reviews);
            model.addAttribute("isWishlisted", isWishlisted);
            model.addAttribute("relatedProducts", finalRelatedProducts);

            return "product/product-detail";
        } else {
            return "redirect:/home";
        }
    }

    @GetMapping("/test-jwt")
    public String testJwt() {
        return "test-jwt";
    }
}
