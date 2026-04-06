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

        /* Product Card Styling (from original, adjusted for consistency) */
        .product-card {
            border: none;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .product-card .card-img-top {
            height: 200px; /* Fixed height for images */
            object-fit: cover;
            border-bottom: 1px solid #eee;
        }

        .product-card .card-body {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 1rem;
        }
        .product-card .card-title {
            font-size: 1rem;
            font-weight: 600;
            min-height: 48px; /* Ensure consistent height for titles */
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .product-card .price {
            font-size: 1.1rem;
            font-weight: bold;
            color: var(--accent-pink); /* Use accent color for price */
        }
        .product-card .original-price {
            font-size: 0.85rem;
            color: #6c757d;
            text-decoration: line-through;
            margin-left: 0.5rem;
        }
        .product-card .badge {
            font-size: 0.75rem;
            padding: 0.3em 0.6em;
            vertical-align: middle;
        }
        .product-card .text-muted {
            font-size: 0.85rem;
        }

        /* Pagination Styling */
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 2.5rem;
        }
        .pagination .page-item .page-link {
            border-radius: 8px;
            margin: 0 4px;
            color: var(--text-dark);
            border: 1px solid #e0e0e0;
            transition: all 0.3s ease;
        }
        .pagination .page-item.active .page-link,
        .pagination .page-item .page-link:hover {
            background-color: var(--accent-pink);
            border-color: var(--accent-pink);
            color: #fff;
        }
        .pagination .page-item.disabled .page-link {
            color: #ccc;
            border-color: #eee;
        }

        /* Alert Styling */
        .alert-info {
            border-radius: 12px;
            border: none;
            background: #e0f7fa; /* Light cyan */
            color: #17a2b8; /* Cyan */
            box-shadow: 0 2px 8px rgba(23,162,184,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="checkout-panel">
            <h4 class="section-title">
                <i class="fas fa-history"></i>
                ${pageTitle}
            </h4>

            <c:choose>
                <c:when test="${not empty viewedProductPage.content}">
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                        <c:forEach var="viewedProduct" items="${viewedProductPage.content}">
                            <c:set var="product" value="${viewedProduct.product}" />
                            <div class="col">
                                <div class="card h-100 product-card">
                                    <a href="<c:url value='/product/${product.id}'/>">
                                        <img src="<c:url value='/${product.imageUrl}'/>" class="card-img-top" alt="${product.name}">
                                    </a>
                                    <div class="card-body">
                                        <h5 class="card-title"><a href="<c:url value='/product/${product.id}'/>" class="text-decoration-none text-dark">${product.name}</a></h5>
                                        <p class="card-text mb-0">
                                            <c:choose>
                                                <c:when test="${product.discountedPrice != null}">
                                                    <span class="price"><fmt:formatNumber value="${product.discountedPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                    <span class="original-price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                    <c:if test="${product.activeDiscount != null}">
                                                        <span class="badge bg-danger">-${product.activeDiscount.discountPercentage}%</span>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="" maxFractionDigits="0"/>đ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p class="card-text"><small class="text-muted">Bán bởi: ${product.shop.name}</small></p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <c:if test="${viewedProductPage.totalPages > 1}">
                        <nav class="pagination-container">
                            <ul class="pagination">
                                <li class="page-item <c:if test='${viewedProductPage.first}'>disabled</c:if>">
                                    <a class="page-link" href="<c:url value='/viewed-products'><c:param name='page' value='${viewedProductPage.number - 1}'/><c:param name='size' value='${viewedProductPage.size}'/></c:url>">Trước</a>
                                </li>
                                <c:forEach var="pageNum" begin="1" end="${viewedProductPage.totalPages}">
                                    <li class="page-item <c:if test='${pageNum - 1 == viewedProductPage.number}'>active</c:if>">
                                        <a class="page-link" href="<c:url value='/viewed-products'><c:param name='page' value='${pageNum - 1}'/><c:param name='size' value='${viewedProductPage.size}'/></c:url>">${pageNum}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item <c:if test='${viewedProductPage.last}'>disabled</c:if>">
                                    <a class="page-link" href="<c:url value='/viewed-products'><c:param name='page' value='${viewedProductPage.number + 1}'/><c:param name='size' value='${viewedProductPage.size}'/></c:url>">Sau</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info text-center" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
                        Bạn chưa xem sản phẩm nào.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
