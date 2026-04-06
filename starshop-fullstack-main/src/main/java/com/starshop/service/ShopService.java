package com.starshop.service;

import com.starshop.entity.Shop;
import com.starshop.entity.User;

import java.util.List;
import java.util.Optional;

public interface ShopService {
    List<Shop> getAllShops();

    List<Shop> searchShops(String keyword);

    void approveShop(int shopId);

    void rejectShop(int shopId);

    // Các phương thức mới cho việc đăng ký shop
    boolean hasShop(User user);

    Shop registerShop(String name, String description, User user);

    // Các phương thức mới cho việc khóa/mở khóa shop
    void lockShop(int shopId);

    void unlockShop(int shopId);

    // Các phương thức mới cho việc ẩn/hiện sản phẩm của shop
    void hideAllProductsInShop(int shopId);

    void showAllProductsInShop(int shopId);

    /**
     * Cập nhật thông tin của một cửa hàng.
     * @param shopId ID của cửa hàng cần cập nhật.
     * @param name Tên mới của cửa hàng.
     * @param description Mô tả mới của cửa hàng.
     */
    void updateShopInfo(Integer shopId, String name, String description);

    /**
     * Tìm tất cả các cửa hàng thuộc sở hữu của một người dùng cụ thể.
     * @param owner Người dùng là chủ sở hữu.
     * @return Danh sách các cửa hàng thuộc sở hữu của người dùng.
     */
    List<Shop> findByOwner(User owner);

    /**
     * Tìm một cửa hàng theo ID.
     * @param id ID của cửa hàng.
     * @return Optional chứa cửa hàng nếu tìm thấy.
     */
    Optional<Shop> findById(Integer id);

    /**
     * Tìm một cửa hàng theo ID và tải thông tin chủ sở hữu.
     * @param id ID của cửa hàng.
     * @return Optional chứa cửa hàng nếu tìm thấy.
     */
    Optional<Shop> findByIdWithOwner(Integer id);
}
