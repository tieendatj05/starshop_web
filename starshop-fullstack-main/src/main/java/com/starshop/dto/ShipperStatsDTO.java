package com.starshop.dto;

import lombok.Data;

@Data
public class ShipperStatsDTO {
    private long ordersToday;
    private long ordersThisWeek;
    private long ordersThisMonth;

    // Manual getter/setter methods to ensure compilation works
    public long getOrdersToday() {
        return ordersToday;
    }

    public void setOrdersToday(long ordersToday) {
        this.ordersToday = ordersToday;
    }

    public long getOrdersThisWeek() {
        return ordersThisWeek;
    }

    public void setOrdersThisWeek(long ordersThisWeek) {
        this.ordersThisWeek = ordersThisWeek;
    }

    public long getOrdersThisMonth() {
        return ordersThisMonth;
    }

    public void setOrdersThisMonth(long ordersThisMonth) {
        this.ordersThisMonth = ordersThisMonth;
    }
}
