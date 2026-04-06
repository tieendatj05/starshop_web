<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="cherryOverlay" value="false" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng Nhập - StarShop</title>
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
            <h2 class="gradient-text animated-gradient text-center mb-4" style="font-weight:900; font-size:2rem;">ĐĂNG NHẬP</h2>

            <!-- Thông báo từ server-side login -->
            <div id="serverMessages">
                <c:if test="${not empty _csrf}">
                    <input type="hidden" id="csrfToken" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>
                <c:if test="${not empty reloginMessage}">
                    <div class="alert alert-success" role="status">${reloginMessage}</div>
                </c:if>
                <c:if test="${param.error}">
                    <div class="alert alert-danger" role="alert">Tên đăng nhập hoặc mật khẩu không đúng.</div>
                </c:if>
                <c:if test="${param.logout}">
                    <div class="alert alert-success" role="status">Bạn đã đăng xuất thành công.</div>
                </c:if>
                <c:if test="${param.register_success}">
                    <div class="alert alert-success" role="status">Đăng ký thành công! Vui lòng đăng nhập.</div>
                </c:if>
            </div>

            <!-- Thông báo động từ JWT login -->
            <div id="dynamicAlert"></div>

            <form id="loginForm" class="needs-validation" novalidate>
                <div class="mb-3">
                    <label for="username" class="form-label">Tên đăng nhập hoặc email</label>
                    <input id="username" name="username" class="form-control form-control-lg" type="text" autocomplete="username" required aria-required="true" aria-describedby="userHelp">
                    <div id="userHelp" class="form-text">Sử dụng tên tài khoản hoặc email bạn đã đăng ký.</div>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <input id="password" name="password" class="form-control form-control-lg" type="password" autocomplete="current-password" required aria-required="true" aria-describedby="pwdHelp">
                        <button type="button" id="togglePassword" class="btn btn-outline-secondary" aria-pressed="false" aria-label="Hiện/Tắt mật khẩu"><i class="bi bi-eye" aria-hidden="true"></i></button>
                    </div>
                    <div id="pwdHelp" class="form-text">Ít nhất 6 ký tự (nếu bạn quên, hãy sử dụng liên kết 'Quên mật khẩu').</div>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-3 helper-row">
                    <div class="form-check">
                        <input id="rememberMe" name="remember-me" class="form-check-input" type="checkbox" value="true">
                        <label for="rememberMe" class="form-check-label">Ghi nhớ tôi</label>
                    </div>
                    <div class="text-end">
                        <a href="<c:url value='/forgot-password'/>" class="small">Quên mật khẩu?</a>
                    </div>
                </div>
                <div class="d-grid mb-3">
                    <button type="submit" id="loginButton" class="btn btn-lg btn-gradient">
                        <span id="buttonText">Đăng Nhập</span>
                        <span id="buttonSpinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    </button>
                </div>
                <div class="text-center form-note">Chưa có tài khoản? <a href="<c:url value='/register'/>">Đăng ký</a></div>
            </form>
            <script>
                (function() {
                    document.addEventListener('DOMContentLoaded', function() {
                        var username = document.getElementById('username');
                        var pwd = document.getElementById('password');
                        var toggle = document.getElementById('togglePassword');
                        var loginButton = document.getElementById('loginButton');
                        var buttonText = document.getElementById('buttonText');
                        var buttonSpinner = document.getElementById('buttonSpinner');

                        if (username) username.focus();

                        // Toggle password visibility
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

                        // Handle JWT Login
                        var form = document.getElementById('loginForm');
                        if (form) {
                            form.addEventListener('submit', function(e) {
                                e.preventDefault(); // Prevent default form submission

                                var u = username && username.value && username.value.trim();
                                var p = pwd && pwd.value && pwd.value.trim();

                                if (!u || !p) {
                                    showAlert('danger', 'Vui lòng nhập tên đăng nhập và mật khẩu.');
                                    if (!u) username.focus(); else pwd.focus();
                                    return;
                                }

                                // Disable button and show loading
                                loginButton.disabled = true;
                                buttonText.classList.add('d-none');
                                buttonSpinner.classList.remove('d-none');

                                // Call JWT Login API
                                fetch('/api/auth/login', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    },
                                    credentials: 'include', // Important: send and receive cookies
                                    body: JSON.stringify({
                                        username: u,
                                        password: p
                                    })
                                })
                                .then(function(response) {
                                    return response.json().then(function(data) {
                                        return { status: response.status, data: data };
                                    });
                                })
                                .then(function(result) {
                                    if (result.status === 200) {
                                        // Login successful
                                        console.log('✅ JWT Login successful:', result.data);
                                        showAlert('success', '🎉 Đăng nhập thành công! Đang chuyển hướng...');

                                        // Redirect to home for all roles
                                        setTimeout(function() {
                                            window.location.href = '/home';
                                        }, 1000);
                                    } else if (result.status === 403) {
                                        // Account locked
                                        showAlert('danger', '🔒 ' + result.data);
                                        resetButton();
                                    } else if (result.status === 401) {
                                        // Wrong credentials
                                        showAlert('danger', '❌ ' + result.data);
                                        resetButton();
                                        pwd.value = '';
                                        pwd.focus();
                                    } else {
                                        // Other errors
                                        showAlert('danger', '❌ Đăng nhập thất bại: ' + result.data);
                                        resetButton();
                                    }
                                })
                                .catch(function(error) {
                                    console.error('❌ Login error:', error);
                                    showAlert('danger', '❌ Lỗi kết nối: ' + error.message + '. Vui lòng kiểm tra server.');
                                    resetButton();
                                });
                            });
                        }

                        function showAlert(type, message) {
                            var alertDiv = document.getElementById('dynamicAlert');
                            alertDiv.innerHTML = '<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' +
                                message +
                                '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                                '</div>';
                        }

                        function resetButton() {
                            loginButton.disabled = false;
                            buttonText.classList.remove('d-none');
                            buttonSpinner.classList.add('d-none');
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
