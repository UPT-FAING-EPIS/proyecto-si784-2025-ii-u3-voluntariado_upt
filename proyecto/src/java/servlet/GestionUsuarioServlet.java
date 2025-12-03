package servlet;

import entidad.Usuario;
import negocio.UsuarioNegocio;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "GestionUsuarioServlet", urlPatterns = {"/GestionUsuarioServlet"})
public class GestionUsuarioServlet extends HttpServlet {
    
    private UsuarioNegocio usuarioNegocio = new UsuarioNegocio();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        if ("cambiarEstado".equals(accion)) {
            cambiarEstadoUsuario(request, response);
        } else {
            response.sendRedirect("administrador/menu_admin.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        
        if ("crear".equals(accion)) {
            crearUsuario(request, response);
        } else if ("editar".equals(accion)) {
            editarUsuario(request, response);
        } else {
            response.sendRedirect("administrador/menu_admin.jsp");
        }
    }
    
    // Método para crear nuevo usuario
    private void crearUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Obtener parámetros del formulario
            String codigo = request.getParameter("codigo");
            String rol = request.getParameter("rol");
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String correo = request.getParameter("correo");
            String contrasena = request.getParameter("contrasena");
            String escuela = request.getParameter("escuela");
            String telefono = request.getParameter("telefono");
            
            // Validar campos requeridos
            if (codigo == null || codigo.trim().isEmpty() ||
                rol == null || rol.trim().isEmpty() ||
                nombres == null || nombres.trim().isEmpty() ||
                apellidos == null || apellidos.trim().isEmpty() ||
                correo == null || correo.trim().isEmpty() ||
                contrasena == null || contrasena.trim().isEmpty()) {
                
                session.setAttribute("error", "Todos los campos obligatorios deben ser completados");
                response.sendRedirect("administrador/menu_admin.jsp");
                return;
            }
            
            // Verificar si el correo ya existe
            if (usuarioNegocio.correoExiste(correo)) {
                session.setAttribute("error", "El correo electrónico ya está registrado");
                response.sendRedirect("administrador/menu_admin.jsp");
                return;
            }
            
            // Crear objeto Usuario
            Usuario usuario = new Usuario();
            usuario.setCodigo(codigo);
            usuario.setRol(rol);
            usuario.setNombres(nombres);
            usuario.setApellidos(apellidos);
            usuario.setCorreo(correo);
            usuario.setContrasena(contrasena);
            usuario.setEscuela(escuela != null ? escuela : "");
            usuario.setTelefono(telefono != null ? telefono : "");
            
            // Registrar usuario
            boolean registrado = usuarioNegocio.registrarUsuario(usuario);
            
            if (registrado) {
                session.setAttribute("mensaje", "Usuario creado exitosamente");
            } else {
                session.setAttribute("error", "Error al crear el usuario");
            }
            
        } catch (Exception e) {
            session.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect("administrador/menu_admin.jsp");
    }
    
    // Método para cambiar estado de usuario (activar/desactivar)
    private void cambiarEstadoUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            int estadoParam = Integer.parseInt(request.getParameter("estado"));
            boolean estado = (estadoParam == 1);
            
            boolean actualizado = usuarioNegocio.cambiarEstadoUsuario(idUsuario, estado);
            
            if (actualizado) {
                String mensaje = estado ? "Usuario activado exitosamente" : "Usuario desactivado exitosamente";
                session.setAttribute("mensaje", mensaje);
            } else {
                session.setAttribute("error", "Error al cambiar el estado del usuario");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Parámetros inválidos");
        } catch (Exception e) {
            session.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect("administrador/menu_admin.jsp");
    }
    
    // Método para editar usuario
    private void editarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Obtener parámetros del formulario
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String codigo = request.getParameter("codigo");
            String rol = request.getParameter("rol");
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String correo = request.getParameter("correo");
            String escuela = request.getParameter("escuela");
            String telefono = request.getParameter("telefono");
            
            // Validar campos requeridos
            if (codigo == null || codigo.trim().isEmpty() ||
                rol == null || rol.trim().isEmpty() ||
                nombres == null || nombres.trim().isEmpty() ||
                apellidos == null || apellidos.trim().isEmpty() ||
                correo == null || correo.trim().isEmpty()) {
                
                session.setAttribute("error", "Todos los campos obligatorios deben ser completados");
                response.sendRedirect("administrador/menu_admin.jsp");
                return;
            }
            
            // Crear objeto Usuario
            Usuario usuario = new Usuario();
            usuario.setIdUsuario(idUsuario);
            usuario.setCodigo(codigo);
            usuario.setRol(rol);
            usuario.setNombres(nombres);
            usuario.setApellidos(apellidos);
            usuario.setCorreo(correo);
            usuario.setEscuela(escuela != null ? escuela : "");
            usuario.setTelefono(telefono != null ? telefono : "");
            
            // Actualizar usuario
            boolean actualizado = usuarioNegocio.actualizarUsuario(usuario);
            
            if (actualizado) {
                session.setAttribute("mensaje", "Usuario actualizado exitosamente");
            } else {
                session.setAttribute("error", "Error al actualizar el usuario");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID de usuario inválido");
        } catch (Exception e) {
            session.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect("administrador/menu_admin.jsp");
    }
}
