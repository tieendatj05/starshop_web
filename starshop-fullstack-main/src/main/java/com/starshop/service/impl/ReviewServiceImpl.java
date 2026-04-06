package com.starshop.service.impl;

import com.starshop.constant.OrderStatus;
import com.starshop.entity.Order;
import com.starshop.entity.Product;
import com.starshop.entity.Review;
import com.starshop.entity.User;
import com.starshop.repository.OrderRepository;
import com.starshop.repository.ProductRepository;
import com.starshop.repository.ReviewRepository;
import com.starshop.service.ReviewService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private UserService userService; // Inject UserService

    @Override
    public void saveReview(Review review, User user) {
        Integer productId = review.getProduct().getId();

        if (!canUserReviewProduct(user.getId(), productId)) {
            throw new IllegalStateException("Bạn không thể đánh giá sản phẩm này vì bạn chưa mua hoặc đơn hàng chưa được giao thành công.");
        }

        if (hasUserReviewedProduct(user.getId(), productId)) {
            throw new IllegalStateException("Bạn đã đánh giá sản phẩm này rồi.");
        }

        review.setUser(user);
        reviewRepository.save(review);

        // After saving, update the product's average rating
        updateProductReviewStats(productId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Review> getReviewsByProductId(Integer productId) {
        return reviewRepository.findByProductId(productId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasUserReviewedProduct(Integer userId, Integer productId) {
        User user = userService.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại với ID: " + userId));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại với ID: " + productId));
        return reviewRepository.existsByUserAndProduct(user, product);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean canUserReviewProduct(Integer userId, Integer productId) {
        // Sử dụng phương thức mới từ OrderRepository để kiểm tra hiệu quả hơn
        return orderRepository.existsByUserIdAndProductIdAndStatus(userId, productId, OrderStatus.DELIVERED_SUCCESS);
    }

    private void updateProductReviewStats(Integer productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại."));

        List<Review> reviews = reviewRepository.findByProductId(productId);

        if (reviews.isEmpty()) {
            product.setAverageRating(0.0);
            product.setReviewCount(0);
        } else {
            double average = reviews.stream()
                    .mapToInt(Review::getRating)
                    .average()
                    .orElse(0.0);
            product.setAverageRating(average);
            product.setReviewCount(reviews.size());
        }

        productRepository.save(product);
    }
}
