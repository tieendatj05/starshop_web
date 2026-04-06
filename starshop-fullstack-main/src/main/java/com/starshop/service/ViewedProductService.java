package com.starshop.service;

import com.starshop.entity.Product;
import com.starshop.entity.User;
import com.starshop.entity.ViewedProduct;
import com.starshop.repository.ViewedProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class ViewedProductService {

    private final ViewedProductRepository viewedProductRepository;

    @Autowired
    public ViewedProductService(ViewedProductRepository viewedProductRepository) {
        this.viewedProductRepository = viewedProductRepository;
    }

    public void addViewedProduct(User user, Product product) {
        // Chỉ sử dụng constructor mặc định vì Lombok có thể có vấn đề
        ViewedProduct viewedProduct = new ViewedProduct();
        // Sử dụng reflection hoặc tạo constructor thủ công
        try {
            java.lang.reflect.Field userField = ViewedProduct.class.getDeclaredField("user");
            userField.setAccessible(true);
            userField.set(viewedProduct, user);

            java.lang.reflect.Field productField = ViewedProduct.class.getDeclaredField("product");
            productField.setAccessible(true);
            productField.set(viewedProduct, product);

            viewedProductRepository.save(viewedProduct);
        } catch (Exception e) {
            throw new RuntimeException("Error creating ViewedProduct", e);
        }
    }

    public Page<ViewedProduct> findViewedProductsByUser(User user, Pageable pageable) {
        return viewedProductRepository.findByUserOrderByViewedAtDesc(user, pageable);
    }
}
