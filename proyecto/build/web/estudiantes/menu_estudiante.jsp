<%-- 
    Document   : menu_estudiante
    Created on : 29 set. 2025, 10:14:32 p. m.
    Author     : Mi Equipo
    Description: Sistema de Voluntariado UPT - Panel del Estudiante
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="entidad.*"%>
<%@page import="negocio.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    // Validación de sesión - Verificar que el usuario esté logueado y sea estudiante
    if (session.getAttribute("usuario") == null || 
        !"ESTUDIANTE".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Obtener datos del estudiante desde la sesión
    Usuario estudiante = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = estudiante.getNombres() + " " + estudiante.getApellidos();
    String codigoEstudiante = estudiante.getCodigo();
    
    // Inicializar negocio del estudiante
    estudiantenegocio estudianteNeg = new estudiantenegocio();
    
    // Obtener estadísticas del estudiante
    estudianteentidad estadisticas = estudianteNeg.obtenerEstadisticasEstudiante(estudiante.getIdUsuario());
    
    // Obtener campañas disponibles
    List<Campana> campanasDisponibles = estudianteNeg.obtenerCampanasDisponibles();
    
    // Obtener inscripciones del estudiante
    List<Campana> misInscripciones = estudianteNeg.obtenerInscripcionesEstudiante(estudiante.getIdUsuario());
    
    // Contar campañas disponibles
    int totalCampanasDisponibles = estudianteNeg.contarCampanasDisponibles();
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Sistema de Voluntariado - EPIS | UPT</title>
    
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
            --info-color: #17A2B8;
            --light-bg: #F8F9FA;
            --white: #FFFFFF;
            --gray-100: #F8F9FA;
            --gray-200: #E9ECEF;
            --gray-300: #DEE2E6;
            --gray-600: #6C757D;
            --gray-800: #343A40;
            --gray-900: #212529;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
            color: var(--gray-800);
            line-height: 1.6;
        }
        
        /* Header Styles */
        .navbar-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 2px 20px rgba(0, 61, 122, 0.15);
            padding: 1rem 0;
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--white) !important;
        }
        
        .navbar-brand img {
            height: 40px;
            margin-right: 10px;
        }
        
        .navbar-nav .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
            margin: 0 10px;
            transition: all 0.3s ease;
            border-radius: 8px;
            padding: 8px 16px !important;
        }
        
        .navbar-nav .nav-link:hover {
            color: var(--white) !important;
            background-color: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
        }
        
        .dropdown-menu {
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            padding: 10px 0;
        }
        
        .dropdown-item {
            padding: 10px 20px;
            transition: all 0.3s ease;
        }
        
        .dropdown-item:hover {
            background-color: var(--light-bg);
            color: var(--primary-color);
        }
        
        /* Sidebar Styles */
        .sidebar {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            padding: 30px;
            margin-bottom: 30px;
            position: sticky;
            top: 20px;
        }
        
        .profile-section {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 2px solid var(--gray-200);
        }
        
        .profile-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            color: var(--white);
            font-size: 2rem;
            font-weight: 700;
            box-shadow: 0 8px 25px rgba(0, 61, 122, 0.3);
        }
        
        .profile-name {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 5px;
        }
        
        .profile-code {
            color: var(--gray-600);
            font-size: 0.9rem;
        }
        
        .progress-section {
            margin-top: 25px;
        }
        
        .progress-title {
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 15px;
            font-size: 1rem;
        }
        
        .hours-display {
            text-align: center;
            margin-bottom: 15px;
        }
        
        .hours-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            line-height: 1;
        }
        
        .hours-total {
            color: var(--gray-600);
            font-size: 0.9rem;
            margin-top: 5px;
        }
        
        .progress-custom {
            height: 8px;
            background-color: var(--gray-200);
            border-radius: 10px;
            overflow: hidden;
        }
        
        .progress-bar-custom {
            background: linear-gradient(90deg, var(--success-color), #20c997);
            border-radius: 10px;
            transition: width 0.6s ease;
        }
        
        /* Main Content Styles */
        .main-content {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            padding: 40px;
            margin-bottom: 30px;
        }
        
        .page-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 8px;
        }
        
        .page-subtitle {
            color: var(--gray-600);
            font-size: 1.1rem;
            margin-bottom: 0;
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--gray-800);
            display: flex;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .section-title i {
            color: var(--primary-color);
            margin-right: 10px;
        }
        
        /* Metric Cards */
        .metric-card {
            background: var(--white);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border: 1px solid var(--gray-200);
            height: 100%;
        }
        
        .metric-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }
        
        .metric-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            color: var(--white);
            font-size: 1.5rem;
        }
        
        .metric-number {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 8px;
        }
        
        .metric-label {
            color: var(--gray-600);
            font-size: 0.95rem;
            font-weight: 500;
        }
        
        /* Campaign Cards */
        .campaign-card {
            background: var(--white);
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border: 1px solid var(--gray-200);
            overflow: hidden;
            height: 100%;
        }
        
        .campaign-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }
        
        .campaign-header {
            padding: 25px 25px 20px;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .campaign-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 10px;
            line-height: 1.4;
        }
        
        .campaign-meta {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .campaign-meta span {
            display: flex;
            align-items: center;
            color: var(--gray-600);
            font-size: 0.9rem;
        }
        
        .campaign-meta i {
            margin-right: 5px;
            color: var(--primary-color);
        }
        
        .campaign-body {
            padding: 20px 25px;
        }
        
        .campaign-description {
            color: var(--gray-700);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 20px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .campaign-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .campaign-cupos {
            font-size: 0.9rem;
            color: var(--gray-600);
        }
        
        .cupos-disponibles {
            font-weight: 600;
            color: var(--success-color);
        }
        
        .campaign-progress {
            height: 6px;
            background-color: var(--gray-200);
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 20px;
        }
        
        .campaign-progress-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--success-color), #20c997);
            border-radius: 10px;
            transition: width 0.6s ease;
        }
        
        .campaign-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .campaign-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .status-disponible {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .status-lleno {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }
        
        .btn-inscribirse {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: var(--white);
            padding: 8px 20px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-inscribirse:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 61, 122, 0.3);
            color: var(--white);
        }
        
        .btn-inscribirse:disabled {
            background: var(--gray-400);
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        /* Table Styles */
        .table-custom {
            background: var(--white);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }
        
        .table-custom table {
            margin-bottom: 0;
        }
        
        .table-custom thead th {
            background: var(--gray-100);
            border: none;
            font-weight: 600;
            color: var(--gray-800);
            padding: 20px;
            font-size: 0.95rem;
        }
        
        .table-custom tbody td {
            border: none;
            padding: 20px;
            vertical-align: middle;
            border-bottom: 1px solid var(--gray-200);
        }
        
        .table-custom tbody tr:last-child td {
            border-bottom: none;
        }
        
        .table-custom tbody tr:hover {
            background-color: var(--gray-100);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                padding: 25px;
            }
            
            .sidebar {
                padding: 20px;
                margin-bottom: 20px;
            }
            
            .page-title {
                font-size: 1.8rem;
            }
            
            .metric-card {
                padding: 20px;
                margin-bottom: 20px;
            }
            
            .campaign-card {
                margin-bottom: 20px;
            }
        }
        
        /* Scroll to top button */
        .scroll-to-top {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: var(--white);
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            font-size: 1.2rem;
            box-shadow: 0 5px 20px rgba(0, 61, 122, 0.3);
            transition: all 0.3s ease;
            opacity: 0;
            visibility: hidden;
        }
        
        .scroll-to-top.show {
            opacity: 1;
            visibility: visible;
        }
        
        .scroll-to-top:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 61, 122, 0.4);
        }
        
        /* Empty state styles */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--gray-600);
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: var(--gray-400);
        }
        
        .empty-state h5 {
            margin-bottom: 10px;
            color: var(--gray-700);
        }
        
        .btn-group .btn {
            margin-right: 5px;
        }
        
        .btn-group .btn:last-child {
            margin-right: 0;
        }
        
        #qrModal .modal-body {
            padding: 2rem;
        }
        
        #qrModal img {
            border: 2px solid #dee2e6;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .spinner-border {
            width: 3rem;
            height: 3rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-hands-helping me-2"></i>
                Sistema de Voluntariado UPT
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#dashboard">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="campañas.jsp">
                            <i class="fas fa-bullhorn me-1"></i>Campañas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="inscripciones.jsp">
                            <i class="fas fa-list-check me-1"></i>Mis Inscripciones
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="certificados.jsp">
                            <i class="fas fa-certificate me-1"></i>Certificados
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i><%= nombreCompleto %>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="perfil.jsp"><i class="fas fa-user-edit me-2"></i>Mi Perfil</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="../index.jsp"><i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="container mt-4">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-3">
                <div class="sidebar">
                    <!-- Profile Section -->
                    <div class="profile-section">
                        <div class="profile-avatar">
                            <%= nombreCompleto.substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="profile-name"><%= nombreCompleto %></div>
                        <div class="profile-code">Código: <%= codigoEstudiante %></div>
                    </div>
                    
                    <!-- Progress Section -->
                    <div class="progress-section">
                        <div class="progress-title">Progreso de Horas</div>
                        <div class="hours-display">
                            <div class="hours-number"><%= estadisticas.getHorasAcumuladas() %></div>
                            <div class="hours-total">horas acumuladas</div>
                        </div>
                        <div class="progress progress-custom">
                            <%
                                int horasObjetivo = 100; // Objetivo de horas (puedes hacer esto configurable)
                                double porcentajeProgreso = estadisticas.getHorasAcumuladas() > 0 ? 
                                    Math.min((double)estadisticas.getHorasAcumuladas() / horasObjetivo * 100, 100) : 0;
                            %>
                            <div class="progress-bar progress-bar-custom" style="width: <%= porcentajeProgreso %>%"></div>
                        </div>
                        <div class="text-center mt-2">
                            <small class="text-muted">
                                <%= Math.max(0, horasObjetivo - estadisticas.getHorasAcumuladas()) %> horas restantes
                            </small>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Contenido Principal -->
            <div class="col-lg-9">
                <div class="main-content">
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h1 class="page-title">Dashboard del Estudiante</h1>
                            <p class="page-subtitle">Bienvenido al Sistema de Voluntariado Universitario</p>
                        </div>
                        <div class="text-end">
                            <small class="text-muted">Última conexión: <%= new java.util.Date() %></small>
                        </div>
                    </div>
                    
                    <!-- Métricas Dashboard -->
                    <section id="dashboard" class="mb-5">
                        <div class="row">
                            <div class="col-lg-3 col-md-6 mb-4">
                                <div class="metric-card">
                                    <div class="metric-icon" style="background: linear-gradient(135deg, var(--success-color), #20c997);">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <div class="metric-number"><%= estadisticas.getHorasAcumuladas() %></div>
                                    <div class="metric-label">Horas Acumuladas</div>
                                </div>
                            </div>
                            
                            <div class="col-lg-3 col-md-6 mb-4">
                                <div class="metric-card">
                                    <div class="metric-icon" style="background: linear-gradient(135deg, var(--info-color), #20c997);">
                                        <i class="fas fa-bullhorn"></i>
                                    </div>
                                    <div class="metric-number"><%= totalCampanasDisponibles %></div>
                                    <div class="metric-label">Campañas Disponibles</div>
                                </div>
                            </div>
                            
                            <div class="col-lg-3 col-md-6 mb-4">
                                <div class="metric-card">
                                    <div class="metric-icon" style="background: linear-gradient(135deg, var(--warning-color), #ffc107);">
                                        <i class="fas fa-certificate"></i>
                                    </div>
                                    <div class="metric-number"><%= estadisticas.getCertificadosObtenidos() %></div>
                                    <div class="metric-label">Certificados</div>
                                </div>
                            </div>
                            
                            <div class="col-lg-3 col-md-6 mb-4">
                                <div class="metric-card">
                                    <div class="metric-icon" style="background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));">
                                        <i class="fas fa-trophy"></i>
                                    </div>
                                    <div class="metric-number">#<%= estadisticas.getRanking() %></div>
                                    <div class="metric-label">Ranking</div>
                                </div>
                            </div>
                        </div>
                    </section>
                    
                    <!-- Campañas Disponibles Section -->
                    <section id="campanas" class="mb-5">
                        <h3 class="section-title mb-4">
                            <i class="fas fa-bullhorn me-2"></i>Campañas Disponibles
                        </h3>
                        
                        <!-- Filtros -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar campañas..." id="searchCampanas">
                                    <button class="btn btn-outline-secondary" type="button">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Grid de Campañas -->
                        <div class="row" id="campanasGrid">
                            <% if (campanasDisponibles != null && !campanasDisponibles.isEmpty()) { %>
                                <% for (Campana campana : campanasDisponibles) { %>
                                    <%
                                        boolean yaInscrito = estudianteNeg.estaInscrito(estudiante.getIdUsuario(), campana.getIdCampana());
                                        double porcentajeOcupacion = campana.getPorcentajeOcupacion();
                                        boolean tieneCupos = campana.tieneDisponibilidad();
                                    %>
                                    <div class="col-lg-6 col-md-12 mb-4">
                                        <div class="campaign-card">
                                            <div class="campaign-header">
                                                <h5 class="campaign-title"><%= campana.getTitulo() %></h5>
                                                <div class="campaign-meta">
                                                    <span>
                                                        <i class="fas fa-calendar-alt"></i>
                                                        <%= sdf.format(campana.getFecha()) %>
                                                    </span>
                                                    <span>
                                                        <i class="fas fa-clock"></i>
                                                        <%= sdfHora.format(campana.getHoraInicio()) %> - <%= sdfHora.format(campana.getHoraFin()) %>
                                                    </span>
                                                    <span>
                                                        <i class="fas fa-map-marker-alt"></i>
                                                        <%= campana.getLugar() %>
                                                    </span>
                                                </div>
                                            </div>
                                            
                                            <div class="campaign-body">
                                                <p class="campaign-description">
                                                    <%= campana.getDescripcion() %>
                                                </p>
                                                
                                                <div class="campaign-stats">
                                                    <div class="campaign-cupos">
                                                        <span class="cupos-disponibles"><%= campana.getCuposDisponibles() %></span>
                                                        de <%= campana.getCuposTotal() %> cupos disponibles
                                                    </div>
                                                </div>
                                                
                                                <div class="campaign-progress">
                                                    <div class="campaign-progress-bar" style="width: <%= porcentajeOcupacion %>%"></div>
                                                </div>
                                                
                                                <div class="campaign-footer">
                                                    <span class="campaign-status <%= tieneCupos ? "status-disponible" : "status-lleno" %>">
                                                        <i class="fas fa-<%= tieneCupos ? "check-circle" : "times-circle" %>"></i>
                                                        <%= tieneCupos ? "Disponible" : "Lleno" %>
                                                    </span>
                                                    
                                                    <% if (yaInscrito) { %>
                                                        <button class="btn btn-success btn-sm" disabled>
                                                            <i class="fas fa-check me-1"></i>Ya Inscrito
                                                        </button>
                                                    <% } else if (tieneCupos) { %>
                                                        <button class="btn btn-inscribirse btn-sm" onclick="inscribirseCampana(<%= campana.getIdCampana() %>)">
                                                            <i class="fas fa-plus me-1"></i>Inscribirse
                                                        </button>
                                                    <% } else { %>
                                                        <button class="btn btn-inscribirse btn-sm" disabled>
                                                            <i class="fas fa-times me-1"></i>Sin Cupos
                                                        </button>
                                                    <% } %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            <% } else { %>
                                <div class="col-12">
                                    <div class="empty-state">
                                        <i class="fas fa-bullhorn"></i>
                                        <h5>No hay campañas disponibles</h5>
                                        <p>Las campañas aparecerán aquí cuando estén disponibles.</p>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </section>
                    
                    <!-- Mis Inscripciones Section -->
                    <section id="inscripciones" class="mb-5">
                        <h3 class="section-title mb-4">
                            <i class="fas fa-list-check me-2"></i>Mis Inscripciones
                        </h3>
                        
                        <div class="table-custom">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Campaña</th>
                                        <th>Fecha</th>
                                        <th>Estado</th>
                                        <th>Horas</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (misInscripciones != null && !misInscripciones.isEmpty()) { %>
                                        <% for (Campana inscripcion : misInscripciones) { %>
                                            <%
                                                long horasDuracion = (inscripcion.getHoraFin().getTime() - inscripcion.getHoraInicio().getTime()) / (1000 * 60 * 60);
                                            %>
                                            <tr>
                                                <td>
                                                    <strong><%= inscripcion.getTitulo() %></strong><br>
                                                    <small class="text-muted"><%= inscripcion.getLugar() %></small>
                                                </td>
                                                <td>
                                                    <%= sdf.format(inscripcion.getFecha()) %><br>
                                                    <small class="text-muted">
                                                        <%= sdfHora.format(inscripcion.getHoraInicio()) %> - <%= sdfHora.format(inscripcion.getHoraFin()) %>
                                                    </small>
                                                </td>
                                                <td>
                                                    <span class="badge bg-<%= inscripcion.getEstado().equals("PUBLICADA") ? "success" : "secondary" %>">
                                                        <%= inscripcion.getEstado() %>
                                                    </span>
                                                </td>
                                                <td><%= horasDuracion %> horas</td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <button class="btn btn-outline-primary btn-sm" onclick="verDetalleCampana(<%= inscripcion.getIdCampana() %>)">
                                                            <i class="fas fa-eye"></i> Ver
                                                        </button>
                                                        <button class="btn btn-outline-success btn-sm" onclick="generarQR(<%= inscripcion.getIdCampana() %>, <%= estudiante.getIdUsuario() %>)">
                                                            <i class="fas fa-qrcode"></i> QR
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    <% } else { %>
                                        <tr>
                                            <td colspan="5" class="text-center py-4">
                                                <i class="fas fa-list-check fa-2x text-muted mb-2"></i><br>
                                                <span class="text-muted">No tienes inscripciones activas</span>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </section>
                    
                    <!-- Certificados Section -->
                    <section id="certificados" class="mb-5">
                        <h3 class="section-title mb-4">
                            <i class="fas fa-certificate me-2"></i>Mis Certificados
                        </h3>
                        
                        <div class="row">
                            <!-- Los certificados se cargarán dinámicamente desde la base de datos -->
                            <div class="col-12">
                                <div class="empty-state">
                                    <i class="fas fa-certificate"></i>
                                    <h5>No tienes certificados aún</h5>
                                    <p>Los certificados aparecerán aquí cuando completes las campañas.</p>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="text-center py-4 mt-5">
        <div class="container">
            <p class="text-muted mb-0">
                &copy; 2024 Universidad Privada de Tacna - Sistema de Voluntariado Universitario
            </p>
        </div>
    </footer>

    <!-- Scroll to Top Button -->
    <button class="scroll-to-top" id="scrollToTop">
        <i class="fas fa-chevron-up"></i>
    </button>

    <!-- Modal para mostrar QR -->
    <div class="modal fade" id="qrModal" tabindex="-1" aria-labelledby="qrModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="qrModalLabel">
                        <i class="fas fa-qrcode me-2"></i>Código QR de Asistencia
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <div class="mb-3">
                        <h6 id="qrCampanaTitulo" class="text-primary"></h6>
                        <small class="text-muted">Presenta este código QR al coordinador para registrar tu asistencia</small>
                    </div>
                    <div id="qrCodeContainer" class="d-flex justify-content-center mb-3">
                        <!-- El QR se generará aquí -->
                    </div>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Instrucciones:</strong><br>
                        • Presenta este QR al coordinador el día del evento<br>
                        • El código es único para esta inscripción<br>
                        • Guarda una captura de pantalla como respaldo
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-primary" onclick="descargarQR()">
                        <i class="fas fa-download me-1"></i>Descargar QR
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Initialize tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Smooth scrolling for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Scroll to top button functionality
        const scrollToTopBtn = document.getElementById('scrollToTop');
        
        if (scrollToTopBtn) {
            window.addEventListener('scroll', function() {
                if (window.pageYOffset > 300) {
                    scrollToTopBtn.classList.add('show');
                } else {
                    scrollToTopBtn.classList.remove('show');
                }
            });
            
            scrollToTopBtn.addEventListener('click', function() {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            });
        }

        // Función para inscribirse en una campaña
        function inscribirseCampana(idCampana) {
            if (confirm('¿Estás seguro de que deseas inscribirte en esta campaña?')) {
                // Mostrar indicador de carga
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Inscribiendo...';
                button.disabled = true;
                
                // Realizar petición AJAX
                fetch('<%=request.getContextPath()%>/InscripcionServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'idCampana=' + encodeURIComponent(idCampana)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('¡Inscripción exitosa! La página se recargará para mostrar los cambios.');
                        location.reload();
                    } else {
                        alert('Error: ' + data.message);
                        button.innerHTML = originalText;
                        button.disabled = false;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error de conexión. Por favor, intenta nuevamente.');
                    button.innerHTML = originalText;
                    button.disabled = false;
                });
            }
        }

        // Función para ver detalles de una campaña
        function verDetalleCampana(idCampana) {
            alert('Ver detalles de la campaña ID: ' + idCampana);
        }

        // Función temporal para QR (solo muestra mensaje)
        function generarQR(idCampana, idUsuario) {
            alert('Función QR temporalmente deshabilitada');
        }

        // Filtro de búsqueda para campañas
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                const campaignCards = document.querySelectorAll('.campaign-card');
                
                campaignCards.forEach(card => {
                    const title = card.querySelector('.card-title');
                    const description = card.querySelector('.card-text');
                    
                    if (title && description) {
                        const titleText = title.textContent.toLowerCase();
                        const descText = description.textContent.toLowerCase();
                        
                        if (titleText.includes(searchTerm) || descText.includes(searchTerm)) {
                            card.parentElement.style.display = 'block';
                        } else {
                            card.parentElement.style.display = 'none';
                        }
                    }
                });
            });
        }
    </script>
</body>
</html>