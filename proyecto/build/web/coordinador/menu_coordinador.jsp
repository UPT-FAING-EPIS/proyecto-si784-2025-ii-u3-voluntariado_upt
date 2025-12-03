<%-- 
    Document   : menu_coordinador
    Created on : 29 set. 2025, 10:15:03 p. m.
    Author     : Mi Equipo
    Description: Sistema de Voluntariado UPT - Panel del Coordinador
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="entidad.*"%>
<%@page import="negocio.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    // Validación de sesión - Verificar que el usuario esté logueado y sea coordinador
    if (session.getAttribute("usuario") == null || 
        !"COORDINADOR".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Obtener datos del coordinador desde la sesión
    Usuario coordinador = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = coordinador.getNombres() + " " + coordinador.getApellidos();
    String codigoCoordinador = coordinador.getCodigo();
    
    // Cargar campañas del coordinador
    coordinadornegocio negocio = new coordinadornegocio();
    List<Campana> misCampanas = negocio.obtenerCampanasPorCoordinador(coordinador.getIdUsuario());
    
    // Obtener inscripciones del coordinador
    List<Map<String, Object>> inscripciones = negocio.obtenerInscripcionesPorCoordinador(coordinador.getIdUsuario());
    
    // Obtener estadísticas
    int totalCampanas = negocio.contarCampanasPorCoordinador(coordinador.getIdUsuario());
    int totalInscritos = negocio.contarInscritosPorCoordinador(coordinador.getIdUsuario());
    
    // Calcular estadísticas adicionales para los dashboards
    int totalAsistencias = 0;
    int totalCertificados = 0;
    int campanasActivas = 0;
    
    // Estadísticas por campaña para los gráficos
    Map<String, Integer> inscritosPorCampana = new LinkedHashMap<>();
    Map<String, Integer> asistenciasPorCampana = new LinkedHashMap<>();
    Map<String, Integer> cuposTotalesPorCampana = new LinkedHashMap<>();
    Map<String, Integer> cuposOcupadosPorCampana = new LinkedHashMap<>();
    
    if (misCampanas != null && !misCampanas.isEmpty()) {
        for (Campana campana : misCampanas) {
            String titulo = campana.getTitulo();
            
            // Contar inscritos en esta campaña
            int inscritos = campana.getCuposTotal() - campana.getCuposDisponibles();
            inscritosPorCampana.put(titulo, inscritos);
            cuposTotalesPorCampana.put(titulo, campana.getCuposTotal());
            cuposOcupadosPorCampana.put(titulo, campana.getCuposOcupados());
            
            // Contar asistencias en esta campaña
            int asistencias = negocio.contarAsistenciasPorCampana(campana.getIdCampana());
            asistenciasPorCampana.put(titulo, asistencias);
            totalAsistencias += asistencias;
            
            // Contar certificados emitidos
            int certificados = negocio.contarCertificadosPorCampana(campana.getIdCampana());
            totalCertificados += certificados;
            
            // Contar campañas activas (publicadas)
            if ("PUBLICADA".equals(campana.getEstado())) {
                campanasActivas++;
            }
        }
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Panel Coordinador - Sistema de Voluntariado | UPT</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
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
        }
        
        .user-info {
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
        }
        
        .btn-logout {
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: var(--white);
            border-radius: 8px;
            padding: 8px 16px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-logout:hover {
            background-color: rgba(255, 255, 255, 0.2);
            color: var(--white);
            transform: translateY(-1px);
        }
        
        /* Sidebar Styles */
        .sidebar {
            background: var(--white);
            box-shadow: 2px 0 20px rgba(0, 0, 0, 0.08);
            min-height: calc(100vh - 80px);
            padding: 2rem 0;
            position: sticky;
            top: 80px;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .sidebar-menu li {
            margin-bottom: 8px;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 12px 24px;
            color: var(--gray-600);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            border-radius: 0 25px 25px 0;
            margin-right: 20px;
        }
        
        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: var(--white);
            transform: translateX(5px);
        }
        
        .sidebar-menu i {
            width: 20px;
            margin-right: 12px;
            text-align: center;
        }
        
        /* Main Content */
        .main-content {
            padding: 2rem;
            background-color: var(--light-bg);
        }
        
        .page-header {
            background: linear-gradient(135deg, var(--white) 0%, #f8f9fa 100%);
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
            color: var(--gray-600);
            font-size: 1.1rem;
        }
        
        /* Metrics Cards */
        .metrics-row {
            margin-bottom: 2rem;
        }
        
        .metric-card {
            background: var(--white);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: none;
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .metric-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }
        
        .metric-icon {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--white);
            margin-bottom: 1rem;
        }
        
        .metric-icon.primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        }
        
        .metric-icon.success {
            background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
        }
        
        .metric-icon.warning {
            background: linear-gradient(135deg, var(--warning-color) 0%, #fd7e14 100%);
        }
        
        .metric-icon.info {
            background: linear-gradient(135deg, var(--info-color) 0%, #6f42c1 100%);
        }
        
        .metric-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }
        
        .metric-label {
            color: var(--gray-600);
            font-weight: 500;
            font-size: 0.9rem;
        }
        
        /* Section Styles */
        .section-title {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        /* Campaign Cards */
        .campaign-card {
            background: var(--white);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: none;
            transition: all 0.3s ease;
            height: 100%;
            margin-bottom: 1.5rem;
        }
        
        .campaign-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }
        
        .campaign-title {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
        }
        
        .campaign-meta {
            color: var(--gray-600);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        
        .campaign-meta i {
            margin-right: 0.5rem;
            width: 16px;
        }
        
        .campaign-description {
            color: var(--gray-700);
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 1rem;
        }
        
        .campaign-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-value {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--primary-color);
        }
        
        .stat-label {
            font-size: 0.8rem;
            color: var(--gray-600);
        }
        
        .campaign-status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .status-publicada {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .status-cerrada {
            background-color: rgba(108, 117, 125, 0.1);
            color: var(--gray-600);
        }
        
        .status-cancelada {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }
        
        /* Buttons */
        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
            color: var(--white);
            transition: all 0.3s ease;
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 61, 122, 0.3);
            color: var(--white);
        }
        
        .btn-outline-primary-custom {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            background: transparent;
            border-radius: 10px;
            padding: 8px 16px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-outline-primary-custom:hover {
            background: var(--primary-color);
            color: var(--white);
            transform: translateY(-2px);
        }
        
        .btn-sm-custom {
            padding: 6px 12px;
            font-size: 0.85rem;
            border-radius: 8px;
        }
        
        /* Table Styles */
        .table-custom {
            background: var(--white);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        
        .table-custom .table {
            margin-bottom: 0;
        }
        
        .table-custom thead th {
            background: var(--gray-100);
            border: none;
            font-weight: 600;
            color: var(--gray-800);
            padding: 1rem;
        }
        
        .table-custom tbody td {
            border: none;
            padding: 1rem;
            vertical-align: middle;
        }
        
        .table-custom tbody tr {
            border-bottom: 1px solid var(--gray-200);
        }
        
        .table-custom tbody tr:last-child {
            border-bottom: none;
        }
        
        .avatar-sm {
            width: 40px;
            height: 40px;
            font-size: 14px;
        }
        
        .table-custom tbody tr:hover {
            background-color: rgba(0, 61, 122, 0.05);
        }
        
        .btn-group .btn {
            margin-right: 2px;
        }
        
        .btn-group .btn:last-child {
            margin-right: 0;
        }
        
        /* Form Styles */
        .form-control, .form-select {
            border: 2px solid var(--gray-300);
            border-radius: 10px;
            padding: 10px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(0, 61, 122, 0.25);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: var(--gray-600);
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        
        .empty-state h5 {
            margin-bottom: 0.5rem;
        }
        
        .empty-state p {
            margin-bottom: 1.5rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }
            
            .main-content {
                padding: 1rem;
            }
            
            .page-header {
                padding: 1.5rem;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
            
            .metric-card {
                margin-bottom: 1rem;
            }
            
            .chart-card {
                margin-bottom: 1rem;
            }
        }
        
        /* Chart Cards */
        .chart-card {
            background: var(--white);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            height: 100%;
            transition: all 0.3s ease;
        }
        
        .chart-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }
        
        .chart-title {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }
        
        .chart-title i {
            margin-right: 0.5rem;
            font-size: 1.2rem;
        }
        
        .chart-container {
            position: relative;
            height: 300px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-hands-helping me-2"></i>
                Sistema de Voluntariado UPT
            </a>
            
            <div class="navbar-nav ms-auto d-flex align-items-center">
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

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-3 col-xl-2 px-0">
                <div class="sidebar">
                    <ul class="sidebar-menu">
                        <li>
                            <a href="menu_coordinador.jsp" class="active">
                                <i class="fas fa-tachometer-alt"></i>
                                Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="crear_campana.jsp">
                                <i class="fas fa-bullhorn"></i>
                                Mis Campañas
                            </a>
                        </li>
                        <li>
                            <a href="#inscripciones">
                                <i class="fas fa-users"></i>
                                Inscripciones
                            </a>
                        </li>
                        <li>
                            <a href="control_asistencia.jsp">
                                <i class="fas fa-qrcode"></i>
                                Control Asistencia
                            </a>
                        </li>
                        <li>
                            <a href="certificados.jsp">
                                <i class="fas fa-certificate"></i>
                                Certificados
                            </a>
                        </li>
                        <li>
                            <a href="#reportes">
                                <i class="fas fa-chart-bar"></i>
                                Reportes
                            </a>
                        </li>
                    </ul>
                    
                    <!-- Quick Actions -->
                    <div class="px-3 mt-4">
                        <h6 class="text-muted mb-3">Acciones Rápidas</h6>
                        <div class="d-grid gap-2">
                            <button class="btn btn-primary-custom btn-sm" onclick="crearCampana()">
                                <i class="fas fa-plus me-2"></i>Nueva Campaña
                            </button>
                            <button class="btn btn-outline-primary-custom btn-sm" onclick="escanearQR()">
                                <i class="fas fa-qrcode me-2"></i>Escanear QR
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-lg-9 col-xl-10">
                <div class="main-content">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1 class="page-title">Panel de Coordinador</h1>
                        <p class="page-subtitle">Gestiona campañas, inscripciones y certificados</p>
                    </div>
                    
                    <!-- Metrics Cards -->
                    <div class="row metrics-row">
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="metric-card">
                                <div class="metric-icon primary">
                                    <i class="fas fa-bullhorn"></i>
                                </div>
                                <div class="metric-value"><%= campanasActivas %></div>
                                <div class="metric-label">Campañas Activas</div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="metric-card">
                                <div class="metric-icon success">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="metric-value"><%= totalInscritos %></div>
                                <div class="metric-label">Total Inscritos</div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="metric-card">
                                <div class="metric-icon warning">
                                    <i class="fas fa-user-check"></i>
                                </div>
                                <div class="metric-value"><%= totalAsistencias %></div>
                                <div class="metric-label">Asistencias Registradas</div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="metric-card">
                                <div class="metric-icon info">
                                    <i class="fas fa-certificate"></i>
                                </div>
                                <div class="metric-value"><%= totalCertificados %></div>
                                <div class="metric-label">Certificados Emitidos</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Dashboard Charts Section -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h3 class="section-title mb-4">
                                <i class="fas fa-chart-line me-2"></i>Estadísticas en Tiempo Real
                            </h3>
                        </div>
                        
                        <!-- Gráfico de Participación -->
                        <div class="col-lg-6 mb-4">
                            <div class="chart-card">
                                <h5 class="chart-title">
                                    <i class="fas fa-users"></i>
                                    Dashboard de Participación
                                </h5>
                                <div class="chart-container">
                                    <canvas id="participacionChart"></canvas>
                                </div>
                                <div class="mt-3 text-center">
                                    <small class="text-muted">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Comparativa de cupos por campaña
                                    </small>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Gráfico de Asistencia -->
                        <div class="col-lg-6 mb-4">
                            <div class="chart-card">
                                <h5 class="chart-title">
                                    <i class="fas fa-chart-pie"></i>
                                    Dashboard de Asistencia
                                </h5>
                                <div class="chart-container">
                                    <canvas id="asistenciaChart"></canvas>
                                </div>
                                <div class="mt-3 text-center">
                                    <small class="text-muted">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Distribución de asistencias por campaña
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Mis Campañas Section -->
                    <section id="campanas" class="mb-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="section-title">
                                <i class="fas fa-bullhorn me-2"></i>Mis Campañas
                            </h3>
                            <button class="btn btn-primary-custom" onclick="crearCampana()">
                                <i class="fas fa-plus me-2"></i>Nueva Campaña
                            </button>
                        </div>
                        
                        <div class="row" id="campanasGrid">
                            <% if (misCampanas != null && !misCampanas.isEmpty()) { %>
                                <% for (Campana campana : misCampanas) { %>
                                    <div class="col-lg-6 col-xl-4 mb-4">
                                        <div class="campaign-card">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h5 class="campaign-title"><%= campana.getTitulo() %></h5>
                                                <span class="campaign-status status-<%= campana.getEstado().toLowerCase() %>">
                                                    <%= campana.getEstado() %>
                                                </span>
                                            </div>
                                            
                                            <div class="campaign-meta mb-3">
                                                <div class="mb-1">
                                                    <i class="fas fa-calendar-alt"></i>
                                                    <%= sdf.format(campana.getFecha()) %>
                                                </div>
                                                <div class="mb-1">
                                                    <i class="fas fa-clock"></i>
                                                    <%= sdfHora.format(campana.getHoraInicio()) %> - <%= sdfHora.format(campana.getHoraFin()) %>
                                                </div>
                                                <div class="mb-1">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                    <%= campana.getLugar() %>
                                                </div>
                                            </div>
                                            
                                            <p class="campaign-description">
                                                <%= campana.getDescripcion().length() > 100 ? 
                                                    campana.getDescripcion().substring(0, 100) + "..." : 
                                                    campana.getDescripcion() %>
                                            </p>
                                            
                                            <div class="campaign-stats mb-3">
                                                <div class="stat-item">
                                                    <div class="stat-value"><%= campana.getCuposTotal() %></div>
                                                    <div class="stat-label">Cupos Total</div>
                                                </div>
                                                <div class="stat-item">
                                                    <div class="stat-value"><%= campana.getCuposDisponibles() %></div>
                                                    <div class="stat-label">Disponibles</div>
                                                </div>
                                                <div class="stat-item">
                                                    <div class="stat-value"><%= campana.getCuposOcupados() %></div>
                                                    <div class="stat-label">Inscritos</div>
                                                </div>
                                            </div>
                                            
                                            <!-- Progress Bar -->
                                            <div class="mb-3">
                                                <div class="d-flex justify-content-between mb-1">
                                                    <small class="text-muted">Ocupación</small>
                                                    <small class="text-muted"><%= String.format("%.1f", campana.getPorcentajeOcupacion()) %>%</small>
                                                </div>
                                                <div class="progress" style="height: 6px;">
                                                    <div class="progress-bar bg-primary" role="progressbar" 
                                                         style="width: <%= campana.getPorcentajeOcupacion() %>%"></div>
                                                </div>
                                            </div>
                                            
                                            <div class="d-flex gap-2">
                                                <button class="btn btn-outline-primary-custom btn-sm-custom flex-fill" 
                                                        onclick="verDetalleCampana(<%= campana.getIdCampana() %>)">
                                                    <i class="fas fa-eye me-1"></i>Ver Detalles
                                                </button>
                                                <button class="btn btn-primary-custom btn-sm-custom" 
                                                        onclick="gestionarCampana(<%= campana.getIdCampana() %>)">
                                                    <i class="fas fa-cog me-1"></i>Gestionar
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                <% } %>
                            <% } else { %>
                                <div class="col-12">
                                    <div class="empty-state">
                                        <i class="fas fa-bullhorn"></i>
                                        <h5>No tienes campañas creadas</h5>
                                        <p>Crea tu primera campaña para comenzar a gestionar voluntarios.</p>
                                        <button class="btn btn-primary-custom" onclick="crearCampana()">
                                            <i class="fas fa-plus me-2"></i>Crear Primera Campaña
                                        </button>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </section>
                    
                    <!-- Gestión de Inscripciones Section -->
                    <section id="inscripciones" class="mb-5">
                        <h3 class="section-title mb-4">
                            <i class="fas fa-users me-2"></i>Gestión de Inscripciones
                        </h3>
                        
                        <!-- Filtros -->
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <select class="form-select" id="filtroCampana">
                                    <option value="">Todas las campañas</option>
                                    <% if (misCampanas != null && !misCampanas.isEmpty()) { %>
                                        <% for (Campana campana : misCampanas) { %>
                                            <option value="<%= campana.getIdCampana() %>"><%= campana.getTitulo() %></option>
                                        <% } %>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <select class="form-select" id="filtroEstado">
                                    <option value="">Todos los estados</option>
                                    <option value="INSCRITO">Inscritos</option>
                                    <option value="LISTA_ESPERA">Lista de Espera</option>
                                    <option value="CONFIRMADO">Confirmados</option>
                                    <option value="CANCELADO">Cancelados</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar estudiante..." id="searchEstudiante">
                                    <button class="btn btn-outline-secondary" type="button">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <div class="table-custom">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Estudiante</th>
                                        <th>Campaña</th>
                                        <th>Fecha Inscripción</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (inscripciones != null && !inscripciones.isEmpty()) { %>
                                        <% for (Map<String, Object> inscripcion : inscripciones) { %>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3">
                                                            <i class="fas fa-user"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold"><%= inscripcion.get("nombreEstudiante") %></div>
                                                            <small class="text-muted">
                                                                <% if (inscripcion.get("codigoEstudiante") != null) { %>
                                                                    Código: <%= inscripcion.get("codigoEstudiante") %>
                                                                <% } %>
                                                            </small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="fw-medium"><%= inscripcion.get("campanaTitulo") %></div>
                                                </td>
                                                <td>
                                                    <% 
                                                        java.sql.Timestamp fechaInscripcion = (java.sql.Timestamp) inscripcion.get("fechaInscripcion");
                                                        if (fechaInscripcion != null) {
                                                            SimpleDateFormat sdfFecha = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                                    %>
                                                        <%= sdfFecha.format(fechaInscripcion) %>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <span class="badge bg-success">INSCRITO</span>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                onclick="verDetalleInscripcion(<%= inscripcion.get("idInscripcion") %>)"
                                                                data-bs-toggle="tooltip" title="Ver detalles">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-success" 
                                                                onclick="contactarEstudiante('<%= inscripcion.get("emailEstudiante") %>')"
                                                                data-bs-toggle="tooltip" title="Contactar">
                                                            <i class="fas fa-envelope"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    <% } else { %>
                                        <tr>
                                            <td colspan="5" class="text-center text-muted py-4">
                                                <i class="fas fa-users fa-2x mb-2 d-block"></i>
                                                No hay inscripciones para mostrar
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </section>
                    
                    <!-- Reportes Section -->
                    <section id="reportes" class="mb-5">
                        <h3 class="section-title mb-4">
                            <i class="fas fa-chart-bar me-2"></i>Reportes y Estadísticas
                        </h3>
                        
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <div class="campaign-card text-center">
                                    <i class="fas fa-chart-pie fa-2x text-primary mb-3"></i>
                                    <h6>Reporte de Participación</h6>
                                    <button class="btn btn-outline-primary-custom btn-sm-custom mt-2" onclick="generarReporte('participacion')">
                                        <i class="fas fa-download me-1"></i>Generar
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="campaign-card text-center">
                                    <i class="fas fa-chart-line fa-2x text-success mb-3"></i>
                                    <h6>Estadísticas de Asistencia</h6>
                                    <button class="btn btn-outline-primary-custom btn-sm-custom mt-2" onclick="generarReporte('asistencia')">
                                        <i class="fas fa-download me-1"></i>Generar
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="campaign-card text-center">
                                    <i class="fas fa-chart-bar fa-2x text-info mb-3"></i>
                                    <h6>Reporte General</h6>
                                    <button class="btn btn-outline-primary-custom btn-sm-custom mt-2" onclick="generarReporte('general')">
                                        <i class="fas fa-download me-1"></i>Generar
                                    </button>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Datos para los gráficos desde la base de datos
        const campanaNombres = [
            <% 
            if (misCampanas != null && !misCampanas.isEmpty()) {
                for (int i = 0; i < misCampanas.size(); i++) {
                    out.print("'" + misCampanas.get(i).getTitulo().replace("'", "\\'") + "'");
                    if (i < misCampanas.size() - 1) out.print(",");
                }
            }
            %>
        ];
        
        const cuposTotales = [
            <% 
            if (misCampanas != null && !misCampanas.isEmpty()) {
                for (int i = 0; i < misCampanas.size(); i++) {
                    out.print(misCampanas.get(i).getCuposTotal());
                    if (i < misCampanas.size() - 1) out.print(",");
                }
            }
            %>
        ];
        
        const cuposOcupados = [
            <% 
            if (misCampanas != null && !misCampanas.isEmpty()) {
                for (int i = 0; i < misCampanas.size(); i++) {
                    out.print(misCampanas.get(i).getCuposOcupados());
                    if (i < misCampanas.size() - 1) out.print(",");
                }
            }
            %>
        ];
        
        const cuposDisponibles = [
            <% 
            if (misCampanas != null && !misCampanas.isEmpty()) {
                for (int i = 0; i < misCampanas.size(); i++) {
                    out.print(misCampanas.get(i).getCuposDisponibles());
                    if (i < misCampanas.size() - 1) out.print(",");
                }
            }
            %>
        ];
        
        const asistenciasPorCampana = [
            <% 
            if (misCampanas != null && !misCampanas.isEmpty()) {
                for (int i = 0; i < misCampanas.size(); i++) {
                    Campana c = misCampanas.get(i);
                    int asist = negocio.contarAsistenciasPorCampana(c.getIdCampana());
                    out.print(asist);
                    if (i < misCampanas.size() - 1) out.print(",");
                }
            }
            %>
        ];
        
        // Configuración de colores UPT
        const coloresUPT = {
            primary: '#003D7A',
            secondary: '#0066CC',
            success: '#28A745',
            warning: '#FFC107',
            danger: '#DC3545',
            info: '#17A2B8'
        };
        
        // Gráfico de Participación (Barras)
        const ctxParticipacion = document.getElementById('participacionChart').getContext('2d');
        const participacionChart = new Chart(ctxParticipacion, {
            type: 'bar',
            data: {
                labels: campanaNombres,
                datasets: [{
                    label: 'Cupos Totales',
                    data: cuposTotales,
                    backgroundColor: coloresUPT.primary,
                    borderColor: coloresUPT.primary,
                    borderWidth: 2,
                    borderRadius: 8
                }, {
                    label: 'Cupos Ocupados',
                    data: cuposOcupados,
                    backgroundColor: coloresUPT.success,
                    borderColor: coloresUPT.success,
                    borderWidth: 2,
                    borderRadius: 8
                }, {
                    label: 'Cupos Disponibles',
                    data: cuposDisponibles,
                    backgroundColor: coloresUPT.warning,
                    borderColor: coloresUPT.warning,
                    borderWidth: 2,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            font: {
                                family: 'Inter',
                                size: 12,
                                weight: '600'
                            },
                            padding: 15,
                            usePointStyle: true
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleFont: {
                            family: 'Inter',
                            size: 14,
                            weight: '600'
                        },
                        bodyFont: {
                            family: 'Inter',
                            size: 13
                        },
                        padding: 12,
                        cornerRadius: 8
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)'
                        },
                        ticks: {
                            font: {
                                family: 'Inter',
                                size: 11
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            font: {
                                family: 'Inter',
                                size: 11
                            },
                            maxRotation: 45,
                            minRotation: 45
                        }
                    }
                }
            }
        });
        
        // Gráfico de Asistencia (Dona) - Basado en datos reales de asistencias
        const ctxAsistencia = document.getElementById('asistenciaChart').getContext('2d');
        
        // Generar colores dinámicos para cada campaña
        const coloresDona = [];
        const numCampanas = campanaNombres.length;
        for (let i = 0; i < numCampanas; i++) {
            const hue = (i * 360 / numCampanas);
            coloresDona.push('hsl(' + hue + ', 70%, 50%)');
        }
        
        // Filtrar solo campañas con asistencias registradas
        const campanasConAsistencia = [];
        const asistenciasConDatos = [];
        const coloresConDatos = [];
        
        for (let i = 0; i < campanaNombres.length; i++) {
            if (asistenciasPorCampana[i] > 0) {
                campanasConAsistencia.push(campanaNombres[i]);
                asistenciasConDatos.push(asistenciasPorCampana[i]);
                coloresConDatos.push(coloresDona[i]);
            }
        }
        
        // Si no hay asistencias, mostrar mensaje
        if (asistenciasConDatos.length === 0) {
            campanasConAsistencia.push('Sin asistencias registradas');
            asistenciasConDatos.push(1);
            coloresConDatos.push('#cccccc');
        }
        
        const asistenciaChart = new Chart(ctxAsistencia, {
            type: 'doughnut',
            data: {
                labels: campanasConAsistencia,
                datasets: [{
                    label: 'Asistencias',
                    data: asistenciasConDatos,
                    backgroundColor: coloresConDatos,
                    borderColor: '#fff',
                    borderWidth: 3,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            font: {
                                family: 'Inter',
                                size: 12,
                                weight: '600'
                            },
                            padding: 12,
                            usePointStyle: true,
                            generateLabels: function(chart) {
                                const data = chart.data;
                                if (data.labels.length && data.datasets.length) {
                                    return data.labels.map((label, i) => {
                                        const value = data.datasets[0].data[i];
                                        return {
                                            text: label + ': ' + value,
                                            fillStyle: data.datasets[0].backgroundColor[i],
                                            hidden: false,
                                            index: i
                                        };
                                    });
                                }
                                return [];
                            }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleFont: {
                            family: 'Inter',
                            size: 14,
                            weight: '600'
                        },
                        bodyFont: {
                            family: 'Inter',
                            size: 13
                        },
                        padding: 12,
                        cornerRadius: 8,
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.parsed || 0;
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = ((value / total) * 100).toFixed(1);
                                return label + ': ' + value + ' (' + percentage + '%)';
                            }
                        }
                    }
                },
                cutout: '60%'
            }
        });
        
        // Funciones de navegación
        function crearCampana() {
            window.location.href = 'crear_campana.jsp';
        }
        
        function verDetalleCampana(idCampana) {
            // Implementar vista de detalles de campaña
            alert('Ver detalles de campaña ID: ' + idCampana);
        }
        
        function gestionarCampana(idCampana) {
            // Implementar gestión de campaña
            alert('Gestionar campaña ID: ' + idCampana);
        }
        
        function escanearQR() {
            window.location.href = 'escanear_qr.jsp';
        }
        
        function registroManual() {
            // Implementar registro manual
            alert('Función de registro manual - Por implementar');
        }
        
        function emitirCertificados() {
            window.location.href = 'certificados.jsp';
        }
        
        function generarReporte(tipo) {
            let url = '';
            switch(tipo) {
                case 'participacion':
                    url = '<%= request.getContextPath() %>/ReporteParticipacionServlet';
                    break;
                case 'asistencia':
                    url = '<%= request.getContextPath() %>/ReporteAsistenciaServlet';
                    break;
                case 'general':
                    url = '<%= request.getContextPath() %>/ReporteGeneralServlet';
                    break;
            }
            if (url) {
                window.open(url, '_blank');
            }
        }
        
        // Función para ver detalles de inscripción
        function verDetalleInscripcion(idInscripcion) {
            // Aquí puedes implementar un modal o redirección para ver detalles
            alert('Ver detalles de inscripción ID: ' + idInscripcion);
        }
        
        // Función para contactar estudiante
        function contactarEstudiante(email) {
            window.location.href = 'mailto:' + email;
        }
        
        // Función para filtrar inscripciones
        function filtrarInscripciones() {
            const filtroCampana = document.getElementById('filtroCampana').value;
            const filtroEstado = document.getElementById('filtroEstado').value;
            const searchEstudiante = document.getElementById('searchEstudiante').value.toLowerCase();
            
            const filas = document.querySelectorAll('#inscripciones tbody tr');
            
            filas.forEach(fila => {
                if (fila.cells.length === 1) return; // Skip "no data" row
                
                const campana = fila.cells[1].textContent;
                const estudiante = fila.cells[0].textContent.toLowerCase();
                const estado = fila.cells[3].textContent;
                
                let mostrar = true;
                
                if (filtroCampana && !campana.includes(filtroCampana)) {
                    mostrar = false;
                }
                
                if (filtroEstado && !estado.includes(filtroEstado)) {
                    mostrar = false;
                }
                
                if (searchEstudiante && !estudiante.includes(searchEstudiante)) {
                    mostrar = false;
                }
                
                fila.style.display = mostrar ? '' : 'none';
            });
        }
        
        // Agregar event listeners para filtros
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('filtroCampana').addEventListener('change', filtrarInscripciones);
            document.getElementById('filtroEstado').addEventListener('change', filtrarInscripciones);
            document.getElementById('searchEstudiante').addEventListener('input', filtrarInscripciones);
            
            // Inicializar tooltips de Bootstrap
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
            
            // Smooth scrolling solo para enlaces internos (#)
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    const href = this.getAttribute('href');
                    if (href !== '#' && href.length > 1) {
                        e.preventDefault();
                        const target = document.querySelector(href);
                        if (target) {
                            target.scrollIntoView({
                                behavior: 'smooth',
                                block: 'start'
                            });
                        }
                    }
                });
            });
        });
    </script>
</body>
</html>