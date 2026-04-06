<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }

        /* Unified Product Panel */
        .product-listing-panel {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(214,51,132,0.08), 0 1.5px 6px rgba(0,0,0,0.04);
            /* Increase bottom padding for breathing room below the grid */
            padding: 2.5rem 2.5rem 3.25rem 2.5rem;
            margin-top: 1rem;
        }

        /* Panel Header for Sorting */
        .panel-header {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding-bottom: 1.5rem;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid #f0f0f0;
        }

        /* Modern Dropdown Styles */
        .modern-dropdown { min-width: 220px; position: relative; }
        .input-icon-wrapper { position: relative; }
        .input-icon { position: absolute; left: 18px; top: 50%; transform: translateY(-50%); color: var(--accent-pink); pointer-events: none; }
        .modern-select { padding-left: 2.5rem !important; border-radius: 1.5rem !important; border: 1px solid var(--border-light) !important; background: #fff !important; box-shadow: none; transition: border 0.2s, box-shadow 0.2s; appearance: none; height: 48px; font-weight: 500; }
        .modern-select:focus { border-color: var(--accent-pink) !important; box-shadow: 0 0 0 3px rgba(255,192,203,0.25); }
        .dropdown-arrow { position: absolute; right: 18px; top: 50%; transform: translateY(-50%); color: var(--accent-pink); pointer-events: none; }
        .form-label { font-weight: 600; color: var(--text-dark); }

        /* Product Card Styles */
        .product-card {
            border: 1px solid #f0f0f0;
            transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 .5rem 1rem rgba(0,0,0,.1)!important;
            border-color: var(--border-light);
        }
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
        .product-card .card-img-top:hover {
            transform: scale(1.08) rotate(-2deg);
        }
        .product-card .card-body {
            display: flex;
            flex-direction: column;
            padding: 1rem;
        }
        .product-card .card-title {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        .product-card .price {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--accent-pink);
        }
        .product-card .original-price { font-size: 0.9rem; color: #6c757d; text-decoration: line-through; margin-left: 6px; }
        .product-card .rating { font-size: 0.9rem; }
        .product-card .btn-add-to-cart {
            padding: 6px 12px !important;
            font-size: 1rem;
            line-height: 1;
            border-radius: 10px !important;
        }

        /* Pagination */
        .pagination-container { display: flex; justify-content: center; margin-top: 30px; }
        .pagination { border-radius: 2rem; background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.04); padding: 0.5rem 1rem; }
        .pagination .page-item { margin: 0 2px; }
        .pagination .page-link { border-radius: 50px !important; border: none; color: #333; font-weight: 500; transition: background 0.2s, color 0.2s; }
        .pagination .page-link:hover { background: #ffe4ec; color: #d63384; }
        .pagination .page-item.active .page-link { background: linear-gradient(90deg,#ffb6c1,#ff69b4); color: #fff; font-weight: 700; box-shadow: 0 2px 8px rgba(255,105,180,0.12); }
        .pagination .page-item.disabled .page-link { color: #bbb; background: #f8f9fa; }

        @media (max-width: 576px) {
            .panel-header { flex-direction: column; align-items: stretch; }
            .modern-dropdown { width: 100%; }
            /* Slightly reduce padding on mobile but keep extra bottom space */
            .product-listing-panel { padding: 1.25rem 1.25rem 2rem 1.25rem; }
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-4">
    <div class="container">
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <section class="product-listing-panel">
            <!-- Panel Header with Sorting -->
            <div class="panel-header">
                <form id="filterSortForm" class="mb-0">
                    <input type="hidden" name="query" value="${param.query}">
                    <input type="hidden" name="page" value="${param.page}">
                    <input type="hidden" name="size" value="${param.size}">
                    <div class="modern-dropdown d-flex align-items-center gap-2">
                        <label for="sortSelect" class="form-label mb-0">Sắp xếp:</label>
                        <div class="input-icon-wrapper flex-grow-1">
                            <i class="bi bi-funnel input-icon"></i>
                            <select class="form-select modern-select" id="sortSelect" name="sort">
                                <option value="newest" <c:if test='${sortBy=="newest"}'>selected</c:if>>Mới nhất</option>
                                <option value="bestselling" <c:if test='${sortBy=="bestselling"}'>selected</c:if>>Bán chạy</option>
                                <option value="toprated" <c:if test='${sortBy=="toprated"}'>selected</c:if>>Đánh giá cao</option>
                                <option value="price_asc" <c:if test='${sortBy=="price_asc"}'>selected</c:if>>Giá: Tăng dần</option>
                                <option value="price_desc" <c:if test='${sortBy=="price_desc"}'>selected</c:if>>Giá: Giảm dần</option>
                                <sec:authorize access="isAuthenticated()">
                                    <option value="wishlisted" <c:if test='${sortBy=="wishlisted"}'>selected</c:if>>Yêu thích</option>
                                </sec:authorize>
                            </select>
                            <span class="dropdown-arrow"><i class="bi bi-chevron-down"></i></span>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Product Grid -->
            <c:choose>
                <c:when test="${not empty productPage.content}">
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                        <c:forEach var="product" items="${productPage.content}">
                            <div class="col">
                                <div class="card h-100 product-card">
                                    <a href="<c:url value='/product/${product.id}'/>">
                                        <div class="card-img-top-wrapper">
                                            <img src="<c:url value='/${product.imageUrl}'/>" class="card-img-top" alt="${product.name}">
                                        </div>
                                    </a>
                                    <div class="card-body">
                                        <h5 class="card-title"><a href="<c:url value='/product/${product.id}'/>" class="text-decoration-none text-dark">${product.name}</a></h5>
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
                                        <p class="card-text"><small class="text-muted">Bán bởi: ${product.shop.name}</small></p>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="rating">
                                                <c:forEach begin="1" end="5" varStatus="loop">
                                                    <i class="fas fa-star <c:if test='${loop.index <= product.averageRating}'>text-warning</c:if><c:if test='${loop.index > product.averageRating}'>text-secondary</c:if>"></i>
                                                </c:forEach>
                                                <small class="text-muted">(${product.reviewCount})</small>
                                            </div>
                                            <sec:authorize access="isAuthenticated()">
                                                <button class="btn btn-sm btn-outline-primary btn-add-to-cart" onclick="addToCart(${product.id})" data-product-id="${product.id}"><i class="fas fa-cart-plus"></i></button>
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

                    <!-- Pagination -->
                    <c:if test="${productPage.totalPages > 1}">
                        <nav class="pagination-container">
                            <ul class="pagination">
                                <c:url var="prevPageUrl" value="${baseProductUrl}">
                                    <c:forEach var="paramEntry" items="${currentParams}"><c:if test="${paramEntry.key != 'page'}"><c:forEach var="paramValue" items="${paramEntry.value}"><c:param name="${paramEntry.key}" value="${paramValue}"/></c:forEach></c:if></c:forEach>
                                    <c:param name="page" value="${productPage.number - 1}"/>
                                </c:url>
                                <li class="page-item <c:if test='${productPage.first}'>disabled</c:if>">
                                    <a class="page-link" href="${prevPageUrl}" aria-label="Trang trước"><i class="bi bi-chevron-left"></i></a>
                                </li>
                                <c:forEach var="pageNum" items="${pageNumbers}">
                                    <c:url var="pageUrl" value="${baseProductUrl}">
                                        <c:forEach var="paramEntry" items="${currentParams}"><c:if test="${paramEntry.key != 'page'}"><c:forEach var="paramValue" items="${paramEntry.value}"><c:param name="${paramEntry.key}" value="${paramValue}"/></c:forEach></c:if></c:forEach>
                                        <c:param name="page" value="${pageNum - 1}"/>
                                    </c:url>
                                    <li class="page-item <c:if test='${pageNum - 1 == productPage.number}'>active</c:if>">
                                        <a class="page-link" href="${pageUrl}">${pageNum}</a>
                                    </li>
                                </c:forEach>
                                <c:url var="nextPageUrl" value="${baseProductUrl}">
                                    <c:forEach var="paramEntry" items="${currentParams}"><c:if test="${paramEntry.key != 'page'}"><c:forEach var="paramValue" items="${paramEntry.value}"><c:param name="${paramEntry.key}" value="${paramValue}"/></c:forEach></c:if></c:forEach>
                                    <c:param name="page" value="${productPage.number + 1}"/>
                                </c:url>
                                <li class="page-item <c:if test='${productPage.last}'>disabled</c:if>">
                                    <a class="page-link" href="${nextPageUrl}" aria-label="Trang sau"><i class="bi bi-chevron-right"></i></a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info text-center" role="alert">
                        Không tìm thấy sản phẩm nào phù hợp.
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
    document.getElementById('sortSelect').addEventListener('change', function() {
        document.getElementById('filterSortForm').submit();
    });

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

    let stompClient = null;

    function connect() {
        const socket = new SockJS('${wsUrl}');
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

        if (window.sharedStompClient == null && typeof connect === 'function') {
            try { connect(); } catch (e) { console.warn('connect() not available', e); }
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        <sec:authorize access="isAuthenticated()">
            // Assuming connect() is defined in a global scope or included script
            if (typeof connect === 'function') {
                connect();
            }
        </sec:authorize>
    });
</script>
</body>
</html>
