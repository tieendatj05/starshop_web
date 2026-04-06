package com.starshop.service;

import com.starshop.dto.ChatMessage;
import com.starshop.dto.ChatParticipantDto;
import com.starshop.entity.User;
import com.starshop.repository.UserRepository;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Service
public class ActiveUserTrackerService {

    private final SimpMessageSendingOperations messagingTemplate;
    private final UserRepository userRepository;
    private final ConcurrentHashMap<String, ChatParticipantDto> activeUsers = new ConcurrentHashMap<>(); // sessionId -> participant

    public ActiveUserTrackerService(SimpMessageSendingOperations messagingTemplate, UserRepository userRepository) {
        this.messagingTemplate = messagingTemplate;
        this.userRepository = userRepository;
    }

    public void userJoined(String sessionId, String username) {
        // Use findByUsernameWithShop to ensure shop information is loaded
        userRepository.findByUsernameWithShop(username).ifPresent(user -> {
            String displayName = determineDisplayName(user);
            ChatParticipantDto participant = new ChatParticipantDto(username, displayName);
            activeUsers.put(sessionId, participant);
            broadcastActiveUsers();

            ChatMessage chatMessage = new ChatMessage();
            chatMessage.setType(ChatMessage.MessageType.JOIN);
            chatMessage.setSender(username);
            // We can set the display name in the content for JOIN/LEAVE messages if we want
            // chatMessage.setContent(displayName + " đã tham gia!");
            messagingTemplate.convertAndSend("/topic/public", chatMessage);
        });
    }

    public void userLeft(String sessionId) {
        ChatParticipantDto participant = activeUsers.remove(sessionId);
        if (participant != null) {
            broadcastActiveUsers();
            ChatMessage chatMessage = new ChatMessage();
            chatMessage.setType(ChatMessage.MessageType.LEAVE);
            chatMessage.setSender(participant.getUsername());
            // chatMessage.setContent(participant.getDisplayName() + " đã rời đi.");
            messagingTemplate.convertAndSend("/topic/public", chatMessage);
        }
    }

    public Collection<ChatParticipantDto> getActiveUsers() {
        return activeUsers.values();
    }

    private void broadcastActiveUsers() {
        messagingTemplate.convertAndSend("/topic/activeUsers", getActiveUsers());
    }

    private String determineDisplayName(User user) {
        // Check if the user has a shop and if it's a VENDOR role (assuming VENDORs have shops)
        // This logic assumes user.getShop() will not be null if they are a VENDOR
        // and that the shop name is preferred for VENDORs.
        if (user.getShop() != null && user.getShop().getName() != null && !user.getShop().getName().isEmpty()) {
            // You might want to add a check for user role here if only VENDORs should show shop name
            // For example: if (user.getRole() != null && "VENDOR".equals(user.getRole().getName())) {
            //    return user.getShop().getName();
            // }
            return user.getShop().getName();
        }
        if (user.getFullName() != null && !user.getFullName().isEmpty()) {
            return user.getFullName();
        }
        return user.getUsername();
    }
}
