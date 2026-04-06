<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Viết Đánh Giá - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"> <%-- Bootstrap Icons CDN --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>"> <%-- Custom CSS --%>
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .main-content { flex: 1; }
        .star-rating {
            font-size: 2rem;
            cursor: pointer;
        }
        .star-rating .fa-star {
            color: #e4e5e9;
        }
        .star-rating .fa-star.selected, .star-rating:hover .fa-star {
            color: #ffc107;
        }
        .star-rating:hover .fa-star:hover ~ .fa-star {
            color: #e4e5e9;
        }
        /* Custom styles for review images */
        .review-product-thumb {
            width: 100px;
            height: 100px;
        }
        .review-image-thumb {
            max-width: 150px;
            height: auto;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/shared/header.jsp" />

<main class="main-content py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <c:set var="pageTitle" value="Viết đánh giá cho sản phẩm" />
                <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

                <div class="card mb-4">
                    <div class="card-body d-flex">
                        <img src="<c:url value='/${product.imageUrl}'/>" alt="${product.name}" class="rounded me-3 img-square-1x1 review-product-thumb">
                        <div>
                            <h4>${product.name}</h4>
                            <p class="text-muted">Cung cấp bởi: ${product.shop.name}</p>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>

                <div class="card">
                    <div class="card-body">
                        <form:form action="/review/save" method="post" modelAttribute="review">
                            <form:hidden path="product.id"/>

                            <div class="mb-4">
                                <label class="form-label">1. Đánh giá của bạn:</label>
                                <div class="star-rating" id="starRating">
                                    <i class="fas fa-star" data-value="1"></i>
                                    <i class="fas fa-star" data-value="2"></i>
                                    <i class="fas fa-star" data-value="3"></i>
                                    <i class="fas fa-star" data-value="4"></i>
                                    <i class="fas fa-star" data-value="5"></i>
                                </div>
                                <form:hidden path="rating" id="ratingInput"/>
                            </div>

                            <div class="mb-3">
                                <label for="comment" class="form-label">2. Viết bình luận (tối thiểu 50 ký tự):</label>
                                <form:textarea path="comment" id="comment" cssClass="form-control" rows="5" required="true" minlength="50"/>
                            </div>

                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">3. Tải lên hình ảnh thực tế (tùy chọn):</label>
                                <form:input path="imageUrl" id="imageUrl" type="file" cssClass="form-control"/>
                            </div>

                            <div class="mb-3">
                                <label for="videoUrl" class="form-label">4. Tải lên video (tùy chọn):</label>
                                <form:input path="videoUrl" id="videoUrl" type="file" cssClass="form-control"/>
                            </div>

                            <button type="submit" class="btn btn-primary">Gửi Đánh Giá</button>
                            <a href="<c:url value='/product/${product.id}'/>" class="btn btn-secondary">Hủy</a>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/shared/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const stars = document.querySelectorAll('.star-rating .fa-star');
        const ratingInput = document.getElementById('ratingInput');

        stars.forEach(star => {
            star.addEventListener('click', function () {
                const value = this.dataset.value;
                ratingInput.value = value;
                stars.forEach(s => {
                    s.classList.toggle('selected', s.dataset.value <= value);
                });
            });

            star.addEventListener('mouseover', function () {
                stars.forEach(s => {
                    s.style.color = s.dataset.value <= this.dataset.value ? '#ffc107' : '#e4e5e9';
                });
            });

            star.addEventListener('mouseout', function () {
                stars.forEach(s => {
                    s.style.color = ''; // Reset to CSS default
                });
            });
        });
    });
</script>

</body>
</html>