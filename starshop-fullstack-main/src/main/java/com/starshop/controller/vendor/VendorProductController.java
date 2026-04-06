package com.starshop.controller.vendor;

import com.starshop.entity.Category;
import com.starshop.entity.Product;
import com.starshop.entity.Shop;
import com.starshop.entity.User;
import com.starshop.service.CategoryService;
import com.starshop.service.ProductService;
import com.starshop.service.ShopService;
import com.starshop.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Controller
@RequestMapping("/vendor/products")
public class VendorProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @Autowired
    private ShopService shopService;

    @Autowired
    private CategoryService categoryService;

    private static final String UPLOAD_DIR = "src/main/webapp/images/";

    @GetMapping
    public String listProducts(Model model, Authentication authentication) {
        User vendor = getCurrentUser(authentication);
        List<Product> products = productService.findByVendor(vendor);
        model.addAttribute("products", products);
        return "vendor/product/list";
    }

    @GetMapping("/new")
    public String showAddForm(Model model, Authentication authentication) {
        User vendor = getCurrentUser(authentication);
        List<Shop> vendorShops = shopService.findByOwner(vendor);
        if (vendorShops.isEmpty()) {
            // Handle case where vendor has no shops or shop is not approved
            model.addAttribute("errorMessage", "Bạn chưa có cửa hàng nào được phê duyệt để thêm sản phẩm.");
            return "vendor/product/list"; // Or a dedicated error page
        }
        List<Category> categories = categoryService.findAllActiveCategories();

        model.addAttribute("product", new Product());
        model.addAttribute("vendorShops", vendorShops);
        model.addAttribute("categories", categories);
        model.addAttribute("pageTitle", "Thêm Sản Phẩm Mới");
        return "vendor/product/form";
    }

    @PostMapping("/save")
    public String saveProduct(@ModelAttribute("product") Product product,
                              @RequestParam("productImage") MultipartFile multipartFile,
                              Authentication authentication,
                              RedirectAttributes ra) {
        User vendor = getCurrentUser(authentication);

        Integer shopIdFromProduct = product.getShop() != null ? product.getShop().getId() : null;

        if (shopIdFromProduct == null) {
            ra.addFlashAttribute("errorMessage", "Thông tin cửa hàng không hợp lệ.");
            return "redirect:/vendor/products";
        }

        Optional<Shop> shopOpt = shopService.findByIdWithOwner(shopIdFromProduct);

        if (shopOpt.isEmpty()) {
            ra.addFlashAttribute("errorMessage", "Không tìm thấy cửa hàng hoặc bạn không có quyền thêm sản phẩm vào cửa hàng này.");
            return "redirect:/vendor/products";
        }

        Shop shop = shopOpt.get();
        // Ensure the retrieved shop's owner matches the current vendor
        if (shop.getOwner() == null || !shop.getOwner().getId().equals(vendor.getId())) {
            ra.addFlashAttribute("errorMessage", "Bạn không có quyền thêm sản phẩm vào cửa hàng này.");
            return "redirect:/vendor/products";
        }

        // Set the fully loaded shop object to the product
        product.setShop(shop);

        if (!multipartFile.isEmpty()) {
            try {
                String fileName = UUID.randomUUID().toString() + "_" + multipartFile.getOriginalFilename();
                Path uploadPath = Paths.get(UPLOAD_DIR);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                Path filePath = uploadPath.resolve(fileName);
                Files.copy(multipartFile.getInputStream(), filePath);
                product.setImageUrl("images/" + fileName);
            } catch (IOException e) {
                ra.addFlashAttribute("errorMessage", "Lỗi khi tải ảnh lên: " + e.getMessage());
                return "redirect:/vendor/products/new";
            }
        }

        try {
            productService.saveProductForVendor(product, vendor);
            ra.addFlashAttribute("successMessage", "Sản phẩm đã được lưu thành công!");
        } catch (IllegalArgumentException | SecurityException e) {
            ra.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi lưu sản phẩm: " + e.getMessage());
        }
        return "redirect:/vendor/products";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model, Authentication authentication, RedirectAttributes ra) {
        User vendor = getCurrentUser(authentication);
        Optional<Product> productOpt = productService.findByIdAndVendor(id, vendor);

        if (productOpt.isEmpty()) {
            ra.addFlashAttribute("errorMessage", "Không tìm thấy sản phẩm hoặc bạn không có quyền chỉnh sửa.");
            return "redirect:/vendor/products";
        }

        List<Shop> vendorShops = shopService.findByOwner(vendor);
        List<Category> categories = categoryService.findAllActiveCategories();

        model.addAttribute("product", productOpt.get());
        model.addAttribute("vendorShops", vendorShops);
        model.addAttribute("categories", categories);
        model.addAttribute("pageTitle", "Chỉnh Sửa Sản Phẩm");
        return "vendor/product/form";
    }

    @GetMapping("/toggle-active/{id}")
    public String toggleProductVisibility(@PathVariable("id") Integer id, Authentication authentication, RedirectAttributes ra) {
        User vendor = getCurrentUser(authentication);
        try {
            productService.toggleProductVisibilityForVendor(id, vendor);
            ra.addFlashAttribute("successMessage", "Cập nhật trạng thái sản phẩm thành công!");
        } catch (IllegalArgumentException | SecurityException e) {
            ra.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái sản phẩm: " + e.getMessage());
        }
        return "redirect:/vendor/products";
    }

    @GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable("id") Integer id, Authentication authentication, RedirectAttributes ra) {
        User vendor = getCurrentUser(authentication);
        try {
            productService.deleteProductForVendor(id, vendor);
            ra.addFlashAttribute("successMessage", "Sản phẩm đã được xóa thành công!");
        } catch (IllegalArgumentException | SecurityException e) {
            ra.addFlashAttribute("errorMessage", "Lỗi: " + e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Lỗi khi xóa sản phẩm: " + e.getMessage());
        }
        return "redirect:/vendor/products";
    }

    private User getCurrentUser(Authentication authentication) {
        String username = authentication.getName();
        return userService.findByUsername(username).orElseThrow(() -> new IllegalStateException("Không tìm thấy người dùng."));
    }
}
