package com.starshop.service;

import com.starshop.dto.ChatMessage;
import com.starshop.dto.ChatParticipantDto;
import com.starshop.entity.ChatMessageEntity;
import com.starshop.entity.User;
import com.starshop.repository.ChatMessageRepository;
import com.starshop.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ChatMessageService {

    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository; // Inject UserRepository

    public ChatMessageService(ChatMessageRepository chatMessageRepository, UserRepository userRepository) {
        this.chatMessageRepository = chatMessageRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public void saveMessage(ChatMessage chatMessage) {
        ChatMessageEntity entity = ChatMessageEntity.builder()
                .sender(chatMessage.getSender())
                .recipient(chatMessage.getRecipient())
                .content(chatMessage.getContent())
                .build();
        chatMessageRepository.save(entity);
    }

    @Transactional(readOnly = true)
    public List<ChatMessage> getChatHistory(String user1, String user2) {
        List<ChatMessageEntity> entities;
        if (user2 == null) { // Public chat history
            entities = chatMessageRepository.findByRecipientIsNullOrderByTimestampAsc();
        } else { // Private chat history
            entities = chatMessageRepository.findChatHistory(user1, user2);
        }

        return entities.stream()
                .map(entity -> new ChatMessage(ChatMessage.MessageType.CHAT, entity.getContent(), entity.getSender(), entity.getRecipient()))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ChatParticipantDto> getRecentChatPartners(String currentUserUsername) {
        // Get distinct partners from chat messages where currentUser is sender or recipient
        Set<String> partnerUsernames = chatMessageRepository.findDistinctChatPartners(currentUserUsername);

        return partnerUsernames.stream()
                .map(partnerUsername -> {
                    Optional<User> userOpt = userRepository.findByUsernameWithShop(partnerUsername); // Use findByUsernameWithShop
                    return userOpt.map(this::determineChatParticipantDto).orElse(null);
                })
                .filter(dto -> dto != null) // Filter out any nulls if user not found
                .collect(Collectors.toList());
    }

    // Helper method to determine display name, similar to ActiveUserTrackerService
    private ChatParticipantDto determineChatParticipantDto(User user) {
        String displayName;
        if (user.getShop() != null && user.getShop().getName() != null && !user.getShop().getName().isEmpty()) {
            displayName = user.getShop().getName();
        } else if (user.getFullName() != null && !user.getFullName().isEmpty()) {
            displayName = user.getFullName();
        } else {
            displayName = user.getUsername();
        }
        return new ChatParticipantDto(user.getUsername(), displayName);
    }
}
