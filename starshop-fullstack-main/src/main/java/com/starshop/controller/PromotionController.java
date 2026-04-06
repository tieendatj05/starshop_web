package com.starshop.controller;

import com.starshop.dto.PromotionDTO;
import com.starshop.entity.Product;
import com.starshop.entity.Promotion;
import com.starshop.entity.User;
import com.starshop.service.PromotionService;
import com.starshop.service.ProductService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.IntStream;

@Controller
@RequestMapping("/promotions")
public class PromotionController {

    @Autowired
    private PromotionService promotionService;

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String listPromotions(Model model, Authentication authentication,
                               @RequestParam(defaultValue = "0") int page,
                               @RequestParam(defaultValue = "12") int size) {

        // Lấy danh sách khuyến mãi đang hoạt động
        List<PromotionDTO> activePromotions = promotionService.findAllActivePromotions();
        model.addAttribute("activePromotions", activePromotions);

        // Lấy danh sách khuyến mãi đã lưu của người dùng (nếu đã đăng nhập)
        if (authentication != null && authentication.isAuthenticated()) {
            Optional<User> userOpt = userService.findByUsername(authentication.getName());
            if (userOpt.isPresent()) {
                List<Promotion> userSavedPromotions = promotionService.findUserSavedPromotions(userOpt.get());
                model.addAttribute("userSavedPromotions", userSavedPromotions);
            }
        }

        // Lấy sản phẩm đang giảm giá (pagination) - SỬA ĐỔI: Sử dụng ProductService
        Pageable pageable = PageRequest.of(page, size);
        Page<Product> discountedProductsPage = productService.findDiscountedProducts(pageable);
        model.addAttribute("discountedProductsPage", discountedProductsPage);

        // Tạo số trang cho pagination
        if (discountedProductsPage.getTotalPages() > 0) {
            List<Integer> pageNumbers = IntStream.rangeClosed(1, discountedProductsPage.getTotalPages())
                    .boxed()
                    .toList();
            model.addAttribute("pageNumbers", pageNumbers);
        }

        model.addAttribute("pageTitle", "Khuyến Mãi");

        return "promotion/list";
    }

    @PostMapping("/save/{promotionId}")
    @ResponseBody
    public ResponseEntity<?> savePromotion(@PathVariable Integer promotionId, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body("Bạn cần đăng nhập để lưu mã khuyến mãi");
        }

        try {
            Optional<User> userOpt = userService.findByUsername(authentication.getName());
            if (userOpt.isEmpty()) {
                return ResponseEntity.status(401).body("Không tìm thấy thông tin người dùng");
            }

            promotionService.savePromotionForUser(promotionId, userOpt.get());
            return ResponseEntity.ok("Đã lưu mã khuyến mãi thành công");
        } catch (IllegalArgumentException | IllegalStateException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Có lỗi xảy ra khi lưu mã khuyến mãi");
        }
    }
}
