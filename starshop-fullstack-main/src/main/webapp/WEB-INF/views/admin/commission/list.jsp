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
    <title>Quản Lý Chiết Khấu - Admin</title>
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

        .item-list { margin: 0; padding: 0; list-style: none; }
        .item-list-item {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 0.9rem;
            padding: 1rem 1.5rem;
            transition: all 0.25s ease;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
        }
        .item-list-item:hover { box-shadow: 0 6px 16px rgba(0,0,0,0.08); transform: translateY(-2px); }

        .item-details { flex-grow: 1; min-width: 0; }
        .item-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.75rem; }
        .item-title { font-size: 1.1rem; font-weight: 700; margin-bottom: 0; }
        .item-sub { font-size: 0.9rem; color: #6c757d; }
        .item-sub strong { color: var(--text-dark); }
        
        .item-financials { display: flex; justify-content: space-around; text-align: center; padding-top: 0.75rem; border-top: 1px solid #f0f0f0; }
        .financial-item .label { font-size: 0.8rem; color: #6c757d; margin-bottom: 0.1rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .financial-item .value { font-size: 1.05rem; font-weight: 700; }

        .badge-status { padding: 0.35em 0.65em; font-size: 0.8em; border-radius: 999px; font-weight: 700; }
        .badge-status.status-paid { background: linear-gradient(90deg, #D1FAE5, #6EE7B7); color: #064E3B; box-shadow: 0 2px 6px rgba(34,197,94,0.08); }
        .badge-status.status-calculated { background: linear-gradient(90deg, #DBEAFE, #BFDBFE); color: #1E40AF; box-shadow: 0 2px 6px rgba(59,130,246,0.08); }
        .badge-status.status-pending { background: linear-gradient(90deg, #FEF3C7, #FDE68A); color: #78350F; box-shadow: 0 2px 6px rgba(251,191,36,0.08); }

        .item-actions { flex-shrink: 0; display:flex; flex-direction:row; align-items: center; gap: 0.5rem; justify-content:flex-end; }
        .action-btn { display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; border: none; color: #fff; cursor: pointer; transition: all .15s ease; box-shadow: 0 2px 6px rgba(0,0,0,0.08); text-decoration: none; }
        .action-btn .fa, .action-btn .fas { font-size: 0.95rem; }
        .action-calculate { background: linear-gradient(90deg,#60A5FA,#3B82F6); } /* blue */
        .action-paid { background: linear-gradient(90deg,#34D399,#10B981); }  /* green */
        .action-details { background: linear-gradient(90deg,#A78BFA,#8B5CF6); } /* violet */
        .action-btn:focus { outline: none; box-shadow: 0 4px 12px rgba(0,0,0,0.12); }
        .action-btn:hover { transform: translateY(-2px); }

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

        <%-- Flash Messages --%>
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="checkout-panel">
            <div class="section-title">
                <div class="title-content">
                    <i class="fas fa-percent"></i>
                    <span>Quản Lý Chiết Khấu</span>
                </div>
                <a href="<c:url value='/admin/commissions/create'/>" class="btn btn-themed">
                    <i class="fas fa-plus"></i> Thêm mới
                </a>
            </div>

            <%-- Filter Form --%>
            <form method="get" action="<c:url value='/admin/commissions'/>" class="mb-4">
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-calendar-alt me-2"></i> Lọc theo kỳ:</span>
                    <select class="form-select" id="month" name="month">
                        <option value="">-- Chọn Tháng --</option>
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}" ${m == selectedMonth ? 'selected' : ''}>Tháng ${m}</option>
                        </c:forEach>
                    </select>
                    <select class="form-select" id="year" name="year">
                        <option value="">-- Chọn Năm --</option>
                        <c:forEach var="y" begin="2024" end="2026">
                            <option value="${y}" ${y == selectedYear ? 'selected' : ''}>Năm ${y}</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-primary"><i class="fas fa-filter"></i> Lọc</button>
                    <a href="<c:url value='/admin/commissions'/>" class="btn btn-outline-secondary" title="Reset bộ lọc"><i class="fas fa-redo"></i></a>
                </div>
            </form>

            <c:choose>
                <c:when test="${not empty commissions}">
                    <ul class="item-list">
                        <c:forEach var="comm" items="${commissions}">
                            <li class="item-list-item">
                                <div class="item-details">
                                    <div class="item-header">
                                        <div>
                                            <h5 class="item-title">${comm.shopName}</h5>
                                            <div class="item-sub">
                                                Kỳ: <strong>${comm.commissionMonth}/${comm.commissionYear}</strong> | Tỷ lệ: <strong>${comm.commissionPercentage}%</strong> | Đơn: <strong>${comm.totalOrders}</strong>
                                            </div>
                                        </div>
                                        <c:choose>
                                            <c:when test="${comm.status == 'PENDING'}"><span class="badge badge-status status-pending">Chờ tính</span></c:when>
                                            <c:when test="${comm.status == 'CALCULATED'}"><span class="badge badge-status status-calculated">Đã tính</span></c:when>
                                            <c:when test="${comm.status == 'PAID'}"><span class="badge badge-status status-paid">Đã thanh toán</span></c:when>
                                        </c:choose>
                                    </div>
                                    <div class="item-financials">
                                        <div class="financial-item">
                                            <div class="label">Doanh Thu</div>
                                            <div class="value text-primary"><fmt:formatNumber value="${comm.totalRevenue}" type="currency" currencySymbol="₫"/></div>
                                        </div>
                                        <div class="financial-item">
                                            <div class="label">Chiết Khấu</div>
                                            <div class="value text-danger"><fmt:formatNumber value="${comm.commissionAmount}" type="currency" currencySymbol="₫"/></div>
                                        </div>
                                        <div class="financial-item">
                                            <div class="label">Thực Nhận</div>
                                            <div class="value text-success"><fmt:formatNumber value="${comm.netAmount}" type="currency" currencySymbol="₫"/></div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="item-actions">
                                    <c:if test="${comm.status == 'PENDING' || comm.status == 'CALCULATED'}">
                                        <form method="post" action="<c:url value='/admin/commissions/${comm.id}/calculate'/>" class="d-inline">
                                            <button type="submit" class="action-btn action-calculate" title="Tính toán">
                                                <i class="fas fa-calculator"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${comm.status == 'CALCULATED'}">
                                        <form method="post" action="<c:url value='/admin/commissions/${comm.id}/mark-paid'/>" class="d-inline" onsubmit="return confirm('Xác nhận đã thanh toán cho kỳ này?')">
                                            <button type="submit" class="action-btn action-paid" title="Đánh dấu đã thanh toán">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                    <a href="<c:url value='/admin/commissions/${comm.id}/details'/>" class="action-btn action-details" title="Chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                     <div class="text-center p-5 border rounded bg-light">
                        <i class="bi bi-percent display-4 text-muted mb-3"></i>
                        <h5 class="mb-2">Không có dữ liệu chiết khấu</h5>
                        <p class="text-muted mb-3">
                            Không tìm thấy bản ghi chiết khấu nào phù hợp với bộ lọc của bạn.
                        </p>
                        <a href="<c:url value='/admin/commissions'/>" class="btn btn-primary">Tải lại danh sách</a>
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
