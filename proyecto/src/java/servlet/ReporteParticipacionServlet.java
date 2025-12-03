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
 * Servlet para generar Reporte de Participación en PDF
 */
public class ReporteParticipacionServlet extends HttpServlet {

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
            
            // Consultar estadísticas de participación por campaña
            String sql = "SELECT " +
                        "    c.id_campana, " +
                        "    c.titulo AS campana_titulo, " +
                        "    c.fecha AS campana_fecha, " +
                        "    c.lugar, " +
                        "    c.cupos_total, " +
                        "    COUNT(DISTINCT i.id_inscripcion) AS total_inscritos, " +
                        "    COUNT(DISTINCT a.id_asistencia) AS total_asistieron, " +
                        "    COUNT(DISTINCT cert.id_certificado) AS total_certificados " +
                        "FROM campanas c " +
                        "LEFT JOIN inscripciones i ON c.id_campana = i.id_campana " +
                        "LEFT JOIN asistencias a ON i.id_inscripcion = a.id_inscripcion " +
                        "LEFT JOIN certificados cert ON c.id_campana = cert.id_campana " +
                        "WHERE c.id_coordinador = ? " +
                        "GROUP BY c.id_campana " +
                        "ORDER BY c.fecha DESC";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idCoordinador);
            rs = ps.executeQuery();
            
            // Configurar respuesta HTTP para PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Reporte_Participacion.pdf\"");
            
            // Crear documento PDF
            Document document = new Document(PageSize.A4, 40, 40, 50, 50);
            PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
            
            document.open();
            
            // Colores
            BaseColor azulUPT = new BaseColor(0, 61, 122);
            BaseColor azulClaro = new BaseColor(0, 102, 204);
            
            // Fuentes
            Font fontTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, azulUPT);
            Font fontSubtitulo = FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.GRAY);
            Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);
            Font fontCellBold = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9);
            Font fontCell = FontFactory.getFont(FontFactory.HELVETICA, 9);
            
            // === HEADER ===
            Paragraph titulo = new Paragraph("REPORTE DE PARTICIPACIÓN", fontTitulo);
            titulo.setAlignment(Element.ALIGN_CENTER);
            titulo.setSpacingAfter(5);
            document.add(titulo);
            
            SimpleDateFormat sdfCompleto = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            Paragraph fecha = new Paragraph("Generado: " + sdfCompleto.format(new java.util.Date()), fontSubtitulo);
            fecha.setAlignment(Element.ALIGN_CENTER);
            fecha.setSpacingAfter(20);
            document.add(fecha);
            
            // === TABLA DE PARTICIPACIÓN ===
            PdfPTable table = new PdfPTable(7);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{3f, 1.5f, 1.5f, 1f, 1f, 1f, 1f});
            table.setSpacingBefore(10);
            
            // Headers
            String[] headers = {"Campaña", "Fecha", "Lugar", "Cupos", "Inscritos", "Asistieron", "Certificados"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, fontHeader));
                cell.setBackgroundColor(azulUPT);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                cell.setPadding(8);
                table.addCell(cell);
            }
            
            // Datos
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            int totalCupos = 0;
            int totalInscritos = 0;
            int totalAsistieron = 0;
            int totalCertificados = 0;
            
            while (rs.next()) {
                // Campaña
                PdfPCell cellCampana = new PdfPCell(new Phrase(rs.getString("campana_titulo"), fontCell));
                cellCampana.setPadding(6);
                table.addCell(cellCampana);
                
                // Fecha
                PdfPCell cellFecha = new PdfPCell(new Phrase(sdf.format(rs.getDate("campana_fecha")), fontCell));
                cellFecha.setHorizontalAlignment(Element.ALIGN_CENTER);
                cellFecha.setPadding(6);
                table.addCell(cellFecha);
                
                // Lugar
                PdfPCell cellLugar = new PdfPCell(new Phrase(rs.getString("lugar"), fontCell));
                cellLugar.setPadding(6);
                table.addCell(cellLugar);
                
                // Cupos
                int cupos = rs.getInt("cupos_total");
                totalCupos += cupos;
                PdfPCell cellCupos = new PdfPCell(new Phrase(String.valueOf(cupos), fontCell));
                cellCupos.setHorizontalAlignment(Element.ALIGN_CENTER);
                cellCupos.setPadding(6);
                table.addCell(cellCupos);
                
                // Inscritos
                int inscritos = rs.getInt("total_inscritos");
                totalInscritos += inscritos;
                PdfPCell cellInscritos = new PdfPCell(new Phrase(String.valueOf(inscritos), fontCellBold));
                cellInscritos.setHorizontalAlignment(Element.ALIGN_CENTER);
                cellInscritos.setPadding(6);
                table.addCell(cellInscritos);
                
                // Asistieron
                int asistieron = rs.getInt("total_asistieron");
                totalAsistieron += asistieron;
                PdfPCell cellAsistieron = new PdfPCell(new Phrase(String.valueOf(asistieron), fontCellBold));
                cellAsistieron.setHorizontalAlignment(Element.ALIGN_CENTER);
                cellAsistieron.setPadding(6);
                cellAsistieron.setBackgroundColor(new BaseColor(220, 255, 220));
                table.addCell(cellAsistieron);
                
                // Certificados
                int certificados = rs.getInt("total_certificados");
                totalCertificados += certificados;
                PdfPCell cellCertificados = new PdfPCell(new Phrase(String.valueOf(certificados), fontCellBold));
                cellCertificados.setHorizontalAlignment(Element.ALIGN_CENTER);
                cellCertificados.setPadding(6);
                cellCertificados.setBackgroundColor(new BaseColor(255, 245, 220));
                table.addCell(cellCertificados);
            }
            
            // Fila de totales
            PdfPCell cellTotalLabel = new PdfPCell(new Phrase("TOTALES", fontCellBold));
            cellTotalLabel.setColspan(3);
            cellTotalLabel.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cellTotalLabel.setBackgroundColor(new BaseColor(240, 240, 240));
            cellTotalLabel.setPadding(8);
            table.addCell(cellTotalLabel);
            
            PdfPCell cellTotalCupos = new PdfPCell(new Phrase(String.valueOf(totalCupos), fontCellBold));
            cellTotalCupos.setHorizontalAlignment(Element.ALIGN_CENTER);
            cellTotalCupos.setBackgroundColor(new BaseColor(240, 240, 240));
            cellTotalCupos.setPadding(8);
            table.addCell(cellTotalCupos);
            
            PdfPCell cellTotalInscritos = new PdfPCell(new Phrase(String.valueOf(totalInscritos), fontCellBold));
            cellTotalInscritos.setHorizontalAlignment(Element.ALIGN_CENTER);
            cellTotalInscritos.setBackgroundColor(new BaseColor(240, 240, 240));
            cellTotalInscritos.setPadding(8);
            table.addCell(cellTotalInscritos);
            
            PdfPCell cellTotalAsistieron = new PdfPCell(new Phrase(String.valueOf(totalAsistieron), fontCellBold));
            cellTotalAsistieron.setHorizontalAlignment(Element.ALIGN_CENTER);
            cellTotalAsistieron.setBackgroundColor(new BaseColor(200, 255, 200));
            cellTotalAsistieron.setPadding(8);
            table.addCell(cellTotalAsistieron);
            
            PdfPCell cellTotalCertificados = new PdfPCell(new Phrase(String.valueOf(totalCertificados), fontCellBold));
            cellTotalCertificados.setHorizontalAlignment(Element.ALIGN_CENTER);
            cellTotalCertificados.setBackgroundColor(new BaseColor(255, 230, 200));
            cellTotalCertificados.setPadding(8);
            table.addCell(cellTotalCertificados);
            
            document.add(table);
            
            // === RESUMEN ESTADÍSTICO ===
            document.add(new Paragraph(" "));
            
            Paragraph resumenTitulo = new Paragraph("Resumen Estadístico", fontCellBold);
            resumenTitulo.setSpacingBefore(15);
            resumenTitulo.setSpacingAfter(10);
            document.add(resumenTitulo);
            
            double tasaAsistencia = totalInscritos > 0 ? (totalAsistieron * 100.0 / totalInscritos) : 0;
            double tasaCertificacion = totalAsistieron > 0 ? (totalCertificados * 100.0 / totalAsistieron) : 0;
            double tasaOcupacion = totalCupos > 0 ? (totalInscritos * 100.0 / totalCupos) : 0;
            
            Paragraph stats = new Paragraph();
            stats.add(new Chunk("• Tasa de Asistencia: ", fontCellBold));
            stats.add(new Chunk(String.format("%.1f%% (%d de %d inscritos)\n", tasaAsistencia, totalAsistieron, totalInscritos), fontCell));
            stats.add(new Chunk("• Tasa de Certificación: ", fontCellBold));
            stats.add(new Chunk(String.format("%.1f%% (%d de %d asistentes)\n", tasaCertificacion, totalCertificados, totalAsistieron), fontCell));
            stats.add(new Chunk("• Tasa de Ocupación: ", fontCellBold));
            stats.add(new Chunk(String.format("%.1f%% (%d de %d cupos)", tasaOcupacion, totalInscritos, totalCupos), fontCell));
            
            document.add(stats);
            
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
