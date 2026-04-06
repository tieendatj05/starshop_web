package com.starshop.repository;

import com.starshop.entity.OrderDetail;
import com.starshop.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderDetailRepository extends JpaRepository<OrderDetail, Long> {
    void deleteByProduct(Product product);

    List<OrderDetail> findByOrderId(Integer orderId);
}
