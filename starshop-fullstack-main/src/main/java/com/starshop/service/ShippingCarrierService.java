package com.starshop.service;

import com.starshop.entity.ShippingCarrier;

import java.util.List;
import java.util.Optional;

public interface ShippingCarrierService {
    List<ShippingCarrier> findAll();

    List<ShippingCarrier> findByIsActiveTrue();

    Optional<ShippingCarrier> findById(Long id);

    ShippingCarrier save(ShippingCarrier shippingCarrier);

    void deleteById(Long id);

    void toggleActiveStatus(Long id);

    List<ShippingCarrier> search(String keyword);
}
