package com.starshop.dto;

import com.starshop.entity.Promotion;
import com.starshop.entity.Shop;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PromotionDTO {
    private Integer id;
    private String code;
    private String description;
    private Double discountPercentage;
    private BigDecimal maxDiscountAmount;
    private LocalDate startDate;
    private LocalDate endDate;
    private Boolean isActive;
    private Shop shop;

    // Manual getters and setters to ensure compilation works
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Double getDiscountPercentage() { return discountPercentage; }
    public void setDiscountPercentage(Double discountPercentage) { this.discountPercentage = discountPercentage; }

    public BigDecimal getMaxDiscountAmount() { return maxDiscountAmount; }
    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) { this.maxDiscountAmount = maxDiscountAmount; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public Boolean getActive() { return isActive; }
    public void setActive(Boolean active) { isActive = active; }

    public Shop getShop() { return shop; }
    public void setShop(Shop shop) { this.shop = shop; }

    // Thêm helper methods để format ngày
    public String getFormattedStartDate() {
        return startDate != null ? startDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "";
    }

    public String getFormattedEndDate() {
        return endDate != null ? endDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "";
    }

    public static PromotionDTO fromEntity(Promotion entity) {
        PromotionDTO dto = new PromotionDTO();
        dto.setId(entity.getId());
        dto.setCode(entity.getCode());
        dto.setDescription(entity.getDescription());
        dto.setDiscountPercentage(entity.getDiscountPercentage());
        dto.setMaxDiscountAmount(entity.getMaxDiscountAmount());
        dto.setStartDate(entity.getStartDate());
        dto.setEndDate(entity.getEndDate());
        dto.setActive(entity.getIsActive());
        dto.setShop(entity.getShop());
        return dto;
    }
}
