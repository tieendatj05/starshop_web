package com.starshop.dto;

import lombok.Data;

@Data
public class CheckoutInfoDTO {

    // ID của địa chỉ đã được chọn từ sổ địa chỉ
    private Integer selectedAddressId;

    // Thông tin nếu người dùng nhập địa chỉ mới
    private String newRecipientName;
    private String newPhoneNumber;
    private String newDetailAddress;
    private String newCity;

    // ID của nhà vận chuyển đã chọn
    private Integer shippingCarrierId;

    // Phương thức thanh toán
    private String paymentMethod;

    // Mã giảm giá được áp dụng
    private String discountCode;

    // Manual getter/setter methods to ensure compilation works
    public Integer getSelectedAddressId() {
        return selectedAddressId;
    }

    public void setSelectedAddressId(Integer selectedAddressId) {
        this.selectedAddressId = selectedAddressId;
    }

    public String getNewRecipientName() {
        return newRecipientName;
    }

    public void setNewRecipientName(String newRecipientName) {
        this.newRecipientName = newRecipientName;
    }

    public String getNewPhoneNumber() {
        return newPhoneNumber;
    }

    public void setNewPhoneNumber(String newPhoneNumber) {
        this.newPhoneNumber = newPhoneNumber;
    }

    public String getNewDetailAddress() {
        return newDetailAddress;
    }

    public void setNewDetailAddress(String newDetailAddress) {
        this.newDetailAddress = newDetailAddress;
    }

    public String getNewCity() {
        return newCity;
    }

    public void setNewCity(String newCity) {
        this.newCity = newCity;
    }

    public Integer getShippingCarrierId() {
        return shippingCarrierId;
    }

    public void setShippingCarrierId(Integer shippingCarrierId) {
        this.shippingCarrierId = shippingCarrierId;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getDiscountCode() {
        return discountCode;
    }

    public void setDiscountCode(String discountCode) {
        this.discountCode = discountCode;
    }
}
