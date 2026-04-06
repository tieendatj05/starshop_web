<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // Retrieve the 'appeal' request attribute as a typed variable for use in scriptlets below.
    com.starshop.entity.Appeal appeal = null;
    Object _appealObj = request.getAttribute("appeal");
    if (_appealObj instanceof com.starshop.entity.Appeal) {
        appeal = (com.starshop.entity.Appeal) _appealObj;
    } else if (_appealObj != null) {
        // Fallback: try to avoid ClassCastException by attempting a best-effort cast
        try {
            appeal = (com.starshop.entity.Appeal) _appealObj;
        } catch (ClassCastException e) {
            // leave as null – JSP will show empty strings for dates
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Kháng Cáo - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">

    <style>
        :root {
            --accent-pink: #FFB6C1;
            --text-dark: #343a40;
            --primary-light: #fff8fa;
            --muted-olive: #6b8e23;
            --pastel-bg: #fff7f9;
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
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .detail-card h5 { font-weight: 700; margin-bottom: 1rem; }
        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 0.6rem 0;
            border-bottom: 1px solid #eee;
        }
        .detail-item:last-child { border-bottom: none; }
        .detail-item .label { font-weight: 600; color: #6c757d; }
        .detail-item .value { color: var(--text-dark); text-align: right; font-weight: 500; }
        .detail-item .value strong { font-weight: 700; }

        .badge-status { padding: 0.35em 0.65em; font-size: 0.8em; border-radius: 999px; font-weight: 700; }
        .badge-status.status-approved { background: linear-gradient(90deg, #D1FAE5, #6EE7B7); color: #064E3B; box-shadow: 0 2px 6px rgba(34,197,94,0.08); }
        .badge-status.status-rejected { background: linear-gradient(90deg, #FECACA, #F87171); color: #7F1D1D; box-shadow: 0 2px 6px rgba(239,68,68,0.08); }
        .badge-status.status-pending { background: linear-gradient(90deg, #FEF3C7, #FDE68A); color: #78350F; box-shadow: 0 2px 6px rgba(251,191,36,0.08); }

        .admin-top-sticky { position: sticky; top: 75px; z-index: 100; }
        
        footer { background: #f8f9fa; padding: 2rem 0; border-top: 1px solid #e9ecef; }
        footer .social-icons a { color: var(--text-dark); transition: color 0.3s ease; }
        footer .social-icons a:hover { color: var(--accent-pink); }

        /* Appeal-specific styles */
        .appeal-reason-box { background: var(--pastel-bg); border-left: 4px solid var(--accent-pink); }
        .appeal-user-card { display:flex; gap:1rem; align-items:center; }
        .appeal-meta small { color:#6c757d; }
        .badge-theme { padding:0.4rem 0.7rem; border-radius:999px; font-weight:700; }
        .badge-theme.approved { background: linear-gradient(90deg,#D1FAE5,#6EE7B7); color:#064E3B; }
        .badge-theme.rejected { background: linear-gradient(90deg,#FECACA,#F87171); color:#7F1D1D; }
        .badge-theme.pending { background: linear-gradient(90deg,#FEF3C7,#FDE68A); color:#78350F; }
        .appeal-avatar-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background-color: var(--accent-pink);
            color: white;
            font-size: 32px;
            border: 3px solid #fff;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }
        .appeal-flower-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 80px;
            height: 80px;
            border-radius: 12px;
            background-color: var(--pastel-bg);
            color: var(--accent-pink);
            font-size: 40px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.06);
        }

        /* Floral Button Styles */
        .btn-floral {
            border-radius: 25px;
            font-weight: bold;
            padding: 10px 25px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .btn-floral-approve {
            background-color: var(--muted-olive);
            color: white;
            border-color: var(--muted-olive);
        }
        .btn-floral-approve:hover {
            background-color: #5a7d1e;
            border-color: #5a7d1e;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(107, 142, 35, 0.3);
            color: white !important;
        }
        .btn-floral-reject {
            background-color: #e67382;
            color: white;
            border-color: #e67382;
        }
        .btn-floral-reject:hover {
            background-color: #d95365;
            border-color: #d95365;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(230, 115, 130, 0.3);
            color: white !important;
        }
        .btn-floral-secondary {
            background-color: transparent;
            color: var(--text-dark);
            border-color: #ced4da;
        }
        .btn-floral-secondary:hover {
            background-color: var(--pastel-bg);
            color: var(--accent-pink) !important;
            border-color: var(--accent-pink);
        }
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
                    <a class="nav-link ${fn:contains(currentPath, '/admin/shipping-carriers') ? 'active' : ''}" href="<c:url value='/admin/shipping-carriers'/>">
                        <i class="fas fa-truck me-2"></i> Vận chuyển
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/admin/appeals'/>">
                        <i class="fas fa-gavel me-2"></i> Kháng cáo
                    </a>
                </li>
            </ul>
        </div>

        <%-- Flash Messages --%>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="checkout-panel">
            <div class="section-title">
                <div class="title-content">
                    <i class="fas fa-gavel"></i>
                    <span>Chi Tiết Kháng Cáo #${appeal.id}</span>
                </div>
                <a href="<c:url value='/admin/appeals'/>" class="btn btn-floral btn-floral-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>

            <div class="row">
                <div class="col-lg-7">
                    <!-- Redesigned appeal content to match floral theme -->
                    <div class="detail-card">
                        <h5><i class="fas fa-seedling me-2 text-accent"></i>Nội dung kháng cáo</h5>
                        <div class="d-flex align-items-start gap-3 mt-3">
                            <div class="flex-shrink-0">
                                <div class="appeal-flower-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                            </div>
                            <div class="flex-grow-1">
                                <div class="appeal-reason-box p-3 rounded">
                                    <p class="mb-0" style="white-space:pre-wrap;">${fn:escapeXml(appeal.reason)}</p>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-2">
                                    <small class="text-muted">Ngày gửi: <strong><%=(appeal != null && appeal.getSubmittedAt() != null)? appeal.getSubmittedAt().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm, dd/MM/yyyy")): ""%></strong></small>
                                    <div>
                                        <c:choose>
                                            <c:when test="${appeal.status == 'PENDING'}"><span class="badge-theme pending">Chờ xử lý</span></c:when>
                                            <c:when test="${appeal.status == 'APPROVED'}"><span class="badge-theme approved">Đã duyệt</span></c:when>
                                            <c:when test="${appeal.status == 'REJECTED'}"><span class="badge-theme rejected">Đã từ chối</span></c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <c:if test="${appeal.status != 'PENDING'}">
                        <div class="detail-card mt-3">
                            <h5><i class="fas fa-user-shield me-2 text-accent"></i>Thông tin xử lý</h5>
                            <div class="p-3 bg-white rounded mt-2">
                                <div class="d-flex justify-content-between mb-2">
                                    <div>
                                        <div class="small text-muted">Admin xử lý</div>
                                        <div class="fw-bold">${appeal.admin.username} (${appeal.admin.fullName})</div>
                                    </div>
                                    <div class="text-end appeal-meta">
                                        <div class="small text-muted">Ngày xử lý</div>
                                        <div class="fw-bold"><%=(appeal != null && appeal.getProcessedAt() != null)? appeal.getProcessedAt().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm, dd/MM/yyyy")): ""%></div>
                                    </div>
                                </div>
                                <div class="mt-2">
                                    <div class="small text-muted">Ghi chú của admin</div>
                                    <div class="mt-1">${fn:escapeXml(appeal.adminNotes)}</div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
                <div class="col-lg-5">
                    <!-- Redesigned user card to match theme -->
                    <div class="detail-card">
                        <h5><i class="fas fa-user me-2 text-accent"></i>Người gửi</h5>
                        <div class="p-3 bg-white rounded mt-3">
                            <div class="appeal-user-card">
                                <div class="appeal-avatar-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div>
                                    <div class="fw-bold">${appeal.user.fullName}</div>
                                    <div class="text-muted">@${appeal.user.username}</div>
                                    <div class="small mt-1">${appeal.user.email}</div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <div class="appeal-meta">
                                    <small>Ngày gửi</small>
                                    <div class="fw-bold"><%=(appeal != null && appeal.getSubmittedAt() != null)? appeal.getSubmittedAt().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm, dd/MM/yyyy")): ""%></div>
                                </div>
                                <div>
                                    <div class="small text-muted">Trạng thái TK</div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${appeal.user.active}"><span class="badge bg-success">Hoạt động</span></c:when>
                                            <c:otherwise><span class="badge bg-danger">Bị khóa</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="small text-muted">Trạng thái kháng cáo</div>
                                <div class="mt-1">
                                    <c:choose>
                                        <c:when test="${appeal.status == 'PENDING'}"><span class="badge-theme pending">Chờ xử lý</span></c:when>
                                        <c:when test="${appeal.status == 'APPROVED'}"><span class="badge-theme approved">Đã duyệt</span></c:when>
                                        <c:when test="${appeal.status == 'REJECTED'}"><span class="badge-theme rejected">Đã từ chối</span></c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    <c:if test="${appeal.status == 'PENDING'}">
                        <div class="detail-card">
                            <h5><i class="fas fa-cogs me-2 text-primary"></i>Xử lý kháng cáo</h5>
                            <div class="d-grid gap-3">
                                <form action="<c:url value='/admin/appeals/approve/${appeal.id}'/>" method="post" class="d-grid">
                                    <button type="submit" class="btn btn-floral btn-floral-approve" onclick="return confirm('Bạn có chắc chắn muốn DUYỆT kháng cáo này và MỞ KHÓA tài khoản người dùng?');">
                                        <i class="fas fa-check-circle me-2"></i> Duyệt và Mở khóa
                                    </button>
                                </form>
                                <button type="button" class="btn btn-floral btn-floral-reject" data-bs-toggle="modal" data-bs-target="#rejectAppealModal">
                                    <i class="fas fa-times-circle me-2"></i> Từ Chối
                                </button>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</main>

<%-- Modal Từ Chối Kháng Cáo --%>
<div class="modal fade" id="rejectAppealModal" tabindex="-1" aria-labelledby="rejectAppealModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="rejectAppealModalLabel"><i class="fas fa-times-circle me-2"></i>Xác nhận Từ Chối Kháng Cáo</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<c:url value='/admin/appeals/reject/${appeal.id}'/>" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="adminNotes" class="form-label">Lý do từ chối (bắt buộc):</label>
                        <textarea class="form-control" id="adminNotes" name="adminNotes" rows="4" required placeholder="Nêu rõ lý do từ chối để người dùng được biết..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-floral btn-floral-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-floral btn-floral-reject">Xác nhận Từ Chối</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
