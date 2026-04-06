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
            justify-content: space-between; /* Ensures button goes to the end */
            gap: 0.5rem;
        }
        .section-title .title-content {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
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
            color: white;
            border: none;
            border-radius: 0.5rem;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
            transition: all 0.3s ease;
            font-weight: 600;
        }
        .btn-themed:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(255, 192, 203, 0.6);
            color: white;
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
        
        footer { background: #f8f9fa; padding: 2rem 0; border-top: 1px solid #e9ecef; }
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
                    <a class="nav-link active" href="<c:url value='/admin/category'/>">
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
                    <i class="fas fa-tag"></i>
                    <span>${pageTitle}</span>
                </div>
                <a href="<c:url value='/admin/category'/>" class="btn btn-sm btn-back-to-list ms-auto">
                    <i class="fas fa-arrow-left me-2"></i>Quay về danh sách
                </a>
            </div>

            <form:form action="/admin/category/save" method="post" modelAttribute="category">
                <sec:csrfInput/>
                <form:hidden path="id"/>

                <div class="mb-3">
                    <label for="name" class="form-label fw-bold">Tên Danh mục</label>
                    <form:input path="name" id="name" cssClass="form-control form-control-lg" required="true" placeholder="Ví dụ: Thời trang nữ"/>
                </div>

                <div class="mb-4">
                    <label for="slug" class="form-label fw-bold">Slug (URL thân thiện)</label>
                    <form:input path="slug" id="slug" cssClass="form-control" placeholder="Ví dụ: thoi-trang-nu"/>
                    <div class="form-text">Nếu để trống, slug sẽ được tạo tự động từ tên.</div>
                </div>

                <div class="form-check form-switch mb-4 p-0">
                     <div class="d-flex align-items-center">
                        <form:checkbox path="active" id="active" cssClass="form-check-input ms-0 me-2" role="switch"/>
                        <label class="form-check-label" for="active">Kích hoạt danh mục</label>
                    </div>
                </div>

                <div class="d-flex align-items-center gap-2">
                    <button type="submit" class="btn btn-themed px-4">Lưu thay đổi</button>
                    <a href="<c:url value='/admin/category'/>" class="btn btn-outline-secondary px-4">Hủy</a>
                </div>
            </form:form>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>