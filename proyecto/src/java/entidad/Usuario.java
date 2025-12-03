package entidad;

import java.sql.Timestamp;

public class Usuario {
    
    private int idUsuario;
    private String codigo;
    private String nombres;
    private String apellidos;
    private String correo;
    private String contrasena;
    private String rol;
    private String escuela;
    private String telefono;
    private boolean activo;
    private Timestamp fechaRegistro;
    
    // Constructor vacío
    public Usuario() {
    }
    
    // Constructor para registro (sin ID)
    public Usuario(String codigo, String nombres, String apellidos, String correo, 
                   String contrasena, String rol, String escuela, String telefono) {
        this.codigo = codigo;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.correo = correo;
        this.contrasena = contrasena;
        this.rol = rol;
        this.escuela = escuela;
        this.telefono = telefono;
        this.activo = true;
    }
    
    // Constructor completo
    public Usuario(int idUsuario, String codigo, String nombres, String apellidos, 
                   String correo, String contrasena, String rol, String escuela, 
                   String telefono, boolean activo, Timestamp fechaRegistro) {
        this.idUsuario = idUsuario;
        this.codigo = codigo;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.correo = correo;
        this.contrasena = contrasena;
        this.rol = rol;
        this.escuela = escuela;
        this.telefono = telefono;
        this.activo = activo;
        this.fechaRegistro = fechaRegistro;
    }
    
    // Getters y Setters
    public int getIdUsuario() {
        return idUsuario;
    }
    
    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }
    
    public String getCodigo() {
        return codigo;
    }
    
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
    
    public String getNombres() {
        return nombres;
    }
    
    public void setNombres(String nombres) {
        this.nombres = nombres;
    }
    
    public String getApellidos() {
        return apellidos;
    }
    
    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }
    
    public String getCorreo() {
        return correo;
    }
    
    public void setCorreo(String correo) {
        this.correo = correo;
    }
    
    public String getContrasena() {
        return contrasena;
    }
    
    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }
    
    // Alias para compatibilidad
    public String getPassword() {
        return contrasena;
    }
    
    public void setPassword(String password) {
        this.contrasena = password;
    }
    
    public String getRol() {
        return rol;
    }
    
    public void setRol(String rol) {
        this.rol = rol;
    }
    
    public String getEscuela() {
        return escuela;
    }
    
    public void setEscuela(String escuela) {
        this.escuela = escuela;
    }
    
    public String getTelefono() {
        return telefono;
    }
    
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }
    
    public boolean isActivo() {
        return activo;
    }
    
    public void setActivo(boolean activo) {
        this.activo = activo;
    }
    
    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }
    
    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
    
    // Método auxiliar para obtener nombre completo
    public String getNombreCompleto() {
        return nombres + " " + apellidos;
    }
    
    @Override
    public String toString() {
        return "Usuario{" +
                "idUsuario=" + idUsuario +
                ", codigo='" + codigo + '\'' +
                ", nombres='" + nombres + '\'' +
                ", apellidos='" + apellidos + '\'' +
                ", correo='" + correo + '\'' +
                ", rol='" + rol + '\'' +
                ", escuela='" + escuela + '\'' +
                '}';
    }
    
    public String getEmail() {
    return correo; // o el nombre del atributo que uses
}

public String getEstado() {
    return activo ? "ACTIVO" : "INACTIVO";
}
}