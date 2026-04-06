package com.starshop.repository;

import com.starshop.entity.ShippingCarrier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ShippingCarrierRepository extends JpaRepository<ShippingCarrier, Long> {

    // Sử dụng @Query tường minh để đảm bảo truy vấn đúng cho trường boolean
    @Query("SELECT c FROM ShippingCarrier c WHERE c.isActive = true")
    List<ShippingCarrier> findByIsActiveTrue();

    @Query("SELECT c FROM ShippingCarrier c WHERE LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR c.phone LIKE CONCAT('%', :keyword, '%') OR LOWER(c.website) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<ShippingCarrier> search(@Param("keyword") String keyword);
}
