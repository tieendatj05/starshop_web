package com.starshop.service;

import com.starshop.entity.Address;
import com.starshop.entity.User;

import java.util.List;
import java.util.Optional;

public interface AddressService {

    /**
     * Lấy danh sách địa chỉ của một người dùng.
     */
    List<Address> getAddressesForUser(User user);

    /**
     * Lấy một địa chỉ cụ thể theo ID, đảm bảo nó thuộc về đúng người dùng.
     */
    Optional<Address> getAddressById(Integer addressId, User user);

    /**
     * Lưu (thêm mới hoặc cập nhật) một địa chỉ.
     */
    void saveAddress(Address address, User user);

    /**
     * Xóa một địa chỉ theo ID, đảm bảo nó thuộc về đúng người dùng.
     */
    void deleteAddress(Integer addressId, User user);

    /**
     * Đặt một địa chỉ làm địa chỉ mặc định.
     */
    void setDefaultAddress(Integer addressId, User user);
}
