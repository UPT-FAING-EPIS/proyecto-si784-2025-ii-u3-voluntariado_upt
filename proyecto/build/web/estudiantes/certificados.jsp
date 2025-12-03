<%-- 
    Document   : certificados
    Created on : 29 set. 2025, 10:14:32 p. m.
    Author     : Mi Equipo
    Description: Sistema de Voluntariado UPT - Mis Certificados
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
<%@page import="java.sql.Timestamp"%>

<%
    // Validación de sesión
    if (session.getAttribute("usuario") == null || 
        !"ESTUDIANTE".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    Usuario estudiante = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = estudiante.getNombres() + " " + estudiante.getApellidos();
    
    // Obtener certificados del estudiante
    List<Map<String, Object>> misCertificados = new ArrayList<>();
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        conn = ConexionDB.getConnection();
        
        String sql = "SELECT " +
                    "    cert.id_certificado, " +
                    "    cert.codigo_verificacion, " +
                    "    cert.fecha_emision, " +
                    "    cert.horas_acreditadas, " +
                    "    cert.hash_qr, " +
                    "    c.titulo AS campana_titulo, " +
                    "    c.descripcion AS campana_descripcion, " +
                    "    c.fecha AS campana_fecha, " +
                    "    c.lugar AS campana_lugar " +
                    "FROM certificados cert " +
                    "INNER JOIN campanas c ON cert.id_campana = c.id_campana " +
                    "WHERE cert.id_estudiante = ? AND cert.activo = 1 " +
                    "ORDER BY cert.fecha_emision DESC";
        
        ps = conn.prepareStatement(sql);
        ps.setInt(1, estudiante.getIdUsuario());
        rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> certificado = new HashMap<>();
            certificado.put("idCertificado", rs.getInt("id_certificado"));
            certificado.put("codigoVerificacion", rs.getString("codigo_verificacion"));
            certificado.put("fechaEmision", rs.getTimestamp("fecha_emision"));
            certificado.put("horasAcreditadas", rs.getInt("horas_acreditadas"));
            certificado.put("hashQR", rs.getString("hash_qr"));
            certificado.put("campanaTitulo", rs.getString("campana_titulo"));
            certificado.put("campanaDescripcion", rs.getString("campana_descripcion"));
            certificado.put("campanaFecha", rs.getDate("campana_fecha"));
            certificado.put("campanaLugar", rs.getString("campana_lugar"));
            misCertificados.add(certificado);
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { }
        if (ps != null) try { ps.close(); } catch (SQLException e) { }
        if (conn != null) ConexionDB.cerrarConexion(conn);
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfCompleto = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Certificados - Sistema de Voluntariado UPT</title>
    
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
        
        .section-title {
            color: var(--primary-color);
            font-weight: 600;
            border-bottom: 3px solid var(--secondary-color);
            padding-bottom: 10px;
            margin-bottom: 2rem;
        }
        
        .certificate-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border-left: 5px solid var(--primary-color);
        }
        
        .certificate-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .certificate-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .certificate-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            box-shadow: 0 4px 15px rgba(0, 61, 122, 0.3);
        }
        
        .certificate-title {
            color: var(--primary-color);
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .certificate-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-item i {
            color: var(--primary-color);
            width: 20px;
        }
        
        .certificate-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .btn-view-cert {
            background: linear-gradient(135deg, var(--info-color) 0%, #138496 100%);
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-view-cert:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(23, 162, 184, 0.3);
            color: white;
        }
        
        .btn-download-cert {
            background: linear-gradient(135deg, var(--success-color) 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-download-cert:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
            color: white;
        }
        
        .hours-badge {
            display: inline-block;
            background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
            color: #333;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 1.1rem;
        }
        
        .code-badge {
            background: rgba(0, 61, 122, 0.1);
            color: var(--primary-color);
            padding: 5px 10px;
            border-radius: 5px;
            font-family: monospace;
            font-size: 0.9rem;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .empty-state i {
            font-size: 5rem;
            color: var(--info-color);
            opacity: 0.5;
            margin-bottom: 1rem;
        }
        
        .stats-summary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0, 61, 122, 0.2);
        }
        
        .stats-summary h3 {
            margin-bottom: 1rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1.5rem;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            display: block;
        }
        
        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
    </style>
</head>

<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container">
            <a class="navbar-brand fw-bold" href="menu_estudiante.jsp">
                <i class="fas fa-graduation-cap me-2"></i>
                Sistema de Voluntariado - EPIS | UPT
            </a>
            
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="menu_estudiante.jsp">
                    <i class="fas fa-home me-1"></i>Dashboard
                </a>
                <a class="nav-link" href="campañas.jsp">
                    <i class="fas fa-bullhorn me-1"></i>Campañas
                </a>
                <a class="nav-link" href="inscripciones.jsp">
                    <i class="fas fa-list-check me-1"></i>Mis Inscripciones
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
    <div class="container mt-4 mb-5">
        <div class="row">
            <div class="col-12">
                <h2 class="section-title">
                    <i class="fas fa-certificate me-2"></i>Mis Certificados
                </h2>
                
                <% if (!misCertificados.isEmpty()) { 
                    // Calcular total de horas
                    int totalHoras = 0;
                    for (Map<String, Object> cert : misCertificados) {
                        totalHoras += (Integer) cert.get("horasAcreditadas");
                    }
                %>
                    <!-- Resumen de estadísticas -->
                    <div class="stats-summary">
                        <h3><i class="fas fa-chart-line me-2"></i>Resumen de Voluntariado</h3>
                        <div class="stats-grid">
                            <div class="stat-item">
                                <span class="stat-value"><%= misCertificados.size() %></span>
                                <span class="stat-label">Certificados Obtenidos</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value"><%= totalHoras %></span>
                                <span class="stat-label">Horas Totales</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value">
                                    <i class="fas fa-trophy"></i>
                                </span>
                                <span class="stat-label">Compromiso Social</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Lista de certificados -->
                    <% for (Map<String, Object> certificado : misCertificados) { 
                        String codigoVerificacion = (String) certificado.get("codigoVerificacion");
                        Timestamp fechaEmision = (Timestamp) certificado.get("fechaEmision");
                        int horasAcreditadas = (Integer) certificado.get("horasAcreditadas");
                        String campanaTitulo = (String) certificado.get("campanaTitulo");
                        String campanaDescripcion = (String) certificado.get("campanaDescripcion");
                        Date campanaFecha = (Date) certificado.get("campanaFecha");
                        String campanaLugar = (String) certificado.get("campanaLugar");
                    %>
                        <div class="certificate-card">
                            <div class="certificate-header">
                                <div class="d-flex align-items-start gap-3 flex-grow-1">
                                    <div class="certificate-icon">
                                        <i class="fas fa-award"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <h3 class="certificate-title"><%= campanaTitulo %></h3>
                                        <p class="text-muted mb-2"><%= campanaDescripcion %></p>
                                        <span class="hours-badge">
                                            <i class="fas fa-clock me-1"></i>
                                            <%= horasAcreditadas %> horas acreditadas
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="certificate-info">
                                <div class="info-item">
                                    <i class="fas fa-calendar-alt"></i>
                                    <span><strong>Fecha Campaña:</strong> <%= sdf.format(campanaFecha) %></span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span><strong>Lugar:</strong> <%= campanaLugar %></span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-calendar-check"></i>
                                    <span><strong>Emitido:</strong> <%= sdfCompleto.format(fechaEmision) %></span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-shield-alt"></i>
                                    <span><strong>Código:</strong> <span class="code-badge"><%= codigoVerificacion %></span></span>
                                </div>
                            </div>
                            
                            <div class="certificate-actions">
                                <button class="btn btn-view-cert btn-ver-certificado-estudiante" 
                                        data-nombre="<%= nombreCompleto %>" 
                                        data-campana="<%= campanaTitulo %>" 
                                        data-fecha="<%= sdf.format(campanaFecha) %>" 
                                        data-horas="<%= horasAcreditadas %>" 
                                        data-codigo="<%= codigoVerificacion %>">
                                    <i class="fas fa-eye me-2"></i>Ver Certificado
                                </button>
                                <button class="btn btn-download-cert" onclick="descargarCertificado('<%= codigoVerificacion %>')">
                                    <i class="fas fa-download me-2"></i>Descargar PDF
                                </button>
                                <button class="btn btn-outline-secondary" onclick="compartirCertificado('<%= codigoVerificacion %>')">
                                    <i class="fas fa-share-alt me-2"></i>Compartir
                                </button>
                            </div>
                        </div>
                    <% } %>
                    
                <% } else { %>
                    <!-- Estado vacío -->
                    <div class="empty-state">
                        <i class="fas fa-certificate"></i>
                        <h4>No tienes certificados aún</h4>
                        <p class="text-muted mb-4">
                            Los certificados aparecerán aquí cuando completes las campañas de voluntariado<br>
                            y el coordinador emita tu certificado de participación.
                        </p>
                        <a href="campañas.jsp" class="btn btn-primary btn-lg">
                            <i class="fas fa-bullhorn me-2"></i>Ver Campañas Disponibles
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- Modal para Vista Previa de Certificado -->
    <div class="modal fade" id="previewModal" tabindex="-1" aria-labelledby="previewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="previewModalLabel">
                        <i class="fas fa-certificate me-2"></i>Mi Certificado
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
                    <button type="button" class="btn btn-success" id="btnDescargarPDF">
                        <i class="fas fa-download me-2"></i>Descargar PDF
                    </button>
                    <button type="button" class="btn btn-primary" id="btnCompartir">
                        <i class="fas fa-share-alt me-2"></i>Compartir
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Event listener para botones de ver certificado
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('btn-ver-certificado-estudiante') || e.target.closest('.btn-ver-certificado-estudiante')) {
                const btn = e.target.classList.contains('btn-ver-certificado-estudiante') ? e.target : e.target.closest('.btn-ver-certificado-estudiante');
                const nombreEstudiante = btn.getAttribute('data-nombre');
                const campanaTitulo = btn.getAttribute('data-campana');
                const fechaCampana = btn.getAttribute('data-fecha');
                const horasAcreditadas = btn.getAttribute('data-horas');
                const codigoVerificacion = btn.getAttribute('data-codigo');
                
                verCertificado(nombreEstudiante, campanaTitulo, fechaCampana, horasAcreditadas, codigoVerificacion);
            }
        });
        
        
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
            previewContent.innerHTML = `
                <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 3rem;">
                    <div style="background: white; max-width: 900px; margin: 0 auto; padding: 0; box-shadow: 0 20px 60px rgba(0,0,0,0.3); border-radius: 10px; overflow: hidden;">
                        
                        <!-- Header con borde decorativo -->
                        <div style="background: linear-gradient(135deg, #003D7A 0%, #0066CC 100%); padding: 2rem; position: relative;">
                            <div style="position: absolute; top: 0; left: 0; right: 0; height: 8px; background: linear-gradient(90deg, #FFD700, #FFA500, #FFD700);"></div>
                            <div style="text-align: center; color: white;">
                                <div style="display: flex; align-items: center; justify-content: center; gap: 1rem; margin-bottom: 1rem;">
                                    <img src="<%= request.getContextPath() %>/img/upt.jpeg" alt="UPT Logo" style="height: 3rem;">
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
                                    <img src="<%= request.getContextPath() %>/img/coordinador.jpg" alt="Firma Coordinador" style="max-width: 200px; margin-bottom: 0.5rem;">
                                    <div style="border-top: 2px solid #333; padding-top: 0.5rem; margin: 0 auto; max-width: 250px;">
                                        <p style="margin: 0; font-weight: 600; color: #003D7A;">Coordinador de Voluntariado</p>
                                        <p style="margin: 0.25rem 0 0 0; font-size: 0.9rem; color: #666;">Universidad Privada de Tacna</p>
                                    </div>
                                </div>
                                <div style="text-align: center;">
                                    <img src="<%= request.getContextPath() %>/img/director.jpeg" alt="Firma Director" style="max-width: 200px; margin-bottom: 0.5rem;">
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
            
            // Configurar botones del modal
            document.getElementById('btnDescargarPDF').onclick = function() {
                descargarCertificado(codigoVerificacion);
            };
            
            document.getElementById('btnCompartir').onclick = function() {
                compartirCertificado(codigoVerificacion);
            };
            
            modal.show();
        }
        
        // Descargar certificado
        function descargarCertificado(codigoVerificacion) {
            window.open('<%= request.getContextPath() %>/DescargarCertificadoServlet?codigo=' + codigoVerificacion, '_blank');
        }
        
        // Compartir certificado
        function compartirCertificado(codigoVerificacion) {
            if (navigator.share) {
                navigator.share({
                    title: 'Mi Certificado de Voluntariado - UPT',
                    text: 'He obtenido un certificado de voluntariado. Código: ' + codigoVerificacion,
                    url: window.location.href
                }).then(() => {
                    console.log('Certificado compartido');
                }).catch((error) => {
                    console.log('Error al compartir:', error);
                });
            } else {
                // Fallback: copiar al portapapeles
                const url = window.location.origin + '/verificar?codigo=' + codigoVerificacion;
                navigator.clipboard.writeText(url).then(() => {
                    alert('Enlace copiado al portapapeles');
                });
            }
        }
    </script>
</body>
</html>