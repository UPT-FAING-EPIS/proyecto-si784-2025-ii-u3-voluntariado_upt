package negocio;

import conexion.ConexionDB;
import entidad.Usuario;
import java.sql.*;

public class UsuarioNegocio {
    
    // Método para validar login
    public Usuario validarLogin(String correo, String contrasena) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Usuario usuario = null;
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql = "SELECT * FROM usuarios WHERE correo = ? AND contrasena = ? AND activo = 1";
            ps = conn.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, contrasena);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setCodigo(rs.getString("codigo"));
                usuario.setNombres(rs.getString("nombres"));
                usuario.setApellidos(rs.getString("apellidos"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEscuela(rs.getString("escuela"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setActivo(rs.getBoolean("activo"));
                usuario.setFechaRegistro(rs.getTimestamp("fecha_registro"));
            }
            
        } catch (SQLException e) {
            System.out.println("Error al validar login: " + e.getMessage());
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
        
        return usuario;
    }
    
    // Método para registrar nuevo usuario
    public boolean registrarUsuario(Usuario usuario) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql = "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol, escuela, telefono) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, usuario.getCodigo());
            ps.setString(2, usuario.getNombres());
            ps.setString(3, usuario.getApellidos());
            ps.setString(4, usuario.getCorreo());
            ps.setString(5, usuario.getContrasena());
            ps.setString(6, usuario.getRol());
            ps.setString(7, usuario.getEscuela());
            ps.setString(8, usuario.getTelefono());
            
            int filasAfectadas = ps.executeUpdate();
            resultado = (filasAfectadas > 0);
            
        } catch (SQLException e) {
            System.out.println("Error al registrar usuario: " + e.getMessage());
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
    
    // Método para verificar si el correo ya existe
    public boolean correoExiste(String correo) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean existe = false;
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql = "SELECT COUNT(*) FROM usuarios WHERE correo = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, correo);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                existe = (rs.getInt(1) > 0);
            }
            
        } catch (SQLException e) {
            System.out.println("Error al verificar correo: " + e.getMessage());
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
        
        return existe;
    }
    
    // Método para obtener usuario por ID
    public Usuario obtenerUsuarioPorId(int idUsuario) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Usuario usuario = null;
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql = "SELECT * FROM usuarios WHERE id_usuario = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setCodigo(rs.getString("codigo"));
                usuario.setNombres(rs.getString("nombres"));
                usuario.setApellidos(rs.getString("apellidos"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEscuela(rs.getString("escuela"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setActivo(rs.getBoolean("activo"));
                usuario.setFechaRegistro(rs.getTimestamp("fecha_registro"));
            }
            
        } catch (SQLException e) {
            System.out.println("Error al obtener usuario: " + e.getMessage());
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
        
        return usuario;
    }
    
    // Método para listar todos los usuarios
    public java.util.List<Usuario> listarTodosUsuarios() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        java.util.List<Usuario> usuarios = new java.util.ArrayList<>();
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql = "SELECT * FROM usuarios ORDER BY fecha_registro DESC";
            ps = conn.prepareStatement(sql);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setCodigo(rs.getString("codigo"));
                usuario.setNombres(rs.getString("nombres"));
                usuario.setApellidos(rs.getString("apellidos"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEscuela(rs.getString("escuela"));
                usuario.setTelefono(rs.getString("telefono"));
                usuario.setActivo(rs.getBoolean("activo"));
                usuario.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                usuarios.add(usuario);
            }
            
        } catch (SQLException e) {
            System.out.println("Error al listar usuarios: " + e.getMessage());
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
        
        return usuarios;
    }
    
    // Método para contar usuarios por rol
    public int contarUsuariosPorRol(String rol) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int total = 0;
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql = "SELECT COUNT(*) FROM usuarios WHERE rol = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, rol);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.out.println("Error al contar usuarios por rol: " + e.getMessage());
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
    
    // Método para contar usuarios activos
    public int contarUsuariosActivos() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int total = 0;
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql = "SELECT COUNT(*) FROM usuarios WHERE activo = 1";
            ps = conn.prepareStatement(sql);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                total = rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.out.println("Error al contar usuarios activos: " + e.getMessage());
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
    
    // Método para cambiar estado de usuario (activar/desactivar)
    public boolean cambiarEstadoUsuario(int idUsuario, boolean estado) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql = "UPDATE usuarios SET activo = ? WHERE id_usuario = ?";
            ps = conn.prepareStatement(sql);
            ps.setBoolean(1, estado);
            ps.setInt(2, idUsuario);
            
            int filasAfectadas = ps.executeUpdate();
            resultado = (filasAfectadas > 0);
            
        } catch (SQLException e) {
            System.out.println("Error al cambiar estado de usuario: " + e.getMessage());
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
    
    // Método para actualizar usuario
    public boolean actualizarUsuario(Usuario usuario) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql = "UPDATE usuarios SET codigo = ?, nombres = ?, apellidos = ?, " +
                        "correo = ?, rol = ?, escuela = ?, telefono = ? WHERE id_usuario = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, usuario.getCodigo());
            ps.setString(2, usuario.getNombres());
            ps.setString(3, usuario.getApellidos());
            ps.setString(4, usuario.getCorreo());
            ps.setString(5, usuario.getRol());
            ps.setString(6, usuario.getEscuela());
            ps.setString(7, usuario.getTelefono());
            ps.setInt(8, usuario.getIdUsuario());
            
            int filasAfectadas = ps.executeUpdate();
            resultado = (filasAfectadas > 0);
            
        } catch (SQLException e) {
            System.out.println("Error al actualizar usuario: " + e.getMessage());
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
     * Verifica si la contraseña proporcionada coincide con la del usuario
     * @param idUsuario ID del usuario
     * @param password Contraseña a verificar
     * @return true si la contraseña es correcta, false en caso contrario
     */
    public boolean verificarPassword(int idUsuario, String password) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean esCorrecta = false;
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql = "SELECT contrasena FROM usuarios WHERE id_usuario = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                String passwordDB = rs.getString("contrasena");
                esCorrecta = password.equals(passwordDB);
            }
            
        } catch (SQLException e) {
            System.out.println("Error al verificar password: " + e.getMessage());
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
        
        return esCorrecta;
    }
    
    /**
     * Actualiza el perfil del usuario (nombres, apellidos y opcionalmente contraseña)
     * @param usuario Usuario con los datos actualizados
     * @param cambiarPassword true si se debe actualizar la contraseña
     * @return true si la actualización fue exitosa, false en caso contrario
     */
    public boolean actualizarPerfil(Usuario usuario, boolean cambiarPassword) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean resultado = false;
        
        try {
            conn = ConexionDB.getConnection();
            
            String sql;
            if (cambiarPassword) {
                sql = "UPDATE usuarios SET nombres = ?, apellidos = ?, contrasena = ? WHERE id_usuario = ?";
            } else {
                sql = "UPDATE usuarios SET nombres = ?, apellidos = ? WHERE id_usuario = ?";
            }
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, usuario.getNombres());
            ps.setString(2, usuario.getApellidos());
            
            if (cambiarPassword) {
                ps.setString(3, usuario.getPassword());
                ps.setInt(4, usuario.getIdUsuario());
            } else {
                ps.setInt(3, usuario.getIdUsuario());
            }
            
            int filasAfectadas = ps.executeUpdate();
            resultado = (filasAfectadas > 0);
            
        } catch (SQLException e) {
            System.out.println("Error al actualizar perfil: " + e.getMessage());
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
}