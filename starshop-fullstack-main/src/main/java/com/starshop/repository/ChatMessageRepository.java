package com.starshop.repository;

import com.starshop.entity.ChatMessageEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Set;

public interface ChatMessageRepository extends JpaRepository<ChatMessageEntity, Long> {

    @Query("SELECT m FROM ChatMessageEntity m WHERE (m.sender = :user1 AND m.recipient = :user2) OR (m.sender = :user2 AND m.recipient = :user1) ORDER BY m.timestamp ASC")
    List<ChatMessageEntity> findChatHistory(@Param("user1") String user1, @Param("user2") String user2);

    // For public chat messages
    List<ChatMessageEntity> findByRecipientIsNullOrderByTimestampAsc();

    // NEW: Query to find distinct chat partners for a given user
    @Query("SELECT DISTINCT CASE WHEN m.sender = :currentUserUsername THEN m.recipient ELSE m.sender END FROM ChatMessageEntity m WHERE m.recipient IS NOT NULL AND (m.sender = :currentUserUsername OR m.recipient = :currentUserUsername)")
    Set<String> findDistinctChatPartners(@Param("currentUserUsername") String currentUserUsername);
}
