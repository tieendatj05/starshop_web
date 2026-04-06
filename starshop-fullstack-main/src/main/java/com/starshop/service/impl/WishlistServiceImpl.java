package com.starshop.service.impl;

import com.starshop.entity.Product;
import com.starshop.entity.User;
import com.starshop.entity.Wishlist;
import com.starshop.repository.ProductRepository;
import com.starshop.repository.UserRepository;
import com.starshop.repository.WishlistRepository;
import com.starshop.service.WishlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class WishlistServiceImpl implements WishlistService {

    @Autowired
    private WishlistRepository wishlistRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @Override
    public void addToWishlist(Integer userId, Integer productId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Product not found with ID: " + productId));

        if (!wishlistRepository.existsByUserAndProduct(user, product)) {
            Wishlist wishlistItem = new Wishlist(user, product);
            wishlistRepository.save(wishlistItem);
        }
    }

    @Override
    public void removeFromWishlist(Integer userId, Integer productId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Product not found with ID: " + productId));

        wishlistRepository.findByUserAndProduct(user, product)
                .ifPresent(wishlistItem -> wishlistRepository.delete(wishlistItem));
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isProductInWishlist(Integer userId, Integer productId) {
        if (userId == null) {
            return false;
        }
        User user = userRepository.findById(userId).orElse(null);
        Product product = productRepository.findById(productId).orElse(null);

        if (user == null || product == null) {
            return false;
        }

        return wishlistRepository.existsByUserAndProduct(user, product);
    }
}
