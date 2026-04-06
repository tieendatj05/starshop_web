-- Tắt kiểm tra khóa ngoại để xóa bảng dễ dàng
SET FOREIGN_KEY_CHECKS = 0;

-- Xóa các bảng nếu đã tồn tại (Thứ tự ngược lại với lúc tạo)
DROP TABLE IF EXISTS `chat_messages`;
DROP TABLE IF EXISTS `payment_transactions`;
DROP TABLE IF EXISTS `shop_commission_transactions`;
DROP TABLE IF EXISTS `shop_commissions`;
DROP TABLE IF EXISTS `viewed_products`;
DROP TABLE IF EXISTS `Appeals`;
DROP TABLE IF EXISTS `User_Promotions`;
DROP TABLE IF EXISTS `CartItems`;
DROP TABLE IF EXISTS `Carts`;
DROP TABLE IF EXISTS `Wishlist`;
DROP TABLE IF EXISTS `Reviews`;
DROP TABLE IF EXISTS `OrderDetails`;
DROP TABLE IF EXISTS `Orders`;
DROP TABLE IF EXISTS `ProductDiscounts`;
DROP TABLE IF EXISTS `Products`;
DROP TABLE IF EXISTS `Promotions`;
DROP TABLE IF EXISTS `shipping_carriers`;
DROP TABLE IF EXISTS `Addresses`;
DROP TABLE IF EXISTS `Shops`;
DROP TABLE IF EXISTS `Users`;
DROP TABLE IF EXISTS `Roles`;
DROP TABLE IF EXISTS `Categories`;

-- Bật lại kiểm tra khóa ngoại
SET FOREIGN_KEY_CHECKS = 1;

-- ==============================================================
-- TẠO CÁC BẢNG (TABLES)
-- ==============================================================

CREATE TABLE `Roles` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(50) NOT NULL UNIQUE CHARACTER SET utf8mb4
);

CREATE TABLE `Users` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `full_name` VARCHAR(150) CHARACTER SET utf8mb4,
    `phone_number` VARCHAR(20),
    `avatar` VARCHAR(255),
    `is_active` BOOLEAN DEFAULT 0,
    `otp_code` VARCHAR(10),
    `otp_expiry` DATETIME,
    `role_id` INT,
    `created_at` DATETIME DEFAULT NOW(),
    FOREIGN KEY (`role_id`) REFERENCES `Roles` (`Id`)
);

CREATE TABLE `Shops` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(200) NOT NULL CHARACTER SET utf8mb4,
    `Description` TEXT CHARACTER SET utf8mb4,
    `Logo` VARCHAR(255),
    `status` VARCHAR(50) NOT NULL, -- PENDING, APPROVED, REJECTED
    `owner_id` INT UNIQUE,
    `created_at` DATETIME DEFAULT NOW(),
    FOREIGN KEY (`owner_id`) REFERENCES `Users` (`Id`)
);

CREATE TABLE `Categories` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(200) NOT NULL CHARACTER SET utf8mb4,
    `Slug` VARCHAR(255) UNIQUE,
    `is_active` BOOLEAN DEFAULT 1
);

CREATE TABLE `Products` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(255) NOT NULL CHARACTER SET utf8mb4,
    `Description` TEXT CHARACTER SET utf8mb4,
    `Price` DECIMAL(18, 2) NOT NULL,
    `stock` INT NOT NULL,
    `image_url` VARCHAR(255),
    `sold_count` INT DEFAULT 0,
    `is_active` BOOLEAN DEFAULT 1,
    `average_rating` FLOAT DEFAULT 0.0,
    `review_count` INT DEFAULT 0,
    `shop_id` INT,
    `category_id` INT,
    `created_at` DATETIME DEFAULT NOW(),
    FOREIGN KEY (`shop_id`) REFERENCES `Shops` (`Id`),
    FOREIGN KEY (`category_id`) REFERENCES `Categories` (`Id`)
);

CREATE TABLE `ProductDiscounts` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `product_id` INT NOT NULL,
    `discount_percentage` INT NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT 1,
    FOREIGN KEY (`product_id`) REFERENCES `Products` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `Addresses` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `recipient_name` VARCHAR(150) CHARACTER SET utf8mb4,
    `phone_number` VARCHAR(20),
    `detail_address` VARCHAR(500) CHARACTER SET utf8mb4,
    `City` VARCHAR(100) CHARACTER SET utf8mb4,
    `is_default` BOOLEAN DEFAULT 0,
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`Id`)
);

CREATE TABLE `shipping_carriers` (
    `Id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(100) NOT NULL CHARACTER SET utf8mb4,
    `phone` VARCHAR(20) NULL,
    `website` VARCHAR(255) NULL,
    `shipping_fee` DECIMAL(18, 2) NOT NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT 1
);

CREATE TABLE `Promotions` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `Code` VARCHAR(50) NOT NULL UNIQUE,
    `Description` TEXT CHARACTER SET utf8mb4,
    `discount_percentage` FLOAT,
    `max_discount_amount` DECIMAL(18, 2),
    `start_date` DATETIME,
    `end_date` DATETIME,
    `is_active` BOOLEAN DEFAULT 1,
    `shop_id` INT NOT NULL,
    FOREIGN KEY (`shop_id`) REFERENCES `Shops` (`Id`)
);

CREATE TABLE `Orders` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `shipping_address` VARCHAR(500) CHARACTER SET utf8mb4,
    `shipping_phone` VARCHAR(20),
    `total_amount` DECIMAL(18, 2),
    `payment_method` VARCHAR(50),
    `Status` VARCHAR(50) CHARACTER SET utf8mb4 DEFAULT 'Đơn hàng mới',
    `Notes` TEXT CHARACTER SET utf8mb4,
    `shipper_id` INT NULL,
    `shipping_carrier_id` BIGINT NOT NULL,
    `promotion_id` INT NULL,
    `discount_code` VARCHAR(50) NULL,
    `discount_amount` DECIMAL(18, 2) NOT NULL DEFAULT 0,
    `created_at` DATETIME DEFAULT NOW(),
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`Id`),
    FOREIGN KEY (`shipper_id`) REFERENCES `Users` (`Id`),
    FOREIGN KEY (`shipping_carrier_id`) REFERENCES `shipping_carriers` (`Id`),
    FOREIGN KEY (`promotion_id`) REFERENCES `Promotions` (`Id`)
);

CREATE TABLE `OrderDetails` (
    `Id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `Quantity` INT NOT NULL,
    `Price` DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (`order_id`) REFERENCES `Orders` (`Id`),
    FOREIGN KEY (`product_id`) REFERENCES `Products` (`Id`)
);

CREATE TABLE `Reviews` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `Rating` INT NOT NULL CHECK (`Rating` >= 1 AND `Rating` <= 5),
    `Comment` TEXT CHARACTER SET utf8mb4,
    `image_url` VARCHAR(255),
    `video_url` VARCHAR(255),
    `created_at` DATETIME DEFAULT NOW(),
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`Id`),
    FOREIGN KEY (`product_id`) REFERENCES `Products` (`Id`)
);

CREATE TABLE `Wishlist` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT,
    `product_id` INT,
    `created_at` DATETIME DEFAULT NOW(),
    UNIQUE (`user_id`, `product_id`),
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`Id`),
    FOREIGN KEY (`product_id`) REFERENCES `Products` (`Id`)
);

CREATE TABLE `Carts` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL UNIQUE,
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`Id`)
);

CREATE TABLE `CartItems` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `cart_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `Quantity` INT NOT NULL,
    FOREIGN KEY (`cart_id`) REFERENCES `Carts` (`Id`),
    FOREIGN KEY (`product_id`) REFERENCES `Products` (`Id`)
);

CREATE TABLE `User_Promotions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `promotion_id` INT NOT NULL,
    `saved_at` DATETIME(6) NOT NULL DEFAULT NOW(6),
    CONSTRAINT `FK_UserPromotion_User` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`),
    CONSTRAINT `FK_UserPromotion_Promotion` FOREIGN KEY (`promotion_id`) REFERENCES `Promotions` (`id`),
    CONSTRAINT `UQ_User_Promotion` UNIQUE (`user_id`, `promotion_id`)
);

CREATE TABLE `Appeals` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `reason` TEXT NOT NULL CHARACTER SET utf8mb4,
    `status` VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    `submitted_at` DATETIME NOT NULL DEFAULT NOW(),
    `admin_id` INT NULL,
    `processed_at` DATETIME NULL,
    `admin_notes` TEXT NULL CHARACTER SET utf8mb4,
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`Id`),
    FOREIGN KEY (`admin_id`) REFERENCES `Users` (`Id`)
);

CREATE TABLE `viewed_products` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `viewed_at` DATETIME DEFAULT NOW(),
    FOREIGN KEY (`user_id`) REFERENCES `Users`(`Id`),
    FOREIGN KEY (`product_id`) REFERENCES `Products`(`Id`)
);

CREATE TABLE `shop_commissions` (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `shop_id` INT NOT NULL,
    `commission_month` INT NOT NULL,
    `commission_year` INT NOT NULL,
    `commission_percentage` DECIMAL(5, 2) NOT NULL DEFAULT 0,
    `total_orders` INT NOT NULL DEFAULT 0,
    `total_revenue` DECIMAL(18, 2) NOT NULL DEFAULT 0,
    `commission_amount` DECIMAL(18, 2) NOT NULL DEFAULT 0,
    `net_amount` DECIMAL(18, 2) NOT NULL DEFAULT 0,
    `status` VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    `created_by` INT NULL,
    `created_at` DATETIME NOT NULL DEFAULT NOW(),
    `updated_at` DATETIME NOT NULL DEFAULT NOW(),
    FOREIGN KEY (`shop_id`) REFERENCES `Shops` (`Id`),
    FOREIGN KEY (`created_by`) REFERENCES `Users` (`Id`),
    CONSTRAINT `UQ_Shop_Month_Year` UNIQUE (`shop_id`, `commission_month`, `commission_year`)
);

CREATE TABLE `shop_commission_transactions` (
    `Id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `commission_id` INT NOT NULL,
    `order_id` INT NOT NULL,
    `order_amount` DECIMAL(18, 2) NOT NULL,
    `commission_rate` DECIMAL(5, 2) NOT NULL,
    `commission_amount` DECIMAL(18, 2) NOT NULL,
    `transaction_date` DATETIME NOT NULL DEFAULT NOW(),
    FOREIGN KEY (`commission_id`) REFERENCES `shop_commissions` (`Id`),
    FOREIGN KEY (`order_id`) REFERENCES `Orders` (`Id`)
);

CREATE TABLE `payment_transactions` (
    `Id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT NOT NULL,
    `transaction_ref` VARCHAR(255) NOT NULL,
    `vnp_TransactionNo` VARCHAR(255),
    `amount` DECIMAL(18, 2) NOT NULL,
    `status` VARCHAR(50) NOT NULL,
    `response_code` VARCHAR(10),
    `transaction_info` TEXT,
    `created_at` DATETIME NOT NULL DEFAULT NOW(),
    FOREIGN KEY (`order_id`) REFERENCES `Orders` (`Id`)
);

CREATE TABLE `chat_messages` (
    `Id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `sender` VARCHAR(255) NOT NULL,
    `recipient` VARCHAR(255),
    `content` VARCHAR(2048) CHARACTER SET utf8mb4 NOT NULL,
    `timestamp` DATETIME NOT NULL DEFAULT NOW()
);