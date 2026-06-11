package ec.edu.monster.modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para gestionar perfiles (XEPER_PERFI)
 * Perfiles: Estudiante, Docente, Secretario Académico, Administrador
 */
public class PerfilDAO {
    
    private Conexion conexion;
    
    public PerfilDAO() {
        this.conexion = new Conexion();
    }
    
    /**
     * Obtener todos los perfiles disponibles
     */
    public List<Perfil> listarTodos() {
        List<Perfil> perfiles = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        String sql = "SELECT XEPER_CODIGO, XEPER_DESCRI, XEPER_OBSER FROM XEPER_PERFI ORDER BY XEPER_DESCRI";
        
        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Perfil p = new Perfil();
                p.setCodigo(rs.getString("XEPER_CODIGO"));
                p.setDescripcion(rs.getString("XEPER_DESCRI"));
                p.setObservacion(rs.getString("XEPER_OBSER"));
                perfiles.add(p);
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en listarTodos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }
        
        return perfiles;
    }
    
    /**
     * Obtener perfil por código
     */
    public Perfil obtenerPorCodigo(String codigo) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Perfil perfil = null;
        
        String sql = "SELECT XEPER_CODIGO, XEPER_DESCRI, XEPER_OBSER FROM XEPER_PERFI WHERE XEPER_CODIGO = ?";
        
        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, codigo);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                perfil = new Perfil();
                perfil.setCodigo(rs.getString("XEPER_CODIGO"));
                perfil.setDescripcion(rs.getString("XEPER_DESCRI"));
                perfil.setObservacion(rs.getString("XEPER_OBSER"));
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en obtenerPorCodigo: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }
        
        return perfil;
    }
    
    /**
     * Obtener perfiles asignados a un usuario específico
     */
    public List<Perfil> obtenerPerfilesPorUsuario(int idUsuario) {
        List<Perfil> perfiles = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        String sql = "SELECT p.XEPER_CODIGO, p.XEPER_DESCRI, p.XEPER_OBSER " +
                    "FROM XEPER_PERFI p " +
                    "INNER JOIN XEUXP_USUPE up ON p.XEPER_CODIGO = up.XEPER_CODIGO " +
                    "WHERE up.XEUSU_ID_USUARIO = ? AND up.XEUXP_FECRET IS NULL " +
                    "ORDER BY p.XEPER_DESCRI";
        
        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Perfil p = new Perfil();
                p.setCodigo(rs.getString("XEPER_CODIGO"));
                p.setDescripcion(rs.getString("XEPER_DESCRI"));
                p.setObservacion(rs.getString("XEPER_OBSER"));
                perfiles.add(p);
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en obtenerPerfilesPorUsuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }
        
        return perfiles;
    }
    
    /**
     * Crear un nuevo perfil
     */
    public boolean crearPerfil(Perfil perfil) {
        Connection cn = null;
        PreparedStatement ps = null;
        
        String sql = "INSERT INTO XEPER_PERFI (XEPER_CODIGO, XEPER_DESCRI, XEPER_OBSER) VALUES (?, ?, ?)";
        
        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, perfil.getCodigo());
            ps.setString(2, perfil.getDescripcion());
            ps.setString(3, perfil.getObservacion());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error en crearPerfil: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(null, ps, cn);
        }
        
        return false;
    }
    
    private void cerrarRecursos(ResultSet rs, PreparedStatement ps, Connection cn) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (cn != null) conexion.desconectar(cn);
        } catch (SQLException e) {
            System.out.println("❌ Error al cerrar recursos: " + e.getMessage());
        }
    }
}