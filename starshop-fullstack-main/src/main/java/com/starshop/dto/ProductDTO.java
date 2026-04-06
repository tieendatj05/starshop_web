package com.starshop.dto;

import com.starshop.entity.Product;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductDTO {
    private Integer id;
    private String name;
    private String imageUrl;
    private BigDecimal price;
    private BigDecimal discountedPrice;
    private int stock;
    private boolean active;
    private ShopDTO shop; // Sử dụng ShopDTO
    private CategoryDTO category; // Sử dụng CategoryDTO

    // Thêm getter/setter methods thủ công để đảm bảo compatibility
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public BigDecimal getDiscountedPrice() { return discountedPrice; }
    public void setDiscountedPrice(BigDecimal discountedPrice) { this.discountedPrice = discountedPrice; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public ShopDTO getShop() { return shop; }
    public void setShop(ShopDTO shop) { this.shop = shop; }

    public CategoryDTO getCategory() { return category; }
    public void setCategory(CategoryDTO category) { this.category = category; }

    public static ProductDTO fromEntity(Product product) {
        if (product == null) {
            return null;
        }
        ProductDTO dto = new ProductDTO();
        dto.setId(product.getId());
        dto.setName(product.getName());
        dto.setImageUrl(product.getImageUrl());
        dto.setPrice(product.getPrice());
        dto.setDiscountedPrice(product.getDiscountedPrice());
        dto.setStock(product.getStock());
        dto.setActive(product.isActive());
        // Chuyển đổi Shop và Category sang DTO
        if (product.getShop() != null) {
            dto.setShop(ShopDTO.fromEntity(product.getShop()));
        }
        if (product.getCategory() != null) {
            dto.setCategory(CategoryDTO.fromEntity(product.getCategory()));
        }
        return dto;
    }
}
