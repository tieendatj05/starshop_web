package com.starshop.service;

import com.starshop.entity.Product;
import com.starshop.entity.Shop;
import com.starshop.entity.Promotion;
import com.starshop.repository.ProductRepository;
import com.starshop.repository.ShopRepository;
import com.starshop.repository.PromotionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true) // Thêm annotation để đảm bảo có Hibernate session
public class SearchService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private PromotionRepository promotionRepository;

    /**
     * Tìm kiếm sản phẩm theo từ khóa
     */
    public List<Map<String, String>> searchProducts(String query) {
        if (query == null || query.trim().isEmpty()) {
            return new ArrayList<>();
        }

        List<Product> products = productRepository.searchProducts(query.trim());

        return products.stream()
                // Loại bỏ filter shop status để test - có thể shop chưa được approve
                // .filter(product -> product.getShop() != null && "APPROVED".equals(product.getShop().getStatus()))
                .filter(product -> product.getShop() != null) // Chỉ cần có shop
                .limit(10) // Giới hạn 10 kết quả
                .map(product -> {
                    Map<String, String> productMap = new HashMap<>();
                    productMap.put("name", product.getName());
                    productMap.put("link", "/product/" + product.getId()); // Sửa từ /products/ thành /product/
                    productMap.put("imageUrl", product.getImageUrl() != null ? product.getImageUrl() : "https://via.placeholder.com/180");
                    productMap.put("price", String.format("%,.0f", product.getPrice()));
                    return productMap;
                })
                .collect(Collectors.toList());
    }

    /**
     * Tìm kiếm cửa hàng theo từ khóa
     */
    public List<Map<String, String>> searchShops(String query) {
        if (query == null || query.trim().isEmpty()) {
            return new ArrayList<>();
        }

        List<Shop> shops = shopRepository.searchShops(query.trim());

        return shops.stream()
                // Loại bỏ filter status để test
                // .filter(shop -> "APPROVED".equals(shop.getStatus()))
                .limit(5) // Giới hạn 5 kết quả
                .map(shop -> {
                    Map<String, String> shopMap = new HashMap<>();
                    shopMap.put("id", String.valueOf(shop.getId())); // THÊM DÒNG NÀY
                    shopMap.put("name", shop.getName());
                    shopMap.put("link", "/shop/" + shop.getId());
                    shopMap.put("logoUrl", shop.getLogo() != null ? shop.getLogo() : "https://via.placeholder.com/80");
                    shopMap.put("description", shop.getDescription() != null ? shop.getDescription() : "Chưa có mô tả");
                    return shopMap;
                })
                .collect(Collectors.toList());
    }

    /**
     * Tìm kiếm mã giảm giá theo từ khóa
     */
    public List<Map<String, String>> searchPromotions(String query) {
        if (query == null || query.trim().isEmpty()) {
            return new ArrayList<>();
        }

        List<Promotion> promotions = promotionRepository.searchActivePromotions(query.trim(), LocalDate.now());

        return promotions.stream()
                .limit(5) // Giới hạn 5 kết quả
                .map(promotion -> {
                    Map<String, String> promotionMap = new HashMap<>();
                    promotionMap.put("name", promotion.getDescription());
                    promotionMap.put("code", promotion.getCode());
                    promotionMap.put("description", promotion.getDescription());
                    promotionMap.put("expiryDate", promotion.getEndDate().toString());
                    promotionMap.put("link", "/promotions/" + promotion.getId());
                    return promotionMap;
                })
                .collect(Collectors.toList());
    }

    /**
     * Tìm kiếm gợi ý (cho autocomplete)
     */
    public List<Map<String, String>> getSearchSuggestions(String query) {
        if (query == null || query.trim().isEmpty()) {
            return new ArrayList<>();
        }

        List<Map<String, String>> suggestions = new ArrayList<>();

        // Tìm sản phẩm (tối đa 3) - sử dụng method tối ưu cho suggestions
        List<Product> products = productRepository.findProductSuggestions(query.trim());
        List<Map<String, String>> productSuggestions = products.stream()
                // Loại bỏ filter shop status để test
                // .filter(product -> product.getShop() != null && "APPROVED".equals(product.getShop().getStatus()))
                .filter(product -> product.getShop() != null)
                .limit(3)
                .map(product -> Map.of(
                    "text", product.getName(),
                    "link", "/product/" + product.getId() // Sửa từ /products/ thành /product/
                ))
                .collect(Collectors.toList());

        // Tìm shop (tối đa 2)
        List<Shop> shops = shopRepository.searchShops(query.trim());
        List<Map<String, String>> shopSuggestions = shops.stream()
                // Loại bỏ filter status để test
                // .filter(shop -> "APPROVED".equals(shop.getStatus()))
                .limit(2)
                .map(shop -> Map.of(
                    "text", "Shop: " + shop.getName(),
                    "link", "/shop/" + shop.getId()
                ))
                .collect(Collectors.toList());

        // Tìm mã giảm giá (tối đa 1)
        List<Promotion> promotions = promotionRepository.searchActivePromotions(query.trim(), LocalDate.now());
        List<Map<String, String>> promotionSuggestions = promotions.stream()
                .limit(1)
                .map(promotion -> Map.of(
                    "text", "Mã: " + promotion.getCode() + " - " + promotion.getDescription(),
                    "link", "/promotions/" + promotion.getId()
                ))
                .collect(Collectors.toList());

        // Kết hợp tất cả suggestions
        suggestions.addAll(productSuggestions);
        suggestions.addAll(shopSuggestions);
        suggestions.addAll(promotionSuggestions);

        return suggestions;
    }
}
