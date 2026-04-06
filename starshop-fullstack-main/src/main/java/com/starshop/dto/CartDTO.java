package com.starshop.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class CartDTO {
    private Integer cartId;
    private List<CartItemDTO> items;
    private BigDecimal totalAmount; // Tổng tiền của các sản phẩm hợp lệ trong giỏ
    private boolean checkoutAllowed = true; // Cho phép thanh toán hay không

    // Manual getter/setter methods to ensure compilation works
    public Integer getCartId() {
        return cartId;
    }

    public void setCartId(Integer cartId) {
        this.cartId = cartId;
    }

    public List<CartItemDTO> getItems() {
        return items;
    }

    public void setItems(List<CartItemDTO> items) {
        this.items = items;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public boolean isCheckoutAllowed() {
        return checkoutAllowed;
    }

    public void setCheckoutAllowed(boolean checkoutAllowed) {
        this.checkoutAllowed = checkoutAllowed;
    }
}
