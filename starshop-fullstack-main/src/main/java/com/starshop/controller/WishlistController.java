package com.starshop.controller;

import com.starshop.entity.User;
import com.starshop.service.UserService;
import com.starshop.service.WishlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/wishlist")
public class WishlistController {

    @Autowired
    private WishlistService wishlistService;

    @Autowired
    private UserService userService;

    @PostMapping("/add/{productId}")
    public String addToWishlist(@PathVariable("productId") Integer productId,
                                Authentication authentication,
                                RedirectAttributes ra,
                                @RequestHeader(value = "Referer", required = false) final String referer) {
        if (authentication == null) {
            return "redirect:/login";
        }
        User currentUser = getCurrentUser(authentication);

        try {
            wishlistService.addToWishlist(currentUser.getId(), productId);
            ra.addFlashAttribute("successMessage", "Đã thêm sản phẩm vào danh sách yêu thích!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }

        return "redirect:" + (referer != null ? referer : "/product/" + productId);
    }

    @PostMapping("/remove/{productId}")
    public String removeFromWishlist(@PathVariable("productId") Integer productId,
                                     Authentication authentication,
                                     RedirectAttributes ra,
                                     @RequestHeader(value = "Referer", required = false) final String referer) {
        if (authentication == null) {
            return "redirect:/login";
        }
        User currentUser = getCurrentUser(authentication);

        try {
            wishlistService.removeFromWishlist(currentUser.getId(), productId);
            ra.addFlashAttribute("successMessage", "Đã xóa sản phẩm khỏi danh sách yêu thích.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }

        return "redirect:" + (referer != null ? referer : "/product/" + productId);
    }

    private User getCurrentUser(Authentication authentication) {
        String username = authentication.getName();
        return userService.findByUsername(username)
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy người dùng."));
    }
}
