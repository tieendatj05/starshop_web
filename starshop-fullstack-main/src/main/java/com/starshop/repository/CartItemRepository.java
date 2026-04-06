package com.starshop.repository;

import com.starshop.entity.Cart;
import com.starshop.entity.CartItem;
import com.starshop.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Integer> {

    /**
     * Tìm một mục trong giỏ hàng dựa trên giỏ hàng và sản phẩm.
     * Giúp kiểm tra xem một sản phẩm đã tồn tại trong giỏ hàng hay chưa.
     */
    Optional<CartItem> findByCartAndProduct(Cart cart, Product product);

    /**
     * Xóa tất cả các mục trong giỏ hàng liên quan đến một sản phẩm cụ thể.
     * @param product Sản phẩm cần xóa các mục trong giỏ hàng liên quan.
     */
    void deleteByProduct(Product product);
}
