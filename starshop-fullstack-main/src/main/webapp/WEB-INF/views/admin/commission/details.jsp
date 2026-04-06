<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Chiết Khấu - Admin</title>
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

        .detail-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #eee;
        }
        .detail-item:last-child { border-bottom: none; }
        .detail-item .label { font-weight: 600; color: var(--text-dark); }
        .detail-item .value { color: #6c757d; text-align: right; }
        .detail-item .value strong { color: var(--text-dark); }

        .badge-status { padding: 0.35em 0.65em; font-size: 0.8em; border-radius: 999px; font-weight: 700; }
        .badge-status.status-paid { background: linear-gradient(90deg, #D1FAE5, #6EE7B7); color: #064E3B; box-shadow: 0 2px 6px rgba(34,197,94,0.08); }
        .badge-status.status-calculated { background: linear-gradient(90deg, #DBEAFE, #BFDBFE); color: #1E40AF; box-shadow: 0 2px 6px rgba(59,130,246,0.08); }
        .badge-status.status-pending { background: linear-gradient(90deg, #FEF3C7, #FDE68A); color: #78350F; box-shadow: 0 2px 6px rgba(251,191,36,0.08); }

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
                    <a class="nav-link active" href="<c:url value='/admin/commissions'/>">
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
                    <i class="fas fa-file-invoice"></i>
                    <span>Chi tiết Chiết Khấu</span>
                </div>
                <a href="<c:url value='/admin/commissions'/>" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <div class="detail-card">
                <div class="row">
                    <div class="col-md-6">
                        <div class="detail-item">
                            <span class="label">Shop:</span>
                            <span class="value"><strong>${commission.shopName}</strong></span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Kỳ Chiết Khấu:</span>
                            <span class="value"><strong>Tháng ${commission.commissionMonth}/${commission.commissionYear}</strong></span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Tỷ Lệ Chiết Khấu:</span>
                            <span class="value text-primary"><strong>${commission.commissionPercentage}%</strong></span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Trạng Thái:</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${commission.status == 'PENDING'}"><span class="badge badge-status status-pending">Chờ tính</span></c:when>
                                    <c:when test="${commission.status == 'CALCULATED'}"><span class="badge badge-status status-calculated">Đã tính</span></c:when>
                                    <c:when test="${commission.status == 'PAID'}"><span class="badge badge-status status-paid">Đã thanh toán</span></c:when>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-item">
                            <span class="label">Tổng Đơn Hàng:</span>
                            <span class="value"><strong>${commission.totalOrders}</strong> đơn</span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Tổng Doanh Thu:</span>
                            <span class="value text-success"><strong><fmt:formatNumber value="${commission.totalRevenue}" type="currency" currencySymbol="₫"/></strong></span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Tiền Chiết Khấu:</span>
                            <span class="value text-danger"><strong><fmt:formatNumber value="${commission.commissionAmount}" type="currency" currencySymbol="₫"/></strong></span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Thực Nhận:</span>
                            <span class="value text-primary"><strong><fmt:formatNumber value="${commission.netAmount}" type="currency" currencySymbol="₫"/></strong></span>
                        </div>
                    </div>
                </div>
                
                <hr class="my-4">

                <div class="row">
                    <div class="col-md-6">
                        <p class="mb-1 text-muted"><strong>Người tạo:</strong> ${commission.createdByName}</p>
                    </div>
                    <div class="col-md-6">
                        <p class="mb-1 text-muted"><strong>Cập nhật lần cuối:</strong> ${commission.updatedAt}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
