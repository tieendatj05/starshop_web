package com.starshop.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Map;

@Data
public class AdminDashboardStatsDTO {
    private long totalUsers;
    private long totalShops;
    private long pendingShopRequests;
    private long totalOrders;
    private BigDecimal totalRevenue;
    private Map<String, BigDecimal> monthlyRevenueChartData;
    private long pendingAppealsCount; // Thêm trường này

    // Manual getter/setter methods to ensure compilation works
    public long getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(long totalUsers) {
        this.totalUsers = totalUsers;
    }

    public long getTotalShops() {
        return totalShops;
    }

    public void setTotalShops(long totalShops) {
        this.totalShops = totalShops;
    }

    public long getPendingShopRequests() {
        return pendingShopRequests;
    }

    public void setPendingShopRequests(long pendingShopRequests) {
        this.pendingShopRequests = pendingShopRequests;
    }

    public long getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(long totalOrders) {
        this.totalOrders = totalOrders;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public Map<String, BigDecimal> getMonthlyRevenueChartData() {
        return monthlyRevenueChartData;
    }

    public void setMonthlyRevenueChartData(Map<String, BigDecimal> monthlyRevenueChartData) {
        this.monthlyRevenueChartData = monthlyRevenueChartData;
    }

    public long getPendingAppealsCount() {
        return pendingAppealsCount;
    }

    public void setPendingAppealsCount(long pendingAppealsCount) {
        this.pendingAppealsCount = pendingAppealsCount;
    }
}
