<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="cherryOverlay" value="false" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên Mật Khẩu - StarShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/custom.css'/>">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .main-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        .login-form-panel {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 4px 32px rgba(255,192,203,0.13);
            max-width: 600px;
            width: 100%;
            padding: 2.5rem 2rem;
        }
        .gradient-text {
            background: linear-gradient(90deg, var(--header-text-color) 0%, var(--accent-pink) 50%, #FF99AA 100%);
            background-size: 200% 200%;
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            -webkit-text-fill-color: transparent;
            font-weight: 900;
            animation: gradientMove 3.5s ease-in-out infinite;
        }
        @keyframes gradientMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .animated-gradient {
            transition: opacity 480ms cubic-bezier(.16,.84,.32,1), transform 480ms cubic-bezier(.16,.84,.32,1);
            will-change: opacity, transform;
        }
        .form-label {
            font-weight: 600;
            color: var(--accent-pink);
        }
        .form-control:focus {
            border-color: var(--accent-pink);
            box-shadow: 0 0 0 0.18rem rgba(255,192,203,0.12);
        }
        .btn-gradient {
            background: linear-gradient(90deg, var(--accent-pink), #FF99AA);
            color: #fff;
            border: none;
            font-weight: 700;
            border-radius: var(--btn-radius);
            box-shadow: 0 2px 8px rgba(255,192,203,0.08);
            transition: background 0.3s;
        }
        .btn-gradient:hover {
            background: linear-gradient(90deg, #FF99AA, var(--accent-pink));
            color: #fff;
        }
        .form-note, .helper-row {
            color: var(--text-light);
            font-size: .97rem;
        }
        .alert {
            font-size: .98rem;
        }
        @media (max-width: 600px) {
            .login-form-panel {
                padding: 1.2rem 0.5rem;
                border-radius: 12px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/shared/header.jsp" />
    <main style="display:flex; justify-content:center; align-items:center; min-height:80vh; position:relative; z-index:10;">
        <div class="login-form-panel p-4 p-md-5 rounded-4 shadow-lg bg-white" style="max-width: 600px; width:100%; position:relative; z-index:11;">
            <h2 class="gradient-text animated-gradient text-center mb-4" style="font-weight:900; font-size:2rem;">QUÊN MẬT KHẨU</h2>
            <form class="needs-validation" action="<c:url value='/forgot-password'/>" method="post" novalidate>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success" role="status">${success}</div>
                </c:if>
                <div class="alert alert-info" role="status">
                    <i class="bi bi-info-circle me-2"></i>Nhập địa chỉ email đã đăng ký. Chúng tôi sẽ gửi mã OTP để xác thực và đặt lại mật khẩu của bạn.
                </div>
                <div class="mb-4">
                    <label for="email" class="form-label">Địa chỉ email</label>
                    <input id="email" name="email" class="form-control form-control-lg" type="email" autocomplete="email" required aria-required="true" aria-describedby="emailHelp">
                    <div id="emailHelp" class="form-text">Nhập email bạn đã sử dụng để đăng ký tài khoản.</div>
                </div>
                <div class="d-grid mb-3">
                    <button type="submit" class="btn btn-lg btn-gradient">Gửi Mã OTP</button>
                </div>
                <div class="text-center form-note">
                    Nhớ mật khẩu? <a href="<c:url value='/login'/>">Đăng nhập</a>
                </div>
            </form>
            <script>
                (function() {
                    document.addEventListener('DOMContentLoaded', function() {
                        var email = document.getElementById('email');
                        if (email) email.focus();
                        var form = document.querySelector('form.needs-validation');
                        if (form) {
                            form.addEventListener('submit', function(e) {
                                var emailValue = email && email.value && email.value.trim();
                                if (!emailValue) {
                                    e.preventDefault();
                                    var existing = document.getElementById('forgotInlineAlert');
                                    if (existing) existing.remove();
                                    var alert = document.createElement('div');
                                    alert.id = 'forgotInlineAlert';
                                    alert.className = 'alert alert-danger mt-2';
                                    alert.setAttribute('role','alert');
                                    alert.textContent = 'Vui lòng nhập địa chỉ email.';
                                    form.parentNode.insertBefore(alert, form);
                                    email.focus();
                                } else if (!email.validity.valid) {
                                    e.preventDefault();
                                    var existing = document.getElementById('forgotInlineAlert');
                                    if (existing) existing.remove();
                                    var alert = document.createElement('div');
                                    alert.id = 'forgotInlineAlert';
                                    alert.className = 'alert alert-danger mt-2';
                                    alert.setAttribute('role','alert');
                                    alert.textContent = 'Vui lòng nhập địa chỉ email hợp lệ.';
                                    form.parentNode.insertBefore(alert, form);
                                    email.focus();
                                }
                            });
                        }
                    });
                })();
            </script>
        </div>
    </main>
    <jsp:include page="/WEB-INF/views/shared/footer.jsp" />
    <!-- Hiệu ứng hoa anh đào rơi dưới cùng, dùng đúng class như header.jsp -->
    <div class="cherry-blossom-container"></div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/resources/js/cherry-blossom.js'/>"></script>
</body>
</html>
