package com.starshop.service.impl;

import com.starshop.constant.OrderStatus;
import com.starshop.dto.*;
import com.starshop.entity.*;
import com.starshop.repository.*;
import com.starshop.service.AddressService;
import com.starshop.service.CartService;
import com.starshop.service.OrderService;
import com.starshop.service.PromotionService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.TextStyle;
import java.time.temporal.TemporalAdjusters;
import java.util.*;

@Service
@Transactional
public class OrderServiceImpl implements OrderService {

    // Manual log declaration to ensure compilation works
    private static final Logger log = LoggerFactory.getLogger(OrderServiceImpl.class);

    @Autowired
    @Lazy
    private OrderService self;

    @Autowired
    private OrderRepository orderRepository;
    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private ShippingCarrierRepository shippingCarrierRepository;
    @Autowired
    private AddressService addressService;
    @Autowired
    private CartService cartService;
    @Autowired
    private ShopRepository shopRepository;
    @Autowired
    private PromotionRepository promotionRepository;
    @Autowired
    private PromotionService promotionService;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private AppealRepository appealRepository; // Inject AppealRepository

    @Override
    @Transactional
    public List<Order> createOrders(User user, CheckoutInfoDTO checkoutInfo) {
        CartDTO cartDTO = cartService.getCartForUser(user);

        if (cartDTO.getItems().isEmpty()) {
            throw new IllegalStateException("Giỏ hàng trống, không thể tạo đơn hàng.");
        }

        if (!cartDTO.isCheckoutAllowed()) {
            throw new IllegalStateException("Giỏ hàng chứa sản phẩm không hợp lệ. Vui lòng kiểm tra lại giỏ hàng.");
        }

        Address shippingAddress = determineShippingAddress(user, checkoutInfo);
        ShippingCarrier carrier = shippingCarrierRepository.findById(Long.valueOf(checkoutInfo.getShippingCarrierId()))
                .orElseThrow(() -> new IllegalArgumentException("Nhà vận chuyển không hợp lệ."));

        // Nhóm sản phẩm theo shop
        Map<Shop, List<CartItemDTO>> itemsByShop = new HashMap<>();
        for (CartItemDTO itemDTO : cartDTO.getItems()) {
            Product product = productRepository.findById(itemDTO.getProduct().getId())
                    .orElseThrow(() -> new IllegalStateException("Sản phẩm với ID " + itemDTO.getProduct().getId() + " không tồn tại."));

            if (!product.isActive() || !product.getShop().isActive() || product.getStock() < itemDTO.getQuantity()) {
                throw new IllegalStateException("Sản phẩm \'" + product.getName() + "\' không hợp lệ để thanh toán.");
            }

            Shop shop = product.getShop();
            itemsByShop.computeIfAbsent(shop, k -> new ArrayList<>()).add(itemDTO);
        }

        // Tìm shop sở hữu mã giảm giá (nếu có)
        Shop discountShop = null;
        Promotion appliedPromotion = null;
        BigDecimal totalDiscountAmount = BigDecimal.ZERO;

        if (checkoutInfo.getDiscountCode() != null && !checkoutInfo.getDiscountCode().isEmpty()) {
            // Tính tổng giá trị giỏ hàng để kiểm tra mã giảm giá
            BigDecimal totalCartValue = BigDecimal.ZERO;
            for (CartItemDTO itemDTO : cartDTO.getItems()) {
                Product product = productRepository.findById(itemDTO.getProduct().getId()).get();
                BigDecimal finalPrice = product.getDiscountedPrice() != null
                    ? product.getDiscountedPrice()
                    : product.getPrice();
                totalCartValue = totalCartValue.add(finalPrice.multiply(new BigDecimal(itemDTO.getQuantity())));
            }

            // Lấy thông tin promotion để xác định shop sở hữu
            Optional<Promotion> promotionOpt = promotionRepository.findByCode(checkoutInfo.getDiscountCode());
            if (promotionOpt.isPresent()) {
                appliedPromotion = promotionOpt.get();
                discountShop = appliedPromotion.getShop();

                // Chỉ tính discount cho sản phẩm của shop sở hữu mã giảm giá
                BigDecimal discountShopCartValue = BigDecimal.ZERO;
                List<CartItemDTO> discountShopItems = itemsByShop.get(discountShop);
                if (discountShopItems != null) {
                    for (CartItemDTO itemDTO : discountShopItems) {
                        Product product = productRepository.findById(itemDTO.getProduct().getId()).get();
                        BigDecimal finalPrice = product.getDiscountedPrice() != null
                            ? product.getDiscountedPrice()
                            : product.getPrice();
                        discountShopCartValue = discountShopCartValue.add(finalPrice.multiply(new BigDecimal(itemDTO.getQuantity())));
                    }

                    // Tính phí ship cho shop này (chia đều phí ship cho các shop)
                    BigDecimal discountShopShippingFee = carrier.getShippingFee().divide(new BigDecimal(itemsByShop.size()), 2, BigDecimal.ROUND_HALF_UP);
                    BigDecimal discountShopTotal = discountShopCartValue.add(discountShopShippingFee);

                    // Tạo CartDTO chỉ chứa sản phẩm của shop sở hữu mã giảm giá
                    CartDTO discountShopCartDTO = new CartDTO();
                    discountShopCartDTO.setItems(discountShopItems);

                    totalDiscountAmount = self.applyDiscountCode(checkoutInfo.getDiscountCode(), discountShopCartDTO, discountShopTotal);
                }
            }
        }

        List<Order> createdOrders = new ArrayList<>();

        // Tạo đơn hàng riêng cho từng shop
        for (Map.Entry<Shop, List<CartItemDTO>> entry : itemsByShop.entrySet()) {
            Shop shop = entry.getKey();
            List<CartItemDTO> shopItems = entry.getValue();

            Order order = new Order();
            order.setUser(user);
            order.setShippingAddress(formatAddress(shippingAddress));
            order.setShippingPhone(shippingAddress.getPhoneNumber());
            order.setPaymentMethod(checkoutInfo.getPaymentMethod());
            order.setStatus(OrderStatus.NEW_ORDER);
            order.setShippingCarrier(carrier);

            Set<OrderDetail> orderDetails = new HashSet<>();
            BigDecimal shopItemsTotal = BigDecimal.ZERO;

            for (CartItemDTO itemDTO : shopItems) {
                Product product = productRepository.findById(itemDTO.getProduct().getId()).get();

                OrderDetail detail = new OrderDetail();
                detail.setOrder(order);
                detail.setProduct(product);
                detail.setQuantity(itemDTO.getQuantity());

                BigDecimal finalPrice = product.getDiscountedPrice() != null
                    ? product.getDiscountedPrice()
                    : product.getPrice();
                detail.setPrice(finalPrice);
                orderDetails.add(detail);

                shopItemsTotal = shopItemsTotal.add(finalPrice.multiply(new BigDecimal(itemDTO.getQuantity())));

                // Cập nhật stock và sold count
                product.setStock(product.getStock() - itemDTO.getQuantity());
                product.setSoldCount(product.getSoldCount() + itemDTO.getQuantity());
                productRepository.save(product);
            }

            order.setOrderDetails(orderDetails);

            // Tính phí ship cho đơn hàng này (chia đều phí ship cho các shop)
            BigDecimal shopShippingFee = carrier.getShippingFee().divide(new BigDecimal(itemsByShop.size()), 2, BigDecimal.ROUND_HALF_UP);
            BigDecimal shopTotalBeforeDiscount = shopItemsTotal.add(shopShippingFee);
            order.setTotalAmount(shopTotalBeforeDiscount);

            // Chỉ áp dụng discount cho shop sở hữu mã giảm giá
            if (discountShop != null && shop.getId().equals(discountShop.getId()) && totalDiscountAmount.compareTo(BigDecimal.ZERO) > 0) {
                order.setPromotion(appliedPromotion);
                order.setDiscountCode(checkoutInfo.getDiscountCode());
                order.setDiscountAmount(totalDiscountAmount);
            }

            Order savedOrder = orderRepository.save(order);
            createdOrders.add(savedOrder);
        }

        cartService.clearCart(user);
        return createdOrders;
    }

    // Giữ lại method cũ để backward compatibility, nhưng sử dụng method mới
    @Override
    @Transactional
    public Order createOrder(User user, CheckoutInfoDTO checkoutInfo) {
        List<Order> orders = createOrders(user, checkoutInfo);
        // Trả về đơn hàng đầu tiên cho backward compatibility
        return orders.isEmpty() ? null : orders.get(0);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findOrdersForUser(User user, String statusFilter) {
        if (statusFilter != null && !statusFilter.isEmpty()) {
            return orderRepository.findUserOrdersWithDetailsAndStatus(user, statusFilter);
        } else {
            return orderRepository.findUserOrdersWithDetails(user);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findOrdersForVendor(User vendor) {
        Shop shop = shopRepository.findByOwner(vendor)
                .orElseThrow(() -> new IllegalStateException("Tài khoản của bạn không sở hữu cửa hàng nào."));
        return orderRepository.findOrdersByShopId(shop.getId());
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void updateOrderStatus(Integer orderId, String newStatus, User vendor) {
        Shop shop = shopRepository.findByOwner(vendor)
                .orElseThrow(() -> new SecurityException("Bạn không có quyền thực hiện thao tác này."));

        Order order = orderRepository.findByIdWithDetails(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại."));

        boolean isOrderRelatedToShop = order.getOrderDetails().stream()
                .anyMatch(detail -> detail.getProduct().getShop().getId().equals(shop.getId()));

        if (!isOrderRelatedToShop) {
            throw new SecurityException("Bạn không có quyền cập nhật trạng thái cho đơn hàng này.");
        }

        order.setStatus(newStatus);
        orderRepository.saveAndFlush(order);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findOrdersForShipper(User shipper) {
        return orderRepository.findByShipper(shipper);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findAvailableOrders() {
        return orderRepository.findAvailableOrders(OrderStatus.WAITING_FOR_CONFIRMATION);
    }

    @Override
    @Transactional
    public synchronized boolean assignOrderToShipper(Integer orderId, User shipper) {
        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            if (OrderStatus.WAITING_FOR_CONFIRMATION.equals(order.getStatus()) && order.getShipper() == null) {
                self.updateOrderStatusInNewTransaction(order, shipper, OrderStatus.WAITING_FOR_PICKUP);
                return true;
            }
        }
        return false;
    }

    @Override
    @Transactional
    public void confirmOrderAndSeekShipper(Integer orderId, User vendor) {
        Shop shop = shopRepository.findByOwner(vendor)
                .orElseThrow(() -> new SecurityException("Bạn không có quyền thực hiện thao tác này."));

        Order order = orderRepository.findByIdWithDetails(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại."));

        boolean isOrderRelatedToShop = order.getOrderDetails().stream()
                .anyMatch(detail -> detail.getProduct().getShop().getId().equals(shop.getId()));

        if (!isOrderRelatedToShop) {
            throw new SecurityException("Bạn không có quyền cập nhật trạng thái cho đơn hàng này.");
        }

        if (OrderStatus.NEW_ORDER.equals(order.getStatus())) {
            self.updateOrderStatusInNewTransaction(order, null, OrderStatus.WAITING_FOR_CONFIRMATION);
        } else {
            throw new IllegalStateException("Chỉ có thể xác nhận đơn hàng ở trạng thái \'" + OrderStatus.NEW_ORDER + "\'.");
        }
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void updateOrderStatusInNewTransaction(Order order, User shipper, String newStatus) {
        if (shipper != null) {
            order.setShipper(shipper);
        }
        order.setStatus(newStatus);
        orderRepository.saveAndFlush(order);
        log.info("GIAO DỊCH MỚI: Đã commit trạng thái của đơn hàng #{} thành {}", order.getId(), newStatus);
    }

    @Override
    @Transactional
    public void updateOrderStatusByShipper(Integer orderId, String newStatus, User shipper) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại."));

        if (order.getShipper() == null || !order.getShipper().getId().equals(shipper.getId())) {
            throw new SecurityException("Bạn không có quyền cập nhật trạng thái cho đơn hàng này.");
        }

        String currentStatus = order.getStatus();
        boolean isValidTransition = (OrderStatus.WAITING_FOR_PICKUP.equals(currentStatus) && OrderStatus.DELIVERING.equals(newStatus)) ||
                                  (OrderStatus.DELIVERING.equals(currentStatus) && (OrderStatus.DELIVERED_SUCCESS.equals(newStatus) || OrderStatus.DELIVERED_FAIL.equals(newStatus)));

        if (isValidTransition) {
            order.setStatus(newStatus);
            orderRepository.save(order);
        } else {
            throw new IllegalStateException("Không thể cập nhật từ trạng thái \'" + currentStatus + "\' sang \'" + newStatus + "\'.");
        }
    }

    @Override
    @Transactional
    public void cancelOrderAsVendor(Integer orderId, User vendor) {
        Shop shop = shopRepository.findByOwner(vendor)
                .orElseThrow(() -> new SecurityException("Bạn không có quyền thực hiện thao tác này."));

        Order order = orderRepository.findByIdWithDetails(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại."));

        boolean isOrderRelatedToShop = order.getOrderDetails().stream()
                .anyMatch(detail -> detail.getProduct().getShop().getId().equals(shop.getId()));

        if (!isOrderRelatedToShop) {
            throw new SecurityException("Bạn không có quyền hủy đơn hàng này.");
        }

        if (OrderStatus.NEW_ORDER.equals(order.getStatus()) || OrderStatus.WAITING_FOR_CONFIRMATION.equals(order.getStatus())) {
            order.setStatus(OrderStatus.CANCELED);
            orderRepository.save(order);
        } else {
            throw new IllegalStateException("Không thể hủy đơn hàng ở trạng thái \'" + order.getStatus() + "\'.");
        }
    }

    @Override
    @Transactional
    public void cancelOrderAsUser(Integer orderId, User user) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Đơn hàng không tồn tại."));

        if (order.getUser() == null || user == null || !order.getUser().getId().equals(user.getId())) {
            throw new SecurityException("Bạn không có quyền hủy đơn hàng này.");
        }

        if (!OrderStatus.NEW_ORDER.equals(order.getStatus())) {
            throw new IllegalStateException("Chỉ có thể hủy đơn hàng ở trạng thái '" + OrderStatus.NEW_ORDER + "'.");
        }

        order.setStatus(OrderStatus.CANCELED);
        orderRepository.save(order);
        log.info("User #{} canceled order #{}", user.getId(), orderId);
    }

    @Override
    @Transactional(readOnly = true)
    public ShipperStatsDTO getShipperStats(User shipper) {
        ShipperStatsDTO stats = new ShipperStatsDTO();
        String successStatus = OrderStatus.DELIVERED_SUCCESS;

        LocalDateTime startOfToday = LocalDate.now().atStartOfDay();
        LocalDateTime endOfToday = LocalDate.now().atTime(LocalTime.MAX);
        long ordersToday = orderRepository.countByShipperAndStatusAndCreatedAtBetween(shipper, successStatus, startOfToday, endOfToday);
        stats.setOrdersToday(ordersToday);

        LocalDateTime startOfWeek = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY)).atStartOfDay();
        LocalDateTime endOfWeek = LocalDate.now().with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY)).atTime(LocalTime.MAX);
        long ordersThisWeek = orderRepository.countByShipperAndStatusAndCreatedAtBetween(shipper, successStatus, startOfWeek, endOfWeek);
        stats.setOrdersThisWeek(ordersThisWeek);

        LocalDateTime startOfMonth = LocalDate.now().with(TemporalAdjusters.firstDayOfMonth()).atStartOfDay();
        LocalDateTime endOfMonth = LocalDate.now().with(TemporalAdjusters.lastDayOfMonth()).atTime(LocalTime.MAX);
        long ordersThisMonth = orderRepository.countByShipperAndStatusAndCreatedAtBetween(shipper, successStatus, startOfMonth, endOfMonth);
        stats.setOrdersThisMonth(ordersThisMonth);

        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public VendorDashboardStatsDTO getVendorDashboardStats(User vendor) {
        Shop shop = shopRepository.findByOwner(vendor)
                .orElseThrow(() -> new IllegalStateException("Tài khoản của bạn không sở hữu cửa hàng nào."));

        VendorDashboardStatsDTO stats = new VendorDashboardStatsDTO();
        String successStatus = OrderStatus.DELIVERED_SUCCESS;
        Integer shopId = shop.getId();

        // Tính doanh thu hôm nay = Gross Revenue - Discount
        LocalDateTime startOfToday = LocalDate.now().atStartOfDay();
        LocalDateTime endOfToday = LocalDate.now().atTime(LocalTime.MAX);
        BigDecimal grossToday = orderRepository.findGrossRevenueByShopIdAndStatusAndDateRange(shopId, successStatus, startOfToday, endOfToday);
        BigDecimal discountToday = orderRepository.findTotalDiscountByShopIdAndStatusAndDateRange(shopId, successStatus, startOfToday, endOfToday);
        stats.setRevenueToday((grossToday != null ? grossToday : BigDecimal.ZERO).subtract(discountToday != null ? discountToday : BigDecimal.ZERO));

        // Tính doanh thu tuần này
        LocalDateTime startOfWeek = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY)).atStartOfDay();
        LocalDateTime endOfWeek = LocalDate.now().with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY)).atTime(LocalTime.MAX);
        BigDecimal grossWeek = orderRepository.findGrossRevenueByShopIdAndStatusAndDateRange(shopId, successStatus, startOfWeek, endOfWeek);
        BigDecimal discountWeek = orderRepository.findTotalDiscountByShopIdAndStatusAndDateRange(shopId, successStatus, startOfWeek, endOfWeek);
        stats.setRevenueThisWeek((grossWeek != null ? grossWeek : BigDecimal.ZERO).subtract(discountWeek != null ? discountWeek : BigDecimal.ZERO));

        // Tính doanh thu tháng này
        LocalDateTime startOfMonth = LocalDate.now().with(TemporalAdjusters.firstDayOfMonth()).atStartOfDay();
        LocalDateTime endOfMonth = LocalDate.now().with(TemporalAdjusters.lastDayOfMonth()).atTime(LocalTime.MAX);
        BigDecimal grossMonth = orderRepository.findGrossRevenueByShopIdAndStatusAndDateRange(shopId, successStatus, startOfMonth, endOfMonth);
        BigDecimal discountMonth = orderRepository.findTotalDiscountByShopIdAndStatusAndDateRange(shopId, successStatus, startOfMonth, endOfMonth);
        stats.setRevenueThisMonth((grossMonth != null ? grossMonth : BigDecimal.ZERO).subtract(discountMonth != null ? discountMonth : BigDecimal.ZERO));

        List<Product> bestSellingProducts = productRepository.findTop5BestSellingProductsByShopId(shopId);
        stats.setBestSellingProducts(bestSellingProducts);

        // Tính doanh thu cho biểu đồ tuần
        Map<String, BigDecimal> weeklyChartData = new LinkedHashMap<>();
        for (int i = 0; i < 7; i++) {
            DayOfWeek day = startOfWeek.plusDays(i).getDayOfWeek();
            String dayName = day.getDisplayName(TextStyle.SHORT, Locale.forLanguageTag("vi-VN"));
            LocalDateTime startOfDay = startOfWeek.plusDays(i);
            LocalDateTime endOfDay = startOfDay.with(LocalTime.MAX);
            BigDecimal dailyGross = orderRepository.findGrossRevenueByShopIdAndStatusAndDateRange(shopId, successStatus, startOfDay, endOfDay);
            BigDecimal dailyDiscount = orderRepository.findTotalDiscountByShopIdAndStatusAndDateRange(shopId, successStatus, startOfDay, endOfDay);
            BigDecimal dailyNet = (dailyGross != null ? dailyGross : BigDecimal.ZERO).subtract(dailyDiscount != null ? dailyDiscount : BigDecimal.ZERO);
            weeklyChartData.put(dayName, dailyNet);
        }
        stats.setWeeklyRevenueChartData(weeklyChartData);

        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public AdminDashboardStatsDTO getAdminDashboardStats() {
        AdminDashboardStatsDTO stats = new AdminDashboardStatsDTO();
        String successStatus = OrderStatus.DELIVERED_SUCCESS;

        stats.setTotalUsers(userRepository.count());
        stats.setTotalShops(shopRepository.count());
        stats.setPendingShopRequests(shopRepository.countByStatus(Shop.PENDING));
        stats.setTotalOrders(orderRepository.count());
        stats.setPendingAppealsCount(countPendingAppeals()); // Set pending appeals count

        BigDecimal totalRevenue = orderRepository.findTotalRevenueByStatusAndDateRange(successStatus, LocalDateTime.of(1970, 1, 1, 0, 0), LocalDateTime.now());
        stats.setTotalRevenue(totalRevenue != null ? totalRevenue : BigDecimal.ZERO);

        Map<String, BigDecimal> monthlyChartData = new LinkedHashMap<>();
        LocalDate today = LocalDate.now();
        for (int i = 11; i >= 0; i--) {
            LocalDate monthDate = today.minusMonths(i);
            String monthName = "Th" + monthDate.getMonthValue();
            LocalDateTime startOfMonth = monthDate.with(TemporalAdjusters.firstDayOfMonth()).atStartOfDay();
            LocalDateTime endOfMonth = monthDate.with(TemporalAdjusters.lastDayOfMonth()).atTime(LocalTime.MAX);
            BigDecimal monthlyRevenue = orderRepository.findTotalRevenueByStatusAndDateRange(successStatus, startOfMonth, endOfMonth);
            monthlyChartData.put(monthName, monthlyRevenue != null ? monthlyRevenue : BigDecimal.ZERO);
        }
        stats.setMonthlyRevenueChartData(monthlyChartData);

        return stats;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findAllOrdersForAdmin() {
        return orderRepository.findAllOrdersWithDetails();
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal applyDiscountCode(String discountCode, CartDTO cartDTO, BigDecimal currentCartTotal) {
        return promotionService.calculateDiscount(discountCode, cartDTO, currentCartTotal);
    }

    @Override
    @Transactional(readOnly = true)
    public long countPendingAppeals() {
        return appealRepository.countByStatus(Appeal.PENDING);
    }

    private Address determineShippingAddress(User user, CheckoutInfoDTO checkoutInfo) {
        if (checkoutInfo.getSelectedAddressId() != null) {
            return addressService.getAddressById(checkoutInfo.getSelectedAddressId(), user)
                    .orElseThrow(() -> new IllegalArgumentException("Địa chỉ đã chọn không h��p lệ."));
        }

        String newRecipientName = checkoutInfo.getNewRecipientName();
        String newPhoneNumber = checkoutInfo.getNewPhoneNumber();
        String newDetailAddress = checkoutInfo.getNewDetailAddress();
        String newCity = checkoutInfo.getNewCity();

        boolean isNewAddressProvided = (newRecipientName != null && !newRecipientName.trim().isEmpty()) &&
                                       (newPhoneNumber != null && !newPhoneNumber.trim().isEmpty()) &&
                                       (newDetailAddress != null && !newDetailAddress.trim().isEmpty()) &&
                                       (newCity != null && !newCity.trim().isEmpty());

        if (isNewAddressProvided) {
            Address newAddress = new Address();
            newAddress.setUser(user);
            newAddress.setRecipientName(newRecipientName);
            newAddress.setPhoneNumber(newPhoneNumber);
            newAddress.setDetailAddress(newDetailAddress);
            newAddress.setCity(newCity);
            newAddress.setDefault(false);
            addressService.saveAddress(newAddress, user);
            return newAddress;
        } else {
            throw new IllegalArgumentException("Vui lòng chọn một địa chỉ đã lưu hoặc nhập đầy đủ thông tin địa chỉ mới.");
        }
    }

    private String formatAddress(Address address) {
        return String.format("%s, %s", address.getDetailAddress(), address.getCity());
    }
}
