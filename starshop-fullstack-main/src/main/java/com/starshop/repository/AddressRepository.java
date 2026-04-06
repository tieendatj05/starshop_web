package com.starshop.repository;

import com.starshop.entity.Address;
import com.starshop.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AddressRepository extends JpaRepository<Address, Integer> {

    /**
     * Tìm tất cả các địa chỉ của một người dùng cụ thể.
     * @param user Người dùng.
     * @return Danh sách các địa chỉ.
     */
    List<Address> findByUser(User user);
}
