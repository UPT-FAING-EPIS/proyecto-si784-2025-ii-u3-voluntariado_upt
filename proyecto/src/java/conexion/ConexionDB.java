package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    
    // Configuración para XAMPP con HeidiSQL
    private static final String URL = "jdbc:mysql://localhost:3306/voluntariado_upt";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // XAMPP por defecto no tiene contraseña
    
    // Método para obtener conexión
    public static Connection getConnection() throws SQLException {
        Connection conn = null;
        try {
            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establecer la conexión
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
        } catch (ClassNotFoundException e) {
            System.out.println("Error: Driver MySQL no encontrado");
            e.printStackTrace();
            throw new SQLException("Driver no encontrado", e);
        } catch (SQLException e) {
            System.out.println("Error al conectar con la base de datos");
            e.printStackTrace();
            throw e;
        }
        
        return conn;
    }
    
    // Método para cerrar la conexión
    public static void cerrarConexion(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar la conexión");
                e.printStackTrace();
            }
        }
    }
    
    // Método de prueba de conexión
    public static boolean probarConexion() {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                System.out.println("✓ Conexión exitosa a la base de datos");
                cerrarConexion(conn);
                return true;
            }
        } catch (SQLException e) {
            System.out.println("✗ Error de conexión: " + e.getMessage());
        }
        return false;
    }
}