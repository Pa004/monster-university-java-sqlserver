package ec.edu.monster.modelo;

public class TestConexion {
    public static void main(String[] args) {

        Conexion cn = new Conexion();

        if (cn.conectar() != null) {
            System.out.println("🎉 Conexión exitosa — Todo funciona correctamente");
        } else {
            System.out.println("❌ No se pudo establecer la conexión");
        }
    }
}
