package com.starshop.repository;

import com.starshop.entity.Promotion;
import com.starshop.entity.Shop;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface PromotionRepository extends JpaRepository<Promotion, Integer> {

    List<Promotion> findByShop(Shop shop);

    Optional<Promotion> findByCodeAndShop(String code, Shop shop);

    Optional<Promotion> findByCode(String code);

    @Query("SELECT p FROM Promotion p LEFT JOIN FETCH p.shop WHERE p.id = :id")
    Optional<Promotion> findByIdWithShop(@Param("id") Integer id);

    @Query("SELECT p FROM Promotion p LEFT JOIN FETCH p.shop WHERE p.code = :code")
    Optional<Promotion> findByCodeWithShop(@Param("code") String code);

    @Query("SELECT p FROM Promotion p LEFT JOIN FETCH p.shop WHERE p.isActive = true AND p.startDate <= :today AND p.endDate >= :today")
    List<Promotion> findActivePromotions(@Param("today") LocalDate today);

    @Query("SELECT p FROM Promotion p LEFT JOIN FETCH p.shop WHERE p.isActive = true AND p.startDate <= :today AND p.endDate >= :today AND (p.code LIKE CONCAT('%', :keyword, '%') OR p.description LIKE CONCAT('%', :keyword, '%'))")
    List<Promotion> searchActivePromotions(@Param("keyword") String keyword, @Param("today") LocalDate today);

    @Query("SELECT p FROM Promotion p WHERE p.shop = :shop AND p.isActive = true AND p.startDate <= :today AND p.endDate >= :today")
    List<Promotion> findActivePromotionsByShop(@Param("shop") Shop shop, @Param("today") LocalDate today);
}
