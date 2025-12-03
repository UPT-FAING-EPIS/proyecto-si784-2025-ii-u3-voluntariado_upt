package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.ByteArrayOutputStream;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.text.SimpleDateFormat;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import entidad.Usuario;
import negocio.estudiantenegocio;

// Importaciones ZXing
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

@WebServlet(name = "QRCodeServlet", urlPatterns = {"/QRCodeServlet"})
public class QRCodeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar encoding UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            System.out.println("=== QRCodeServlet - Inicio ===");
            
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
            
            if (!"ESTUDIANTE".equals(rol)) {
                System.out.println("Error: Acceso no autorizado para rol: " + rol);
                out.print("{\"success\": false, \"message\": \"Acceso no autorizado\"}");
                return;
            }
            
            String action = request.getParameter("action");
            System.out.println("Action: " + action);
            
            if ("generate".equals(action)) {
                generateQRCode(request, response, out, usuario);
            } else {
                System.out.println("Error: Acción no válida: " + action);
                out.print("{\"success\": false, \"message\": \"Acción no válida\"}");
            }
            
        } catch (Exception e) {
            System.err.println("Error general en QRCodeServlet: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error interno del servidor: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
    
    private void generateQRCode(HttpServletRequest request, HttpServletResponse response, 
                               PrintWriter out, Usuario usuario) throws IOException {
        
        try {
            System.out.println("=== Generando QR Code ===");
            
            // Debug completo de la request
            System.out.println("Content-Type: " + request.getContentType());
            System.out.println("Method: " + request.getMethod());
            System.out.println("Query String: " + request.getQueryString());
            
            // Mostrar todos los parámetros
            System.out.println("=== TODOS LOS PARÁMETROS ===");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            boolean hasParams = false;
            while (paramNames.hasMoreElements()) {
                hasParams = true;
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println("Parámetro: '" + paramName + "' = '" + paramValue + "'");
            }
            if (!hasParams) {
                System.out.println("NO SE RECIBIERON PARÁMETROS");
            }
            System.out.println("=== FIN PARÁMETROS ===");
            
            // Obtener parámetros específicos
            String idCampanaStr = request.getParameter("idCampana");
            String idUsuarioStr = request.getParameter("idUsuario");
            
            System.out.println("Parámetros específicos - idCampana: '" + idCampanaStr + "', idUsuario: '" + idUsuarioStr + "'");
            
            if (idCampanaStr == null || idUsuarioStr == null || 
                idCampanaStr.trim().isEmpty() || idUsuarioStr.trim().isEmpty()) {
                System.out.println("Error: Parámetros faltantes o vacíos");
                out.print("{\"success\": false, \"message\": \"Parámetros faltantes\"}");
                return;
            }
            
            int idCampana, idUsuario;
            try {
                idCampana = Integer.parseInt(idCampanaStr.trim());
                idUsuario = Integer.parseInt(idUsuarioStr.trim());
                System.out.println("Parámetros parseados - idCampana: " + idCampana + ", idUsuario: " + idUsuario);
            } catch (NumberFormatException e) {
                System.err.println("Error parseando parámetros: " + e.getMessage());
                System.err.println("idCampanaStr: '" + idCampanaStr + "', idUsuarioStr: '" + idUsuarioStr + "'");
                out.print("{\"success\": false, \"message\": \"Parámetros no válidos: " + e.getMessage() + "\"}");
                return;
            }
            
            // Verificar que el usuario está inscrito en la campaña
            estudiantenegocio negocio = new estudiantenegocio();
            boolean estaInscrito = negocio.estaInscrito(idUsuario, idCampana);
            System.out.println("¿Está inscrito? " + estaInscrito);
            
            if (!estaInscrito) {
                System.out.println("Error: Usuario no inscrito en la campaña");
                out.print("{\"success\": false, \"message\": \"No estás inscrito en esta campaña\"}");
                return;
            }
            
            // Generar datos del QR
            long timestamp = System.currentTimeMillis();
            String qrData = String.format("ASISTENCIA|%d|%d|%d", idUsuario, idCampana, timestamp);
            System.out.println("Datos del QR: " + qrData);
            
            // Generar QR code usando ZXing
            String base64Image;
            try {
                base64Image = generateZXingQRCode(qrData);
                System.out.println("QR generado exitosamente con ZXing");
            } catch (Exception e) {
                System.err.println("Error con ZXing: " + e.getMessage());
                e.printStackTrace();
                out.print("{\"success\": false, \"message\": \"Error al generar código QR con ZXing: " + e.getMessage() + "\"}");
                return;
            }
            
            // Calcular validez (24 horas)
            Date validezDate = new Date(timestamp + (24 * 60 * 60 * 1000));
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            
            // Crear ID de inscripción único
            String inscripcionId = String.format("INS-%d-%d-%d", idUsuario, idCampana, timestamp % 10000);
            
            // Respuesta JSON
            String jsonResponse = String.format(
                "{\"success\": true, \"qrCode\": \"%s\", \"inscripcionId\": \"%s\", \"validez\": \"%s\", \"qrData\": \"%s\"}",
                base64Image, inscripcionId, sdf.format(validezDate), qrData
            );
            
            System.out.println("Respuesta JSON preparada, longitud: " + jsonResponse.length());
            out.print(jsonResponse);
            
        } catch (NumberFormatException e) {
            System.err.println("Error de formato de número: " + e.getMessage());
            out.print("{\"success\": false, \"message\": \"Parámetros no válidos\"}");
        } catch (Exception e) {
            System.err.println("Error generando QR: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error generando código QR: " + e.getMessage() + "\"}");
        }
    }
    
    /**
     * Genera un código QR usando ZXing con método manual de creación de imagen
     * Más compatible que usar MatrixToImageWriter.writeToStream()
     */
    private String generateZXingQRCode(String data) throws WriterException, IOException {
        System.out.println("Iniciando generación con ZXing...");
        
        try {
            // Configuración del QR con hints para mejor compatibilidad
            Map<EncodeHintType, Object> hints = new HashMap<EncodeHintType, Object>();
            hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            hints.put(EncodeHintType.MARGIN, 1); // Margen mínimo
            
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            System.out.println("QRCodeWriter creado");
            
            // Generar matriz del QR
            BitMatrix bitMatrix = qrCodeWriter.encode(data, BarcodeFormat.QR_CODE, 250, 250, hints);
            System.out.println("BitMatrix generado: " + bitMatrix.getWidth() + "x" + bitMatrix.getHeight());
            
            // Crear imagen manualmente (método más compatible)
            BufferedImage image = createQRImage(bitMatrix);
            System.out.println("BufferedImage creado");
            
            // Convertir imagen a bytes
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "PNG", baos);
            System.out.println("Imagen escrita al stream");
            
            byte[] imageBytes = baos.toByteArray();
            System.out.println("Bytes de imagen obtenidos: " + imageBytes.length);
            
            // Convertir a Base64
            String base64 = Base64.getEncoder().encodeToString(imageBytes);
            System.out.println("Base64 generado, longitud: " + base64.length());
            
            return base64;
            
        } catch (WriterException e) {
            System.err.println("WriterException en ZXing: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } catch (IOException e) {
            System.err.println("IOException en ZXing: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } catch (Exception e) {
            System.err.println("Exception general en ZXing: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error inesperado generando QR: " + e.getMessage(), e);
        }
    }
    
    /**
     * Crea una imagen BufferedImage a partir de una BitMatrix
     * Método manual que no depende de MatrixToImageWriter
     */
    private BufferedImage createQRImage(BitMatrix matrix) {
        int width = matrix.getWidth();
        int height = matrix.getHeight();
        
        // Crear imagen RGB
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = image.createGraphics();
        
        // Fondo blanco
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0, 0, width, height);
        
        // Dibujar píxeles negros del QR
        graphics.setColor(Color.BLACK);
        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                if (matrix.get(x, y)) {
                    graphics.fillRect(x, y, 1, 1);
                }
            }
        }
        
        graphics.dispose();
        return image;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported");
    }
}