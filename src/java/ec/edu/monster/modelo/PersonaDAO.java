package ec.edu.monster.modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * DAO para gestión de personas (XEPER_PERSONA)
 * Versión corregida con manejo de errores mejorado
 */
public class PersonaDAO {
    
    private Conexion conexion;
    
    public PersonaDAO() {
        this.conexion = new Conexion();
    }
    
    /**
     * Registrar nueva persona en la base de datos
     * @param p Objeto Persona con los datos
     * @return ID generado o -1 si hay error
     */
    public int registrarPersona(Persona p) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int idGenerado = -1;
        
        String sql = "INSERT INTO XEPER_PERSONA ("
                + "PEESC_CODIGO, PESEX_CODIGO, XEPER_CEDULA, XEPER_NOMBRES, "
                + "XEPER_APELLIDOS, XEPER_FECHANAC, XEPER_DIRECCION, XEPER_TELEFONO, "
                + "XEPER_EMAIL, XEPER_FECREGISTRO, XEPER_TIPO_PERSONA"
                + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?)";
        
        try {
            cn = conexion.conectar();
            
            if (cn == null) {
                System.out.println("❌ Error: No se pudo establecer conexión a la base de datos");
                return -1;
            }
            
            ps = cn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            
            // Validar y asignar parámetros
            ps.setString(1, validarCampo(p.getEstadoCivilCodigo(), "S")); // Default: Soltero
            ps.setString(2, validarCampo(p.getSexoCodigo(), "M")); // Default: Masculino
            ps.setString(3, validarCampo(p.getCedula(), null));
            ps.setString(4, validarCampo(p.getNombres(), "Sin nombre"));
            ps.setString(5, validarCampo(p.getApellidos(), "Sin apellido"));
            
            // Fecha de nacimiento
            if (p.getFechaNac() != null) {
                ps.setDate(6, new java.sql.Date(p.getFechaNac().getTime()));
            } else {
                // Default: 01/01/2000
                ps.setDate(6, java.sql.Date.valueOf("2000-01-01"));
            }
            
            ps.setString(7, p.getDireccion()); // Puede ser NULL
            ps.setString(8, p.getTelefono()); // Puede ser NULL
            ps.setString(9, validarCampo(p.getEmail(), "sin-email@temp.com"));
            ps.setString(10, validarCampo(p.getTipoPersona(), "U")); // Default: Usuario
            
            // Log de depuración
            System.out.println("📝 Intentando insertar persona:");
            System.out.println("   - Nombres: " + p.getNombres());
            System.out.println("   - Apellidos: " + p.getApellidos());
            System.out.println("   - Cédula: " + p.getCedula());
            System.out.println("   - Email: " + p.getEmail());
            
            int filasAfectadas = ps.executeUpdate();
            
            if (filasAfectadas > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    idGenerado = rs.getInt(1);
                    System.out.println("✅ Persona registrada exitosamente con ID: " + idGenerado);
                }
            } else {
                System.out.println("⚠️ No se insertó ninguna fila");
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error SQL en registrarPersona: " + e.getMessage());
            System.out.println("   Código de error: " + e.getErrorCode());
            System.out.println("   SQL State: " + e.getSQLState());
            e.printStackTrace();
            
            // Mensajes específicos según el error
            if (e.getMessage().contains("Duplicate entry")) {
                System.out.println("   ⚠️ La cédula ya existe en la base de datos");
            } else if (e.getMessage().contains("cannot be null")) {
                System.out.println("   ⚠️ Falta un campo obligatorio");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error general en registrarPersona: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }
        
        return idGenerado;
    }
    
    /**
     * Obtener persona por ID
     */
    public Persona obtenerPorId(int id) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Persona p = null;
        
        String sql = "SELECT * FROM XEPER_PERSONA WHERE XEPER_ID = ?";
        
        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                p = new Persona();
                p.setId(rs.getInt("XEPER_ID"));
                p.setEstadoCivilCodigo(rs.getString("PEESC_CODIGO"));
                p.setSexoCodigo(rs.getString("PESEX_CODIGO"));
                p.setCedula(rs.getString("XEPER_CEDULA"));
                p.setNombres(rs.getString("XEPER_NOMBRES"));
                p.setApellidos(rs.getString("XEPER_APELLIDOS"));
                p.setFechaNac(rs.getDate("XEPER_FECHANAC"));
                p.setDireccion(rs.getString("XEPER_DIRECCION"));
                p.setTelefono(rs.getString("XEPER_TELEFONO"));
                p.setEmail(rs.getString("XEPER_EMAIL"));
                p.setFechaRegistro(rs.getTimestamp("XEPER_FECREGISTRO"));
                p.setTipoPersona(rs.getString("XEPER_TIPO_PERSONA"));
                
                System.out.println("✅ Persona obtenida: " + p.getNombres() + " " + p.getApellidos());
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en obtenerPorId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }
        
        return p;
    }
    
    /**
     * Obtener persona por cédula
     */
    public Persona obtenerPorCedula(String cedula) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Persona p = null;
        
        String sql = "SELECT * FROM XEPER_PERSONA WHERE XEPER_CEDULA = ?";
        
        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, cedula);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                p = new Persona();
                p.setId(rs.getInt("XEPER_ID"));
                p.setEstadoCivilCodigo(rs.getString("PEESC_CODIGO"));
                p.setSexoCodigo(rs.getString("PESEX_CODIGO"));
                p.setCedula(rs.getString("XEPER_CEDULA"));
                p.setNombres(rs.getString("XEPER_NOMBRES"));
                p.setApellidos(rs.getString("XEPER_APELLIDOS"));
                p.setFechaNac(rs.getDate("XEPER_FECHANAC"));
                p.setDireccion(rs.getString("XEPER_DIRECCION"));
                p.setTelefono(rs.getString("XEPER_TELEFONO"));
                p.setEmail(rs.getString("XEPER_EMAIL"));
                p.setFechaRegistro(rs.getTimestamp("XEPER_FECREGISTRO"));
                p.setTipoPersona(rs.getString("XEPER_TIPO_PERSONA"));
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en obtenerPorCedula: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }
        
        return p;
    }
    
    /**
     * Verificar si existe una cédula
     */
    public boolean existeCedula(String cedula) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        String sql = "SELECT COUNT(*) FROM XEPER_PERSONA WHERE XEPER_CEDULA = ?";
        
        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, cedula);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en existeCedula: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }
        
        return false;
    }
    
    /**
     * Actualizar datos de persona
     */
    public boolean actualizarPersona(Persona p) {
        Connection cn = null;
        PreparedStatement ps = null;
        
        String sql = "UPDATE XEPER_PERSONA SET "
                + "PEESC_CODIGO = ?, PESEX_CODIGO = ?, XEPER_NOMBRES = ?, "
                + "XEPER_APELLIDOS = ?, XEPER_FECHANAC = ?, XEPER_DIRECCION = ?, "
                + "XEPER_TELEFONO = ?, XEPER_EMAIL = ? "
                + "WHERE XEPER_ID = ?";
        
        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            
            ps.setString(1, p.getEstadoCivilCodigo());
            ps.setString(2, p.getSexoCodigo());
            ps.setString(3, p.getNombres());
            ps.setString(4, p.getApellidos());
            ps.setDate(5, new java.sql.Date(p.getFechaNac().getTime()));
            ps.setString(6, p.getDireccion());
            ps.setString(7, p.getTelefono());
            ps.setString(8, p.getEmail());
            ps.setInt(9, p.getId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error en actualizarPersona: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(null, ps, cn);
        }
        
        return false;
    }
    
    /**
     * Validar campo: retorna el valor si no es null/empty, sino retorna el default
     */
    private String validarCampo(String valor, String valorDefault) {
        if (valor == null || valor.trim().isEmpty()) {
            return valorDefault;
        }
        return valor.trim();
    }
    
    /**
     * Cerrar recursos de base de datos
     */
    private void cerrarRecursos(ResultSet rs, PreparedStatement ps, Connection cn) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (cn != null) {
                conexion.desconectar(cn);
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al cerrar recursos: " + e.getMessage());
        }
    }
}