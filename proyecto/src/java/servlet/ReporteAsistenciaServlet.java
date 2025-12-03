package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import conexion.ConexionDB;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import java.text.SimpleDateFormat;

/**
 * Servlet para generar Reporte de Estadísticas de Asistencia en PDF
 */
public class ReporteAsistenciaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer idCoordinador = null;
        
        if (session.getAttribute("usuario") != null) {
            entidad.Usuario coordinador = (entidad.Usuario) session.getAttribute("usuario");
            idCoordinador = coordinador.getIdUsuario();
        } else {
            response.sendRedirect("../index.jsp");
            return;
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            
            // Configurar respuesta HTTP para PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Estadisticas_Asistencia.pdf\"");
            
            // Crear documento PDF
            Document document = new Document(PageSize.A4, 40, 40, 50, 50);
            PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
            
            document.open();
            
            // Colores
            BaseColor azulUPT = new BaseColor(0, 61, 122);
            BaseColor verde = new BaseColor(40, 167, 69);
            BaseColor amarillo = new BaseColor(255, 193, 7);
            
            // Fuentes
            Font fontTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, azulUPT);
            Font fontSubtitulo = FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.GRAY);
            Font fontSeccion = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, azulUPT);
            Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);
            Font fontCellBold = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9);
            Font fontCell = FontFactory.getFont(FontFactory.HELVETICA, 9);
            
            // === HEADER ===
            Paragraph titulo = new Paragraph("ESTADÍSTICAS DE ASISTENCIA", fontTitulo);
            titulo.setAlignment(Element.ALIGN_CENTER);
            titulo.setSpacingAfter(5);
            document.add(titulo);
            
            SimpleDateFormat sdfCompleto = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            Paragraph fecha = new Paragraph("Generado: " + sdfCompleto.format(new java.util.Date()), fontSubtitulo);
            fecha.setAlignment(Element.ALIGN_CENTER);
            fecha.setSpacingAfter(20);
            document.add(fecha);
            
            // === SECCIÓN 1: ASISTENCIA POR CAMPAÑA ===
            Paragraph seccion1 = new Paragraph("1. Asistencia por Campaña", fontSeccion);
            seccion1.setSpacingAfter(10);
            document.add(seccion1);
            
            String sql1 = "SELECT " +
                         "    c.titulo AS campana, " +
                         "    c.fecha, " +
                         "    COUNT(DISTINCT i.id_inscripcion) AS inscritos, " +
                         "    COUNT(DISTINCT a.id_asistencia) AS asistieron, " +
                         "    ROUND((COUNT(DISTINCT a.id_asistencia) * 100.0 / NULLIF(COUNT(DISTINCT i.id_inscripcion), 0)), 1) AS porcentaje " +
                         "FROM campanas c " +
                         "LEFT JOIN inscripciones i ON c.id_campana = i.id_campana " +
                         "LEFT JOIN asistencias a ON i.id_inscripcion = a.id_inscripcion " +
                         "WHERE c.id_coordinador = ? " +
                         "GROUP BY c.id_campana " +
                         "ORDER BY c.fecha DESC";
            
            ps = conn.prepareStatement(sql1);
            ps.setInt(1, idCoordinador);
            rs = ps.executeQuery();
            
            PdfPTable table1 = new PdfPTable(5);
            table1.setWidthPercentage(100);
            table1.setWidths(new float[]{3f, 1.5f, 1f, 1f, 1f});
            
            // Headers
            String[] headers1 = {"Campaña", "Fecha", "Inscritos", "Asistieron", "% Asistencia"};
            for (String header : headers1) {
                PdfPCell cell = new PdfPCell(new Phrase(header, fontHeader));
                cell.setBackgroundColor(azulUPT);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(8);
                table1.addCell(cell);
            }
            
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            
            while (rs.next()) {
                table1.addCell(createCell(rs.getString("campana"), fontCell, Element.ALIGN_LEFT));
                table1.addCell(createCell(sdf.format(rs.getDate("fecha")), fontCell, Element.ALIGN_CENTER));
                table1.addCell(createCell(String.valueOf(rs.getInt("inscritos")), fontCell, Element.ALIGN_CENTER));
                table1.addCell(createCell(String.valueOf(rs.getInt("asistieron")), fontCellBold, Element.ALIGN_CENTER));
                
                double porcentaje = rs.getDouble("porcentaje");
                PdfPCell cellPorcentaje = new PdfPCell(new Phrase(String.format("%.1f%%", porcentaje), fontCellBold));
                cellPorcentaje.setHorizontalAlignment(Element.ALIGN_CENTER);
                cellPorcentaje.setPadding(6);
                if (porcentaje >= 80) {
                    cellPorcentaje.setBackgroundColor(new BaseColor(220, 255, 220));
                } else if (porcentaje >= 50) {
                    cellPorcentaje.setBackgroundColor(new BaseColor(255, 245, 220));
                } else {
                    cellPorcentaje.setBackgroundColor(new BaseColor(255, 220, 220));
                }
                table1.addCell(cellPorcentaje);
            }
            
            document.add(table1);
            rs.close();
            ps.close();
            
            // === SECCIÓN 2: ASISTENCIA POR TIPO DE REGISTRO ===
            document.add(new Paragraph(" "));
            Paragraph seccion2 = new Paragraph("2. Tipo de Registro de Asistencia", fontSeccion);
            seccion2.setSpacingBefore(15);
            seccion2.setSpacingAfter(10);
            document.add(seccion2);
            
            String sql2 = "SELECT " +
                         "    a.tipo_registro, " +
                         "    COUNT(*) AS total " +
                         "FROM asistencias a " +
                         "INNER JOIN inscripciones i ON a.id_inscripcion = i.id_inscripcion " +
                         "INNER JOIN campanas c ON i.id_campana = c.id_campana " +
                         "WHERE c.id_coordinador = ? " +
                         "GROUP BY a.tipo_registro";
            
            ps = conn.prepareStatement(sql2);
            ps.setInt(1, idCoordinador);
            rs = ps.executeQuery();
            
            PdfPTable table2 = new PdfPTable(3);
            table2.setWidthPercentage(60);
            table2.setHorizontalAlignment(Element.ALIGN_CENTER);
            table2.setWidths(new float[]{2f, 1f, 1f});
            
            // Headers
            String[] headers2 = {"Tipo de Registro", "Total", "%"};
            for (String header : headers2) {
                PdfPCell cell = new PdfPCell(new Phrase(header, fontHeader));
                cell.setBackgroundColor(azulUPT);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(8);
                table2.addCell(cell);
            }
            
            int totalRegistros = 0;
            java.util.List<Object[]> registros = new java.util.ArrayList<>();
            
            while (rs.next()) {
                int total = rs.getInt("total");
                totalRegistros += total;
                registros.add(new Object[]{rs.getString("tipo_registro"), total});
            }
            
            for (Object[] reg : registros) {
                table2.addCell(createCell((String)reg[0], fontCell, Element.ALIGN_LEFT));
                table2.addCell(createCell(String.valueOf(reg[1]), fontCellBold, Element.ALIGN_CENTER));
                double porcentaje = totalRegistros > 0 ? ((Integer)reg[1] * 100.0 / totalRegistros) : 0;
                table2.addCell(createCell(String.format("%.1f%%", porcentaje), fontCell, Element.ALIGN_CENTER));
            }
            
            document.add(table2);
            rs.close();
            ps.close();
            
            // === SECCIÓN 3: TOP ESTUDIANTES ===
            document.add(new Paragraph(" "));
            Paragraph seccion3 = new Paragraph("3. Top 10 Estudiantes Más Participativos", fontSeccion);
            seccion3.setSpacingBefore(15);
            seccion3.setSpacingAfter(10);
            document.add(seccion3);
            
            String sql3 = "SELECT " +
                         "    u.nombres, " +
                         "    u.apellidos, " +
                         "    u.codigo, " +
                         "    COUNT(DISTINCT a.id_asistencia) AS total_asistencias, " +
                         "    COUNT(DISTINCT cert.id_certificado) AS total_certificados " +
                         "FROM usuarios u " +
                         "INNER JOIN inscripciones i ON u.id_usuario = i.id_estudiante " +
                         "INNER JOIN campanas c ON i.id_campana = c.id_campana " +
                         "LEFT JOIN asistencias a ON i.id_inscripcion = a.id_inscripcion " +
                         "LEFT JOIN certificados cert ON u.id_usuario = cert.id_estudiante " +
                         "WHERE c.id_coordinador = ? " +
                         "GROUP BY u.id_usuario " +
                         "ORDER BY total_asistencias DESC, total_certificados DESC " +
                         "LIMIT 10";
            
            ps = conn.prepareStatement(sql3);
            ps.setInt(1, idCoordinador);
            rs = ps.executeQuery();
            
            PdfPTable table3 = new PdfPTable(5);
            table3.setWidthPercentage(100);
            table3.setWidths(new float[]{0.5f, 2f, 2f, 1f, 1f});
            
            // Headers
            String[] headers3 = {"#", "Nombres", "Apellidos", "Asistencias", "Certificados"};
            for (String header : headers3) {
                PdfPCell cell = new PdfPCell(new Phrase(header, fontHeader));
                cell.setBackgroundColor(verde);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(8);
                table3.addCell(cell);
            }
            
            int rank = 1;
            while (rs.next()) {
                table3.addCell(createCell(String.valueOf(rank++), fontCell, Element.ALIGN_CENTER));
                table3.addCell(createCell(rs.getString("nombres"), fontCell, Element.ALIGN_LEFT));
                table3.addCell(createCell(rs.getString("apellidos"), fontCell, Element.ALIGN_LEFT));
                table3.addCell(createCell(String.valueOf(rs.getInt("total_asistencias")), fontCellBold, Element.ALIGN_CENTER));
                table3.addCell(createCell(String.valueOf(rs.getInt("total_certificados")), fontCellBold, Element.ALIGN_CENTER));
            }
            
            document.add(table3);
            
            // Footer
            Paragraph footer = new Paragraph("Universidad Privada de Tacna - Sistema de Voluntariado", 
                                           FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 8, BaseColor.GRAY));
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setSpacingBefore(30);
            document.add(footer);
            
            document.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error de base de datos: " + e.getMessage());
        } catch (DocumentException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generando PDF: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { }
            if (ps != null) try { ps.close(); } catch (SQLException e) { }
            if (conn != null) ConexionDB.cerrarConexion(conn);
        }
    }
    
    private PdfPCell createCell(String text, Font font, int alignment) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setHorizontalAlignment(alignment);
        cell.setPadding(6);
        return cell;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
