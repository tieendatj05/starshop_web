package com.starshop.controller;

import com.starshop.config.CustomUserDetails;
import com.starshop.config.JwtUtil;
import com.starshop.dto.JwtRequest;
import com.starshop.dto.JwtResponse;
import com.starshop.entity.User;
import com.starshop.repository.UserRepository;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
public class JwtAuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private UserRepository userRepository;

    /**
     * API đăng nhập và trả về JWT token
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody JwtRequest request, HttpServletResponse response) {
        String usernameOrEmail = request.getUsername();
        String username = usernameOrEmail;

        // Kiểm tra xem đầu vào là email hay username
        if (usernameOrEmail != null && usernameOrEmail.contains("@")) {
            Optional<User> userOptional = userRepository.findByEmail(usernameOrEmail);
            if (userOptional.isPresent()) {
                username = userOptional.get().getUsername();
            } else {
                // Nếu không tìm thấy user bằng email, coi như thông tin sai để tránh lộ thông tin
                return ResponseEntity.status(401).body("Tên đăng nhập hoặc mật khẩu không chính xác");
            }
        }

        try {
            // Xác thực bằng username đã được phân giải
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(username, request.getPassword())
            );
        } catch (DisabledException e) {
            return ResponseEntity.status(403).body("Tài khoản đã bị khóa");
        } catch (BadCredentialsException e) {
            return ResponseEntity.status(401).body("Tên đăng nhập hoặc mật khẩu không chính xác");
        }

        // Load user details bằng username đã được phân giải
        final UserDetails userDetails = userDetailsService.loadUserByUsername(username);
        final String token = jwtUtil.generateToken(userDetails);

        // Tạo cookie cho JWT (cho JSP sử dụng)
        Cookie jwtCookie = new Cookie("JWT-TOKEN", token);
        jwtCookie.setHttpOnly(true);
        jwtCookie.setSecure(false); // Set true nếu dùng HTTPS
        jwtCookie.setPath("/");
        jwtCookie.setMaxAge(24 * 60 * 60); // 24 hours
        response.addCookie(jwtCookie);

        // Tạo response
        JwtResponse jwtResponse = new JwtResponse();
        jwtResponse.setToken(token);

        if (userDetails instanceof CustomUserDetails) {
            CustomUserDetails customUserDetails = (CustomUserDetails) userDetails;
            jwtResponse.setUserId(customUserDetails.getId());
            jwtResponse.setUsername(customUserDetails.getUsername());
            jwtResponse.setEmail(customUserDetails.getEmail());
            jwtResponse.setRole(customUserDetails.getAuthorities().stream()
                    .findFirst()
                    .map(auth -> auth.getAuthority())
                    .orElse("ROLE_USER"));
        }

        return ResponseEntity.ok(jwtResponse);
    }

    /**
     * API đăng xuất - xóa JWT cookie
     */
    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpServletResponse response) {
        Cookie jwtCookie = new Cookie("JWT-TOKEN", null);
        jwtCookie.setHttpOnly(true);
        jwtCookie.setPath("/");
        jwtCookie.setMaxAge(0); // Xóa cookie
        response.addCookie(jwtCookie);

        return ResponseEntity.ok("Đăng xuất thành công");
    }

    /**
     * API kiểm tra token có hợp lệ không
     */
    @GetMapping("/validate")
    public ResponseEntity<?> validateToken(@RequestHeader("Authorization") String authHeader) {
        try {
            String token = authHeader.substring(7);
            String username = jwtUtil.extractUsername(token);
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);

            if (jwtUtil.validateToken(token, userDetails)) {
                return ResponseEntity.ok("Token hợp lệ");
            } else {
                return ResponseEntity.status(401).body("Token không hợp lệ");
            }
        } catch (Exception e) {
            return ResponseEntity.status(401).body("Token không hợp lệ: " + e.getMessage());
        }
    }

    /**
     * API kiểm tra JWT cookie có tồn tại không (cho test page)
     */
    @GetMapping("/check-cookie")
    public ResponseEntity<?> checkCookie(jakarta.servlet.http.HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("JWT-TOKEN".equals(cookie.getName())) {
                    try {
                        String token = cookie.getValue();
                        String username = jwtUtil.extractUsername(token);
                        Integer userId = jwtUtil.extractUserId(token);

                        java.util.Map<String, Object> result = new java.util.HashMap<>();
                        result.put("found", true);
                        result.put("token", token);
                        result.put("username", username);
                        result.put("userId", userId);
                        result.put("tokenLength", token.length());

                        return ResponseEntity.ok(result);
                    } catch (Exception e) {
                        java.util.Map<String, Object> result = new java.util.HashMap<>();
                        result.put("found", true);
                        result.put("valid", false);
                        result.put("error", e.getMessage());
                        return ResponseEntity.ok(result);
                    }
                }
            }
        }

        java.util.Map<String, Object> result = new java.util.HashMap<>();
        result.put("found", false);
        return ResponseEntity.ok(result);
    }

    /**
     * API refresh token (tạo token mới từ token cũ còn hạn)
     */
    @PostMapping("/refresh")
    public ResponseEntity<?> refreshToken(@RequestHeader("Authorization") String authHeader, HttpServletResponse response) {
        try {
            String oldToken = authHeader.substring(7);
            String username = jwtUtil.extractUsername(oldToken);
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);

            if (jwtUtil.validateToken(oldToken, userDetails)) {
                String newToken = jwtUtil.generateToken(userDetails);

                // Cập nhật cookie
                Cookie jwtCookie = new Cookie("JWT-TOKEN", newToken);
                jwtCookie.setHttpOnly(true);
                jwtCookie.setSecure(false);
                jwtCookie.setPath("/");
                jwtCookie.setMaxAge(24 * 60 * 60);
                response.addCookie(jwtCookie);

                JwtResponse jwtResponse = new JwtResponse();
                jwtResponse.setToken(newToken);

                if (userDetails instanceof CustomUserDetails) {
                    CustomUserDetails customUserDetails = (CustomUserDetails) userDetails;
                    jwtResponse.setUserId(customUserDetails.getId());
                    jwtResponse.setUsername(customUserDetails.getUsername());
                    jwtResponse.setEmail(customUserDetails.getEmail());
                    jwtResponse.setRole(customUserDetails.getAuthorities().stream()
                            .findFirst()
                            .map(auth -> auth.getAuthority())
                            .orElse("ROLE_USER"));
                }

                return ResponseEntity.ok(jwtResponse);
            } else {
                return ResponseEntity.status(401).body("Token không hợp lệ");
            }
        } catch (Exception e) {
            return ResponseEntity.status(401).body("Không thể refresh token: " + e.getMessage());
        }
    }
}
