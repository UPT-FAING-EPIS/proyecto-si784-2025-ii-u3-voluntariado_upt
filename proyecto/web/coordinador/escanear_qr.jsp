<%-- 
    Document   : escanear-qr
    Created on : 30 set. 2025, 12:00:00 a. m.
    Author     : Mi Equipo
    Description: Sistema de Voluntariado UPT - Escanear QR para Asistencia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entidad.*"%>

<%
    // Validación de sesión
    if (session.getAttribute("usuario") == null || 
        !"COORDINADOR".equals(session.getAttribute("rol"))) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    Usuario coordinador = (Usuario) session.getAttribute("usuario");
    String nombreCompleto = coordinador.getNombres() + " " + coordinador.getApellidos();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Escanear QR - Sistema de Voluntariado UPT</title>
    
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
        
        .scanner-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .scanner-area {
            border: 3px dashed var(--primary-color);
            border-radius: 10px;
            padding: 40px;
            text-align: center;
            background: rgba(0, 61, 122, 0.05);
            margin-bottom: 20px;
        }
        
        .scanner-icon {
            font-size: 4rem;
            color: var(--primary-color);
            margin-bottom: 20px;
        }
        
        .history-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .status-success {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .status-error {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }
        
        #qrVideo {
            width: 100%;
            height: 480px;
            border-radius: 15px;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            box-shadow: 0 8px 30px rgba(0, 61, 122, 0.3);
            border: 3px solid var(--primary-color);
            display: block;
            overflow: hidden;
        }
        
        #qrVideo video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        
        .scanning-indicator {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 15px;
            padding: 15px;
            background: rgba(0, 102, 204, 0.1);
            border-radius: 10px;
            color: var(--secondary-color);
            font-weight: 500;
        }
        
        .scanning-dot {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: var(--secondary-color);
            animation: pulse 1.5s infinite;
        }
        
        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.3;
            }
        }
        
        .success-message {
            padding: 20px;
            background: linear-gradient(135deg, rgba(40, 167, 69, 0.1) 0%, rgba(40, 167, 69, 0.05) 100%);
            border-left: 5px solid var(--success-color);
            border-radius: 10px;
            margin-top: 15px;
            text-align: center;
            animation: slideIn 0.5s ease-out;
        }
        
        .success-message i {
            font-size: 2rem;
            color: var(--success-color);
            margin-bottom: 10px;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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
                <a class="nav-link active" href="escanear-qr.jsp">
                    <i class="fas fa-qrcode me-1"></i>Escanear QR
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
            <div class="col-lg-8">
                <div class="scanner-container">
                    <h3 class="mb-4">
                        <i class="fas fa-qrcode me-2"></i>Escáner de Códigos QR
                    </h3>
                    
                    <div class="scanner-area" id="scannerArea">
                        <i class="fas fa-qrcode scanner-icon"></i>
                        <h5>Escanear Código QR</h5>
                        <p class="text-muted mb-4">
                            Haz clic en el botón para activar la cámara y escanear el código QR del estudiante
                        </p>
                        <button class="btn btn-primary btn-lg" id="startScanBtn" onclick="iniciarEscaneo()">
                            <i class="fas fa-camera me-2"></i>Activar Cámara
                        </button>
                    </div>
                    
                    <!-- Área de video para la cámara -->
                    <div id="videoContainer" class="d-none">
                        <div id="qrVideo"></div>
                        
                        <!-- Indicador de escaneo -->
                        <div class="scanning-indicator">
                            <span class="scanning-dot"></span>
                            <span>Escaneando código QR...</span>
                        </div>
                        
                        <!-- Mensaje de éxito -->
                        <div id="successMessage" class="success-message d-none">
                            <i class="fas fa-check-circle"></i>
                            <h5 class="mt-2">¡Escaneo Correcto!</h5>
                            <p id="successText" class="mb-0"></p>
                        </div>
                        
                        <div class="mt-3 text-center">
                            <button class="btn btn-danger btn-lg" onclick="detenerEscaneo()">
                                <i class="fas fa-stop me-2"></i>Detener Escáner
                            </button>
                        </div>
                    </div>
                    
                    <!-- Input manual como alternativa -->
                    <div class="mt-4">
                        <h6>Ingreso Manual</h6>
                        <div class="input-group">
                            <input type="text" class="form-control" id="qrManualInput" 
                                   placeholder="Pega aquí el código QR manualmente...">
                            <button class="btn btn-outline-primary" onclick="procesarQRManual()">
                                <i class="fas fa-check me-1"></i>Procesar
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Historial de Escaneos -->
            <div class="col-lg-4">
                <div class="scanner-container">
                    <h5 class="mb-3">
                        <i class="fas fa-history me-2"></i>Historial de Escaneos
                    </h5>
                    <div id="scanHistory">
                        <!-- Contenido dinámico -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de Resultado -->
    <div class="modal fade" id="resultModal" tabindex="-1" aria-labelledby="resultModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="resultModalLabel">
                        <i class="fas fa-check-circle me-2"></i>Resultado del Escaneo
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="resultModalBody">
                    <!-- Contenido dinámico -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- QR Scanner Library -->
    <script src="https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js"></script>
    
    <script>
        let html5QrCode = null;
        let scanHistory = [];
        
        function iniciarEscaneo() {
            const videoContainer = document.getElementById('videoContainer');
            const scannerArea = document.getElementById('scannerArea');
            
            // Mostrar video container
            videoContainer.classList.remove('d-none');
            scannerArea.style.display = 'none';
            
            try {
                // Inicializar escáner
                html5QrCode = new Html5Qrcode("qrVideo");
                
                const config = {
                    fps: 10,
                    qrbox: { width: 200, height: 200 },
                    aspectRatio: 1.0,
                    rememberLastUsedCamera: true
                };
                
                html5QrCode.start(
                    { facingMode: "environment" }, // Cámara trasera
                    config,
                    (decodedText, decodedResult) => {
                        console.log('QR escaneado:', decodedText);
                        procesarQR(decodedText);
                        detenerEscaneo();
                    },
                    (errorMessage) => {
                        // Error de escaneo (normal, no hacer nada)
                    }
                ).catch(err => {
                    console.error('Error iniciando escáner:', err);
                    
                    // Intentar con cámara frontal si falla la trasera
                    if (err.name === 'NotAllowedError') {
                        alert('Permiso denegado. Por favor, permite el acceso a la cámara.');
                        detenerEscaneo();
                    } else if (err.name === 'NotFoundError') {
                        alert('No se encontró ninguna cámara en tu dispositivo.');
                        detenerEscaneo();
                    } else {
                        alert('Error al acceder a la cámara: ' + err.message);
                        detenerEscaneo();
                    }
                });
            } catch (err) {
                console.error('Error en iniciarEscaneo:', err);
                alert('Error inesperado: ' + err.message);
                detenerEscaneo();
            }
        }
        
        function detenerEscaneo() {
            if (html5QrCode) {
                html5QrCode.stop().then(() => {
                    html5QrCode.clear();
                    html5QrCode = null;
                }).catch(err => {
                    console.error('Error deteniendo escáner:', err);
                });
            }
            
            const videoContainer = document.getElementById('videoContainer');
            const scannerArea = document.getElementById('scannerArea');
            
            videoContainer.classList.add('d-none');
            scannerArea.style.display = 'block';
        }
        
        function procesarQRManual() {
            const qrData = document.getElementById('qrManualInput').value.trim();
            if (qrData) {
                procesarQR(qrData);
                document.getElementById('qrManualInput').value = '';
            } else {
                alert('Por favor ingresa un código QR válido');
            }
        }
        
        function procesarQR(qrData) {
            console.log('Procesando QR:', qrData);
            
            // Mostrar mensaje de escaneo correcto
            mostrarMensajeExito(`Código escaneado: ${qrData.substring(0, 20)}...`);
            
            // Mostrar loading en modal
            mostrarResultado('Procesando...', 'info', true);
            
            // Enviar al servidor
            const formData = new URLSearchParams();
            formData.append('action', 'registrarAsistencia');
            formData.append('qrData', qrData);
            
            console.log('Enviando datos:', formData.toString());
            
            fetch('<%= request.getContextPath() %>/AsistenciaServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                console.log('Respuesta del servidor:', data);
                
                if (data.success) {
                    mostrarResultado(
                        `<div class="text-center">
                            <i class="fas fa-check-circle text-success fa-3x mb-3"></i>
                            <h5>¡Asistencia Registrada!</h5>
                            <p><strong>Estudiante:</strong> ${data.estudiante}</p>
                            <p><strong>Campaña:</strong> ${data.campana}</p>
                        </div>`,
                        'success'
                    );
                    
                    agregarAlHistorial(data.estudiante, data.campana, true);
                } else {
                    mostrarResultado(
                        `<div class="text-center">
                            <i class="fas fa-exclamation-triangle text-danger fa-3x mb-3"></i>
                            <h5>Error</h5>
                            <p>${data.message}</p>
                        </div>`,
                        'error'
                    );
                    
                    agregarAlHistorial('Error', data.message, false);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                mostrarResultado(
                    `<div class="text-center">
                        <i class="fas fa-times-circle text-danger fa-3x mb-3"></i>
                        <h5>Error de Conexión</h5>
                        <p>${error.message}</p>
                    </div>`,
                    'error'
                );
                
                agregarAlHistorial('Error', 'Error de conexión', false);
            });
        }
        
        function mostrarResultado(contenido, tipo, loading = false) {
            const modalElement = document.getElementById('resultModal');
            let modal = bootstrap.Modal.getInstance(modalElement);
            
            if (!modal) {
                modal = new bootstrap.Modal(modalElement);
            }
            
            const modalBody = document.getElementById('resultModalBody');
            const modalTitle = document.getElementById('resultModalLabel');
            
            if (loading) {
                modalTitle.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Procesando...';
                modalBody.innerHTML = `
                    <div class="text-center">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Procesando...</span>
                        </div>
                        <p class="mt-3">${contenido}</p>
                    </div>
                `;
                modal.show();
            } else {
                if (tipo === 'success') {
                    modalTitle.innerHTML = '<i class="fas fa-check-circle text-success me-2"></i>Éxito';
                } else {
                    modalTitle.innerHTML = '<i class="fas fa-exclamation-triangle text-danger me-2"></i>Error';
                }
                modalBody.innerHTML = contenido;
                
                // Si es éxito, cerrar automáticamente después de 2 segundos
                if (tipo === 'success') {
                    setTimeout(() => {
                        modal.hide();
                    }, 2000);
                }
            }
        }
        
        function mostrarMensajeExito(texto) {
            const successMessage = document.getElementById('successMessage');
            const successText = document.getElementById('successText');
            
            successText.textContent = texto;
            successMessage.classList.remove('d-none');
            
            // Ocultarlo después de 3 segundos
            setTimeout(() => {
                successMessage.classList.add('d-none');
            }, 3000);
        }
        
        function agregarAlHistorial(estudiante, detalle, exito) {
            const historyContainer = document.getElementById('scanHistory');
            const timestamp = new Date().toLocaleString();
            
            // Agregar al array
            scanHistory.unshift({
                estudiante: estudiante,
                detalle: detalle,
                exito: exito,
                timestamp: timestamp
            });
            
            // Mantener solo los últimos 10
            if (scanHistory.length > 10) {
                scanHistory = scanHistory.slice(0, 10);
            }
            
            // Actualizar UI
            actualizarHistorialUI();
        }
        
        function actualizarHistorialUI() {
            const historyContainer = document.getElementById('scanHistory');
            
            if (scanHistory.length === 0) {
                historyContainer.innerHTML = `
                    <div class="text-center text-muted">
                        <i class="fas fa-clock fa-2x mb-2"></i>
                        <p class="mb-0">No hay escaneos recientes</p>
                    </div>
                `;
                return;
            }
            
            let html = '';
            scanHistory.forEach(item => {
                html += `
                    <div class="history-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">${item.estudiante}</h6>
                                <small class="text-muted">${item.detalle}</small>
                            </div>
                            <span class="status-badge ${item.exito ? 'status-success' : 'status-error'}">
                                <i class="fas ${item.exito ? 'fa-check' : 'fa-times'} me-1"></i>
                                ${item.exito ? 'Éxito' : 'Error'}
                            </span>
                        </div>
                        <small class="text-muted">
                            <i class="fas fa-clock me-1"></i>${item.timestamp}
                        </small>
                    </div>
                `;
            });
            
            historyContainer.innerHTML = html;
        }
        
        // Limpiar recursos al cerrar la página
        window.addEventListener('beforeunload', function() {
            if (html5QrCode) {
                html5QrCode.stop();
            }
        });
        
        // Inicializar el historial cuando la página cargue
        document.addEventListener('DOMContentLoaded', function() {
            actualizarHistorialUI();
        });
    </script>
</body>
</html>