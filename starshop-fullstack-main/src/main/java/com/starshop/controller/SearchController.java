package com.starshop.controller;

import com.starshop.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class SearchController {

    @Autowired
    private SearchService searchService;

    @GetMapping("/search")
    public String search(@RequestParam(value = "query", required = false) String query, Model model) {
        // The actual search results will be fetched via WebSocket on the client-side
        // We just need to ensure the search_results.jsp page is rendered.
        // The 'query' parameter is passed to the model so it can be displayed on the page.
        model.addAttribute("searchQuery", query);
        return "search_results";
    }

    // Thêm REST API endpoint cho tìm kiếm như một fallback
    @GetMapping("/api/search")
    @ResponseBody
    public Map<String, Object> searchApi(@RequestParam(value = "query", required = false) String query) {
        Map<String, Object> response = new HashMap<>();

        if (query == null || query.trim().isEmpty()) {
            response.put("products", List.of());
            response.put("shops", List.of());
            response.put("discounts", List.of());
            return response;
        }

        List<Map<String, String>> products = searchService.searchProducts(query.trim());
        List<Map<String, String>> shops = searchService.searchShops(query.trim());
        List<Map<String, String>> discounts = searchService.searchPromotions(query.trim());

        response.put("products", products);
        response.put("shops", shops);
        response.put("discounts", discounts);

        return response;
    }
}
