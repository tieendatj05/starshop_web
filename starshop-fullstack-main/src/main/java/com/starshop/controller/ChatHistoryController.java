package com.starshop.controller;

import com.starshop.dto.ChatMessage;
import com.starshop.dto.ChatParticipantDto; // Import ChatParticipantDto
import com.starshop.service.ChatMessageService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/chat")
public class ChatHistoryController {

    private final ChatMessageService chatMessageService;

    public ChatHistoryController(ChatMessageService chatMessageService) {
        this.chatMessageService = chatMessageService;
    }

    @GetMapping("/history/{recipient}")
    public ResponseEntity<List<ChatMessage>> getChatHistory(@PathVariable String recipient, Principal principal) {
        String currentUser = principal.getName();
        return ResponseEntity.ok(chatMessageService.getChatHistory(currentUser, recipient));
    }

    @GetMapping("/history/public")
    public ResponseEntity<List<ChatMessage>> getPublicChatHistory() {
        return ResponseEntity.ok(chatMessageService.getChatHistory(null, null));
    }

    // NEW: Endpoint to get recent chat partners
    @GetMapping("/partners")
    public ResponseEntity<List<ChatParticipantDto>> getRecentChatPartners(Principal principal) {
        if (principal == null) {
            return ResponseEntity.status(401).build(); // Unauthorized
        }
        String currentUser = principal.getName();
        List<ChatParticipantDto> partners = chatMessageService.getRecentChatPartners(currentUser);
        return ResponseEntity.ok(partners);
    }
}
