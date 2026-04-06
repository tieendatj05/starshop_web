package com.starshop.service;

import com.starshop.entity.Category;
import java.util.List;
import java.util.Optional;

public interface CategoryService {
    List<Category> findAll();
    Optional<Category> findById(Integer id);
    Category save(Category category);
    void deleteById(Integer id);

    /**
     * Kiểm tra xem danh mục có thể xóa được không (không có sản phẩm nào đang sử dụng)
     * @param id ID của danh mục
     * @return true nếu có thể xóa, false nếu không thể
     */
    boolean canDeleteCategory(Integer id);

    /**
     * Đếm số lượng sản phẩm trong danh mục
     * @param id ID của danh mục
     * @return số lượng sản phẩm
     */
    long countProductsInCategory(Integer id);

    /**
     * Tìm kiếm danh mục theo từ khóa.
     * @param keyword Từ khóa tìm kiếm.
     * @return Danh sách danh mục phù hợp.
     */
    List<Category> searchCategories(String keyword);

    /**
     * Lấy tất cả các danh mục đang hoạt động.
     * @return Danh sách các danh mục đang hoạt động.
     */
    List<Category> findAllActiveCategories();
}
