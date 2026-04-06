package com.starshop.service.impl;

import com.starshop.entity.Product;
import com.starshop.entity.Role;
import com.starshop.entity.Shop;
import com.starshop.entity.User;
import com.starshop.repository.ProductRepository;
import com.starshop.repository.RoleRepository;
import com.starshop.repository.ShopRepository;
import com.starshop.repository.UserRepository;
import com.starshop.service.ShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class ShopServiceImpl implements ShopService {

    @Autowired
    private ShopRepository shopRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private SimpMessageSendingOperations messagingTemplate;

    @Override
    @Transactional(readOnly = true)
    public List<Shop> getAllShops() {
        return shopRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Shop> searchShops(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return shopRepository.findAll();
        } else {
            return shopRepository.searchShops(keyword);
        }
    }

    @Override
    public void approveShop(int shopId) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new IllegalArgumentException("Shop không tồn tại với ID: " + shopId));

        if (!Shop.PENDING.equals(shop.getStatus())) {
            throw new IllegalStateException("Chỉ có thể duyệt shop đang ở trạng thái chờ duyệt.");
        }

        shop.setStatus(Shop.APPROVED);
        shopRepository.save(shop);

        User owner = shop.getOwner();
        if (owner != null) {
            String destination = "/topic/shop-approval/" + owner.getId();

            // DEBUG LOGGING
            System.out.println("DEBUG: Sending shop approval notification to destination: " + destination);

            messagingTemplate.convertAndSend(destination, Map.of(
                    "status", "APPROVED",
                    "message", "Chúc mừng! Shop '" + shop.getName() + "' của bạn đã được duyệt.",
                    "shopName", shop.getName()
            ));

            System.out.println("DEBUG: Notification sent successfully.");

            // Nâng cấp vai trò của chủ shop
            if (owner.getRole() != null && !"VENDOR".equals(owner.getRole().getName())) {
                Role vendorRole = roleRepository.findByName("VENDOR")
                        .orElseThrow(() -> new IllegalStateException("Không tìm thấy vai trò VENDOR trong hệ thống."));
                owner.setRole(vendorRole);
                userRepository.save(owner);
            }
        } else {
            System.out.println("DEBUG: Shop with ID " + shopId + " has no owner. Cannot send notification.");
            throw new IllegalStateException("Shop không có owner hợp lệ.");
        }
    }

    @Override
    public void rejectShop(int shopId) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new IllegalArgumentException("Shop không tồn tại với ID: " + shopId));

        shop.setStatus(Shop.REJECTED);
        shopRepository.save(shop);

        User owner = shop.getOwner();
        if (owner != null && "VENDOR".equals(owner.getRole().getName())) {
            Role userRole = roleRepository.findByName("USER")
                    .orElseThrow(() -> new IllegalStateException("Không tìm thấy vai trò USER trong hệ thống."));
            owner.setRole(userRole);
            userRepository.save(owner);
        }

        List<Product> products = productRepository.findByShop(shop);
        for (Product product : products) {
            if (product.isActive()) {
                product.setActive(false);
                productRepository.save(product);
            }
        }
    }

    @Override
    @Transactional(readOnly = true)
    public boolean hasShop(User user) {
        Optional<Shop> shopOpt = shopRepository.findByOwner(user);
        return shopOpt.isPresent() && (Shop.PENDING.equals(shopOpt.get().getStatus()) || Shop.APPROVED.equals(shopOpt.get().getStatus()));
    }

    @Override
    public Shop registerShop(String name, String description, User user) {
        Optional<Shop> existingShopOpt = shopRepository.findByOwner(user);

        if (existingShopOpt.isPresent()) {
            Shop existingShop = existingShopOpt.get();
            if (Shop.PENDING.equals(existingShop.getStatus()) || Shop.APPROVED.equals(existingShop.getStatus())) {
                throw new IllegalStateException("Bạn đã có một cửa hàng hoặc yêu cầu của bạn đang được xử lý.");
            }
            else if (Shop.REJECTED.equals(existingShop.getStatus())) {
                existingShop.setName(name);
                existingShop.setDescription(description);
                existingShop.setStatus(Shop.PENDING);
                return shopRepository.save(existingShop);
            }
        }

        Shop newShop = new Shop();
        newShop.setName(name);
        newShop.setDescription(description);
        newShop.setOwner(user);
        newShop.setStatus(Shop.PENDING);

        return shopRepository.save(newShop);
    }

    @Override
    public void lockShop(int shopId) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new IllegalArgumentException("Shop không tồn tại với ID: " + shopId));

        // Chỉ có thể khóa shop đã được duyệt
        if (!Shop.APPROVED.equals(shop.getStatus())) {
            throw new IllegalStateException("Chỉ có thể khóa shop đã được duyệt.");
        }

        // Cập nhật trạng thái shop thành LOCKED
        shop.setStatus(Shop.LOCKED);
        shopRepository.save(shop);

        // Chuyển role của owner từ VENDOR về USER
        User owner = shop.getOwner();
        if (owner != null && "VENDOR".equals(owner.getRole().getName())) {
            Role userRole = roleRepository.findByName("USER")
                    .orElseThrow(() -> new IllegalStateException("Không tìm thấy vai trò USER trong hệ thống."));
            owner.setRole(userRole);
            userRepository.save(owner);

            // Ẩn tất cả sản phẩm của shop
            List<Product> products = productRepository.findByShop(shop);
            for (Product product : products) {
                if (product.isActive()) {
                    product.setActive(false);
                    productRepository.save(product);
                }
            }
        }
    }

    @Override
    public void unlockShop(int shopId) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new IllegalArgumentException("Shop không tồn tại với ID: " + shopId));

        // Chỉ có thể mở khóa shop đã bị khóa
        if (!Shop.LOCKED.equals(shop.getStatus())) {
            throw new IllegalStateException("Chỉ có thể mở khóa shop đã bị khóa.");
        }

        // Cập nhật trạng thái shop thành APPROVED
        shop.setStatus(Shop.APPROVED);
        shopRepository.save(shop);

        // Khôi phục role của owner từ USER về VENDOR
        User owner = shop.getOwner();
        if (owner != null && "USER".equals(owner.getRole().getName())) {
            Role vendorRole = roleRepository.findByName("VENDOR")
                    .orElseThrow(() -> new IllegalStateException("Không tìm thấy vai trò VENDOR trong hệ thống."));
            owner.setRole(vendorRole);
            userRepository.save(owner);

            // Tự động hiện lại tất cả sản phẩm của shop khi mở khóa
            List<Product> products = productRepository.findByShop(shop);
            for (Product product : products) {
                if (!product.isActive()) {
                    product.setActive(true);
                    productRepository.save(product);
                }
            }
        }
    }

    @Override
    public void hideAllProductsInShop(int shopId) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new IllegalArgumentException("Shop không tồn tại với ID: " + shopId));

        // Chỉ có thể ẩn sản phẩm của shop đã được duyệt
        if (!Shop.APPROVED.equals(shop.getStatus())) {
            throw new IllegalStateException("Chỉ có thể ẩn sản phẩm của shop đã được duyệt.");
        }

        // Ẩn tất cả sản phẩm của shop
        List<Product> products = productRepository.findByShop(shop);
        for (Product product : products) {
            if (product.isActive()) {
                product.setActive(false);
                productRepository.save(product);
            }
        }
    }

    @Override
    public void showAllProductsInShop(int shopId) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new IllegalArgumentException("Shop không tồn tại với ID: " + shopId));

        // Chỉ có thể hiện sản phẩm của shop đã được duyệt
        if (!Shop.APPROVED.equals(shop.getStatus())) {
            throw new IllegalStateException("Chỉ có thể hiện sản phẩm của shop đã được duyệt.");
        }

        // Hiện tất cả sản phẩm của shop
        List<Product> products = productRepository.findByShop(shop);
        for (Product product : products) {
            if (!product.isActive()) {
                product.setActive(true);
                productRepository.save(product);
            }
        }
    }

    @Override
    public void updateShopInfo(Integer shopId, String name, String description) {
        Shop shop = shopRepository.findById(shopId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy shop với ID: " + shopId));

        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên shop không được để trống.");
        }

        shop.setName(name);
        shop.setDescription(description);
        shopRepository.save(shop);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Shop> findByOwner(User owner) {
        return shopRepository.findByOwner(owner).map(List::of).orElse(List.of());
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Shop> findById(Integer id) {
        return shopRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Shop> findByIdWithOwner(Integer id) {
        return shopRepository.findByIdWithOwner(id);
    }
}
