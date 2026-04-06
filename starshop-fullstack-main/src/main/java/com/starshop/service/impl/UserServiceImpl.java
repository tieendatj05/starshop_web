package com.starshop.service.impl;

import com.starshop.entity.Appeal;
import com.starshop.entity.Product;
import com.starshop.entity.Role;
import com.starshop.entity.Shop;
import com.starshop.entity.User;
import com.starshop.repository.AppealRepository;
import com.starshop.repository.ProductRepository;
import com.starshop.repository.RoleRepository;
import com.starshop.repository.UserRepository;
import com.starshop.repository.ShopRepository;
import com.starshop.service.EmailService;
import com.starshop.service.ShopService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.Random;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private ShopService shopService;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private SessionRegistry sessionRegistry; // Inject SessionRegistry

    @Autowired
    private AppealRepository appealRepository; // Inject AppealRepository
    @Autowired
    private ProductRepository productRepository; // Inject ProductRepository

    @Autowired
    private EmailService emailService; // Inject EmailService

    @Override
    public void registerUser(User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Lỗi: Username đã tồn tại!");
        }

        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Lỗi: Email đã được sử dụng!");
        }

        user.setPassword(passwordEncoder.encode(user.getPassword()));

        Role userRole = roleRepository.findByName("USER")
                .orElseThrow(() -> new RuntimeException("Lỗi: Role 'USER' không tồn tại."));

        user.setRole(userRole);
        user.setActive(true);

        userRepository.save(user);
    }

    @Override
    public String registerUserWithOtp(User user) {
        // Kiểm tra username đã tồn tại
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Lỗi: Username đã tồn tại!");
        }

        // Kiểm tra email đã được sử dụng
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Lỗi: Email đã được sử dụng!");
        }

        // Mã hóa mật khẩu
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        // Gán role USER
        Role userRole = roleRepository.findByName("USER")
                .orElseThrow(() -> new RuntimeException("Lỗi: Role 'USER' không tồn tại."));
        user.setRole(userRole);

        // Tài khoản chưa được kích hoạt
        user.setActive(false);

        // Tạo mã OTP 6 số
        String otpCode = generateOtp();
        user.setOtpCode(otpCode);

        // Thiết lập thời gian hết hạn OTP (10 phút)
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MINUTE, 10);
        user.setOtpExpiry(calendar.getTime());

        // Lưu user vào database
        userRepository.save(user);

        // Gửi email OTP
        try {
            emailService.sendOtpEmail(user.getEmail(), otpCode, user.getFullName());
        } catch (Exception e) {
            // Nếu gửi email thất bại, xóa user vừa tạo
            userRepository.delete(user);
            throw new RuntimeException("Không thể gửi email OTP. Vui lòng thử lại sau!");
        }

        return user.getUsername();
    }

    @Override
    public boolean verifyOtpAndActivate(String username, String otpCode) {
        Optional<User> userOpt = userRepository.findByUsername(username);

        if (userOpt.isEmpty()) {
            return false;
        }

        User user = userOpt.get();

        // Kiểm tra tài khoản đã được kích hoạt chưa
        if (user.isActive()) {
            throw new RuntimeException("Tài khoản đã được kích hoạt trước đó!");
        }

        // Kiểm tra OTP
        if (user.getOtpCode() == null || !user.getOtpCode().equals(otpCode)) {
            return false;
        }

        // Kiểm tra OTP đã hết hạn chưa
        if (user.getOtpExpiry() == null || user.getOtpExpiry().before(new Date())) {
            throw new RuntimeException("Mã OTP đã hết hạn!");
        }

        // Kích hoạt tài khoản
        user.setActive(true);
        user.setOtpCode(null);
        user.setOtpExpiry(null);
        userRepository.save(user);

        // Gửi email chào mừng
        try {
            emailService.sendWelcomeEmail(user.getEmail(), user.getFullName());
        } catch (Exception e) {
            // Log error nhưng không throw exception
            System.err.println("Không thể gửi email chào mừng: " + e.getMessage());
        }

        return true;
    }

    @Override
    public boolean resendOtp(String username) {
        Optional<User> userOpt = userRepository.findByUsername(username);

        if (userOpt.isEmpty()) {
            return false;
        }

        User user = userOpt.get();

        // Kiểm tra tài khoản đã được kích hoạt chưa
        if (user.isActive()) {
            throw new RuntimeException("Tài khoản đã được kích hoạt!");
        }

        // Tạo mã OTP mới
        String otpCode = generateOtp();
        user.setOtpCode(otpCode);

        // Thiết lập thời gian hết hạn OTP mới (10 phút)
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MINUTE, 10);
        user.setOtpExpiry(calendar.getTime());

        userRepository.save(user);

        // Gửi email OTP mới
        try {
            emailService.sendOtpEmail(user.getEmail(), otpCode, user.getFullName());
            return true;
        } catch (Exception e) {
            throw new RuntimeException("Không thể gửi email OTP. Vui lòng thử lại sau!");
        }
    }

    /**
     * Tạo mã OTP ngẫu nhiên 6 chữ số.
     */
    private String generateOtp() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    @Override
    public String requestPasswordReset(String email) {
        // Tìm user theo email
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản với email này!"));

        // Kiểm tra tài khoản có được kích hoạt chưa
        if (!user.isActive()) {
            throw new RuntimeException("Tài khoản chưa được kích hoạt!");
        }

        // Tạo mã OTP mới
        String otpCode = generateOtp();
        user.setOtpCode(otpCode);

        // Thiết lập thời gian hết hạn OTP (10 phút)
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MINUTE, 10);
        user.setOtpExpiry(calendar.getTime());

        userRepository.save(user);

        // Gửi email OTP reset password
        try {
            emailService.sendPasswordResetOtpEmail(user.getEmail(), otpCode, user.getFullName());
        } catch (Exception e) {
            throw new RuntimeException("Không thể gửi email OTP. Vui lòng thử lại sau!");
        }

        return user.getUsername();
    }

    @Override
    public boolean verifyPasswordResetOtp(String username, String otpCode) {
        Optional<User> userOpt = userRepository.findByUsername(username);

        if (userOpt.isEmpty()) {
            return false;
        }

        User user = userOpt.get();

        // Kiểm tra OTP
        if (user.getOtpCode() == null || !user.getOtpCode().equals(otpCode)) {
            return false;
        }

        // Kiểm tra OTP đã hết hạn chưa
        if (user.getOtpExpiry() == null || user.getOtpExpiry().before(new Date())) {
            throw new RuntimeException("Mã OTP đã hết hạn!");
        }

        return true;
    }

    @Override
    public void resetPassword(String username, String newPassword) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng!"));

        // Kiểm tra OTP còn hợp lệ không (đảm bảo đã verify OTP trước)
        if (user.getOtpCode() == null) {
            throw new RuntimeException("Phiên đặt lại mật khẩu không hợp lệ!");
        }

        if (user.getOtpExpiry() == null || user.getOtpExpiry().before(new Date())) {
            throw new RuntimeException("Phiên đặt lại mật khẩu đã hết hạn!");
        }

        // Đặt mật khẩu mới
        user.setPassword(passwordEncoder.encode(newPassword));

        // Xóa OTP sau khi đặt lại mật khẩu thành công
        user.setOtpCode(null);
        user.setOtpExpiry(null);

        userRepository.save(user);
    }


    @Override
    @Transactional(readOnly = true)
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> findById(Integer id) {
        return userRepository.findById(id);
    }

    @Override
    public void updateUserProfile(User updatedData) {
        User existingUser = userRepository.findByUsername(updatedData.getUsername())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng để cập nhật!"));

        existingUser.setFullName(updatedData.getFullName());
        existingUser.setPhoneNumber(updatedData.getPhoneNumber());

        if (!existingUser.getEmail().equals(updatedData.getEmail())) {
            if (userRepository.existsByEmail(updatedData.getEmail())) {
                throw new RuntimeException("Lỗi: Email đã được sử dụng bởi một tài khoản khác!");
            }
            existingUser.setEmail(updatedData.getEmail());
        }

        userRepository.save(existingUser);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> findAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public void lockUser(Integer userId, RedirectAttributes ra) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại với ID: " + userId));
        user.setActive(false);
        userRepository.save(user);

        // Kiểm tra xem user có shop không (bất kể role gì)
        shopRepository.findByOwner(user).ifPresent(shop -> {
            // Nếu shop đang active (APPROVED), thì khóa nó tạm thời
            if (Shop.APPROVED.equals(shop.getStatus())) {
                shop.setStatus(Shop.LOCKED);
                shopRepository.save(shop);

                // Ẩn tất cả sản phẩm của shop
                List<Product> products = productRepository.findByShop(shop);
                for (Product product : products) {
                    if (product.isActive()) {
                        product.setActive(false);
                        productRepository.save(product);
                    }
                }

                ra.addFlashAttribute("reloginMessage", "Tài khoản của bạn đã bị vô hiệu hóa. Shop và tất cả sản phẩm của bạn đã bị ẩn tạm thời. Vui lòng đăng nhập lại.");
            } else {
                ra.addFlashAttribute("reloginMessage", "Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng đăng nhập lại.");
            }
        });

        // KHÔNG tự động hạ cấp role khi khóa tài khoản VENDOR
        // Role sẽ chỉ bị hạ cấp khi shop bị từ chối/khóa vĩnh viễn

        // Nếu user không có shop
        if (shopRepository.findByOwner(user).isEmpty()) {
            ra.addFlashAttribute("reloginMessage", "Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng đăng nhập lại để truy cập các tính năng của người dùng.");
        }

        // Vô hiệu hóa tất cả các phiên của người dùng này để buộc họ đăng nhập lại
        for (Object principal : sessionRegistry.getAllPrincipals()) {
            if (principal instanceof UserDetails) {
                UserDetails userDetails = (UserDetails) principal;
                if (userDetails.getUsername().equals(user.getUsername())) {
                    for (SessionInformation session : sessionRegistry.getAllSessions(userDetails, false)) {
                        session.expireNow();
                    }
                }
            }
        }
    }

    @Override
    public void unlockUser(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại với ID: " + userId));
        user.setActive(true);
        userRepository.save(user);

        // Kiểm tra xem user có shop bị khóa không và khôi phục nó
        shopRepository.findByOwner(user).ifPresent(shop -> {
            if (Shop.LOCKED.equals(shop.getStatus())) {
                // Khôi phục shop về trạng thái APPROVED
                shop.setStatus(Shop.APPROVED);
                shopRepository.save(shop);

                // Khôi phục tất cả sản phẩm của shop
                List<Product> products = productRepository.findByShop(shop);
                for (Product product : products) {
                    if (!product.isActive()) {
                        product.setActive(true);
                        productRepository.save(product);
                    }
                }
            }
        });
    }

    @Override
    public void submitAppeal(String username, String reason) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại: " + username));

        // Kiểm tra xem người dùng đã có kháng cáo PENDING chưa
        // (Tùy chọn: có thể cho phép nhiều kháng cáo hoặc chỉ 1 tại một thời điểm)
        // Hiện tại, chúng ta sẽ tạo một kháng cáo mới mỗi lần gửi.

        Appeal appeal = new Appeal();
        appeal.setUser(user);
        appeal.setReason(reason);
        appeal.setStatus(Appeal.PENDING);
        appeal.setSubmittedAt(LocalDateTime.now());

        appealRepository.save(appeal);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> searchUsers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return userRepository.findAll();
        } else {
            return userRepository.searchUsers(keyword);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Appeal> findAllPendingAppeals() {
        return appealRepository.findByStatus(Appeal.PENDING);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Appeal> findAppealById(Integer appealId) {
        return appealRepository.findById(appealId);
    }

    @Override
    public void approveAppeal(Integer appealId, User adminUser) {
        Appeal appeal = appealRepository.findById(appealId)
                .orElseThrow(() -> new IllegalArgumentException("Kháng cáo không tồn tại với ID: " + appealId));

        if (!Appeal.PENDING.equals(appeal.getStatus())) {
            throw new IllegalStateException("Chỉ có thể duyệt kháng cáo đang chờ xử lý.");
        }

        // Mở khóa tài khoản người dùng
        User userToUnlock = appeal.getUser();
        userToUnlock.setActive(true);
        userRepository.save(userToUnlock);

        // Kiểm tra xem user có shop bị khóa không và khôi phục nó
        shopRepository.findByOwner(userToUnlock).ifPresent(shop -> {
            if (Shop.LOCKED.equals(shop.getStatus())) {
                // Khôi phục shop về trạng thái APPROVED
                shop.setStatus(Shop.APPROVED);
                shopRepository.save(shop);

                // Khôi phục tất cả sản phẩm của shop
                List<Product> products = productRepository.findByShop(shop);
                for (Product product : products) {
                    if (!product.isActive()) {
                        product.setActive(true);
                        productRepository.save(product);
                    }
                }
            }
        });

        // Cập nhật trạng thái kháng cáo
        appeal.setStatus(Appeal.APPROVED);
        appeal.setAdmin(adminUser);
        appeal.setProcessedAt(LocalDateTime.now());
        appeal.setAdminNotes("Tài khoản đã được mở khóa theo yêu cầu kháng cáo. Shop và sản phẩm đã được khôi phục.");
        appealRepository.save(appeal);

        // Vô hiệu hóa tất cả các phiên của người dùng này để buộc họ đăng nhập lại
        for (Object principal : sessionRegistry.getAllPrincipals()) {
            if (principal instanceof UserDetails) {
                UserDetails userDetails = (UserDetails) principal;
                if (userDetails.getUsername().equals(userToUnlock.getUsername())) {
                    for (SessionInformation session : sessionRegistry.getAllSessions(userDetails, false)) {
                        session.expireNow();
                    }
                }
            }
        }
    }

    @Override
    public void rejectAppeal(Integer appealId, User adminUser, String adminNotes) {
        Appeal appeal = appealRepository.findById(appealId)
                .orElseThrow(() -> new IllegalArgumentException("Kháng cáo không tồn tại với ID: " + appealId));

        if (!Appeal.PENDING.equals(appeal.getStatus())) {
            throw new IllegalStateException("Chỉ có thể từ chối kháng cáo đang chờ xử lý.");
        }

        // Cập nhật trạng thái kháng cáo
        appeal.setStatus(Appeal.REJECTED);
        appeal.setAdmin(adminUser);
        appeal.setProcessedAt(LocalDateTime.now());
        appeal.setAdminNotes(adminNotes);
        appealRepository.save(appeal);

        // Không làm gì với tài khoản người dùng, giữ nguyên trạng thái khóa
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Appeal> findLatestAppealByUsername(String username) {
        return appealRepository.findTopByUserUsernameOrderBySubmittedAtDesc(username);
    }
}
