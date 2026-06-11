package ec.edu.monster.modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioAcademicoDAO {
    private Conexion conexion;

    public UsuarioAcademicoDAO() {
        this.conexion = new Conexion();
    }

    /**
     * Genera automáticamente el siguiente ID académico según el tipo
     * @param tipo ESTUDIANTE, DOCENTE, SECRETARIO, ADMINISTRADOR
     * @return ID generado (ej: E00000001, D00000001, S00000001, A00000001)
     */
    public String generarIdAcademico(String tipo) {
        Connection cn = null;
        PreparedStatement ps = null;
        PreparedStatement psUpdate = null;
        ResultSet rs = null;
        
        try {
            cn = conexion.conectar();
            cn.setAutoCommit(false); // Iniciar transacción
            
            // Obtener el último número para este tipo
            String sqlSelect = "SELECT ULTIMO_NUMERO FROM XESEC_SECUENCIAS WHERE TIPO = ? FOR UPDATE";
            ps = cn.prepareStatement(sqlSelect);
            ps.setString(1, tipo);
            rs = ps.executeQuery();
            
            int ultimoNumero = 0;
            if (rs.next()) {
                ultimoNumero = rs.getInt("ULTIMO_NUMERO");
            }
            
            // Incrementar
            int nuevoNumero = ultimoNumero + 1;
            
            // Actualizar la secuencia
            String sqlUpdate = "UPDATE XESEC_SECUENCIAS SET ULTIMO_NUMERO = ? WHERE TIPO = ?";
            psUpdate = cn.prepareStatement(sqlUpdate);
            psUpdate.setInt(1, nuevoNumero);
            psUpdate.setString(2, tipo);
            psUpdate.executeUpdate();
            
            cn.commit(); // Confirmar transacción
            
            // Generar el ID con prefijo y formato
            String prefijo = obtenerPrefijo(tipo);
            String idAcademico = String.format("%s%08d", prefijo, nuevoNumero);
            
            System.out.println("✅ ID Académico generado: " + idAcademico + " para tipo: " + tipo);
            return idAcademico;
            
        } catch (SQLException e) {
            try {
                if (cn != null) cn.rollback();
            } catch (SQLException ex) {
                System.out.println("❌ Error en rollback: " + ex.getMessage());
            }
            System.out.println("❌ Error al generar ID académico: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (psUpdate != null) psUpdate.close();
                if (cn != null) {
                    cn.setAutoCommit(true);
                    conexion.desconectar(cn);
                }
            } catch (SQLException ex) {
                System.out.println("❌ Error al cerrar recursos: " + ex.getMessage());
            }
        }
    }
    
    /**
     * Obtiene el prefijo según el tipo de usuario
     */
    private String obtenerPrefijo(String tipo) {
        if (tipo == null) return "X";
        switch (tipo.toUpperCase()) {
            case "ESTUDIANTE": return "E";
            case "DOCENTE": return "D";
            case "SECRETARIO":
            case "SECRETARIO_ACADEMICO": return "S";
            case "ADMINISTRADOR":
            case "ADMIN": return "A";
            default: return "X"; // Por si acaso
        }
    }
    
    /**
     * Detecta el tipo de usuario según los perfiles asignados.
     * Consulta la descripción del perfil en BD y usa palabras clave.
     */
    public String detectarTipoUsuario(String[] perfiles) {
        if (perfiles == null || perfiles.length == 0) {
            return null;
        }

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = conexion.conectar();
            String sql = "SELECT XEPER_DESCRI FROM XEPER_PERFI WHERE XEPER_CODIGO = ?";
            ps = cn.prepareStatement(sql);

            for (String perfilCodigo : perfiles) {
                if (perfilCodigo == null || perfilCodigo.trim().isEmpty()) {
                    continue;
                }

                ps.setString(1, perfilCodigo);
                rs = ps.executeQuery();

                String descri = null;
                if (rs.next()) {
                    descri = rs.getString("XEPER_DESCRI");
                }

                String tipoDetectado = determinarTipo(perfilCodigo, descri);
                if (tipoDetectado != null) {
                    return tipoDetectado;
                }

                if (rs != null) {
                    rs.close();
                }
            }

        } catch (SQLException e) {
            System.out.println("❌ Error al detectar tipo de usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) conexion.desconectar(cn);
            } catch (SQLException e) {
                System.out.println("❌ Error al cerrar recursos: " + e.getMessage());
            }
        }

        return null;
    }

    private String determinarTipo(String codigoPerfil, String descripcion) {
        String codigo = codigoPerfil == null ? "" : codigoPerfil.toUpperCase();
        String descri = descripcion == null ? "" : descripcion.toUpperCase();
        String texto = codigo + " " + descri;

        if (texto.contains("ESTUD")) return "ESTUDIANTE";
        if (texto.contains("DOCENT") || texto.contains("PROFES")) return "DOCENTE";
        if (texto.contains("SECRET") || texto.contains("ACADEM")) return "SECRETARIO_ACADEMICO";
        if (texto.contains("ADMIN") || texto.contains("SISTEM")) return "ADMINISTRADOR";
        return null;
    }

    /**
     * Obtiene el tipo e ID académico actuales de un usuario.
     * @return String[]{tipo, idAcademico} o null si no existe registro.
     */
    public String[] obtenerTipoEIdPorUsuario(int idUsuario) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT TIPO, ID_ACADEMICO FROM XEACU_USR_ACADE WHERE XEUSU_ID_USUARIO = ?";

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new String[]{rs.getString("TIPO"), rs.getString("ID_ACADEMICO")};
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al obtener datos académicos: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) conexion.desconectar(cn);
            } catch (SQLException e) {
                System.out.println("❌ Error al cerrar recursos: " + e.getMessage());
            }
        }
        return null;
    }

    public boolean guardar(int idUsuario, String tipo, String idAcademico) {
        Connection cn = null;
        PreparedStatement ps = null;
        String sql = "INSERT INTO XEACU_USR_ACADE (XEUSU_ID_USUARIO, TIPO, ID_ACADEMICO) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE TIPO = VALUES(TIPO), ID_ACADEMICO = VALUES(ID_ACADEMICO), FECMOD = NOW()";
        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setString(2, tipo);
            ps.setString(3, idAcademico);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("❌ Error guardar UsuarioAcademico: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) conexion.desconectar(cn);
            } catch (SQLException ex) {
                System.out.println("❌ Error al cerrar recursos UsuarioAcademicoDAO: " + ex.getMessage());
            }
        }
    }
}