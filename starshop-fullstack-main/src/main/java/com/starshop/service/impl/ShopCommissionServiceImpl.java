package com.starshop.service.impl;

import com.starshop.constant.OrderStatus;
import com.starshop.dto.ShopCommissionDTO;
import com.starshop.entity.*;
import com.starshop.repository.*;
import com.starshop.service.ShopCommissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ShopCommissionServiceImpl implements ShopCommissionService {

    @Autowired
    private ShopCommissionRepository shopCommissionRepository;

    @Autowired
    private ShopCommissionTransactionRepository transactionRepository;

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Override
    @Transactional
    public ShopCommission createOrUpdateCommission(Integer shopId, Integer month, Integer year, BigDecimal percentage, User admin) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new RuntimeException("Shop không tồn tại"));

        ShopCommission commission = shopCommissionRepository
                .findByShopAndCommissionMonthAndCommissionYear(shop, month, year)
                .orElse(new ShopCommission(shop, month, year, percentage));

        commission.setCommissionPercentage(percentage);
        commission.setCreatedBy(admin);
        commission.setUpdatedAt(LocalDateTime.now());

        return shopCommissionRepository.save(commission);
    }

    @Override
    @Transactional
    public ShopCommission calculateCommission(Integer shopId, Integer month, Integer year) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new RuntimeException("Shop không tồn tại"));

        ShopCommission commission = shopCommissionRepository
                .findByShopAndCommissionMonthAndCommissionYear(shop, month, year)
                .orElseThrow(() -> new RuntimeException("Chưa thiết lập tỷ lệ chiết khấu cho tháng này"));

        // Tính toán doanh thu từ các đơn hàng
        YearMonth yearMonth = YearMonth.of(year, month);
        LocalDateTime startDate = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime endDate = yearMonth.atEndOfMonth().atTime(23, 59, 59);

        // Lấy tất cả đơn hàng đã hoàn thành của shop trong tháng
        List<Order> orders = orderRepository.findAll().stream()
                .filter(order -> {
                    if (order.getCreatedAt() == null) return false;
                    LocalDateTime orderDate = order.getCreatedAt();
                    return orderDate.isAfter(startDate) && orderDate.isBefore(endDate)
                            && OrderStatus.DELIVERED_SUCCESS.equals(order.getStatus());
                })
                .collect(Collectors.toList());

        // Lọc đơn hàng thuộc shop
        List<Order> shopOrders = new ArrayList<>();
        for (Order order : orders) {
            List<OrderDetail> details = orderDetailRepository.findByOrderId(order.getId());
            boolean belongsToShop = details.stream()
                    .anyMatch(detail -> detail.getProduct().getShop().getId().equals(shopId));
            if (belongsToShop) {
                shopOrders.add(order);
            }
        }

        BigDecimal totalRevenue = BigDecimal.ZERO;
        int totalOrders = shopOrders.size();

        // Xóa các transaction cũ
        transactionRepository.deleteAll(commission.getTransactions());
        commission.getTransactions().clear();

        for (Order order : shopOrders) {
            List<OrderDetail> details = orderDetailRepository.findByOrderId(order.getId());
            BigDecimal orderAmount = BigDecimal.ZERO;

            // Tính tổng giá trị sản phẩm của shop trong đơn hàng
            for (OrderDetail detail : details) {
                if (detail.getProduct().getShop().getId().equals(shopId)) {
                    BigDecimal itemTotal = detail.getPrice().multiply(BigDecimal.valueOf(detail.getQuantity()));
                    orderAmount = orderAmount.add(itemTotal);
                }
            }

            // Trừ đi số tiền giảm giá nếu promotion thuộc shop này
            if (order.getPromotion() != null &&
                    order.getPromotion().getShop() != null &&
                    order.getPromotion().getShop().getId().equals(shopId)) {

                // Trừ đi discount_amount của shop
                if (order.getDiscountAmount() != null) {
                    orderAmount = orderAmount.subtract(order.getDiscountAmount());
                }
            }

            // Đảm bảo orderAmount không âm
            if (orderAmount.compareTo(BigDecimal.ZERO) < 0) {
                orderAmount = BigDecimal.ZERO;
            }

            totalRevenue = totalRevenue.add(orderAmount);

            // Tạo transaction cho mỗi đơn hàng
            BigDecimal commissionAmount = orderAmount
                    .multiply(commission.getCommissionPercentage())
                    .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);

            ShopCommissionTransaction transaction = new ShopCommissionTransaction(
                    commission, order, orderAmount, commission.getCommissionPercentage(), commissionAmount
            );
            commission.getTransactions().add(transaction);
        }

        // Cập nhật thông tin commission
        commission.setTotalOrders(totalOrders);
        commission.setTotalRevenue(totalRevenue);
        commission.setCommissionAmount(
                totalRevenue.multiply(commission.getCommissionPercentage())
                        .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP)
        );
        commission.setNetAmount(totalRevenue.subtract(commission.getCommissionAmount()));
        commission.setStatus(ShopCommission.STATUS_CALCULATED);
        commission.setUpdatedAt(LocalDateTime.now());

        return shopCommissionRepository.save(commission);
    }

    @Override
    public List<ShopCommissionDTO> getAllCommissions() {
        return shopCommissionRepository.findAllOrderByYearMonthDesc().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public List<ShopCommissionDTO> getCommissionsByShop(Integer shopId) {
        return shopCommissionRepository.findByShopId(shopId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public ShopCommissionDTO getCommissionById(Integer id) {
        return shopCommissionRepository.findById(id)
                .map(this::convertToDTO)
                .orElse(null);
    }

    @Override
    public ShopCommissionDTO getCurrentMonthCommission(Integer shopId) {
        Shop shop = shopRepository.findById(shopId).orElse(null);
        if (shop == null) return null;

        LocalDateTime now = LocalDateTime.now();
        return shopCommissionRepository
                .findByShopAndCommissionMonthAndCommissionYear(shop, now.getMonthValue(), now.getYear())
                .map(this::convertToDTO)
                .orElse(null);
    }

    @Override
    @Transactional
    public void markAsPaid(Integer commissionId) {
        ShopCommission commission = shopCommissionRepository.findById(commissionId)
                .orElseThrow(() -> new RuntimeException("Commission không tồn tại"));
        commission.setStatus(ShopCommission.STATUS_PAID);
        commission.setUpdatedAt(LocalDateTime.now());
        shopCommissionRepository.save(commission);
    }

    @Override
    public List<ShopCommissionDTO> getCommissionsByMonthAndYear(Integer month, Integer year) {
        return shopCommissionRepository.findByCommissionYearAndCommissionMonthOrderByShopNameAsc(year, month).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private ShopCommissionDTO convertToDTO(ShopCommission commission) {
        ShopCommissionDTO dto = new ShopCommissionDTO();
        dto.setId(commission.getId());
        dto.setShopId(commission.getShop().getId());
        dto.setShopName(commission.getShop().getName());
        dto.setCommissionMonth(commission.getCommissionMonth());
        dto.setCommissionYear(commission.getCommissionYear());
        dto.setCommissionPercentage(commission.getCommissionPercentage());
        dto.setTotalOrders(commission.getTotalOrders());
        dto.setTotalRevenue(commission.getTotalRevenue());
        dto.setCommissionAmount(commission.getCommissionAmount());
        dto.setNetAmount(commission.getNetAmount());
        dto.setStatus(commission.getStatus());
        if (commission.getCreatedBy() != null) {
            dto.setCreatedByName(commission.getCreatedBy().getFullName());
        }
        dto.setCreatedAt(commission.getCreatedAt());
        dto.setUpdatedAt(commission.getUpdatedAt());
        return dto;
    }
}
