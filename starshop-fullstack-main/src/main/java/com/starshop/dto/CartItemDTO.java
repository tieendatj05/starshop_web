package com.starshop.dto;

import com.starshop.entity.Product;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class CartItemDTO {
    private Integer cartItemId;
    private ProductDTO product;
    private int quantity;
    private BigDecimal subtotal;
    private boolean valid = true; // Mặc định là hợp lệ
    private String invalidReason;   // Lý do không hợp lệ nếu valid = false

    // Manual getter/setter methods to ensure compilation works
    public Integer getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(Integer cartItemId) {
        this.cartItemId = cartItemId;
    }

    public ProductDTO getProduct() {
        return product;
    }

    public void setProduct(ProductDTO product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public boolean isValid() {
        return valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public String getInvalidReason() {
        return invalidReason;
    }

    public void setInvalidReason(String invalidReason) {
        this.invalidReason = invalidReason;
    }
}
