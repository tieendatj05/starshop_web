<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; padding-bottom: 150px; /* Add padding for sticky footer */ }
        .toast-container { position: fixed; top: 20px; right: 20px; z-index: 1055; }

        /* Cart Panel */
        .cart-panel {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 1.5rem;
        }

        /* Cart Item Layout */
        .cart-item {
            display: grid;
            grid-template-columns: 100px 1fr auto; /* Image | Details | Actions */
            gap: 1rem 1.5rem;
            align-items: center;
        }
        .cart-item:not(:last-child) { padding-bottom: 1.5rem; margin-bottom: 1.5rem; border-bottom: 1px solid #f0f0f0; }
        
        .cart-item-image img { width: 100px; height: 100px; object-fit: cover; border-radius: 12px; border: 1px solid #f0f0f0; }
        .cart-item-details h5 { font-size: 1.1rem; font-weight: 600; margin-bottom: 0.25rem; }

        .cart-item-actions {
            display: grid;
            grid-template-columns: 1fr 120px auto; /* Subtotal | Quantity | Remove */
            align-items: center;
            gap: 1.5rem;
            justify-content: end;
        }
        .cart-item-subtotal { text-align: left; font-weight: bold; font-size: 1.1rem; }

        /* Quantity Controls */
        .quantity-control { display: flex; align-items: center; border: 1px solid var(--border-light); border-radius: 50px; overflow: hidden; background: #fff; box-shadow: 0 1px 4px rgba(0,0,0,0.04); justify-self: center; }
        .quantity-btn { background: transparent; border: none; font-size: 1rem; font-weight: bold; padding: 0.5rem 0.75rem; cursor: pointer; color: var(--accent-pink); line-height: 1; }
        .quantity-btn:hover { background-color: #fff8fa; }
        .quantity-input { width: 40px; text-align: center; border: none; font-weight: 600; color: var(--text-dark); background: transparent; -moz-appearance: textfield; }
        .quantity-input:focus { outline: none; }
        .quantity-input::-webkit-outer-spin-button, .quantity-input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }

        /* Remove Button */
        .btn-ghost-danger { background: transparent !important; border: none !important; color: #dc3545 !important; padding: 4px 8px !important; border-radius: 8px !important; font-weight: 500; font-size: 1.2rem; box-shadow: none !important; }
        .btn-ghost-danger:hover { background-color: rgba(220, 53, 69, 0.08) !important; }

        /* Sticky Summary Footer */
        .cart-summary-footer {
            position: sticky;
            bottom: 0;
            z-index: 1020;
            padding-bottom: 1.5rem; /* Space above the real footer */
        }
        .summary-panel-sticky {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 -4px 20px rgba(0,0,0,0.08);
            padding: 1rem 1.5rem;
            border: 1px solid #f0f0f0;
        }
        .summary-content {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 1.5rem;
        }
        .summary-total-text { font-size: 1.1rem; }
        .summary-total-amount { font-size: 1.5rem; font-weight: bold; color: var(--accent-pink); }
        .summary-checkout-btn { min-width: 220px; font-size: 1.1rem; font-weight: 600; }

        /* Invalid Item */
        .cart-item.invalid-item { background-color: rgba(220, 53, 69, 0.05); border-radius: 12px; padding: 1rem; }

        /* Responsive */
        @media (max-width: 991px) {
            .cart-item-actions { grid-template-columns: 1fr; gap: 0.8rem; justify-items: end; }
            .cart-item-subtotal { grid-row: 1; }
            .cart-item-quantity { grid-row: 2; }
            .cart-item-remove { grid-row: 3; }
        }
        @media (max-width: 767px) {
            .summary-content { flex-direction: column; align-items: stretch; gap: 1rem; }
            .summary-checkout-btn { width: 100%; }
            .main-content { padding-bottom: 200px; } /* More padding for taller mobile footer */
        }
        @media (max-width: 576px) {
            .cart-item {
                grid-template-columns: 80px 1fr;
                grid-template-areas: "image details" "image actions";
                align-items: start;
            }
            .cart-item-image img { width: 80px; height: 80px; }
            .cart-item-actions { grid-area: actions; grid-template-columns: 1fr auto; justify-items: start; width: 100%; gap: 1rem; }
            .cart-item-subtotal { text-align: left; }
            .cart-item-remove { justify-self: end; }
        }
    </style>
</head>
<body>

<div id="toast-container" class="toast-container"></div>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Giỏ Hàng Của Bạn" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <c:choose>
            <c:when test="${not empty cart.items}">
                <div class="row">
                    <div class="col-12">
                        <div class="cart-panel" id="cart-items-container">
                            <c:forEach var="item" items="${cart.items}">
                                <c:set var="displayPrice" value="${item.product.discountedPrice != null ? item.product.discountedPrice : item.product.price}" />
                                <div class="cart-item cart-item-row ${!item.valid ? 'invalid-item' : ''}" data-product-id="${item.product.id}" data-price="${displayPrice}">
                                    <div class="cart-item-image">
                                        <img src="<c:url value='/${item.product.imageUrl}'/>" alt="${item.product.name}">
                                    </div>
                                    <div class="cart-item-details">
                                        <h5>${item.product.name}</h5>
                                        <p class="text-muted small mb-1">Bán bởi: ${item.product.shop.name}</p>
                                        <c:if test="${!item.valid}">
                                            <div class="alert alert-danger p-2 mt-2 invalid-reason">${item.invalidReason}</div>
                                        </c:if>
                                    </div>
                                    <div class="cart-item-actions">
                                        <div class="cart-item-subtotal">
                                            <strong class="item-subtotal"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</strong>
                                        </div>
                                        <div class="cart-item-quantity">
                                            <div class="quantity-control">
                                                <button class="quantity-btn minus-btn">-</button>
                                                <input type="number" class="quantity-input" value="${item.quantity}" min="0" data-stock="${item.product.stock}">
                                                <button class="quantity-btn plus-btn">+</button>
                                            </div>
                                        </div>
                                        <div class="cart-item-remove">
                                            <form action="<c:url value='/cart/remove'/>" method="post">
                                                <input type="hidden" name="productId" value="${item.product.id}"/>
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-ghost-danger"><i class="fas fa-trash"></i></button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <p class="fs-5">Giỏ hàng của bạn đang trống.</p>
                    <a href="<c:url value='/products'/>" class="btn btn-primary btn-lg mt-3">Tiếp tục mua sắm</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Sticky Footer for Cart Summary -->
<c:if test="${not empty cart.items}">
    <div class="cart-summary-footer">
        <div class="container">
            <div class="summary-panel-sticky">
                <div class="summary-content">
                    <div class="summary-total-text">
                        Tổng thanh toán:
                        <span class="summary-total-amount" id="cart-final-total">
                            <fmt:formatNumber value="${cart.totalAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ
                        </span>
                    </div>
                    <div class="summary-checkout-btn">
                        <c:choose>
                            <c:when test="${cart.checkoutAllowed}">
                                <a href="<c:url value='/order/checkout'/>" class="btn btn-primary w-100">Tiến hành thanh toán</a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-primary w-100" disabled>Tiến hành thanh toán</button>
                                <p class="text-danger small mt-1 mb-0 text-center">Xóa sản phẩm không hợp lệ để tiếp tục</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:if>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
    // Existing JS code remains the same...
    function showToast(message, isSuccess) {
        const toastContainer = document.getElementById('toast-container');
        const toastId = 'toast-' + Date.now();
        const toastClass = isSuccess ? 'bg-success' : 'bg-danger';
        const toastHtml = `
            <div id="${toastId}" class="toast align-items-center text-white ${toastClass} border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex"><div class="toast-body">${message}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button></div>
            </div>
        `;
        toastContainer.insertAdjacentHTML('beforeend', toastHtml);
        const toastElement = document.getElementById(toastId);
        const toast = new bootstrap.Toast(toastElement, { delay: 3000 });
        toast.show();
    }

    document.addEventListener('DOMContentLoaded', function() {
        let stompClient = null;
        let debounceTimer = null;

        function connect() {
            const socket = new SockJS('<c:url value="/ws"/>');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function (frame) {
                console.log('Connected: ' + frame);
                stompClient.subscribe('/user/topic/cart-state', function (response) {
                    const updatedCart = JSON.parse(response.body);
                    updateCartView(updatedCart);
                });
                stompClient.subscribe('/user/topic/cart-errors', function (response) {
                    const error = JSON.parse(response.body);
                    showToast(error.message, false);
                    setTimeout(() => window.location.reload(), 2000);
                });
            }, function(error) {
                console.error('STOMP error', error);
                showToast("Mất kết nối với máy chủ giỏ hàng.", false);
            });
        }

        function sendQuantityUpdate(productId, quantity) {
            if (stompClient && stompClient.connected) {
                const payload = { 'productId': productId, 'quantity': quantity };
                stompClient.send("/app/cart/update", {}, JSON.stringify(payload));
            } else {
                showToast("Chưa kết nối. Đang thử kết nối lại...", false);
                connect();
            }
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount) + 'đ';
        }

        function calculateAndDisplayOptimisticTotals() {
            let newCartTotalAmount = 0;
            document.querySelectorAll('.cart-item-row').forEach(row => {
                const quantityInput = row.querySelector('.quantity-input');
                const pricePerItem = parseFloat(row.dataset.price);
                const currentQuantity = parseInt(quantityInput.value);

                if (!isNaN(pricePerItem) && !isNaN(currentQuantity)) {
                    const newSubtotal = pricePerItem * currentQuantity;
                    row.querySelector('.item-subtotal').textContent = formatCurrency(newSubtotal);
                    newCartTotalAmount += newSubtotal;
                }
            });

            document.getElementById('cart-final-total').textContent = formatCurrency(newCartTotalAmount);
        }

        function setupEventListeners() {
             document.querySelectorAll('.quantity-control').forEach(control => {
                const input = control.querySelector('.quantity-input');
                const minusBtn = control.querySelector('.minus-btn');
                const plusBtn = control.querySelector('.plus-btn');
                const row = control.closest('.cart-item-row');
                const productId = row.dataset.productId;
                const maxStock = parseInt(input.dataset.stock);

                minusBtn.addEventListener('click', () => {
                    let currentValue = parseInt(input.value);
                    if (currentValue > 0) {
                        input.value = currentValue - 1;
                        calculateAndDisplayOptimisticTotals();
                        sendQuantityUpdate(productId, input.value);
                    }
                });

                plusBtn.addEventListener('click', () => {
                    let currentValue = parseInt(input.value);
                    if (currentValue < maxStock) {
                        input.value = currentValue + 1;
                        calculateAndDisplayOptimisticTotals();
                        sendQuantityUpdate(productId, input.value);
                    }
                    else if (currentValue >= maxStock) {
                        showToast(`Số lượng tồn kho không đủ. Chỉ còn ${maxStock} sản phẩm.`, false);
                    }
                });

                input.addEventListener('input', () => {
                    clearTimeout(debounceTimer);
                    debounceTimer = setTimeout(() => {
                        let newQuantity = parseInt(input.value);
                        if (isNaN(newQuantity) || newQuantity < 0) newQuantity = 0;
                        if (newQuantity > maxStock) {
                            newQuantity = maxStock;
                            input.value = newQuantity;
                            showToast(`Số lượng tồn kho không đủ. Chỉ còn ${maxStock} sản phẩm.`, false);
                        }
                        calculateAndDisplayOptimisticTotals();
                        sendQuantityUpdate(productId, newQuantity);
                    }, 500);
                });
            });
        }

        function updateCartView(cart) {
            try {
                const cartFinalTotalElement = document.getElementById('cart-final-total');
                if (cartFinalTotalElement) cartFinalTotalElement.textContent = formatCurrency(cart.totalAmount);

                cart.items.forEach(item => {
                    const row = document.querySelector(`.cart-item-row[data-product-id='${item.product.id}']`);
                    if (row) {
                        const quantityInput = row.querySelector('.quantity-input');
                        if (quantityInput) quantityInput.value = item.quantity;
                        const itemSubtotalElement = row.querySelector('.item-subtotal');
                        if (itemSubtotalElement) itemSubtotalElement.textContent = formatCurrency(item.subtotal);

                        const invalidReasonDiv = row.querySelector('.invalid-reason');
                        if (item.valid) {
                            row.classList.remove('invalid-item');
                            if(invalidReasonDiv) invalidReasonDiv.style.display = 'none';
                        } else {
                            row.classList.add('invalid-item');
                            if(invalidReasonDiv) {
                                invalidReasonDiv.textContent = item.invalidReason;
                                invalidReasonDiv.style.display = 'block';
                            } else {
                                const newInvalidReasonDiv = document.createElement('div');
                                newInvalidReasonDiv.className = 'alert alert-danger p-2 mt-2 invalid-reason';
                                newInvalidReasonDiv.textContent = item.invalidReason;
                                row.querySelector('.cart-item-details').appendChild(newInvalidReasonDiv);
                            }
                        }
                    }
                });

                document.querySelectorAll('.cart-item-row').forEach(row => {
                    const productId = row.dataset.productId;
                    if (!cart.items.some(item => item.product.id == productId)) {
                        const hrElement = row.nextElementSibling;
                        if (hrElement && hrElement.tagName === 'HR') hrElement.remove();
                        row.remove();
                    }
                });

                const checkoutContainer = document.querySelector('.summary-checkout-btn');
                if (checkoutContainer) {
                    if (cart.checkoutAllowed) {
                        checkoutContainer.innerHTML = `<a href="<c:url value='/order/checkout'/>" class="btn btn-primary w-100">Tiến hành thanh toán</a>`;
                    } else {
                        checkoutContainer.innerHTML = `<button class="btn btn-primary w-100" disabled>Tiến hành thanh toán</button><p class="text-danger small mt-1 mb-0 text-center">Xóa sản phẩm không hợp lệ để tiếp tục</p>`;
                    }
                }

                if (cart.items.length === 0 && document.querySelectorAll('.cart-item-row').length > 0) {
                    window.location.reload();
                }
            } catch (e) {
                console.error('Error during updateCartView:', e);
                showToast('Có lỗi xảy ra khi cập nhật giỏ hàng. Vui lòng tải lại trang.', false);
            }
        }

        <sec:authorize access="isAuthenticated()">
            connect();
            setupEventListeners();
        </sec:authorize>
    });
</script>

</body>
</html>