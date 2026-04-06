package com.starshop.repository;

import com.starshop.entity.Product;
import com.starshop.entity.User;
import com.starshop.entity.Wishlist;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WishlistRepository extends JpaRepository<Wishlist, Integer> {
    List<Wishlist> findByUser(User user);
    Optional<Wishlist> findByUserAndProduct(User user, Product product);
    boolean existsByUserAndProduct(User user, Product product);

    /**
     * Xóa tất cả các mục trong danh sách yêu thích liên quan đến một sản phẩm cụ thể.
     * @param product Sản phẩm cần xóa các mục trong danh sách yêu thích liên quan.
     */
    void deleteByProduct(Product product);
}
