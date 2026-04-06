package com.starshop.service.impl;

import com.starshop.entity.Category;
import com.starshop.repository.CategoryRepository;
import com.starshop.repository.ProductRepository;
import com.starshop.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private ProductRepository productRepository;

    @Override
    public List<Category> findAll() {
        return categoryRepository.findAll();
    }

    @Override
    public Optional<Category> findById(Integer id) {
        return categoryRepository.findById(id);
    }

    @Override
    public Category save(Category category) {
        return categoryRepository.save(category);
    }

    @Override
    public void deleteById(Integer id) {
        categoryRepository.deleteById(id);
    }

    @Override
    public boolean canDeleteCategory(Integer id) {
        return countProductsInCategory(id) == 0;
    }

    @Override
    public long countProductsInCategory(Integer id) {
        return productRepository.countByCategoryId(id);
    }

    @Override
    public List<Category> searchCategories(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return categoryRepository.findAll();
        } else {
            return categoryRepository.searchCategories(keyword);
        }
    }

    @Override
    public List<Category> findAllActiveCategories() {
        return categoryRepository.findByIsActiveTrue();
    }
}
