<%-- 
    Document   : control_asistencia
    Created on : 15 oct. 2025
    Author     : Sistema UPT
    Description: Control de Asistencia para Coordinadores
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="entidad.*"%>
<%@page import="negocio.*"%>

<%
    // Validación de sesión
    if (session.getAttribute("usuario") == null || 
        !"COORDINADOR".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    Usuario coordinador = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = coordinador.getNombres() + " " + coordinador.getApellidos();
    
    // Obtener campañas del coordinador
    coordinadornegocio negocio = new coordinadornegocio();
    List<Campana> misCampanas = negocio.obtenerCampanasPorCoordinador(coordinador.getIdUsuario());
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Control de Asistencia - Sistema de Voluntariado UPT</title>
    
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
            --danger-color: #DC3545;
            --light-bg: #F8F9FA;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
            min-height: 100vh;
        }
        
        .navbar-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 20px rgba(0, 61, 122, 0.15);
            padding: 1rem 0;
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: white !important;
        }
        
        .user-info {
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
        }
        
        .btn-logout {
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 8px;
            padding: 8px 16px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-logout:hover {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
        }
        
        .container-main {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .page-header {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        
        .page-title {
            color: var(--primary-color);
            font-weight: 700;
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .page-subtitle {
            color: #6c757d;
            font-size: 1.1rem;
        }
        
        .control-card {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 2rem;
            transition: all 0.3s ease;
        }
        
        .control-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }
        
        .control-icon {
            width: 80px;
            height: 80px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            margin-bottom: 1.5rem;
        }
        
        .control-icon.qr {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        }
        
        .control-icon.manual {
            background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 61, 122, 0.3);
            color: white;
        }
        
        .btn-success-custom {
            background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
            border: none;
            border-radius: 10px;
            padding: 12px 24px;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-success-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
            color: white;
        }
        
        .btn-back {
            background: white;
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            background: var(--primary-color);
            color: white;
        }
        
        .feature-list {
            list-style: none;
            padding: 0;
            margin: 1.5rem 0;
        }
        
        .feature-list li {
            padding: 0.75rem 0;
            display: flex;
            align-items: center;
            color: #495057;
        }
        
        .feature-list li i {
            color: var(--success-color);
            margin-right: 1rem;
            font-size: 1.2rem;
        }
        
        .info-box {
            background: #e7f3ff;
            border-left: 4px solid var(--primary-color);
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-top: 2rem;
        }
        
        .info-box h6 {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .info-box p {
            margin: 0;
            color: #495057;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="menu_coordinador.jsp">
                <i class="fas fa-hands-helping me-2"></i>
                Sistema de Voluntariado UPT
            </a>
            
            <div class="d-flex align-items-center">
                <span class="user-info me-3">
                    <i class="fas fa-user-tie me-2"></i>
                    <%= nombreCompleto %>
                </span>
                <a href="../index.jsp" class="btn btn-logout">
                    <i class="fas fa-sign-out-alt me-2"></i>
                    Cerrar Sesión
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container-main">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">
                        <i class="fas fa-qrcode me-2"></i>Control de Asistencia
                    </h1>
                    <p class="page-subtitle">Registra la asistencia de estudiantes a las campañas</p>
                </div>
                <a href="menu_coordinador.jsp" class="btn btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Volver al Panel
                </a>
            </div>
        </div>

        <!-- Control Options -->
        <div class="row">
            <!-- Escaneo QR -->
            <div class="col-md-6">
                <div class="control-card">
                    <div class="text-center">
                        <div class="control-icon qr mx-auto">
                            <i class="fas fa-qrcode"></i>
                        </div>
                        <h3 class="mb-3">Escaneo de Código QR</h3>
                        <p class="text-muted mb-4">
                            Registra asistencia de forma rápida y automática escaneando el código QR de los estudiantes
                        </p>
                    </div>
                    
                    <ul class="feature-list">
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Registro instantáneo de asistencia</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Validación automática del estudiante</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Sincronización en tiempo real</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Control de duplicados automático</span>
                        </li>
                    </ul>
                    
                    <div class="text-center">
                        <a href="escanear_qr.jsp" class="btn btn-primary-custom w-100">
                            <i class="fas fa-qrcode me-2"></i>Iniciar Escaneo QR
                        </a>
                    </div>
                </div>
            </div>

            <!-- Registro Manual -->
            <div class="col-md-6">
                <div class="control-card">
                    <div class="text-center">
                        <div class="control-icon manual mx-auto">
                            <i class="fas fa-keyboard"></i>
                        </div>
                        <h3 class="mb-3">Registro Manual</h3>
                        <p class="text-muted mb-4">
                            Registra asistencia manualmente ingresando el código del estudiante cuando sea necesario
                        </p>
                    </div>
                    
                    <ul class="feature-list">
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Búsqueda por código o nombre</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Alternativa al escaneo QR</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Verificación de datos del estudiante</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>Útil ante problemas técnicos</span>
                        </li>
                    </ul>
                    
                    <div class="text-center">
                        <button class="btn btn-success-custom w-100" onclick="mostrarRegistroManual()">
                            <i class="fas fa-keyboard me-2"></i>Abrir Registro Manual
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Información adicional -->
        <div class="info-box">
            <h6><i class="fas fa-info-circle me-2"></i>Información Importante</h6>
            <p>
                El control de asistencia permite registrar la participación de los estudiantes en las campañas de voluntariado. 
                Puedes utilizar el escaneo QR para un registro rápido o el registro manual como alternativa. 
                Todos los registros quedan almacenados en el sistema y se utilizan para generar certificados y reportes.
            </p>
        </div>

        <!-- Campañas Activas -->
        <% if (misCampanas != null && !misCampanas.isEmpty()) { %>
            <div class="mt-4">
                <h4 class="mb-3">
                    <i class="fas fa-bullhorn me-2"></i>Tus Campañas Activas
                </h4>
                <div class="row">
                    <% for (Campana campana : misCampanas) { %>
                        <% if ("PUBLICADA".equals(campana.getEstado())) { %>
                            <div class="col-md-4 mb-3">
                                <div class="card">
                                    <div class="card-body">
                                        <h6 class="card-title text-primary"><%= campana.getTitulo() %></h6>
                                        <p class="card-text small text-muted">
                                            <i class="fas fa-calendar me-1"></i>
                                            <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(campana.getFecha()) %>
                                        </p>
                                        <p class="card-text small">
                                            <i class="fas fa-users me-1"></i>
                                            <%= campana.getCuposOcupados() %> / <%= campana.getCuposTotal() %> inscritos
                                        </p>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
        <% } %>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function mostrarRegistroManual() {
            // Por ahora redirige al escaneo QR, pero puedes crear una página específica
            alert('Función de registro manual en desarrollo.\nPor ahora utiliza el escaneo QR.');
            // window.location.href = 'registro_manual.jsp';
        }
    </script>
</body>
</html>
