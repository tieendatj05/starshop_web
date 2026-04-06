package com.starshop.service.impl;

import com.starshop.dto.ProductDTO;
import com.starshop.entity.*;
import com.starshop.repository.CartItemRepository;
import com.starshop.repository.OrderDetailRepository;
import com.starshop.repository.ProductDiscountRepository;
import com.starshop.repository.ProductRepository;
import com.starshop.repository.ReviewRepository;
import com.starshop.repository.ShopRepository;
import com.starshop.repository.ViewedProductRepository;
import com.starshop.repository.WishlistRepository;
import com.starshop.service.ProductService;
import jakarta.persistence.EntityManager; // Import EntityManager
import jakarta.persistence.PersistenceContext; // Import PersistenceContext
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductDiscountRepository discountRepository;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private WishlistRepository wishlistRepository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private ViewedProductRepository viewedProductRepository;

    @PersistenceContext // Inject EntityManager
    private EntityManager entityManager;

    @Override
    @Transactional(readOnly = true)
    public List<Product> findAll() {
        List<Product> products = productRepository.findAll();
        products.forEach(product -> {
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return products;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Product> findById(Integer id) {
        Optional<Product> productOpt = productRepository.findByIdWithShopOwnerAndCategory(id);
        productOpt.ifPresent(product -> {
            entityManager.refresh(product);
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return productOpt;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<ProductDTO> findProductDTOById(Integer id) {
        Optional<Product> productOpt = productRepository.findByIdWithShopOwnerAndCategory(id);
        productOpt.ifPresent(product -> {
            entityManager.refresh(product);
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return productOpt.map(ProductDTO::fromEntity);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findTop8BestSellingProducts() {
        List<Product> products = productRepository.findTop8BestSellingProducts();
        products.forEach(product -> {
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return products;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findAllProducts() {
        List<Product> products = productRepository.findAll();
        products.forEach(product -> {
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return products;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> findByVendor(User vendor) {
        List<Product> products = productRepository.findByShop_Owner(vendor);
        products.forEach(product -> {
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return products;
    }

    @Override
    public void toggleProductVisibility(Integer productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại với ID: " + productId));
        product.setActive(!product.isActive());
        productRepository.save(product);
    }

    @Override
    public Product save(Product product) {
        return productRepository.save(product);
    }

    @Override
    public void deleteById(Integer id) {
        productRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> searchProducts(String keyword) {
        String keywordPattern = "%" + keyword.toLowerCase() + "%";
        List<Product> products = productRepository.searchProducts(keywordPattern);
        products.forEach(product -> {
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return products;
    }

    @Override
    public Product saveProductForVendor(Product product, User vendor) {
        if (product.getShop() == null) {
            throw new SecurityException("Thông tin cửa hàng không hợp lệ: Sản phẩm không có cửa hàng liên kết.");
        }
        if (product.getShop().getOwner() == null) {
            throw new SecurityException("Thông tin cửa hàng không hợp lệ: Cửa hàng liên kết không có chủ sở hữu.");
        }
        if (!product.getShop().getOwner().getId().equals(vendor.getId())) {
            throw new SecurityException("Bạn không có quyền thực hiện thao tác này trên cửa hàng được chỉ định.");
        }
        return productRepository.save(product);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Product> findByIdAndVendor(Integer productId, User vendor) {
        Optional<Product> productOpt = productRepository.findByIdWithShopAndOwner(productId);
        productOpt.ifPresent(product -> {
            entityManager.refresh(product);
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return productOpt.filter(p -> p.getShop() != null && p.getShop().getOwner().getId().equals(vendor.getId()));
    }

    @Override
    public void toggleProductVisibilityForVendor(Integer productId, User vendor) {
        Product product = findByIdAndVendor(productId, vendor)
                .orElseThrow(() -> new SecurityException("Sản phẩm không tồn tại hoặc bạn không có quyền truy cập."));
        product.setActive(!product.isActive());
        productRepository.save(product);
    }

    @Override
    public void deleteProductForVendor(Integer productId, User vendor) {
        Product product = findByIdAndVendor(productId, vendor)
                .orElseThrow(() -> new SecurityException("Sản phẩm không tồn tại hoặc bạn không có quyền truy cập."));

        orderDetailRepository.deleteByProduct(product);
        discountRepository.deleteByProduct(product);
        wishlistRepository.deleteByProduct(product);
        cartItemRepository.deleteByProduct(product);
        reviewRepository.deleteByProduct(product);
        viewedProductRepository.deleteByProduct(product);

        productRepository.delete(product);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Product> findProducts(String categorySlug, Pageable pageable) {
        Page<Product> productPage;
        if (categorySlug != null && !categorySlug.isEmpty()) {
            productPage = productRepository.findByCategory_SlugAndActiveTrue(categorySlug, pageable);
        } else {
            productPage = productRepository.findByActiveTrue(pageable);
        }
        productPage.getContent().forEach(product -> {
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return productPage;
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Product> findWishlistedProducts(User user, Pageable pageable) {
        List<Wishlist> wishlist = wishlistRepository.findByUser(user);
        List<Integer> productIds = wishlist.stream().map(w -> w.getProduct().getId()).collect(Collectors.toList());
        Page<Product> productPage = productRepository.findByIdIn(productIds, pageable);
        productPage.getContent().forEach(product -> {
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return productPage;
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Product> findDiscountedProducts(Pageable pageable) {
        List<ProductDiscount> discounts = discountRepository.findByActiveTrueAndStartDateBeforeAndEndDateAfter(LocalDate.now(), LocalDate.now());
        List<Integer> productIds = discounts.stream().map(d -> d.getProduct().getId()).collect(Collectors.toList());
        Page<Product> productPage = productRepository.findByIdIn(productIds, pageable);
        productPage.getContent().forEach(product -> {
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return productPage;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> getProductsByShopId(Long shopId) {
        List<Product> products = productRepository.findByShopId(shopId.intValue());
        products.forEach(product -> {
            applyActiveDiscount(product);
            calculateAndSetReviewStatistics(product);
        });
        return products;
    }

    private void applyActiveDiscount(Product product) {
        if (product == null) return;
        List<ProductDiscount> discounts = discountRepository.findActiveDiscountForProduct(product.getId(), LocalDate.now());
        if (!discounts.isEmpty()) {
            ProductDiscount discount = discounts.get(0);
            BigDecimal price = product.getPrice();
            BigDecimal discountPercentage = BigDecimal.valueOf(discount.getDiscountPercentage());
            BigDecimal discountValue = price.multiply(discountPercentage).divide(BigDecimal.valueOf(100));
            product.setDiscountedPrice(price.subtract(discountValue));
            product.setActiveDiscount(discount);
        } else {
            product.setDiscountedPrice(null);
            product.setActiveDiscount(null);
        }
    }

    private void calculateAndSetReviewStatistics(Product product) {
        if (product == null) return;
        List<Review> reviews = reviewRepository.findByProductId(product.getId());
        if (reviews != null && !reviews.isEmpty()) {
            double average = reviews.stream().mapToInt(Review::getRating).average().orElse(0.0);
            product.setAverageRating(average);
            product.setReviewCount(reviews.size());
        } else {
            product.setAverageRating(0.0);
            product.setReviewCount(0);
        }
    }
}
