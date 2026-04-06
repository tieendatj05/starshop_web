package com.starshop.config;

import com.starshop.entity.User;
import com.starshop.repository.UserRepository;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.HashSet;
import java.util.Set;

// Đã xóa @Component hoặc @Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository; // Sử dụng final và constructor injection

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("Người dùng không tồn tại: " + username));

        // Kiểm tra trạng thái hoạt động của người dùng
        if (!user.isActive()) {
            throw new DisabledException("Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
        }

        Set<GrantedAuthority> authorities = new HashSet<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_" + user.getRole().getName()));

        return new CustomUserDetails(user, authorities);
    }
}
