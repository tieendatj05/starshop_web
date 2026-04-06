package com.starshop.config;

import com.starshop.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.session.HttpSessionEventPublisher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private UserRepository userRepository; // Cần để tạo CustomUserDetailsService

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // Bean cho AuthenticationManager (cần cho JWT authentication)
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }

    // Định nghĩa CustomUserDetailsService như một Bean
    @Bean
    public UserDetailsService userDetailsService() {
        return new CustomUserDetailsService(userRepository);
    }

    // Tạo JwtAuthenticationFilter như một Bean để tránh circular dependency
    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter() {
        return new JwtAuthenticationFilter();
    }

    // Cấu hình AuthenticationProvider
    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService());
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    // Bean cho SessionRegistry để quản lý các phiên đăng nhập
    @Bean
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    // Bean để Spring Security lắng nghe các sự kiện session (cần cho SessionRegistry)
    @Bean
    public HttpSessionEventPublisher httpSessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Tạm thời vô hiệu hóa CSRF để test
                .authorizeHttpRequests(auth -> auth
                        //== JWT API ENDPOINTS - CHO PHÉP TRUY CẬP ==
                        .requestMatchers("/api/auth/**").permitAll()

                        //== CÁC KHU VỰC CẦN ĐĂNG NHẬP VÀ PHÂN QUYỀN ==
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/vendor/**").hasRole("VENDOR")
                        .requestMatchers("/shipper/**").hasRole("SHIPPER")
                        .requestMatchers("/profile/**", "/cart/**", "/checkout/**", "/orders/**", "/addresses/**").authenticated()
                        // Cho phép truy cập trang tài khoản bị khóa và endpoint gửi kháng cáo
                        .requestMatchers("/locked-account", "/locked-account/appeal").permitAll()
                        // Cho phép truy cập các trang xác thực OTP
                        .requestMatchers("/verify-otp", "/resend-otp").permitAll()
                        // Cho phép truy cập các trang reset password
                        .requestMatchers("/forgot-password", "/reset-password-verify", "/reset-password-new", "/resend-reset-otp").permitAll()

                        //== CÁC KHU VỰC CÔNG KHAI ==
                        .anyRequest().permitAll()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/perform_login")
                        .defaultSuccessUrl("/home", true)
                        .failureHandler(authenticationFailureHandler()) // Sử dụng custom failure handler
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/perform_logout") // Đổi URL để tránh xung đột với custom LogoutController
                        .logoutSuccessUrl("/login?logout=true")
                        .deleteCookies("JSESSIONID", "JWT-TOKEN") // Xóa cả 2 cookies
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .permitAll()
                )
                .exceptionHandling(e -> e
                        .accessDeniedPage("/access-denied")
                )
                .sessionManagement(session -> session
                        .maximumSessions(1) // Chỉ cho phép 1 phiên đăng nhập cho mỗi người dùng
                        .sessionRegistry(sessionRegistry())
                        .expiredUrl("/login?expired") // Chuyển hướng khi phiên hết hạn
                );

        // Thêm JWT Authentication Filter trước UsernamePasswordAuthenticationFilter
        http.addFilterBefore(jwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

        // Thêm AuthenticationProvider vào HttpSecurity
        http.authenticationProvider(authenticationProvider());

        return http.build();
    }

    @Bean
    public AuthenticationFailureHandler authenticationFailureHandler() {
        return (request, response, exception) -> {
            // Kiểm tra nguyên nhân gốc rễ của ngoại lệ
            Throwable rootCause = exception.getCause();
            // Sửa lỗi: Kiểm tra rootCause != null trước khi gọi getClass()
            if (rootCause != null && rootCause.getClass().isAssignableFrom(DisabledException.class)) {
                // Lấy username từ request để truyền qua parameter
                String username = request.getParameter("username");
                if (username != null && !username.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/locked-account?username=" + username);
                } else {
                    response.sendRedirect(request.getContextPath() + "/locked-account");
                }
            } else {
                new SimpleUrlAuthenticationFailureHandler("/login?error=true").onAuthenticationFailure(request, response, exception);
            }
        };
    }
}
