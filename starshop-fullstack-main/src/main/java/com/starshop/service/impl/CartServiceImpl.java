package com.starshop.service.impl;

import com.starshop.dto.CartDTO;
import com.starshop.dto.CartItemDTO;
import com.starshop.dto.ProductDTO;
import com.starshop.entity.Cart;
import com.starshop.entity.CartItem;
import com.starshop.entity.Product;
import com.starshop.entity.User;
import com.starshop.repository.CartItemRepository;
import com.starshop.repository.CartRepository;
import com.starshop.repository.ProductRepository;
import com.starshop.service.CartService;
import com.starshop.service.ProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CartServiceImpl implements CartService {

    private static final Logger log = LoggerFactory.getLogger(CartServiceImpl.class);

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductService productService;

    @Override
    public void addProductToCart(User user, Integer productId, int quantity) {
        Cart cart = getOrCreateCartEntity(user);
        Product product = productService.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không tồn tại với ID: " + productId));

        if (!product.isActive()) {
            throw new IllegalStateException("Sản phẩm \'" + product.getName() + "\' hiện không còn được bán.");
        }
        if (product.getShop() == null) {
            throw new IllegalStateException("Sản phẩm \'" + product.getName() + "\' không có thông tin shop. Vui lòng liên hệ hỗ trợ.");
        }
        if (!product.getShop().isActive()) {
            throw new IllegalStateException("Sản phẩm \'" + product.getName() + "\' thuộc shop đã bị khóa. Không thể thêm vào giỏ.");
        }

        Optional<CartItem> existingCartItem = cart.getItems().stream()
                .filter(item -> item.getProduct().getId().equals(productId))
                .findFirst();

        if (existingCartItem.isPresent()) {
            CartItem cartItem = existingCartItem.get();
            cartItem.setQuantity(cartItem.getQuantity() + quantity);
            cartItemRepository.save(cartItem);
        } else {
            CartItem newCartItem = new CartItem();
            newCartItem.setCart(cart);
            newCartItem.setProduct(product);
            newCartItem.setQuantity(quantity);
            cartItemRepository.save(newCartItem);
        }
    }

    @Override
    @Transactional
    public void updateProductQuantity(User user, Integer productId, int quantity) {
        Cart cart = getOrCreateCartEntity(user);
        CartItem cartItem = cart.getItems().stream()
                .filter(item -> item.getProduct().getId().equals(productId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Sản phẩm không có trong giỏ hàng."));

        if (quantity <= 0) {
            cart.getItems().remove(cartItem);
            cartItemRepository.delete(cartItem);
        } else {
            Product product = cartItem.getProduct();
            if (product.getStock() < quantity) {
                throw new IllegalStateException("Số lượng tồn kho không đủ. Chỉ còn " + product.getStock() + " sản phẩm.");
            }
            cartItem.setQuantity(quantity);
            cartItemRepository.save(cartItem);
        }

        cartItemRepository.flush();
    }

    private Cart getOrCreateCartEntity(User user) {
        return cartRepository.findByUserWithItems(user).orElseGet(() -> {
            Cart newCart = new Cart();
            newCart.setUser(user);
            return cartRepository.save(newCart);
        });
    }

    @Override
    @Transactional(readOnly = true)
    public CartDTO getCartForUser(User user) {
        Cart cartEntity = getOrCreateCartEntity(user);
        CartDTO cartDTO = new CartDTO();
        cartDTO.setCartId(cartEntity.getId());

        List<CartItemDTO> itemDTOs = new ArrayList<>();
        BigDecimal totalAmount = BigDecimal.ZERO;
        boolean isCheckoutAllowed = true;

        for (CartItem item : cartEntity.getItems()) {
            CartItemDTO itemDTO = new CartItemDTO();
            itemDTO.setCartItemId(item.getId());

            Optional<ProductDTO> productDTOOptional = productService.findProductDTOById(item.getProduct().getId());

            if (productDTOOptional.isEmpty()) {
                itemDTO.setValid(false);
                itemDTO.setInvalidReason("Sản phẩm không tồn tại hoặc đã bị ẩn.");
                isCheckoutAllowed = false;

                ProductDTO placeholderProduct = new ProductDTO();
                placeholderProduct.setId(item.getProduct().getId());
                placeholderProduct.setName("[Sản phẩm không khả dụng]");
                
                itemDTO.setProduct(placeholderProduct);
                itemDTO.setQuantity(item.getQuantity());
                itemDTO.setSubtotal(BigDecimal.ZERO);

                itemDTOs.add(itemDTO);
                continue;
            }

            ProductDTO productDTO = productDTOOptional.get();
            itemDTO.setProduct(productDTO);
            itemDTO.setQuantity(item.getQuantity());

            BigDecimal finalPrice = productDTO.getDiscountedPrice() != null
                ? productDTO.getDiscountedPrice()
                : productDTO.getPrice();
            itemDTO.setSubtotal(finalPrice.multiply(new BigDecimal(item.getQuantity())));
            log.info("Calculated subtotal for product ID {}: Quantity = {}, Final Price = {}, Subtotal = {}",
                     productDTO.getId(), item.getQuantity(), finalPrice, itemDTO.getSubtotal());

            if (!productDTO.isActive()) {
                itemDTO.setValid(false);
                itemDTO.setInvalidReason("Sản phẩm hiện không còn được bán.");
                isCheckoutAllowed = false;
            } else if (productDTO.getShop() == null) {
                itemDTO.setValid(false);
                itemDTO.setInvalidReason("Sản phẩm không có thông tin shop. Vui lòng liên hệ hỗ trợ.");
                isCheckoutAllowed = false;
            } else if (!productDTO.getShop().isActive()) {
                itemDTO.setValid(false);
                itemDTO.setInvalidReason("Sản phẩm thuộc shop đã bị khóa.");
                isCheckoutAllowed = false;
            } else if (productDTO.getStock() < item.getQuantity()) {
                itemDTO.setValid(false);
                itemDTO.setInvalidReason("Số lượng tồn kho không đủ.");
                isCheckoutAllowed = false;
            } else {
                totalAmount = totalAmount.add(itemDTO.getSubtotal());
            }
            itemDTOs.add(itemDTO);
        }

        cartDTO.setItems(itemDTOs);
        cartDTO.setTotalAmount(totalAmount);
        cartDTO.setCheckoutAllowed(isCheckoutAllowed);

        return cartDTO;
    }

    @Override
    public void removeProductFromCart(User user, Integer productId) {
        Cart cart = getOrCreateCartEntity(user);
        Optional<CartItem> cartItemToRemove = cart.getItems().stream()
                .filter(item -> item.getProduct().getId().equals(productId))
                .findFirst();

        cartItemToRemove.ifPresent(item -> {
            cart.getItems().remove(item);
            cartItemRepository.delete(item);
            cartRepository.save(cart);
        });
    }

    @Override
    public void clearCart(User user) {
        Cart cart = getOrCreateCartEntity(user);
        cart.getItems().clear();
        cartRepository.save(cart);
    }
}