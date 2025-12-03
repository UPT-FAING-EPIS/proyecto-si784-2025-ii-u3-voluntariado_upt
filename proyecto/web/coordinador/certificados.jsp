<%-- 
    Document   : certificados
    Created on : 15 oct. 2025, 10:00:00 p. m.
    Author     : Mi Equipo
    Description: Sistema de Voluntariado UPT - Gestión de Certificados
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="entidad.*"%>
<%@page import="conexion.ConexionDB"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Time"%>
<%@page import="java.sql.Timestamp"%>

<%
    // Validación de sesión
    if (session.getAttribute("usuario") == null || 
        !"COORDINADOR".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    Usuario coordinador = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = coordinador.getNombres() + " " + coordinador.getApellidos();
    
    // Obtener estudiantes con asistencia registrada en campañas del coordinador
    List<Map<String, Object>> estudiantesConAsistencia = new ArrayList<>();
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        conn = ConexionDB.getConnection();
        
        String sql = "SELECT DISTINCT " +
                    "    u.id_usuario, " +
                    "    u.nombres, " +
                    "    u.apellidos, " +
                    "    u.codigo, " +
                    "    u.correo, " +
                    "    c.id_campana, " +
                    "    c.titulo AS campana_titulo, " +
                    "    c.fecha AS campana_fecha, " +
                    "    c.hora_inicio, " +
                    "    c.hora_fin, " +
                    "    a.id_asistencia, " +
                    "    a.fecha_registro, " +
                    "    IFNULL(cert.id_certificado, 0) AS tiene_certificado, " +
                    "    cert.codigo_verificacion, " +
                    "    cert.fecha_emision " +
                    "FROM asistencias a " +
                    "INNER JOIN usuarios u ON a.id_estudiante = u.id_usuario " +
                    "INNER JOIN campanas c ON a.id_campana = c.id_campana " +
                    "LEFT JOIN certificados cert ON cert.id_estudiante = u.id_usuario AND cert.id_campana = c.id_campana " +
                    "WHERE c.id_coordinador = ? " +
                    "    AND a.presente = 1 " +
                    "ORDER BY c.fecha DESC, u.apellidos, u.nombres";
        
        ps = conn.prepareStatement(sql);
        ps.setInt(1, coordinador.getIdUsuario());
        rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> registro = new HashMap<>();
            registro.put("idEstudiante", rs.getInt("id_usuario"));
            registro.put("nombreEstudiante", rs.getString("nombres") + " " + rs.getString("apellidos"));
            registro.put("codigoEstudiante", rs.getString("codigo"));
            registro.put("correoEstudiante", rs.getString("correo"));
            registro.put("idCampana", rs.getInt("id_campana"));
            registro.put("campanaTitulo", rs.getString("campana_titulo"));
            registro.put("campanaFecha", rs.getDate("campana_fecha"));
            registro.put("horaInicio", rs.getTime("hora_inicio"));
            registro.put("horaFin", rs.getTime("hora_fin"));
            registro.put("fechaAsistencia", rs.getTimestamp("fecha_registro"));
            registro.put("tieneCertificado", rs.getInt("tiene_certificado") > 0);
            registro.put("codigoVerificacion", rs.getString("codigo_verificacion"));
            registro.put("fechaEmision", rs.getTimestamp("fecha_emision"));
            estudiantesConAsistencia.add(registro);
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { }
        if (ps != null) try { ps.close(); } catch (SQLException e) { }
        if (conn != null) ConexionDB.cerrarConexion(conn);
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdfCompleto = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    
    // Contar certificados emitidos y pendientes
    int certificadosEmitidos = 0;
    int certificadosPendientes = 0;
    for (Map<String, Object> reg : estudiantesConAsistencia) {
        if ((Boolean) reg.get("tieneCertificado")) {
            certificadosEmitidos++;
        } else {
            certificadosPendientes++;
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Certificados - Sistema de Voluntariado UPT</title>
    
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
        
        .content-wrapper {
            padding: 2rem;
        }
        
        .page-header {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .page-title {
            color: var(--primary-color);
            font-weight: 700;
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
            color: white;
        }
        
        .stats-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .stats-label {
            color: #6C757D;
            font-size: 0.9rem;
        }
        
        .filter-section {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .table-container {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .table th {
            background-color: var(--light-bg);
            color: var(--primary-color);
            font-weight: 600;
            border: none;
        }
        
        .table tbody tr:hover {
            background-color: rgba(0, 61, 122, 0.05);
        }
        
        .badge-certificado {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.85rem;
        }
        
        .badge-emitido {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .badge-pendiente {
            background-color: rgba(255, 193, 7, 0.1);
            color: var(--warning-color);
        }
        
        .btn-generate {
            background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-generate:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
            color: white;
        }
        
        .btn-view {
            background: linear-gradient(135deg, var(--info-color) 0%, #138496 100%);
            border: none;
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-view:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(23, 162, 184, 0.3);
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6C757D;
        }
        
        .empty-state i {
            font-size: 4rem;
            opacity: 0.3;
            margin-bottom: 1rem;
        }
    </style>
</head>

<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand fw-bold" href="menu_coordinador.jsp">
                <i class="fas fa-hands-helping me-2"></i>
                Sistema de Voluntariado - UPT
            </a>
            
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="menu_coordinador.jsp">
                    <i class="fas fa-home me-1"></i>Dashboard
                </a>
                <a class="nav-link active" href="certificados.jsp">
                    <i class="fas fa-certificate me-1"></i>Certificados
                </a>
                <div class="dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user me-1"></i><%= nombreCompleto %>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="../index.jsp">
                            <i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión
                        </a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container-fluid content-wrapper">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-certificate me-2"></i>Gestión de Certificados
            </h1>
            <p class="text-muted">Genera y gestiona certificados para estudiantes que completaron campañas</p>
        </div>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stats-value"><%= estudiantesConAsistencia.size() %></div>
                    <div class="stats-label">Total con Asistencia</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);">
                        <i class="fas fa-certificate"></i>
                    </div>
                    <div class="stats-value">
                        <%= certificadosEmitidos %>
                    </div>
                    <div class="stats-label">Certificados Emitidos</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, var(--warning-color) 0%, #fd7e14 100%);">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stats-value">
                        <%= certificadosPendientes %>
                    </div>
                    <div class="stats-label">Pendientes</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, var(--info-color) 0%, #138496 100%);">
                        <i class="fas fa-download"></i>
                    </div>
                    <div class="stats-value">0</div>
                    <div class="stats-label">Descargas</div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="filter-section">
            <div class="row">
                <div class="col-md-4">
                    <label class="form-label">Filtrar por Campaña</label>
                    <select class="form-select" id="filtroCampana">
                        <option value="">Todas las campañas</option>
                        <% 
                        Set<String> campanas = new HashSet<>();
                        for (Map<String, Object> reg : estudiantesConAsistencia) {
                            campanas.add((String) reg.get("campanaTitulo"));
                        }
                        for (String campana : campanas) {
                        %>
                            <option value="<%= campana %>"><%= campana %></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Filtrar por Estado</label>
                    <select class="form-select" id="filtroEstado">
                        <option value="">Todos</option>
                        <option value="emitido">Certificados Emitidos</option>
                        <option value="pendiente">Pendientes</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Buscar Estudiante</label>
                    <input type="text" class="form-control" id="searchEstudiante" placeholder="Nombre o código...">
                </div>
            </div>
            
            <div class="row mt-3">
                <div class="col-12">
                    <button class="btn btn-primary" id="btnGenerarTodos" onclick="generarTodosPendientes(event)">
                        <i class="fas fa-certificate me-2"></i>Generar Todos los Pendientes
                    </button>
                    <button class="btn btn-outline-secondary ms-2" onclick="exportarReporte()">
                        <i class="fas fa-file-excel me-2"></i>Exportar Reporte
                    </button>
                </div>
            </div>
        </div>

        <!-- Table -->
        <div class="table-container">
            <h5 class="mb-3"><i class="fas fa-list me-2"></i>Estudiantes con Asistencia Registrada</h5>
            
            <div class="table-responsive">
                <table class="table table-hover" id="tablaCertificados">
                    <thead>
                        <tr>
                            <th>Estudiante</th>
                            <th>Código</th>
                            <th>Campaña</th>
                            <th>Fecha Campaña</th>
                            <th>Horas</th>
                            <th>Asistencia</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (estudiantesConAsistencia.isEmpty()) { %>
                            <tr>
                                <td colspan="8">
                                    <div class="empty-state">
                                        <i class="fas fa-certificate"></i>
                                        <h5>No hay registros de asistencia</h5>
                                        <p>Los certificados se generan para estudiantes con asistencia confirmada.</p>
                                    </div>
                                </td>
                            </tr>
                        <% } else { 
                            for (Map<String, Object> registro : estudiantesConAsistencia) {
                                int idEstudiante = (Integer) registro.get("idEstudiante");
                                int idCampana = (Integer) registro.get("idCampana");
                                String nombreEstudiante = (String) registro.get("nombreEstudiante");
                                String codigoEstudiante = (String) registro.get("codigoEstudiante");
                                String campanaTitulo = (String) registro.get("campanaTitulo");
                                Date campanaFecha = (Date) registro.get("campanaFecha");
                                Time horaInicio = (Time) registro.get("horaInicio");
                                Time horaFin = (Time) registro.get("horaFin");
                                Timestamp fechaAsistencia = (Timestamp) registro.get("fechaAsistencia");
                                boolean tieneCertificado = (Boolean) registro.get("tieneCertificado");
                                String codigoVerificacion = (String) registro.get("codigoVerificacion");
                                
                                // Calcular horas acreditadas
                                long diffMillis = horaFin.getTime() - horaInicio.getTime();
                                int horasAcreditadas = (int) (diffMillis / (1000 * 60 * 60));
                        %>
                            <tr data-campana="<%= campanaTitulo %>" data-estado="<%= tieneCertificado ? "emitido" : "pendiente" %>">
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" 
                                             style="width: 35px; height: 35px; font-size: 0.8rem;">
                                            <%= nombreEstudiante.substring(0, 1).toUpperCase() %>
                                        </div>
                                        <strong><%= nombreEstudiante %></strong>
                                    </div>
                                </td>
                                <td><%= codigoEstudiante != null ? codigoEstudiante : "N/A" %></td>
                                <td><%= campanaTitulo %></td>
                                <td><%= sdf.format(campanaFecha) %></td>
                                <td><%= horasAcreditadas %> hrs</td>
                                <td><small class="text-muted"><%= sdfCompleto.format(fechaAsistencia) %></small></td>
                                <td>
                                    <% if (tieneCertificado) { %>
                                        <span class="badge-certificado badge-emitido">
                                            <i class="fas fa-check-circle me-1"></i>Emitido
                                        </span>
                                    <% } else { %>
                                        <span class="badge-certificado badge-pendiente">
                                            <i class="fas fa-clock me-1"></i>Pendiente
                                        </span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (tieneCertificado) { 
                                        // Escapar comillas para evitar conflictos
                                        String nombreEscapado = nombreEstudiante.replace("\"", "&quot;").replace("'", "&#39;");
                                        String campanaEscapada = campanaTitulo.replace("\"", "&quot;").replace("'", "&#39;");
                                    %>
                                        <button class="btn btn-sm btn-view btn-ver-certificado" 
                                                data-nombre="<%= nombreEscapado %>" 
                                                data-campana="<%= campanaEscapada %>" 
                                                data-fecha="<%= sdf.format(campanaFecha) %>" 
                                                data-horas="<%= horasAcreditadas %>" 
                                                data-codigo="<%= codigoVerificacion %>">
                                            <i class="fas fa-eye me-1"></i>Ver
                                        </button>
                                        <button class="btn btn-sm btn-outline-secondary" onclick="descargarCertificado('<%= codigoVerificacion %>')">
                                            <i class="fas fa-download"></i>
                                        </button>
                                    <% } else { %>
                                        <button class="btn btn-sm btn-generate" 
                                                onclick="generarCertificado(<%= idEstudiante %>, <%= idCampana %>, <%= horasAcreditadas %>)">
                                            <i class="fas fa-plus me-1"></i>Generar
                                        </button>
                                    <% } %>
                                </td>
                            </tr>
                        <% 
                            }
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal para Vista Previa de Certificado -->
    <div class="modal fade" id="previewModal" tabindex="-1" aria-labelledby="previewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="previewModalLabel">
                        <i class="fas fa-certificate me-2"></i>Vista Previa del Certificado
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-0" id="previewContent">
                    <!-- Contenido dinámico del certificado -->
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Cerrar
                    </button>
                    <button type="button" class="btn btn-primary" id="btnDescargarPDF">
                        <i class="fas fa-download me-2"></i>Descargar PDF
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Filtrar tabla
        document.getElementById('filtroCampana').addEventListener('change', filtrarTabla);
        document.getElementById('filtroEstado').addEventListener('change', filtrarTabla);
        document.getElementById('searchEstudiante').addEventListener('input', filtrarTabla);
        
        // Event listener para botones de ver certificado
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('btn-ver-certificado') || e.target.closest('.btn-ver-certificado')) {
                const btn = e.target.classList.contains('btn-ver-certificado') ? e.target : e.target.closest('.btn-ver-certificado');
                const nombreEstudiante = btn.getAttribute('data-nombre');
                const campanaTitulo = btn.getAttribute('data-campana');
                const fechaCampana = btn.getAttribute('data-fecha');
                const horasAcreditadas = btn.getAttribute('data-horas');
                const codigoVerificacion = btn.getAttribute('data-codigo');
                
                // Debug: ver qué valores se obtienen
                console.log('Nombre:', nombreEstudiante);
                console.log('Campaña:', campanaTitulo);
                console.log('Fecha:', fechaCampana);
                console.log('Horas:', horasAcreditadas);
                console.log('Código:', codigoVerificacion);
                
                verCertificado(nombreEstudiante, campanaTitulo, fechaCampana, horasAcreditadas, codigoVerificacion);
            }
        });
        
        function filtrarTabla() {
            const filtroCampana = document.getElementById('filtroCampana').value.toLowerCase();
            const filtroEstado = document.getElementById('filtroEstado').value;
            const searchEstudiante = document.getElementById('searchEstudiante').value.toLowerCase();
            
            const filas = document.querySelectorAll('#tablaCertificados tbody tr');
            
            filas.forEach(fila => {
                if (fila.cells.length === 1) return; // Skip empty state row
                
                const campana = fila.dataset.campana.toLowerCase();
                const estado = fila.dataset.estado;
                const estudiante = fila.cells[0].textContent.toLowerCase();
                const codigo = fila.cells[1].textContent.toLowerCase();
                
                let mostrar = true;
                
                if (filtroCampana && !campana.includes(filtroCampana)) {
                    mostrar = false;
                }
                
                if (filtroEstado && estado !== filtroEstado) {
                    mostrar = false;
                }
                
                if (searchEstudiante && !estudiante.includes(searchEstudiante) && !codigo.includes(searchEstudiante)) {
                    mostrar = false;
                }
                
                fila.style.display = mostrar ? '' : 'none';
            });
        }
        
        // Generar certificado individual
        function generarCertificado(idEstudiante, idCampana, horasAcreditadas) {
            if (!confirm('¿Generar certificado para este estudiante?')) {
                return;
            }
            
            const formData = new URLSearchParams();
            formData.append('action', 'generarCertificado');
            formData.append('idEstudiante', idEstudiante);
            formData.append('idCampana', idCampana);
            formData.append('horasAcreditadas', horasAcreditadas);
            
            fetch('<%= request.getContextPath() %>/CertificadoServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Certificado generado exitosamente');
                    location.reload();
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error al generar certificado');
            });
        }
        
        // Generar todos los pendientes
        function generarTodosPendientes(e) {
            e.preventDefault();
            
            const pendientes = document.querySelectorAll('[data-estado="pendiente"]');
            
            if (pendientes.length === 0) {
                alert('ℹ️ No hay certificados pendientes por generar');
                return;
            }
            
            if (!confirm(`¿Generar ${pendientes.length} certificado${pendientes.length > 1 ? 's' : ''} pendiente${pendientes.length > 1 ? 's' : ''}?\n\n⚠️ Esto puede tomar unos momentos.\n\n✓ Presiona OK para continuar`)) {
                return;
            }
            
            // Mostrar loading en el botón
            const btnGenerar = document.getElementById('btnGenerarTodos');
            const textoOriginal = btnGenerar.innerHTML;
            btnGenerar.disabled = true;
            btnGenerar.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Generando certificados...';
            btnGenerar.classList.remove('btn-primary');
            btnGenerar.classList.add('btn-warning');
            
            console.log('Iniciando generación masiva de certificados...');
            
            const formData = new URLSearchParams();
            formData.append('action', 'generarTodosPendientes');
            
            fetch('<%= request.getContextPath() %>/CertificadoServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: formData
            })
            .then(response => {
                console.log('Respuesta recibida, status:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('Datos recibidos:', data);
                
                btnGenerar.disabled = false;
                btnGenerar.innerHTML = textoOriginal;
                btnGenerar.classList.remove('btn-warning');
                btnGenerar.classList.add('btn-primary');
                
                if (data.success) {
                    let mensaje = `✅ ¡Proceso completado exitosamente!\n\n`;
                    mensaje += `📊 Resultados:\n`;
                    mensaje += `✓ Certificados generados: ${data.generados}\n`;
                    
                    if (data.errores > 0) {
                        mensaje += `✗ Errores encontrados: ${data.errores}\n`;
                    }
                    
                    mensaje += `\n🔄 La página se recargará automáticamente para mostrar los cambios.`;
                    
                    alert(mensaje);
                    
                    // Recargar después de 1 segundo
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                } else {
                    alert('❌ Error al generar certificados\n\n' + data.message);
                }
            })
            .catch(error => {
                console.error('Error en la petición:', error);
                
                btnGenerar.disabled = false;
                btnGenerar.innerHTML = textoOriginal;
                btnGenerar.classList.remove('btn-warning');
                btnGenerar.classList.add('btn-primary');
                
                alert('❌ Error de conexión\n\nNo se pudo completar la operación.\nDetalles: ' + error.message);
            });
        }
        
        // Ver certificado
        function verCertificado(nombreEstudiante, campanaTitulo, fechaCampana, horasAcreditadas, codigoVerificacion) {
            const modal = new bootstrap.Modal(document.getElementById('previewModal'));
            const previewContent = document.getElementById('previewContent');
            
            // Obtener fecha actual
            const fechaActual = new Date().toLocaleDateString('es-ES', { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            });
            
            // Crear el certificado HTML con diseño bonito
            const certificadoHTML = `
                <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 3rem;">
                    <div style="background: white; max-width: 900px; margin: 0 auto; padding: 0; box-shadow: 0 20px 60px rgba(0,0,0,0.3); border-radius: 10px; overflow: hidden;">
                        
                        <!-- Header con borde decorativo -->
                        <div style="background: linear-gradient(135deg, #003D7A 0%, #0066CC 100%); padding: 2rem; position: relative;">
                            <div style="position: absolute; top: 0; left: 0; right: 0; height: 8px; background: linear-gradient(90deg, #FFD700, #FFA500, #FFD700);"></div>
                            <div style="text-align: center; color: white;">
                                <div style="display: flex; align-items: center; justify-content: center; gap: 1.5rem; margin-bottom: 1rem;">
                                    <img src="<%= request.getContextPath() %>/img/upt.jpeg" alt="UPT Logo" style="height: 80px;">
                                </div>
                                <h2 style="margin: 0; font-size: 2rem; font-weight: 700; letter-spacing: 2px;">
                                    UNIVERSIDAD PRIVADA DE TACNA
                                </h2>
                                <p style="margin: 0.5rem 0 0 0; font-size: 1.1rem; opacity: 0.9;">
                                    Sistema de Voluntariado Universitario
                                </p>
                            </div>
                        </div>
                        
                        <!-- Contenido del certificado -->
                        <div style="padding: 3rem 4rem;">
                            
                            <!-- Título del certificado -->
                            <div style="text-align: center; margin-bottom: 2rem;">
                                <div style="display: inline-block; position: relative;">
                                    <h1 style="color: #003D7A; font-size: 3rem; font-weight: 700; margin: 0; letter-spacing: 3px; text-transform: uppercase;">
                                        CERTIFICADO
                                    </h1>
                                    <div style="height: 4px; background: linear-gradient(90deg, transparent, #FFD700, transparent); margin-top: 0.5rem;"></div>
                                </div>
                                <p style="color: #666; font-size: 1rem; margin-top: 1rem; font-style: italic;">
                                    de Reconocimiento por Participación en Actividad de Voluntariado
                                </p>
                            </div>
                            
                            <!-- Texto principal -->
                            <div style="text-align: center; margin: 2rem 0; line-height: 2;">
                                <p style="font-size: 1.1rem; color: #333; margin-bottom: 1.5rem;">
                                    La Universidad Privada de Tacna otorga el presente certificado a:
                                </p>
                                
                                <!-- Nombre del estudiante -->
                                <div style="margin: 2rem 0;">
                                    <div style="border-bottom: 3px solid #003D7A; display: inline-block; min-width: 400px; padding-bottom: 0.5rem;">
                                        <h2 style="color: #003D7A; font-size: 2.5rem; font-weight: 700; margin: 0; text-transform: uppercase;">
                                            ` + nombreEstudiante + `
                                        </h2>
                                    </div>
                                </div>
                                
                                <!-- Descripción -->
                                <p style="font-size: 1.1rem; color: #333; margin: 2rem auto; max-width: 600px; line-height: 1.8;">
                                    Por su destacada participación en la campaña de voluntariado 
                                    <strong style="color: #003D7A;">"` + campanaTitulo + `"</strong>, 
                                    realizada el <strong>` + fechaCampana + `</strong>, 
                                    acreditando un total de <strong style="color: #0066CC; font-size: 1.3rem;">` + horasAcreditadas + ` horas</strong> 
                                    de servicio comunitario.
                                </p>
                                
                                <p style="font-size: 1rem; color: #666; margin-top: 2rem;">
                                    Reconocemos su compromiso con la responsabilidad social y el servicio a la comunidad.
                                </p>
                            </div>
                            
                            <!-- Línea decorativa -->
                            <div style="height: 2px; background: linear-gradient(90deg, transparent, #003D7A, transparent); margin: 2rem 0;"></div>
                            
                            <!-- Firmas -->
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 3rem; margin: 3rem 0 2rem 0;">
                                <div style="text-align: center;">
                                    <img src="<%= request.getContextPath() %>/img/coordinador.jpg" alt="Firma Coordinador" style="max-width: 200px; height: auto; margin-bottom: 0.5rem;">
                                    <div style="border-top: 2px solid #333; padding-top: 0.5rem; margin: 0 auto; max-width: 250px;">
                                        <p style="margin: 0; font-weight: 600; color: #003D7A;">Coordinador de Voluntariado</p>
                                        <p style="margin: 0.25rem 0 0 0; font-size: 0.9rem; color: #666;">Universidad Privada de Tacna</p>
                                    </div>
                                </div>
                                <div style="text-align: center;">
                                    <img src="<%= request.getContextPath() %>/img/director.jpeg" alt="Firma Director" style="max-width: 200px; height: auto; margin-bottom: 0.5rem;">
                                    <div style="border-top: 2px solid #333; padding-top: 0.5rem; margin: 0 auto; max-width: 250px;">
                                        <p style="margin: 0; font-weight: 600; color: #003D7A;">Director de Responsabilidad Social</p>
                                        <p style="margin: 0.25rem 0 0 0; font-size: 0.9rem; color: #666;">Universidad Privada de Tacna</p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Footer con código de verificación -->
                            <div style="margin-top: 3rem; padding-top: 2rem; border-top: 1px solid #e0e0e0;">
                                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                                    <div style="text-align: left;">
                                        <p style="margin: 0; font-size: 0.85rem; color: #666;">
                                            <i class="fas fa-calendar-alt" style="color: #003D7A; margin-right: 0.5rem;"></i>
                                            Fecha de emisión: <strong>` + fechaActual + `</strong>
                                        </p>
                                    </div>
                                    <div style="text-align: right;">
                                        <p style="margin: 0; font-size: 0.85rem; color: #666;">
                                            <i class="fas fa-shield-alt" style="color: #003D7A; margin-right: 0.5rem;"></i>
                                            Código de verificación: <strong style="color: #0066CC;">` + codigoVerificacion + `</strong>
                                        </p>
                                    </div>
                                </div>
                                
                                <!-- QR Code placeholder -->
                                <div style="text-align: center; margin-top: 1.5rem;">
                                    <div style="display: inline-block; padding: 1rem; background: #f8f9fa; border-radius: 8px;">
                                        <i class="fas fa-qrcode" style="font-size: 3rem; color: #003D7A;"></i>
                                        <p style="margin: 0.5rem 0 0 0; font-size: 0.75rem; color: #666;">
                                            Escanea para verificar autenticidad
                                        </p>
                                    </div>
                                </div>
                            </div>
                            
                        </div>
                        
                        <!-- Footer decorativo -->
                        <div style="background: linear-gradient(135deg, #003D7A 0%, #0066CC 100%); padding: 1.5rem; text-align: center; color: white;">
                            <p style="margin: 0; font-size: 0.9rem; opacity: 0.9;">
                                <i class="fas fa-hands-helping" style="margin-right: 0.5rem;"></i>
                                "El voluntariado es la expresión del compromiso del ciudadano con su comunidad"
                            </p>
                        </div>
                        
                        <!-- Borde inferior decorativo -->
                        <div style="height: 8px; background: linear-gradient(90deg, #FFD700, #FFA500, #FFD700);"></div>
                    </div>
                </div>
            `;
            
            previewContent.innerHTML = certificadoHTML;
            
            // Configurar botón de descarga
            document.getElementById('btnDescargarPDF').onclick = function() {
                descargarCertificado(codigoVerificacion);
            };
            
            modal.show();
        }
        
        // Descargar certificado
        function descargarCertificado(codigoVerificacion) {
            window.open('<%= request.getContextPath() %>/DescargarCertificadoServlet?codigo=' + codigoVerificacion, '_blank');
        }
        
        // Exportar reporte
        function exportarReporte() {
            alert('Función de exportación en desarrollo');
        }
    </script>
</body>
</html>
