package com.starshop.service.impl;

import com.starshop.dto.CartDTO;
import com.starshop.dto.CartItemDTO;
import com.starshop.dto.PromotionDTO;
import com.starshop.entity.Promotion;
import com.starshop.entity.Shop;
import com.starshop.entity.User;
import com.starshop.entity.UserPromotion;
import com.starshop.repository.PromotionRepository;
import com.starshop.repository.ShopRepository;
import com.starshop.repository.UserPromotionRepository;
import com.starshop.service.PromotionService;
import com.starshop.service.ProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class PromotionServiceImpl implements PromotionService {

    private static final Logger log = LoggerFactory.getLogger(PromotionServiceImpl.class);

    @Autowired
    private PromotionRepository promotionRepository;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private UserPromotionRepository userPromotionRepository;

    @Autowired
    private ProductService productService;

    @Override
    @Transactional(readOnly = true)
    public List<Promotion> findPromotionsByVendor(User vendor) {
        Optional<Shop> shopOpt = shopRepository.findByOwner(vendor);
        return shopOpt.map(promotionRepository::findByShop).orElse(Collections.emptyList());
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Promotion> findByIdAndVendor(Integer id, User vendor) {
        return shopRepository.findByOwner(vendor)
                .flatMap(shop -> promotionRepository.findByIdWithShop(id)
                        .filter(promo -> promo.getShop() != null && promo.getShop().getId().equals(shop.getId())));
    }

    @Override
    public Promotion savePromotion(Promotion promotion, User vendor) {
        Shop shop = shopRepository.findByOwner(vendor)
                .orElseThrow(() -> new IllegalStateException("Bạn không sở hữu cửa hàng nào để tạo khuyến mãi."));

        promotion.setShop(shop);
        return promotionRepository.save(promotion);
    }

    @Override
    public void deletePromotion(Integer id, User vendor) {
        Promotion promotion = findByIdAndVendor(id, vendor)
                .orElseThrow(() -> new SecurityException("Bạn không có quyền xóa khuyến mãi này."));
        promotionRepository.delete(promotion);
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal calculateDiscount(String discountCode, CartDTO cartDTO, BigDecimal currentCartTotal) {
        log.info("--- Bắt đầu tính toán giảm giá cho mã: {}", discountCode);
        if (discountCode == null || discountCode.trim().isEmpty() || cartDTO == null || cartDTO.getItems().isEmpty()) {
            log.warn("Dừng tính toán: Đầu vào không hợp lệ (mã hoặc giỏ hàng rỗng).");
            return BigDecimal.ZERO;
        }

        Optional<Promotion> promotionOpt = promotionRepository.findByCodeWithShop(discountCode);

        if (promotionOpt.isEmpty()) {
            log.warn("Dừng tính toán: Không tìm thấy mã khuyến mãi '{}'.", discountCode);
            return BigDecimal.ZERO;
        }

        Promotion promotion = promotionOpt.get();
        log.info("Đã tìm thấy khuyến mãi ID: {}, Shop: {}", promotion.getId(), promotion.getShop() != null ? promotion.getShop().getName() : "NULL");
        LocalDate today = LocalDate.now();

        if (!promotion.isActive() || today.isBefore(promotion.getStartDate()) || today.isAfter(promotion.getEndDate())) {
            log.warn("Dừng tính toán: Khuyến mãi không hoạt động hoặc đã hết hạn.");
            return BigDecimal.ZERO;
        }

        if (promotion.getShop() == null) {
            log.error("Dừng tính toán: Khuyến mãi ID {} không có thông tin Shop.", promotion.getId());
            return BigDecimal.ZERO;
        }

        BigDecimal subtotalForPromotion = BigDecimal.ZERO;
        Integer promotionShopId = promotion.getShop().getId();
        log.info("Khuyến mãi áp dụng cho Shop ID: {}", promotionShopId);

        log.info("Kiểm tra {} sản phẩm trong giỏ hàng...", cartDTO.getItems().size());
        for (CartItemDTO item : cartDTO.getItems()) {
            if (item.getProduct() == null || item.getProduct().getShop() == null) {
                log.warn("Bỏ qua sản phẩm trong giỏ hàng vì không có thông tin sản phẩm hoặc shop. CartItemID: {}", item.getCartItemId());
                continue;
            }
            Integer productShopId = item.getProduct().getShop().getId();
            log.info("  - Kiểm tra sản phẩm: '{}' (ID: {}), Shop ID: {}", item.getProduct().getName(), item.getProduct().getId(), productShopId);

            if (item.isValid() && productShopId.equals(promotionShopId)) {
                log.info("    -> TRÙNG KHỚP! Thêm tổng phụ {} vào tính toán.", item.getSubtotal());
                subtotalForPromotion = subtotalForPromotion.add(item.getSubtotal());
            } else {
                log.info("    -> Không trùng khớp.");
            }
        }

        if (subtotalForPromotion.compareTo(BigDecimal.ZERO) <= 0) {
            log.warn("Dừng tính toán: Không có sản phẩm nào trong giỏ hàng hợp lệ cho khuyến mãi này.");
            return BigDecimal.ZERO;
        }
        log.info("Tổng tiền các sản phẩm hợp lệ: {}", subtotalForPromotion);

        BigDecimal discountAmount = subtotalForPromotion.multiply(BigDecimal.valueOf(promotion.getDiscountPercentage()))
                                                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        log.info("Số tiền giảm giá (trước khi giới hạn): {}", discountAmount);

        if (promotion.getMaxDiscountAmount() != null && discountAmount.compareTo(promotion.getMaxDiscountAmount()) > 0) {
            discountAmount = promotion.getMaxDiscountAmount();
            log.info("Số tiền giảm giá được giới hạn còn: {}", discountAmount);
        }

        log.info("--- Kết thúc tính toán. Số tiền giảm giá cuối cùng: {}", discountAmount);
        return discountAmount;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Promotion> findValidPromotionByCodeAndCart(String code, CartDTO cartDTO) {
        return Optional.empty();
    }

    @Override
    @Transactional(readOnly = true)
    public List<PromotionDTO> findAllActivePromotions() {
        LocalDate today = LocalDate.now();
        List<Promotion> activePromotions = promotionRepository.findActivePromotions(today);

        return activePromotions.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Promotion> findUserSavedPromotions(User user) {
        List<UserPromotion> userPromotions = userPromotionRepository.findByUser(user);
        return userPromotions.stream()
                .map(UserPromotion::getPromotion)
                .collect(Collectors.toList());
    }

    @Override
    public void savePromotionForUser(Integer promotionId, User user) {
        Promotion promotion = promotionRepository.findById(promotionId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy mã khuyến mãi"));

        if (userPromotionRepository.existsByUserAndPromotion(user, promotion)) {
            throw new IllegalStateException("Bạn đã lưu mã khuyến mãi này rồi");
        }

        UserPromotion userPromotion = new UserPromotion(user, promotion);
        userPromotionRepository.save(userPromotion);
    }

    @Override
    @Transactional
    public void removePromotionForUser(Integer promotionId, User user) {
        Promotion promotion = promotionRepository.findById(promotionId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy mã khuyến mãi"));

        userPromotionRepository.deleteByUserAndPromotion(user, promotion);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isPromotionSavedByUser(Integer promotionId, User user) {
        Promotion promotion = promotionRepository.findById(promotionId)
                .orElse(null);
        return promotion != null && userPromotionRepository.existsByUserAndPromotion(user, promotion);
    }

    @Override
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<PromotionDTO> findDiscountedProducts(org.springframework.data.domain.Pageable pageable) {
        // Để trống hoặc trả về empty page vì chức năng này có thể cần ProductService
        return org.springframework.data.domain.Page.empty();
    }

    @Override
    @Transactional(readOnly = true)
    public List<PromotionDTO> findApplicableSavedPromotions(User user, CartDTO cartDTO) {
        List<UserPromotion> savedPromotions = userPromotionRepository.findByUserAndActivePromotions(user);

        return savedPromotions.stream()
                .map(UserPromotion::getPromotion)
                .filter(promotion -> isPromotionApplicableToCart(promotion, cartDTO))
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private boolean isPromotionApplicableToCart(Promotion promotion, CartDTO cartDTO) {
        if (promotion == null || promotion.getShop() == null || cartDTO == null) {
            return false;
        }

        LocalDate today = LocalDate.now();
        if (!promotion.isActive() || today.isBefore(promotion.getStartDate()) || today.isAfter(promotion.getEndDate())) {
            return false;
        }

        // Kiểm tra xem có sản phẩm nào trong cart thuộc shop của promotion không
        return cartDTO.getItems().stream()
                .anyMatch(item -> item.getProduct() != null
                    && item.getProduct().getShop() != null
                    && item.getProduct().getShop().getId().equals(promotion.getShop().getId()));
    }

    private PromotionDTO convertToDTO(Promotion promotion) {
        return PromotionDTO.fromEntity(promotion);
    }

    // Admin methods implementation
    @Override
    @Transactional(readOnly = true)
    public List<Promotion> findAllPromotions() {
        return promotionRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Promotion> findById(Integer id) {
        return promotionRepository.findByIdWithShop(id);
    }

    @Override
    public Promotion savePromotionByAdmin(Promotion promotion) {
        if (promotion.getShop() == null || promotion.getShop().getId() == null) {
            throw new IllegalArgumentException("Cửa hàng không được để trống");
        }

        // Verify shop exists
        Shop shop = shopRepository.findById(promotion.getShop().getId())
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy cửa hàng"));

        promotion.setShop(shop);
        return promotionRepository.save(promotion);
    }

    @Override
    public void deletePromotionByAdmin(Integer id) {
        Promotion promotion = promotionRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy mã khuyến mãi"));
        promotionRepository.delete(promotion);
    }

    @Override
    public void togglePromotionStatus(Integer id) {
        Promotion promotion = promotionRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy mã khuyến mãi"));
        promotion.setIsActive(!promotion.isActive());
        promotionRepository.save(promotion);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Promotion> searchPromotions(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAllPromotions();
        }

        return promotionRepository.findAll().stream()
                .filter(p -> p.getCode().toLowerCase().contains(keyword.toLowerCase())
                        || (p.getDescription() != null && p.getDescription().toLowerCase().contains(keyword.toLowerCase()))
                        || (p.getShop() != null && p.getShop().getName().toLowerCase().contains(keyword.toLowerCase())))
                .collect(Collectors.toList());
    }
}
