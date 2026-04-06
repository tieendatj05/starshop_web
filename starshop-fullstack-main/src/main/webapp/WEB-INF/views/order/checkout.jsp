<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán - StarShop</title>
    
    <!-- Vô hiệu hóa cache để đảm bảo dữ liệu luôn mới nhất -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-content {
            flex: 1;
            padding-bottom: 2rem;
        }

        /* Modern Card Panel */
        .checkout-panel {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 2rem;
            margin-bottom: 1.5rem;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title i {
            color: var(--accent-pink);
            font-size: 1.4rem;
        }

        /* Address Selection Cards */
        .address-card {
            border: 2px solid #f0f0f0;
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            cursor: pointer;
            background: #fff;
        }

        .address-card:hover {
            border-color: var(--accent-pink);
            box-shadow: 0 4px 12px rgba(255,192,203,0.15);
        }

        .address-card input[type="radio"]:checked ~ .address-content {
            border-left: 4px solid var(--accent-pink);
            padding-left: 1rem;
        }

        .address-content {
            transition: all 0.3s ease;
        }

        /* Form Styling */
        .form-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            padding: 0.625rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--accent-pink);
            box-shadow: 0 0 0 0.2rem rgba(255,192,203,0.25);
        }

        /* Order Summary Styling */
        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: start;
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .order-item-info h6 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .order-item-price {
            font-weight: 600;
            color: var(--accent-pink);
            white-space: nowrap;
        }

        /* Shipping & Payment Options */
        .option-card {
            border: 2px solid #f0f0f0;
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            transition: all 0.3s ease;
            cursor: pointer;
            background: #fff;
        }

        .option-card:hover {
            border-color: var(--accent-pink);
            background: #fff8fa;
        }

        .option-card input[type="radio"]:checked + label {
            color: var(--accent-pink);
            font-weight: 600;
        }

        /* Promotion Cards */
        .promotion-card-small {
            transition: all 0.3s ease;
            border: 1px solid #f0f0f0;
            border-radius: 12px;
            cursor: pointer;
            margin-bottom: 0.75rem;
            background: #fff;
        }

        .promotion-card-small:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255,192,203,0.2);
            border-color: var(--accent-pink);
        }

        .promotion-card-small .card-body {
            padding: 1rem;
        }

        .promotion-code {
            font-weight: 700;
            color: var(--accent-pink);
            font-size: 1rem;
        }

        .promotion-list {
            max-height: 250px;
            overflow-y: auto;
            padding: 0.5rem;
            background-color: #fafafa;
            border-radius: 12px;
        }

        /* Discount Input Group */
        .discount-input-group {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .discount-input-group .form-control {
            border-radius: 12px 0 0 12px;
            border-right: none;
        }

        .discount-input-group .btn {
            border-radius: 0 12px 12px 0;
            padding: 0.625rem 1.5rem;
            font-weight: 600;
        }

        /* Summary Items */
        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            font-size: 1rem;
        }

        .summary-item.total {
            border-top: 2px solid var(--accent-pink);
            padding-top: 1rem;
            margin-top: 0.5rem;
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--accent-pink);
        }

        .summary-item.discount {
            color: #28a745;
            font-weight: 600;
        }

        /* Button Styling */
        .btn-primary {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            border: none;
            border-radius: 12px;
            padding: 1rem 2rem;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(255,192,203,0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255,192,203,0.4);
        }

        .btn-outline-secondary {
            border-color: var(--accent-pink);
            color: var(--accent-pink);
            font-weight: 600;
        }

        .btn-outline-secondary:hover {
            background: var(--accent-pink);
            border-color: var(--accent-pink);
        }

        /* Badge Styling */
        .discount-badge {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }

        /* Alert Error Message */
        .alert-danger {
            border-radius: 12px;
            border: none;
            background: #fff0f0;
            color: #dc3545;
            box-shadow: 0 2px 8px rgba(220,53,69,0.1);
        }

        /* Responsive */
        @media (max-width: 991px) {
            .checkout-panel {
                padding: 1.5rem;
            }

            .order-summary-sticky {
                position: relative !important;
                top: auto !important;
            }
        }

        @media (max-width: 767px) {
            .checkout-panel {
                padding: 1rem;
            }

            .section-title {
                font-size: 1.1rem;
            }

            .btn-primary {
                padding: 0.875rem 1.5rem;
                font-size: 1rem;
            }
        }

        /* Sticky Order Summary for Desktop */
        @media (min-width: 992px) {
            .order-summary-sticky {
                position: sticky;
                top: 20px;
            }
        }

        /* New Address Highlight */
        .new-address-section {
            background: #fafafa;
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 1rem;
        }

        /* Divider */
        .section-divider {
            height: 2px;
            background: linear-gradient(to right, transparent, var(--accent-pink), transparent);
            margin: 2rem 0;
            border: none;
        }

        /* Toast for messages */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1055;
        }
    </style>
</head>
<body>

<div id="toast-container" class="toast-container"></div>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Thanh Toán" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <%-- HIỂN THỊ THÔNG BÁO LỖI --%>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <form action="<c:url value='/order/checkout/place-order'/>" method="post">
            <div class="row">
                <%-- CỘT TRÁI: THÔNG TIN GIAO HÀNG --%>
                <div class="col-lg-7">
                    <%-- THÔNG TIN GIAO HÀNG --%>
                    <div class="checkout-panel">
                        <h4 class="section-title">
                            <i class="fas fa-map-marker-alt"></i>
                            Địa chỉ giao hàng
                        </h4>

                        <c:choose>
                            <c:when test="${not empty addresses}">
                                <div class="mb-3">
                                    <c:forEach var="addr" items="${addresses}">
                                        <div class="address-card">
                                            <input class="form-check-input" type="radio" name="selectedAddressId"
                                                   id="addr-${addr.id}" value="${addr.id}" ${addr['default'] ? 'checked' : ''}>
                                            <label class="address-content w-100 ps-3" for="addr-${addr.id}">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div>
                                                        <strong class="d-block mb-1">${addr.recipientName}</strong>
                                                        <span class="text-muted d-block mb-1">
                                                            <i class="fas fa-phone me-1"></i>${addr.phoneNumber}
                                                        </span>
                                                        <span class="text-muted">
                                                            <i class="fas fa-location-dot me-1"></i>
                                                            ${addr.detailAddress}, ${addr.city}
                                                        </span>
                                                    </div>
                                                    <c:if test="${addr['default']}">
                                                        <span class="badge bg-success">Mặc định</span>
                                                    </c:if>
                                                </div>
                                            </label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Bạn chưa có địa chỉ nào. Vui lòng thêm địa chỉ mới bên dưới.
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <hr class="section-divider">

                        <h5 class="mb-3">
                            <i class="fas fa-plus-circle text-muted me-2"></i>
                            Hoặc nhập địa chỉ mới
                        </h5>
                        <div class="new-address-section">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="recipientName" class="form-label">
                                        <i class="fas fa-user me-1"></i>Họ tên người nhận
                                    </label>
                                    <input type="text" class="form-control" id="recipientName" name="newRecipientName"
                                           placeholder="Nhập họ tên">
                                </div>
                                <div class="col-md-6">
                                    <label for="phoneNumber" class="form-label">
                                        <i class="fas fa-phone me-1"></i>Số điện thoại
                                    </label>
                                    <input type="text" class="form-control" id="phoneNumber" name="newPhoneNumber"
                                           placeholder="Nhập số điện thoại">
                                </div>
                                <div class="col-12">
                                    <label for="detailAddress" class="form-label">
                                        <i class="fas fa-home me-1"></i>Địa chỉ chi tiết
                                    </label>
                                    <input type="text" class="form-control" id="detailAddress" name="newDetailAddress"
                                           placeholder="Số nhà, tên đường...">
                                </div>
                                <div class="col-12">
                                    <label for="city" class="form-label">
                                        <i class="fas fa-city me-1"></i>Tỉnh/Thành phố
                                    </label>
                                    <input type="text" class="form-control" id="city" name="newCity"
                                           placeholder="Nhập tỉnh/thành phố">
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- PHƯƠNG THỨC VẬN CHUYỂN --%>
                    <div class="checkout-panel">
                        <h4 class="section-title">
                            <i class="fas fa-truck"></i>
                            Phương thức vận chuyển
                        </h4>
                        <c:forEach var="carrier" items="${carriers}">
                            <div class="option-card">
                                <div class="d-flex align-items-center">
                                    <input class="form-check-input shipping-option me-3" type="radio"
                                           name="shippingCarrierId" id="carrier-${carrier.id}"
                                           value="${carrier.id}" data-fee="${carrier.shippingFee}" required>
                                    <label class="form-check-label flex-grow-1 d-flex justify-content-between align-items-center"
                                           for="carrier-${carrier.id}">
                                        <span>
                                            <i class="fas fa-shipping-fast me-2"></i>${carrier.name}
                                        </span>
                                        <span class="text-primary fw-bold">
                                            <fmt:formatNumber value="${carrier.shippingFee}" type="currency"
                                                            currencySymbol="" maxFractionDigits="0"/>đ
                                        </span>
                                    </label>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <%-- PHƯƠNG THỨC THANH TOÁN --%>
                    <div class="checkout-panel">
                        <h4 class="section-title">
                            <i class="fas fa-credit-card"></i>
                            Phương thức thanh toán
                        </h4>
                        <div class="option-card">
                            <div class="d-flex align-items-center">
                                <input class="form-check-input me-3" type="radio" name="paymentMethod"
                                       id="cod" value="COD" checked>
                                <label class="form-check-label flex-grow-1" for="cod">
                                    <i class="fas fa-money-bill-wave me-2"></i>
                                    Thanh toán khi nhận hàng (COD)
                                </label>
                            </div>
                        </div>
                        <div class="option-card">
                            <div class="d-flex align-items-center">
                                <input class="form-check-input me-3" type="radio" name="paymentMethod"
                                       id="vnpay" value="VNPAY">
                                <label class="form-check-label flex-grow-1" for="vnpay">
                                    <i class="fas fa-qrcode me-2"></i>
                                    Thanh toán qua VNPAY
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- CỘT PHẢI: TÓM TẮT ĐƠN HÀNG --%>
                <div class="col-lg-5">
                    <div class="order-summary-sticky">
                        <div class="checkout-panel">
                            <h4 class="section-title">
                                <i class="fas fa-shopping-bag"></i>
                                Tóm tắt đơn hàng
                            </h4>

                            <%-- DANH SÁCH SẢN PHẨM --%>
                            <div class="mb-3">
                                <c:set var="totalAmount" value="0" />
                                <c:forEach var="item" items="${cart.items}">
                                    <c:set var="totalAmount" value="${totalAmount + item.subtotal}" />
                                    <div class="order-item">
                                        <div class="order-item-info flex-grow-1">
                                            <h6>${item.product.name}</h6>
                                            <small class="text-muted">
                                                <i class="fas fa-store me-1"></i>${item.product.shop.name}
                                            </small>
                                            <div class="text-muted small mt-1">
                                                Số lượng: <strong>x${item.quantity}</strong>
                                            </div>
                                        </div>
                                        <div class="order-item-price">
                                            <fmt:formatNumber value="${item.subtotal}" type="currency"
                                                            currencySymbol="" maxFractionDigits="0"/>đ
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <hr class="section-divider">

                            <%-- MÃ GIẢM GIÁ ĐÃ LƯU --%>
                            <c:if test="${not empty applicablePromotions}">
                                <div class="mb-4">
                                    <h5 class="mb-3">
                                        <i class="fas fa-tag me-2"></i>Mã giảm giá khả dụng
                                    </h5>
                                    <div class="promotion-list">
                                        <c:forEach var="promotion" items="${applicablePromotions}">
                                            <div class="promotion-card-small"
                                                 onclick="selectPromotion('${promotion.code}', '${promotion.description}', ${promotion.discountPercentage})">
                                                <div class="card-body">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div class="flex-grow-1">
                                                            <span class="promotion-code d-block">${promotion.code}</span>
                                                            <small class="text-muted">${promotion.description}</small>
                                                        </div>
                                                        <div class="text-end ms-3">
                                                            <span class="discount-badge">-${promotion.discountPercentage}%</span>
                                                            <c:if test="${promotion.maxDiscountAmount != null}">
                                                                <div class="small text-muted mt-1">
                                                                    Tối đa: <fmt:formatNumber value="${promotion.maxDiscountAmount}"
                                                                                            type="currency" currencySymbol=""
                                                                                            maxFractionDigits="0"/>đ
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <small class="text-muted">
                                        <i class="fas fa-info-circle me-1"></i>Nhấn vào mã để chọn
                                    </small>
                                </div>
                            </c:if>

                            <%-- NHẬP MÃ GIẢM GIÁ --%>
                            <div class="mb-4">
                                <label for="discountCode" class="form-label">
                                    <i class="fas fa-ticket me-1"></i>Mã giảm giá
                                </label>
                                <div class="input-group discount-input-group">
                                    <input type="text" class="form-control" id="discountCode"
                                           placeholder="Nhập hoặc chọn mã">
                                    <button class="btn btn-outline-secondary" type="button" id="applyDiscountBtn">
                                        Áp dụng
                                    </button>
                                </div>
                                <div id="discountMessage" class="form-text mt-2"></div>
                            </div>

                            <hr class="section-divider">

                            <%-- TỔNG KẾT --%>
                            <div class="summary-item">
                                <span>Tạm tính</span>
                                <span id="subtotal-amount">
                                    <fmt:formatNumber value="${cart.totalAmount}" type="currency"
                                                    currencySymbol="" maxFractionDigits="0"/>đ
                                </span>
                            </div>
                            <div class="summary-item">
                                <span>Phí vận chuyển</span>
                                <span id="shipping-fee">0đ</span>
                            </div>
                            <div class="summary-item discount">
                                <span>
                                    <i class="fas fa-gift me-1"></i>Giảm giá
                                </span>
                                <span id="discount-amount">0đ</span>
                            </div>
                            <div class="summary-item total">
                                <span>Tổng cộng</span>
                                <span id="total-amount">
                                    <fmt:formatNumber value="${cart.totalAmount}" type="currency"
                                                    currencySymbol="" maxFractionDigits="0"/>đ
                                </span>
                            </div>

                            <div class="d-grid mt-4">
                                <input type="hidden" id="appliedDiscountCode" name="discountCode" value="">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-check-circle me-2"></i>Hoàn tất Đơn hàng
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Toast notification function
    function showToast(message, isSuccess) {
        const toastContainer = document.getElementById('toast-container');
        const toastId = 'toast-' + Date.now();
        const toastClass = isSuccess ? 'bg-success' : 'bg-danger';
        const toastHtml =
            '<div id="' + toastId + '" class="toast align-items-center text-white ' + toastClass + ' border-0" role="alert" aria-live="assertive" aria-atomic="true">' +
                '<div class="d-flex">' +
                    '<div class="toast-body">' + message + '</div>' +
                    '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
                '</div>' +
            '</div>';

        toastContainer.insertAdjacentHTML('beforeend', toastHtml);
        const toastElement = document.getElementById(toastId);
        const toast = new bootstrap.Toast(toastElement, { delay: 3000 });
        toast.show();
    }

    // Buộc tải lại trang nếu nó được phục hồi từ back-forward cache
    window.addEventListener('pageshow', function(event) {
        if (event.persisted) {
            window.location.reload();
        }
    });

    document.addEventListener('DOMContentLoaded', function () {
        let currentSubtotal = ${cart.totalAmount};
        let currentShippingFee = 0;
        let currentDiscount = 0;
        let appliedDiscountCode = null;

        const shippingOptions = document.querySelectorAll('.shipping-option');
        const subtotalAmountEl = document.getElementById('subtotal-amount');
        const shippingFeeEl = document.getElementById('shipping-fee');
        const discountAmountEl = document.getElementById('discount-amount');
        const totalAmountEl = document.getElementById('total-amount');
        const discountCodeInput = document.getElementById('discountCode');
        const applyDiscountBtn = document.getElementById('applyDiscountBtn');
        const discountMessageEl = document.getElementById('discountMessage');
        const formatter = new Intl.NumberFormat('vi-VN');

        function formatCurrency(amount) {
            return formatter.format(amount) + 'đ';
        }

        function calculateTotal() {
            const finalTotal = currentSubtotal + currentShippingFee - currentDiscount;
            subtotalAmountEl.textContent = formatCurrency(currentSubtotal);
            shippingFeeEl.textContent = formatCurrency(currentShippingFee);
            discountAmountEl.textContent = formatCurrency(currentDiscount);
            totalAmountEl.textContent = formatCurrency(finalTotal);
        }

        // Xử lý thay đổi phí vận chuyển
        shippingOptions.forEach(option => {
            option.addEventListener('change', function () {
                const fee = parseFloat(this.dataset.fee);
                currentShippingFee = fee;
                calculateTotal();

                // Khi phí vận chuyển thay đổi, cần tính toán lại giảm giá nếu có mã đã áp dụng
                if (appliedDiscountCode) {
                    fetch('<c:url value="/order/checkout/apply-discount"/>', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            discountCode: appliedDiscountCode,
                            currentCartTotal: currentSubtotal + currentShippingFee
                        })
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            currentDiscount = data.discountAmount;
                            calculateTotal();
                            showToast('Đã cập nhật giảm giá với phí vận chuyển mới', true);
                        } else {
                            currentDiscount = 0;
                            appliedDiscountCode = null;
                            document.getElementById('appliedDiscountCode').value = '';
                            discountMessageEl.textContent = 'Mã giảm giá không còn hợp lệ với phí vận chuyển mới.';
                            discountMessageEl.className = 'form-text text-warning';
                            calculateTotal();
                        }
                    })
                    .catch(error => {
                        console.error('Lỗi khi tính lại mã giảm giá:', error);
                        showToast('Có lỗi xảy ra khi tính lại mã giảm giá', false);
                    });
                }
            });
        });

        // Xử lý áp dụng mã giảm giá
        applyDiscountBtn.addEventListener('click', function () {
            const code = discountCodeInput.value.trim();
            if (!code) {
                discountMessageEl.textContent = 'Vui lòng nhập mã giảm giá.';
                discountMessageEl.className = 'form-text text-danger';
                return;
            }

            // Hiển thị trạng thái đang xử lý
            discountMessageEl.textContent = 'Đang kiểm tra mã giảm giá...';
            discountMessageEl.className = 'form-text text-info';
            applyDiscountBtn.disabled = true;

            // Gửi yêu cầu AJAX
            fetch('<c:url value="/order/checkout/apply-discount"/>', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    discountCode: code,
                    currentCartTotal: (currentSubtotal + currentShippingFee).toString()
                })
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response ok:', response.ok);

                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Apply discount response:', data);
                console.log('Success value:', data.success, 'Type:', typeof data.success);
                console.log('Discount amount:', data.discountAmount, 'Type:', typeof data.discountAmount);

                applyDiscountBtn.disabled = false;

                if (data.success === true) {
                    // Parse discountAmount as number
                    const discountValue = parseFloat(data.discountAmount);
                    console.log('Parsed discount:', discountValue);

                    if (!isNaN(discountValue) && discountValue >= 0) {
                        currentDiscount = discountValue;
                        appliedDiscountCode = code;
                        document.getElementById('appliedDiscountCode').value = code;
                        discountMessageEl.textContent = data.message || 'Áp dụng mã giảm giá thành công!';
                        discountMessageEl.className = 'form-text text-success';
                        calculateTotal();
                        // Don't show toast, just update the message
                    } else {
                        console.error('Invalid discount amount:', data.discountAmount);
                        currentDiscount = 0;
                        discountMessageEl.textContent = 'Lỗi: Giá trị giảm giá không hợp lệ';
                        discountMessageEl.className = 'form-text text-danger';
                        calculateTotal();
                    }
                } else {
                    currentDiscount = 0;
                    appliedDiscountCode = null;
                    document.getElementById('appliedDiscountCode').value = '';
                    discountMessageEl.textContent = data.message || 'Không thể áp dụng mã giảm giá';
                    discountMessageEl.className = 'form-text text-danger';
                    calculateTotal();
                }
            })
            .catch(error => {
                console.error('Lỗi khi áp dụng mã giảm giá:', error);
                console.error('Error type:', error.name);
                console.error('Error message:', error.message);

                applyDiscountBtn.disabled = false;
                currentDiscount = 0;
                appliedDiscountCode = null;
                document.getElementById('appliedDiscountCode').value = '';
                discountMessageEl.textContent = 'Không thể kết nối đến máy chủ. Vui lòng thử lại.';
                discountMessageEl.className = 'form-text text-danger';
                calculateTotal();
            });
        });

        // Hàm chọn mã giảm giá đã lưu
        window.selectPromotion = function (code, description, discountPercentage) {
            discountCodeInput.value = code;
            discountMessageEl.textContent = 'Đang áp dụng mã giảm giá...';
            discountMessageEl.className = 'form-text text-info';

            // Tính toán lại giảm giá
            fetch('<c:url value="/order/checkout/apply-discount"/>', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    discountCode: code,
                    currentCartTotal: (currentSubtotal + currentShippingFee).toString()
                })
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response ok:', response.ok);

                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Select promotion response:', data);
                console.log('Success value:', data.success, 'Type:', typeof data.success);
                console.log('Discount amount:', data.discountAmount, 'Type:', typeof data.discountAmount);

                if (data.success === true) {
                    // Parse discountAmount as number
                    const discountValue = parseFloat(data.discountAmount);
                    console.log('Parsed discount:', discountValue);

                    if (!isNaN(discountValue) && discountValue >= 0) {
                        currentDiscount = discountValue;
                        appliedDiscountCode = code;
                        document.getElementById('appliedDiscountCode').value = code;
                        discountMessageEl.textContent = data.message || 'Áp dụng mã giảm giá thành công!';
                        discountMessageEl.className = 'form-text text-success';
                        calculateTotal();
                        // Don't show toast, just update the message
                    } else {
                        console.error('Invalid discount amount:', data.discountAmount);
                        currentDiscount = 0;
                        discountMessageEl.textContent = 'Lỗi: Giá trị giảm giá không hợp lệ';
                        discountMessageEl.className = 'form-text text-danger';
                        calculateTotal();
                    }
                } else {
                    currentDiscount = 0;
                    appliedDiscountCode = null;
                    document.getElementById('appliedDiscountCode').value = '';
                    discountMessageEl.textContent = data.message || 'Không thể áp dụng mã giảm giá';
                    discountMessageEl.className = 'form-text text-danger';
                    calculateTotal();
                }
            })
            .catch(error => {
                console.error('Lỗi khi chọn mã giảm giá:', error);
                console.error('Error type:', error.name);
                console.error('Error message:', error.message);
                console.error('Error stack:', error.stack);

                currentDiscount = 0;
                appliedDiscountCode = null;
                document.getElementById('appliedDiscountCode').value = '';
                discountMessageEl.textContent = 'Không thể kết nối đến máy chủ. Vui lòng thử lại.';
                discountMessageEl.className = 'form-text text-danger';
                calculateTotal();
            });
        };

        // Khởi tạo tổng tiền ban đầu
        calculateTotal();
    });
</script>
</body>
</html>
