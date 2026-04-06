package com.starshop.service.impl;

import com.starshop.service.EmailService;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailServiceImpl implements EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    @Override
    public void sendOtpEmail(String toEmail, String otpCode, String fullName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Mã OTP Kích Hoạt Tài Khoản - StarShop");

            String htmlContent = buildOtpEmailContent(otpCode, fullName);
            helper.setText(htmlContent, true);

            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Không thể gửi email: " + e.getMessage());
        }
    }

    @Override
    public void sendWelcomeEmail(String toEmail, String fullName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Chào Mừng Đến Với StarShop!");

            String htmlContent = buildWelcomeEmailContent(fullName);
            helper.setText(htmlContent, true);

            mailSender.send(message);
        } catch (MessagingException e) {
            // Log error but don't throw exception for welcome email
            System.err.println("Không thể gửi email chào mừng: " + e.getMessage());
        }
    }

    private String buildOtpEmailContent(String otpCode, String fullName) {
        return "<!DOCTYPE html>" +
                "<html lang='vi'>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f9fa; margin: 0; padding: 20px; }" +
                ".container { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #FFC0CB 0%, #FF99AA 100%); padding: 30px; text-align: center; color: white; }" +
                ".header h1 { margin: 0; font-size: 28px; font-weight: 700; }" +
                ".content { padding: 40px 30px; }" +
                ".otp-box { background-color: #f8f9fa; border-left: 4px solid #FFC0CB; padding: 20px; margin: 25px 0; border-radius: 8px; }" +
                ".otp-code { font-size: 32px; font-weight: bold; color: #FF69B4; letter-spacing: 8px; text-align: center; margin: 15px 0; }" +
                ".footer { background-color: #f8f9fa; padding: 20px; text-align: center; color: #6c757d; font-size: 14px; }" +
                ".btn { display: inline-block; padding: 12px 30px; background: linear-gradient(135deg, #FFC0CB 0%, #FF99AA 100%); color: white; text-decoration: none; border-radius: 6px; font-weight: 600; margin: 20px 0; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🌸 StarShop 🌸</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<h2 style='color: #333;'>Xin chào " + (fullName != null ? fullName : "bạn") + "!</h2>" +
                "<p style='color: #555; font-size: 16px; line-height: 1.6;'>Cảm ơn bạn đã đăng ký tài khoản tại <strong>StarShop</strong>. Để hoàn tất quá trình đăng ký, vui lòng sử dụng mã OTP dưới đây:</p>" +
                "<div class='otp-box'>" +
                "<p style='margin: 0; color: #666; font-size: 14px;'>Mã OTP của bạn:</p>" +
                "<div class='otp-code'>" + otpCode + "</div>" +
                "<p style='margin: 0; color: #999; font-size: 13px; text-align: center;'>Mã có hiệu lực trong 10 phút</p>" +
                "</div>" +
                "<p style='color: #555; font-size: 14px;'><strong>Lưu ý:</strong> Vui lòng không chia sẻ mã OTP này với bất kỳ ai. Đội ngũ StarShop sẽ không bao giờ yêu cầu mã OTP của bạn qua điện thoại hoặc email.</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>Nếu bạn không thực hiện đăng ký này, vui lòng bỏ qua email này.</p>" +
                "<p style='margin: 5px 0;'>© 2025 StarShop - Shop Hoa Tươi</p>" +
                "<p style='margin: 5px 0;'>Email: support@starshop.com | Hotline: 1900-xxxx</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }

    private String buildWelcomeEmailContent(String fullName) {
        return "<!DOCTYPE html>" +
                "<html lang='vi'>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f9fa; margin: 0; padding: 20px; }" +
                ".container { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #FFC0CB 0%, #FF99AA 100%); padding: 40px; text-align: center; color: white; }" +
                ".header h1 { margin: 0; font-size: 32px; font-weight: 700; }" +
                ".content { padding: 40px 30px; }" +
                ".feature { margin: 20px 0; padding: 15px; background-color: #fff5f8; border-radius: 8px; }" +
                ".footer { background-color: #f8f9fa; padding: 20px; text-align: center; color: #6c757d; font-size: 14px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🎉 Chào Mừng Đến Với StarShop! 🎉</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<h2 style='color: #333;'>Xin chào " + (fullName != null ? fullName : "bạn") + "!</h2>" +
                "<p style='color: #555; font-size: 16px; line-height: 1.6;'>Tài khoản của bạn đã được kích hoạt thành công! Chúng tôi rất vui được chào đón bạn đến với cộng đồng StarShop.</p>" +
                "<div class='feature'>" +
                "<h3 style='color: #FF69B4; margin-top: 0;'>🌺 Những gì bạn có thể làm:</h3>" +
                "<ul style='color: #555; line-height: 1.8;'>" +
                "<li>Khám phá hàng ngàn loại hoa tươi đẹp</li>" +
                "<li>Đặt hàng nhanh chóng và tiện lợi</li>" +
                "<li>Theo dõi đơn hàng của bạn</li>" +
                "<li>Nhận ưu đãi và khuyến mãi độc quyền</li>" +
                "</ul>" +
                "</div>" +
                "<p style='color: #555; font-size: 16px;'>Bắt đầu mua sắm ngay hôm nay và trải nghiệm dịch vụ tốt nhất từ StarShop!</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p style='margin: 5px 0;'>© 2025 StarShop - Shop Hoa Tươi</p>" +
                "<p style='margin: 5px 0;'>Email: support@starshop.com | Hotline: 1900-xxxx</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }

    @Override
    public void sendPasswordResetOtpEmail(String toEmail, String otpCode, String fullName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Mã OTP Đặt Lại Mật Khẩu - StarShop");

            String htmlContent = buildPasswordResetOtpEmailContent(otpCode, fullName);
            helper.setText(htmlContent, true);

            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Không thể gửi email: " + e.getMessage());
        }
    }

    private String buildPasswordResetOtpEmailContent(String otpCode, String fullName) {
        return "<!DOCTYPE html>" +
                "<html lang='vi'>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f9fa; margin: 0; padding: 20px; }" +
                ".container { max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #FFC0CB 0%, #FF99AA 100%); padding: 30px; text-align: center; color: white; }" +
                ".header h1 { margin: 0; font-size: 28px; font-weight: 700; }" +
                ".content { padding: 40px 30px; }" +
                ".otp-box { background-color: #f8f9fa; border-left: 4px solid #FFC0CB; padding: 20px; margin: 25px 0; border-radius: 8px; }" +
                ".otp-code { font-size: 32px; font-weight: bold; color: #FF69B4; letter-spacing: 8px; text-align: center; margin: 15px 0; }" +
                ".warning-box { background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; border-radius: 8px; }" +
                ".footer { background-color: #f8f9fa; padding: 20px; text-align: center; color: #6c757d; font-size: 14px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🔐 Đặt Lại Mật Khẩu</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<h2 style='color: #333;'>Xin chào " + (fullName != null ? fullName : "bạn") + "!</h2>" +
                "<p style='color: #555; font-size: 16px; line-height: 1.6;'>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản <strong>StarShop</strong> của bạn. Sử dụng mã OTP dưới đây để xác nhận:</p>" +
                "<div class='otp-box'>" +
                "<p style='margin: 0; color: #666; font-size: 14px;'>Mã OTP của bạn:</p>" +
                "<div class='otp-code'>" + otpCode + "</div>" +
                "<p style='margin: 0; color: #999; font-size: 13px; text-align: center;'>Mã có hiệu lực trong 10 phút</p>" +
                "</div>" +
                "<div class='warning-box'>" +
                "<p style='margin: 0; color: #856404; font-size: 14px;'><strong>⚠️ Lưu ý bảo mật:</strong></p>" +
                "<p style='margin: 5px 0 0 0; color: #856404; font-size: 13px;'>Nếu bạn KHÔNG yêu cầu đặt lại mật khẩu, vui lòng BỎ QUA email này và kiểm tra bảo mật tài khoản của bạn.</p>" +
                "</div>" +
                "<p style='color: #555; font-size: 14px;'>Vui lòng không chia sẻ mã OTP này với bất kỳ ai. Đội ngũ StarShop sẽ không bao giờ yêu cầu mã OTP của bạn.</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>Email này được gửi tự động, vui lòng không trả lời.</p>" +
                "<p style='margin: 5px 0;'>© 2025 StarShop - Shop Hoa Tươi</p>" +
                "<p style='margin: 5px 0;'>Email: support@starshop.com | Hotline: 1900-xxxx</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
}

