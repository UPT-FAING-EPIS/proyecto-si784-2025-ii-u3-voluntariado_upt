<%@page import="entidad.Usuario"%>
<%@page import="negocio.UsuarioNegocio"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String accion = request.getParameter("accion");
    String mensaje = "";
    String tipoMensaje = ""; // success, error, warning
    
    // PROCESO DE LOGIN
    if ("login".equals(accion)) {
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        
        if (correo != null && !correo.isEmpty() && contrasena != null && !contrasena.isEmpty()) {
            UsuarioNegocio negocio = new UsuarioNegocio();
            Usuario usuario = negocio.validarLogin(correo, contrasena);
            
            if (usuario != null) {
                // Login exitoso - Guardar en sesión
                session.setAttribute("usuario", usuario);
                session.setAttribute("idUsuario", usuario.getIdUsuario());
                session.setAttribute("nombreCompleto", usuario.getNombreCompleto());
                session.setAttribute("rol", usuario.getRol());
                
                // Redirigir según el rol
                if ("ESTUDIANTE".equals(usuario.getRol())) {
                    response.sendRedirect("estudiantes/menu_estudiante.jsp");
                    return;
                } else if ("COORDINADOR".equals(usuario.getRol())) {
                    response.sendRedirect("coordinador/menu_coordinador.jsp");
                    return;
                } else if ("ADMINISTRADOR".equals(usuario.getRol())) {
                    response.sendRedirect("administrador/menu_admin.jsp");
                    return;
                }
            } else {
                mensaje = "Correo o contraseña incorrectos";
                tipoMensaje = "error";
            }
        } else {
            mensaje = "Por favor complete todos los campos";
            tipoMensaje = "warning";
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Voluntariado UPT - Iniciar Sesión</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --upt-azul: #003D7A;
            --upt-azul-claro: #0066CC;
            --upt-dorado: #FFD700;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #003D7A 0%, #0066CC 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        
        /* Decorative circles */
        body::before,
        body::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.05);
        }
        
        body::before {
            width: 600px;
            height: 600px;
            top: -300px;
            right: -200px;
        }
        
        body::after {
            width: 400px;
            height: 400px;
            bottom: -200px;
            left: -100px;
        }
        
        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 1000px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            overflow: hidden;
            position: relative;
            z-index: 1;
        }
        
        .login-left {
            background: linear-gradient(135deg, var(--upt-azul) 0%, var(--upt-azul-claro) 100%);
            padding: 60px 40px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .login-left::before {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
            top: -100px;
            left: -100px;
        }
        
        .logo-container {
            margin-bottom: 30px;
            position: relative;
            z-index: 1;
        }
        
        .logo-container img {
            width: 150px;
            height: auto;
            background: white;
            padding: 15px;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        }
        
        .login-left h1 {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 15px;
            letter-spacing: -1px;
        }
        
        .login-left h2 {
            font-size: 20px;
            font-weight: 300;
            margin-bottom: 10px;
            opacity: 0.95;
        }
        
        .login-left p {
            font-size: 15px;
            opacity: 0.85;
            line-height: 1.6;
            max-width: 350px;
        }
        
        .login-left .features {
            margin-top: 40px;
            text-align: left;
        }
        
        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            font-size: 14px;
        }
        
        .feature-item i {
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 18px;
        }
        
        .login-right {
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .login-header {
            margin-bottom: 40px;
        }
        
        .login-header h3 {
            color: var(--upt-azul);
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .login-header p {
            color: #666;
            font-size: 15px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--upt-azul);
            box-shadow: 0 0 0 4px rgba(0, 61, 122, 0.1);
        }
        
        .input-icon {
            position: relative;
        }
        
        .input-icon i {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 18px;
        }
        
        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, var(--upt-azul) 0%, var(--upt-azul-claro) 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 61, 122, 0.3);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        .alert {
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 25px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert i {
            font-size: 18px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .divider {
            text-align: center;
            margin: 25px 0;
            position: relative;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e0e0e0;
        }
        
        .divider span {
            background: white;
            padding: 0 15px;
            color: #999;
            font-size: 13px;
            position: relative;
        }
        
        .help-text {
            text-align: center;
            margin-top: 25px;
            color: #666;
            font-size: 13px;
        }
        
        .help-text a {
            color: var(--upt-azul);
            text-decoration: none;
            font-weight: 600;
        }
        
        .help-text a:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 992px) {
            .login-container {
                grid-template-columns: 1fr;
                max-width: 500px;
            }
            
            .login-left {
                padding: 40px 30px;
            }
            
            .login-left h1 {
                font-size: 24px;
            }
            
            .login-left h2 {
                font-size: 18px;
            }
            
            .login-left .features {
                display: none;
            }
            
            .logo-container img {
                width: 120px;
            }
            
            .login-right {
                padding: 40px 30px;
            }
        }
        
        @media (max-width: 576px) {
            body {
                padding: 10px;
            }
            
            .login-container {
                border-radius: 15px;
            }
            
            .login-left {
                padding: 30px 20px;
            }
            
            .login-left h1 {
                font-size: 20px;
            }
            
            .login-left h2 {
                font-size: 16px;
            }
            
            .logo-container img {
                width: 100px;
                padding: 10px;
            }
            
            .login-right {
                padding: 30px 20px;
            }
            
            .login-header h3 {
                font-size: 24px;
            }
            
            .form-control {
                padding: 12px 15px;
                font-size: 14px;
            }
            
            .btn-login {
                padding: 14px;
                font-size: 15px;
            }
        }
        
        .password-toggle {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            font-size: 18px;
            padding: 0;
        }
        
        .password-toggle:hover {
            color: var(--upt-azul);
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Left Side - Branding -->
        <div class="login-left">
            <div class="logo-container">
                <img src="<%= request.getContextPath() %>/img/upt.jpeg" alt="UPT Logo">
                <h1>UNIVERSIDAD PRIVADA DE TACNA</h1>
                <h2>Sistema de Voluntariado</h2>
                <p>Gestión integral de campañas de voluntariado universitario</p>
            </div>
            
            <div class="features">
                <div class="feature-item">
                    <i class="fas fa-bullhorn"></i>
                    <span>Campañas de voluntariado organizadas</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-users"></i>
                    <span>Gestión de participantes</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-certificate"></i>
                    <span>Certificados digitales verificables</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-qrcode"></i>
                    <span>Control de asistencia con QR</span>
                </div>
            </div>
        </div>
        
        <!-- Right Side - Login Form -->
        <div class="login-right">
            <div class="login-header">
                <h3>Iniciar Sesión</h3>
                <p>Ingresa tus credenciales para acceder al sistema</p>
            </div>
            
            <% if (!mensaje.isEmpty()) { %>
                <div class="alert alert-<%= tipoMensaje.equals("error") ? "danger" : tipoMensaje %>">
                    <i class="fas fa-<%= tipoMensaje.equals("error") ? "exclamation-circle" : tipoMensaje.equals("success") ? "check-circle" : "exclamation-triangle" %>"></i>
                    <span><%= mensaje %></span>
                </div>
            <% } %>
            
            <form method="post" action="index.jsp" id="loginForm">
                <input type="hidden" name="accion" value="login">
                
                <div class="form-group">
                    <label class="form-label" for="correo">
                        <i class="fas fa-envelope me-2"></i>Correo Electrónico
                    </label>
                    <div class="input-icon">
                        <input type="email" 
                               class="form-control" 
                               id="correo" 
                               name="correo" 
                               required 
                               placeholder="ejemplo@upt.pe"
                               autocomplete="email">
                        <i class="fas fa-user"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="contrasena">
                        <i class="fas fa-lock me-2"></i>Contraseña
                    </label>
                    <div class="input-icon">
                        <input type="password" 
                               class="form-control" 
                               id="contrasena" 
                               name="contrasena" 
                               required 
                               placeholder="••••••••"
                               autocomplete="current-password">
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye" id="toggleIcon"></i>
                        </button>
                    </div>
                </div>
                
                <button type="submit" class="btn-login">
                    <i class="fas fa-sign-in-alt me-2"></i>Iniciar Sesión
                </button>
            </form>
            
            <div class="divider">
                <span>Sistema exclusivo para usuarios autorizados</span>
            </div>
            
            <div class="help-text">
                ¿Problemas para acceder? <a href="mailto:soporte@upt.pe">Contactar soporte</a>
            </div>
        </div>
    </div>
    
    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('contrasena');
            const toggleIcon = document.getElementById('toggleIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
        
        // Auto focus en el primer input
        window.addEventListener('load', function() {
            document.getElementById('correo').focus();
        });
        
        // Enter key navigation
        document.getElementById('correo').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('contrasena').focus();
            }
        });
    </script>
</body>
</html>