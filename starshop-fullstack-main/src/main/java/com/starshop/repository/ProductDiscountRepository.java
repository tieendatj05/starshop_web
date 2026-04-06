package com.starshop.repository;

import com.starshop.entity.ProductDiscount;
import com.starshop.entity.Product;
import com.starshop.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProductDiscountRepository extends JpaRepository<ProductDiscount, Integer> {

    /**
     * Tìm tất cả các chương trình giảm giá thuộc về các sản phẩm của một người bán cụ thể.
     * @param owner Người bán (vendor).
     * @return Danh sách các chương trình giảm giá.
     */
    List<ProductDiscount> findByProduct_Shop_Owner(User owner);

    /**
     * Tìm một chương trình giảm giá đang hoạt động cho một sản phẩm cụ thể vào một ngày nhất định.
     * @param productId ID của sản phẩm.
     * @param date Ngày để kiểm tra.
     * @return Optional chứa chương trình giảm giá nếu có.
     */
    @Query("SELECT d FROM ProductDiscount d WHERE d.product.id = :productId AND d.active = true AND :date BETWEEN d.startDate AND d.endDate")
    List<ProductDiscount> findActiveDiscountForProduct(@Param("productId") Integer productId, @Param("date") LocalDate date);

    /**
     * Tìm tất cả các chương trình giảm giá đang hoạt động và có hiệu lực vào ngày hiện tại.
     * @param currentDate Ngày hiện tại.
     * @return Danh sách các chương trình giảm giá đang hoạt động.
     */
    List<ProductDiscount> findByActiveTrueAndStartDateBeforeAndEndDateAfter(LocalDate currentDate, LocalDate currentDate2);

    /**
     * Xóa tất cả các chương trình giảm giá liên quan đến một sản phẩm cụ thể.
     * @param product Sản phẩm cần xóa các chương trình giảm giá liên quan.
     */
    void deleteByProduct(Product product);
}
