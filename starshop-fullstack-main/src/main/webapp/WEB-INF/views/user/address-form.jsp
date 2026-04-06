<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        :root {
            --accent-pink: #FFB6C1;
            --text-dark: #343a40;
            --primary-light: #fff8fa;
            --border-color: #e0e0e0;
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

        /* Form Styling */
        .form-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .form-control {
            border-radius: 8px;
            border: 1px solid var(--border-color);
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: var(--accent-pink);
            box-shadow: 0 0 0 0.2rem rgba(255, 192, 203, 0.25);
        }

        .form-check-input:checked {
            background-color: var(--accent-pink);
            border-color: var(--accent-pink);
        }

        /* Button Styling */
        .btn-primary {
            background: linear-gradient(135deg, #FFC0CB 0%, #FFB6C1 100%);
            border: none;
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(255, 192, 203, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 192, 203, 0.5);
        }

        .btn-secondary {
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            background-color: #f0f0f0;
            border-color: #f0f0f0;
            color: #555;
        }
        
        .btn-secondary:hover {
            background-color: #e0e0e0;
            border-color: #e0e0e0;
        }

    </style>
</head>
<body>

<%-- HEADER --%>
<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<%-- MAIN CONTENT --%>
<main class="main-content py-5">
    <div class="container">
        <c:set var="pageTitle" value="${empty address.id ? 'Thêm Địa Chỉ Mới' : 'Chỉnh Sửa Địa Chỉ'}" />

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

        <!-- Content Panel -->
        <div class="profile-panel">
            <h4 class="section-title mb-4">
                <i class="${empty address.id ? 'fas fa-plus-circle' : 'fas fa-edit'}"></i>
                ${pageTitle}
            </h4>

            <form:form action="/addresses/save" method="post" modelAttribute="address">
                <form:hidden path="id"/>
                <div class="row g-4">
                    <div class="col-md-6">
                        <label for="recipientName" class="form-label">Họ và tên người nhận</label>
                        <form:input path="recipientName" id="recipientName" cssClass="form-control" required="true" placeholder="Nguyễn Văn A"/>
                    </div>

                    <div class="col-md-6">
                        <label for="phoneNumber" class="form-label">Số điện thoại</label>
                        <form:input path="phoneNumber" id="phoneNumber" cssClass="form-control" required="true" placeholder="09xxxxxxxx"/>
                    </div>

                    <div class="col-12">
                        <label for="detailAddress" class="form-label">Địa chỉ chi tiết</label>
                        <form:input path="detailAddress" id="detailAddress" cssClass="form-control" required="true" placeholder="Số nhà, tên đường, phường/xã..."/>
                    </div>

                    <div class="col-12">
                        <label for="city" class="form-label">Tỉnh/Thành phố</label>
                        <form:input path="city" id="city" cssClass="form-control" required="true" placeholder="Hà Nội, TP. Hồ Chí Minh..."/>
                    </div>

                    <div class="col-12">
                        <div class="form-check">
                            <form:checkbox path="default" id="isDefault" cssClass="form-check-input"/>
                            <label class="form-check-label" for="isDefault">Đặt làm địa chỉ mặc định</label>
                        </div>
                    </div>

                    <div class="col-12 mt-4 d-flex justify-content-end gap-2">
                        <a href="<c:url value='/addresses'/>" class="btn btn-secondary">Hủy</a>
                        <button type="submit" class="btn btn-primary">Lưu Địa Chỉ</button>
                    </div>
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
