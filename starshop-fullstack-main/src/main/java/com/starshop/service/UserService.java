package com.starshop.service;

import com.starshop.entity.Appeal;
import com.starshop.entity.User;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

public interface UserService {
    void registerUser(User user);

    /**
     * Đăng ký người dùng mới và gửi OTP qua email.
     * @param user Thông tin người dùng đăng ký
     * @return Username để chuyển sang trang xác thực OTP
     */
    String registerUserWithOtp(User user);

    /**
     * Xác thực mã OTP và kích hoạt tài khoản.
     * @param username Tên đăng nhập
     * @param otpCode Mã OTP
     * @return true nếu xác thực thành công, false nếu thất bại
     */
    boolean verifyOtpAndActivate(String username, String otpCode);

    /**
     * Gửi lại mã OTP mới cho người dùng.
     * @param username Tên đăng nhập
     * @return true nếu gửi thành công, false nếu thất bại
     */
    boolean resendOtp(String username);

    /**
     * Yêu cầu đặt lại mật khẩu - Gửi OTP qua email.
     * @param email Email của người dùng
     * @return Username nếu thành công
     */
    String requestPasswordReset(String email);

    /**
     * Xác thực OTP để đặt lại mật khẩu.
     * @param username Tên đăng nhập
     * @param otpCode Mã OTP
     * @return true nếu OTP hợp lệ, false nếu không
     */
    boolean verifyPasswordResetOtp(String username, String otpCode);

    /**
     * Đặt lại mật khẩu mới sau khi xác thực OTP.
     * @param username Tên đăng nhập
     * @param newPassword Mật khẩu mới
     */
    void resetPassword(String username, String newPassword);

    /**
     * Tìm kiếm người dùng dựa trên tên đăng nhập.
     * @param username Tên đăng nhập cần tìm.
     * @return Optional chứa người dùng nếu tìm thấy.
     */
    Optional<User> findByUsername(String username);

    /**
     * Tìm kiếm người dùng dựa trên ID.
     * @param id ID của người dùng cần tìm.
     * @return Optional chứa người dùng nếu tìm thấy.
     */
    Optional<User> findById(Integer id);

    /**
     * Cập nhật thông tin hồ sơ của người dùng.
     * @param updatedUser Đối tượng User chứa thông tin mới.
     */
    void updateUserProfile(User updatedUser);

    /**
     * Lấy tất cả người dùng trong hệ thống.
     * @return Danh sách tất cả người dùng.
     */
    List<User> findAllUsers();

    /**
     * Khóa tài khoản người dùng.
     * @param userId ID của người dùng cần khóa.
     * @param ra RedirectAttributes để thêm thông báo flash.
     */
    void lockUser(Integer userId, RedirectAttributes ra);

    /**
     * Mở khóa tài khoản người dùng.
     * @param userId ID của người dùng cần mở khóa.
     */
    void unlockUser(Integer userId);

    /**
     * Xử lý việc gửi kháng cáo từ người dùng bị khóa.
     * @param username Tên đăng nhập của người dùng kháng cáo.
     * @param reason Lý do kháng cáo.
     */
    void submitAppeal(String username, String reason);

    /**
     * Tìm kiếm người dùng theo từ khóa trong username, email hoặc full_name.
     * @param keyword Từ khóa tìm kiếm.
     * @return Danh sách người dùng phù hợp.
     */
    List<User> searchUsers(String keyword);

    /**
     * Lấy tất cả các kháng cáo đang chờ xử lý.
     * @return Danh sách các kháng cáo đang chờ xử lý.
     */
    List<Appeal> findAllPendingAppeals();

    /**
     * Tìm một kháng cáo theo ID.
     * @param appealId ID của kháng cáo.
     * @return Optional chứa kháng cáo nếu tìm thấy.
     */
    Optional<Appeal> findAppealById(Integer appealId);

    /**
     * Duyệt một kháng cáo, mở khóa tài khoản người dùng và cập nhật trạng thái kháng cáo.
     * @param appealId ID của kháng cáo cần duyệt.
     * @param adminUser Người dùng admin thực hiện duyệt.
     */
    void approveAppeal(Integer appealId, User adminUser);

    /**
     * Từ chối một kháng cáo và cập nhật trạng thái kháng cáo.
     * @param appealId ID của kháng cáo cần từ chối.
     * @param adminUser Người dùng admin thực hiện từ chối.
     * @param adminNotes Ghi chú của admin về lý do từ chối.
     */
    void rejectAppeal(Integer appealId, User adminUser, String adminNotes);

    /**
     * Tìm kháng cáo mới nhất của một người dùng.
     * @param username Tên đăng nhập của người dùng.
     * @return Optional chứa kháng cáo mới nhất nếu có.
     */
    Optional<Appeal> findLatestAppealByUsername(String username);
}
