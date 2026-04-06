<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm - ${product.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }

        .content-panel {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(214,51,132,0.08), 0 1.5px 6px rgba(0,0,0,0.04);
            padding: 2.5rem;
            margin-bottom: 2rem;
        }

        .product-image-gallery .main-image-wrapper { width: 100%; aspect-ratio: 1/1; overflow: hidden; border-radius: 12px; background: #f8f9fa; display: flex; align-items: center; justify-content: center; border: 1px solid #f0f0f0; }
        .product-image-gallery .main-image { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s ease; }
        .product-image-gallery .main-image:hover { transform: scale(1.05); }

        .price-section .price { font-size: 2rem; font-weight: bold; color: var(--accent-pink); }
        .price-section .original-price { font-size: 1.25rem; color: #6c757d; text-decoration: line-through; margin-left: 8px; }
        .price-section .discount-badge { font-size: 1rem; vertical-align: middle; }

        .rating-summary .rating-value { font-size: 1.1rem; font-weight: 600; color: #ffc107; }
        .rating-summary .star-rating .fa-star { color: #ffc107; }
        .rating-summary .star-rating .far.fa-star { color: #e4e5e9; }
        .rating-summary .review-count { color: #6c757d; }

        .quantity-input-wrapper { display: flex; align-items: center; gap: 0.75rem; }
        .quantity-input { border-radius: 1.5rem !important; border: 1px solid var(--border-light) !important; background: #fff !important; box-shadow: none; transition: border 0.2s, box-shadow 0.2s; height: 48px; font-weight: 500; text-align: center; width: 80px; }
        .quantity-input:focus { border-color: var(--accent-pink) !important; box-shadow: 0 0 0 3px rgba(255,192,203,0.25); }

        .btn-action { border-radius: 1.5rem !important; padding: 0.65rem 1.5rem !important; font-weight: 600; font-size: 1rem; line-height: 1.5; }

        .review-card { border: none; border-bottom: 1px solid #f0f0f0; padding: 1.5rem 0; }
        .review-card:last-child { border-bottom: none; padding-bottom: 0; }
        .review-card:first-child { padding-top: 0; }
        .review-author-avatar { width: 48px; height: 48px; border-radius: 50%; margin-right: 1rem; background-color: #e9ecef; display: flex; align-items: center; justify-content: center; }
        .review-author-avatar i { font-size: 1.8rem; color: #adb5bd; }
        .review-rating .fa-star { color: #ffc107; }
        .review-rating .far.fa-star { color: #e4e5e9; }
        .review-image-thumb { max-width: 100px; height: 100px; object-fit: cover; border-radius: 8px; cursor: pointer; margin-top: 0.5rem; }

        /* Product Card Styles (from list.jsp) */
        .product-card { border: 1px solid #f0f0f0; transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 .5rem 1rem rgba(0,0,0,.1)!important; border-color: var(--border-light); }
        .product-card .card-img-top-wrapper { width: 100%; aspect-ratio: 1/1; overflow: hidden; border-radius: 12px 12px 0 0; background: #f8f9fa; display: flex; align-items: center; justify-content: center; }
        .product-card .card-img-top { width: 100%; height: 100%; object-fit: cover; aspect-ratio: 1/1; border-radius: 12px 12px 0 0; transition: transform 0.3s cubic-bezier(.4,2,.6,.8); }
        .product-card .card-img-top:hover { transform: scale(1.08) rotate(-2deg); }
        .product-card .card-body { display: flex; flex-direction: column; padding: 1rem; }
        .product-card .card-title { font-size: 1rem; font-weight: 600; margin-bottom: 0.25rem; }
        .product-card .price { font-size: 1.2rem; font-weight: bold; color: var(--accent-pink); }
        .product-card .original-price { font-size: 0.9rem; color: #6c757d; text-decoration: line-through; margin-left: 6px; }
        .product-card .rating { font-size: 0.9rem; }
        .product-card .btn-add-to-cart { padding: 6px 12px !important; font-size: 1rem; line-height: 1; border-radius: 10px !important; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-4">
    <div class="container">
        <c:choose>
            <c:when test="${not empty product}">
                <!-- Product Detail Panel -->
                <section class="content-panel">
                    <div class="row">
                        <div class="col-lg-6 product-image-gallery mb-4 mb-lg-0">
                            <div class="main-image-wrapper">
                                <img src="<c:url value='/${product.imageUrl}'/>" alt="${product.name}" class="main-image">
                            </div>
                        </div>
                        <div class="col-lg-6 ps-lg-4">
                            <c:set var="pageTitle" value="${product.name}" />
                            <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />
                            <p class="text-muted mb-3">Cung cấp bởi: <a href="<c:url value='/shop/${product.shop.id}'/>" class="fw-bold text-decoration-none">${product.shop.name}</a></p>
                            <div class="d-flex align-items-center mb-3 rating-summary">
                                <span class="rating-value me-2">${product.averageRating > 0 ? String.format("%.1f", product.averageRating) : "Mới"}</span>
                                <span class="star-rating me-2">
                                    <c:forEach var="i" begin="1" end="5">
                                        <c:choose>
                                            <c:when test="${product.averageRating >= i}"><i class="fas fa-star"></i></c:when>
                                            <c:when test="${product.averageRating > (i - 1)}"><i class="fas fa-star-half-alt"></i></c:when>
                                            <c:otherwise><i class="far fa-star"></i></c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                                <span class="review-count">(${product.reviewCount} đánh giá)</span>
                            </div>
                            <div class="my-4 price-section">
                                <c:choose>
                                    <c:when test="${not empty product.activeDiscount}">
                                        <span class="price"><fmt:formatNumber value="${product.discountedPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                        <span class="original-price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                        <span class="badge bg-danger discount-badge">-${product.activeDiscount.discountPercentage}%</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <p class="lead">${product.description}</p>
                            <hr>
                            <p><strong>Tình trạng:</strong>
                                <c:if test="${product.stock > 0}"><span class="text-success">Còn hàng (${product.stock} sản phẩm)</span></c:if>
                                <c:if test="${product.stock <= 0}"><span class="text-danger">Hết hàng</span></c:if>
                            </p>
                            <form action="<c:url value='/cart/add'/>" method="post" id="detailAddForm">
                                <input type="hidden" name="productId" value="${product.id}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <div class="d-flex align-items-center mt-4">
                                    <div class="quantity-input-wrapper me-3">
                                        <label for="quantity" class="form-label mb-0 fw-normal">Số lượng:</label>
                                        <input type="number" id="quantity" name="quantity" value="1" min="1" max="${product.stock}" class="form-control quantity-input">
                                    </div>
                                </div>
                            </form>
                            <div class="d-flex align-items-center mt-3">
                                <sec:authorize access="isAuthenticated()">
                                    <button type="button" class="btn btn-primary btn-action flex-grow-1" id="detailAddBtn" data-product-id="${product.id}" ${product.stock <= 0 ? 'disabled' : ''}>
                                        <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ hàng
                                    </button>
                                </sec:authorize>
                                <sec:authorize access="!isAuthenticated()">
                                    <button type="submit" form="detailAddForm" class="btn btn-primary btn-action flex-grow-1" ${product.stock <= 0 ? 'disabled' : ''}>
                                        <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ hàng
                                    </button>
                                </sec:authorize>
                                <sec:authorize access="isAuthenticated()">
                                    <c:choose>
                                        <c:when test="${isWishlisted}">
                                            <form action="<c:url value='/wishlist/remove/${product.id}'/>" method="post" class="ms-2">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-danger btn-action" title="Xóa khỏi danh sách yêu thích"><i class="fas fa-heart"></i></button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="<c:url value='/wishlist/add/${product.id}'/>" method="post" class="ms-2">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-outline-danger btn-action" title="Thêm vào danh sách yêu thích"><i class="far fa-heart"></i></button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </sec:authorize>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Review Panel -->
                <section class="content-panel">
                    <h2 class="mb-4">Đánh giá sản phẩm</h2>
                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <c:forEach var="review" items="${reviews}">
                                <div class="review-card">
                                    <div class="d-flex">
                                        <div class="flex-shrink-0 review-author-avatar"><i class="fas fa-user-circle"></i></div>
                                        <div class="flex-grow-1">
                                            <div class="d-flex justify-content-between">
                                                <span class="fw-bold">${review.user.fullName}</span>
                                                <small class="text-muted"><fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/></small>
                                            </div>
                                            <div class="review-rating my-1">
                                                <c:forEach var="i" begin="1" end="5"><i class="${i <= review.rating ? 'fas' : 'far'} fa-star"></i></c:forEach>
                                            </div>
                                            <p class="card-text mb-0">${review.comment}</p>
                                            <c:if test="${not empty review.imageUrl}">
                                                <img src="<c:url value='/${review.imageUrl}'/>" alt="Review image" class="rounded review-image-thumb">
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                        </c:otherwise>
                    </c:choose>
                </section>

                <!-- Related Products Panel -->
                <section class="content-panel">
                    <h2 class="mb-4">Có thể bạn cũng thích</h2>
                    <c:choose>
                        <c:when test="${not empty relatedProducts}">
                            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                                <c:forEach var="relatedProduct" items="${relatedProducts}">
                                    <div class="col">
                                        <div class="card h-100 product-card">
                                            <a href="<c:url value='/product/${relatedProduct.id}'/>">
                                                <div class="card-img-top-wrapper">
                                                    <img src="<c:url value='/${relatedProduct.imageUrl}'/>" class="card-img-top" alt="${relatedProduct.name}">
                                                </div>
                                            </a>
                                            <div class="card-body">
                                                <h5 class="card-title"><a href="<c:url value='/product/${relatedProduct.id}'/>" class="text-decoration-none text-dark">${relatedProduct.name}</a></h5>
                                                <p class="card-text mb-0">
                                                    <c:choose>
                                                        <c:when test="${relatedProduct.discountedPrice != null}">
                                                            <span class="price"><fmt:formatNumber value="${relatedProduct.discountedPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                            <span class="original-price"><fmt:formatNumber value="${relatedProduct.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                            <span class="badge bg-danger discount-badge">-${relatedProduct.activeDiscount.discountPercentage}%</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="price"><fmt:formatNumber value="${relatedProduct.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <p class="card-text"><small class="text-muted">Bán bởi: ${relatedProduct.shop.name}</small></p>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div class="rating">
                                                        <c:forEach begin="1" end="5" varStatus="loop">
                                                            <i class="fas fa-star <c:if test='${loop.index <= relatedProduct.averageRating}'>text-warning</c:if><c:if test='${loop.index > relatedProduct.averageRating}'>text-secondary</c:if>"></i>
                                                        </c:forEach>
                                                        <small class="text-muted">(${relatedProduct.reviewCount})</small>
                                                    </div>
                                                    <sec:authorize access="isAuthenticated()">
                                                        <button class="btn btn-sm btn-outline-primary btn-add-to-cart" onclick="addToCart(${relatedProduct.id})" data-product-id="${relatedProduct.id}"><i class="fas fa-cart-plus"></i></button>
                                                    </sec:authorize>
                                                    <sec:authorize access="!isAuthenticated()">
                                                        <a href="<c:url value='/login'/>" class="btn btn-sm btn-outline-primary"><i class="fas fa-cart-plus"></i></a>
                                                    </sec:authorize>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p>Không có sản phẩm nào để hiển thị.</p>
                        </c:otherwise>
                    </c:choose>
                </section>

            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <h2>Sản phẩm không tồn tại</h2>
                    <p class="lead">Sản phẩm bạn đang tìm kiếm không có sẵn hoặc đã bị xóa.</p>
                    <a href="<c:url value='/home'/>" class="btn btn-primary btn-lg mt-3">Quay về trang chủ</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
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
        const socket = new SockJS('${pageContext.request.contextPath}/ws');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function (frame) {
            console.log('Connected: ' + frame);
            stompClient.subscribe('/user/topic/cart-updates', function (response) {
                const body = JSON.parse(response.body);
                if (window.cartFeedback && typeof window.cartFeedback.notifyServerResponse === 'function') {
                    window.cartFeedback.notifyServerResponse(body);
                }
            });
        }, function(error) {
            console.error('STOMP error', error);
            showToast("Không thể kết nối đến máy chủ. Vui lòng thử lại.", false);
        });
    }

    function addToCart(productId) {
        const client = (window.sharedStompClient && window.sharedStompClient.connected) ? window.sharedStompClient
            : (stompClient && stompClient.connected) ? stompClient
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

        if (window.sharedStompClient == null) {
            try { connect(); } catch (e) { console.warn('connect() not available', e); }
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        // Connect to WebSocket for authenticated users
        <sec:authorize access="isAuthenticated()">
            if (typeof connect === 'function') {
                connect();
            }
        </sec:authorize>

        // Handler for the main product's add-to-cart button
        const detailBtn = document.getElementById('detailAddBtn');
        if (detailBtn) {
            detailBtn.addEventListener('click', function() {
                const productId = this.getAttribute('data-product-id');
                const qtyInput = document.getElementById('quantity');
                const quantity = qtyInput ? parseInt(qtyInput.value || '1', 10) : 1;

                if (window.cartFeedback && typeof window.cartFeedback.setAddingFor === 'function') {
                    window.cartFeedback.setAddingFor(this);
                }

                const client = (window.sharedStompClient && window.sharedStompClient.connected) ? window.sharedStompClient : stompClient;
                if (client && client.connected) {
                    client.send('/app/cart/add', {}, JSON.stringify({ productId: productId, quantity: quantity }));
                } else {
                    const form = document.getElementById('detailAddForm');
                    if (form) form.submit();
                }
            });
        }
    });
</script>
</body>
</html>
