package com.starshop.repository;

import com.starshop.entity.Appeal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AppealRepository extends JpaRepository<Appeal, Integer> {

    /**
     * Tìm tất cả các kháng cáo đang chờ xử lý.
     * @param status Trạng thái cần tìm (ví dụ: PENDING).
     * @return Danh sách các kháng cáo có trạng thái PENDING.
     */
    List<Appeal> findByStatus(String status);

    /**
     * Tìm một kháng cáo theo ID và tải eager thông tin người dùng gửi kháng cáo.
     * @param id ID của kháng cáo.
     * @return Optional chứa kháng cáo nếu tìm thấy.
     */
    // @Query("SELECT a FROM Appeal a JOIN FETCH a.user WHERE a.id = :id") // This query is not needed for findById, JpaRepository's findById is sufficient
    Optional<Appeal> findById(Integer id);

    /**
     * Đếm số lượng kháng cáo theo trạng thái.
     * @param status Trạng thái cần đếm (ví dụ: PENDING).
     * @return Số lượng kháng cáo có trạng thái tương ứng.
     */
    long countByStatus(String status);

    /**
     * Tìm kháng cáo mới nhất của một người dùng theo username.
     * @param username Tên đăng nhập của người dùng.
     * @return Optional chứa kháng cáo mới nhất nếu có.
     */
    Optional<Appeal> findTopByUserUsernameOrderBySubmittedAtDesc(String username);
}
