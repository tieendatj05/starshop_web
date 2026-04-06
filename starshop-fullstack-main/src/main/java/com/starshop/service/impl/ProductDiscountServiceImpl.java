package com.starshop.service.impl;

import com.starshop.entity.Product;
import com.starshop.entity.ProductDiscount;
import com.starshop.entity.User;
import com.starshop.repository.ProductDiscountRepository;
import com.starshop.repository.ProductRepository;
import com.starshop.service.ProductDiscountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ProductDiscountServiceImpl implements ProductDiscountService {

    @Autowired
    private ProductDiscountRepository discountRepository;

    @Autowired
    private ProductRepository productRepository;

    @Override
    @Transactional(readOnly = true)
    public List<ProductDiscount> getDiscountsByVendor(User vendor) {
        return discountRepository.findByProduct_Shop_Owner(vendor);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<ProductDiscount> findByIdAndVendor(Integer discountId, User vendor) {
        return discountRepository.findById(discountId)
                .filter(discount -> discount.getProduct().getShop().getOwner().getId().equals(vendor.getId()));
    }

    @Override
    public ProductDiscount saveDiscount(ProductDiscount discount, Integer productId, User vendor) {
        // 1. Fetch a managed Product entity using the provided productId.
        Product managedProduct = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại."));

        // 2. Ensure the product belongs to the vendor
        if (!managedProduct.getShop().getOwner().getId().equals(vendor.getId())) {
            throw new SecurityException("Bạn không có quyền tạo giảm giá cho sản phẩm này.");
        }

        // 3. Set the fetched Product entity to the discount object.
        //    This is crucial to ensure the relationship is correctly handled by JPA.
        discount.setProduct(managedProduct);

        // 4. Save the discount object.
        //    JPA's save method handles both create (if id is null) and update.
        return discountRepository.save(discount);
    }

    @Override
    public void deleteDiscount(Integer discountId, User vendor) {
        ProductDiscount discount = findByIdAndVendor(discountId, vendor)
                .orElseThrow(() -> new SecurityException("Bạn không có quyền xóa chương trình giảm giá này."));
        discountRepository.delete(discount);
    }

    // Admin methods implementation
    @Override
    @Transactional(readOnly = true)
    public List<ProductDiscount> findAllDiscounts() {
        return discountRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<ProductDiscount> findById(Integer id) {
        return discountRepository.findById(id);
    }

    @Override
    public ProductDiscount saveDiscountByAdmin(ProductDiscount discount, Integer productId) {
        if (productId == null) {
            throw new IllegalArgumentException("Sản phẩm không được để trống");
        }

        Product managedProduct = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy sản phẩm"));

        discount.setProduct(managedProduct);
        return discountRepository.save(discount);
    }

    @Override
    public void deleteDiscountByAdmin(Integer id) {
        ProductDiscount discount = discountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy chương trình giảm giá"));
        discountRepository.delete(discount);
    }

    @Override
    public void toggleDiscountStatus(Integer id) {
        ProductDiscount discount = discountRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy chương trình giảm giá"));
        discount.setActive(!discount.isActive());
        discountRepository.save(discount);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ProductDiscount> searchDiscounts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAllDiscounts();
        }

        return discountRepository.findAll().stream()
                .filter(d -> {
                    String lowerKeyword = keyword.toLowerCase();
                    return (d.getProduct() != null && d.getProduct().getName().toLowerCase().contains(lowerKeyword))
                            || (d.getProduct() != null && d.getProduct().getShop() != null
                                && d.getProduct().getShop().getName().toLowerCase().contains(lowerKeyword));
                })
                .collect(java.util.stream.Collectors.toList());
    }
}
