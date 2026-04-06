package com.starshop.controller;

import com.starshop.dto.CartDTO;
import com.starshop.entity.User;
import com.starshop.service.CartService;
import com.starshop.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class CartController {

    private static final Logger log = LoggerFactory.getLogger(CartController.class);

    @Autowired
    private CartService cartService;

    @Autowired
    private UserService userService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @GetMapping("/cart")
    public String viewCart(Model model) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }
        CartDTO cartDTO = cartService.getCartForUser(currentUser);
        model.addAttribute("cart", cartDTO);
        return "cart/cart";
    }

    @PostMapping("/cart/add")
    public String addToCart(@RequestParam("productId") Integer productId,
                            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                            HttpServletRequest request,
                            RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }

        try {
            cartService.addProductToCart(currentUser, productId, quantity);
            redirectAttributes.addFlashAttribute("toastMessage", "Sản phẩm đã được thêm vào giỏ hàng!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("toastError", "Không thể thêm sản phẩm vào giỏ hàng: " + e.getMessage());
        }

        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/products");
    }

    @MessageMapping("/cart/add")
    public void addToCartWS(@Payload Map<String, Object> payload, Principal principal) {
        String message;
        boolean success = false;
        try {
            if (principal == null) {
                throw new IllegalStateException("Người dùng chưa được xác thực.");
            }

            log.info("Received WS /cart/add from principal={} payload={}", principal.getName(), payload);

            User currentUser = userService.findByUsername(principal.getName())
                    .orElseThrow(() -> new IllegalStateException("Không tìm thấy người dùng."));

            Integer productId = Integer.parseInt(payload.get("productId").toString());
            int quantity = Integer.parseInt(payload.get("quantity").toString());

            cartService.addProductToCart(currentUser, productId, quantity);
            message = "Sản phẩm đã được thêm vào giỏ hàng!";
            success = true;

            // Gửi lại trạng thái giỏ hàng đã cập nhật cho client để UI có thể đồng bộ chính xác
            CartDTO updatedCart = cartService.getCartForUser(currentUser);
            log.info("Cart updated for user={} items={} total={}", currentUser.getUsername(), updatedCart.getItems() != null ? updatedCart.getItems().size() : 0, updatedCart.getTotalAmount());
            messagingTemplate.convertAndSendToUser(principal.getName(), "/topic/cart-state", updatedCart);
        } catch (Exception e) {
            message = "Lỗi: " + e.getMessage();
            // Log exception for debugging
        }

        // Ngoài việc gửi cart-state, gửi một thông báo ngắn để hiển thị toast/confirm
        messagingTemplate.convertAndSendToUser(
                principal.getName(),
                "/topic/cart-updates",
                Map.of("message", message, "success", success)
        );
    }

    @MessageMapping("/cart/update")
    public void updateQuantityWS(@Payload Map<String, Object> payload, Principal principal) {
        try {
            if (principal == null) {
                throw new IllegalStateException("Người dùng chưa được xác thực.");
            }
            User currentUser = userService.findByUsername(principal.getName())
                    .orElseThrow(() -> new IllegalStateException("Không tìm thấy người dùng."));

            Integer productId = Integer.parseInt(payload.get("productId").toString());
            int quantity = Integer.parseInt(payload.get("quantity").toString());

            cartService.updateProductQuantity(currentUser, productId, quantity);
            CartDTO updatedCart = cartService.getCartForUser(currentUser);
            
            // Gửi lại toàn bộ giỏ hàng đã cập nhật cho người dùng
            messagingTemplate.convertAndSendToUser(principal.getName(), "/topic/cart-state", updatedCart);

        } catch (Exception e) {
            // Gửi thông báo lỗi nếu có
            messagingTemplate.convertAndSendToUser(
                principal.getName(),
                "/topic/cart-errors",
                Map.of("message", e.getMessage())
            );
        }
    }

    @PostMapping("/cart/remove")
    public String removeFromCart(@RequestParam("productId") Integer productId, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }
        try {
            cartService.removeProductFromCart(currentUser, productId);
            redirectAttributes.addFlashAttribute("toastMessage", "Sản phẩm đã được xóa khỏi giỏ hàng!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("toastError", "Không thể xóa sản phẩm khỏi giỏ hàng: " + e.getMessage());
            log.error("Error removing product from cart: {}", e.getMessage());
        }
        return "redirect:/cart";
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication.getPrincipal().equals("anonymousUser")) {
            return null;
        }
        String username = authentication.getName();
        return userService.findByUsername(username).orElse(null);
    }
}