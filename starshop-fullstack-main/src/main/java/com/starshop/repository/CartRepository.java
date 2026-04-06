package com.starshop.repository;

import com.starshop.entity.Cart;
import com.starshop.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository<Cart, Integer> {

    Optional<Cart> findByUser(User user);

    /**
     * Sửa đổi: Tìm giỏ hàng và tải đồng thời tất cả thông tin liên quan:
     * Cart -> CartItems -> Product -> Shop -> Owner (Người bán)
     */
    @Query("SELECT c FROM Cart c LEFT JOIN FETCH c.items ci LEFT JOIN FETCH ci.product p LEFT JOIN FETCH p.shop s LEFT JOIN FETCH s.owner WHERE c.user = :user")
    Optional<Cart> findByUserWithItems(@Param("user") User user);

    Optional<Cart> findByUserId(Integer userId);
}
