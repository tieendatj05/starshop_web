package com.starshop.repository;

import com.starshop.entity.Product;
import com.starshop.entity.Review;
import com.starshop.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Integer> {
    List<Review> findByProductId(Integer productId);

    /**
     * Xóa tất cả các đánh giá liên quan đến một sản phẩm cụ thể.
     * @param product Sản phẩm cần xóa các đánh giá liên quan.
     */
    void deleteByProduct(Product product);

    /**
     * Kiểm tra xem một người dùng đã đánh giá một sản phẩm cụ thể hay chưa.
     * @param user Người dùng.
     * @param product Sản phẩm.
     * @return true nếu người dùng đã đánh giá sản phẩm, ngược lại là false.
     */
    boolean existsByUserAndProduct(User user, Product product);
}
