<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sổ Địa Chỉ - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        :root {
            --accent-pink: #FFB6C1;
            --text-dark: #343a40;
            --primary-light: #fff8fa;
            --border-color: #e9ecef;
        }

        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
        }

        /* Profile Tab Navigation */
        .profile-nav {
            background: #fff;
            border-radius: 16px;
            padding: 0.5rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
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

        .profile-nav .nav-link:hover:not(.active) {
            background-color: var(--primary-light);
        }

        .profile-nav .nav-link.active {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
        }

        /* Modern Card Panel */
        .profile-panel {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 2rem;
        }

        /* Section Title */
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-title i {
            color: var(--accent-pink);
            font-size: 1.6rem;
        }

        /* Address Card Styling */
        .address-card {
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            height: 100%;
            display: flex;
            flex-direction: column;
            transition: all 0.3s ease;
        }

        .address-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.1);
            border-color: var(--accent-pink);
        }

        .address-card-body {
            flex-grow: 1;
        }

        .address-card-footer {
            padding-top: 1rem;
            margin-top: 1rem;
            border-top: 1px solid var(--border-color);
        }

        /* Button Styling */
        .btn-primary {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            border: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 192, 203, 0.5);
        }

        .btn-outline-secondary {
            border-radius: 8px;
        }
        .btn-outline-danger {
            border-radius: 8px;
        }
        .btn-link {
            text-decoration: none;
            font-weight: 600;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
        }
        .empty-state i {
            font-size: 4rem;
            color: #e0e0e0;
        }
        .empty-state h4 {
            margin-top: 1.5rem;
            font-weight: 600;
        }
        .empty-state p {
            color: #6c757d;
        }

    </style>
</head>
<body>

<%-- HEADER --%>
<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<%-- MAIN CONTENT --%>
<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="Tài Khoản Của Tôi" />
        <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

        <!-- Tab Navigation -->
        <ul class="nav nav-pills nav-fill mb-4 profile-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value='/profile'/>">
                    <i class="fas fa-user-circle me-2"></i>Thông tin cá nhân
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="<c:url value='/addresses'/>">
                    <i class="fas fa-map-marked-alt me-2"></i>Sổ địa chỉ
                </a>
            </li>
        </ul>

        <%-- Hiển thị thông báo --%>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show rounded-3" role="alert">
                <i class="fas fa-check-circle me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Content Panel -->
        <div class="profile-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="section-title mb-0">
                    <i class="fas fa-book"></i>
                    Sổ Địa Chỉ
                </h4>
                <a href="<c:url value='/addresses/new'/>" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Thêm Địa Chỉ Mới
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty addresses}">
                    <div class="row g-4">
                        <c:forEach var="addr" items="${addresses}">
                            <div class="col-lg-6">
                                <div class="address-card">
                                    <div class="address-card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="mb-0 fw-bold">${addr.recipientName}</h5>
                                            <c:if test="${addr['default']}">
                                                <span class="badge bg-success">Mặc định</span>
                                            </c:if>
                                        </div>
                                        <p class="text-muted mb-1"><i class="fas fa-phone me-2"></i>${addr.phoneNumber}</p>
                                        <p class="text-muted mb-0"><i class="fas fa-map-marker-alt me-2"></i>${addr.detailAddress}, ${addr.city}</p>
                                    </div>
                                    <div class="address-card-footer d-flex justify-content-between align-items-center">
                                        <c:if test="${!addr['default']}">
                                            <form action="<c:url value='/addresses/default/${addr.id}'/>" method="post" class="mb-0">
                                                <button type="submit" class="btn btn-link p-0">Đặt làm mặc định</button>
                                            </form>
                                        </c:if>
                                        <div class="ms-auto">
                                            <a href="<c:url value='/addresses/edit/${addr.id}'/>" class="btn btn-sm btn-outline-secondary me-1"><i class="fas fa-pen"></i></a>
                                            <form action="<c:url value='/addresses/delete/${addr.id}'/>" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');" class="d-inline mb-0">
                                                <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fas fa-trash"></i></button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-map-signs"></i>
                        <h4>Sổ địa chỉ của bạn trống</h4>
                        <p>Thêm địa chỉ mới để quản lý và thanh toán nhanh hơn.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<%-- FOOTER --%>
<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
