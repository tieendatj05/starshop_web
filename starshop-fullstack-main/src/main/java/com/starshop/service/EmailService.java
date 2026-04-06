package com.starshop.service;

public interface EmailService {
    /**
     * Gửi mã OTP qua email cho người dùng.
     * @param toEmail Email người nhận
     * @param otpCode Mã OTP
     * @param fullName Tên đầy đủ của người dùng
     */
    void sendOtpEmail(String toEmail, String otpCode, String fullName);

    /**
     * Gửi email chào mừng sau khi kích hoạt tài khoản thành công.
     * @param toEmail Email người nhận
     * @param fullName Tên đầy đủ của người dùng
     */
    void sendWelcomeEmail(String toEmail, String fullName);

    /**
     * Gửi mã OTP để đặt lại mật khẩu.
     * @param toEmail Email người nhận
     * @param otpCode Mã OTP
     * @param fullName Tên đầy đủ của người dùng
     */
    void sendPasswordResetOtpEmail(String toEmail, String otpCode, String fullName);
}
