<%-- 
    Document   : campañas
    Created on : 29 set. 2025, 10:14:32 p. m.
    Author     : Mi Equipo
    Description: Sistema de Voluntariado UPT - Campañas Disponibles
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
    
    // Obtener campañas disponibles
    List<Campana> campanasDisponibles = estudianteNeg.obtenerCampanasDisponibles();
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campañas Disponibles - Sistema de Voluntariado UPT</title>
    
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
        
        .campaign-card {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .campaign-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .section-title {
            color: var(--primary-color);
            font-weight: 600;
            border-bottom: 3px solid var(--secondary-color);
            padding-bottom: 10px;
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
                <a class="nav-link active" href="campañas.jsp">
                    <i class="fas fa-bullhorn me-1"></i>Campañas
                </a>
                <a class="nav-link" href="inscripciones.jsp">
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
        <div class="main-content">
            <div class="row">
                <div class="col-12">
                    <h2 class="section-title mb-4">
                        <i class="fas fa-bullhorn me-2"></i>Campañas Disponibles
                    </h2>
                </div>
            </div>
        </div>
        
        <!-- Filtros -->
        <div class="filter-section">
            <div class="row">
                <div class="col-md-6">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Buscar campañas..." id="searchInput">
                        <button class="btn btn-outline-primary" type="button">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
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
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card campaign-card h-100">
                            <div class="card-body">
                                <h5 class="card-title text-primary campaign-title">
                                    <%= campana.getTitulo() %>
                                </h5>
                                <p class="card-text campaign-description">
                                    <%= campana.getDescripcion() %>
                                </p>
                                <div class="campaign-details">
                                    <small class="text-muted">
                                        <i class="fas fa-calendar me-1"></i>
                                        <strong>Fecha:</strong> <%= sdf.format(campana.getFecha()) %><br>
                                        <i class="fas fa-clock me-1"></i>
                                        <strong>Horario:</strong> <%= sdfHora.format(campana.getHoraInicio()) %> - <%= sdfHora.format(campana.getHoraFin()) %><br>
                                        <i class="fas fa-map-marker-alt me-1"></i>
                                        <strong>Lugar:</strong> <%= campana.getLugar() %><br>
                                        <i class="fas fa-users me-1"></i>
                                        <strong>Cupos:</strong> <%= campana.getCuposDisponibles() %>/<%= campana.getCuposTotal() %>
                                    </small>
                                </div>
                                
                                <div class="campaign-progress mt-3">
                                    <div class="progress">
                                        <div class="progress-bar" role="progressbar" 
                                             style="width: <%= porcentajeOcupacion %>%" 
                                             aria-valuenow="<%= porcentajeOcupacion %>" 
                                             aria-valuemin="0" aria-valuemax="100">
                                        </div>
                                    </div>
                                    <small class="text-muted mt-1 d-block">
                                        <%= String.format("%.1f", porcentajeOcupacion) %>% ocupado
                                    </small>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="d-grid">
                                    <% if (yaInscrito) { %>
                                        <button class="btn btn-success" disabled>
                                            <i class="fas fa-check me-1"></i>Ya Inscrito
                                        </button>
                                    <% } else if (tieneCupos) { %>
                                        <button class="btn btn-primary" onclick="inscribirseCampana(<%= campana.getIdCampana() %>)">
                                            <i class="fas fa-user-plus me-1"></i>Inscribirme
                                        </button>
                                    <% } else { %>
                                        <button class="btn btn-danger" disabled>
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
                        <p>Por el momento no hay campañas de voluntariado disponibles para inscripción.</p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Función para inscribirse en una campaña
        function inscribirseCampana(idCampana) {
            if (confirm('¿Estás seguro de que deseas inscribirte en esta campaña?')) {
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Inscribiendo...';
                button.disabled = true;
                
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
                        alert('¡Inscripción exitosa! Serás redirigido a tus inscripciones.');
                        window.location.href = 'inscripciones.jsp';
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

        // Filtro de búsqueda
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const campaignCards = document.querySelectorAll('.campaign-card');
            
            campaignCards.forEach(card => {
                const title = card.querySelector('.campaign-title').textContent.toLowerCase();
                const description = card.querySelector('.campaign-description').textContent.toLowerCase();
                
                if (title.includes(searchTerm) || description.includes(searchTerm)) {
                    card.parentElement.style.display = 'block';
                } else {
                    card.parentElement.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
