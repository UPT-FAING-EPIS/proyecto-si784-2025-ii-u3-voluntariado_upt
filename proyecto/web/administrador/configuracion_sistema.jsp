<%-- 
    Document   : configuracion_sistema
    Created on : 15 oct. 2025
    Author     : Sistema UPT
    Description: Configuración del Sistema - Panel Administrador
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entidad.Usuario"%>

<%
    // Validación de sesión
    if (session.getAttribute("usuario") == null || 
        !"ADMINISTRADOR".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    Usuario administrador = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = administrador.getNombres() + " " + administrador.getApellidos();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuración del Sistema - Admin UPT</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
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
        
        /* Config Card */
        .config-card {
            background: var(--white);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 2rem;
        }
        
        .config-title {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.3rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }
        
        .config-title i {
            margin-right: 0.75rem;
            font-size: 1.5rem;
        }
        
        .form-label {
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 0.5rem;
        }
        
        .form-control, .form-select {
            border: 2px solid var(--gray-200);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            transition: all 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 0.2rem rgba(0, 102, 204, 0.15);
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
        
        .btn-secondary-custom {
            background: var(--gray-600);
            border: none;
            color: var(--white);
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-secondary-custom:hover {
            background: var(--gray-800);
            transform: translateY(-2px);
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
        
        .btn-danger-custom {
            background: var(--danger-color);
            border: none;
            color: var(--white);
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-danger-custom:hover {
            background: #c82333;
            transform: translateY(-2px);
        }
        
        .alert-info-custom {
            background: rgba(0, 102, 204, 0.1);
            border-left: 4px solid var(--secondary-color);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        
        .table-custom {
            background: var(--white);
        }
        
        .table-custom th {
            background: var(--gray-200);
            font-weight: 600;
            color: var(--gray-800);
        }
        
        .badge-custom {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
        }
        
        .switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }
        
        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }
        
        .slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .slider {
            background-color: var(--success-color);
        }
        
        input:checked + .slider:before {
            transform: translateX(26px);
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="menu_admin.jsp">
                <i class="fas fa-cogs me-2"></i>
                Configuración del Sistema
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
                            <a href="configuracion_sistema.jsp" class="active">
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
                        <h1 class="page-title">Configuración del Sistema</h1>
                        <p class="page-subtitle">Parámetros generales y configuración avanzada del sistema</p>
                    </div>

                    <!-- Parámetros Generales -->
                    <div class="config-card">
                        <h3 class="config-title">
                            <i class="fas fa-sliders-h"></i>
                            Parámetros Generales
                        </h3>
                        
                        <form id="formParametros">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Nombre del Sistema</label>
                                    <input type="text" class="form-control" value="Sistema de Voluntariado UPT" readonly>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Versión</label>
                                    <input type="text" class="form-control" value="1.0.0" readonly>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Horas Mínimas para Certificado</label>
                                    <input type="number" class="form-control" value="4" min="1" max="24">
                                    <small class="text-muted">Horas mínimas de participación para generar certificado</small>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Días de Anticipación para Inscripción</label>
                                    <input type="number" class="form-control" value="1" min="0" max="30">
                                    <small class="text-muted">Días antes del evento para permitir inscripciones</small>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Correo del Sistema</label>
                                    <input type="email" class="form-control" value="voluntariado@upt.pe">
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Teléfono de Contacto</label>
                                    <input type="tel" class="form-control" value="(052) 583000">
                                </div>
                                
                                <div class="col-12">
                                    <button type="submit" class="btn btn-primary-custom">
                                        <i class="fas fa-save me-2"></i>Guardar Cambios
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Configuración de Notificaciones -->
                    <div class="config-card">
                        <h3 class="config-title">
                            <i class="fas fa-bell"></i>
                            Notificaciones
                        </h3>
                        
                        <div class="alert-info-custom">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Nota:</strong> Configure qué notificaciones se enviarán automáticamente a los usuarios.
                        </div>
                        
                        <table class="table table-custom">
                            <thead>
                                <tr>
                                    <th>Tipo de Notificación</th>
                                    <th>Descripción</th>
                                    <th class="text-center">Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>Nueva Campaña Publicada</strong></td>
                                    <td>Notificar a estudiantes cuando se publique una nueva campaña</td>
                                    <td class="text-center">
                                        <label class="switch">
                                            <input type="checkbox" checked>
                                            <span class="slider"></span>
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Inscripción Confirmada</strong></td>
                                    <td>Notificar al estudiante cuando se confirme su inscripción</td>
                                    <td class="text-center">
                                        <label class="switch">
                                            <input type="checkbox" checked>
                                            <span class="slider"></span>
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Recordatorio de Evento</strong></td>
                                    <td>Recordar 24 horas antes del evento</td>
                                    <td class="text-center">
                                        <label class="switch">
                                            <input type="checkbox" checked>
                                            <span class="slider"></span>
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Certificado Generado</strong></td>
                                    <td>Notificar cuando se genere un certificado</td>
                                    <td class="text-center">
                                        <label class="switch">
                                            <input type="checkbox" checked>
                                            <span class="slider"></span>
                                        </label>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Gestión de Base de Datos -->
                    <div class="config-card">
                        <h3 class="config-title">
                            <i class="fas fa-database"></i>
                            Gestión de Base de Datos
                        </h3>
                        
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Advertencia:</strong> Estas operaciones son sensibles. Asegúrese de tener respaldos antes de proceder.
                        </div>
                        
                        <div class="row g-3">
                            <div class="col-md-4">
                                <div class="d-grid">
                                    <button class="btn btn-success-custom" onclick="respaldarBD()">
                                        <i class="fas fa-download me-2"></i>
                                        Crear Respaldo
                                    </button>
                                    <small class="text-muted mt-2">Exportar copia de seguridad de la BD</small>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <div class="d-grid">
                                    <button class="btn btn-secondary-custom" onclick="verRespaldos()">
                                        <i class="fas fa-history me-2"></i>
                                        Ver Respaldos
                                    </button>
                                    <small class="text-muted mt-2">Lista de respaldos anteriores</small>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <div class="d-grid">
                                    <button class="btn btn-danger-custom" onclick="limpiarDatos()">
                                        <i class="fas fa-broom me-2"></i>
                                        Limpiar Datos Antiguos
                                    </button>
                                    <small class="text-muted mt-2">Eliminar registros de más de 1 año</small>
                                </div>
                            </div>
                        </div>
                        
                        <hr class="my-4">
                        
                        <div class="row">
                            <div class="col-md-6">
                                <h5 class="mb-3"><i class="fas fa-chart-pie me-2"></i>Estadísticas de la Base de Datos</h5>
                                <table class="table table-sm">
                                    <tbody>
                                        <tr>
                                            <td><strong>Total Usuarios:</strong></td>
                                            <td class="text-end"><span class="badge bg-primary">3</span></td>
                                        </tr>
                                        <tr>
                                            <td><strong>Total Campañas:</strong></td>
                                            <td class="text-end"><span class="badge bg-info">5</span></td>
                                        </tr>
                                        <tr>
                                            <td><strong>Total Inscripciones:</strong></td>
                                            <td class="text-end"><span class="badge bg-success">5</span></td>
                                        </tr>
                                        <tr>
                                            <td><strong>Total Certificados:</strong></td>
                                            <td class="text-end"><span class="badge bg-warning">0</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            
                            <div class="col-md-6">
                                <h5 class="mb-3"><i class="fas fa-info-circle me-2"></i>Información del Sistema</h5>
                                <table class="table table-sm">
                                    <tbody>
                                        <tr>
                                            <td><strong>Base de Datos:</strong></td>
                                            <td class="text-end">voluntariado_upt</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Motor:</strong></td>
                                            <td class="text-end">MariaDB 10.4.32</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Última Conexión:</strong></td>
                                            <td class="text-end">Hoy 10:30 AM</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Estado:</strong></td>
                                            <td class="text-end"><span class="badge bg-success">Conectado</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Logs del Sistema -->
                    <div class="config-card">
                        <h3 class="config-title">
                            <i class="fas fa-file-alt"></i>
                            Logs del Sistema
                        </h3>
                        
                        <div class="mb-3">
                            <button class="btn btn-primary-custom btn-sm" onclick="actualizarLogs()">
                                <i class="fas fa-sync-alt me-2"></i>Actualizar
                            </button>
                            <button class="btn btn-secondary-custom btn-sm" onclick="descargarLogs()">
                                <i class="fas fa-download me-2"></i>Descargar
                            </button>
                        </div>
                        
                        <div style="background: #f8f9fa; border-radius: 8px; padding: 1rem; max-height: 300px; overflow-y: auto; font-family: monospace; font-size: 0.85rem;">
                            <div>[2025-10-15 10:30:25] INFO - Usuario 'joan' inició sesión</div>
                            <div>[2025-10-15 10:28:15] INFO - Campaña 'ayuda a gatitos' publicada por coordinador 'victor'</div>
                            <div>[2025-10-15 10:20:10] INFO - Nuevo usuario registrado: 'diego castillo'</div>
                            <div>[2025-10-15 10:15:05] INFO - Sistema iniciado correctamente</div>
                            <div>[2025-10-15 09:00:00] INFO - Respaldo automático completado</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Guardar parámetros
        document.getElementById('formParametros').addEventListener('submit', function(e) {
            e.preventDefault();
            alert('✅ Configuración guardada exitosamente');
        });
        
        // Funciones de gestión de BD
        function respaldarBD() {
            if (confirm('¿Desea crear un respaldo de la base de datos?')) {
                alert('✅ Respaldo creado exitosamente\nArchivo: backup_' + new Date().toISOString().split('T')[0] + '.sql');
            }
        }
        
        function verRespaldos() {
            alert('📋 Lista de Respaldos:\n\n' +
                  '1. backup_2025-10-15.sql (Hoy)\n' +
                  '2. backup_2025-10-10.sql (Hace 5 días)\n' +
                  '3. backup_2025-10-05.sql (Hace 10 días)');
        }
        
        function limpiarDatos() {
            if (confirm('⚠️ ADVERTENCIA\n\nEsta operación eliminará:\n- Campañas antiguas (>1 año)\n- Inscripciones antiguas\n- Certificados antiguos\n\n¿Está seguro de continuar?')) {
                alert('✅ Datos antiguos eliminados\n\n' +
                      'Campañas eliminadas: 0\n' +
                      'Inscripciones eliminadas: 0\n' +
                      'Certificados eliminados: 0');
            }
        }
        
        function actualizarLogs() {
            alert('✅ Logs actualizados');
        }
        
        function descargarLogs() {
            alert('✅ Descargando logs del sistema...\nArchivo: system_logs_' + new Date().toISOString().split('T')[0] + '.txt');
        }
    </script>
</body>
</html>
