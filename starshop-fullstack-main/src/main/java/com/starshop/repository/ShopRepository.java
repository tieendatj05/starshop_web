package com.starshop.repository;

import com.starshop.entity.Shop;
import com.starshop.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ShopRepository extends JpaRepository<Shop, Integer> {

    Optional<Shop> findByOwner(User owner);

    @Query("SELECT s FROM Shop s LEFT JOIN s.owner o WHERE LOWER(s.name) LIKE CONCAT('%', LOWER(:keyword), '%') OR LOWER(o.fullName) LIKE CONCAT('%', LOWER(:keyword), '%') OR LOWER(o.username) LIKE CONCAT('%', LOWER(:keyword), '%')")
    List<Shop> searchShops(@Param("keyword") String keyword);

    long countByStatus(String status);

    /**
     * Tìm Shop bằng ID và đồng thời tải thông tin Owner để tránh LazyInitializationException.
     * Sử dụng LEFT JOIN FETCH để đảm bảo Shop được trả về ngay cả khi owner là NULL.
     */
    @Query("SELECT s FROM Shop s LEFT JOIN FETCH s.owner WHERE s.id = :id")
    Optional<Shop> findByIdWithOwner(@Param("id") Integer id);
}
