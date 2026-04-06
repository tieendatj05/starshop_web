package com.starshop.service;

import com.starshop.entity.Review;
import com.starshop.entity.User;

import java.util.List;

public interface ReviewService {

    /**
     * Lưu một đánh giá mới và cập nhật thống kê của sản phẩm liên quan.
     * @param review Đối tượng Review cần lưu.
     * @param user Người dùng thực hiện đánh giá.
     */
    void saveReview(Review review, User user);

    /**
     * Lấy tất cả các đánh giá của một sản phẩm.
     * @param productId ID của sản phẩm.
     * @return Danh sách các đánh giá.
     */
    List<Review> getReviewsByProductId(Integer productId);

    /**
     * Kiểm tra xem người dùng đã từng đánh giá sản phẩm này chưa.
     * @param userId ID của người dùng.
     * @param productId ID của sản phẩm.
     * @return true nếu đã đánh giá, false nếu chưa.
     */
    boolean hasUserReviewedProduct(Integer userId, Integer productId);

    /**
     * Kiểm tra xem người dùng có đủ điều kiện để đánh giá sản phẩm không
     * (đã mua và đơn hàng đã được giao thành công).
     * @param userId ID của người dùng.
     * @param productId ID của sản phẩm.
     * @return true nếu đủ điều kiện, false nếu không.
     */
    boolean canUserReviewProduct(Integer userId, Integer productId);
}
