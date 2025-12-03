<%-- 
    Document   : menu_admin
    Created on : 15 oct. 2025
    Author     : Sistema UPT
    Description: Panel del Administrador - Sistema de Voluntariado UPT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="entidad.*"%>
<%@page import="negocio.*"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    // Validación de sesión
    if (session.getAttribute("usuario") == null || 
        !"ADMINISTRADOR".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    Usuario administrador = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = administrador.getNombres() + " " + administrador.getApellidos();
    
    // Obtener estadísticas de usuarios
    UsuarioNegocio negocio = new UsuarioNegocio();
    int totalEstudiantes = negocio.contarUsuariosPorRol("ESTUDIANTE");
    int totalCoordinadores = negocio.contarUsuariosPorRol("COORDINADOR");
    int totalAdministradores = negocio.contarUsuariosPorRol("ADMINISTRADOR");
    int totalUsuariosActivos = negocio.contarUsuariosActivos();
    
    // Obtener todos los usuarios
    List<Usuario> todosUsuarios = negocio.listarTodosUsuarios();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Administrador - Sistema de Voluntariado UPT</title>
    
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
            --gray-200: #E9ECEF;
            --gray-300: #DEE2E6;
            --gray-600: #6C757D;
            --gray-800: #343A40;
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
        }
        
        /* Navbar */
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
        }
        
        /* Sidebar */
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
        }
        
        .page-header {
            background: var(--white);
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
        
        /* Metric Cards */
        .metric-card {
            background: var(--white);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
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
        
        .metric-icon.estudiantes {
            background: linear-gradient(135deg, #17A2B8 0%, #138496 100%);
        }
        
        .metric-icon.coordinadores {
            background: linear-gradient(135deg, #FFC107 0%, #E0A800 100%);
        }
        
        .metric-icon.administradores {
            background: linear-gradient(135deg, #DC3545 0%, #C82333 100%);
        }
        
        .metric-icon.activos {
            background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
        }
        
        .metric-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 0.5rem;
        }
        
        .metric-label {
            color: var(--gray-600);
            font-weight: 500;
            font-size: 0.9rem;
        }
        
        /* Chart Card */
        .chart-card {
            background: var(--white);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            height: 100%;
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
        }
        
        .chart-container {
            position: relative;
            height: 300px;
        }
        
        /* Section Title */
        .section-title {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        /* Table */
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
            background: var(--gray-200);
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
        
        .table-custom tbody tr:hover {
            background-color: rgba(0, 61, 122, 0.05);
        }
        
        /* Badges */
        .badge-rol {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .badge-estudiante {
            background-color: rgba(23, 162, 184, 0.1);
            color: #17A2B8;
        }
        
        .badge-coordinador {
            background-color: rgba(255, 193, 7, 0.1);
            color: #E0A800;
        }
        
        .badge-administrador {
            background-color: rgba(220, 53, 69, 0.1);
            color: #DC3545;
        }
        
        .badge-activo {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .badge-inactivo {
            background-color: rgba(108, 117, 125, 0.1);
            color: var(--gray-600);
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
        
        .btn-sm-custom {
            padding: 6px 12px;
            font-size: 0.85rem;
        }
        
        /* Modal */
        .modal-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: var(--white);
            border-radius: 10px 10px 0 0;
        }
        
        .modal-content {
            border-radius: 10px;
            border: none;
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
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="menu_admin.jsp">
                <i class="fas fa-user-shield me-2"></i>
                Sistema de Voluntariado UPT - Admin
            </a>
            
            <div class="d-flex align-items-center">
                <span class="user-info me-3">
                    <i class="fas fa-user-cog me-2"></i>
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
                            <a href="menu_admin.jsp" class="active">
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
                            <a href="reportes.jsp">
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
                        <h1 class="page-title">Panel de Administrador</h1>
                        <p class="page-subtitle">Gestión completa del sistema de voluntariado</p>
                    </div>

                    <%-- Mensajes de éxito o error --%>
                    <%
                        String mensaje = (String) session.getAttribute("mensaje");
                        String error = (String) session.getAttribute("error");
                        
                        if (mensaje != null) {
                            session.removeAttribute("mensaje");
                    %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <%= mensaje %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <%
                        }
                        
                        if (error != null) {
                            session.removeAttribute("error");
                    %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <%
                        }
                    %>

                    <!-- Metrics Cards -->
                    <div class="row mb-4">
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="metric-card">
                                <div class="metric-icon estudiantes">
                                    <i class="fas fa-user-graduate"></i>
                                </div>
                                <div class="metric-value"><%= totalEstudiantes %></div>
                                <div class="metric-label">Estudiantes</div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="metric-card">
                                <div class="metric-icon coordinadores">
                                    <i class="fas fa-user-tie"></i>
                                </div>
                                <div class="metric-value"><%= totalCoordinadores %></div>
                                <div class="metric-label">Coordinadores</div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="metric-card">
                                <div class="metric-icon administradores">
                                    <i class="fas fa-user-shield"></i>
                                </div>
                                <div class="metric-value"><%= totalAdministradores %></div>
                                <div class="metric-label">Administradores</div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="metric-card">
                                <div class="metric-icon activos">
                                    <i class="fas fa-user-check"></i>
                                </div>
                                <div class="metric-value"><%= totalUsuariosActivos %></div>
                                <div class="metric-label">Usuarios Activos</div>
                            </div>
                        </div>
                    </div>

                    <!-- Dashboard Charts -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h3 class="section-title">
                                <i class="fas fa-chart-pie me-2"></i>Distribución de Usuarios
                            </h3>
                        </div>
                        
                        <div class="col-lg-6 mb-4">
                            <div class="chart-card">
                                <h5 class="chart-title">
                                    <i class="fas fa-users"></i>
                                    Usuarios por Rol
                                </h5>
                                <div class="chart-container">
                                    <canvas id="rolesChart"></canvas>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-6 mb-4">
                            <div class="chart-card">
                                <h5 class="chart-title">
                                    <i class="fas fa-chart-bar"></i>
                                    Estado de Usuarios
                                </h5>
                                <div class="chart-container">
                                    <canvas id="estadoChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Gestión de Usuarios -->
                    <section id="gestionUsuarios" class="mb-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3 class="section-title mb-0">
                                <i class="fas fa-users-cog me-2"></i>Gestión de Usuarios
                            </h3>
                            <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#modalNuevoUsuario">
                                <i class="fas fa-user-plus me-2"></i>Nuevo Usuario
                            </button>
                        </div>

                        <!-- Filtros -->
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <select class="form-select" id="filtroRol">
                                    <option value="">Todos los roles</option>
                                    <option value="ESTUDIANTE">Estudiantes</option>
                                    <option value="COORDINADOR">Coordinadores</option>
                                    <option value="ADMINISTRADOR">Administradores</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <select class="form-select" id="filtroEstado">
                                    <option value="">Todos los estados</option>
                                    <option value="1">Activos</option>
                                    <option value="0">Inactivos</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <input type="text" class="form-control" id="buscarUsuario" placeholder="Buscar por nombre o correo...">
                            </div>
                        </div>

                        <!-- Tabla de Usuarios -->
                        <div class="table-custom">
                            <table class="table table-hover mb-0" id="tablaUsuarios">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Código</th>
                                        <th>Nombre Completo</th>
                                        <th>Correo</th>
                                        <th>Rol</th>
                                        <th>Escuela</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (todosUsuarios != null && !todosUsuarios.isEmpty()) { %>
                                        <% for (Usuario user : todosUsuarios) { %>
                                            <tr>
                                                <td><%= user.getIdUsuario() %></td>
                                                <td><%= user.getCodigo() != null ? user.getCodigo() : "-" %></td>
                                                <td><%= user.getNombres() %> <%= user.getApellidos() %></td>
                                                <td><%= user.getCorreo() %></td>
                                                <td>
                                                    <span class="badge-rol badge-<%= user.getRol().toLowerCase() %>">
                                                        <%= user.getRol() %>
                                                    </span>
                                                </td>
                                                <td><%= user.getEscuela() != null ? user.getEscuela() : "-" %></td>
                                                <td>
                                                    <span class="badge <%= user.isActivo() ? "badge-activo" : "badge-inactivo" %>">
                                                        <%= user.isActivo() ? "Activo" : "Inactivo" %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <button class="btn btn-sm btn-outline-primary" 
                                                                onclick="editarUsuario(<%= user.getIdUsuario() %>)"
                                                                title="Editar">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <% if (user.isActivo()) { %>
                                                            <button class="btn btn-sm btn-outline-warning" 
                                                                    onclick="cambiarEstadoUsuario(<%= user.getIdUsuario() %>, 0)"
                                                                    title="Desactivar">
                                                                <i class="fas fa-user-slash"></i>
                                                            </button>
                                                        <% } else { %>
                                                            <button class="btn btn-sm btn-outline-success" 
                                                                    onclick="cambiarEstadoUsuario(<%= user.getIdUsuario() %>, 1)"
                                                                    title="Activar">
                                                                <i class="fas fa-user-check"></i>
                                                            </button>
                                                        <% } %>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    <% } else { %>
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-4">
                                                No hay usuarios registrados
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Nuevo Usuario -->
    <div class="modal fade" id="modalNuevoUsuario" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-user-plus me-2"></i>Crear Nuevo Usuario
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="formNuevoUsuario" action="<%= request.getContextPath() %>/GestionUsuarioServlet" method="POST">
                        <input type="hidden" name="accion" value="crear">
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Código (opcional)</label>
                                <input type="text" class="form-control" name="codigo" placeholder="202012345">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Rol <span class="text-danger">*</span></label>
                                <select class="form-select" name="rol" required>
                                    <option value="">Seleccione un rol</option>
                                    <option value="ESTUDIANTE">Estudiante</option>
                                    <option value="COORDINADOR">Coordinador</option>
                                    <option value="ADMINISTRADOR">Administrador</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Nombres <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="nombres" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Apellidos <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="apellidos" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Correo <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" name="correo" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Contraseña <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" name="contrasena" required minlength="3">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Escuela</label>
                                <input type="text" class="form-control" name="escuela" placeholder="EPIS">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Teléfono</label>
                                <input type="tel" class="form-control" name="telefono" placeholder="987654321">
                            </div>
                        </div>
                        
                        <div class="mt-4 d-flex justify-content-end gap-2">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary-custom">
                                <i class="fas fa-save me-2"></i>Guardar Usuario
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Editar Usuario -->
    <div class="modal fade" id="modalEditarUsuario" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-user-edit me-2"></i>Editar Usuario
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="formEditarUsuario" action="<%= request.getContextPath() %>/GestionUsuarioServlet" method="POST">
                        <input type="hidden" name="accion" value="editar">
                        <input type="hidden" name="idUsuario" id="editIdUsuario">
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Código</label>
                                <input type="text" class="form-control" name="codigo" id="editCodigo">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Rol <span class="text-danger">*</span></label>
                                <select class="form-select" name="rol" id="editRol" required>
                                    <option value="">Seleccione un rol</option>
                                    <option value="ESTUDIANTE">Estudiante</option>
                                    <option value="COORDINADOR">Coordinador</option>
                                    <option value="ADMINISTRADOR">Administrador</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Nombres <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="nombres" id="editNombres" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Apellidos <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="apellidos" id="editApellidos" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Correo <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" name="correo" id="editCorreo" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Escuela</label>
                                <input type="text" class="form-control" name="escuela" id="editEscuela">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Teléfono</label>
                                <input type="tel" class="form-control" name="telefono" id="editTelefono">
                            </div>
                        </div>
                        
                        <div class="alert alert-info mt-3">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Nota:</strong> La contraseña no se puede cambiar desde aquí.
                        </div>
                        
                        <div class="mt-4 d-flex justify-content-end gap-2">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary-custom">
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
        // Datos para gráficos
        const totalEstudiantes = <%= totalEstudiantes %>;
        const totalCoordinadores = <%= totalCoordinadores %>;
        const totalAdministradores = <%= totalAdministradores %>;
        const totalActivos = <%= totalUsuariosActivos %>;
        const totalInactivos = <%= todosUsuarios.size() - totalUsuariosActivos %>;
        
        // Colores UPT
        const coloresUPT = {
            primary: '#003D7A',
            estudiantes: '#17A2B8',
            coordinadores: '#FFC107',
            administradores: '#DC3545',
            activo: '#28A745',
            inactivo: '#6C757D'
        };
        
        // Gráfico de Roles (Dona)
        const ctxRoles = document.getElementById('rolesChart').getContext('2d');
        new Chart(ctxRoles, {
            type: 'doughnut',
            data: {
                labels: ['Estudiantes', 'Coordinadores', 'Administradores'],
                datasets: [{
                    data: [totalEstudiantes, totalCoordinadores, totalAdministradores],
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
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const value = context.parsed;
                                const percentage = ((value / total) * 100).toFixed(1);
                                return context.label + ': ' + value + ' (' + percentage + '%)';
                            }
                        }
                    }
                }
            }
        });
        
        // Gráfico de Estado (Barras)
        const ctxEstado = document.getElementById('estadoChart').getContext('2d');
        new Chart(ctxEstado, {
            type: 'bar',
            data: {
                labels: ['Activos', 'Inactivos'],
                datasets: [{
                    label: 'Usuarios',
                    data: [totalActivos, totalInactivos],
                    backgroundColor: [coloresUPT.activo, coloresUPT.inactivo],
                    borderRadius: 8,
                    barThickness: 60
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        padding: 12,
                        cornerRadius: 8
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
        
        // Funciones de gestión
        function editarUsuario(id) {
            // Obtener datos del usuario desde el servidor
            // Por simplicidad, vamos a buscar el usuario en la lista JSP
            <% if (todosUsuarios != null) { %>
                const usuarios = [
                    <% for (int i = 0; i < todosUsuarios.size(); i++) { 
                        Usuario u = todosUsuarios.get(i);
                    %>
                    {
                        id: <%= u.getIdUsuario() %>,
                        codigo: '<%= u.getCodigo() != null ? u.getCodigo() : "" %>',
                        nombres: '<%= u.getNombres() %>',
                        apellidos: '<%= u.getApellidos() %>',
                        correo: '<%= u.getCorreo() %>',
                        rol: '<%= u.getRol() %>',
                        escuela: '<%= u.getEscuela() != null ? u.getEscuela() : "" %>',
                        telefono: '<%= u.getTelefono() != null ? u.getTelefono() : "" %>'
                    }<%= i < todosUsuarios.size() - 1 ? "," : "" %>
                    <% } %>
                ];
                
                const usuario = usuarios.find(u => u.id === id);
                
                if (usuario) {
                    // Llenar el formulario
                    document.getElementById('editIdUsuario').value = usuario.id;
                    document.getElementById('editCodigo').value = usuario.codigo;
                    document.getElementById('editRol').value = usuario.rol;
                    document.getElementById('editNombres').value = usuario.nombres;
                    document.getElementById('editApellidos').value = usuario.apellidos;
                    document.getElementById('editCorreo').value = usuario.correo;
                    document.getElementById('editEscuela').value = usuario.escuela;
                    document.getElementById('editTelefono').value = usuario.telefono;
                    
                    // Abrir modal
                    const modal = new bootstrap.Modal(document.getElementById('modalEditarUsuario'));
                    modal.show();
                }
            <% } %>
        }
        
        function cambiarEstadoUsuario(id, nuevoEstado) {
            const accion = nuevoEstado === 1 ? 'activar' : 'desactivar';
            if (confirm('¿Está seguro de ' + accion + ' este usuario?')) {
                window.location.href = '<%= request.getContextPath() %>/GestionUsuarioServlet?accion=cambiarEstado&idUsuario=' + id + '&estado=' + nuevoEstado;
            }
        }
        
        // Filtros
        document.getElementById('filtroRol').addEventListener('change', filtrarTabla);
        document.getElementById('filtroEstado').addEventListener('change', filtrarTabla);
        document.getElementById('buscarUsuario').addEventListener('input', filtrarTabla);
        
        function filtrarTabla() {
            const filtroRol = document.getElementById('filtroRol').value;
            const filtroEstado = document.getElementById('filtroEstado').value;
            const busqueda = document.getElementById('buscarUsuario').value.toLowerCase();
            
            const filas = document.querySelectorAll('#tablaUsuarios tbody tr');
            
            filas.forEach(fila => {
                if (fila.cells.length === 1) return; // Skip empty row
                
                const rol = fila.cells[4].textContent.trim();
                const estado = fila.querySelector('.badge').textContent.trim() === 'Activo' ? '1' : '0';
                const nombre = fila.cells[2].textContent.toLowerCase();
                const correo = fila.cells[3].textContent.toLowerCase();
                
                let mostrar = true;
                
                if (filtroRol && rol !== filtroRol) mostrar = false;
                if (filtroEstado && estado !== filtroEstado) mostrar = false;
                if (busqueda && !nombre.includes(busqueda) && !correo.includes(busqueda)) mostrar = false;
                
                fila.style.display = mostrar ? '' : 'none';
            });
        }
        
        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                const href = this.getAttribute('href');
                if (href !== '#' && href.length > 1) {
                    e.preventDefault();
                    const target = document.querySelector(href);
                    if (target) {
                        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                }
            });
        });
    </script>
</body>
</html>
