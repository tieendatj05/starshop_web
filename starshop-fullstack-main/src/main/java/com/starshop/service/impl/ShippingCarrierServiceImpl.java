package com.starshop.service.impl;

import com.starshop.entity.ShippingCarrier;
import com.starshop.repository.ShippingCarrierRepository;
import com.starshop.service.ShippingCarrierService;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@Transactional
public class ShippingCarrierServiceImpl implements ShippingCarrierService {

    // Manual log declaration to ensure compilation works
    private static final Logger log = LoggerFactory.getLogger(ShippingCarrierServiceImpl.class);

    @Autowired
    private ShippingCarrierRepository shippingCarrierRepository;

    @Override
    @Transactional(readOnly = true)
    public List<ShippingCarrier> findAll() {
        List<ShippingCarrier> carriers = shippingCarrierRepository.findAll();
        log.info("ShippingCarrierService.findAll() trả về {} nhà vận chuyển.", carriers.size());
        return carriers;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ShippingCarrier> findByIsActiveTrue() {
        List<ShippingCarrier> activeCarriers = shippingCarrierRepository.findByIsActiveTrue();
        log.info("ShippingCarrierService.findByIsActiveTrue() trả về {} nhà vận chuyển đang hoạt động.", activeCarriers.size());
        return activeCarriers;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<ShippingCarrier> findById(Long id) {
        return shippingCarrierRepository.findById(id);
    }

    @Override
    public ShippingCarrier save(ShippingCarrier carrier) {
        return shippingCarrierRepository.save(carrier);
    }

    @Override
    public void deleteById(Long id) {
        shippingCarrierRepository.deleteById(id);
    }

    @Override
    public void toggleActiveStatus(Long id) {
        ShippingCarrier carrier = shippingCarrierRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Nhà vận chuyển không tồn tại với ID: " + id));
        carrier.setActive(!carrier.isActive()); // Đảo ngược trạng thái
        shippingCarrierRepository.save(carrier);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ShippingCarrier> search(String keyword) {
        return shippingCarrierRepository.search(keyword);
    }
}
