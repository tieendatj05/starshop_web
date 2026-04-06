package com.starshop.service;

import com.starshop.entity.User;
import com.starshop.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Set;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private static final Logger log = LoggerFactory.getLogger(CustomUserDetailsService.class);

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        log.info("---[BẮT ĐẦU XÁC THỰC]---");
        log.info("Đang tìm kiếm người dùng với username: '{}'", username);

        return userRepository.findByUsername(username)
                .map(user -> {
                    log.info(">>> ĐÃ TÌM THẤY người dùng: '{}'. Đang chuẩn bị thông tin xác thực.", user.getUsername());
                    log.info("    - ID: {}, Email: {}", user.getId(), user.getEmail());
                    // DEBUG: In ra chuỗi mật khẩu đã mã hóa được đọc từ DB
                    log.info("    - Password Hash từ DB: [{}]", user.getPassword());

                    Set<GrantedAuthority> authorities = Collections.singleton(
                            new SimpleGrantedAuthority("ROLE_" + user.getRole().getName())
                    );
                    log.info("    - Vai trò (Role): {}", user.getRole().getName());

                    return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), authorities);
                })
                .orElseThrow(() -> {
                    log.warn("!!! KHÔNG TÌM THẤY người dùng với username: '{}'. Quá trình xác thực thất bại.", username);
                    return new UsernameNotFoundException("Không tìm thấy người dùng với username: " + username);
                });
    }
}