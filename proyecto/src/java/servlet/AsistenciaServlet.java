package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import conexion.ConexionDB;
import entidad.Usuario;

@WebServlet(name = "AsistenciaServlet", urlPatterns = {"/AsistenciaServlet"})
public class AsistenciaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            System.out.println("=== AsistenciaServlet - Inicio ===");
            
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
            
            String action = request.getParameter("action");
            System.out.println("Action: " + action);
            
            if ("registrarAsistencia".equals(action)) {
                registrarAsistenciaQR(request, response, out, usuario, rol);
            } else {
                System.out.println("Error: Acción no válida: " + action);
                out.print("{\"success\": false, \"message\": \"Acción no válida\"}");
            }
            
        } catch (Exception e) {
            System.err.println("Error general en AsistenciaServlet: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error interno del servidor: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
    
    private void registrarAsistenciaQR(HttpServletRequest request, HttpServletResponse response, 
                                      PrintWriter out, Usuario usuario, String rol) throws IOException {
        
        try {
            System.out.println("=== Registrando Asistencia por QR ===");
            
            // Solo coordinadores pueden registrar asistencia
            if (!"COORDINADOR".equals(rol)) {
                System.out.println("Error: Acceso no autorizado para rol: " + rol);
                out.print("{\"success\": false, \"message\": \"Solo coordinadores pueden registrar asistencia\"}");
                return;
            }
            
            String qrData = request.getParameter("qrData");
            System.out.println("QR Data recibido: " + qrData);
            
            if (qrData == null || qrData.trim().isEmpty()) {
                System.out.println("Error: Datos QR faltantes");
                out.print("{\"success\": false, \"message\": \"Datos QR faltantes\"}");
                return;
            }
            
            // Parsear datos del QR: ASISTENCIA|idUsuario|idCampana|timestamp
            String[] qrParts = qrData.split("\\|");
            if (qrParts.length != 4 || !"ASISTENCIA".equals(qrParts[0])) {
                System.out.println("Error: Formato QR inválido. Partes: " + qrParts.length);
                if (qrParts.length > 0) {
                    System.out.println("Primera parte: " + qrParts[0]);
                }
                out.print("{\"success\": false, \"message\": \"Código QR inválido\"}");
                return;
            }
            
            int idEstudiante = Integer.parseInt(qrParts[1]);
            int idCampana = Integer.parseInt(qrParts[2]);
            long timestamp = Long.parseLong(qrParts[3]);
            
            System.out.println("Datos parseados - Estudiante: " + idEstudiante + ", Campaña: " + idCampana + ", Timestamp: " + timestamp);
            
            // Obtener id_inscripcion desde la BD
            int idInscripcion = obtenerIdInscripcion(idEstudiante, idCampana);
            if (idInscripcion == -1) {
                System.out.println("Error: Inscripción no encontrada para estudiante " + idEstudiante + " en campaña " + idCampana);
                out.print("{\"success\": false, \"message\": \"No se encontró la inscripción del estudiante en esta campaña\"}");
                return;
            }
            
            System.out.println("ID Inscripción encontrado: " + idInscripcion);
            
            // Verificar que el QR no haya expirado (24 horas)
            long currentTime = System.currentTimeMillis();
            long qrAge = currentTime - timestamp;
            long maxAge = 24 * 60 * 60 * 1000; // 24 horas en milisegundos
            
            if (qrAge > maxAge) {
                System.out.println("Error: QR expirado");
                out.print("{\"success\": false, \"message\": \"El código QR ha expirado\"}");
                return;
            }
            
            // Registrar asistencia en la base de datos
            boolean registrado = registrarAsistenciaDB(idInscripcion, idCampana, usuario.getIdUsuario());
            
            if (registrado) {
                System.out.println("Asistencia registrada exitosamente");
                
                // Obtener información del estudiante e inscripción para la respuesta
                String[] info = obtenerInfoAsistencia(idInscripcion);
                String nombreEstudiante = info[0];
                String nombreCampana = info[1];
                
                String jsonResponse = String.format(
                    "{\"success\": true, \"message\": \"Asistencia registrada correctamente\", \"estudiante\": \"%s\", \"campana\": \"%s\"}",
                    nombreEstudiante, nombreCampana
                );
                
                out.print(jsonResponse);
            } else {
                System.out.println("Error al registrar asistencia");
                out.print("{\"success\": false, \"message\": \"Error al registrar asistencia\"}");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Error parseando datos QR: " + e.getMessage());
            out.print("{\"success\": false, \"message\": \"Datos QR inválidos\"}");
        } catch (Exception e) {
            System.err.println("Error registrando asistencia: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error registrando asistencia: " + e.getMessage() + "\"}");
        }
    }
    
    private int obtenerIdInscripcion(int idEstudiante, int idCampana) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT id_inscripcion FROM inscripciones WHERE id_estudiante = ? AND id_campana = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idEstudiante);
            ps.setInt(2, idCampana);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("id_inscripcion");
            }
            
        } catch (SQLException e) {
            System.err.println("Error obteniendo ID de inscripción: " + e.getMessage());
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
        
        return -1;
    }
    
    private boolean registrarAsistenciaDB(int idInscripcion, int idCampana, int idCoordinador) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            System.out.println("Conexión establecida para registrar asistencia");
            
            // Obtener id_estudiante desde inscripciones
            String sqlObtenerEstudiante = "SELECT id_estudiante FROM inscripciones WHERE id_inscripcion = ?";
            ps = conn.prepareStatement(sqlObtenerEstudiante);
            ps.setInt(1, idInscripcion);
            rs = ps.executeQuery();
            
            if (!rs.next()) {
                System.out.println("Error: Inscripción no encontrada");
                return false;
            }
            
            int idEstudiante = rs.getInt("id_estudiante");
            System.out.println("ID Estudiante obtenido: " + idEstudiante);
            rs.close();
            ps.close();
            
            // Verificar que no haya asistencia ya registrada
            String sqlVerificar = "SELECT id_asistencia FROM asistencias WHERE id_inscripcion = ?";
            ps = conn.prepareStatement(sqlVerificar);
            ps.setInt(1, idInscripcion);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                System.out.println("Asistencia ya registrada para esta inscripción");
                return false;
            }
            
            rs.close();
            ps.close();
            
            // Registrar nueva asistencia
            String sqlInsert = "INSERT INTO asistencias (id_inscripcion, id_campana, id_estudiante, fecha_registro, tipo_registro, presente) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sqlInsert);
            ps.setInt(1, idInscripcion);
            ps.setInt(2, idCampana);
            ps.setInt(3, idEstudiante);
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            ps.setString(5, "QR");
            ps.setBoolean(6, true);
            
            System.out.println("Ejecutando insert con: inscripcion=" + idInscripcion + ", campana=" + idCampana + ", estudiante=" + idEstudiante);
            int filasAfectadas = ps.executeUpdate();
            System.out.println("Filas afectadas en asistencias: " + filasAfectadas);
            
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error SQL registrando asistencia: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) ConexionDB.cerrarConexion(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private String[] obtenerInfoAsistencia(int idInscripcion) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT u.nombres, u.apellidos, c.titulo FROM inscripciones i " +
                        "JOIN usuarios u ON i.id_estudiante = u.id_usuario " +
                        "JOIN campanas c ON i.id_campana = c.id_campana " +
                        "WHERE i.id_inscripcion = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idInscripcion);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                String nombreEstudiante = rs.getString("nombres") + " " + rs.getString("apellidos");
                String nombreCampana = rs.getString("titulo");
                return new String[]{nombreEstudiante, nombreCampana};
            }
            
        } catch (SQLException e) {
            System.err.println("Error obteniendo información de asistencia: " + e.getMessage());
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
    
    private String obtenerNombreEstudiante(int idEstudiante) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT nombres, apellidos FROM usuarios WHERE id_usuario = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idEstudiante);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("nombres") + " " + rs.getString("apellidos");
            }
            
        } catch (SQLException e) {
            System.err.println("Error obteniendo nombre estudiante: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) ConexionDB.cerrarConexion(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return "Estudiante desconocido";
    }
    
    private String obtenerNombreCampana(int idCampana) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT titulo FROM campanas WHERE id_campana = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idCampana);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("titulo");
            }
            
        } catch (SQLException e) {
            System.err.println("Error obteniendo nombre campaña: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) ConexionDB.cerrarConexion(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return "Campaña desconocida";
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported");
    }
}