package com.starshop.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ApplyDiscountRequestDTO {
    private String discountCode;
    private BigDecimal currentCartTotal;
}
