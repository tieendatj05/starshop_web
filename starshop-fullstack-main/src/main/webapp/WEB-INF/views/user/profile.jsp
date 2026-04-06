<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài Khoản Của Tôi - StarShop</title>
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

        /* Custom button style */
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

        .btn-primary.btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }

        /* Definition list styling */
        .profile-details dt {
            font-weight: 600;
            color: #6c757d;
            padding-bottom: 1rem;
        }

        .profile-details dd {
            font-weight: 500;
            color: var(--text-dark);
            padding-bottom: 1rem;
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
                <a class="nav-link active" href="<c:url value='/profile'/>">
                    <i class="fas fa-user-circle me-2"></i>Thông tin cá nhân
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value='/addresses'/>">
                    <i class="fas fa-map-marked-alt me-2"></i>Sổ địa chỉ
                </a>
            </li>
        </ul>

        <!-- Content Panel -->
        <div class="profile-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="section-title mb-0">
                    <i class="fas fa-address-card"></i>
                    Chi tiết tài khoản
                </h4>
                <a href="<c:url value='/profile/edit'/>" class="btn btn-primary btn-sm">
                    <i class="fas fa-edit"></i> Chỉnh sửa
                </a>
            </div>

            <div class="profile-details">
                <dl class="row mb-0">
                    <dt class="col-sm-4 col-md-3">Tên đăng nhập</dt>
                    <dd class="col-sm-8 col-md-9">${user.username}</dd>

                    <dt class="col-sm-4 col-md-3">Họ và tên</dt>
                    <dd class="col-sm-8 col-md-9">${not empty user.fullName ? user.fullName : 'Chưa cập nhật'}</dd>

                    <dt class="col-sm-4 col-md-3">Email</dt>
                    <dd class="col-sm-8 col-md-9">${user.email}</dd>

                    <dt class="col-sm-4 col-md-3">Số điện thoại</dt>
                    <dd class="col-sm-8 col-md-9">${not empty user.phoneNumber ? user.phoneNumber : 'Chưa cập nhật'}</dd>
                </dl>
            </div>
        </div>
    </div>
</main>

<%-- FOOTER --%>
<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
