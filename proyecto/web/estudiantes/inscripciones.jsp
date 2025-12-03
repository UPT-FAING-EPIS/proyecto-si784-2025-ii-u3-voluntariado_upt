<%-- 
    Document   : inscripciones
    Created on : 29 set. 2025, 10:14:32 p. m.
    Author     : Mi Equipo
    Description: Sistema de Voluntariado UPT - Mis Inscripciones
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="entidad.*"%>
<%@page import="negocio.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    // Validación de sesión
    if (session.getAttribute("usuario") == null || 
        !"ESTUDIANTE".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    Usuario estudiante = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = estudiante.getNombres() + " " + estudiante.getApellidos();
    
    // Inicializar negocio del estudiante
    estudiantenegocio estudianteNeg = new estudiantenegocio();
    
    // Obtener inscripciones del estudiante
    List<Campana> misInscripciones = estudianteNeg.obtenerInscripcionesEstudiante(estudiante.getIdUsuario());
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Inscripciones - Sistema de Voluntariado UPT</title>
    
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
        }
        
        .table-custom {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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
                <a class="nav-link active" href="inscripciones.jsp">
                    <i class="fas fa-list-check me-1"></i>Mis Inscripciones
                </a>
                <a class="nav-link" href="certificados.jsp">
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
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2 class="section-title mb-4">
                    <i class="fas fa-list-check me-2"></i>Mis Inscripciones
                </h2>
                
                <% if (misInscripciones != null && !misInscripciones.isEmpty()) { %>
                    <div class="table-responsive table-custom">
                        <table class="table table-hover mb-0">
                            <thead class="table-primary">
                                <tr>
                                    <th>Campaña</th>
                                    <th>Fecha</th>
                                    <th>Horario</th>
                                    <th>Lugar</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Campana inscripcion : misInscripciones) { %>
                                    <tr>
                                        <td>
                                            <strong><%= inscripcion.getTitulo() %></strong><br>
                                            <small class="text-muted"><%= inscripcion.getDescripcion() %></small>
                                        </td>
                                        <td><%= sdf.format(inscripcion.getFecha()) %></td>
                                        <td>
                                            <%= sdfHora.format(inscripcion.getHoraInicio()) %> - 
                                            <%= sdfHora.format(inscripcion.getHoraFin()) %>
                                        </td>
                                        <td><%= inscripcion.getLugar() %></td>
                                        <td>
                                            <span class="badge bg-success">Inscrito</span>
                                        </td>
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
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="alert alert-info text-center">
                        <i class="fas fa-info-circle fa-2x mb-3"></i>
                        <h5>No tienes inscripciones</h5>
                        <p>Aún no te has inscrito en ninguna campaña.</p>
                        <a href="campañas.jsp" class="btn btn-primary">
                            <i class="fas fa-bullhorn me-1"></i>Ver Campañas Disponibles
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Modal QR -->
    <div class="modal fade" id="qrModal" tabindex="-1" aria-labelledby="qrModalLabel">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="qrModalLabel">
                        <i class="fas fa-qrcode me-2"></i>Código QR de Asistencia
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <div id="qrLoading" class="d-none">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Generando QR...</span>
                        </div>
                        <p class="mt-3">Generando código QR...</p>
                    </div>
                    <div id="qrContent" class="d-none">
                        <img id="qrImage" src="" alt="Código QR" class="img-fluid mb-3" style="max-width: 250px;">
                        <div class="alert alert-info">
                            <small>
                                <i class="fas fa-info-circle me-1"></i>
                                <strong>ID:</strong> <span id="qrInscripcionId"></span><br>
                                <i class="fas fa-clock me-1"></i>
                                <strong>Válido hasta:</strong> <span id="qrValidez"></span>
                            </small>
                        </div>
                        <p class="text-muted small">
                            Presenta este código QR al coordinador para registrar tu asistencia.
                        </p>
                    </div>
                    <div id="qrError" class="d-none">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <span id="qrErrorMessage">Error al generar el código QR</span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-primary" id="downloadQR" onclick="descargarQR()" style="display: none;">
                        <i class="fas fa-download me-1"></i>Descargar
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        let currentQRData = null;
        
        function verDetalleCampana(idCampana) {
            alert('Ver detalles de la campaña ID: ' + idCampana);
        }
        
        function generarQR(idCampana, idUsuario) {
            console.log('Generando QR para campaña:', idCampana, 'usuario:', idUsuario);
            
            // Limpiar estado anterior
            document.getElementById('qrContent').classList.add('d-none');
            document.getElementById('qrError').classList.add('d-none');
            document.getElementById('downloadQR').style.display = 'none';
            currentQRData = null;
            
            // Mostrar modal y loading
            const modal = new bootstrap.Modal(document.getElementById('qrModal'));
            modal.show();
            document.getElementById('qrLoading').classList.remove('d-none');
            
            // Crear parámetros URL
            const params = new URLSearchParams();
            params.append('action', 'generate');
            params.append('idCampana', idCampana);
            params.append('idUsuario', idUsuario);
            
            // Enviar petición al servlet correcto
            fetch('../QRCodeServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params
            })
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                console.log('Respuesta del servidor:', data);
                
                // Ocultar loading
                document.getElementById('qrLoading').classList.add('d-none');
                
                if (data.success) {
                    // Mostrar QR exitoso
                    document.getElementById('qrImage').src = 'data:image/png;base64,' + data.qrCode;
                    document.getElementById('qrInscripcionId').textContent = data.inscripcionId;
                    document.getElementById('qrValidez').textContent = data.validez;
                    document.getElementById('qrContent').classList.remove('d-none');
                    document.getElementById('downloadQR').style.display = 'inline-block';
                    
                    // Guardar datos para descarga
                    currentQRData = {
                        image: data.qrCode,
                        inscripcionId: data.inscripcionId
                    };
                } else {
                    // Mostrar error
                    document.getElementById('qrErrorMessage').textContent = data.message || 'Error desconocido';
                    document.getElementById('qrError').classList.remove('d-none');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                
                // Ocultar loading
                document.getElementById('qrLoading').classList.add('d-none');
                
                // Mostrar error
                document.getElementById('qrErrorMessage').textContent = 'Error de conexión: ' + error.message;
                document.getElementById('qrError').classList.remove('d-none');
            });
        }
        
        function descargarQR() {
            if (!currentQRData) {
                alert('No hay código QR para descargar');
                return;
            }
            
            try {
                // Crear enlace de descarga
                const link = document.createElement('a');
                link.href = 'data:image/png;base64,' + currentQRData.image;
                link.download = 'QR_Asistencia_' + currentQRData.inscripcionId + '.png';
                
                // Simular click para descargar
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
                
                console.log('QR descargado exitosamente');
            } catch (error) {
                console.error('Error descargando QR:', error);
                alert('Error al descargar el código QR');
            }
        }
    </script>
</body>
</html>