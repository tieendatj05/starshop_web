package com.starshop.service;

import com.starshop.dto.CartDTO;
import com.starshop.dto.PromotionDTO;
import com.starshop.entity.Promotion;
import com.starshop.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface PromotionService {

    List<PromotionDTO> findAllActivePromotions();

    void savePromotionForUser(Integer promotionId, User user);

    List<Promotion> findUserSavedPromotions(User user);

    void removePromotionForUser(Integer promotionId, User user);

    boolean isPromotionSavedByUser(Integer promotionId, User user);

    Page<PromotionDTO> findDiscountedProducts(Pageable pageable);

    List<Promotion> findPromotionsByVendor(User vendor);

    Optional<Promotion> findByIdAndVendor(Integer id, User vendor);

    Promotion savePromotion(Promotion promotion, User vendor);

    void deletePromotion(Integer id, User vendor);

    BigDecimal calculateDiscount(String discountCode, CartDTO cartDTO, BigDecimal currentCartTotal);

    Optional<Promotion> findValidPromotionByCodeAndCart(String code, CartDTO cartDTO);

    List<PromotionDTO> findApplicableSavedPromotions(User user, CartDTO cartDTO);

    // Admin methods
    List<Promotion> findAllPromotions();

    Optional<Promotion> findById(Integer id);

    Promotion savePromotionByAdmin(Promotion promotion);

    void deletePromotionByAdmin(Integer id);

    void togglePromotionStatus(Integer id);

    List<Promotion> searchPromotions(String keyword);
}
