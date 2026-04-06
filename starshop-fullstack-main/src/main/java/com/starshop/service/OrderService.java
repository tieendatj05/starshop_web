package com.starshop.service;

import com.starshop.dto.AdminDashboardStatsDTO;
import com.starshop.dto.CartDTO;
import com.starshop.dto.CheckoutInfoDTO;
import com.starshop.dto.ShipperStatsDTO;
import com.starshop.dto.VendorDashboardStatsDTO;
import com.starshop.entity.Order;
import com.starshop.entity.User;

import java.math.BigDecimal;
import java.util.List;

public interface OrderService {
    Order createOrder(User user, CheckoutInfoDTO checkoutInfo);

    List<Order> createOrders(User user, CheckoutInfoDTO checkoutInfo);

    List<Order> findOrdersForUser(User user, String statusFilter);

    List<Order> findOrdersForVendor(User vendor);

    void updateOrderStatus(Integer orderId, String newStatus, User vendor);

    List<Order> findOrdersForShipper(User shipper);

    List<Order> findAvailableOrders();

    boolean assignOrderToShipper(Integer orderId, User shipper);

    void confirmOrderAndSeekShipper(Integer orderId, User vendor);

    void updateOrderStatusInNewTransaction(Order order, User shipper, String newStatus);

    void updateOrderStatusByShipper(Integer orderId, String newStatus, User shipper);

    void cancelOrderAsVendor(Integer orderId, User vendor);

    ShipperStatsDTO getShipperStats(User shipper);

    BigDecimal applyDiscountCode(String discountCode, CartDTO cartDTO, BigDecimal currentCartTotal);

    VendorDashboardStatsDTO getVendorDashboardStats(User vendor);

    /**
     * Lấy dữ liệu thống kê cho trang dashboard của Admin.
     * @return DTO chứa các thông tin thống kê.
     */
    AdminDashboardStatsDTO getAdminDashboardStats();

    /**
     * Lấy tất cả đơn hàng trong hệ thống (cho Admin).
     * @return Danh sách tất cả đơn hàng.
     */
    List<Order> findAllOrdersForAdmin();

    /**
     * Đếm số lượng kháng cáo đang chờ xử lý.
     * @return Số lượng kháng cáo đang chờ xử lý.
     */
    long countPendingAppeals();

    /**
     * Cho phép người dùng hủy đơn hàng của chính họ khi đơn ở trạng thái "Đơn hàng mới".
     */
    void cancelOrderAsUser(Integer orderId, User user);
}
