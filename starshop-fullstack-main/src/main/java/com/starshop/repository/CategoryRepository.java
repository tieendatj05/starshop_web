package com.starshop.repository;

import com.starshop.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Integer> {

    /**
     * Tìm kiếm danh mục theo từ khóa trong tên hoặc slug.
     * @param keyword Từ khóa tìm kiếm.
     * @return Danh sách danh mục phù hợp.
     */
    @Query("SELECT c FROM Category c WHERE LOWER(c.name) LIKE CONCAT('%', LOWER(:keyword), '%') OR LOWER(c.slug) LIKE CONCAT('%', LOWER(:keyword), '%')")
    List<Category> searchCategories(@Param("keyword") String keyword);

    /**
     * Lấy tất cả các danh mục đang hoạt động.
     * @return Danh sách các danh mục đang hoạt động.
     */
    List<Category> findByIsActiveTrue(); // Corrected to findByIsActiveTrue
}
