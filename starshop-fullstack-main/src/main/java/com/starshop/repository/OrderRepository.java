package com.starshop.repository;

import com.starshop.entity.Order;
import com.starshop.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<Order, Integer> {

    // Cập nhật truy vấn để tải eager shippingCarrier và promotion
    @Query("SELECT o FROM Order o JOIN FETCH o.orderDetails od JOIN FETCH od.product p LEFT JOIN FETCH o.shippingCarrier sc LEFT JOIN FETCH o.promotion prom WHERE o.user = :user ORDER BY o.createdAt DESC")
    List<Order> findUserOrdersWithDetails(@Param("user") User user);

    // Thêm method để lọc đơn hàng theo trạng thái
    @Query("SELECT o FROM Order o JOIN FETCH o.orderDetails od JOIN FETCH od.product p LEFT JOIN FETCH o.shippingCarrier sc LEFT JOIN FETCH o.promotion prom WHERE o.user = :user AND o.status = :status ORDER BY o.createdAt DESC")
    List<Order> findUserOrdersWithDetailsAndStatus(@Param("user") User user, @Param("status") String status);

    @Query("SELECT DISTINCT o FROM Order o JOIN o.orderDetails od WHERE od.product.shop.id = :shopId ORDER BY o.createdAt DESC")
    List<Order> findOrdersByShopId(@Param("shopId") int shopId);

    @Query("SELECT o FROM Order o JOIN FETCH o.user WHERE o.shipper = :shipper ORDER BY o.createdAt DESC")
    List<Order> findByShipper(@Param("shipper") User shipper);

    @Query("SELECT o FROM Order o WHERE o.status = :status AND o.shipper IS NULL ORDER BY o.createdAt ASC")
    List<Order> findAvailableOrders(@Param("status") String status);

    @Query("SELECT o FROM Order o JOIN FETCH o.orderDetails od JOIN FETCH od.product p JOIN FETCH p.shop s WHERE o.id = :orderId")
    Optional<Order> findByIdWithDetails(@Param("orderId") Integer orderId);

    @Query("SELECT count(o) FROM Order o WHERE o.shipper = :shipper AND o.status = :status AND o.createdAt BETWEEN :startDate AND :endDate")
    long countByShipperAndStatusAndCreatedAtBetween(
            @Param("shipper") User shipper,
            @Param("status") String status,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate
    );

    @Query("SELECT SUM(od.price * od.quantity) FROM Order o JOIN o.orderDetails od " +
           "WHERE od.product.shop.id = :shopId " +
           "AND o.status = :status " +
           "AND o.createdAt BETWEEN :startDate AND :endDate")
    BigDecimal findTotalRevenueByShopIdAndStatusAndDateRange(
            @Param("shopId") Integer shopId,
            @Param("status") String status,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    // Phương thức mới: Tính doanh thu thực tế (đã trừ discount của shop)
    // Sửa lại để tính discount đúng - không nhân với số lượng orderDetail
    @Query("SELECT COALESCE(SUM(od.price * od.quantity), 0) - " +
           "COALESCE((SELECT SUM(DISTINCT o2.discountAmount) FROM Order o2 " +
           "WHERE o2.promotion.shop.id = :shopId AND o2.status = :status " +
           "AND o2.id IN (SELECT DISTINCT od2.order.id FROM OrderDetail od2 WHERE od2.product.shop.id = :shopId)), 0) " +
           "FROM Order o JOIN o.orderDetails od " +
           "WHERE od.product.shop.id = :shopId " +
           "AND o.status = :status")
    BigDecimal findTotalNetRevenueByShopIdAndStatus(
            @Param("shopId") Integer shopId,
            @Param("status") String status);

    // Phương thức đơn giản: Tính tổng doanh thu của shop (chưa trừ discount)
    @Query("SELECT COALESCE(SUM(od.price * od.quantity), 0) " +
           "FROM Order o JOIN o.orderDetails od " +
           "WHERE od.product.shop.id = :shopId " +
           "AND o.status = :status " +
           "AND o.createdAt BETWEEN :startDate AND :endDate")
    BigDecimal findGrossRevenueByShopIdAndStatusAndDateRange(
            @Param("shopId") Integer shopId,
            @Param("status") String status,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    // Tính tổng discount của shop trong khoảng thời gian
    @Query("SELECT COALESCE(SUM(o.discountAmount), 0) " +
           "FROM Order o " +
           "WHERE o.status = :status " +
           "AND o.createdAt BETWEEN :startDate AND :endDate " +
           "AND o.promotion IS NOT NULL " +
           "AND o.promotion.shop.id = :shopId " +
           "AND EXISTS (SELECT 1 FROM OrderDetail od WHERE od.order = o AND od.product.shop.id = :shopId)")
    BigDecimal findTotalDiscountByShopIdAndStatusAndDateRange(
            @Param("shopId") Integer shopId,
            @Param("status") String status,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    // Phương thức cũ: Giữ lại cho các trường hợp cần lọc theo ngày
    @Query("SELECT COALESCE(SUM(od.price * od.quantity), 0) - " +
           "COALESCE((SELECT SUM(DISTINCT o2.discountAmount) FROM Order o2 " +
           "WHERE o2.promotion.shop.id = :shopId AND o2.status = :status " +
           "AND o2.createdAt BETWEEN :startDate AND :endDate " +
           "AND o2.id IN (SELECT DISTINCT od2.order.id FROM OrderDetail od2 WHERE od2.product.shop.id = :shopId)), 0) " +
           "FROM Order o JOIN o.orderDetails od " +
           "WHERE od.product.shop.id = :shopId " +
           "AND o.status = :status " +
           "AND o.createdAt BETWEEN :startDate AND :endDate")
    BigDecimal findNetRevenueByShopIdAndStatusAndDateRange(
            @Param("shopId") Integer shopId,
            @Param("status") String status,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    // === ADMIN METHODS ===

    @Query("SELECT DISTINCT o FROM Order o " +
           "JOIN FETCH o.orderDetails od " +
           "JOIN FETCH od.product p " +
           "JOIN FETCH p.shop s " +
           "ORDER BY o.createdAt DESC")
    List<Order> findAllOrdersWithDetails();

    @Query("SELECT SUM(od.price * od.quantity) FROM Order o JOIN o.orderDetails od " +
           "WHERE o.status = :status " +
           "AND o.createdAt BETWEEN :startDate AND :endDate")
    BigDecimal findTotalRevenueByStatusAndDateRange(
            @Param("status") String status,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    /**
     * Kiểm tra xem người dùng đã mua một sản phẩm cụ thể với trạng thái đơn hàng là DELIVERED_SUCCESS hay chưa.
     * @param userId ID của người dùng.
     * @param productId ID của sản phẩm.
     * @param status Trạng thái đơn hàng cần kiểm tra (ví dụ: "DELIVERED_SUCCESS").
     * @return true nếu tìm thấy đơn hàng thỏa mãn điều kiện, ngược lại là false.
     */
    @Query("SELECT COUNT(od) > 0 FROM Order o JOIN o.orderDetails od WHERE o.user.id = :userId AND od.product.id = :productId AND o.status = :status")
    boolean existsByUserIdAndProductIdAndStatus(@Param("userId") Integer userId, @Param("productId") Integer productId, @Param("status") String status);
}
