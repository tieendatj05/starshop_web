package com.starshop.constant;

public final class OrderStatus {

    // Private constructor để ngăn việc tạo instance của lớp này
    private OrderStatus() {}

    public static final String NEW_ORDER = "Đơn hàng mới";
    public static final String WAITING_FOR_CONFIRMATION = "Chờ xác nhận";
    public static final String WAITING_FOR_PICKUP = "Chờ lấy hàng";
    public static final String DELIVERING = "Đang giao";
    public static final String DELIVERED_SUCCESS = "Giao thành công";
    public static final String DELIVERED_FAIL = "Giao thất bại";
    public static final String CANCELED = "Đã hủy";
}
