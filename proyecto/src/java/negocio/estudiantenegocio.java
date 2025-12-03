/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package negocio;

/**
 *
 * @author Mi Equipo
 */

import conexion.ConexionDB;
import entidad.Usuario;
import entidad.Campana;
import entidad.estudianteentidad;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class estudiantenegocio {
    
    private ConexionDB conexion;
    
    public estudiantenegocio() {
        this.conexion = new ConexionDB();
    }
    
    /**
     * Obtiene todas las campañas disponibles para inscripción
     * @return Lista de campañas disponibles
     */
    public List<Campana> obtenerCampanasDisponibles() {
        List<Campana> campanas = new ArrayList<>();
        String sql = "SELECT * FROM campanas WHERE estado = 'PUBLICADA' ORDER BY fecha ASC, hora_inicio ASC";
        
        try (Connection conn = conexion.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("Ejecutando consulta: " + sql);
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
                
                System.out.println("Campaña encontrada: " + campana.getTitulo() + " - Estado: " + campana.getEstado());
                campanas.add(campana);
            }
            
            System.out.println("Total de campañas encontradas: " + contador);
            
        } catch (SQLException e) {
            System.err.println("Error al obtener campañas disponibles: " + e.getMessage());
            e.printStackTrace();
        }
        
        return campanas;
    }
    
    /**
     * Obtiene las estadísticas de un estudiante
     * @param idUsuario ID del usuario estudiante
     * @return Objeto con las estadísticas del estudiante
     */
    public estudianteentidad obtenerEstadisticasEstudiante(int idUsuario) {
        estudianteentidad estadisticas = new estudianteentidad();
        
        try (Connection conn = conexion.getConnection()) {
            
            // Obtener horas acumuladas
            String sqlHoras = "SELECT COALESCE(SUM(TIMESTAMPDIFF(HOUR, c.hora_inicio, c.hora_fin)), 0) as horasTotal " +
                             "FROM inscripciones i " +
                             "INNER JOIN campanas c ON i.id_campana = c.id_campana " +
                             "INNER JOIN asistencias a ON i.id_inscripcion = a.id_inscripcion " +
                             "WHERE i.id_estudiante = ? AND a.presente = 1";
            
            try (PreparedStatement stmt = conn.prepareStatement(sqlHoras)) {
                stmt.setInt(1, idUsuario);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        estadisticas.setHorasAcumuladas(rs.getInt("horasTotal"));
                    }
                }
            }
            
            // Obtener número de campañas inscritas activas
            String sqlCampanas = "SELECT COUNT(*) as totalCampanas " +
                               "FROM inscripciones i " +
                               "INNER JOIN campanas c ON i.id_campana = c.id_campana " +
                               "WHERE i.id_estudiante = ? AND c.estado = 'PUBLICADA'";
            
            try (PreparedStatement stmt = conn.prepareStatement(sqlCampanas)) {
                stmt.setInt(1, idUsuario);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        estadisticas.setCampanasInscritas(rs.getInt("totalCampanas"));
                    }
                }
            }
            
            // Obtener número de certificados
            String sqlCertificados = "SELECT COUNT(*) as totalCertificados " +
                                   "FROM certificados " +
                                   "WHERE id_estudiante = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sqlCertificados)) {
                stmt.setInt(1, idUsuario);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        estadisticas.setCertificadosObtenidos(rs.getInt("totalCertificados"));
                    }
                }
            }
            
            // Calcular ranking (posición basada en horas acumuladas)
            String sqlRanking = "SELECT COUNT(*) + 1 as ranking " +
                              "FROM (" +
                              "    SELECT i.id_estudiante, SUM(TIMESTAMPDIFF(HOUR, c.hora_inicio, c.hora_fin)) as horasTotal " +
                              "    FROM inscripciones i " +
                              "    INNER JOIN campanas c ON i.id_campana = c.id_campana " +
                              "    INNER JOIN asistencias a ON i.id_inscripcion = a.id_inscripcion " +
                              "    WHERE a.presente = 1 " +
                              "    GROUP BY i.id_estudiante " +
                              "    HAVING horasTotal > ? " +
                              ") as ranking_table";
            
            try (PreparedStatement stmt = conn.prepareStatement(sqlRanking)) {
                stmt.setInt(1, estadisticas.getHorasAcumuladas());
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        estadisticas.setRanking(rs.getInt("ranking"));
                    }
                }
            }
            
            estadisticas.setIdEstudiante(idUsuario);
            
        } catch (SQLException e) {
            System.err.println("Error al obtener estadísticas del estudiante: " + e.getMessage());
            e.printStackTrace();
        }
        
        return estadisticas;
    }
    
    /**
     * Obtiene las inscripciones de un estudiante
     * @param idUsuario ID del usuario estudiante
     * @return Lista de campañas en las que está inscrito
     */
    /**
     * Obtiene las campañas en las que está inscrito un estudiante
     * @param idUsuario ID del usuario estudiante
     * @return Lista de campañas inscritas
     */
    public List<Campana> obtenerInscripcionesEstudiante(int idUsuario) {
        List<Campana> inscripciones = new ArrayList<>();
        String sql = "SELECT c.* FROM campanas c " +
                    "INNER JOIN inscripciones i ON c.id_campana = i.id_campana " +
                    "WHERE i.id_estudiante = ? " +
                    "ORDER BY c.fecha ASC, c.hora_inicio ASC";
        
        try (Connection conn = conexion.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Campana campana = new Campana();
                    campana.setIdCampana(rs.getInt("id_campana"));
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
                    
                    inscripciones.add(campana);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener inscripciones del estudiante: " + e.getMessage());
            e.printStackTrace();
        }
        
        return inscripciones;
    }
    
    /**
     * Verifica si un estudiante ya está inscrito en una campaña específica
     * @param idUsuario ID del usuario estudiante
     * @param idCampana ID de la campaña
     * @return true si ya está inscrito, false en caso contrario
     */
    public boolean estaInscrito(int idUsuario, int idCampana) {
        boolean inscrito = false;
        String sql = "SELECT COUNT(*) as total FROM inscripciones WHERE id_estudiante = ? AND id_campana = ?";
        
        System.out.println("Verificando inscripción previa - Usuario: " + idUsuario + ", Campaña: " + idCampana);
        
        try (Connection conn = conexion.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idCampana);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt("total");
                    inscrito = total > 0;
                    System.out.println("Inscripciones encontradas: " + total + ", Ya inscrito: " + inscrito);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al verificar inscripción: " + e.getMessage());
            e.printStackTrace();
        }
        
        return inscrito;
    }
    
    /**
     * Cuenta el número total de campañas disponibles
     * @return Número de campañas disponibles
     */
    public int contarCampanasDisponibles() {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM campanas WHERE estado = 'PUBLICADA'";
        
        try (Connection conn = conexion.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                total = rs.getInt("total");
            }
            
            System.out.println("Total de campañas disponibles contadas: " + total);
            
        } catch (SQLException e) {
            System.err.println("Error al contar campañas disponibles: " + e.getMessage());
            e.printStackTrace();
        }
        
        return total;
    }
    
    /**
     * Inscribe a un estudiante en una campaña
     * @param idUsuario ID del usuario estudiante
     * @param idCampana ID de la campaña
     * @return true si se inscribió correctamente, false en caso contrario
     */
    public boolean inscribirseEnCampana(int idUsuario, int idCampana) {
        boolean resultado = false;
        
        System.out.println("Iniciando inscripción - Usuario: " + idUsuario + ", Campaña: " + idCampana);
        
        try (Connection conn = conexion.getConnection()) {
            
            // Verificar si ya está inscrito
            System.out.println("Verificando si el usuario ya está inscrito...");
            if (estaInscrito(idUsuario, idCampana)) {
                System.out.println("El usuario " + idUsuario + " ya está inscrito en la campaña " + idCampana);
                return false;
            }
            System.out.println("Usuario no está inscrito previamente");
            
            // Verificar si hay cupos disponibles
            System.out.println("Verificando cupos disponibles...");
            String sqlCupos = "SELECT cupos_disponibles, estado FROM campanas WHERE id_campana = ?";
            try (PreparedStatement stmtCupos = conn.prepareStatement(sqlCupos)) {
                stmtCupos.setInt(1, idCampana);
                try (ResultSet rs = stmtCupos.executeQuery()) {
                    if (rs.next()) {
                        int cuposDisponibles = rs.getInt("cupos_disponibles");
                        String estado = rs.getString("estado");
                        
                        System.out.println("Campaña encontrada - Cupos disponibles: " + cuposDisponibles + ", Estado: " + estado);
                        
                        if (!"PUBLICADA".equals(estado)) {
                            System.out.println("La campaña no está en estado PUBLICADA: " + estado);
                            return false;
                        }
                        
                        if (cuposDisponibles <= 0) {
                            System.out.println("No hay cupos disponibles en la campaña " + idCampana);
                            return false;
                        }
                    } else {
                        System.out.println("Campaña no encontrada: " + idCampana);
                        return false;
                    }
                }
            }
            
            // Iniciar transacción
            System.out.println("Iniciando transacción...");
            conn.setAutoCommit(false);
            
            try {
                // Insertar inscripción - CORREGIDO: usar id_estudiante en lugar de idUsuario
                System.out.println("Insertando inscripción...");
                String sqlInscripcion = "INSERT INTO inscripciones (id_estudiante, id_campana, fecha_inscripcion) VALUES (?, ?, NOW())";
                try (PreparedStatement stmtInscripcion = conn.prepareStatement(sqlInscripcion)) {
                    stmtInscripcion.setInt(1, idUsuario);
                    stmtInscripcion.setInt(2, idCampana);
                    int filasInscripcion = stmtInscripcion.executeUpdate();
                    
                    System.out.println("Filas insertadas en inscripciones: " + filasInscripcion);
                    
                    if (filasInscripcion > 0) {
                        // Actualizar cupos disponibles
                        System.out.println("Actualizando cupos disponibles...");
                        String sqlActualizar = "UPDATE campanas SET cupos_disponibles = cupos_disponibles - 1 WHERE id_campana = ?";
                        try (PreparedStatement stmtActualizar = conn.prepareStatement(sqlActualizar)) {
                            stmtActualizar.setInt(1, idCampana);
                            int filasActualizadas = stmtActualizar.executeUpdate();
                            
                            System.out.println("Filas actualizadas en campanas: " + filasActualizadas);
                            
                            if (filasActualizadas > 0) {
                                conn.commit();
                                resultado = true;
                                System.out.println("Usuario " + idUsuario + " inscrito exitosamente en campaña " + idCampana);
                            } else {
                                conn.rollback();
                                System.out.println("Error al actualizar cupos disponibles - rollback realizado");
                            }
                        }
                    } else {
                        conn.rollback();
                        System.out.println("Error al insertar inscripción - rollback realizado");
                    }
                }
            } catch (SQLException e) {
                System.out.println("Error en transacción: " + e.getMessage());
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al inscribir estudiante en campaña: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Resultado final de inscripción: " + resultado);
        return resultado;
    }
}