package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import conexion.ConexionDB;
import entidad.Usuario;

@WebServlet(name = "CertificadoServlet", urlPatterns = {"/CertificadoServlet"})
public class CertificadoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            System.out.println("=== CertificadoServlet - Inicio ===");
            
            // Verificar sesión
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("usuario") == null) {
                System.out.println("Error: Sesión no válida");
                out.print("{\"success\": false, \"message\": \"Sesión no válida\"}");
                return;
            }
            
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            String rol = (String) session.getAttribute("rol");
            
            System.out.println("Usuario: " + usuario.getNombres() + ", Rol: " + rol);
            
            // Solo coordinadores pueden generar certificados
            if (!"COORDINADOR".equals(rol)) {
                System.out.println("Error: Acceso no autorizado para rol: " + rol);
                out.print("{\"success\": false, \"message\": \"Solo coordinadores pueden generar certificados\"}");
                return;
            }
            
            String action = request.getParameter("action");
            System.out.println("Action: " + action);
            
            if ("generarCertificado".equals(action)) {
                generarCertificado(request, response, out, usuario);
            } else if ("generarTodosPendientes".equals(action)) {
                generarTodosPendientes(request, response, out, usuario);
            } else {
                System.out.println("Error: Acción no válida: " + action);
                out.print("{\"success\": false, \"message\": \"Acción no válida\"}");
            }
            
        } catch (Exception e) {
            System.err.println("Error general en CertificadoServlet: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error interno del servidor: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
    
    private void generarCertificado(HttpServletRequest request, HttpServletResponse response, 
                                   PrintWriter out, Usuario coordinador) throws IOException {
        
        try {
            System.out.println("=== Generando Certificado ===");
            
            // Obtener parámetros
            String idEstudianteStr = request.getParameter("idEstudiante");
            String idCampanaStr = request.getParameter("idCampana");
            String horasAcreditadasStr = request.getParameter("horasAcreditadas");
            
            System.out.println("Parámetros - Estudiante: " + idEstudianteStr + 
                             ", Campaña: " + idCampanaStr + 
                             ", Horas: " + horasAcreditadasStr);
            
            if (idEstudianteStr == null || idCampanaStr == null || horasAcreditadasStr == null) {
                System.out.println("Error: Parámetros faltantes");
                out.print("{\"success\": false, \"message\": \"Parámetros faltantes\"}");
                return;
            }
            
            int idEstudiante = Integer.parseInt(idEstudianteStr);
            int idCampana = Integer.parseInt(idCampanaStr);
            int horasAcreditadas = Integer.parseInt(horasAcreditadasStr);
            
            // Verificar que el estudiante tenga asistencia registrada
            if (!verificarAsistencia(idEstudiante, idCampana)) {
                System.out.println("Error: El estudiante no tiene asistencia registrada");
                out.print("{\"success\": false, \"message\": \"El estudiante no tiene asistencia registrada en esta campaña\"}");
                return;
            }
            
            // Verificar que no exista ya un certificado
            if (existeCertificado(idEstudiante, idCampana)) {
                System.out.println("Error: Ya existe un certificado para este estudiante y campaña");
                out.print("{\"success\": false, \"message\": \"Ya existe un certificado para este estudiante\"}");
                return;
            }
            
            // Generar código de verificación único
            String codigoVerificacion = generarCodigoVerificacion();
            
            // Generar hash QR (puedes usar cualquier librería de QR)
            String hashQR = generarHashQR(idEstudiante, idCampana, codigoVerificacion);
            
            // Insertar certificado en la base de datos
            boolean generado = insertarCertificado(idEstudiante, idCampana, codigoVerificacion, 
                                                  hashQR, horasAcreditadas);
            
            if (generado) {
                System.out.println("Certificado generado exitosamente");
                
                // Obtener información del estudiante y campaña
                String[] info = obtenerInfoCertificado(idEstudiante, idCampana);
                String nombreEstudiante = info[0];
                String nombreCampana = info[1];
                
                String jsonResponse = String.format(
                    "{\"success\": true, \"message\": \"Certificado generado correctamente\", " +
                    "\"estudiante\": \"%s\", \"campana\": \"%s\", \"codigo\": \"%s\"}",
                    nombreEstudiante, nombreCampana, codigoVerificacion
                );
                
                out.print(jsonResponse);
            } else {
                System.out.println("Error al generar certificado");
                out.print("{\"success\": false, \"message\": \"Error al generar certificado en la base de datos\"}");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Error parseando parámetros: " + e.getMessage());
            out.print("{\"success\": false, \"message\": \"Parámetros inválidos\"}");
        } catch (Exception e) {
            System.err.println("Error generando certificado: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error generando certificado: " + e.getMessage() + "\"}");
        }
    }
    
    private boolean verificarAsistencia(int idEstudiante, int idCampana) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT COUNT(*) FROM asistencias WHERE id_estudiante = ? AND id_campana = ? AND presente = 1";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idCampana);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error verificando asistencia: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) ConexionDB.cerrarConexion(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return false;
    }
    
    private boolean existeCertificado(int idEstudiante, int idCampana) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT COUNT(*) FROM certificados WHERE id_estudiante = ? AND id_campana = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idCampana);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error verificando existencia de certificado: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) ConexionDB.cerrarConexion(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return false;
    }
    
    private String generarCodigoVerificacion() {
        // Generar código único de 16 caracteres
        return "CERT-" + UUID.randomUUID().toString().substring(0, 11).toUpperCase();
    }
    
    private String generarHashQR(int idEstudiante, int idCampana, String codigoVerificacion) {
        // Generar hash para el código QR
        return String.format("CERTIFICADO|%d|%d|%s|%d", 
                           idEstudiante, idCampana, codigoVerificacion, 
                           System.currentTimeMillis());
    }
    
    private boolean insertarCertificado(int idEstudiante, int idCampana, String codigoVerificacion,
                                       String hashQR, int horasAcreditadas) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = ConexionDB.getConnection();
            System.out.println("Conexión establecida para insertar certificado");
            
            String sql = "INSERT INTO certificados " +
                        "(id_estudiante, id_campana, codigo_verificacion, hash_qr, " +
                        "fecha_emision, horas_acreditadas, activo) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idCampana);
            ps.setString(3, codigoVerificacion);
            ps.setString(4, hashQR);
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.setInt(6, horasAcreditadas);
            ps.setBoolean(7, true);
            
            System.out.println("Ejecutando insert - Estudiante: " + idEstudiante + 
                             ", Campaña: " + idCampana + 
                             ", Código: " + codigoVerificacion);
            
            int filasAfectadas = ps.executeUpdate();
            System.out.println("Filas afectadas en certificados: " + filasAfectadas);
            
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error SQL insertando certificado: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) ConexionDB.cerrarConexion(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void generarTodosPendientes(HttpServletRequest request, HttpServletResponse response, 
                                       PrintWriter out, Usuario coordinador) throws IOException {
        
        try {
            System.out.println("=== Generando Todos los Certificados Pendientes ===");
            
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            int generados = 0;
            int errores = 0;
            
            try {
                conn = ConexionDB.getConnection();
                
                // Obtener todos los estudiantes con asistencia sin certificado del coordinador
                String sql = "SELECT DISTINCT " +
                            "    a.id_estudiante, " +
                            "    a.id_campana, " +
                            "    c.hora_inicio, " +
                            "    c.hora_fin " +
                            "FROM asistencias a " +
                            "INNER JOIN campanas c ON a.id_campana = c.id_campana " +
                            "LEFT JOIN certificados cert ON cert.id_estudiante = a.id_estudiante " +
                            "    AND cert.id_campana = a.id_campana " +
                            "WHERE c.id_coordinador = ? " +
                            "    AND a.presente = 1 " +
                            "    AND cert.id_certificado IS NULL";
                
                ps = conn.prepareStatement(sql);
                ps.setInt(1, coordinador.getIdUsuario());
                rs = ps.executeQuery();
                
                System.out.println("Buscando asistencias sin certificado para coordinador ID: " + coordinador.getIdUsuario());
                
                while (rs.next()) {
                    int idEstudiante = rs.getInt("id_estudiante");
                    int idCampana = rs.getInt("id_campana");
                    java.sql.Time horaInicio = rs.getTime("hora_inicio");
                    java.sql.Time horaFin = rs.getTime("hora_fin");
                    
                    // Calcular horas acreditadas
                    long diffMillis = horaFin.getTime() - horaInicio.getTime();
                    int horasAcreditadas = (int) (diffMillis / (1000 * 60 * 60));
                    
                    System.out.println("Procesando - Estudiante: " + idEstudiante + 
                                     ", Campaña: " + idCampana + 
                                     ", Horas: " + horasAcreditadas);
                    
                    // Generar código de verificación único
                    String codigoVerificacion = generarCodigoVerificacion();
                    String hashQR = generarHashQR(idEstudiante, idCampana, codigoVerificacion);
                    
                    // Insertar certificado
                    boolean generado = insertarCertificado(idEstudiante, idCampana, codigoVerificacion, 
                                                          hashQR, horasAcreditadas);
                    
                    if (generado) {
                        generados++;
                        System.out.println("Certificado generado exitosamente para estudiante " + idEstudiante);
                    } else {
                        errores++;
                        System.err.println("Error generando certificado para estudiante " + idEstudiante);
                    }
                }
                
            } catch (SQLException e) {
                System.err.println("Error SQL en generación masiva: " + e.getMessage());
                e.printStackTrace();
                out.print("{\"success\": false, \"message\": \"Error en la base de datos: " + e.getMessage() + "\"}");
                return;
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) ConexionDB.cerrarConexion(conn);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            
            System.out.println("Generación masiva completada - Generados: " + generados + ", Errores: " + errores);
            
            String jsonResponse = String.format(
                "{\"success\": true, \"message\": \"Proceso completado\", " +
                "\"generados\": %d, \"errores\": %d}",
                generados, errores
            );
            
            out.print(jsonResponse);
            
        } catch (Exception e) {
            System.err.println("Error en generación masiva: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error generando certificados: " + e.getMessage() + "\"}");
        }
    }
    
    private String[] obtenerInfoCertificado(int idEstudiante, int idCampana) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT u.nombres, u.apellidos, c.titulo " +
                        "FROM usuarios u, campanas c " +
                        "WHERE u.id_usuario = ? AND c.id_campana = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idCampana);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                String nombreEstudiante = rs.getString("nombres") + " " + rs.getString("apellidos");
                String nombreCampana = rs.getString("titulo");
                return new String[]{nombreEstudiante, nombreCampana};
            }
            
        } catch (SQLException e) {
            System.err.println("Error obteniendo información del certificado: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) ConexionDB.cerrarConexion(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return new String[]{"Estudiante desconocido", "Campaña desconocida"};
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported");
    }
}
