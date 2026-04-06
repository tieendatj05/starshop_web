<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo/Chỉnh sửa Giảm giá Sản phẩm - StarShop</title>
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

        /* Sticky vendor nav for consistency */
        .vendor-top-sticky { position: sticky; top: 75px; z-index: 100; margin-bottom: 1rem; }

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
            margin-bottom: 1.5rem;
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

        /* Custom style for Add New Discount button (if needed, adapted for form) */
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
            border-color: var(--accent-pink); /* Keep border color consistent */
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="${discount.id != null ? 'Chỉnh sửa Chương trình Giảm giá' : 'Tạo Chương trình Giảm giá Mới'}" />

        <!-- Vendor Management Navigation -->
        <div class="vendor-top-sticky">
            <c:set var="currentPath" value="${requestScope['javax.servlet.forward.request_uri']}" />
            <ul class="nav nav-pills nav-fill mb-3 profile-nav">
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
                    <a class="nav-link <c:if test="${currentPath eq '/StarShop/vendor/products'}">active</c:if>" href="<c:url value='/vendor/products'/>">
                        <i class="bi bi-box-seam me-2"></i> Quản lý Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/vendor/discounts'/>">
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
                <i class="bi bi-percent"></i>
                ${pageTitle}
                <a href="<c:url value='/vendor/discounts'/>" class="btn btn-sm ms-auto btn-back-to-list">
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

            <form action="<c:url value='/vendor/discounts/save'/>" method="post">
                <c:if test="${discount.id != null}">
                    <input type="hidden" name="id" value="${discount.id}" />
                </c:if>

                <div class="mb-3">
                    <label for="productId" class="form-label">Sản phẩm áp dụng:</label>
                    <select class="form-select" id="productId" name="productId" required>
                        <option value="">-- Chọn sản phẩm --</option>
                        <c:forEach var="product" items="${vendorProducts}">
                            <option value="${product.id}" ${discount.product.id == product.id ? 'selected' : ''}>${product.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="discountPercentage" class="form-label">Phần trăm giảm giá (%):</label>
                    <input type="number" class="form-control" id="discountPercentage" name="discountPercentage" min="1" max="100" value="${discount.discountPercentage}" required>
                </div>

                <div class="mb-3">
                    <label for="startDate" class="form-label">Ngày bắt đầu:</label>
                    <input type="date" class="form-control" id="startDate" name="startDate" value="${discount.startDate}" required>
                </div>

                <div class="mb-3">
                    <label for="endDate" class="form-label">Ngày kết thúc:</label>
                    <input type="date" class="form-control" id="endDate" name="endDate" value="${discount.endDate}" required>
                </div>

                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="active" name="active" ${discount.active ? 'checked' : ''}>
                    <label class="form-check-label" for="active">Hoạt động</label>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i> Lưu Chương trình
                    </button>
                    <a href="<c:url value='/vendor/discounts'/>" class="btn btn-outline-secondary">
                        <i class="fas fa-times-circle me-2"></i> Hủy
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>