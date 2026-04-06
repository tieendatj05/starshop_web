<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>JWT Test Page - StarShop</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        h1 {
            color: #333;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 10px;
        }
        h2 {
            color: #666;
            margin-top: 20px;
        }
        .test-section {
            margin: 15px 0;
            padding: 15px;
            background: #f9f9f9;
            border-left: 4px solid #4CAF50;
        }
        button {
            background: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 5px;
            font-size: 14px;
        }
        button:hover {
            background: #45a049;
        }
        .result {
            margin-top: 10px;
            padding: 10px;
            background: #e8f5e9;
            border: 1px solid #4CAF50;
            border-radius: 4px;
            white-space: pre-wrap;
            word-break: break-all;
        }
        .error {
            background: #ffebee;
            border-color: #f44336;
            color: #c62828;
        }
        .info {
            background: #e3f2fd;
            border-color: #2196F3;
            color: #1565c0;
        }
        input {
            padding: 8px;
            width: 300px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin: 5px;
        }
        .status {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: bold;
            margin-left: 10px;
        }
        .status.success {
            background: #4CAF50;
            color: white;
        }
        .status.fail {
            background: #f44336;
            color: white;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        table th, table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        table th {
            background: #f0f0f0;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h1>🔐 JWT Authentication Test Page</h1>

    <div class="container">
        <h2>1. Kiểm tra JWT Cookie</h2>
        <div class="test-section">
            <button onclick="checkJWTCookie()">Kiểm tra JWT Cookie</button>
            <div id="cookieResult"></div>
        </div>
    </div>

    <div class="container">
        <h2>2. Đăng nhập và lấy JWT Token</h2>
        <div class="test-section">
            <input type="text" id="username" placeholder="Username" value="admin">
            <input type="password" id="password" placeholder="Password" value="admin123">
            <br>
            <button onclick="login()">Đăng nhập</button>
            <div id="loginResult"></div>
        </div>
    </div>

    <div class="container">
        <h2>3. Validate JWT Token</h2>
        <div class="test-section">
            <button onclick="validateToken()">Validate Token</button>
            <div id="validateResult"></div>
        </div>
    </div>

    <div class="container">
        <h2>4. Refresh JWT Token</h2>
        <div class="test-section">
            <button onclick="refreshToken()">Refresh Token</button>
            <div id="refreshResult"></div>
        </div>
    </div>

    <div class="container">
        <h2>5. Test Protected Endpoint</h2>
        <div class="test-section">
            <button onclick="testProtectedEndpoint()">Test /profile</button>
            <button onclick="testAdminEndpoint()">Test /admin</button>
            <div id="protectedResult"></div>
        </div>
    </div>

    <div class="container">
        <h2>6. Giải mã JWT Token</h2>
        <div class="test-section">
            <button onclick="decodeToken()">Giải mã Token</button>
            <div id="decodeResult"></div>
        </div>
    </div>

    <div class="container">
        <h2>7. Đăng xuất và xóa JWT</h2>
        <div class="test-section">
            <button onclick="logout()">Đăng xuất</button>
            <div id="logoutResult"></div>
        </div>
    </div>

    <script>
        let currentToken = null;

        // 1. Kiểm tra JWT Cookie
        async function checkJWTCookie() {
            const resultDiv = document.getElementById('cookieResult');
            resultDiv.innerHTML = '<div class="result info">Đang kiểm tra JWT Cookie...</div>';

            try {
                // Gọi API server-side để kiểm tra cookie HttpOnly
                const response = await fetch('/api/auth/check-cookie', {
                    method: 'GET',
                    credentials: 'include' // Quan trọng: gửi cookies cùng request
                });

                const data = await response.json();

                if (data.found) {
                    if (data.valid !== false) {
                        currentToken = data.token;
                        resultDiv.innerHTML = `
                            <div class="result">
                                <strong>✅ JWT Cookie được tìm thấy!</strong><span class="status success">SUCCESS</span>
                                <br><br>
                                <strong>⚠️ Lưu ý:</strong> Cookie được set với HttpOnly=true nên JavaScript không thể đọc trực tiếp (đây là tính năng bảo mật tốt!)
                                <br><br>
                                <table>
                                    <tr><th>Thông tin</th><th>Giá trị</th></tr>
                                    <tr><td>Username</td><td>${data.username || 'N/A'}</td></tr>
                                    <tr><td>User ID</td><td>${data.userId || 'N/A'}</td></tr>
                                    <tr><td>Token Length</td><td>${data.tokenLength} ký tự</td></tr>
                                    <tr><td>HttpOnly</td><td>✅ true (Secure)</td></tr>
                                </table>
                                <br>
                                <strong>Token:</strong><br>${data.token}
                            </div>
                        `;
                    } else {
                        resultDiv.innerHTML = `
                            <div class="result error">
                                <strong>⚠️ JWT Cookie tồn tại nhưng không hợp lệ</strong><span class="status fail">INVALID</span>
                                <br><br>
                                <strong>Lỗi:</strong> ${data.error}
                            </div>
                        `;
                    }
                } else {
                    resultDiv.innerHTML = `
                        <div class="result error">
                            <strong>❌ Không tìm thấy JWT Cookie</strong><span class="status fail">NOT FOUND</span>
                            <br><br>
                            Cookie JWT-TOKEN không tồn tại trong request.
                            <br><br>
                            <strong>Hướng dẫn:</strong>
                            <ol style="text-align: left; margin-top: 10px;">
                                <li>Nhập username/password trong phần "Đăng nhập" bên dưới</li>
                                <li>Click nút "Đăng nhập"</li>
                                <li>Sau khi đăng nhập thành công, click lại "Kiểm tra JWT Cookie"</li>
                            </ol>
                        </div>
                    `;
                }
            } catch (error) {
                resultDiv.innerHTML = `
                    <div class="result error">
                        <strong>❌ Lỗi kết nối:</strong>
                        <br><br>
                        ${error.message}
                        <br><br>
                        Vui lòng đảm bảo server đang chạy.
                    </div>
                `;
            }
        }

        // 2. Đăng nhập
        async function login() {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const resultDiv = document.getElementById('loginResult');

            resultDiv.innerHTML = '<div class="result info">Đang đăng nhập...</div>';

            try {
                const response = await fetch('/api/auth/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ username, password })
                });

                const data = await response.json();

                if (response.ok) {
                    currentToken = data.token;
                    resultDiv.innerHTML = `
                        <div class="result">
                            <strong>✅ Đăng nhập thành công!</strong><span class="status success">SUCCESS</span>
                            <br><br>
                            <table>
                                <tr><th>Thông tin</th><th>Giá trị</th></tr>
                                <tr><td>User ID</td><td>${data.userId}</td></tr>
                                <tr><td>Username</td><td>${data.username}</td></tr>
                                <tr><td>Email</td><td>${data.email}</td></tr>
                                <tr><td>Role</td><td>${data.role}</td></tr>
                            </table>
                            <br>
                            <strong>Token:</strong><br>${data.token}
                        </div>
                    `;
                } else {
                    resultDiv.innerHTML = `
                        <div class="result error">
                            <strong>❌ Đăng nhập thất bại!</strong><span class="status fail">FAILED</span>
                            <br><br>
                            <strong>Lỗi:</strong> ${data}
                        </div>
                    `;
                }
            } catch (error) {
                resultDiv.innerHTML = `
                    <div class="result error">
                        <strong>❌ Lỗi kết nối!</strong>
                        <br><br>
                        ${error.message}
                    </div>
                `;
            }
        }

        // 3. Validate Token
        async function validateToken() {
            const resultDiv = document.getElementById('validateResult');

            if (!currentToken) {
                checkJWTCookie();
                if (!currentToken) {
                    resultDiv.innerHTML = '<div class="result error">❌ Không có token. Vui lòng đăng nhập trước!</div>';
                    return;
                }
            }

            resultDiv.innerHTML = '<div class="result info">Đang validate token...</div>';

            try {
                const response = await fetch('/api/auth/validate', {
                    method: 'GET',
                    headers: {
                        'Authorization': 'Bearer ' + currentToken
                    }
                });

                const data = await response.json();

                if (response.ok) {
                    resultDiv.innerHTML = `
                        <div class="result">
                            <strong>✅ Token hợp lệ!</strong><span class="status success">VALID</span>
                            <br><br>
                            <strong>Thông tin:</strong><br>
                            ${JSON.stringify(data, null, 2)}
                        </div>
                    `;
                } else {
                    resultDiv.innerHTML = `
                        <div class="result error">
                            <strong>❌ Token không hợp lệ!</strong><span class="status fail">INVALID</span>
                            <br><br>
                            ${data}
                        </div>
                    `;
                }
            } catch (error) {
                resultDiv.innerHTML = `
                    <div class="result error">
                        <strong>❌ Lỗi:</strong> ${error.message}
                    </div>
                `;
            }
        }

        // 4. Refresh Token
        async function refreshToken() {
            const resultDiv = document.getElementById('refreshResult');

            if (!currentToken) {
                checkJWTCookie();
                if (!currentToken) {
                    resultDiv.innerHTML = '<div class="result error">❌ Không có token. Vui lòng đăng nhập trước!</div>';
                    return;
                }
            }

            resultDiv.innerHTML = '<div class="result info">Đang refresh token...</div>';

            try {
                const response = await fetch('/api/auth/refresh', {
                    method: 'POST',
                    headers: {
                        'Authorization': 'Bearer ' + currentToken
                    }
                });

                const data = await response.json();

                if (response.ok) {
                    currentToken = data.token;
                    resultDiv.innerHTML = `
                        <div class="result">
                            <strong>✅ Token đã được refresh!</strong><span class="status success">SUCCESS</span>
                            <br><br>
                            <strong>New Token:</strong><br>${data.token}
                        </div>
                    `;
                } else {
                    resultDiv.innerHTML = `
                        <div class="result error">
                            <strong>❌ Refresh thất bại!</strong><span class="status fail">FAILED</span>
                        </div>
                    `;
                }
            } catch (error) {
                resultDiv.innerHTML = `
                    <div class="result error">
                        <strong>❌ Lỗi:</strong> ${error.message}
                    </div>
                `;
            }
        }

        // 5. Test Protected Endpoint
        async function testProtectedEndpoint() {
            await testEndpoint('/profile', 'protectedResult');
        }

        async function testAdminEndpoint() {
            await testEndpoint('/admin', 'protectedResult');
        }

        async function testEndpoint(endpoint, resultDivId) {
            const resultDiv = document.getElementById(resultDivId);

            resultDiv.innerHTML = `<div class="result info">Đang test endpoint: ${endpoint}</div>`;

            try {
                const response = await fetch(endpoint);

                if (response.ok) {
                    resultDiv.innerHTML = `
                        <div class="result">
                            <strong>✅ Truy cập thành công: ${endpoint}</strong><span class="status success">SUCCESS</span>
                            <br><br>
                            <strong>Status:</strong> ${response.status}
                        </div>
                    `;
                } else if (response.status === 401) {
                    resultDiv.innerHTML = `
                        <div class="result error">
                            <strong>🔒 Cần xác thực: ${endpoint}</strong><span class="status fail">401</span>
                            <br><br>
                            JWT đang hoạt động! Endpoint yêu cầu đăng nhập.
                        </div>
                    `;
                } else if (response.status === 403) {
                    resultDiv.innerHTML = `
                        <div class="result error">
                            <strong>🚫 Không có quyền truy cập: ${endpoint}</strong><span class="status fail">403</span>
                            <br><br>
                            JWT đang hoạt động! Bạn không có quyền truy cập endpoint này.
                        </div>
                    `;
                } else {
                    resultDiv.innerHTML = `
                        <div class="result error">
                            <strong>❌ Status:</strong> ${response.status}
                        </div>
                    `;
                }
            } catch (error) {
                resultDiv.innerHTML = `
                    <div class="result error">
                        <strong>❌ Lỗi:</strong> ${error.message}
                    </div>
                `;
            }
        }

        // 6. Giải mã Token
        function decodeToken() {
            const resultDiv = document.getElementById('decodeResult');

            if (!currentToken) {
                checkJWTCookie();
                if (!currentToken) {
                    resultDiv.innerHTML = '<div class="result error">❌ Không có token. Vui lòng đăng nhập trước!</div>';
                    return;
                }
            }

            try {
                // JWT format: header.payload.signature
                const parts = currentToken.split('.');
                if (parts.length !== 3) {
                    throw new Error('Token không đúng định dạng JWT');
                }

                // Giải mã header
                const header = JSON.parse(atob(parts[0]));

                // Giải mã payload
                const payload = JSON.parse(atob(parts[1]));

                // Convert timestamp to date
                const issuedAt = new Date(payload.iat * 1000).toLocaleString();
                const expiration = new Date(payload.exp * 1000).toLocaleString();

                resultDiv.innerHTML = `
                    <div class="result">
                        <strong>✅ Token đã được giải mã!</strong><span class="status success">SUCCESS</span>
                        <br><br>
                        <strong>Header:</strong>
                        <table>
                            <tr><td>Algorithm</td><td>${header.alg}</td></tr>
                            <tr><td>Type</td><td>${header.typ}</td></tr>
                        </table>
                        <br>
                        <strong>Payload:</strong>
                        <table>
                            <tr><td>User ID</td><td>${payload.userId || 'N/A'}</td></tr>
                            <tr><td>Username</td><td>${payload.sub}</td></tr>
                            <tr><td>Email</td><td>${payload.email || 'N/A'}</td></tr>
                            <tr><td>Role</td><td>${payload.role || 'N/A'}</td></tr>
                            <tr><td>Issued At</td><td>${issuedAt}</td></tr>
                            <tr><td>Expiration</td><td>${expiration}</td></tr>
                        </table>
                        <br>
                        <strong>Raw Payload:</strong><br>
                        ${JSON.stringify(payload, null, 2)}
                    </div>
                `;
            } catch (error) {
                resultDiv.innerHTML = `
                    <div class="result error">
                        <strong>❌ Lỗi giải mã:</strong> ${error.message}
                    </div>
                `;
            }
        }

        // 7. Đăng xuất
        async function logout() {
            const resultDiv = document.getElementById('logoutResult');
            resultDiv.innerHTML = '<div class="result info">Đang đăng xuất...</div>';

            try {
                const response = await fetch('/api/auth/logout', {
                    method: 'POST'
                });

                if (response.ok) {
                    currentToken = null;
                    resultDiv.innerHTML = `
                        <div class="result">
                            <strong>✅ Đăng xuất thành công!</strong><span class="status success">SUCCESS</span>
                            <br><br>
                            JWT Cookie đã được xóa
                        </div>
                    `;

                    // Check lại cookie
                    setTimeout(() => {
                        checkJWTCookie();
                    }, 1000);
                } else {
                    resultDiv.innerHTML = `
                        <div class="result error">
                            <strong>❌ Đăng xuất thất bại!</strong>
                        </div>
                    `;
                }
            } catch (error) {
                resultDiv.innerHTML = `
                    <div class="result error">
                        <strong>❌ Lỗi:</strong> ${error.message}
                    </div>
                `;
            }
        }

        // Auto check JWT cookie khi trang load
        window.onload = function() {
            checkJWTCookie();
        };
    </script>
</body>
</html>

