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
 * Servlet para generar Reporte General del Sistema en PDF
 */
public class ReporteGeneralServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer idCoordinador = null;
        String nombreCoordinador = "";
        
        if (session.getAttribute("usuario") != null) {
            entidad.Usuario coordinador = (entidad.Usuario) session.getAttribute("usuario");
            idCoordinador = coordinador.getIdUsuario();
            nombreCoordinador = coordinador.getNombres() + " " + coordinador.getApellidos();
        } else {
            response.sendRedirect("../index.jsp");
            return;
        }
        
        Connection conn = null;
        
        try {
            conn = ConexionDB.getConnection();
            
            // Configurar respuesta HTTP para PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"Reporte_General.pdf\"");
            
            // Crear documento PDF
            Document document = new Document(PageSize.A4, 40, 40, 50, 50);
            PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
            
            document.open();
            
            // Colores
            BaseColor azulUPT = new BaseColor(0, 61, 122);
            BaseColor azulClaro = new BaseColor(0, 102, 204);
            BaseColor verde = new BaseColor(40, 167, 69);
            
            // Fuentes
            Font fontTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20, azulUPT);
            Font fontSubtitulo = FontFactory.getFont(FontFactory.HELVETICA, 11, BaseColor.GRAY);
            Font fontSeccion = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, azulUPT);
            Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);
            Font fontCellBold = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9);
            Font fontCell = FontFactory.getFont(FontFactory.HELVETICA, 9);
            Font fontLarge = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 24, azulUPT);
            
            // === HEADER ===
            Paragraph titulo = new Paragraph("REPORTE GENERAL", fontTitulo);
            titulo.setAlignment(Element.ALIGN_CENTER);
            titulo.setSpacingAfter(5);
            document.add(titulo);
            
            Paragraph subtitulo = new Paragraph("Sistema de Voluntariado Universitario", fontSubtitulo);
            subtitulo.setAlignment(Element.ALIGN_CENTER);
            document.add(subtitulo);
            
            SimpleDateFormat sdfCompleto = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            Paragraph fecha = new Paragraph("Generado: " + sdfCompleto.format(new java.util.Date()), fontSubtitulo);
            fecha.setAlignment(Element.ALIGN_CENTER);
            fecha.setSpacingAfter(5);
            document.add(fecha);
            
            Paragraph coordinadorInfo = new Paragraph("Coordinador: " + nombreCoordinador, fontSubtitulo);
            coordinadorInfo.setAlignment(Element.ALIGN_CENTER);
            coordinadorInfo.setSpacingAfter(20);
            document.add(coordinadorInfo);
            
            // === RESUMEN EJECUTIVO ===
            Paragraph seccionResumen = new Paragraph("RESUMEN EJECUTIVO", fontSeccion);
            seccionResumen.setSpacingAfter(15);
            document.add(seccionResumen);
            
            // Obtener métricas principales
            int totalCampanas = 0, campanasActivas = 0, totalInscritos = 0, totalAsistencias = 0, totalCertificados = 0;
            
            PreparedStatement psMetricas = conn.prepareStatement(
                "SELECT " +
                "    COUNT(DISTINCT c.id_campana) AS total_campanas, " +
                "    COUNT(DISTINCT CASE WHEN c.estado = 'PUBLICADA' THEN c.id_campana END) AS campanas_activas, " +
                "    COUNT(DISTINCT i.id_inscripcion) AS total_inscritos, " +
                "    COUNT(DISTINCT a.id_asistencia) AS total_asistencias, " +
                "    COUNT(DISTINCT cert.id_certificado) AS total_certificados " +
                "FROM campanas c " +
                "LEFT JOIN inscripciones i ON c.id_campana = i.id_campana " +
                "LEFT JOIN asistencias a ON i.id_inscripcion = a.id_inscripcion " +
                "LEFT JOIN certificados cert ON c.id_campana = cert.id_campana " +
                "WHERE c.id_coordinador = ?"
            );
            psMetricas.setInt(1, idCoordinador);
            ResultSet rsMetricas = psMetricas.executeQuery();
            
            if (rsMetricas.next()) {
                totalCampanas = rsMetricas.getInt("total_campanas");
                campanasActivas = rsMetricas.getInt("campanas_activas");
                totalInscritos = rsMetricas.getInt("total_inscritos");
                totalAsistencias = rsMetricas.getInt("total_asistencias");
                totalCertificados = rsMetricas.getInt("total_certificados");
            }
            rsMetricas.close();
            psMetricas.close();
            
            // Tabla de métricas destacadas
            PdfPTable metricsTable = new PdfPTable(5);
            metricsTable.setWidthPercentage(100);
            metricsTable.setSpacingBefore(10);
            metricsTable.setSpacingAfter(20);
            
            String[] metricLabels = {"Total Campañas", "Campañas Activas", "Total Inscritos", "Total Asistencias", "Certificados Emitidos"};
            int[] metricValues = {totalCampanas, campanasActivas, totalInscritos, totalAsistencias, totalCertificados};
            
            for (int i = 0; i < metricLabels.length; i++) {
                PdfPCell cell = new PdfPCell();
                cell.setBackgroundColor(i % 2 == 0 ? azulUPT : verde);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                cell.setPadding(15);
                
                Paragraph metricLabel = new Paragraph(metricLabels[i], 
                    FontFactory.getFont(FontFactory.HELVETICA, 8, BaseColor.WHITE));
                metricLabel.setAlignment(Element.ALIGN_CENTER);
                cell.addElement(metricLabel);
                
                Paragraph metricValue = new Paragraph(String.valueOf(metricValues[i]), fontLarge);
                metricValue.getFont().setColor(BaseColor.WHITE);
                metricValue.setAlignment(Element.ALIGN_CENTER);
                cell.addElement(metricValue);
                
                metricsTable.addCell(cell);
            }
            
            document.add(metricsTable);
            
            // === DETALLE DE CAMPAÑAS ===
            Paragraph seccionCampanas = new Paragraph("DETALLE DE CAMPAÑAS", fontSeccion);
            seccionCampanas.setSpacingBefore(10);
            seccionCampanas.setSpacingAfter(10);
            document.add(seccionCampanas);
            
            PreparedStatement psCampanas = conn.prepareStatement(
                "SELECT " +
                "    c.titulo, " +
                "    c.fecha, " +
                "    c.hora_inicio, " +
                "    c.hora_fin, " +
                "    c.lugar, " +
                "    c.cupos_total, " +
                "    c.estado, " +
                "    COUNT(DISTINCT i.id_inscripcion) AS inscritos, " +
                "    COUNT(DISTINCT a.id_asistencia) AS asistieron " +
                "FROM campanas c " +
                "LEFT JOIN inscripciones i ON c.id_campana = i.id_campana " +
                "LEFT JOIN asistencias a ON i.id_inscripcion = a.id_inscripcion " +
                "WHERE c.id_coordinador = ? " +
                "GROUP BY c.id_campana " +
                "ORDER BY c.fecha DESC"
            );
            psCampanas.setInt(1, idCoordinador);
            ResultSet rsCampanas = psCampanas.executeQuery();
            
            PdfPTable tableCampanas = new PdfPTable(7);
            tableCampanas.setWidthPercentage(100);
            tableCampanas.setWidths(new float[]{2.5f, 1.3f, 1.2f, 1.5f, 1f, 1f, 0.8f});
            
            String[] headersCampanas = {"Campaña", "Fecha", "Horario", "Lugar", "Cupos", "Inscritos", "Asist."};
            for (String header : headersCampanas) {
                PdfPCell cell = new PdfPCell(new Phrase(header, fontHeader));
                cell.setBackgroundColor(azulUPT);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(6);
                tableCampanas.addCell(cell);
            }
            
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yy");
            SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
            
            while (rsCampanas.next()) {
                tableCampanas.addCell(createCell(rsCampanas.getString("titulo"), fontCell, Element.ALIGN_LEFT));
                tableCampanas.addCell(createCell(sdf.format(rsCampanas.getDate("fecha")), fontCell, Element.ALIGN_CENTER));
                
                String horario = sdfHora.format(rsCampanas.getTime("hora_inicio")) + "-" + 
                                sdfHora.format(rsCampanas.getTime("hora_fin"));
                tableCampanas.addCell(createCell(horario, fontCell, Element.ALIGN_CENTER));
                tableCampanas.addCell(createCell(rsCampanas.getString("lugar"), fontCell, Element.ALIGN_LEFT));
                tableCampanas.addCell(createCell(String.valueOf(rsCampanas.getInt("cupos_total")), fontCell, Element.ALIGN_CENTER));
                tableCampanas.addCell(createCell(String.valueOf(rsCampanas.getInt("inscritos")), fontCellBold, Element.ALIGN_CENTER));
                tableCampanas.addCell(createCell(String.valueOf(rsCampanas.getInt("asistieron")), fontCellBold, Element.ALIGN_CENTER));
            }
            
            document.add(tableCampanas);
            rsCampanas.close();
            psCampanas.close();
            
            // === ESTADÍSTICAS ADICIONALES ===
            document.add(new Paragraph(" "));
            Paragraph seccionStats = new Paragraph("INDICADORES DE DESEMPEÑO", fontSeccion);
            seccionStats.setSpacingBefore(15);
            seccionStats.setSpacingAfter(10);
            document.add(seccionStats);
            
            double tasaAsistencia = totalInscritos > 0 ? (totalAsistencias * 100.0 / totalInscritos) : 0;
            double tasaCertificacion = totalAsistencias > 0 ? (totalCertificados * 100.0 / totalAsistencias) : 0;
            
            PdfPTable statsTable = new PdfPTable(2);
            statsTable.setWidthPercentage(70);
            statsTable.setHorizontalAlignment(Element.ALIGN_CENTER);
            
            addStatRow(statsTable, "Tasa de Asistencia", String.format("%.1f%%", tasaAsistencia), fontCellBold, fontCell);
            addStatRow(statsTable, "Tasa de Certificación", String.format("%.1f%%", tasaCertificacion), fontCellBold, fontCell);
            addStatRow(statsTable, "Promedio de Inscritos por Campaña", 
                      totalCampanas > 0 ? String.format("%.1f", (double)totalInscritos / totalCampanas) : "0", 
                      fontCellBold, fontCell);
            addStatRow(statsTable, "Promedio de Asistentes por Campaña", 
                      totalCampanas > 0 ? String.format("%.1f", (double)totalAsistencias / totalCampanas) : "0", 
                      fontCellBold, fontCell);
            
            document.add(statsTable);
            
            // === FOOTER ===
            Paragraph footer = new Paragraph("Universidad Privada de Tacna - Sistema de Voluntariado Universitario", 
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
            if (conn != null) ConexionDB.cerrarConexion(conn);
        }
    }
    
    private PdfPCell createCell(String text, Font font, int alignment) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setHorizontalAlignment(alignment);
        cell.setPadding(5);
        return cell;
    }
    
    private void addStatRow(PdfPTable table, String label, String value, Font labelFont, Font valueFont) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, labelFont));
        labelCell.setHorizontalAlignment(Element.ALIGN_LEFT);
        labelCell.setPadding(8);
        labelCell.setBackgroundColor(new BaseColor(240, 240, 240));
        table.addCell(labelCell);
        
        PdfPCell valueCell = new PdfPCell(new Phrase(value, valueFont));
        valueCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        valueCell.setPadding(8);
        table.addCell(valueCell);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
