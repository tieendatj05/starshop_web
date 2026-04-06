package com.starshop.controller;

import com.starshop.dto.ChatParticipantDto;
import com.starshop.entity.User;
import com.starshop.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/search")
    public ResponseEntity<List<ChatParticipantDto>> searchUsers(@RequestParam("q") String query) {
        if (query == null || query.trim().isEmpty()) {
            return ResponseEntity.ok(List.of());
        }
        List<ChatParticipantDto> users = userRepository.searchUsers(query).stream()
                .map(user -> new ChatParticipantDto(user.getUsername(), determineDisplayName(user)))
                .collect(Collectors.toList());
        return ResponseEntity.ok(users);
    }

    private String determineDisplayName(User user) {
        if (user.getShop() != null && user.getShop().getName() != null && !user.getShop().getName().isEmpty()) {
            return user.getShop().getName();
        }
        if (user.getFullName() != null && !user.getFullName().isEmpty()) {
            return user.getFullName();
        }
        return user.getUsername();
    }
}
