
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Login - HadesNetwork</title>
    <meta name="description" content="Masuk ke akun HadesNetwork Anda untuk mengakses dasbor, melihat riwayat pesanan, dan mengelola layanan Anda." />
    <meta name="robots" content="noindex, nofollow" />

    <link rel="canonical" href="https://hadesnetwork.online/login.html" />
    <meta name="theme-color" content="#7f3cff">
    <link rel="icon" href="/Favicon_Transparent.png" type="image/png" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet" />

    <style>
        /* Menggunakan variabel warna dan font dari desain utama */
        :root {
            --primary: #5271ff;
            --accent: #8c52ff;
            --gradient-main: linear-gradient(135deg, #16172D 0%, #1F1F3D 100%);
            --gradient-btn: linear-gradient(90deg, var(--accent) 0%, var(--primary) 100%);
            --gradient-btn-hover: linear-gradient(90deg, var(--primary) 0%, var(--accent) 100%);
            
            --surface: #1A1B32;
            --card-border: rgba(255, 255, 255, 0.1);

            --text-light: #EAEBF2;
            --text-muted: #A0A3C2;
            --radius-md: 12px;
            --radius-lg: 18px;
            --transition: 0.4s cubic-bezier(.4, 0, .2, 1);
            
            --success: #28a745;
            --danger: #dc3545;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        html { height: 100%; }
        body {
            background: var(--gradient-main);
            color: var(--text-light);
            font-family: 'Inter', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 1.5rem;
            position: relative;
            overflow: hidden;
        }

        /* Latar belakang dinamis */
        body::before {
            content: "";
            position: absolute;
            top: 50%; left: 50%;
            width: 150vmax; height: 150vmax;
            background: radial-gradient(circle at center, rgba(140, 82, 255, 0.15), transparent 40%);
            transform: translate(-50%, -50%);
            animation: pulse-bg 10s infinite ease-in-out;
            z-index: 0;
        }
        @keyframes pulse-bg {
            0% { transform: translate(-50%, -50%) scale(0.8); opacity: 0.5; }
            50% { transform: translate(-50%, -50%) scale(1.2); opacity: 1; }
            100% { transform: translate(-50%, -50%) scale(0.8); opacity: 0.5; }
        }

        .auth-container {
            background: var(--surface);
            padding: 2.5rem;
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 450px;
            border: 1px solid var(--card-border);
            position: relative;
            z-index: 1;
            backdrop-filter: blur(10px);
        }

        .auth-header { text-align: center; margin-bottom: 2.5rem; }
        .auth-header .logo { height: 50px; margin-bottom: 1.5rem; }
        .auth-header h2 { font-size: 2rem; font-weight: 700; color: var(--text-light); margin-bottom: 0.5rem; }
        .auth-header p { color: var(--text-muted); }
        
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.6rem; font-weight: 500; color: var(--text-muted); }
        .form-group input {
            width: 100%;
            padding: 0.9rem 1rem;
            border-radius: var(--radius-md);
            border: 1px solid var(--card-border);
            background-color: rgba(0,0,0,0.2);
            color: var(--text-light);
            font-size: 1rem;
            outline: none;
            transition: all var(--transition);
        }
        .form-group input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(140, 82, 255, 0.2);
        }
        
        .form-options { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; font-size: 0.9rem; }
        .remember-me { display: flex; align-items: center; gap: 0.5rem; }
        .remember-me label { margin: 0; color: var(--text-muted); cursor: pointer; font-weight: 400; }
        .remember-me input[type="checkbox"] { width: 1em; height: 1em; accent-color: var(--accent); }
        .form-options a { color: var(--accent); text-decoration: none; font-weight: 500; }
        .form-options a:hover { text-decoration: underline; }

        .btn-submit {
            width: 100%;
            padding: 0.9rem;
            background: var(--gradient-btn);
            color: #fff;
            border: none;
            border-radius: var(--radius-md);
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all var(--transition);
            box-shadow: 0 4px 15px rgba(140, 82, 255, 0.2);
        }
        .btn-submit:hover:not(:disabled) {
            background: var(--gradient-btn-hover);
            box-shadow: 0 8px 25px rgba(140, 82, 255, 0.3);
            transform: translateY(-3px);
        }
        .btn-submit:disabled { background: #555; cursor: not-allowed; box-shadow: none; transform: none; opacity: 0.7; }
        
        .auth-footer { text-align: center; margin-top: 2rem; color: var(--text-muted); }
        .auth-footer a { color: var(--accent); text-decoration: none; font-weight: 600; }
        
        .message-box { padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; text-align: center; font-weight: 500; display: none; }
        .message-box.success { background-color: rgba(40, 167, 69, 0.15); color: var(--success); }
        .message-box.error { background-color: rgba(220, 53, 69, 0.15); color: var(--danger); }
    </style>
</head>
<body>

    <div class="auth-container">
        <div class="auth-header">
            <a href="/index.html"><img src="https://media.hadesnetwork.online/Favicon_Transparent-removebg-preview.png" alt="HadesNetwork Logo" class="logo"></a>
            <h2>Selamat Datang Kembali</h2>
            <p>Masuk untuk melanjutkan ke dasbor Anda.</p>
        </div>

        <div id="messageBox" class="message-box"></div>

        <form id="loginForm">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <div class="form-options">
                <div class="remember-me">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <label for="rememberMe">Ingat Saya</label>
                </div>
                <a href="/forgot-password.html">Lupa Password?</a>
            </div>

            <button type="submit" class="btn-submit" id="submitButton">Login</button>
        </form>

        <div class="auth-footer">
            <p>Belum punya akun? <a href="/register.html">Daftar di sini</a></p>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (localStorage.getItem('hadesnetwork_token')) {
                window.location.href = '/order.html';
                return;
            }

            const loginForm = document.getElementById('loginForm');
            const messageBox = document.getElementById('messageBox');
            const submitButton = document.getElementById('submitButton');

            loginForm.addEventListener('submit', async function(event) {
                event.preventDefault();
                
                submitButton.disabled = true;
                submitButton.textContent = 'Memproses...';
                messageBox.style.display = 'none';

                const formData = new FormData(loginForm);
                const data = Object.fromEntries(formData.entries());
                data.rememberMe = document.getElementById('rememberMe').checked;

                // Simulasi API untuk pengujian lokal
                // Ganti ini dengan logika fetch asli Anda saat production
                /*if (data.email && data.password) {
                    // Anggap login berhasil untuk demonstrasi
                    const mockResult = {
                        token: 'mock_jwt_token_string_for_testing',
                        user: { id: 1, username: 'DemoUser', email: data.email }
                    };

                    localStorage.setItem('hadesnetwork_token', mockResult.token);
                    localStorage.setItem('hadesnetwork_user', JSON.stringify(mockResult.user));
                    
                    showMessage('success', 'Login berhasil! Anda akan diarahkan...');
                    setTimeout(() => {
                        window.location.href = '/order.html';
                    }, 1500);

                } else {
                    // Anggap login gagal jika input kosong
                    showMessage('error', 'Email dan password tidak boleh kosong.');
                    submitButton.disabled = false;
                    submitButton.textContent = 'Login';
                }*/

                
                // KODE ASLI UNTUK KONEKSI KE API (dinonaktifkan untuk demo)
                try {
                    const response = await fetch('/api/auth/login', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(data),
                    });
                    const result = await response.json();
                    if (response.ok) {
                        localStorage.setItem('hadesnetwork_token', result.token);
                        localStorage.setItem('hadesnetwork_user', JSON.stringify(result.user));
                        showMessage('success', 'Login berhasil! Anda akan diarahkan...');
                        setTimeout(() => { window.location.href = '/order.html'; }, 1500);
                    } else {
                        throw new Error(result.message || 'Terjadi kesalahan.');
                    }
                } catch (error) {
                    showMessage('error', error.message);
                    submitButton.disabled = false;
                    submitButton.textContent = 'Login';
                }
                
            });

            function showMessage(type, text) {
                messageBox.className = `message-box ${type}`;
                messageBox.textContent = text;
                messageBox.style.display = 'block';
            }
        });
    </script>
</body>
</html>