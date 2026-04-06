package com.starshop.repository;

import com.starshop.entity.Promotion;
import com.starshop.entity.User;
import com.starshop.entity.UserPromotion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserPromotionRepository extends JpaRepository<UserPromotion, Integer> {

    boolean existsByUserAndPromotion(User user, Promotion promotion);

    List<UserPromotion> findByUser(User user);

    @Query("SELECT up FROM UserPromotion up WHERE up.user = :user AND up.promotion.isActive = true")
    List<UserPromotion> findByUserAndActivePromotions(@Param("user") User user);

    void deleteByUserAndPromotion(User user, Promotion promotion);
}
