package com.starshop.service;

import com.starshop.dto.ShopCommissionDTO;
import com.starshop.entity.ShopCommission;
import com.starshop.entity.Shop;
import com.starshop.entity.User;

import java.math.BigDecimal;
import java.util.List;

public interface ShopCommissionService {

    ShopCommission createOrUpdateCommission(Integer shopId, Integer month, Integer year, BigDecimal percentage, User admin);

    ShopCommission calculateCommission(Integer shopId, Integer month, Integer year);

    List<ShopCommissionDTO> getAllCommissions();

    List<ShopCommissionDTO> getCommissionsByShop(Integer shopId);

    ShopCommissionDTO getCommissionById(Integer id);

    ShopCommissionDTO getCurrentMonthCommission(Integer shopId);

    void markAsPaid(Integer commissionId);

    List<ShopCommissionDTO> getCommissionsByMonthAndYear(Integer month, Integer year);
}

