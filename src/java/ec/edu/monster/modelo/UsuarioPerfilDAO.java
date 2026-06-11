package ec.edu.monster.modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioPerfilDAO {

    private Conexion conexion;

    public UsuarioPerfilDAO() {
        this.conexion = new Conexion();
    }

    public boolean asignarPerfil(int idUsuario, int idPerfil) {

        String sql = "INSERT INTO XEUXP_USUPE (XEUSU_ID_USUARIO, XEPERF_ID) "
                   + "VALUES (?, ?)";

        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setInt(2, idPerfil);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("❌ Error asignarPerfil: " + e.getMessage());
        } finally {
            cerrar(ps, cn);
        }

        return false;
    }

    // =========================================
    // ASIGNAR MULTIPLES PERFILES
    // =========================================
    public boolean asignarPerfiles(int idUsuario, List<String> listaPerfiles) {
        if (listaPerfiles == null) return false;

        // 1. Eliminar perfiles existentes
        eliminarPerfilesUsuario(idUsuario);

        // 2. Insertar cada perfil nuevo
        for (String perfilIdStr : listaPerfiles) {
            try {
                int idPerfil = Integer.parseInt(perfilIdStr);
                asignarPerfil(idUsuario, idPerfil);
            } catch (NumberFormatException e) {
                System.out.println("❌ ID de perfil inválido: " + perfilIdStr);
            }
        }
        return true;
    }

    // =========================================
    // OBTENER PERFILES ACTUALES DE UN USUARIO
    // =========================================
    public List<String> obtenerCodigosPerfilesActivos(int idUsuario) {
        List<String> perfiles = new ArrayList<>();
        String sql = "SELECT XEPERF_ID FROM XEUXP_USUPE WHERE XEUSU_ID_USUARIO = ?";

        try (Connection cn = conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                perfiles.add(String.valueOf(rs.getInt("XEPERF_ID")));
            }

        } catch (SQLException e) {
            System.out.println("❌ Error obtenerCodigosPerfilesActivos: " + e.getMessage());
        }

        return perfiles;
    }

    // =========================================
    // ELIMINAR PERFILES EXISTENTES DE UN USUARIO
    // =========================================
    private boolean eliminarPerfilesUsuario(int idUsuario) {
        String sql = "DELETE FROM XEUXP_USUPE WHERE XEUSU_ID_USUARIO = ?";

        try (Connection cn = conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.out.println("❌ Error eliminarPerfilesUsuario: " + e.getMessage());
            return false;
        }
    }

    // =========================================
    // CERRAR RECURSOS
    // =========================================
    private void cerrar(PreparedStatement ps, Connection cn) {
        try {
            if (ps != null) ps.close();
            if (cn != null) conexion.desconectar(cn);
        } catch (SQLException e) {
            System.out.println("❌ Error cerrar recursos UsuarioPerfilDAO");
        }
    }
}
