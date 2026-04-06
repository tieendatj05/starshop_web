package com.starshop.controller;

import com.starshop.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

@Controller
public class SearchWebSocketController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private SearchService searchService;

    @MessageMapping("/search.suggestions")
    public void getSearchSuggestions(Map<String, String> message, Principal principal, SimpMessageHeaderAccessor headerAccessor) {
        String query = message.get("query");
        List<Map<String, String>> suggestions = searchService.getSearchSuggestions(query);

        if (principal != null) {
            // Authenticated user: send to user-specific queue
            messagingTemplate.convertAndSendToUser(principal.getName(), "/queue/search.suggestions", suggestions);
        } else {
            // Unauthenticated user: send to session-specific queue
            String sessionId = headerAccessor.getSessionId();
            if (sessionId != null) {
                // Send to a topic that includes the session ID.
                messagingTemplate.convertAndSend("/topic/search.suggestions.reply-" + sessionId, suggestions);
            }
        }
    }

    @MessageMapping("/search.results")
    public void getSearchResults(Map<String, String> message, Principal principal, SimpMessageHeaderAccessor headerAccessor) {
        String query = message.get("query");

        List<Map<String, String>> products = searchService.searchProducts(query);
        List<Map<String, String>> shops = searchService.searchShops(query);
        List<Map<String, String>> discounts = searchService.searchPromotions(query);

        Map<String, Object> searchResults = Map.of(
                "products", products,
                "shops", shops,
                "discounts", discounts
        );

        if (principal != null) {
            // Authenticated user: send to user-specific queue
            messagingTemplate.convertAndSendToUser(principal.getName(), "/queue/search.results", searchResults);
        } else {
            // Unauthenticated user: send to session-specific queue
            String sessionId = headerAccessor.getSessionId();
            if (sessionId != null) {
                // Send to a topic that includes the session ID.
                messagingTemplate.convertAndSend("/topic/search.results.reply-" + sessionId, searchResults);
            }
        }
    }
}
