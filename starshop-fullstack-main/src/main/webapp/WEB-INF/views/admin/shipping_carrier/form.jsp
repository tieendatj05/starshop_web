<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <c:set var="pageTitle" value="${empty carrier.id ? 'Thêm mới' : 'Chỉnh sửa'} Nhà vận chuyển" />
    <title>${pageTitle} - Admin</title>
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
                    <a class="nav-link ${fn:contains(currentPath, '/admin/promotion') ? 'active' : ''}" href="<c:url value='/admin/promotion'/>">
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
                    <a class="nav-link active" href="<c:url value='/admin/shipping-carriers'/>">
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
                    <i class="fas fa-truck"></i>
                    <span>${pageTitle}</span>
                </div>
                <a href="<c:url value='/admin/shipping-carriers'/>" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <form action="<c:url value='/admin/shipping-carriers/save' />" method="post">
                <input type="hidden" name="id" value="${carrier.id}">

                <div class="mb-3">
                    <label for="name" class="form-label">Tên nhà vận chuyển <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="name" name="name" value="${carrier.name}" required>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="${carrier.phone}">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="website" class="form-label">Website</label>
                        <input type="url" class="form-control" id="website" name="website" value="${carrier.website}" placeholder="https://example.com">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="shippingFee" class="form-label">Phí vận chuyển (VNĐ) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="shippingFee" name="shippingFee" value="${carrier.shippingFee}" required min="0" step="1000">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="isActive" class="form-label">Trạng thái</label>
                        <select class="form-select" id="isActive" name="isActive">
                            <option value="true" ${carrier.isActive ? 'selected' : ''}>Hoạt động</option>
                            <option value="false" ${!carrier.isActive ? 'selected' : ''}>Không hoạt động</option>
                        </select>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <button type="submit" class="btn btn-themed">
                        <i class="fas fa-save"></i> Lưu Thay Đổi
                    </button>
                    <a href="<c:url value='/admin/shipping-carriers' />" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Hủy
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
