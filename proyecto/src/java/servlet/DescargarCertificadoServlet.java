package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import conexion.ConexionDB;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import java.text.SimpleDateFormat;
import java.net.URL;

/**
 * Servlet para descargar certificados en formato PDF
 */
public class DescargarCertificadoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String codigoVerificacion = request.getParameter("codigo");
        
        if (codigoVerificacion == null || codigoVerificacion.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Código de verificación no proporcionado");
            return;
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = ConexionDB.getConnection();
            
            // Consultar datos del certificado
            String sql = "SELECT " +
                        "    cert.id_certificado, " +
                        "    cert.codigo_verificacion, " +
                        "    cert.fecha_emision, " +
                        "    cert.horas_acreditadas, " +
                        "    u.nombres, " +
                        "    u.apellidos, " +
                        "    c.titulo AS campana_titulo, " +
                        "    c.descripcion AS campana_descripcion, " +
                        "    c.fecha AS campana_fecha, " +
                        "    c.lugar AS campana_lugar " +
                        "FROM certificados cert " +
                        "INNER JOIN usuarios u ON cert.id_estudiante = u.id_usuario " +
                        "INNER JOIN campanas c ON cert.id_campana = c.id_campana " +
                        "WHERE cert.codigo_verificacion = ? AND cert.activo = 1";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, codigoVerificacion);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Datos del certificado
                String nombreCompleto = rs.getString("nombres") + " " + rs.getString("apellidos");
                String campanaTitulo = rs.getString("campana_titulo");
                String campanaDescripcion = rs.getString("campana_descripcion");
                Date campanaFecha = rs.getDate("campana_fecha");
                String campanaLugar = rs.getString("campana_lugar");
                Timestamp fechaEmision = rs.getTimestamp("fecha_emision");
                int horasAcreditadas = rs.getInt("horas_acreditadas");
                
                // Formatear fechas
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                SimpleDateFormat sdfCompleto = new SimpleDateFormat("dd 'de' MMMM 'de' yyyy", new java.util.Locale("es", "ES"));
                
                // Configurar respuesta HTTP para descarga de PDF
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=\"Certificado_" + codigoVerificacion + ".pdf\"");
                
                // Crear documento PDF con márgenes más pequeños
                Document document = new Document(PageSize.A4.rotate(), 30, 30, 30, 30); // Horizontal con márgenes pequeños
                PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
                
                document.open();
                
                // Colores personalizados
                BaseColor azulUPT = new BaseColor(0, 61, 122);
                BaseColor azulClaro = new BaseColor(0, 102, 204);
                BaseColor dorado = new BaseColor(255, 215, 0);
                
                // Cargar imágenes - Corregir rutas
                String contextPath = getServletContext().getRealPath("/");
                Image logoUPT = null;
                Image firmaCoordinador = null;
                Image firmaDirector = null;
                
                String imgPath = contextPath + "img" + File.separator;
                System.out.println("========================================");
                System.out.println("Ruta base de imágenes: " + imgPath);
                
                // Logo UPT
                try {
                    String logoPath = imgPath + "upt.jpeg";
                    System.out.println("Intentando cargar logo: " + logoPath);
                    File logoFile = new File(logoPath);
                    System.out.println("Logo existe: " + logoFile.exists());
                    
                    logoUPT = Image.getInstance(logoPath);
                    logoUPT.scaleToFit(60, 60);
                    System.out.println("Logo cargado exitosamente");
                } catch (Exception e) {
                    System.err.println("Error cargando logo: " + e.getMessage());
                }
                
                // Firma Coordinador
                try {
                    String coordPath = imgPath + "coordinador.jpg";
                    System.out.println("Intentando cargar firma coordinador: " + coordPath);
                    File coordFile = new File(coordPath);
                    System.out.println("Firma coordinador existe: " + coordFile.exists());
                    
                    firmaCoordinador = Image.getInstance(coordPath);
                    firmaCoordinador.scaleToFit(100, 50);
                    System.out.println("Firma coordinador cargada exitosamente");
                } catch (Exception e) {
                    System.err.println("Error cargando firma coordinador: " + e.getMessage());
                    e.printStackTrace();
                }
                
                // Firma Director
                try {
                    String dirPath = imgPath + "director.jpeg";
                    System.out.println("Intentando cargar firma director: " + dirPath);
                    File dirFile = new File(dirPath);
                    System.out.println("Firma director existe: " + dirFile.exists());
                    
                    firmaDirector = Image.getInstance(dirPath);
                    firmaDirector.scaleToFit(100, 50);
                    System.out.println("Firma director cargada exitosamente");
                } catch (Exception e) {
                    System.err.println("Error cargando firma director: " + e.getMessage());
                    e.printStackTrace();
                }
                
                System.out.println("========================================");
                
                // Fuentes - Tamaños reducidos para que quepa en una página
                Font fontTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 30, azulUPT);
                Font fontSubtitulo = FontFactory.getFont(FontFactory.HELVETICA, 11, BaseColor.GRAY);
                Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, BaseColor.WHITE);
                Font fontHeaderSub = FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.WHITE);
                Font fontNombre = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 24, azulUPT);
                Font fontTexto = FontFactory.getFont(FontFactory.HELVETICA, 11, BaseColor.BLACK);
                Font fontTextoNegrita = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, azulUPT);
                Font fontPequeno = FontFactory.getFont(FontFactory.HELVETICA, 8, BaseColor.GRAY);
                
                // === HEADER CON FONDO AZUL ===
                PdfPTable headerTable = new PdfPTable(2);
                headerTable.setWidthPercentage(100);
                headerTable.setWidths(new float[]{1, 4});
                
                // Logo
                PdfPCell logoCell = new PdfPCell();
                if (logoUPT != null) {
                    logoCell.addElement(logoUPT);
                }
                logoCell.setBackgroundColor(azulUPT);
                logoCell.setBorder(Rectangle.NO_BORDER);
                logoCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                logoCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                logoCell.setPadding(20);
                headerTable.addCell(logoCell);
                
                // Texto del header
                PdfPCell headerTextCell = new PdfPCell();
                headerTextCell.setBackgroundColor(azulUPT);
                headerTextCell.setBorder(Rectangle.NO_BORDER);
                headerTextCell.setPadding(20);
                
                Paragraph headerTitle = new Paragraph("UNIVERSIDAD PRIVADA DE TACNA", fontHeader);
                headerTitle.setAlignment(Element.ALIGN_CENTER);
                headerTextCell.addElement(headerTitle);
                
                Paragraph headerSubtitle = new Paragraph("Sistema de Voluntariado Universitario", fontHeaderSub);
                headerSubtitle.setAlignment(Element.ALIGN_CENTER);
                headerSubtitle.setSpacingBefore(5);
                headerTextCell.addElement(headerSubtitle);
                
                headerTable.addCell(headerTextCell);
                document.add(headerTable);
                
                // Espacio reducido
                document.add(new Paragraph(" ", new Font(Font.FontFamily.HELVETICA, 6)));
                
                // === TÍTULO CERTIFICADO ===
                Paragraph titulo = new Paragraph("CERTIFICADO", fontTitulo);
                titulo.setAlignment(Element.ALIGN_CENTER);
                titulo.setSpacingAfter(5);
                document.add(titulo);
                
                Paragraph subtitulo = new Paragraph("de Reconocimiento por Participación en Actividad de Voluntariado", fontSubtitulo);
                subtitulo.setAlignment(Element.ALIGN_CENTER);
                subtitulo.setSpacingAfter(15);
                document.add(subtitulo);
                
                // === TEXTO PRINCIPAL ===
                Paragraph intro = new Paragraph("La Universidad Privada de Tacna otorga el presente certificado a:", fontTexto);
                intro.setAlignment(Element.ALIGN_CENTER);
                intro.setSpacingAfter(10);
                document.add(intro);
                
                // Nombre del estudiante
                Paragraph nombre = new Paragraph(nombreCompleto.toUpperCase(), fontNombre);
                nombre.setAlignment(Element.ALIGN_CENTER);
                nombre.setSpacingAfter(3);
                document.add(nombre);
                
                // Línea bajo el nombre
                LineSeparator line = new LineSeparator();
                line.setLineColor(azulUPT);
                line.setLineWidth(2);
                PdfPTable lineTable = new PdfPTable(1);
                lineTable.setWidthPercentage(50);
                lineTable.setHorizontalAlignment(Element.ALIGN_CENTER);
                PdfPCell lineCell = new PdfPCell();
                lineCell.setBorder(Rectangle.NO_BORDER);
                lineCell.setBorderWidthBottom(2);
                lineCell.setBorderColorBottom(azulUPT);
                lineCell.setPadding(5);
                lineTable.addCell(lineCell);
                document.add(lineTable);
                
                // Espacio pequeño
                document.add(new Paragraph(" ", new Font(Font.FontFamily.HELVETICA, 4)));
                
                // Descripción con menos espaciado
                Paragraph descripcion = new Paragraph();
                descripcion.setAlignment(Element.ALIGN_CENTER);
                descripcion.setLeading(14);
                descripcion.add(new Chunk("Por su destacada participación en la campaña de voluntariado ", fontTexto));
                descripcion.add(new Chunk("\"" + campanaTitulo + "\"", fontTextoNegrita));
                descripcion.add(new Chunk(", realizada el ", fontTexto));
                descripcion.add(new Chunk(sdf.format(campanaFecha), fontTextoNegrita));
                descripcion.add(new Chunk(", acreditando un total de ", fontTexto));
                descripcion.add(new Chunk(horasAcreditadas + " horas", fontTextoNegrita));
                descripcion.add(new Chunk(" de servicio comunitario.", fontTexto));
                descripcion.setSpacingAfter(8);
                document.add(descripcion);
                
                Paragraph reconocimiento = new Paragraph("Reconocemos su compromiso con la responsabilidad social y el servicio a la comunidad.", fontTexto);
                reconocimiento.setAlignment(Element.ALIGN_CENTER);
                reconocimiento.setSpacingAfter(15);
                document.add(reconocimiento);
                
                // === FIRMAS ===
                PdfPTable firmasTable = new PdfPTable(2);
                firmasTable.setWidthPercentage(80);
                firmasTable.setHorizontalAlignment(Element.ALIGN_CENTER);
                firmasTable.setSpacingBefore(15);
                
                // Firma Coordinador
                PdfPCell firmaCoordCell = new PdfPCell();
                firmaCoordCell.setBorder(Rectangle.NO_BORDER);
                firmaCoordCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                firmaCoordCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                firmaCoordCell.setPaddingBottom(5);
                
                if (firmaCoordinador != null) {
                    try {
                        firmaCoordinador.setAlignment(Element.ALIGN_CENTER);
                        Chunk firmaChunk = new Chunk(firmaCoordinador, 0, 0, true);
                        Paragraph firmaPara = new Paragraph();
                        firmaPara.add(firmaChunk);
                        firmaPara.setAlignment(Element.ALIGN_CENTER);
                        firmaCoordCell.addElement(firmaPara);
                        System.out.println("Firma coordinador agregada al PDF");
                    } catch (Exception e) {
                        System.err.println("Error agregando firma coordinador al PDF: " + e.getMessage());
                    }
                } else {
                    System.out.println("ADVERTENCIA: firmaCoordinador es null");
                    // Agregar espacio en blanco si no hay imagen
                    Paragraph espacio = new Paragraph(" ", new Font(Font.FontFamily.HELVETICA, 30));
                    espacio.setAlignment(Element.ALIGN_CENTER);
                    firmaCoordCell.addElement(espacio);
                }
                
                Paragraph lineaCoord = new Paragraph("_________________________");
                lineaCoord.setAlignment(Element.ALIGN_CENTER);
                firmaCoordCell.addElement(lineaCoord);
                
                Paragraph tituloCoord = new Paragraph("Coordinador de Voluntariado", fontTextoNegrita);
                tituloCoord.setAlignment(Element.ALIGN_CENTER);
                firmaCoordCell.addElement(tituloCoord);
                
                Paragraph institCoord = new Paragraph("Universidad Privada de Tacna", fontPequeno);
                institCoord.setAlignment(Element.ALIGN_CENTER);
                firmaCoordCell.addElement(institCoord);
                
                firmasTable.addCell(firmaCoordCell);
                
                // Firma Director
                PdfPCell firmaDirCell = new PdfPCell();
                firmaDirCell.setBorder(Rectangle.NO_BORDER);
                firmaDirCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                firmaDirCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                firmaDirCell.setPaddingBottom(5);
                
                if (firmaDirector != null) {
                    try {
                        firmaDirector.setAlignment(Element.ALIGN_CENTER);
                        Chunk firmaChunk = new Chunk(firmaDirector, 0, 0, true);
                        Paragraph firmaPara = new Paragraph();
                        firmaPara.add(firmaChunk);
                        firmaPara.setAlignment(Element.ALIGN_CENTER);
                        firmaDirCell.addElement(firmaPara);
                        System.out.println("Firma director agregada al PDF");
                    } catch (Exception e) {
                        System.err.println("Error agregando firma director al PDF: " + e.getMessage());
                    }
                } else {
                    System.out.println("ADVERTENCIA: firmaDirector es null");
                    // Agregar espacio en blanco si no hay imagen
                    Paragraph espacio = new Paragraph(" ", new Font(Font.FontFamily.HELVETICA, 30));
                    espacio.setAlignment(Element.ALIGN_CENTER);
                    firmaDirCell.addElement(espacio);
                }
                
                Paragraph lineaDir = new Paragraph("_________________________");
                lineaDir.setAlignment(Element.ALIGN_CENTER);
                firmaDirCell.addElement(lineaDir);
                
                Paragraph tituloDir = new Paragraph("Director de Responsabilidad Social", fontTextoNegrita);
                tituloDir.setAlignment(Element.ALIGN_CENTER);
                firmaDirCell.addElement(tituloDir);
                
                Paragraph institDir = new Paragraph("Universidad Privada de Tacna", fontPequeno);
                institDir.setAlignment(Element.ALIGN_CENTER);
                firmaDirCell.addElement(institDir);
                
                firmasTable.addCell(firmaDirCell);
                
                document.add(firmasTable);
                
                // === FOOTER - Más compacto ===
                PdfPTable footerTable = new PdfPTable(2);
                footerTable.setWidthPercentage(100);
                footerTable.setSpacingBefore(10);
                
                PdfPCell fechaCell = new PdfPCell();
                fechaCell.setBorder(Rectangle.NO_BORDER);
                Paragraph fechaTexto = new Paragraph("Fecha de emisión: " + sdfCompleto.format(fechaEmision), fontPequeno);
                fechaCell.addElement(fechaTexto);
                footerTable.addCell(fechaCell);
                
                PdfPCell codigoCell = new PdfPCell();
                codigoCell.setBorder(Rectangle.NO_BORDER);
                codigoCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                Paragraph codigoTexto = new Paragraph("Código de verificación: " + codigoVerificacion, fontPequeno);
                codigoTexto.setAlignment(Element.ALIGN_RIGHT);
                codigoCell.addElement(codigoTexto);
                footerTable.addCell(codigoCell);
                
                document.add(footerTable);
                
                // Frase final más pequeña
                Paragraph frase = new Paragraph("\"El voluntariado es la expresión del compromiso del ciudadano con su comunidad\"", 
                                               FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 8, BaseColor.GRAY));
                frase.setAlignment(Element.ALIGN_CENTER);
                frase.setSpacingBefore(8);
                document.add(frase);
                
                document.close();
                
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Certificado no encontrado");
            }
            
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
