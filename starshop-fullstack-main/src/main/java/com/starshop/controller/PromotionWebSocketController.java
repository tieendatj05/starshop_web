package com.starshop.controller;

import com.starshop.entity.User;
import com.starshop.service.PromotionService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
public class PromotionWebSocketController {

    @Autowired
    private PromotionService promotionService;

    @Autowired
    private UserService userService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/promotion/save")
    public void savePromotion(@Payload Map<String, Object> payload, Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            sendErrorMessage("guest", "Bạn cần đăng nhập để lưu mã khuyến mãi", null);
            return;
        }

        String username = authentication.getName();
        Integer promotionId = null;

        try {
            promotionId = (Integer) payload.get("promotionId");
            if (promotionId == null) {
                sendErrorMessage(username, "ID mã khuyến mãi không hợp lệ", null);
                return;
            }

            Optional<User> userOpt = userService.findByUsername(username);
            if (userOpt.isEmpty()) {
                sendErrorMessage(username, "Không tìm thấy thông tin người dùng", promotionId);
                return;
            }

            promotionService.savePromotionForUser(promotionId, userOpt.get());

            messagingTemplate.convertAndSendToUser(
                username,
                "/topic/promotion-updates",
                Map.of(
                    "message", "Đã lưu mã khuyến mãi thành công",
                    "success", true,
                    "promotionId", promotionId
                )
            );

        } catch (IllegalArgumentException | IllegalStateException e) {
            sendErrorMessage(username, e.getMessage(), promotionId);
        } catch (Exception e) {
            sendErrorMessage(username, "Có lỗi xảy ra khi lưu mã khuyến mãi", promotionId);
        }
    }

    private void sendErrorMessage(String username, String message, Integer promotionId) {
        Map<String, Object> response = new HashMap<>();
        response.put("message", message);
        response.put("success", false);
        if (promotionId != null) {
            response.put("promotionId", promotionId);
        }

        messagingTemplate.convertAndSendToUser(
            username,
            "/topic/promotion-updates",
            response
        );
    }
}
