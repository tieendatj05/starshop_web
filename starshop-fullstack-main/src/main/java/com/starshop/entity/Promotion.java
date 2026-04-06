package com.starshop.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

@Data
@Entity
@Table(name = "Promotions")
public class Promotion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, unique = true)
    private String code;

    @Lob
    private String description;

    @Column(name = "discount_percentage")
    private double discountPercentage;

    @Column(name = "max_discount_amount")
    private BigDecimal maxDiscountAmount;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "is_active")
    private boolean isActive = true;

    @ManyToOne(fetch = FetchType.EAGER) // Changed from LAZY to EAGER
    @JoinColumn(name = "shop_id", nullable = false)
    private Shop shop;

    // Manual getter/setter methods to ensure compilation works
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code; // Đã sửa lỗi đánh máy tại đây
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public BigDecimal getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public Shop getShop() {
        return shop;
    }

    public void setShop(Shop shop) {
        this.shop = shop;
    }

    // Thêm getter thủ công để đảm bảo JSP EL có thể truy cập
    public boolean isActive() {
        return isActive;
    }

    // Thêm getter thứ 2 để chắc chắn tương thích với mọi môi trường EL
    public boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(boolean active) {
        this.isActive = active;
    }

    // Getter chuyển đổi LocalDate sang java.util.Date cho JSTL <fmt:formatDate>
    @Transient // Đánh dấu để Hibernate bỏ qua, không tạo cột trong DB
    public Date getLegacyStartDate() {
        return startDate != null ? Date.from(startDate.atStartOfDay(ZoneId.systemDefault()).toInstant()) : null;
    }

    @Transient // Đánh dấu để Hibernate bỏ qua, không tạo cột trong DB
    public Date getLegacyEndDate() {
        return endDate != null ? Date.from(endDate.atStartOfDay(ZoneId.systemDefault()).toInstant()) : null;
    }

    // Helper method to safely get shop name for JSP
    @Transient
    public String getShopName() {
        return (shop != null && shop.getName() != null) ? shop.getName() : "N/A";
    }
}
