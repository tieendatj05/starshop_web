    -- ==============================================================
    -- CHÈN DỮ LIỆU (DATA SEEDING)
    -- ==============================================================

    -- 1. Roles
    INSERT INTO `Roles` (`Name`) VALUES ('ADMIN'), ('VENDOR'), ('USER'), ('SHIPPER');

    -- 2. Users
    INSERT INTO `Users` (`username`, `password`, `email`, `full_name`, `phone_number`, `avatar`, `is_active`, `otp_code`, `otp_expiry`, `role_id`)
    VALUES
    ('admin', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'admin@starshop.com', 'Quản Trị Viên', '0909123456', 'avatars/admin.jpg', 1, NULL, NULL, 1),
    ('vendor1', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'vendor1@starshop.com', 'Nguyễn Văn Bán', '0909111222', 'avatars/vendor1.jpg', 1, NULL, NULL, 2),
    ('vendor2', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'vendor2@starshop.com', 'Trần Thị Chủ Shop', '0909333444', 'avatars/vendor2.jpg', 1, NULL, NULL, 2),
    ('user1', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user1@starshop.com', 'Lê Thị Mua Hàng', '0909888999', 'avatars/user1.jpg', 1, NULL, NULL, 3),
    ('user2', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user2@starshop.com', 'Phạm Văn Khách', '0909777666', 'avatars/user2.jpg', 1, NULL, NULL, 3),
    ('shipper1', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'shipper1@starshop.com', 'Hoàng Giao Nhanh', '0912345678', 'avatars/shipper1.jpg', 1, NULL, NULL, 4),
    ('vendor3', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'vendor3@starshop.com', 'Phạm Thị Cung Cấp', '0912345670', 'avatars/vendor3.jpg', 1, NULL, NULL, 2),
    ('vendor4', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'vendor4@starshop.com', 'Đỗ Văn Bán Buôn', '0912345671', 'avatars/vendor4.jpg', 1, NULL, NULL, 2),
    ('vendor5', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'vendor5@starshop.com', 'Nguyễn Thị Hoa', '0912345672', 'avatars/vendor5.jpg', 1, NULL, NULL, 2),
    ('user3', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user3@starshop.com', 'Trần Văn Mua', '0912345673', 'avatars/user3.jpg', 1, '123456', '2024-12-31 23:59:59', 3),
    ('user4', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user4@starshop.com', 'Nguyễn Thị Khách Hàng', '0912345674', 'avatars/user4.jpg', 1, NULL, NULL, 3),
    ('user5', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user5@starshop.com', 'Lê Văn Thử', '0912345675', 'avatars/user5.jpg', 1, NULL, NULL, 3),
    ('shipper2', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'shipper2@starshop.com', 'Vận Chuyển Nhanh', '0912345676', 'avatars/shipper2.jpg', 1, NULL, NULL, 4),
    ('shipper3', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'shipper3@starshop.com', 'Giao Hàng Tận Nơi', '0912345677', 'avatars/shipper3.jpg', 1, NULL, NULL, 4),
    ('user6', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user6@starshop.com', 'Nguyễn Văn A', '0912345679', 'avatars/user6.jpg', 1, NULL, NULL, 3),
    ('user7', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user7@starshop.com', 'Trần Thị B', '0912345680', 'avatars/user7.jpg', 1, '654321', '2024-12-31 23:59:59', 3),
    ('vendor6', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'vendor6@starshop.com', 'Lý Văn Cung Cấp', '0912345681', 'avatars/vendor6.jpg', 1, NULL, NULL, 2),
    ('user8', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user8@starshop.com', 'Phạm Văn C', '0912345682', 'avatars/user8.jpg', 1, NULL, NULL, 3),
    ('user9', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user9@starshop.com', 'Hoàng Thị D', '0912345683', 'avatars/user9.jpg', 1, NULL, NULL, 3),
    ('user10', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user10@starshop.com', 'Đặng Văn E', '0912345684', 'avatars/user10.jpg', 1, NULL, NULL, 3),
    ('user11', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user11@starshop.com', 'Nguyễn Thị F', '0912345685', 'avatars/user11.jpg', 1, NULL, NULL, 3),
    ('user12', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user12@starshop.com', 'Trần Văn G', '0912345686', 'avatars/user12.jpg', 1, NULL, NULL, 3),
    ('user13', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user13@starshop.com', 'Lê Thị H', '0912345687', 'avatars/user13.jpg', 1, NULL, NULL, 3),
    ('user14', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user14@starshop.com', 'Vũ Thị Mai', '0912345688', 'avatars/user14.jpg', 1, NULL, NULL, 3),
    ('user15', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user15@starshop.com', 'Đinh Văn Nam', '0912345689', 'avatars/user15.jpg', 1, NULL, NULL, 3),
    ('user16', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user16@starshop.com', 'Bùi Thị Lan', '0912345690', 'avatars/user16.jpg', 1, NULL, NULL, 3),
    ('user17', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user17@starshop.com', 'Cao Văn Đức', '0912345691', 'avatars/user17.jpg', 1, NULL, NULL, 3),
    ('user18', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user18@starshop.com', 'Huỳnh Thị Thảo', '0912345692', 'avatars/user18.jpg', 1, NULL, NULL, 3),
    ('user19', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user19@starshop.com', 'Phan Văn Hùng', '0912345693', 'avatars/user19.jpg', 1, NULL, NULL, 3),
    ('user20', '$2b$10$L2h9vkTiIk8E7d4Ecn/OaOHsL0KMy2azFPGZ8aBsFJBBz.2G/a7hu', 'user20@starshop.com', 'Lâm Thị Hương', '0912345694', 'avatars/user20.jpg', 1, NULL, NULL, 3);

    -- 3. Shops
    INSERT INTO `Shops` (`Name`, `Description`, `Logo`, `status`, `owner_id`)
    VALUES
    ('Vườn Hoa Yêu Thương', 'Chuyên cung cấp hoa cho các dịp lễ tình nhân, cưới hỏi.', 'logos/shop1.png', 'APPROVED', 2),
    ('Hoa Khai Trương Phát Tài', 'Hoa khai trương, hoa chúc mừng, lẵng hoa sang trọng.', 'logos/shop2.png', 'APPROVED', 3),
    ('Shop Hoa Tươi 24h', 'Cung cấp hoa tươi mọi lúc mọi nơi.', 'logos/shop3.png', 'APPROVED', 7),
    ('Thế Giới Cây Cảnh', 'Đa dạng các loại cây cảnh mini và cây phong thủy.', 'logos/shop4.png', 'APPROVED', 8),
    ('Phụ Kiện Hoa Đẹp', 'Chuyên phụ kiện trang trí hoa, giỏ, ruy băng.', 'logos/shop5.png', 'APPROVED', 9),
    ('Shop Hoa Của Tôi', 'Shop hoa mới, đang chờ duyệt.', 'logos/shop6.png', 'PENDING', 1);

    -- 4. Categories
    INSERT INTO `Categories` (`Name`, `Slug`, `is_active`)
    VALUES
    ('Hoa Tình Yêu', 'hoa-tinh-yeu', 1),
    ('Hoa Khai Trương', 'hoa-khai-truong', 1),
    ('Hoa Sinh Nhật', 'hoa-sinh-nhat', 1),
    ('Hoa Chia Buồn', 'hoa-chia-buon', 1),
    ('Hoa Cưới', 'hoa-cuoi', 1),
    ('Cây Cảnh Mini', 'cay-canh-mini', 1),
    ('Phụ Kiện Hoa', 'phu-kien-hoa', 1),
    ('Hoa Giả Cao Cấp', 'hoa-gia-cao-cap', 0);

    -- 5. Products
    INSERT INTO `Products` (`Name`, `Description`, `Price`, `stock`, `image_url`, `sold_count`, `is_active`, `shop_id`, `category_id`)
    VALUES
    ('Bó Hồng Đỏ Ecuador', 'Bó hoa gồm 99 bông hồng đỏ Ecuador tượng trưng cho tình yêu vĩnh cửu.', 2500000, 50, 'images/hoa-hong-do.jpg', 120, 1, 1, 1),
    ('Giỏ Hoa Baby Trắng', 'Sự tinh khôi và trong sáng của hoa baby trắng.', 750000, 100, 'images/hoa-baby.jpg', 85, 1, 1, 3),
    ('Bó Tulip Hà Lan', 'Bó hoa tulip nhập khẩu trực tiếp từ Hà Lan, sang trọng và tinh tế.', 900000, 70, 'images/hoa-tulip.jpeg', 60, 1, 1, 1),
    ('Kệ Hoa Khai Trương 2 Tầng', 'Kệ hoa chúc mừng khai trương hồng phát, kết hợp hoa đồng tiền và lan hồ điệp.', 3500000, 30, 'images/ke-hoa-khai-truong.jpg', 45, 1, 2, 2),
    ('Lẵng Hoa Hướng Dương', 'Lẵng hoa hướng dương rực rỡ mang lại năng lượng tích cực.', 850000, 80, 'images/lang-hoa-huong-duong.jpg', 95, 1, 2, 2),
    ('Bình Lan Hồ Điệp Vàng', 'Bình hoa lan hồ điệp vàng 5 cành, sang trọng và đẳng cấp.', 4500000, 20, 'images/lan-ho-diep.jpg', 30, 1, 2, 2),
    ('Bó Hoa Cưới Cầm Tay', 'Bó hoa cưới tinh tế với hoa hồng trắng và baby.', 1800000, 25, 'images/hoa-cuoi-cam-tay.jpg', 15, 1, 1, 5),
    ('Cây Kim Tiền Mini', 'Cây kim tiền để bàn, mang lại tài lộc.', 150000, 200, 'images/cay-kim-tien.jpg', 50, 1, 4, 6),
    ('Chậu Lan Hồ Điệp Tím', 'Chậu lan hồ điệp tím sang trọng, 3 cành.', 2800000, 15, 'images/lan-ho-diep-tim.jpg', 10, 1, 3, 2),
    ('Ruy Băng Lụa Cao Cấp', 'Cuộn ruy băng lụa dùng để trang trí hoa.', 50000, 500, 'images/ruy-bang.jpg', 150, 1, 5, 7),
    ('Hoa Ly Trắng', 'Bó hoa ly trắng tinh khiết, thích hợp cho nhiều dịp.', 600000, 90, 'images/hoa-ly-trang.jpg', 70, 1, 3, 3),
    ('Bó Hoa Chia Buồn Trang Trọng', 'Bó hoa chia buồn với hoa cúc và huệ trắng.', 1200000, 40, 'images/hoa-chia-buon-trang-trong.jpg', 20, 1, 2, 4),
    ('Sen Đá Đa Dạng', 'Bộ sưu tập sen đá mini, dễ chăm sóc.', 80000, 300, 'images/sen-da.jpg', 100, 1, 4, 6),
    ('Bó Hoa Hướng Dương Mini', 'Bó hoa hướng dương nhỏ xinh, tươi tắn.', 400000, 120, 'images/huong-duong-mini.jpg', 80, 1, 1, 3),
    ('Hoa Hồng Xanh Vĩnh Cửu', 'Bông hồng xanh được ướp vĩnh cửu, quà tặng độc đáo.', 950000, 30, 'images/hoa-hong-xanh.jpg', 5, 0, 1, 1),
    ('Kệ Hoa Chúc Mừng', 'Kệ hoa chúc mừng với hoa lan và hoa hồng.', 2000000, 10, 'images/ke-hoa-chuc-mung.jpg', 8, 1, 2, 2),
    ('Bó Hoa Cúc Họa Mi', 'Bó hoa cúc họa mi trắng tinh khôi, thích hợp cho nhiều dịp đặc biệt.', 450000, 60, 'images/hoa-cuc-hoa-mi.jpg', 35, 1, 1, 3),
    ('Chậu Hoa Violet Tím', 'Chậu hoa violet tím nhỏ xinh, dễ chăm sóc và lâu tàn.', 180000, 120, 'images/hoa-violet.jpg', 45, 1, 3, 6),
    ('Lẵng Hoa Cẩm Chướng', 'Lẵng hoa cẩm chướng đa sắc màu, tươi tắn và rực rỡ.', 680000, 40, 'images/hoa-cam-chuong.jpg', 28, 1, 2, 3),
    ('Bó Hoa Đồng Tiền Vàng', 'Bó hoa đồng tiền vàng mang ý nghĩa thịnh vượng, may mắn.', 520000, 75, 'images/hoa-dong-tien.jpg', 52, 1, 2, 2),
    ('Cây Trầu Bà Lá Tim', 'Cây trầu bà lá tim dễ trồng, thanh lọc không khí hiệu quả.', 95000, 180, 'images/cay-trau-ba.jpg', 67, 1, 4, 6),
    ('Hộp Quà Hoa Hồng Nhỏ', 'Hộp quà nhỏ xinh với 3 bông hoa hồng đỏ và chocolate.', 350000, 90, 'images/hop-qua-hoa-hong.jpg', 89, 1, 1, 1),
    ('Bó Hoa Calla Lily Trắng', 'Bó hoa calla lily trắng thanh lịch, sang trọng và tinh tế.', 780000, 25, 'images/hoa-calla-lily.jpg', 12, 1, 3, 5),
    ('Giỏ Cây Xương Rồng Mini', 'Giỏ 5 cây xương rồng mini đa dạng, dễ chăm sóc.', 220000, 150, 'images/xuong-rong-mini.jpg', 73, 1, 4, 6);

    -- 6. ProductDiscounts
    INSERT INTO `ProductDiscounts` (`product_id`, `discount_percentage`, `start_date`, `end_date`, `is_active`)
    VALUES
    (1, 10, '2024-01-01', '2025-12-31', 1),
    (2, 5, '2024-03-01', '2025-12-30', 1),
    (4, 15, '2024-05-15', '2025-12-15', 1),
    (6, 20, '2024-06-01', '2025-12-30', 1),
    (7, 12, '2024-04-01', '2025-12-31', 1),
    (8, 8, '2024-01-01', '2025-12-31', 1),
    (11, 7, '2024-06-10', '2025-12-10', 1),
    (13, 10, '2024-01-01', '2025-12-31', 0),
    (14, 25, '2024-07-01', '2025-12-31', 1),
    (16, 5, '2024-06-01', '2025-12-31', 1);

    -- 7. Addresses
    INSERT INTO `Addresses` (`user_id`, `recipient_name`, `phone_number`, `detail_address`, `City`, `is_default`)
    VALUES
    (4, 'Lê Thị Mua Hàng', '0909888999', '123 Đường ABC, Phường XYZ', 'TP.HCM', 1),
    (4, 'Lê Thị Mua Hàng (Văn Phòng)', '0909888998', 'Tòa nhà DEF, Quận 1', 'TP.HCM', 0),
    (5, 'Phạm Văn Khách', '0909777666', '456 Đường GHI, Phường JKL', 'Hà Nội', 1),
    (10, 'Trần Văn Mua', '0912345673', '789 Đường MNO, Quận 3', 'Đà Nẵng', 1),
    (11, 'Nguyễn Thị Khách Hàng', '0912345674', '101 Đường PQR, Quận 5', 'Cần Thơ', 1),
    (18, 'Phạm Văn C', '0912345682', '202 Đường XYZ, Phường 1', 'TP.HCM', 1),
    (19, 'Hoàng Thị D', '0912345683', '303 Đường ABC, Quận Bình Thạnh', 'TP.HCM', 1),
    (20, 'Đặng Văn E', '0912345684', '404 Đường DEF, Quận 7', 'TP.HCM', 1),
    (21, 'Nguyễn Thị F', '0912345685', '505 Đường GHI, Quận 10', 'TP.HCM', 1),
    (22, 'Trần Văn G', '0912345686', '606 Đường JKL, Quận 1', 'Hà Nội', 1),
    (23, 'Lê Thị H', '0912345687', '707 Đường MNO, Quận Sơn Trà', 'Đà Nẵng', 1),
    (24, 'Vũ Thị Mai', '0912345688', '808 Đường ABC, Quận 3', 'TP.HCM', 1),
    (25, 'Đinh Văn Nam', '0912345689', '909 Đường DEF, Quận Tân Bình', 'TP.HCM', 1),
    (26, 'Bùi Thị Lan', '0912345690', '101 Đường GHI, Quận Ba Đình', 'Hà Nội', 1),
    (27, 'Cao Văn Đức', '0912345691', '202 Đường JKL, Quận Hai Châu', 'Đà Nẵng', 1),
    (28, 'Huỳnh Thị Thảo', '0912345692', '303 Đường MNO, Quận Ninh Kiều', 'Cần Thơ', 1),
    (29, 'Phan Văn Hùng', '0912345693', '404 Đường PQR, Quận 9', 'TP.HCM', 1),
    (30, 'Lâm Thị Hương', '0912345694', '505 Đường STU, Quận Gò Vấp', 'TP.HCM', 1);

    -- 8. shipping_carriers
    INSERT INTO `shipping_carriers` (`Name`, `phone`, `website`, `shipping_fee`, `is_active`)
    VALUES
    ('Giao Hàng Tiết Kiệm', '19006092', 'ghtk.vn', 25000, 1),
    ('Giao Hàng Nhanh', '18001201', 'ghn.vn', 30000, 1),
    ('Grab Express', '02871098989', 'grab.com/vn/express', 40000, 1),
    ('Viettel Post', '19008095', 'viettelpost.com.vn', 28000, 1),
    ('J&T Express', '19001088', 'jtexpress.vn', 27000, 0);

    -- 9. Promotions
    INSERT INTO `Promotions` (`Code`, `Description`, `discount_percentage`, `max_discount_amount`, `start_date`, `end_date`, `is_active`, `shop_id`)
    VALUES
    ('LOVE10', 'Giảm 10% cho hoa tình yêu, tối đa 500.000đ', 10.0, 500000, '2024-01-01', '2025-12-31', 1, 1),
    ('KHAI15', 'Giảm 15% cho hoa khai trương, tối đa 1.000.000đ', 15.0, 1000000, '2024-01-01', '2025-12-31', 1, 2),
    ('VIP20', 'Giảm 20% cho khách VIP, không giới hạn', 20.0, NULL, '2024-01-01', '2025-12-31', 1, 1),
    ('NEWBIE05', 'Giảm 5% cho khách hàng mới, tối đa 200.000đ', 5.0, 200000, '2024-01-01', '2025-12-31', 1, 1),
    ('SUMMER25', 'Giảm 25% mùa hè hot, tối đa 2.000.000đ', 25.0, 2000000, '2024-06-01', '2024-08-31', 1, 2),
    ('FLASH50', 'Flash sale 50% giới hạn thời gian', 50.0, 1500000, '2024-10-01', '2024-10-31', 1, 1),
    ('WEDDING10', 'Giảm 10% cho hoa cưới', 10.0, 300000, '2024-01-01', '2025-12-31', 1, 1),
    ('PLANTCARE', 'Giảm 5% cho cây cảnh mini', 5.0, 50000, '2024-01-01', '2025-12-31', 1, 4),
    ('SPRING20', 'Giảm 20% cho tất cả sản phẩm của Shop Hoa Tươi 24h', 20.0, 1000000, '2024-03-01', '2024-05-31', 1, 3),
    ('EXPIREDPROMO', 'Mã giảm giá đã hết hạn', 10.0, 100000, '2023-01-01', '2023-01-31', 0, 1),
    ('FUTUREPROMO', 'Mã giảm giá sẽ có hiệu lực trong tương lai', 15.0, 200000, '2025-01-01', '2025-01-31', 1, 2);

    -- 10. Orders & OrderDetails (Dùng LAST_INSERT_ID() thay vì biến)
    -- Order 1
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (4, '123 Đường ABC, Phường XYZ, Quận 1, TP.HCM', '0909888999', 3250000, 'COD', 'Giao thành công', 'Giao hàng vào buổi sáng.', 6, 2, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 1, 1, 2500000), (LAST_INSERT_ID(), 2, 1, 750000);

    -- Order 2
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (5, '456 Đường DEF, Phường GHI, Quận 2, TP.HCM', '0909777666', 3500000, 'BANK_TRANSFER', 'Chờ xác nhận', 'Khách hàng yêu cầu gọi trước khi giao.', 13, 1, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 4, 1, 3500000);

    -- Order 3
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (10, '789 Đường JKL, Phường MNO, Quận 3, TP.HCM', '0912345673', 1800000, 'COD', 'Đang giao', 'Giao vào giờ hành chính.', 14, 3, 7, 'WEDDING10', 180000);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 7, 1, 1800000);

    -- Order 4
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (4, '123 Đường ABC, Phường XYZ, Quận 1, TP.HCM', '0909888999', 150000, 'COD', 'Giao thành công', NULL, 6, 1, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 8, 1, 150000);

    -- Order 5
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (11, '101 Đường PQR, Quận 5, TP.HCM', '0912345674', 1000000, 'BANK_TRANSFER', 'Đơn hàng mới', 'Khách hàng muốn nhận hàng vào cuối tuần.', NULL, 4, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 3, 1, 900000), (LAST_INSERT_ID(), 14, 1, 400000);

    -- Order 6
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (12, 'Địa chỉ không hợp lệ', '0912345675', 500000, 'COD', 'Đã huỷ', 'Địa chỉ giao hàng không tìm thấy.', NULL, 1, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 11, 1, 600000);

    -- Order 7
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (18, '202 Đường XYZ, Phường 1, TP.HCM', '0912345682', 900000, 'COD', 'Đơn hàng mới', NULL, NULL, 2, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 3, 1, 900000);

    -- Order 8
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (19, '303 Đường ABC, Quận Bình Thạnh, TP.HCM', '0912345683', 2800000, 'BANK_TRANSFER', 'Chờ lấy hàng', 'Giao hàng nhanh.', 13, 1, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 9, 1, 2800000);

    -- Order 9
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (20, '404 Đường DEF, Quận 7, TP.HCM', '0912345684', 4500000, 'COD', 'Đang giao', NULL, 6, 3, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 6, 1, 4500000);

    -- Order 10
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (21, '505 Đường GHI, Quận 10, TP.HCM', '0912345685', 2500000, 'COD', 'Giao thành công', 'Giao hàng vào buổi tối.', 14, 2, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 1, 1, 2500000);

    -- Order 11
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (22, '606 Đường JKL, Quận 1, Hà Nội', '0912345686', 3500000, 'BANK_TRANSFER', 'Chờ lấy hàng', NULL, 6, 1, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 4, 1, 3500000);

    -- Order 12
    INSERT INTO `Orders` (`user_id`, `shipping_address`, `shipping_phone`, `total_amount`, `payment_method`, `Status`, `Notes`, `shipper_id`, `shipping_carrier_id`, `promotion_id`, `discount_code`, `discount_amount`)
    VALUES (23, '707 Đường MNO, Quận Sơn Trà, Đà Nẵng', '0912345687', 600000, 'COD', 'Đang giao', 'Khách hàng muốn nhận vào cuối tuần.', 13, 3, NULL, NULL, 0);
    INSERT INTO `OrderDetails` (`order_id`, `product_id`, `Quantity`, `Price`)
    VALUES (LAST_INSERT_ID(), 11, 1, 600000);

    -- 11. Reviews
    INSERT INTO `Reviews` (`user_id`, `product_id`, `Rating`, `Comment`, `image_url`, `video_url`)
    VALUES
    (4, 1, 5, 'Hoa rất tươi và đẹp...', 'reviews/review1_img.jpg', NULL),
    (5, 4, 4, 'Kệ hoa khai trương rất hoành tráng...', NULL, NULL),
    (10, 7, 5, 'Bó hoa cưới rất đẹp...', 'reviews/review3_img.jpg', 'reviews/review3_video.mp4');
    -- (Bro tự copy tiếp các dòng review còn lại tương tự nhé, chỉ cần thay N'...' thành '...' là được)

    -- 12. Wishlist
    INSERT INTO `Wishlist` (`user_id`, `product_id`)
    VALUES (4, 3), (4, 7), (5, 1), (10, 14), (11, 6), (18, 1), (19, 2), (20, 4), (21, 3), (22, 5), (23, 1);

    -- 13. Carts
    INSERT INTO `Carts` (`user_id`)
    VALUES (4), (5), (10), (11), (12), (15), (16), (18), (19), (20), (21), (22), (23), (24), (25), (26), (27), (28), (29), (30);

    -- 14. CartItems
    INSERT INTO `CartItems` (`cart_id`, `product_id`, `Quantity`)
    VALUES
    (1, 3, 1), (1, 6, 1),
    (2, 4, 1), (2, 5, 2),
    (3, 8, 3), (3, 11, 1),
    (4, 1, 1), (4, 12, 2),
    (5, 15, 1),
    (6, 2, 1), (6, 7, 1),
    (7, 13, 2),
    (8, 3, 2), (8, 5, 1),
    (9, 9, 1), (9, 14, 3),
    (10, 6, 1), (10, 13, 1),
    (11, 1, 1), (11, 2, 2),
    (12, 4, 1), (12, 7, 1),
    (13, 11, 1), (13, 15, 1),
    (14, 17, 1), (14, 22, 2),
    (15, 18, 3), (15, 21, 1),
    (16, 19, 1), (16, 20, 1),
    (17, 23, 1), (17, 24, 2),
    (18, 1, 1), (18, 4, 1),
    (19, 7, 1), (19, 12, 1),
    (20, 5, 2), (20, 16, 1);