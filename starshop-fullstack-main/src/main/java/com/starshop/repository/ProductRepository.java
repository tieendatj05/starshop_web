package com.starshop.repository;

import com.starshop.entity.Product;
import com.starshop.entity.Shop;
import com.starshop.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, Integer> {

    @Query("SELECT p FROM Product p WHERE p.active = true ORDER BY p.soldCount DESC LIMIT 8")
    List<Product> findTop8BestSellingProducts();

    @Query("SELECT p FROM Product p JOIN FETCH p.shop s JOIN FETCH s.owner WHERE p.id = :id AND p.active = true AND s.status = 'APPROVED'")
    Optional<Product> findActiveByIdWithShopAndOwner(@Param("id") Integer id);

    @Query("SELECT p FROM Product p JOIN FETCH p.shop s JOIN FETCH s.owner WHERE p.id = :id")
    Optional<Product> findByIdWithShopAndOwner(@Param("id") Integer id);

    // Cập nhật: Chỉ lấy sản phẩm active cho trang chi tiết
    @Query("SELECT p FROM Product p JOIN FETCH p.shop s JOIN FETCH s.owner JOIN FETCH p.category WHERE p.id = :id AND p.active = true")
    Optional<Product> findByIdWithShopOwnerAndCategory(@Param("id") Integer id);

    @Query("SELECT p FROM Product p WHERE p.active = true")
    List<Product> findAllActiveProducts();

    // Sửa query để eager load shop cho suggestions - tránh LazyInitializationException
    // Method tìm kiếm cho suggestions (chỉ theo tên sản phẩm)
    @Query("SELECT p FROM Product p JOIN FETCH p.shop s WHERE p.active = true AND p.name LIKE CONCAT('%', :keyword, '%')")
    List<Product> findProductSuggestions(@Param("keyword") String keyword);

    // Sửa query tìm kiếm để eager load shop
    @Query("SELECT p FROM Product p JOIN FETCH p.shop s WHERE p.active = true AND (p.name LIKE CONCAT('%', :keyword, '%') OR p.description LIKE CONCAT('%', :keyword, '%'))")
    List<Product> searchProducts(@Param("keyword") String keyword);

    // Thêm method tìm kiếm với phân trang
    @Query("SELECT p FROM Product p WHERE p.active = true AND (p.name LIKE CONCAT('%', :keyword, '%') OR p.description LIKE CONCAT('%', :keyword, '%'))")
    Page<Product> searchProductsWithPagination(@Param("keyword") String keyword, Pageable pageable);

    @Query("SELECT p FROM Product p WHERE p.shop.id = :shopId AND p.active = true ORDER BY p.soldCount DESC")
    List<Product> findTop5BestSellingProductsByShopId(@Param("shopId") Integer shopId);

    List<Product> findByShop_Owner(User owner);

    List<Product> findByShop(Shop shop);

    long countByCategoryId(Integer categoryId);

    Page<Product> findByActiveTrue(Pageable pageable);

    Page<Product> findByCategory_SlugAndActiveTrue(String categorySlug, Pageable pageable);

    /**
     * MỚI: Tìm các sản phẩm theo danh sách ID và áp dụng phân trang.
     */
    Page<Product> findByIdIn(List<Integer> ids, Pageable pageable);

    /**
     * Lấy danh sách sản phẩm của một shop cụ thể theo ID của shop.
     * @param shopId ID của shop.
     * @return Danh sách sản phẩm thuộc shop đó.
     */
    @Query("SELECT p FROM Product p WHERE p.shop.id = :shopId AND p.active = true")
    List<Product> findByShopId(@Param("shopId") Integer shopId);
}
