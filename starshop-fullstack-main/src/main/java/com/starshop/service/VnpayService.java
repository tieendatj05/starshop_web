package com.starshop.service;

import com.starshop.dto.CheckoutInfoDTO;
import com.starshop.entity.User;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Map;

public interface VnpayService {
    String createPaymentUrl(User user, CheckoutInfoDTO checkoutInfo, HttpServletRequest request);

    Map<String, String> handleVnpayReturn(HttpServletRequest request);
}
