package ec.edu.monster.modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Calendar;

/**
 * DAO para gestionar tokens de recuperación de contraseña
 */
public class TokenRecuperacionDAO {
    
    private Conexion conexion;
    
    public TokenRecuperacionDAO() {
        this.conexion = new Conexion();
    }
    
    /**
     * Crear un token de recuperación para un usuario
     * @param idUsuario ID del usuario
     * @return Token generado
     */
    public String crearToken(int idUsuario) {
        Connection cn = null;
        PreparedStatement ps = null;
        
        try {
            // Generar token único
            String token = generarTokenUnico();
            
            // Calcular expiración (24 horas)
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.HOUR_OF_DAY, 24);
            Timestamp expiracion = new Timestamp(cal.getTimeInMillis());
            
            String sql = "INSERT INTO XETREC_TOKENREC (XEUSU_ID, XETREC_TOKEN, XETREC_EXPIRACION, XETREC_USADO) " +
                         "VALUES (?, ?, ?, 'N')";
            
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setString(2, token);
            ps.setTimestamp(3, expiracion);
            
            int resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("✅ Token creado para usuario ID: " + idUsuario);
                return token;
            } else {
                System.out.println("❌ Error al crear token para usuario ID: " + idUsuario);
                return null;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en crearToken: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            cerrarRecursos(null, ps, cn);
        }
    }
    
    /**
     * Validar un token de recuperación
     * @param token Token a validar
     * @return ID del usuario si es válido, -1 si no existe o expiró
     */
    public int validarToken(String token) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT XEUSU_ID FROM XETREC_TOKENREC " +
                         "WHERE XETREC_TOKEN = ? " +
                         "AND XETREC_USADO = 'N' " +
                         "AND XETREC_EXPIRACION > NOW()";
            
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, token);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                System.out.println("✅ Token válido");
                return rs.getInt("XEUSU_ID");
            } else {
                System.out.println("❌ Token inválido o expirado");
                return -1;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en validarToken: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            cerrarRecursos(rs, ps, cn);
        }
    }
    
    /**
     * Marcar un token como usado
     * @param token Token a marcar como usado
     * @return true si fue marcado exitosamente
     */
    public boolean marcarTokenComoUsado(String token) {
        Connection cn = null;
        PreparedStatement ps = null;
        
        try {
            String sql = "UPDATE XETREC_TOKENREC SET XETREC_USADO = 'S' " +
                         "WHERE XETREC_TOKEN = ?";
            
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, token);
            
            int resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("✅ Token marcado como usado");
                return true;
            } else {
                System.out.println("❌ Error al marcar token como usado");
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en marcarTokenComoUsado: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            cerrarRecursos(null, ps, cn);
        }
    }
    
    /**
     * Limpiar tokens expirados
     */
    public void limpiarTokensExpirados() {
        Connection cn = null;
        PreparedStatement ps = null;
        
        try {
            String sql = "DELETE FROM XETREC_TOKENREC " +
                         "WHERE XETREC_EXPIRACION < NOW() " +
                         "OR (XETREC_USADO = 'S' AND DATEDIFF(NOW(), XETREC_CREACION) > 7)";
            
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            
            int registrosEliminados = ps.executeUpdate();
            if (registrosEliminados > 0) {
                System.out.println("✅ Tokens expirados limpiados: " + registrosEliminados);
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en limpiarTokensExpirados: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(null, ps, cn);
        }
    }
    
    /**
     * Generar un token único de 64 caracteres
     */
    private String generarTokenUnico() {
        String caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder token = new StringBuilder();
        
        for (int i = 0; i < 64; i++) {
            int indice = (int) (Math.random() * caracteres.length());
            token.append(caracteres.charAt(indice));
        }
        
        return token.toString();
    }
    
    /**
     * Cerrar recursos de BD
     */
    private void cerrarRecursos(ResultSet rs, PreparedStatement ps, Connection cn) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (cn != null) cn.close();
        } catch (SQLException e) {
            System.out.println("❌ Error cerrar recursos TokenRecuperacionDAO");
            e.printStackTrace();
        }
    }
}
