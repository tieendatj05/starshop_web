package com.starshop.service.impl;

import com.starshop.entity.Address;
import com.starshop.entity.User;
import com.starshop.repository.AddressRepository;
import com.starshop.service.AddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AddressServiceImpl implements AddressService {

    @Autowired
    private AddressRepository addressRepository;

    @Override
    @Transactional(readOnly = true)
    public List<Address> getAddressesForUser(User user) {
        return addressRepository.findByUser(user);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Address> getAddressById(Integer addressId, User user) {
        return addressRepository.findById(addressId)
                .filter(address -> address.getUser().getId().equals(user.getId()));
    }

    @Override
    public void saveAddress(Address address, User user) {
        address.setUser(user);
        // Nếu địa chỉ này được đặt làm mặc định, hãy bỏ mặc định tất cả các địa chỉ khác
        if (address.isDefault()) {
            unsetDefaultForOtherAddresses(user, null);
        }
        addressRepository.save(address);
    }

    @Override
    public void deleteAddress(Integer addressId, User user) {
        Address address = getAddressById(addressId, user)
                .orElseThrow(() -> new SecurityException("Bạn không có quyền xóa địa chỉ này."));
        addressRepository.delete(address);
    }

    @Override
    public void setDefaultAddress(Integer addressId, User user) {
        Address addressToSetDefault = getAddressById(addressId, user)
                .orElseThrow(() -> new SecurityException("Bạn không có quyền thay đổi địa chỉ này."));

        // Bỏ mặc định tất cả các địa chỉ khác
        unsetDefaultForOtherAddresses(user, addressId);

        // Đặt địa chỉ này làm mặc định
        addressToSetDefault.setDefault(true);
        addressRepository.save(addressToSetDefault);
    }

    /**
     * Helper method to set isDefault = false for all other addresses of a user.
     * @param user The user.
     * @param excludeAddressId The ID of the address to exclude from this operation (the one being set to default).
     */
    private void unsetDefaultForOtherAddresses(User user, Integer excludeAddressId) {
        List<Address> userAddresses = addressRepository.findByUser(user);
        for (Address addr : userAddresses) {
            if (!addr.getId().equals(excludeAddressId) && addr.isDefault()) {
                addr.setDefault(false);
                addressRepository.save(addr);
            }
        }
    }
}
