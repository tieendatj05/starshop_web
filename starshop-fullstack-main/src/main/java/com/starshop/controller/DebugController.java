package com.starshop.controller;

import com.starshop.service.SearchService;
import com.starshop.repository.ProductRepository;
import com.starshop.entity.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
public class DebugController {

    @Autowired
    private SearchService searchService;

    @Autowired
    private ProductRepository productRepository;

    @GetMapping("/debug/search")
    public Map<String, Object> debugSearch(@RequestParam(value = "query", required = false) String query) {
        Map<String, Object> debug = new java.util.HashMap<>();

        // Test 1: Check raw products from repository
        List<Product> allProducts = productRepository.findAll();
        debug.put("totalProductsInDB", allProducts.size());

        if (!allProducts.isEmpty()) {
            Product firstProduct = allProducts.get(0);
            debug.put("firstProductName", firstProduct.getName());
            debug.put("firstProductActive", firstProduct.isActive());
            if (firstProduct.getShop() != null) {
                debug.put("firstProductShopStatus", firstProduct.getShop().getStatus());
            }
        }

        // Test 2: Search with exact query
        if (query != null && !query.trim().isEmpty()) {
            debug.put("searchQuery", query);

            // Test repository search
            List<Product> searchResults = productRepository.searchProducts(query.trim());
            debug.put("repositorySearchResults", searchResults.size());

            // Test service search
            List<Map<String, String>> serviceResults = searchService.searchProducts(query.trim());
            debug.put("serviceSearchResults", serviceResults.size());
            debug.put("serviceResults", serviceResults);
        }

        return debug;
    }

    @GetMapping("/debug/products")
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
}
