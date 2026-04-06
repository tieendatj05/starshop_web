package com.starshop.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "shipping_carriers")
public class ShippingCarrier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    private String phone;

    private String website;

    @Column(name = "shipping_fee", nullable = false)
    private BigDecimal shippingFee;

    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;

    // Manual getter/setter methods to ensure compilation works
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    // Getter tường minh để JSP EL có thể truy cập
    // Cách 1: Dành cho EL tìm kiếm theo quy tắc is<PropertyName>
    public boolean isActive() {
        return this.isActive;
    }

    // Cách 2: Dành cho EL tìm kiếm theo quy tắc get<PropertyName>
    public boolean getIsActive() {
        return this.isActive;
    }

    // Add missing setter method
    public void setActive(boolean active) {
        this.isActive = active;
    }
}
