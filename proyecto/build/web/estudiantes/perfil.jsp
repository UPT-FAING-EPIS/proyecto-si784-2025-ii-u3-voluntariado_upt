<%-- 
    Document   : perfil
    Created on : 18 oct. 2025
    Author     : Mi Equipo
    Description: Perfil del Estudiante - Edición de Datos
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entidad.*"%>

<%
    // Validación de sesión
    if (session.getAttribute("usuario") == null || 
        !"ESTUDIANTE".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    Usuario estudiante = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = estudiante.getNombres() + " " + estudiante.getApellidos();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - Sistema de Voluntariado UPT</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #003D7A;
            --secondary-color: #0066CC;
            --success-color: #28A745;
            --warning-color: #FFC107;
            --danger-color: #DC3545;
            --light-bg: #F8F9FA;
            --white: #FFFFFF;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
            color: #343A40;
        }
        
        .navbar-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 20px rgba(0, 61, 122, 0.15);
        }
        
        .profile-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            padding: 40px;
            margin-top: 30px;
            margin-bottom: 30px;
        }
        
        .profile-header {
            text-align: center;
            padding-bottom: 30px;
            border-bottom: 2px solid var(--light-bg);
            margin-bottom: 40px;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: var(--white);
            font-size: 3rem;
            font-weight: 700;
            box-shadow: 0 8px 25px rgba(0, 61, 122, 0.3);
        }
        
        .profile-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 5px;
        }
        
        .profile-subtitle {
            color: #6c757d;
            font-size: 1rem;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        
        .section-title i {
            margin-right: 10px;
        }
        
        .form-label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 8px;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(0, 61, 122, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            padding: 12px 30px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 61, 122, 0.3);
        }
        
        .btn-outline-secondary {
            border: 2px solid #6c757d;
            color: #6c757d;
            padding: 12px 30px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: white;
        }
        
        .input-group-text {
            background-color: var(--light-bg);
            border-right: none;
        }
        
        .input-group .form-control {
            border-left: none;
        }
        
        .input-group:focus-within .input-group-text {
            border-color: var(--primary-color);
        }
        
        .alert-custom {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
        }
        
        .toggle-password {
            cursor: pointer;
            color: #6c757d;
            transition: color 0.3s ease;
        }
        
        .toggle-password:hover {
            color: var(--primary-color);
        }
        
        .info-badge {
            background-color: rgba(0, 61, 122, 0.1);
            color: var(--primary-color);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
    </style>
</head>

<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand fw-bold" href="menu_estudiante.jsp">
                <i class="fas fa-hands-helping me-2"></i>
                Sistema de Voluntariado - UPT
            </a>
            
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="menu_estudiante.jsp">
                    <i class="fas fa-home me-1"></i>Dashboard
                </a>
                <a class="nav-link" href="campañas.jsp">
                    <i class="fas fa-bullhorn me-1"></i>Campañas
                </a>
                <a class="nav-link" href="certificados.jsp">
                    <i class="fas fa-certificate me-1"></i>Certificados
                </a>
                <div class="dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user me-1"></i><%= nombreCompleto %>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item active" href="perfil.jsp">
                            <i class="fas fa-user-edit me-2"></i>Mi Perfil
                        </a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="../index.jsp">
                            <i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión
                        </a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="profile-container">
                    <!-- Profile Header -->
                    <div class="profile-header">
                        <div class="profile-avatar">
                            <%= estudiante.getNombres().substring(0, 1).toUpperCase() %>
                        </div>
                        <h1 class="profile-title"><%= nombreCompleto %></h1>
                        <p class="profile-subtitle">
                            <i class="fas fa-id-badge me-2"></i>Código: <%= estudiante.getCodigo() %>
                        </p>
                    </div>
                    
                    <!-- Mensaje de éxito/error -->
                    <div id="messageContainer"></div>
                    
                    <!-- Formulario de Perfil -->
                    <form id="profileForm" onsubmit="actualizarPerfil(event)">
                        <!-- Información Personal -->
                        <div class="form-section">
                            <h3 class="section-title">
                                <i class="fas fa-user"></i>
                                Información Personal
                            </h3>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="nombres" class="form-label">
                                        <i class="fas fa-user me-1"></i>Nombres *
                                    </label>
                                    <input type="text" class="form-control" id="nombres" name="nombres" 
                                           value="<%= estudiante.getNombres() %>" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="apellidos" class="form-label">
                                        <i class="fas fa-user me-1"></i>Apellidos *
                                    </label>
                                    <input type="text" class="form-control" id="apellidos" name="apellidos" 
                                           value="<%= estudiante.getApellidos() %>" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="correo" class="form-label">
                                    <i class="fas fa-envelope me-1"></i>Correo Electrónico
                                    <span class="info-badge ms-2">
                                        <i class="fas fa-lock me-1"></i>Solo lectura
                                    </span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-envelope"></i>
                                    </span>
                                    <input type="email" class="form-control" id="correo" 
                                           value="<%= estudiante.getCorreo() %>" disabled>
                                </div>
                                <small class="text-muted">
                                    <i class="fas fa-info-circle me-1"></i>
                                    El correo no puede ser modificado. Contacta al administrador si necesitas cambiarlo.
                                </small>
                            </div>
                            
                            <div class="mb-3">
                                <label for="codigo" class="form-label">
                                    <i class="fas fa-id-badge me-1"></i>Código de Estudiante
                                    <span class="info-badge ms-2">
                                        <i class="fas fa-lock me-1"></i>Solo lectura
                                    </span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-id-badge"></i>
                                    </span>
                                    <input type="text" class="form-control" id="codigo" 
                                           value="<%= estudiante.getCodigo() %>" disabled>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Seguridad -->
                        <div class="form-section">
                            <h3 class="section-title">
                                <i class="fas fa-shield-alt"></i>
                                Seguridad
                            </h3>
                            
                            <div class="alert alert-info alert-custom">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Cambiar Contraseña:</strong> Deja estos campos en blanco si no deseas cambiar tu contraseña.
                            </div>
                            
                            <div class="mb-3">
                                <label for="passwordActual" class="form-label">
                                    <i class="fas fa-lock me-1"></i>Contraseña Actual
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-lock"></i>
                                    </span>
                                    <input type="password" class="form-control" id="passwordActual" 
                                           name="passwordActual" placeholder="Ingresa tu contraseña actual">
                                    <span class="input-group-text toggle-password" onclick="togglePassword('passwordActual')">
                                        <i class="fas fa-eye" id="togglePasswordActualIcon"></i>
                                    </span>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="passwordNueva" class="form-label">
                                    <i class="fas fa-key me-1"></i>Nueva Contraseña
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-key"></i>
                                    </span>
                                    <input type="password" class="form-control" id="passwordNueva" 
                                           name="passwordNueva" placeholder="Ingresa tu nueva contraseña">
                                    <span class="input-group-text toggle-password" onclick="togglePassword('passwordNueva')">
                                        <i class="fas fa-eye" id="togglePasswordNuevaIcon"></i>
                                    </span>
                                </div>
                                <small class="text-muted">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Mínimo 6 caracteres
                                </small>
                            </div>
                            
                            <div class="mb-3">
                                <label for="passwordConfirmar" class="form-label">
                                    <i class="fas fa-check-circle me-1"></i>Confirmar Nueva Contraseña
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-check-circle"></i>
                                    </span>
                                    <input type="password" class="form-control" id="passwordConfirmar" 
                                           name="passwordConfirmar" placeholder="Confirma tu nueva contraseña">
                                    <span class="input-group-text toggle-password" onclick="togglePassword('passwordConfirmar')">
                                        <i class="fas fa-eye" id="togglePasswordConfirmarIcon"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Botones de Acción -->
                        <div class="d-flex justify-content-between">
                            <a href="menu_estudiante.jsp" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Volver
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Guardar Cambios
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Función para mostrar/ocultar contraseña
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById('toggle' + inputId.charAt(0).toUpperCase() + inputId.slice(1) + 'Icon');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        // Función para mostrar mensajes
        function mostrarMensaje(mensaje, tipo) {
            const messageContainer = document.getElementById('messageContainer');
            const alertClass = tipo === 'success' ? 'alert-success' : 'alert-danger';
            const icon = tipo === 'success' ? 'fa-check-circle' : 'fa-exclamation-triangle';
            
            messageContainer.innerHTML = `
                <div class="alert ${alertClass} alert-custom alert-dismissible fade show" role="alert">
                    <i class="fas ${icon} me-2"></i>
                    <strong>${mensaje}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            `;
            
            // Scroll hacia el mensaje
            messageContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
            
            // Auto-cerrar después de 5 segundos
            if (tipo === 'success') {
                setTimeout(() => {
                    const alert = messageContainer.querySelector('.alert');
                    if (alert) {
                        alert.classList.remove('show');
                        setTimeout(() => {
                            messageContainer.innerHTML = '';
                        }, 300);
                    }
                }, 5000);
            }
        }
        
        // Función para actualizar el perfil
        function actualizarPerfil(event) {
            event.preventDefault();
            
            const form = document.getElementById('profileForm');
            const formData = new FormData(form);
            
            // Validaciones
            const nombres = formData.get('nombres').trim();
            const apellidos = formData.get('apellidos').trim();
            const passwordActual = formData.get('passwordActual').trim();
            const passwordNueva = formData.get('passwordNueva').trim();
            const passwordConfirmar = formData.get('passwordConfirmar').trim();
            
            // Validar nombres y apellidos
            if (!nombres || !apellidos) {
                mostrarMensaje('Los nombres y apellidos son obligatorios.', 'error');
                return;
            }
            
            // Si está intentando cambiar la contraseña
            if (passwordActual || passwordNueva || passwordConfirmar) {
                if (!passwordActual) {
                    mostrarMensaje('Debes ingresar tu contraseña actual para cambiarla.', 'error');
                    return;
                }
                
                if (!passwordNueva) {
                    mostrarMensaje('Debes ingresar la nueva contraseña.', 'error');
                    return;
                }
                
                if (passwordNueva.length < 6) {
                    mostrarMensaje('La nueva contraseña debe tener al menos 6 caracteres.', 'error');
                    return;
                }
                
                if (passwordNueva !== passwordConfirmar) {
                    mostrarMensaje('Las contraseñas no coinciden.', 'error');
                    return;
                }
            }
            
            // Mostrar loading
            const submitBtn = form.querySelector('button[type="submit"]');
            const originalBtnText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Guardando...';
            submitBtn.disabled = true;
            
            // Enviar datos al servlet
            const data = new URLSearchParams();
            data.append('action', 'actualizarPerfil');
            data.append('nombres', nombres);
            data.append('apellidos', apellidos);
            data.append('passwordActual', passwordActual);
            data.append('passwordNueva', passwordNueva);
            
            fetch('<%= request.getContextPath() %>/UsuarioServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: data
            })
            .then(response => response.json())
            .then(data => {
                submitBtn.innerHTML = originalBtnText;
                submitBtn.disabled = false;
                
                if (data.success) {
                    mostrarMensaje(data.message, 'success');
                    
                    // Limpiar campos de contraseña
                    document.getElementById('passwordActual').value = '';
                    document.getElementById('passwordNueva').value = '';
                    document.getElementById('passwordConfirmar').value = '';
                    
                    // Recargar después de 2 segundos para actualizar la sesión
                    setTimeout(() => {
                        location.reload();
                    }, 2000);
                } else {
                    mostrarMensaje(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                submitBtn.innerHTML = originalBtnText;
                submitBtn.disabled = false;
                mostrarMensaje('Error de conexión. Por favor, intenta nuevamente.', 'error');
            });
        }
    </script>
</body>
</html>
