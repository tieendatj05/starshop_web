<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sản phẩm - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"> <%-- Bootstrap Icons CDN --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>"> <%-- Custom CSS --%>
    <style>
        :root {
            --accent-pink: #FFB6C1;
            --text-dark: #343a40;
            --primary-light: #fff8fa;
        }
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }

        /* Sticky containers */
        .vendor-top-sticky { position: sticky; top: 80px; z-index: 100; } /* below site header */

        /* Checkout-like panel and section title */
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
            margin-bottom: 1.25rem; /* adjusted to match list.jsp */
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .section-title i { color: var(--accent-pink); font-size: 1.4rem; }

        /* Profile Tab Navigation (adapted for vendor dashboard) */
        .profile-nav {
            background: rgba(255, 255, 255, 0.9); /* Slightly transparent white */
            backdrop-filter: blur(6px); /* Add blur effect */
            border-radius: 16px;
            padding: 0.5rem;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06); /* Adjusted shadow */
        }

        .profile-nav .nav-link {
            border-radius: 12px;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0 4px; /* Creates a small gap between buttons */
            border: 2px solid transparent;
            transition: all 0.3s ease;
            padding: 0.8rem 1rem;
        }

        .profile-nav .nav-link:hover:not(.active) {
            background-color: var(--primary-light);
        }

        .profile-nav .nav-link.active {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
        }

        /* Custom style for form buttons */
        .btn-primary {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            border: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 192, 203, 0.5);
        }

        .btn-outline-secondary {
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-outline-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        /* Image preview style */
        .image-preview {
            max-width: 150px;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        /* Form specific styles */
        .form-control, .form-select {
            border-radius: 8px;
            border-color: #e0e0e0;
            padding: 0.75rem 1rem;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
            transition: all 0.2s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--accent-pink);
            box-shadow: 0 0 0 0.25rem rgba(255, 192, 203, 0.25);
            outline: none;
        }
        .form-check-input:checked {
            background-color: var(--accent-pink);
            border-color: var(--accent-pink);
        }
        .form-check-input:focus {
            box-shadow: 0 0 0 0.25rem rgba(255, 192, 203, 0.25);
        }

        /* Back-to-list button style (copied from discount/promotion forms for consistency) */
        .btn-back-to-list {
            border-color: var(--accent-pink);
            color: var(--accent-pink);
            background-color: transparent;
            transition: all 0.3s ease;
        }
        .btn-back-to-list:hover {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
            border-color: var(--accent-pink);
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Vendor Management Navigation -->
        <div class="vendor-top-sticky mb-3">
            <c:set var="currentPath" value="${pageContext.request.requestURI}" />
            <ul class="nav nav-pills nav-fill profile-nav">
                <li class="nav-item">
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/dashboard'}">active</c:if>" href="<c:url value='/vendor/dashboard'/>">
                        <i class="bi bi-speedometer2 me-2"></i> Tổng quan Shop
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/orders'}">active</c:if>" href="<c:url value='/vendor/orders'/>">
                        <i class="bi bi-receipt me-2"></i> Quản lý Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/vendor/products'/>">
                        <i class="bi bi-box-seam me-2"></i> Quản lý Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/discounts'}">active</c:if>" href="<c:url value='/vendor/discounts'/>">
                        <i class="bi bi-percent me-2"></i> Giảm giá Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/promotions'}">active</c:if>" href="<c:url value='/vendor/promotions'/>">
                        <i class="bi bi-ticket-perforated me-2"></i> Mã Giảm giá (Voucher)
                    </a>
                </li>
            </ul>
        </div>

        <div class="checkout-panel">
            <h4 class="section-title">
                <i class="bi bi-box-seam"></i>
                ${product.id != null ? 'Chỉnh Sửa Sản Phẩm' : 'Thêm Sản Phẩm Mới'}
                <a href="<c:url value='/vendor/products'/>" class="btn btn-sm ms-auto btn-back-to-list">
                    <i class="fas fa-arrow-left me-2"></i> Quay lại danh sách
                </a>
            </h4>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success d-flex align-items-center" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    <div>${successMessage}</div>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger d-flex align-items-center" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <div>${errorMessage}</div>
                </div>
            </c:if>

            <form:form action="/vendor/products/save" method="post" modelAttribute="product" enctype="multipart/form-data">
                <form:hidden path="id"/>
                <c:if test="${product.imageUrl != null}">
                    <form:hidden path="imageUrl"/>
                </c:if>

                <div class="mb-3">
                    <label for="name" class="form-label">Tên Sản Phẩm</label>
                    <form:input type="text" path="name" id="name" class="form-control" required="true"/>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Mô Tả</label>
                    <form:textarea path="description" id="description" class="form-control" rows="5"/>
                </div>

                <div class="mb-3">
                    <label for="price" class="form-label">Giá (VNĐ)</label>
                    <form:input type="number" path="price" id="price" class="form-control" required="true" min="0" step="1000"/>
                </div>

                <div class="mb-3">
                    <label for="stock" class="form-label">Số Lượng Tồn Kho</label>
                    <form:input type="number" path="stock" id="stock" class="form-control" required="true" min="0"/>
                </div>

                <div class="mb-3">
                    <label for="productImage" class="form-label">Ảnh Sản Phẩm</label>
                    <input type="file" name="productImage" id="productImage" class="form-control" accept="image/*">
                    <c:if test="${product.imageUrl != null}">
                        <div class="mt-2">
                            <img src="<c:url value='/${product.imageUrl}'/>" alt="${product.name}" class="image-preview">
                            <small class="text-muted d-block">Ảnh hiện tại</small>
                        </div>
                    </c:if>
                </div>

                <div class="mb-3">
                    <label for="shop" class="form-label">Cửa Hàng</label>
                    <form:select path="shop.id" id="shop" class="form-select" required="true">
                        <form:option value="" label="-- Chọn cửa hàng --"/>
                        <form:options items="${vendorShops}" itemValue="id" itemLabel="name"/>
                    </form:select>
                </div>

                <div class="mb-3">
                    <label for="category" class="form-label">Danh Mục</label>
                    <form:select path="category.id" id="category" class="form-select" required="true">
                        <form:option value="" label="-- Chọn danh mục --"/>
                        <form:options items="${categories}" itemValue="id" itemLabel="name"/>
                    </form:select>
                </div>

                <div class="mb-3 form-check">
                    <form:checkbox path="active" id="active" class="form-check-input"/>
                    <label for="active" class="form-check-label">Sản phẩm đang hoạt động</label>
                </div>

                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i> Lưu Sản Phẩm
                </button>
                <a href="<c:url value='/vendor/products'/>" class="btn btn-outline-secondary ms-2">
                    <i class="fas fa-times me-2"></i> Hủy
                </a>
            </form:form>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>