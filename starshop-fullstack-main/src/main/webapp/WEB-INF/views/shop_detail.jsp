<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${shop.name} - StarShop</title>
    <!-- Bootstrap CSS (align with promotions page) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }
        /* Promo-like vertical section wrapper */
        .promotion-section {
            width: 100%;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 2rem 1.5rem 1.5rem 1.5rem;
            margin-bottom: 2.5rem;
        }
        .promotion-section h2 {
            font-size: 1.75rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            letter-spacing: 1px;
            color: var(--header-text-color);
        }
        /* Product card image wrapper & hover (match promotions page feel) */
        .product-card .card-img-top-wrapper {
            width: 100%;
            aspect-ratio: 1/1;
            overflow: hidden;
            border-radius: 12px 12px 0 0;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .product-card .card-img-top {
            width: 100%;
            height: 100%;
            object-fit: cover;
            aspect-ratio: 1/1;
            border-radius: 12px 12px 0 0;
            transition: transform 0.3s cubic-bezier(.4,2,.6,.8);
        }
        .product-card .card-img-top:hover { transform: scale(1.06) rotate(-1.5deg); }
        /* Price styles to match promotions page */
        .product-card .price {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--accent-pink);
        }
        .product-card .original-price { font-size: 0.9rem; color: #6c757d; text-decoration: line-through; margin-left: 6px; }
        .product-card .discount-badge { margin-left: 5px; }

        /* Adjusted shop avatar for detail page within a white section */
        .shop-avatar-large {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: #f8f9fa; /* Light background */
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: var(--header-text-color); /* Theme color for icon */
            border: 4px solid var(--primary-color); /* Theme color border */
            box-shadow: 0 2px 12px rgba(0,0,0,0.07); /* Consistent shadow */
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/shared/header.jsp"/>

    <main class="main-content py-5">
        <div class="container">
            <!-- Shop Information Section -->
            <section class="promotion-section mb-5">
                <div class="d-flex align-items-center mb-4">
                    <div class="shop-avatar-large me-4">
                        <i class="bi bi-shop"></i>
                    </div>
                    <div>
                        <h2 class="gradient-text animated-gradient text-uppercase">${shop.name}</h2>
                        <p class="text-muted">${shop.description != null && shop.description != '' ? shop.description : 'Chưa có mô tả về cửa hàng này.'}</p>
                        <div class="mt-3">
                            <a href="#" class="btn btn-outline-primary btn-lg me-2" id="chatWithShopBtn" 
                               data-shop-owner-username="${shop.owner.username}" 
                               data-shop-owner-displayname="${shop.name}"> <!-- CHANGED HERE -->
                                <i class="bi bi-chat-dots me-2"></i>Nhắn tin với Shop
                            </a>
                        </div>
                    </div>
                </div>
                <div class="section-divider"></div>
            </section>

            <!-- Products Section -->
            <section id="shopProductsSection" class="promotion-section">
                <h2 class="gradient-text animated-gradient text-center text-uppercase">Sản phẩm của ${shop.name}</h2>
                <div class="section-divider"></div>
                <div id="shopProductsResults" class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                    <c:choose>
                        <c:when test="${not empty shopProducts}">
                            <c:forEach var="product" items="${shopProducts}">
                                <div class="col">
                                    <div class="card h-100 shadow-sm product-card">
                                        <a href="<c:url value='/product/${product.id}'/>">
                                            <div class="card-img-top-wrapper">
                                                <img src="<c:url value='/${product.imageUrl}'/>" class="card-img-top" alt="${product.name}">
                                            </div>
                                        </a>
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title mb-2"><a href="<c:url value='/product/${product.id}'/>" class="text-decoration-none text-dark">${product.name}</a></h5>
                                            <p class="card-text mb-0">
                                                <c:choose>
                                                    <c:when test="${product.discountedPrice != null}">
                                                        <span class="price"><fmt:formatNumber value="${product.discountedPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                        <span class="original-price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                        <span class="badge bg-danger discount-badge">-${product.activeDiscount.discountPercentage}%</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <div class="d-flex justify-content-between align-items-center mt-2">
                                                <sec:authorize access="isAuthenticated()">
                                                    <button class="btn btn-sm btn-outline-primary btn-add-to-cart" data-product-id="${product.id}"><i class="fas fa-cart-plus"></i></button>
                                                </sec:authorize>
                                                <sec:authorize access="isAnonymous()">
                                                    <a href="<c:url value='/login'/>" class="btn btn-sm btn-outline-primary"><i class="fas fa-cart-plus"></i></a>
                                                </sec:authorize>
                                                <a href="<c:url value='/product/${product.id}'/>" class="btn btn-primary btn-sm">Xem Chi Tiết</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center py-4">
                                <p class="text-muted">Shop này hiện chưa có sản phẩm nào được hiển thị.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/shared/footer.jsp"/>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Include SockJS and STOMP libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <script>
        // isAuthenticated is already defined in header.jsp, no need to redefine here.
        // wsUrl is also defined in header.jsp

        let stompClient = null;

        function showToast(message, isSuccess) {
            const toastContainer = document.getElementById('toast-container');
            if (!toastContainer) return;
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

        function connect() {
            const socket = new SockJS('<c:url value="/ws"/>'); // Use c:url for context path
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function (frame) {
                console.log('Connected: ' + frame);
                stompClient.subscribe('/user/topic/cart-updates', function (response) {
                    const body = JSON.parse(response.body);
                    if (window.cartFeedback && typeof window.cartFeedback.notifyServerResponse === 'function') {
                        window.cartFeedback.notifyServerResponse(body);
                    } else {
                        showToast(body.message, body.success);
                    }
                });
            }, function(error) {
                console.error('STOMP error', error);
                showToast("Không thể kết nối đến máy chủ. Vui lòng thử lại.", false);
            });
        }

        function addToCart(productId) {
            const client = (window.sharedStompClient && window.sharedStompClient.connected) ? window.sharedStompClient
                : (typeof stompClient !== 'undefined' && stompClient && stompClient.connected) ? stompClient
                : null;

            const payload = { 'productId': productId, 'quantity': 1 };

            if (client && client.connected) {
                client.send('/app/cart/add', {}, JSON.stringify(payload));
                return;
            }

            if (window.cartFeedback && typeof window.cartFeedback.notifyServerResponse === 'function') {
                window.cartFeedback.notifyServerResponse({ message: 'Chưa kết nối. Vui lòng thử lại.', success: false });
            } else {
                showToast("Chưa kết nối. Vui lòng thử lại.", false);
            }

            // Attempt to connect if not already connected
            if (!client && typeof connect === 'function') {
                console.log('Attempting to connect WebSocket for addToCart...');
                connect();
                // After connecting, the user might need to click again or we can re-attempt sending
                // For simplicity, we'll let the user click again after connection is established.
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            <sec:authorize access="isAuthenticated()">
                // Connect WebSocket only if authenticated
                if (typeof connect === 'function') {
                    connect();
                }
            </sec:authorize>

            // Event delegation for add-to-cart buttons
            document.getElementById('shopProductsResults').addEventListener('click', function (e) {
                const btn = e.target.closest('.btn-add-to-cart');
                if (!btn) return;
                const productId = btn.getAttribute('data-product-id');
                if (!productId) return;

                // Optional: visual feedback for adding to cart
                // if (window.cartFeedback && typeof window.cartFeedback.setAddingFor === 'function') {
                //     window.cartFeedback.setAddingFor(btn);
                // }
                addToCart(parseInt(productId, 10));
            });

            // Handle chat with shop button
            const chatWithShopBtn = document.getElementById('chatWithShopBtn');
            if (chatWithShopBtn) {
                chatWithShopBtn.addEventListener('click', function(e) {
                    e.preventDefault(); // Prevent default link navigation
                    const shopOwnerUsername = this.getAttribute('data-shop-owner-username');
                    const shopOwnerDisplayName = this.getAttribute('data-shop-owner-displayname');

                    if (shopOwnerUsername && typeof window.startPrivateChat === 'function') {
                        window.startPrivateChat(shopOwnerUsername, shopOwnerDisplayName);
                    } else if (typeof loggedInUsername === 'undefined') {
                        alert("Bạn cần đăng nhập để sử dụng tính năng chat.");
                    } else {
                        console.error("Could not initiate chat. shopOwnerUsername or window.startPrivateChat not available.");
                    }
                });
            }
        });
    </script>
</body>
</html>
