package com.starshop.controller.socket;

import com.starshop.dto.ChatMessage;
import com.starshop.service.ActiveUserTrackerService;
import com.starshop.service.ChatMessageService;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import java.security.Principal;

@Controller
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ActiveUserTrackerService activeUserTrackerService;
    private final ChatMessageService chatMessageService;

    public ChatController(SimpMessagingTemplate messagingTemplate, ActiveUserTrackerService activeUserTrackerService, ChatMessageService chatMessageService) {
        this.messagingTemplate = messagingTemplate;
        this.activeUserTrackerService = activeUserTrackerService;
        this.chatMessageService = chatMessageService;
    }

    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload ChatMessage chatMessage, Principal principal) {
        // Set the sender from the authenticated principal for security
        chatMessage.setSender(principal.getName());

        // Save the message to the database
        chatMessageService.saveMessage(chatMessage);

        if (chatMessage.getRecipient() != null && !chatMessage.getRecipient().isEmpty()) {
            // Private message
            messagingTemplate.convertAndSendToUser(chatMessage.getRecipient(), "/queue/private", chatMessage);
            // Also send to self for display
            messagingTemplate.convertAndSendToUser(principal.getName(), "/queue/private", chatMessage);
        } else {
            // Public message
            messagingTemplate.convertAndSend("/topic/public", chatMessage);
        }
    }

    @MessageMapping("/chat.addUser")
    public void addUser(SimpMessageHeaderAccessor headerAccessor, Principal principal) {
        // Get username from Principal (more secure)
        String username = principal.getName();
        String sessionId = headerAccessor.getSessionId();
        headerAccessor.getSessionAttributes().put("username", username);
        activeUserTrackerService.userJoined(sessionId, username);
    }
}
