package com.starshop.controller;

import com.starshop.entity.Product;
import com.starshop.entity.Review;
import com.starshop.entity.User;
import com.starshop.service.ProductService;
import com.starshop.service.ReviewService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @GetMapping("/add/{productId}")
    public String showReviewForm(@PathVariable("productId") Integer productId, Model model, Authentication authentication, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser(authentication);
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (!reviewService.canUserReviewProduct(currentUser.getId(), productId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn không đủ điều kiện để đánh giá sản phẩm này.");
            return "redirect:/order/orders"; // Đã sửa từ "redirect:/orders" thành "redirect:/order/orders"
        }

        if (reviewService.hasUserReviewedProduct(currentUser.getId(), productId)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn đã đánh giá sản phẩm này rồi.");
            return "redirect:/order/orders"; // Đã sửa từ "redirect:/orders" thành "redirect:/order/orders"
        }

        Product product = productService.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại."));

        Review review = new Review();
        review.setProduct(product);

        model.addAttribute("review", review);
        model.addAttribute("product", product);
        return "review/review-form";
    }

    @PostMapping("/save")
    public String saveReview(@ModelAttribute("review") Review review, BindingResult bindingResult, Authentication authentication, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser(authentication);
        if (currentUser == null) {
            return "redirect:/login";
        }

        // Basic validation
        if (review.getRating() < 1 || review.getRating() > 5) {
            bindingResult.rejectValue("rating", "rating.invalid", "Vui lòng chọn từ 1 đến 5 sao.");
        }
        if (review.getComment() == null || review.getComment().trim().length() < 50) {
            bindingResult.rejectValue("comment", "comment.short", "Bình luận phải có ít nhất 50 ký tự.");
        }

        if (bindingResult.hasErrors()) {
            // Repopulate product to show the form again
            Product product = productService.findById(review.getProduct().getId()).orElse(null);
            // model.addAttribute("product", product); // This won't work on redirect
            // For simplicity, we redirect with an error. A better approach might be to not redirect.
            redirectAttributes.addFlashAttribute("errorMessage", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.");
            return "redirect:/review/add/" + review.getProduct().getId();
        }

        try {
            reviewService.saveReview(review, currentUser);
            redirectAttributes.addFlashAttribute("successMessage", "Cảm ơn bạn đã gửi đánh giá!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
        }

        return "redirect:/product/" + review.getProduct().getId();
    }

    private User getCurrentUser(Authentication authentication) {
        if (authentication == null) return null;
        String username = authentication.getName();
        return userService.findByUsername(username).orElse(null);
    }
}
