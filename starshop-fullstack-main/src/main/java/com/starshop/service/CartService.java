package com.starshop.service;

import com.starshop.dto.CartDTO;
import com.starshop.entity.User;

public interface CartService {

    void addProductToCart(User user, Integer productId, int quantity);

    CartDTO getCartForUser(User user);

    void removeProductFromCart(User user, Integer productId);

    /**
     * Cập nhật số lượng của một sản phẩm trong giỏ hàng.
     *
     * @param user Người dùng.
     * @param productId ID của sản phẩm.
     * @param quantity Số lượng mới.
     */
    void updateProductQuantity(User user, Integer productId, int quantity);

    void clearCart(User user);
}
