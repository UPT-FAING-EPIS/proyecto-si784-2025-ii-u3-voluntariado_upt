<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entidad.Usuario"%>
<%@page import="entidad.Campana"%>
<%@page import="negocio.coordinadornegocio"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Time"%>

<%
    // Verificar sesión del coordinador
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null || !"COORDINADOR".equals(usuario.getRol())) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    String mensaje = "";
    String tipoMensaje = "";
    
    // Procesar formulario si se envió
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            String titulo = request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion");
            String fechaStr = request.getParameter("fecha");
            String horaInicioStr = request.getParameter("horaInicio");
            String horaFinStr = request.getParameter("horaFin");
            String lugar = request.getParameter("lugar");
            String cuposTotalStr = request.getParameter("cuposTotal");
            String requisitos = request.getParameter("requisitos");
            
            // Validaciones básicas
            if (titulo == null || titulo.trim().isEmpty() ||
                descripcion == null || descripcion.trim().isEmpty() ||
                fechaStr == null || fechaStr.trim().isEmpty() ||
                horaInicioStr == null || horaInicioStr.trim().isEmpty() ||
                horaFinStr == null || horaFinStr.trim().isEmpty() ||
                lugar == null || lugar.trim().isEmpty() ||
                cuposTotalStr == null || cuposTotalStr.trim().isEmpty()) {
                
                mensaje = "Todos los campos son obligatorios";
                tipoMensaje = "error";
            } else {
                // Convertir datos
                Date fecha = Date.valueOf(fechaStr);
                Time horaInicio = Time.valueOf(horaInicioStr + ":00");
                Time horaFin = Time.valueOf(horaFinStr + ":00");
                int cuposTotal = Integer.parseInt(cuposTotalStr);
                
                // Validar que la hora de fin sea posterior a la de inicio
                if (horaFin.before(horaInicio)) {
                    mensaje = "La hora de fin debe ser posterior a la hora de inicio";
                    tipoMensaje = "error";
                } else if (cuposTotal <= 0) {
                    mensaje = "El número de cupos debe ser mayor a 0";
                    tipoMensaje = "error";
                } else {
                    // Crear campaña
                    Campana nuevaCampana = new Campana(titulo, descripcion, fecha, horaInicio, 
                                                     horaFin, lugar, cuposTotal, requisitos, 
                                                     usuario.getIdUsuario());
                    
                    coordinadornegocio negocio = new coordinadornegocio();
                    boolean exito = negocio.crearCampana(nuevaCampana);
                    
                    if (exito) {
                        mensaje = "Campaña creada exitosamente";
                        tipoMensaje = "success";
                        // Limpiar formulario después del éxito
                        request.setAttribute("limpiarFormulario", true);
                    } else {
                        mensaje = "Error al crear la campaña. Intente nuevamente.";
                        tipoMensaje = "error";
                    }
                }
            }
        } catch (Exception e) {
            mensaje = "Error: " + e.getMessage();
            tipoMensaje = "error";
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Campaña - Sistema de Voluntariado UPT</title>
    
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
            min-height: 100vh;
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
        
        /* Main Content */
        .main-content {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
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
        
        .btn-back {
            background: white;
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-back:hover {
            background: var(--primary-color);
            color: white;
        }
        
        /* Form Container */
        .form-container {
            background: var(--white);
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        
        .form-section-title {
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--gray-200);
        }
        
        .form-label {
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }
        
        .form-label i {
            color: var(--primary-color);
            margin-right: 0.5rem;
        }
        
        .form-control, .form-select {
            border: 2px solid var(--gray-300);
            border-radius: 10px;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(0, 61, 122, 0.25);
            outline: none;
        }
        
        textarea.form-control {
            resize: vertical;
        }
        
        /* Buttons */
        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            border: none;
            border-radius: 10px;
            padding: 12px 32px;
            font-weight: 600;
            color: var(--white);
            transition: all 0.3s ease;
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 61, 122, 0.3);
            color: var(--white);
        }
        
        .btn-secondary-custom {
            background: var(--white);
            border: 2px solid var(--gray-300);
            color: var(--gray-600);
            border-radius: 10px;
            padding: 10px 32px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-secondary-custom:hover {
            background: var(--gray-200);
            color: var(--gray-800);
            border-color: var(--gray-600);
        }
        
        /* Alerts */
        .alert {
            border-radius: 10px;
            border: none;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert i {
            font-size: 1.2rem;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid var(--success-color);
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid var(--danger-color);
        }
        
        /* Info Box */
        .info-box {
            background: #e7f3ff;
            border-left: 4px solid var(--primary-color);
            padding: 1rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        
        .info-box i {
            color: var(--primary-color);
            margin-right: 0.5rem;
        }
        
        .info-box p {
            margin: 0;
            color: var(--gray-800);
            font-size: 0.95rem;
        }
        
        /* Required asterisk */
        .required {
            color: var(--danger-color);
            margin-left: 2px;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                padding: 1rem;
            }
            
            .page-header {
                padding: 1.5rem;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
            
            .form-container {
                padding: 1.5rem;
            }
            
            .btn-primary-custom,
            .btn-secondary-custom {
                width: 100%;
                margin-bottom: 0.5rem;
            }
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
                    <%= usuario.getNombreCompleto() %>
                </span>
                <a href="../index.jsp" class="btn btn-logout">
                    <i class="fas fa-sign-out-alt me-2"></i>
                    Cerrar Sesión
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center flex-wrap">
                <div>
                    <h1 class="page-title">
                        <i class="fas fa-bullhorn me-2"></i>Crear Nueva Campaña
                    </h1>
                    <p class="page-subtitle">Complete el formulario para crear una nueva campaña de voluntariado</p>
                </div>
                <a href="menu_coordinador.jsp" class="btn-back mt-3 mt-md-0">
                    <i class="fas fa-arrow-left me-2"></i>Volver al Panel
                </a>
            </div>
        </div>

        <!-- Mensajes de estado -->
        <% if (!mensaje.isEmpty()) { %>
            <div class="alert alert-<%= tipoMensaje.equals("success") ? "success" : "danger" %>" role="alert">
                <i class="fas fa-<%= tipoMensaje.equals("success") ? "check-circle" : "exclamation-triangle" %>"></i>
                <span><%= mensaje %></span>
            </div>
        <% } %>
        
        <!-- Info Box -->
        <div class="info-box">
            <p>
                <i class="fas fa-info-circle"></i>
                <strong>Nota:</strong> Los campos marcados con <span class="required">*</span> son obligatorios. 
                La campaña quedará en estado "Publicada" una vez creada y será visible para los estudiantes.
            </p>
        </div>

        <!-- Form Container -->
        <div class="form-container">
                        
            <form method="POST" action="crear_campana.jsp" id="formCrearCampana">
                <!-- Información General -->
                <h5 class="form-section-title">
                    <i class="fas fa-info-circle me-2"></i>Información General
                </h5>
                
                <div class="row g-3 mb-4">
                    <!-- Título -->
                    <div class="col-12">
                        <label for="titulo" class="form-label">
                            <i class="fas fa-heading"></i>
                            Título de la Campaña <span class="required">*</span>
                        </label>
                        <input type="text" class="form-control" id="titulo" name="titulo" 
                               placeholder="Ej: Limpieza de Playas - Tacna 2024" 
                               value="<%= request.getParameter("titulo") != null && !tipoMensaje.equals("success") ? request.getParameter("titulo") : "" %>"
                               required maxlength="200">
                    </div>
                    
                    <!-- Descripción -->
                    <div class="col-12">
                        <label for="descripcion" class="form-label">
                            <i class="fas fa-align-left"></i>
                            Descripción <span class="required">*</span>
                        </label>
                        <textarea class="form-control" id="descripcion" name="descripcion" rows="4" 
                                  placeholder="Describe los objetivos, actividades y beneficios de la campaña..."
                                  required><%= request.getParameter("descripcion") != null && !tipoMensaje.equals("success") ? request.getParameter("descripcion") : "" %></textarea>
                    </div>
                </div>
                
                <!-- Fecha y Horarios -->
                <h5 class="form-section-title">
                    <i class="fas fa-calendar-alt me-2"></i>Fecha y Horarios
                </h5>
                
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label for="fecha" class="form-label">
                            <i class="fas fa-calendar"></i>
                            Fecha <span class="required">*</span>
                        </label>
                        <input type="date" class="form-control" id="fecha" name="fecha" 
                               value="<%= request.getParameter("fecha") != null && !tipoMensaje.equals("success") ? request.getParameter("fecha") : "" %>"
                               required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                    </div>
                    
                    <div class="col-md-4">
                        <label for="horaInicio" class="form-label">
                            <i class="fas fa-clock"></i>
                            Hora Inicio <span class="required">*</span>
                        </label>
                        <input type="time" class="form-control" id="horaInicio" name="horaInicio" 
                               value="<%= request.getParameter("horaInicio") != null && !tipoMensaje.equals("success") ? request.getParameter("horaInicio") : "" %>"
                               required>
                    </div>
                    
                    <div class="col-md-4">
                        <label for="horaFin" class="form-label">
                            <i class="fas fa-clock"></i>
                            Hora Fin <span class="required">*</span>
                        </label>
                        <input type="time" class="form-control" id="horaFin" name="horaFin" 
                               value="<%= request.getParameter("horaFin") != null && !tipoMensaje.equals("success") ? request.getParameter("horaFin") : "" %>"
                               required>
                    </div>
                </div>
                
                <!-- Lugar y Cupos -->
                <h5 class="form-section-title">
                    <i class="fas fa-map-marker-alt me-2"></i>Ubicación y Capacidad
                </h5>
                
                <div class="row g-3 mb-4">
                    <div class="col-md-8">
                        <label for="lugar" class="form-label">
                            <i class="fas fa-map-marker-alt"></i>
                            Lugar <span class="required">*</span>
                        </label>
                        <input type="text" class="form-control" id="lugar" name="lugar" 
                               placeholder="Ej: Playa Boca del Río, Tacna" 
                               value="<%= request.getParameter("lugar") != null && !tipoMensaje.equals("success") ? request.getParameter("lugar") : "" %>"
                               required maxlength="200">
                    </div>
                    
                    <div class="col-md-4">
                        <label for="cuposTotal" class="form-label">
                            <i class="fas fa-users"></i>
                            Cupos Totales <span class="required">*</span>
                        </label>
                        <input type="number" class="form-control" id="cuposTotal" name="cuposTotal" 
                               placeholder="50" min="1" max="1000"
                               value="<%= request.getParameter("cuposTotal") != null && !tipoMensaje.equals("success") ? request.getParameter("cuposTotal") : "" %>"
                               required>
                    </div>
                </div>
                
                <!-- Requisitos -->
                <h5 class="form-section-title">
                    <i class="fas fa-list-check me-2"></i>Requisitos Adicionales
                </h5>
                
                <div class="row g-3 mb-4">
                    <div class="col-12">
                        <label for="requisitos" class="form-label">
                            <i class="fas fa-clipboard-list"></i>
                            Requisitos (Opcional)
                        </label>
                        <textarea class="form-control" id="requisitos" name="requisitos" rows="3" 
                                  placeholder="Ej: Traer ropa cómoda, protector solar, agua. Edad mínima 16 años."><%= request.getParameter("requisitos") != null && !tipoMensaje.equals("success") ? request.getParameter("requisitos") : "" %></textarea>
                        <small class="text-muted">Especifica cualquier requisito o material que los voluntarios deban traer.</small>
                    </div>
                </div>
                
                <!-- Botones -->
                <div class="row mt-4">
                    <div class="col-12 d-flex justify-content-center gap-3 flex-wrap">
                        <button type="submit" class="btn-primary-custom">
                            <i class="fas fa-save me-2"></i>
                            Crear Campaña
                        </button>
                        <a href="menu_coordinador.jsp" class="btn-secondary-custom">
                            <i class="fas fa-times me-2"></i>
                            Cancelar
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </main>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Limpiar formulario si la campaña se creó exitosamente
 // Limpiar formulario si la campaña se creó exitosamente
            window.addEventListener('DOMContentLoaded', function() {
                const alertSuccess = document.querySelector('.alert-success');
                const form = document.getElementById('formCrearCampana');
                
                if (alertSuccess && form) {
                    form.reset();
                }
            });
        
        // Validación en tiempo real
        document.getElementById('horaInicio').addEventListener('change', validarHorarios);
        document.getElementById('horaFin').addEventListener('change', validarHorarios);
        
        function validarHorarios() {
            const horaInicio = document.getElementById('horaInicio').value;
            const horaFin = document.getElementById('horaFin').value;
            
            if (horaInicio && horaFin) {
                if (horaFin <= horaInicio) {
                    document.getElementById('horaFin').setCustomValidity('La hora de fin debe ser posterior a la hora de inicio');
                } else {
                    document.getElementById('horaFin').setCustomValidity('');
                }
            }
        }
        
        // Validación de fecha (no permitir fechas pasadas)
        document.getElementById('fecha').addEventListener('change', function() {
            const fechaSeleccionada = new Date(this.value);
            const fechaHoy = new Date();
            fechaHoy.setHours(0, 0, 0, 0);
            
            if (fechaSeleccionada < fechaHoy) {
                this.setCustomValidity('No se pueden crear campañas en fechas pasadas');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // Auto-ocultar mensajes de éxito después de 5 segundos
        // Auto-ocultar TODOS los mensajes de éxito después de 5 segundos
    window.addEventListener('DOMContentLoaded', function() {
        const alertSuccess = document.querySelector('.alert-success');
        if (alertSuccess) {
            setTimeout(function() {
                alertSuccess.style.transition = 'opacity 0.5s ease';
                alertSuccess.style.opacity = '0';
                setTimeout(() => alertSuccess.remove(), 500);
            }, 5000);
        }
    });
    </script>
</body>
</html>