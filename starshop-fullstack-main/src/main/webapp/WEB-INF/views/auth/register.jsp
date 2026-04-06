<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="cherryOverlay" value="false" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng Ký - StarShop</title>
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
            z-index: 10;
        }
        .login-form-panel {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 4px 32px rgba(255,192,203,0.13);
            max-width: 600px;
            width: 100%;
            padding: 2.5rem 2rem;
            position: relative;
            z-index: 11;
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
    <main class="main-content">
        <div class="login-form-panel p-4 p-md-5 rounded-4 shadow-lg bg-white">
            <h2 class="gradient-text animated-gradient text-center mb-4" style="font-weight:900; font-size:2rem;">TẠO TÀI KHOẢN</h2>
            <form class="needs-validation" action="<c:url value='/register'/>" method="post" novalidate>
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">${error}</div>
                </c:if>
                <div class="mb-3">
                    <label for="username" class="form-label">Tên đăng nhập</label>
                    <input id="username" name="username" class="form-control form-control-lg" type="text" autocomplete="username" required aria-required="true" value="${param.username}" aria-describedby="userHelp">
                    <div id="userHelp" class="form-text">Chọn tên tài khoản duy nhất để đăng nhập.</div>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input id="email" name="email" class="form-control form-control-lg" type="email" autocomplete="email" required aria-required="true" value="${param.email}" aria-describedby="emailHelp">
                    <div id="emailHelp" class="form-text">Nhập email hợp lệ để nhận thông báo và khôi phục mật khẩu.</div>
                </div>
                <div class="mb-3">
                    <label for="fullName" class="form-label">Họ và Tên</label>
                    <input id="fullName" name="fullName" class="form-control form-control-lg" type="text" required aria-required="true" value="${param.fullName}" aria-describedby="nameHelp">
                    <div id="nameHelp" class="form-text">Nhập họ tên thật để thuận tiện xác minh.</div>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <input id="password" name="password" class="form-control form-control-lg" type="password" autocomplete="new-password" required aria-required="true" aria-describedby="pwdHelp">
                        <button type="button" id="togglePassword" class="btn btn-outline-secondary" aria-pressed="false" aria-label="Hiện/Tắt mật khẩu"><i class="bi bi-eye" aria-hidden="true"></i></button>
                    </div>
                    <div id="pwdHelp" class="form-text">Mật khẩu nên có ít nhất 8 ký tự, bao gồm chữ và số.</div>
                </div>
                <div class="d-grid mb-3">
                    <button type="submit" class="btn btn-lg btn-gradient">Đăng Ký</button>
                </div>
                <div class="text-center form-note">Đã có tài khoản? <a href="<c:url value='/login'/>">Đăng nhập ngay</a></div>
            </form>
            <script>
                (function() {
                    document.addEventListener('DOMContentLoaded', function() {
                        var username = document.getElementById('username');
                        var pwd = document.getElementById('password');
                        var toggle = document.getElementById('togglePassword');
                        if (username) username.focus();
                        if (toggle && pwd) {
                            toggle.addEventListener('click', function() {
                                var pressed = this.getAttribute('aria-pressed') === 'true';
                                var icon = this.querySelector('i');
                                if (!pressed) {
                                    pwd.type = 'text';
                                    this.setAttribute('aria-pressed', 'true');
                                    if (icon) { icon.classList.remove('bi-eye'); icon.classList.add('bi-eye-slash'); }
                                } else {
                                    pwd.type = 'password';
                                    this.setAttribute('aria-pressed', 'false');
                                    if (icon) { icon.classList.remove('bi-eye-slash'); icon.classList.add('bi-eye'); }
                                }
                            });
                        }
                        var form = document.querySelector('form.needs-validation');
                        if (form) {
                            form.addEventListener('submit', function(e) {
                                var u = username && username.value && username.value.trim();
                                var p = pwd && pwd.value && pwd.value.trim();
                                var email = document.getElementById('email').value.trim();
                                var fullName = document.getElementById('fullName').value.trim();
                                if (!u || !p || !email || !fullName) {
                                    e.preventDefault();
                                    var existing = document.getElementById('registerInlineAlert');
                                    if (existing) existing.remove();
                                    var alert = document.createElement('div');
                                    alert.id = 'registerInlineAlert';
                                    alert.className = 'alert alert-danger mt-2';
                                    alert.setAttribute('role','alert');
                                    alert.textContent = 'Vui lòng nhập đầy đủ thông tin đăng ký.';
                                    form.parentNode.insertBefore(alert, form);
                                    if (!u) username.focus();
                                    else if (!email) document.getElementById('email').focus();
                                    else if (!fullName) document.getElementById('fullName').focus();
                                    else pwd.focus();
                                }
                            });
                        }
                    });
                })();
            </script>
        </div>
    </main>
    <jsp:include page="/WEB-INF/views/shared/footer.jsp" />
    <div class="cherry-blossom-container"></div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/resources/js/cherry-blossom.js'/>"></script>
</body>
</html>
