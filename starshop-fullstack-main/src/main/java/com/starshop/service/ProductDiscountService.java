package com.starshop.service;

import com.starshop.entity.ProductDiscount;
import com.starshop.entity.User;

import java.util.List;
import java.util.Optional;

public interface ProductDiscountService {

    /**
     * Lấy tất cả các chương trình giảm giá của một người bán.
     * @param vendor Người bán.
     * @return Danh sách các chương trình giảm giá.
     */
    List<ProductDiscount> getDiscountsByVendor(User vendor);

    /**
     * Lấy một chương trình giảm giá cụ thể theo ID, đảm bảo nó thuộc về đúng người bán.
     * @param discountId ID của chương trình giảm giá.
     * @param vendor Người bán.
     * @return Optional chứa chương trình giảm giá nếu tìm thấy.
     */
    Optional<ProductDiscount> findByIdAndVendor(Integer discountId, User vendor);

    /**
     * Lưu (thêm mới hoặc cập nhật) một chương trình giảm giá.
     * @param discount Chương trình giảm giá cần lưu.
     * @param productId ID của sản phẩm áp dụng giảm giá.
     * @param vendor Người bán thực hiện.
     * @return Chương trình giảm giá đã được lưu.
     */
    ProductDiscount saveDiscount(ProductDiscount discount, Integer productId, User vendor);

    /**
     * Xóa một chương trình giảm giá.
     * @param discountId ID của chương trình giảm giá cần xóa.
     * @param vendor Người bán thực hiện.
     */
    void deleteDiscount(Integer discountId, User vendor);

    // Admin methods
    /**
     * Lấy tất cả các chương trình giảm giá trong hệ thống.
     * @return Danh sách tất cả các chương trình giảm giá.
     */
    List<ProductDiscount> findAllDiscounts();

    /**
     * Tìm chương trình giảm giá theo ID.
     * @param id ID của chương trình giảm giá.
     * @return Optional chứa chương trình giảm giá nếu tìm thấy.
     */
    Optional<ProductDiscount> findById(Integer id);

    /**
     * Lưu chương trình giảm giá bởi admin.
     * @param discount Chương trình giảm giá cần lưu.
     * @param productId ID của sản phẩm.
     * @return Chương trình giảm giá đã được lưu.
     */
    ProductDiscount saveDiscountByAdmin(ProductDiscount discount, Integer productId);

    /**
     * Xóa chương trình giảm giá bởi admin.
     * @param id ID của chương trình giảm giá cần xóa.
     */
    void deleteDiscountByAdmin(Integer id);

    /**
     * Bật/tắt trạng thái chương trình giảm giá.
     * @param id ID của chương trình giảm giá.
     */
    void toggleDiscountStatus(Integer id);

    /**
     * Tìm kiếm chương trình giảm giá.
     * @param keyword Từ khóa tìm kiếm.
     * @return Danh sách các chương trình giảm giá phù hợp.
     */
    List<ProductDiscount> searchDiscounts(String keyword);
}
