package com.starshop.dto;

import com.starshop.entity.Product;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Data
public class VendorDashboardStatsDTO {
    private BigDecimal revenueToday;
    private BigDecimal revenueThisWeek;
    private BigDecimal revenueThisMonth;
    private List<Product> bestSellingProducts;
    private Map<String, BigDecimal> weeklyRevenueChartData;

    // Thông tin chiết khấu tháng hiện tại
    private BigDecimal currentMonthCommissionRate;
    private BigDecimal currentMonthCommissionAmount;
    private BigDecimal currentMonthNetAmount;
    private Integer currentMonthTotalOrders;

    // Manual getter/setter methods to ensure compilation works
    public BigDecimal getRevenueToday() {
        return revenueToday;
    }

    public void setRevenueToday(BigDecimal revenueToday) {
        this.revenueToday = revenueToday;
    }

    public BigDecimal getRevenueThisWeek() {
        return revenueThisWeek;
    }

    public void setRevenueThisWeek(BigDecimal revenueThisWeek) {
        this.revenueThisWeek = revenueThisWeek;
    }

    public BigDecimal getRevenueThisMonth() {
        return revenueThisMonth;
    }

    public void setRevenueThisMonth(BigDecimal revenueThisMonth) {
        this.revenueThisMonth = revenueThisMonth;
    }

    public List<Product> getBestSellingProducts() {
        return bestSellingProducts;
    }

    public void setBestSellingProducts(List<Product> bestSellingProducts) {
        this.bestSellingProducts = bestSellingProducts;
    }

    public Map<String, BigDecimal> getWeeklyRevenueChartData() {
        return weeklyRevenueChartData;
    }

    public void setWeeklyRevenueChartData(Map<String, BigDecimal> weeklyRevenueChartData) {
        this.weeklyRevenueChartData = weeklyRevenueChartData;
    }

    public BigDecimal getCurrentMonthCommissionRate() {
        return currentMonthCommissionRate;
    }

    public void setCurrentMonthCommissionRate(BigDecimal currentMonthCommissionRate) {
        this.currentMonthCommissionRate = currentMonthCommissionRate;
    }

    public BigDecimal getCurrentMonthCommissionAmount() {
        return currentMonthCommissionAmount;
    }

    public void setCurrentMonthCommissionAmount(BigDecimal currentMonthCommissionAmount) {
        this.currentMonthCommissionAmount = currentMonthCommissionAmount;
    }

    public BigDecimal getCurrentMonthNetAmount() {
        return currentMonthNetAmount;
    }

    public void setCurrentMonthNetAmount(BigDecimal currentMonthNetAmount) {
        this.currentMonthNetAmount = currentMonthNetAmount;
    }

    public Integer getCurrentMonthTotalOrders() {
        return currentMonthTotalOrders;
    }

    public void setCurrentMonthTotalOrders(Integer currentMonthTotalOrders) {
        this.currentMonthTotalOrders = currentMonthTotalOrders;
    }
}
