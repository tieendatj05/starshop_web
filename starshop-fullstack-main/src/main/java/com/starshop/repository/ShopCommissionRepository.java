package com.starshop.repository;

import com.starshop.entity.Shop;
import com.starshop.entity.ShopCommission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ShopCommissionRepository extends JpaRepository<ShopCommission, Integer> {

    Optional<ShopCommission> findByShopAndCommissionMonthAndCommissionYear(Shop shop, Integer month, Integer year);

    List<ShopCommission> findByShopOrderByCommissionYearDescCommissionMonthDesc(Shop shop);

    List<ShopCommission> findByCommissionYearAndCommissionMonthOrderByShopNameAsc(Integer year, Integer month);

    List<ShopCommission> findByStatusOrderByUpdatedAtDesc(String status);

    @Query("SELECT sc FROM ShopCommission sc WHERE sc.shop.id = :shopId ORDER BY sc.commissionYear DESC, sc.commissionMonth DESC")
    List<ShopCommission> findByShopId(@Param("shopId") Integer shopId);

    @Query("SELECT sc FROM ShopCommission sc ORDER BY sc.commissionYear DESC, sc.commissionMonth DESC")
    List<ShopCommission> findAllOrderByYearMonthDesc();
}

