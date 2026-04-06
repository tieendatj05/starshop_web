package com.starshop.repository;

import com.starshop.entity.ShopCommissionTransaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ShopCommissionTransactionRepository extends JpaRepository<ShopCommissionTransaction, Long> {

    List<ShopCommissionTransaction> findByCommissionId(Integer commissionId);

    @Query("SELECT sct FROM ShopCommissionTransaction sct WHERE sct.commission.id = :commissionId ORDER BY sct.transactionDate DESC")
    List<ShopCommissionTransaction> findByCommissionIdOrderByDateDesc(@Param("commissionId") Integer commissionId);
}

