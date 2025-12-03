package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import entidad.Usuario;
import negocio.estudiantenegocio;

@WebServlet(name = "InscripcionServlet", urlPatterns = {"/InscripcionServlet"})
public class InscripcionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Verificar sesión
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("usuario") == null) {
                out.print("{\"success\": false, \"message\": \"Sesión no válida\"}");
                return;
            }
            
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            String rol = (String) session.getAttribute("rol");
            
            if (!"ESTUDIANTE".equals(rol)) {
                out.print("{\"success\": false, \"message\": \"Acceso no autorizado\"}");
                return;
            }
            
            // Obtener parámetros
            String idCampanaStr = request.getParameter("idCampana");
            
            if (idCampanaStr == null || idCampanaStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"ID de campaña no válido\"}");
                return;
            }
            
            int idCampana = Integer.parseInt(idCampanaStr);
            int idUsuario = usuario.getIdUsuario();
            
            // Realizar inscripción
            estudiantenegocio negocio = new estudiantenegocio();
            boolean resultado = negocio.inscribirseEnCampana(idUsuario, idCampana);
            
            if (resultado) {
                out.print("{\"success\": true, \"message\": \"Inscripción realizada exitosamente\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"No se pudo realizar la inscripción. Verifica que haya cupos disponibles y que no estés ya inscrito.\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"ID de campaña no válido\"}");
        } catch (Exception e) {
            System.err.println("Error en InscripcionServlet: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error interno del servidor\"}");
        } finally {
            out.close();
        }
    }

}