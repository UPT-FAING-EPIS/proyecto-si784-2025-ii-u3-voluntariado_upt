package negocio;

import conexion.ConexionDB;
import entidad.Campana;
import entidad.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class coordinadornegocio {
    
    // Método para crear una nueva campaña
    public boolean crearCampana(Campana campana) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "INSERT INTO campanas (titulo, descripcion, fecha, hora_inicio, " +
                        "hora_fin, lugar, cupos_total, cupos_disponibles, requisitos, " +
                        "estado, id_coordinador) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, campana.getTitulo());
            ps.setString(2, campana.getDescripcion());
            ps.setDate(3, campana.getFecha());
            ps.setTime(4, campana.getHoraInicio());
            ps.setTime(5, campana.getHoraFin());
            ps.setString(6, campana.getLugar());
            ps.setInt(7, campana.getCuposTotal());
            ps.setInt(8, campana.getCuposDisponibles());
            ps.setString(9, campana.getRequisitos());
            ps.setString(10, campana.getEstado());
            ps.setInt(11, campana.getIdCoordinador());
            
            int filasAfectadas = ps.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al crear campaña: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }
    
    /**
     * Obtiene todas las campañas creadas por un coordinador específico
     * @param idCoordinador ID del coordinador
     * @return Lista de campañas del coordinador
     */
    public List<Campana> obtenerCampanasPorCoordinador(int idCoordinador) {
        List<Campana> campanas = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT * FROM campanas WHERE id_coordinador = ? ORDER BY fecha_creacion DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idCoordinador);
            rs = ps.executeQuery();
            
            System.out.println("Ejecutando consulta para coordinador " + idCoordinador + ": " + sql);
            int contador = 0;
            
            while (rs.next()) {
                contador++;
                Campana campana = new Campana();
                campana.setIdCampana(rs.getInt("id_campana")); // Corregir nombre de columna
                campana.setTitulo(rs.getString("titulo"));
                campana.setDescripcion(rs.getString("descripcion"));
                campana.setFecha(rs.getDate("fecha"));
                campana.setHoraInicio(rs.getTime("hora_inicio"));
                campana.setHoraFin(rs.getTime("hora_fin"));
                campana.setLugar(rs.getString("lugar"));
                campana.setCuposTotal(rs.getInt("cupos_total"));
                campana.setCuposDisponibles(rs.getInt("cupos_disponibles"));
                campana.setRequisitos(rs.getString("requisitos"));
                campana.setEstado(rs.getString("estado"));
                campana.setIdCoordinador(rs.getInt("id_coordinador"));
                campana.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                
                System.out.println("Campaña encontrada: " + campana.getTitulo() + " - ID: " + campana.getIdCampana());
                campanas.add(campana);
            }
            
            System.out.println("Total de campañas encontradas para coordinador " + idCoordinador + ": " + contador);
            
        } catch (SQLException e) {
            System.out.println("Error al obtener campañas del coordinador: " + e.getMessage());
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
        
        return campanas;
    }
    
    /**
     * Obtiene una campaña específica por su ID
     * @param idCampana ID de la campaña
     * @return Objeto Campana o null si no se encuentra
     */
    public Campana obtenerCampanaPorId(int idCampana) {
        Campana campana = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT * FROM campanas WHERE id_campana = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idCampana);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                campana = new Campana();
                campana.setIdCampana(rs.getInt("id_campana")); // Corregir nombre de columna
                campana.setTitulo(rs.getString("titulo"));
                campana.setDescripcion(rs.getString("descripcion"));
                campana.setFecha(rs.getDate("fecha"));
                campana.setHoraInicio(rs.getTime("hora_inicio"));
                campana.setHoraFin(rs.getTime("hora_fin"));
                campana.setLugar(rs.getString("lugar"));
                campana.setCuposTotal(rs.getInt("cupos_total"));
                campana.setCuposDisponibles(rs.getInt("cupos_disponibles"));
                campana.setRequisitos(rs.getString("requisitos"));
                campana.setEstado(rs.getString("estado"));
                campana.setIdCoordinador(rs.getInt("id_coordinador"));
                campana.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
            }
            
        } catch (SQLException e) {
            System.out.println("Error al obtener campaña por ID: " + e.getMessage());
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
        
        return campana;
    }
    
    /**
     * Actualiza una campaña existente
     * @param campana Objeto Campana con los datos actualizados
     * @return true si se actualizó correctamente, false en caso contrario
     */
    public boolean actualizarCampana(Campana campana) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "UPDATE campanas SET titulo = ?, descripcion = ?, fecha = ?, " +
                        "hora_inicio = ?, hora_fin = ?, lugar = ?, cupos_total = ?, " +
                        "cupos_disponibles = ?, requisitos = ?, estado = ? " +
                        "WHERE id_campana = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, campana.getTitulo());
            ps.setString(2, campana.getDescripcion());
            ps.setDate(3, campana.getFecha());
            ps.setTime(4, campana.getHoraInicio());
            ps.setTime(5, campana.getHoraFin());
            ps.setString(6, campana.getLugar());
            ps.setInt(7, campana.getCuposTotal());
            ps.setInt(8, campana.getCuposDisponibles());
            ps.setString(9, campana.getRequisitos());
            ps.setString(10, campana.getEstado());
            ps.setInt(11, campana.getIdCampana());
            
            int filasAfectadas = ps.executeUpdate();
            resultado = filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al actualizar campaña: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) ConexionDB.cerrarConexion(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }
    
    /**
     * Cuenta el número total de campañas de un coordinador
     * @param idCoordinador ID del coordinador
     * @return Número de campañas
     */
    public int contarCampanasPorCoordinador(int idCoordinador) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int total = 0;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT COUNT(*) as total FROM campanas WHERE id_coordinador = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idCoordinador);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.out.println("Error al contar campañas del coordinador: " + e.getMessage());
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
        
        return total;
    }
    
    /**
     * Cuenta el número total de inscritos en las campañas de un coordinador
     * @param idCoordinador ID del coordinador
     * @return Número de inscritos
     */
    public int contarInscritosPorCoordinador(int idCoordinador) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int total = 0;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT COUNT(i.id_inscripcion) as total " +
                        "FROM inscripciones i " +
                        "INNER JOIN campanas c ON i.id_campana = c.id_campana " +
                        "WHERE c.id_coordinador = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idCoordinador);
            rs = ps.executeQuery();
            
            System.out.println("Ejecutando consulta de conteo para coordinador " + idCoordinador + ": " + sql);
            
            if (rs.next()) {
                total = rs.getInt("total");
                System.out.println("Total de inscritos encontrados: " + total);
            }
            
        } catch (SQLException e) {
            System.out.println("Error al contar inscritos del coordinador: " + e.getMessage());
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
        
        return total;
    }
    
    /**
     * Obtiene las inscripciones de las campañas de un coordinador con información del estudiante
     * @param idCoordinador ID del coordinador
     * @return Lista de inscripciones con información del estudiante y campaña
     */
    public List<Map<String, Object>> obtenerInscripcionesPorCoordinador(int idCoordinador) {
        List<Map<String, Object>> inscripciones = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT i.id_inscripcion, i.fecha_inscripcion, " +
                        "u.nombres, u.apellidos, u.codigo, u.correo, " +
                        "c.titulo as campana_titulo, c.id_campana " +
                        "FROM inscripciones i " +
                        "INNER JOIN campanas c ON i.id_campana = c.id_campana " +
                        "INNER JOIN usuarios u ON i.id_estudiante = u.id_usuario " +
                        "WHERE c.id_coordinador = ? " +
                        "ORDER BY i.fecha_inscripcion DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idCoordinador);
            rs = ps.executeQuery();
            
            System.out.println("Ejecutando consulta de inscripciones para coordinador " + idCoordinador + ": " + sql);
            
            while (rs.next()) {
                Map<String, Object> inscripcion = new HashMap<>();
                inscripcion.put("idInscripcion", rs.getInt("id_inscripcion"));
                inscripcion.put("fechaInscripcion", rs.getTimestamp("fecha_inscripcion"));
                inscripcion.put("nombreEstudiante", rs.getString("nombres") + " " + rs.getString("apellidos"));
                inscripcion.put("codigoEstudiante", rs.getString("codigo"));
                inscripcion.put("emailEstudiante", rs.getString("correo"));
                inscripcion.put("campanaTitulo", rs.getString("campana_titulo"));
                inscripcion.put("idCampana", rs.getInt("id_campana"));
                
                inscripciones.add(inscripcion);
            }
            
            System.out.println("Total de inscripciones encontradas: " + inscripciones.size());
            
        } catch (SQLException e) {
            System.out.println("Error al obtener inscripciones del coordinador: " + e.getMessage());
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
        
        return inscripciones;
    }
    
    /**
     * Cuenta el número de asistencias registradas en una campaña específica
     * @param idCampana ID de la campaña
     * @return Número de asistencias
     */
    public int contarAsistenciasPorCampana(int idCampana) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int total = 0;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT COUNT(*) as total FROM asistencias WHERE id_campana = ? AND presente = 1";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idCampana);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.out.println("Error al contar asistencias de campaña: " + e.getMessage());
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
        
        return total;
    }
    
    /**
     * Cuenta el número de certificados emitidos en una campaña específica
     * @param idCampana ID de la campaña
     * @return Número de certificados
     */
    public int contarCertificadosPorCampana(int idCampana) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int total = 0;
        
        try {
            conn = ConexionDB.getConnection();
            String sql = "SELECT COUNT(*) as total FROM certificados WHERE id_campana = ? AND activo = 1";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idCampana);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.out.println("Error al contar certificados de campaña: " + e.getMessage());
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
        
        return total;
    }
}