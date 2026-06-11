package ec.edu.monster.modelo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    // Cambia según tu configuración
    private final String baseDatos = "pruebawebdb";  // ← Tu BD de prueba
    private final String url = "jdbc:mysql://localhost:3306/" + baseDatos + "?useSSL=false&serverTimezone=UTC";
    private final String usuario = "root";
    private final String clave = "";  // Tu contraseña de MySQL aquí
    
    public Connection conectar() {
        Connection cn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection(url, usuario, clave);
            cn.setAutoCommit(true); // ✅ HABILITAR AUTOCOMMIT EXPLÍCITAMENTE
            System.out.println("✔ Conexión exitosa a la base de datos");
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Error: No se pudo cargar el driver JDBC: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("❌ Error en la conexión: " + e.getMessage());
        }
        return cn;
    }
    
    // Método para cerrar conexión
    public void desconectar(Connection cn) {
        try {
            if (cn != null && !cn.isClosed()) {
                cn.close();
                System.out.println("✔ Conexión cerrada");
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al cerrar conexión: " + e.getMessage());
        }
    }
}