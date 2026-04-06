package com.starshop.repository;

import com.starshop.entity.Product;
import com.starshop.entity.User;
import com.starshop.entity.ViewedProduct;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewedProductRepository extends JpaRepository<ViewedProduct, Long> {

    @Query("SELECT vp FROM ViewedProduct vp " +
           "JOIN FETCH vp.product p " +
           "JOIN FETCH p.shop " +
           "WHERE vp.user = :user " +
           "ORDER BY vp.viewedAt DESC")
    Page<ViewedProduct> findByUserOrderByViewedAtDesc(@Param("user") User user, Pageable pageable);

    // Backup method không dùng JOIN FETCH nếu cần
    Page<ViewedProduct> findByUserOrderByIdDesc(User user, Pageable pageable);

    /**
     * Xóa tất cả các sản phẩm đã xem liên quan đến một sản phẩm cụ thể.
     * @param product Sản phẩm cần xóa các sản phẩm đã xem liên quan.
     */
    void deleteByProduct(Product product);
}
