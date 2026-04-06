package com.starshop.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class LogoutController {

    /**
     * Custom logout handler để xóa cả JWT token và Spring Security session
     */
    @PostMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {

        // 1. Xóa JWT-TOKEN cookie
        Cookie jwtCookie = new Cookie("JWT-TOKEN", null);
        jwtCookie.setHttpOnly(true);
        jwtCookie.setSecure(false); // Set true nếu dùng HTTPS
        jwtCookie.setPath("/");
        jwtCookie.setMaxAge(0); // Xóa cookie
        response.addCookie(jwtCookie);

        // 2. Xóa Spring Security session
        if (authentication != null) {
            new SecurityContextLogoutHandler().logout(request, response, authentication);
        }

        // 3. Clear SecurityContext
        SecurityContextHolder.clearContext();

        // 4. Invalidate session
        if (request.getSession(false) != null) {
            request.getSession().invalidate();
        }

        // 5. Redirect đến trang login với thông báo logout thành công
        return "redirect:/login?logout=true";
    }
}

