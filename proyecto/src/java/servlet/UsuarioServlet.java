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
import negocio.UsuarioNegocio;

/**
 * Servlet para gestionar operaciones de usuario
 * @author Mi Equipo
 */
@WebServlet(name = "UsuarioServlet", urlPatterns = {"/UsuarioServlet"})
public class UsuarioServlet extends HttpServlet {

    private UsuarioNegocio usuarioNegocio;

    @Override
    public void init() throws ServletException {
        super.init();
        usuarioNegocio = new UsuarioNegocio();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "";
        }
        
        switch (action) {
            case "actualizarPerfil":
                actualizarPerfil(request, response);
                break;
            default:
                enviarError(response, "Acción no válida");
                break;
        }
    }

    /**
     * Actualiza el perfil del usuario (nombres, apellidos y contraseña)
     */
    private void actualizarPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        PrintWriter out = response.getWriter();
        
        try {
            // Obtener usuario de la sesión
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("usuario") == null) {
                out.print("{\"success\":false,\"message\":\"Sesión expirada. Por favor, inicia sesión nuevamente.\"}");
                return;
            }
            
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            
            // Obtener parámetros
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String passwordActual = request.getParameter("passwordActual");
            String passwordNueva = request.getParameter("passwordNueva");
            
            // Validar datos básicos
            if (nombres == null || nombres.trim().isEmpty() ||
                apellidos == null || apellidos.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Los nombres y apellidos son obligatorios.\"}");
                return;
            }
            
            // Actualizar nombres y apellidos
            usuario.setNombres(nombres.trim());
            usuario.setApellidos(apellidos.trim());
            
            boolean cambioPassword = false;
            
            // Si está intentando cambiar la contraseña
            if (passwordActual != null && !passwordActual.trim().isEmpty()) {
                // Verificar contraseña actual
                if (!usuarioNegocio.verificarPassword(usuario.getIdUsuario(), passwordActual)) {
                    out.print("{\"success\":false,\"message\":\"La contraseña actual es incorrecta.\"}");
                    return;
                }
                
                // Validar nueva contraseña
                if (passwordNueva == null || passwordNueva.trim().isEmpty()) {
                    out.print("{\"success\":false,\"message\":\"Debes ingresar la nueva contraseña.\"}");
                    return;
                }
                
                if (passwordNueva.length() < 6) {
                    out.print("{\"success\":false,\"message\":\"La nueva contraseña debe tener al menos 6 caracteres.\"}");
                    return;
                }
                
                // Actualizar contraseña
                usuario.setPassword(passwordNueva.trim());
                cambioPassword = true;
            }
            
            // Guardar cambios en la base de datos
            boolean actualizado = usuarioNegocio.actualizarPerfil(usuario, cambioPassword);
            
            if (actualizado) {
                // Actualizar usuario en sesión
                session.setAttribute("usuario", usuario);
                
                if (cambioPassword) {
                    out.print("{\"success\":true,\"message\":\"Perfil y contraseña actualizados exitosamente.\"}");
                } else {
                    out.print("{\"success\":true,\"message\":\"Perfil actualizado exitosamente.\"}");
                }
            } else {
                out.print("{\"success\":false,\"message\":\"Error al actualizar el perfil. Intenta nuevamente.\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Error del servidor: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }

    /**
     * Envía un mensaje de error en formato JSON
     */
    private void enviarError(HttpServletResponse response, String mensaje) throws IOException {
        PrintWriter out = response.getWriter();
        out.print("{\"success\":false,\"message\":\"" + mensaje + "\"}");
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestión de usuarios";
    }
}
