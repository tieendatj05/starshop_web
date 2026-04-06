<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Thông Tin Shop - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        :root {
            --accent-pink: #FFB6C1;
            --text-dark: #343a40;
            --primary-light: #fff8fa;
        }
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }

        /* Sticky containers */
        .vendor-top-sticky { position: sticky; top: 80px; z-index: 100; }

        /* Panel and section title */
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

        /* Vendor Navigation */
        .profile-nav {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(6px);
            border-radius: 16px;
            padding: 0.5rem;
            box-shadow: 0 4px 14px rgba(0,0,0,0.06);
        }
        .profile-nav .nav-link {
            border-radius: 12px;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0 4px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            padding: 0.8rem 1rem;
        }
        .profile-nav .nav-link:hover:not(.active) { background-color: var(--primary-light); }
        .profile-nav .nav-link.active {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
        }

        /* Form Styles */
        .form-control { border-radius: 8px; border-color: #e0e0e0; padding: 0.75rem 1rem; box-shadow: inset 0 1px 3px rgba(0,0,0,0.05); transition: all 0.2s ease; }
        .form-control:focus { border-color: var(--accent-pink); box-shadow: 0 0 0 0.25rem rgba(255, 192, 203, 0.25); outline: none; }
        .btn-primary { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); border: none; border-radius: 8px; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(255, 192, 203, 0.5); }
        .btn-outline-secondary { border-radius: 8px; font-weight: 600; transition: all 0.3s ease; }
        .btn-outline-secondary:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05); }
        .btn-back-to-list { border-color: var(--accent-pink); color: var(--accent-pink); background-color: transparent; transition: all 0.3s ease; }
        .btn-back-to-list:hover { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); color: white; box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4); border-color: var(--accent-pink); }
    </style>
</head>
<body>

<%-- HEADER --%>
<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<%-- MAIN CONTENT --%>
<main class="main-content py-5">
    <div class="container">
        <!-- Vendor Management Navigation -->
        <div class="vendor-top-sticky mb-3">
            <c:set var="currentPath" value="${pageContext.request.requestURI}" />
            <ul class="nav nav-pills nav-fill profile-nav">
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/vendor/dashboard'/>">
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
                <i class="fas fa-store"></i>
                Chỉnh Sửa Thông Tin Shop
                <a href="<c:url value='/vendor/dashboard'/>" class="btn btn-sm ms-auto btn-back-to-list">
                    <i class="fas fa-arrow-left me-2"></i> Quay lại tổng quan
                </a>
            </h4>

            <form:form action="/vendor/shop/edit" method="post" modelAttribute="shop">
                <form:hidden path="id" />

                <div class="mb-4">
                    <label for="name" class="form-label">Tên Shop</label>
                    <form:input path="name" id="name" cssClass="form-control" required="true" />
                </div>

                <div class="mb-4">
                    <label for="description" class="form-label">Mô tả</label>
                    <form:textarea path="description" id="description" cssClass="form-control" rows="5" />
                </div>

                <div class="d-flex justify-content-end mt-4">
                    <a href="<c:url value='/vendor/dashboard'/>" class="btn btn-outline-secondary me-2">
                        <i class="fas fa-times me-2"></i> Hủy
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i> Lưu thay đổi
                    </button>
                </div>
            </form:form>
        </div>
    </div>
</main>

<%-- FOOTER --%>
<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
