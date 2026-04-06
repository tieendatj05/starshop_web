<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">

    <%-- Copied styles from category/list.jsp for consistent UI --%>
    <style>
        :root {
            --accent-pink: #FFB6C1;
            --text-dark: #343a40;
            --primary-light: #fff8fa;
        }
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }

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
            justify-content: space-between;
            gap: 0.5rem;
        }
        .section-title .title-content { display: flex; align-items: center; gap: 0.5rem; }
        .section-title i { color: var(--accent-pink); font-size: 1.4rem; }

        .profile-nav {
            background: #fff;
            border-radius: 16px;
            padding: 0.5rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            white-space: nowrap;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start;
        }
        .profile-nav .nav-item { flex-shrink: 0; margin-bottom: 0.5rem; flex: 1 1 calc(16.66% - 10px); text-align: center; }
        .profile-nav .nav-item:nth-child(n+7) { flex: 1 1 calc(20% - 10px); }
        @media (max-width: 992px) { .profile-nav .nav-item { flex: 1 1 calc(33.33% - 10px); } }
        @media (max-width: 576px) { .profile-nav .nav-item { flex: 1 1 calc(50% - 10px); } }
        .profile-nav .nav-link { border-radius: 12px; font-weight: 600; color: var(--text-dark); margin: 0 2px; border: 2px solid transparent; transition: all 0.3s ease; padding: 0.8rem 0.7rem; font-size: 0.9rem; }
        .profile-nav .nav-link:hover:not(.active) { background-color: var(--primary-light); }
        .profile-nav .nav-link.active { background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%); color: white; box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4); }

        .btn-themed {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: var(--text-dark);
            border: none;
            border-radius: 0.5rem;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
            transition: all 0.3s ease;
            font-weight: 700;
        }
        .btn-themed:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(255, 192, 203, 0.6);
            color: var(--text-dark);
        }

        .btn-back-to-list {
            border: 1px solid var(--accent-pink);
            color: var(--accent-pink);
            background-color: transparent;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-back-to-list:hover {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
            border-color: var(--accent-pink);
        }

        .admin-top-sticky { position: sticky; top: 75px; z-index: 100; }
        
        .form-label { font-weight: 600; }
        .form-control, .form-select {
            border-radius: 0.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
            border-color: #dee2e6;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--accent-pink);
            box-shadow: 0 0 0 0.25rem rgba(255, 182, 193, 0.25);
        }
        .form-check-input:checked {
            background-color: var(--accent-pink);
            border-color: var(--accent-pink);
        }

        footer { background: #f8f9fa; padding: 2rem 0; border-top: 1px solid #e9ecef; }
        footer .social-icons a { color: var(--text-dark); transition: color 0.3s ease; }
        footer .social-icons a:hover { color: var(--accent-pink); }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <!-- Admin Management Navigation -->
        <div class="admin-top-sticky mb-3">
            <c:set var="currentPath" value="${pageContext.request.requestURI}" />
            <ul class="nav nav-pills profile-nav">
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/dashboard') ? 'active' : ''}" href="<c:url value='/admin/dashboard'/>">
                        <i class="bi bi-speedometer2 me-2"></i> Tổng quan
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/orders') ? 'active' : ''}" href="<c:url value='/admin/orders'/>">
                        <i class="fas fa-receipt me-2"></i> Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/products') ? 'active' : ''}" href="<c:url value='/admin/products'/>">
                        <i class="fas fa-box me-2"></i> Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/users') ? 'active' : ''}" href="<c:url value='/admin/users'/>">
                        <i class="fas fa-users me-2"></i> Người dùng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/shops') ? 'active' : ''}" href="<c:url value='/admin/shops'/>">
                        <i class="fas fa-store me-2"></i> Shops
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/category') ? 'active' : ''}" href="<c:url value='/admin/category'/>">
                        <i class="fas fa-tags me-2"></i> Danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/admin/promotion'/>">
                        <i class="fas fa-gift me-2"></i> Khuyến mãi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/product-discount') ? 'active' : ''}" href="<c:url value='/admin/product-discount'/>">
                        <i class="fas fa-tags me-2"></i> Giảm giá SP
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/commissions') ? 'active' : ''}" href="<c:url value='/admin/commissions'/>">
                        <i class="fas fa-percent me-2"></i> Chiết khấu
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/shipping-carriers') ? 'active' : ''}" href="<c:url value='/admin/shipping-carriers'/>">
                        <i class="fas fa-truck me-2"></i> Vận chuyển
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${fn:contains(currentPath, '/admin/appeals') ? 'active' : ''}" href="<c:url value='/admin/appeals'/>">
                        <i class="fas fa-gavel me-2"></i> Kháng cáo
                    </a>
                </li>
            </ul>
        </div>

        <div class="checkout-panel">
            <div class="section-title">
                <div class="title-content">
                    <i class="fas fa-gift"></i>
                    <span>${pageTitle}</span>
                </div>
                <a href="<c:url value='/admin/promotion'/>" class="btn btn-sm btn-back-to-list">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                </a>
            </div>

            <form:form action="/admin/promotion/save" method="post" modelAttribute="promotion">
                <form:hidden path="id"/>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="code" class="form-label">Mã Khuyến Mãi <span class="text-danger">*</span></label>
                        <form:input path="code" id="code" cssClass="form-control" required="true" placeholder="VD: SUMMER2024"/>
                        <div class="form-text">Mã phải là duy nhất, không trùng lặp.</div>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="shop" class="form-label">Cửa Hàng <span class="text-danger">*</span></label>
                        <form:select path="shop.id" id="shop" cssClass="form-select" required="true">
                            <option value="">-- Chọn cửa hàng --</option>
                            <c:forEach var="shop" items="${shops}">
                                <option value="${shop.id}" ${promotion.shop != null && promotion.shop.id == shop.id ? 'selected' : ''}>
                                    ${shop.name}
                                </option>
                            </c:forEach>
                        </form:select>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Mô Tả</label>
                    <form:textarea path="description" id="description" cssClass="form-control" rows="3" placeholder="Mô tả chi tiết về chương trình khuyến mãi..."/>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="discountPercentage" class="form-label">Phần Trăm Giảm Giá (%) <span class="text-danger">*</span></label>
                        <form:input path="discountPercentage" id="discountPercentage" type="number" cssClass="form-control" required="true" min="0" max="100" step="0.01" placeholder="VD: 10"/>
                        <div class="form-text">Nhập giá trị từ 0 đến 100.</div>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="maxDiscountAmount" class="form-label">Số Tiền Giảm Tối Đa (VNĐ)</label>
                        <form:input path="maxDiscountAmount" id="maxDiscountAmount" type="number" cssClass="form-control" min="0" step="1000" placeholder="VD: 100000"/>
                        <div class="form-text">Để trống nếu không có giới hạn.</div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="startDate" class="form-label">Ngày Bắt Đầu <span class="text-danger">*</span></label>
                        <form:input path="startDate" id="startDate" type="date" cssClass="form-control" required="true"/>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="endDate" class="form-label">Ngày Kết Thúc <span class="text-danger">*</span></label>
                        <form:input path="endDate" id="endDate" type="date" cssClass="form-control" required="true"/>
                    </div>
                </div>

                <div class="form-check form-switch mb-4">
                    <form:checkbox path="isActive" id="isActive" cssClass="form-check-input"/>
                    <label class="form-check-label" for="isActive">
                        <strong>Kích hoạt khuyến mãi</strong>
                    </label>
                    <div class="form-text">Bỏ chọn nếu muốn tạm dừng chương trình.</div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-themed">
                        <i class="fas fa-save"></i> Lưu Thay Đổi
                    </button>
                    <a href="<c:url value='/admin/promotion'/>" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Hủy
                    </a>
                </div>
            </form:form>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const startDateInput = document.getElementById('startDate');
        const endDateInput = document.getElementById('endDate');

        function validateDates() {
            if (startDateInput.value && endDateInput.value && new Date(endDateInput.value) < new Date(startDateInput.value)) {
                alert('Ngày kết thúc không được nhỏ hơn ngày bắt đầu!');
                endDateInput.value = startDateInput.value; // or endDateInput.value = '';
            }
        }

        startDateInput.addEventListener('change', validateDates);
        endDateInput.addEventListener('change', validateDates);
    });
</script>
</body>
</html>
