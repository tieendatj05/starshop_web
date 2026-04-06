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
        .product-card .price { font-size: 1.2rem; font-weight: bold; color: #dc3545; }
        .product-card .original-price { font-size: 0.95rem; color: #6c757d; text-decoration: line-through; margin-left: 6px; }
        .pagination-container { display: flex; justify-content: center; margin-top: 30px; }

        /* Vertical layout for promotion page */
        .promotion-section {
            width: 100%;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            padding: 2rem 1.5rem 1.5rem 1.5rem;
            margin-bottom: 2.5rem; /* Space between sections */
        }
        .promotion-section h2 {
            font-size: 1.5rem; /* Larger subtitle */
            font-weight: bold;
            margin-bottom: 1.5rem;
            letter-spacing: 1px;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/shared/header.jsp" />
<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Khuyến mãi" />
        <c:set var="titleClass" value="text-uppercase" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <section class="promotion-section">
            <h2 class="gradient-text animated-gradient text-center text-uppercase">Mã giảm giá</h2>
            <c:choose>
                <c:when test="${not empty activePromotions}">
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                        <c:forEach var="promo" items="${activePromotions}">
                            <div class="col">
                                <div class="card promo-card h-100">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <span>Mã: <strong class="promo-code">${promo.code}</strong></span>
                                        <span class="badge bg-danger">-${promo.discountPercentage}%</span>
                                    </div>
                                    <div class="card-body">
                                        <h5 class="card-title">${promo.description}</h5>
                                        <p class="card-text mb-1"><small class="text-muted">Áp dụng cho: ${promo.shop.name}</small></p>
                                        <p class="card-text mb-1"><small class="text-muted">Hạn dùng: ${promo.formattedEndDate}</small></p>
                                        <c:if test="${promo.maxDiscountAmount != null}">
                                            <p class="card-text mb-1"><small class="text-muted">Giảm tối đa: <fmt:formatNumber value="${promo.maxDiscountAmount}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</small></p>
                                        </c:if>
                                    </div>
                                    <div class="card-footer text-end" id="promo-footer-${promo.id}">
                                        <sec:authorize access="isAuthenticated()">
                                            <c:set var="isSaved" value="false"/>
                                            <c:forEach var="savedPromo" items="${userSavedPromotions}">
                                                <c:if test="${savedPromo.id == promo.id}"><c:set var="isSaved" value="true"/></c:if>
                                            </c:forEach>
                                            <c:choose>
                                                <c:when test="${isSaved}">
                                                    <button class="btn btn-saved btn-sm" disabled><i class="fas fa-check"></i> Đã Lưu</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-outline-primary btn-sm" onclick="savePromotion(${promo.id})" id="save-btn-${promo.id}">
                                                        <i class="fas fa-bookmark"></i> Lưu Mã
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </sec:authorize>
                                        <sec:authorize access="!isAuthenticated()">
                                            <a href="<c:url value='/login'/>" class="btn btn-outline-primary btn-sm"><i class="fas fa-bookmark"></i> Đăng nhập để lưu</a>
                                        </sec:authorize>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info text-center" role="alert">Hiện chưa có mã khuyến mãi nào đang hoạt động.</div>
                </c:otherwise>
            </c:choose>
        </section>

        <section class="promotion-section">
            <h2 class="gradient-text animated-gradient text-center text-uppercase">Sản phẩm đang giảm giá</h2>
            <c:choose>
                <c:when test="${not empty discountedProductsPage.content}">
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                        <c:forEach var="product" items="${discountedProductsPage.content}">
                            <div class="col">
                                <div class="card product-card h-100">
                                    <a href="<c:url value='/product/${product.id}'/>">
                                        <div class="card-img-top-wrapper">
                                            <img src="<c:url value='/${product.imageUrl}'/>" class="card-img-top" alt="${product.name}">
                                        </div>
                                    </a>
                                    <div class="card-body">
                                        <h5 class="card-title"><a href="<c:url value='/product/${product.id}'/>" class="text-decoration-none text-dark">${product.name}</a></h5>
                                        <p class="card-text mb-0">
                                            <span class="price"><fmt:formatNumber value="${product.discountedPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                            <span class="original-price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                            <span class="badge bg-danger discount-badge">-${product.activeDiscount.discountPercentage}%</span>
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
                    <c:if test="${discountedProductsPage.totalPages > 1}">
                        <nav class="pagination-container">
                            <ul class="pagination">
                                <li class="page-item <c:if test='${discountedProductsPage.first}'>disabled</c:if>">
                                    <a class="page-link" href="<c:url value='/promotions'><c:param name='page' value='${discountedProductsPage.number - 1}'/><c:param name='size' value='${discountedProductsPage.size}'/></c:url>">Trước</a>
                                </li>
                                <c:forEach var="pageNum" items="${pageNumbers}">
                                    <li class="page-item <c:if test='${pageNum - 1 == discountedProductsPage.number}'>active</c:if>">
                                        <a class="page-link" href="<c:url value='/promotions'><c:param name='page' value='${pageNum - 1}'/><c:param name='size' value='${discountedProductsPage.size}'/></c:url>">${pageNum}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item <c:if test='${discountedProductsPage.last}'>disabled</c:if>">
                                    <a class="page-link" href="<c:url value='/promotions'><c:param name='page' value='${discountedProductsPage.number + 1}'/><c:param name='size' value='${discountedProductsPage.size}'/></c:url>">Sau</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info text-center" role="alert">Hiện chưa có sản phẩm nào đang giảm giá.</div>
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
    let stompClient = null;
    function connect() {
        const socket = new SockJS('<%= request.getContextPath() %>/ws');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function (frame) {
            stompClient.subscribe('/user/topic/cart-updates', function (response) {
                const body = JSON.parse(response.body);
            });
            stompClient.subscribe('/user/topic/promotion-updates', function (response) {
                const body = JSON.parse(response.body);
                if (body.promotionId) {
                    const promoId = body.promotionId;
                    const saveBtn = document.getElementById("save-btn-" + promoId);
                    if (saveBtn) {
                        if (body.success) {
                            saveBtn.disabled = true;
                            saveBtn.innerHTML = '<i class="fas fa-check"></i> Đã Lưu';
                            saveBtn.classList.remove('btn-warning', 'btn-outline-primary');
                            saveBtn.classList.add('btn-saved');
                        } else {
                            saveBtn.disabled = false;
                            saveBtn.innerHTML = '<i class="fas fa-bookmark"></i> Lưu Mã';
                            saveBtn.classList.remove('btn-warning');
                            saveBtn.classList.add('btn-outline-primary');
                        }
                    }
                }
            });
        }, function(error) {
            // error handling
        });
    }
    function addToCart(productId) {
        if (stompClient && stompClient.connected) {
            stompClient.send("/app/cart/add", {}, JSON.stringify({ 'productId': productId, 'quantity': 1 }));
        }
    }
    function savePromotion(promotionId) {
        const saveBtn = document.getElementById("save-btn-" + promotionId);
        if (saveBtn) {
            saveBtn.disabled = true;
            saveBtn.classList.remove('btn-outline-primary');
            saveBtn.classList.add('btn-warning');
        }
        if (stompClient && stompClient.connected) {
            stompClient.send("/app/promotion/save", {}, JSON.stringify({ 'promotionId': promotionId }));
        } else {
            if (saveBtn) {
                saveBtn.disabled = false;
                saveBtn.classList.remove('btn-warning');
                saveBtn.classList.add('btn-outline-primary');
            }
        }
    }
    document.addEventListener('DOMContentLoaded', function() {
        <sec:authorize access="isAuthenticated()">
            connect();
        </sec:authorize>
    });
</script>
</body>
</html>