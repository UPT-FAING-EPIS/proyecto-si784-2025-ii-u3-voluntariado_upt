<%-- 
    Document   : reportes
    Created on : 15 oct. 2025
    Author     : Sistema UPT
    Description: Reportes Estadísticos Globales - Panel Administrador
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="entidad.*"%>
<%@page import="negocio.*"%>

<%
    // Validación de sesión
    if (session.getAttribute("usuario") == null || 
        !"ADMINISTRADOR".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    Usuario administrador = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = administrador.getNombres() + " " + administrador.getApellidos();
    
    // Obtener estadísticas globales
    UsuarioNegocio usuarioNeg = new UsuarioNegocio();
    int totalUsuarios = usuarioNeg.listarTodosUsuarios().size();
    int totalEstudiantes = usuarioNeg.contarUsuariosPorRol("ESTUDIANTE");
    int totalCoordinadores = usuarioNeg.contarUsuariosPorRol("COORDINADOR");
    int totalActivos = usuarioNeg.contarUsuariosActivos();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes Estadísticos - Admin UPT</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        :root {
            --primary-color: #003D7A;
            --secondary-color: #0066CC;
            --success-color: #28A745;
            --warning-color: #FFC107;
            --danger-color: #DC3545;
            --info-color: #17A2B8;
            --gray-100: #f8f9fa;
            --gray-200: #e9ecef;
            --gray-600: #6c757d;
            --gray-800: #343a40;
            --white: #ffffff;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        /* Navbar */
        .navbar-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 1rem 2rem;
        }
        
        .navbar-brand {
            color: var(--white) !important;
            font-weight: 700;
            font-size: 1.5rem;
        }
        
        .user-info {
            color: var(--white);
            font-weight: 500;
        }
        
        .btn-logout {
            background: rgba(255, 255, 255, 0.2);
            color: var(--white);
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 0.5rem 1.5rem;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-logout:hover {
            background: rgba(255, 255, 255, 0.3);
            color: var(--white);
            transform: translateY(-2px);
        }
        
        /* Sidebar */
        .sidebar {
            background: var(--white);
            min-height: calc(100vh - 76px);
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1);
            padding: 2rem 0;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0;
        }
        
        .sidebar-menu li {
            margin-bottom: 0.5rem;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 1rem 2rem;
            color: var(--gray-800);
            text-decoration: none;
            transition: all 0.3s;
            font-weight: 500;
        }
        
        .sidebar-menu a:hover {
            background: linear-gradient(90deg, rgba(0, 61, 122, 0.1) 0%, transparent 100%);
            color: var(--primary-color);
        }
        
        .sidebar-menu a.active {
            background: linear-gradient(90deg, rgba(0, 61, 122, 0.15) 0%, transparent 100%);
            color: var(--primary-color);
            border-left: 4px solid var(--primary-color);
        }
        
        .sidebar-menu a i {
            width: 24px;
            margin-right: 1rem;
        }
        
        /* Main Content */
        .main-content {
            padding: 2rem;
        }
        
        .page-header {
            margin-bottom: 2rem;
        }
        
        .page-title {
            color: var(--primary-color);
            font-weight: 700;
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .page-subtitle {
            color: var(--gray-600);
            font-size: 1rem;
        }
        
        /* Report Card */
        .report-card {
            background: var(--white);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 2rem;
        }
        
        .report-title {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.3rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }
        
        .report-title i {
            margin-right: 0.75rem;
            font-size: 1.5rem;
        }
        
        /* Stats Card */
        .stats-card {
            background: linear-gradient(135deg, var(--white) 0%, #f8f9fa 100%);
            border-radius: 12px;
            padding: 1.5rem;
            border: 2px solid var(--gray-200);
            transition: all 0.3s;
        }
        
        .stats-card:hover {
            border-color: var(--secondary-color);
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }
        
        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: var(--white);
            margin-bottom: 1rem;
        }
        
        .stats-icon.primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        }
        
        .stats-icon.success {
            background: linear-gradient(135deg, #28A745 0%, #20c997 100%);
        }
        
        .stats-icon.warning {
            background: linear-gradient(135deg, #FFC107 0%, #FFD54F 100%);
        }
        
        .stats-icon.info {
            background: linear-gradient(135deg, #17A2B8 0%, #5DADE2 100%);
        }
        
        .stats-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--gray-800);
        }
        
        .stats-label {
            color: var(--gray-600);
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        /* Chart Container */
        .chart-container {
            position: relative;
            height: 350px;
        }
        
        /* Filters */
        .filter-section {
            background: var(--gray-100);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            color: var(--white);
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 61, 122, 0.3);
        }
        
        .btn-success-custom {
            background: var(--success-color);
            border: none;
            color: var(--white);
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-success-custom:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        
        .table-custom {
            background: var(--white);
        }
        
        .table-custom th {
            background: var(--gray-200);
            font-weight: 600;
            color: var(--gray-800);
            border: none;
        }
        
        .table-custom td {
            border-color: var(--gray-200);
        }
        
        .progress-custom {
            height: 25px;
            border-radius: 12px;
            background: var(--gray-200);
        }
        
        .progress-bar-custom {
            border-radius: 12px;
            background: linear-gradient(90deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="menu_admin.jsp">
                <i class="fas fa-chart-line me-2"></i>
                Reportes Estadísticos
            </a>
            
            <div class="d-flex align-items-center">
                <span class="user-info me-3">
                    <i class="fas fa-user-shield me-2"></i>
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
                            <a href="menu_admin.jsp">
                                <i class="fas fa-tachometer-alt"></i>
                                Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="menu_admin.jsp#gestionUsuarios">
                                <i class="fas fa-users-cog"></i>
                                Gestionar Usuarios
                            </a>
                        </li>
                        <li>
                            <a href="configuracion_sistema.jsp">
                                <i class="fas fa-cog"></i>
                                Configuración
                            </a>
                        </li>
                        <li>
                            <a href="reportes.jsp" class="active">
                                <i class="fas fa-chart-bar"></i>
                                Reportes
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-lg-9 col-xl-10">
                <div class="main-content">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1 class="page-title">Reportes Estadísticos del Sistema</h1>
                        <p class="page-subtitle">Análisis global y métricas de rendimiento</p>
                    </div>

                    <!-- Filtros de Fecha -->
                    <div class="filter-section">
                        <div class="row align-items-end g-3">
                            <div class="col-md-3">
                                <label class="form-label fw-bold">
                                    <i class="fas fa-calendar-alt me-2"></i>Fecha Inicio
                                </label>
                                <input type="date" class="form-control" id="fechaInicio" value="2025-01-01">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label fw-bold">
                                    <i class="fas fa-calendar-check me-2"></i>Fecha Fin
                                </label>
                                <input type="date" class="form-control" id="fechaFin" value="2025-10-15">
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-primary-custom w-100">
                                    <i class="fas fa-filter me-2"></i>Aplicar Filtros
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-success-custom w-100" onclick="exportarReporte()">
                                    <i class="fas fa-file-excel me-2"></i>Exportar Excel
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Estadísticas Generales -->
                    <div class="row mb-4">
                        <div class="col-md-3 mb-3">
                            <div class="stats-card">
                                <div class="stats-icon primary">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="stats-value"><%= totalUsuarios %></div>
                                <div class="stats-label">Total Usuarios</div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="stats-card">
                                <div class="stats-icon success">
                                    <i class="fas fa-calendar-check"></i>
                                </div>
                                <div class="stats-value">5</div>
                                <div class="stats-label">Campañas Publicadas</div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="stats-card">
                                <div class="stats-icon warning">
                                    <i class="fas fa-user-check"></i>
                                </div>
                                <div class="stats-value">5</div>
                                <div class="stats-label">Total Inscripciones</div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="stats-card">
                                <div class="stats-icon info">
                                    <i class="fas fa-certificate"></i>
                                </div>
                                <div class="stats-value">0</div>
                                <div class="stats-label">Certificados Emitidos</div>
                            </div>
                        </div>
                    </div>

                    <!-- Gráficos -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="report-card">
                                <h3 class="report-title">
                                    <i class="fas fa-chart-pie"></i>
                                    Distribución de Usuarios por Rol
                                </h3>
                                <div class="chart-container">
                                    <canvas id="usuariosRolChart"></canvas>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="report-card">
                                <h3 class="report-title">
                                    <i class="fas fa-chart-line"></i>
                                    Inscripciones por Mes
                                </h3>
                                <div class="chart-container">
                                    <canvas id="inscripcionesMesChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Rendimiento de Coordinadores -->
                    <div class="report-card">
                        <h3 class="report-title">
                            <i class="fas fa-user-tie"></i>
                            Rendimiento de Coordinadores
                        </h3>
                        
                        <div class="table-responsive">
                            <table class="table table-hover table-custom">
                                <thead>
                                    <tr>
                                        <th>Coordinador</th>
                                        <th>Correo</th>
                                        <th>Campañas Creadas</th>
                                        <th>Total Inscritos</th>
                                        <th>Asistencias</th>
                                        <th>Certificados</th>
                                        <th>Tasa de Asistencia</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Victor Cruz</strong></td>
                                        <td>victor@upt.pe</td>
                                        <td><span class="badge bg-primary">5</span></td>
                                        <td><span class="badge bg-info">5</span></td>
                                        <td><span class="badge bg-success">0</span></td>
                                        <td><span class="badge bg-warning">0</span></td>
                                        <td>
                                            <div class="progress progress-custom">
                                                <div class="progress-bar progress-bar-custom" style="width: 0%">0%</div>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Campañas Más Populares -->
                    <div class="report-card">
                        <h3 class="report-title">
                            <i class="fas fa-star"></i>
                            Top Campañas Más Populares
                        </h3>
                        
                        <div class="table-responsive">
                            <table class="table table-hover table-custom">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Campaña</th>
                                        <th>Coordinador</th>
                                        <th>Fecha</th>
                                        <th>Inscritos</th>
                                        <th>Cupos Totales</th>
                                        <th>% Ocupación</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><span class="badge bg-warning">🥇</span></td>
                                        <td><strong>ayuda a perritos</strong></td>
                                        <td>Victor Cruz</td>
                                        <td>30/10/2025</td>
                                        <td><span class="badge bg-primary">1</span></td>
                                        <td>20</td>
                                        <td>
                                            <div class="progress progress-custom">
                                                <div class="progress-bar progress-bar-custom" style="width: 5%">5%</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="badge bg-secondary">🥈</span></td>
                                        <td><strong>ayuda a gatitos</strong></td>
                                        <td>Victor Cruz</td>
                                        <td>23/10/2025</td>
                                        <td><span class="badge bg-primary">1</span></td>
                                        <td>123</td>
                                        <td>
                                            <div class="progress progress-custom">
                                                <div class="progress-bar progress-bar-custom" style="width: 0.8%">0.8%</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><span class="badge bg-info">🥉</span></td>
                                        <td><strong>patos</strong></td>
                                        <td>Victor Cruz</td>
                                        <td>23/10/2025</td>
                                        <td><span class="badge bg-primary">1</span></td>
                                        <td>12</td>
                                        <td>
                                            <div class="progress progress-custom">
                                                <div class="progress-bar progress-bar-custom" style="width: 8.3%">8.3%</div>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Actividad de Estudiantes -->
                    <div class="report-card">
                        <h3 class="report-title">
                            <i class="fas fa-user-graduate"></i>
                            Estudiantes Más Activos
                        </h3>
                        
                        <div class="table-responsive">
                            <table class="table table-hover table-custom">
                                <thead>
                                    <tr>
                                        <th>Estudiante</th>
                                        <th>Código</th>
                                        <th>Escuela</th>
                                        <th>Inscripciones</th>
                                        <th>Asistencias</th>
                                        <th>Certificados</th>
                                        <th>Horas Acumuladas</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Diego Castillo</strong></td>
                                        <td>2022073895</td>
                                        <td>EPIS</td>
                                        <td><span class="badge bg-primary">5</span></td>
                                        <td><span class="badge bg-success">0</span></td>
                                        <td><span class="badge bg-warning">0</span></td>
                                        <td><span class="badge bg-info">0 hrs</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Resumen por Escuela -->
                    <div class="report-card">
                        <h3 class="report-title">
                            <i class="fas fa-building"></i>
                            Participación por Escuela Profesional
                        </h3>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="chart-container">
                                    <canvas id="escuelasChart"></canvas>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <table class="table table-custom">
                                    <thead>
                                        <tr>
                                            <th>Escuela</th>
                                            <th>Estudiantes</th>
                                            <th>Inscripciones</th>
                                            <th>Certificados</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><strong>EPIS</strong></td>
                                            <td><span class="badge bg-primary">1</span></td>
                                            <td><span class="badge bg-info">5</span></td>
                                            <td><span class="badge bg-warning">0</span></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" class="text-center text-muted">
                                                Otras escuelas sin registros
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Colores UPT
        const coloresUPT = {
            primary: '#003D7A',
            secondary: '#0066CC',
            estudiantes: '#17A2B8',
            coordinadores: '#FFC107',
            administradores: '#DC3545',
            success: '#28A745',
            warning: '#FFC107',
            info: '#17A2B8'
        };
        
        // Gráfico de Usuarios por Rol
        const ctxRol = document.getElementById('usuariosRolChart').getContext('2d');
        new Chart(ctxRol, {
            type: 'doughnut',
            data: {
                labels: ['Estudiantes', 'Coordinadores', 'Administradores'],
                datasets: [{
                    data: [<%= totalEstudiantes %>, <%= totalCoordinadores %>, <%= totalUsuarios - totalEstudiantes - totalCoordinadores %>],
                    backgroundColor: [
                        coloresUPT.estudiantes,
                        coloresUPT.coordinadores,
                        coloresUPT.administradores
                    ],
                    borderColor: '#fff',
                    borderWidth: 3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            font: { family: 'Inter', size: 12, weight: '600' },
                            padding: 15
                        }
                    }
                }
            }
        });
        
        // Gráfico de Inscripciones por Mes
        const ctxMes = document.getElementById('inscripcionesMesChart').getContext('2d');
        new Chart(ctxMes, {
            type: 'line',
            data: {
                labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct'],
                datasets: [{
                    label: 'Inscripciones',
                    data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 5],
                    borderColor: coloresUPT.secondary,
                    backgroundColor: 'rgba(0, 102, 204, 0.1)',
                    tension: 0.4,
                    fill: true,
                    borderWidth: 3,
                    pointRadius: 5,
                    pointBackgroundColor: coloresUPT.primary
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
        
        // Gráfico de Participación por Escuela
        const ctxEscuelas = document.getElementById('escuelasChart').getContext('2d');
        new Chart(ctxEscuelas, {
            type: 'bar',
            data: {
                labels: ['EPIS', 'EPIC', 'EPIA', 'EPII', 'Otras'],
                datasets: [{
                    label: 'Estudiantes',
                    data: [1, 0, 0, 0, 0],
                    backgroundColor: [
                        coloresUPT.primary,
                        coloresUPT.secondary,
                        coloresUPT.info,
                        coloresUPT.warning,
                        coloresUPT.success
                    ],
                    borderRadius: 8,
                    barThickness: 40
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
        
        // Función para exportar reporte
        function exportarReporte() {
            alert('📊 Exportando reporte a Excel...\n\nArchivo: reporte_sistema_' + new Date().toISOString().split('T')[0] + '.xlsx\n\nIncluye:\n- Estadísticas generales\n- Rendimiento de coordinadores\n- Campañas populares\n- Estudiantes activos\n- Participación por escuela');
        }
    </script>
</body>
</html>
