package com.starshop.controller;

import com.starshop.entity.Shop;
import com.starshop.entity.User;
import com.starshop.entity.Product; // Import Product entity
import com.starshop.repository.ShopRepository;
import com.starshop.service.ShopService;
import com.starshop.service.UserService;
import com.starshop.service.ProductService; // Import ProductService
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable; // Import PathVariable
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List; // Import List
import java.util.Optional;

@Controller
@RequestMapping("/shop")
public class ShopController {

    @Autowired
    private ShopService shopService;

    @Autowired
    private UserService userService;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private ProductService productService; // Inject ProductService

    @GetMapping("/register")
    public String showRegisterForm(Model model, Authentication authentication, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        if (authentication == null || !authentication.isAuthenticated() || authentication.getPrincipal().equals("anonymousUser")) {
            return "shop/register-shop";
        }

        User currentUser = userService.findByUsername(authentication.getName()).orElse(null);
        if (currentUser != null) {
            model.addAttribute("currentUser", currentUser); // Add user to model

            Optional<Shop> shopOpt = shopRepository.findByOwner(currentUser);
            if (shopOpt.isPresent()) {
                Shop userShop = shopOpt.get();

                boolean isStillUser = authentication.getAuthorities().stream()
                                      .anyMatch(a -> a.getAuthority().equals("ROLE_USER"));

                if (Shop.APPROVED.equals(userShop.getStatus()) && isStillUser) {
                    try {
                        request.logout();
                    } catch (ServletException e) {
                        // Log error if needed
                    }
                    redirectAttributes.addFlashAttribute("reloginMessage", "Chúc mừng! Shop của bạn đã được duyệt. Vui lòng đăng nhập lại để truy cập các tính năng của người bán.");
                    return "redirect:/login";
                }

                model.addAttribute("userShop", userShop);
                if (Shop.PENDING.equals(userShop.getStatus())) {
                    model.addAttribute("errorMessage", "Yêu cầu của bạn đang được xử lý.");
                }
            }
        }
        return "shop/register-shop";
    }

    @PostMapping("/register")
    public String processRegistration(@RequestParam("name") String name,
                                      @RequestParam("description") String description,
                                      Authentication authentication,
                                      RedirectAttributes redirectAttributes) {
        try {
            User currentUser = userService.findByUsername(authentication.getName())
                    .orElseThrow(() -> new IllegalStateException("Không tìm thấy người dùng."));

            shopService.registerShop(name, description, currentUser);
            redirectAttributes.addFlashAttribute("successMessage", "Yêu cầu mở shop của bạn đã được gửi thành công! Vui lòng chờ Admin xét duyệt.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
        }
        return "redirect:/shop/register";
    }

    @GetMapping("/{shopId}")
    public String showShopDetail(@PathVariable("shopId") Long shopId, Model model) {
        // 1. Lấy thông tin Shop từ Service, sử dụng findByIdWithOwner để tải thông tin owner
        Optional<Shop> shopOpt = shopService.findByIdWithOwner(shopId.intValue());

        if (shopOpt.isEmpty()) {
            // Xử lý trường hợp không tìm thấy shop, ví dụ: chuyển hướng đến trang lỗi hoặc trang 404
            return "redirect:/error/404"; // Hoặc một trang lỗi tùy chỉnh
        }
        Shop shop = shopOpt.get();

        // 2. Lấy danh sách sản phẩm của Shop từ Service
        List<Product> shopProducts = productService.getProductsByShopId(shopId); // Giả sử ProductService có phương thức này

        // 3. Đưa dữ liệu vào Model để truyền sang JSP
        model.addAttribute("shop", shop);
        model.addAttribute("shopProducts", shopProducts);

        // 4. Trả về tên của view JSP (không cần .jsp)
        return "shop_detail"; // Tên file JSP là shop_detail.jsp
    }
}
