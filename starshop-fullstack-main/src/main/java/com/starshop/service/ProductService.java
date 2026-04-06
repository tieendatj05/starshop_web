package com.starshop.service;

import com.starshop.dto.ProductDTO;
import com.starshop.entity.Product;
import com.starshop.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

public interface ProductService {
    List<Product> findAll();
    Optional<Product> findById(Integer id);
    List<Product> findTop8BestSellingProducts();

    /**
     * Lấy tất cả sản phẩm trong hệ thống (dành cho Admin).
     * @return Danh sách tất cả sản phẩm.
     */
    List<Product> findAllProducts();

    /**
     * Lấy tất cả sản phẩm của một người bán cụ thể.
     * @param vendor Người bán.
     * @return Danh sách sản phẩm của người bán đó.
     */
    List<Product> findByVendor(User vendor);

    /**
     * Thay đổi trạng thái hiển thị của sản phẩm (ẩn/hiện).
     * @param productId ID của sản phẩm.
     */
    void toggleProductVisibility(Integer productId);

    /**
     * Lưu một sản phẩm (thêm mới hoặc cập nhật).
     * @param product Sản phẩm cần lưu.
     */
    Product save(Product product);

    /**
     * Xóa một sản phẩm theo ID.
     * @param id ID của sản phẩm cần xóa.
     */
    void deleteById(Integer id);

    /**
     * Lấy danh sách sản phẩm đang có giảm giá.
     * @param pageable Thông tin phân trang.
     * @return Page chứa các sản phẩm đang giảm giá.
     */
    Page<Product> findDiscountedProducts(Pageable pageable);

    /**
     * Tìm kiếm sản phẩm theo từ khóa trong tên, mô tả, hoặc tên shop.
     * @param keyword Từ khóa tìm kiếm.
     * @return Danh sách sản phẩm phù hợp.
     */
    List<Product> searchProducts(String keyword);

    // New methods for Vendor Product Management

    /**
     * Lưu một sản phẩm cho người bán (thêm mới hoặc cập nhật), đảm bảo quyền sở hữu.
     * @param product Sản phẩm cần lưu.
     * @param vendor Người bán thực hiện thao tác.
     * @return Sản phẩm đã được lưu.
     * @throws SecurityException nếu người bán không có quyền với sản phẩm/shop.
     */
    Product saveProductForVendor(Product product, User vendor);

    /**
     * Tìm một sản phẩm theo ID và đảm bảo nó thuộc về người bán cụ thể.
     * @param productId ID của sản phẩm.
     * @param vendor Người bán.
     * @return Optional chứa sản phẩm nếu tìm thấy và thuộc về người bán.
     */
    Optional<Product> findByIdAndVendor(Integer productId, User vendor);

    /**
     * Thay đổi trạng thái hiển thị của sản phẩm (ẩn/hiện) cho người bán, đảm bảo quyền sở hữu.
     * @param productId ID của sản phẩm.
     * @param vendor Người bán thực hiện thao tác.
     * @throws SecurityException nếu người bán không có quyền với sản phẩm.
     */
    void toggleProductVisibilityForVendor(Integer productId, User vendor);

    /**
     * Xóa một sản phẩm cho người bán, đảm bảo quyền sở hữu.
     * @param productId ID của sản phẩm cần xóa.
     * @param vendor Người bán thực hiện thao tác.
     * @throws SecurityException nếu người bán không có quyền với sản phẩm.
     */
    void deleteProductForVendor(Integer productId, User vendor);

    // New methods for Product Listing with Pagination and Sorting

    /**
     * Lấy danh sách sản phẩm có phân trang và sắp xếp.
     * @param categorySlug Slug của danh mục (có thể null để lấy tất cả).
     * @param pageable Đối tượng Pageable chứa thông tin phân trang và sắp xếp.
     * @return Trang sản phẩm.
     */
    Page<Product> findProducts(String categorySlug, Pageable pageable);

    /**
     * Lấy danh sách sản phẩm yêu thích của người dùng có phân trang.
     * @param user Người dùng hiện tại.
     * @param pageable Đối tượng Pageable chứa thông tin phân trang.
     * @return Trang sản phẩm yêu thích.
     */
    Page<Product> findWishlistedProducts(User user, Pageable pageable);

    /**
     * Tìm một sản phẩm theo ID và trả về dưới dạng ProductDTO.
     * @param id ID của sản phẩm.
     * @return Optional chứa ProductDTO nếu tìm thấy.
     */
    Optional<ProductDTO> findProductDTOById(Integer id);

    /**
     * Lấy danh sách sản phẩm của một shop cụ thể.
     * @param shopId ID của shop.
     * @return Danh sách sản phẩm thuộc shop đó.
     */
    List<Product> getProductsByShopId(Long shopId);
}
