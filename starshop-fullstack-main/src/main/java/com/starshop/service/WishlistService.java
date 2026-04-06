package com.starshop.service;

import com.starshop.entity.User;

public interface WishlistService {

    /**
     * Thêm một sản phẩm vào danh sách yêu thích của người dùng.
     * @param userId ID của người dùng.
     * @param productId ID của sản phẩm.
     */
    void addToWishlist(Integer userId, Integer productId);

    /**
     * Xóa một sản phẩm khỏi danh sách yêu thích của người dùng.
     * @param userId ID của người dùng.
     * @param productId ID của sản phẩm.
     */
    void removeFromWishlist(Integer userId, Integer productId);

    /**
     * Kiểm tra xem một sản phẩm có nằm trong danh sách yêu thích của người dùng hay không.
     * @param userId ID của người dùng.
     * @param productId ID của sản phẩm.
     * @return true nếu sản phẩm đã được yêu thích, ngược lại là false.
     */
    boolean isProductInWishlist(Integer userId, Integer productId);
}
