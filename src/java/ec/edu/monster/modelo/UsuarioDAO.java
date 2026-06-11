package ec.edu.monster.modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO Completo para gestión de usuarios (XEUSU_USUAR)
 * Incluye: CRUD, búsquedas, filtros, cambio de estado
 */
public class UsuarioDAO {

    private Conexion conexion;

    public UsuarioDAO() {
        this.conexion = new Conexion();
    }

    // ========================================
    // AUTENTICACIÓN
    // ========================================
    
    public Usuario validarUsuario(String username, String password) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Usuario usuario = null;

        String sql = "SELECT u.XEUSU_ID_USUARIO, u.XEPER_ID, u.XEUSU_USERNAME, "
            + "u.PASSWORDHASH, u.EMAIL_USUARIO, u.XEEST_CODIGO, u.PEEMP_CODIGO, u.FOTO_PATH, "
            + "u.PRIMER_INGRESO, u.CONTRASEÑA_TEMPORAL, "
            + "p.XEPER_NOMBRES, p.XEPER_APELLIDOS, p.XEPER_EMAIL, p.XEPER_CEDULA, "
            + "e.PEEMP_ESTADOEMPLEADO "
                + "FROM XEUSU_USUAR u "
                + "INNER JOIN XEPER_PERSONA p ON u.XEPER_ID = p.XEPER_ID "
                + "LEFT JOIN PEEMP_EMPLE e ON u.PEEMP_CODIGO = e.PEEMP_CODIGO "
                + "WHERE u.XEUSU_USERNAME = ? AND u.XEEST_CODIGO = 'A'";

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                String passwordGuardada = rs.getString("PASSWORDHASH");
                // Verify with PBKDF2 util; supports legacy plain text
                if (ec.edu.monster.util.PasswordUtil.verify(password, passwordGuardada)) {
                    usuario = mapearUsuario(rs);
                }
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en validarUsuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }

        return usuario;
    }

    // ========================================
    // CREAR USUARIO
    // ========================================
    
    public int crearUsuario(Usuario u) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int idGenerado = -1;

        String sql = "INSERT INTO XEUSU_USUAR (XEPER_ID, XEEST_CODIGO, PEEMP_CODIGO, "
            + "XEUSU_USERNAME, PASSWORDHASH, EMAIL_USUARIO, FOTO_PATH, XEUSU_FECCRE) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, u.getXeperId());
            ps.setString(2, u.getEstadoCodigo() == null ? "A" : u.getEstadoCodigo());
            // Si el código de empleado viene vacío, enviamos NULL para evitar violar FK
            if (u.getPempCodigo() == null || u.getPempCodigo().trim().isEmpty()) {
                ps.setNull(3, java.sql.Types.VARCHAR);
            } else {
                ps.setString(3, u.getPempCodigo());
            }
            ps.setString(4, u.getUsername());
            ps.setString(5, u.getPasswordHash());
            ps.setString(6, u.getEmailUsuario());
            ps.setString(7, u.getFotoPath());

            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                idGenerado = rs.getInt(1);
            }

        } catch (SQLException e) {
            System.out.println("❌ Error crearUsuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }

        return idGenerado;
    }

    // ========================================
    // ACTUALIZAR USUARIO
    // ========================================
    
    public boolean actualizarUsuario(Usuario u) {
        Connection cn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE XEUSU_USUAR SET XEPER_ID = ?, XEEST_CODIGO = ?, "
            + "PEEMP_CODIGO = ?, XEUSU_USERNAME = ?, PASSWORDHASH = ?, EMAIL_USUARIO = ?, FOTO_PATH = ?, XEUSU_FECMOD = NOW() "
            + "WHERE XEUSU_ID_USUARIO = ?";

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setInt(1, u.getXeperId());
            ps.setString(2, u.getEstadoCodigo());
            ps.setString(3, u.getPempCodigo());
            ps.setString(4, u.getUsername());
            ps.setString(5, u.getPasswordHash());
            ps.setString(6, u.getEmailUsuario());
            ps.setString(7, u.getFotoPath());
            ps.setInt(8, u.getUsuIdUsuario());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("❌ Error actualizarUsuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(null, ps, cn);
        }
        return false;
    }

    // ========================================
    // ELIMINAR USUARIO (Hard delete - Elimina físicamente de la BD)
    // ========================================
    
    public boolean eliminarUsuario(int idUsuario) {
        Connection cn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        
        try {
            cn = conexion.conectar();
            
            if (cn == null) {
                System.out.println("❌ Error: Conexión nula en eliminarUsuario");
                return false;
            }
            
            // Primero eliminar los perfiles asignados al usuario (XEUXP_USUPE)
            String sqlEliminarPerfiles = "DELETE FROM XEUXP_USUPE WHERE XEUSU_ID_USUARIO = ?";
            ps1 = cn.prepareStatement(sqlEliminarPerfiles);
            ps1.setInt(1, idUsuario);
            int filasPerfiles = ps1.executeUpdate();
            System.out.println("   ✅ Perfiles eliminados: " + filasPerfiles);
            
            // Luego eliminar el usuario (XEUSU_USUAR)
            String sqlEliminarUsuario = "DELETE FROM XEUSU_USUAR WHERE XEUSU_ID_USUARIO = ?";
            ps2 = cn.prepareStatement(sqlEliminarUsuario);
            ps2.setInt(1, idUsuario);
            int filasUsuario = ps2.executeUpdate();
            
            if (filasUsuario > 0) {
                System.out.println("✅ Usuario eliminado de XEUSU_USUAR. Filas afectadas: " + filasUsuario);
                return true;
            } else {
                System.out.println("⚠️ No se eliminó ningún usuario. Verificar si el ID existe.");
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error eliminarUsuario: " + e.getMessage());
            System.out.println("   SQL State: " + e.getSQLState());
            System.out.println("   Error Code: " + e.getErrorCode());
            
            // Mostrar detalles de FK si es el caso
            if (e.getMessage().contains("foreign key")) {
                System.out.println("   ⚠️ Error de Foreign Key: Hay registros dependientes del usuario");
            }
            e.printStackTrace();
        } finally {
            try {
                if (ps1 != null) ps1.close();
                if (ps2 != null) ps2.close();
                if (cn != null) conexion.desconectar(cn);
            } catch (SQLException e) {
                System.out.println("❌ Error al cerrar recursos: " + e.getMessage());
            }
        }
        return false;
    }

    // ========================================
    // ACTUALIZAR CONTRASEÑA (Recuperación)
    // ========================================
    
    public boolean actualizarPassword(int idUsuario, String nuevoPasswordHash) {
        Connection cn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE XEUSU_USUAR SET PASSWORDHASH = ?, XEUSU_FECMOD = NOW() WHERE XEUSU_ID_USUARIO = ?";

        try {
            cn = conexion.conectar();
            
            if (cn == null) {
                System.out.println("❌ Error: Conexión nula en actualizarPassword");
                return false;
            }
            
            ps = cn.prepareStatement(sql);
            ps.setString(1, nuevoPasswordHash);
            ps.setInt(2, idUsuario);
            
            int filasAfectadas = ps.executeUpdate();
            
            if (filasAfectadas > 0) {
                System.out.println("✅ Contraseña actualizada para usuario ID: " + idUsuario);
                return true;
            } else {
                System.out.println("⚠️ No se actualizó ninguna contraseña. ID usuario: " + idUsuario);
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error actualizarPassword: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(null, ps, cn);
        }
        return false;
    }

    // ========================================
    // ACTUALIZAR FLAGS DE CONTRASEÑA (después de cambiar)
    // ========================================
    
    public boolean marcarContrasenaActualizada(int idUsuario) {
        Connection cn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE XEUSU_USUAR SET PRIMER_INGRESO = 'N', CONTRASEÑA_TEMPORAL = 'N', XEUSU_FECMOD = NOW() WHERE XEUSU_ID_USUARIO = ?";

        try {
            cn = conexion.conectar();
            
            if (cn == null) {
                System.out.println("❌ Error: Conexión nula en marcarContrasenaActualizada");
                return false;
            }
            
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            
            int filasAfectadas = ps.executeUpdate();
            
            if (filasAfectadas > 0) {
                System.out.println("✅ Flags actualizados - usuario: " + idUsuario);
                return true;
            } else {
                System.out.println("⚠️ No se actualizaron los flags");
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error marcarContrasenaActualizada: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(null, ps, cn);
        }
        return false;
    }

    public boolean marcarContrasenaComoDeTipo(int idUsuario, char primerIngreso, char contrasenaTemporal) {
        Connection cn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE XEUSU_USUAR SET PRIMER_INGRESO = ?, CONTRASEÑA_TEMPORAL = ?, XEUSU_FECMOD = NOW() WHERE XEUSU_ID_USUARIO = ?";

        try {
            cn = conexion.conectar();
            
            if (cn == null) {
                System.out.println("❌ Error: Conexión nula en marcarContrasenaComoDeTipo");
                return false;
            }
            
            ps = cn.prepareStatement(sql);
            ps.setString(1, String.valueOf(primerIngreso));
            ps.setString(2, String.valueOf(contrasenaTemporal));
            ps.setInt(3, idUsuario);
            
            int filasAfectadas = ps.executeUpdate();
            
            if (filasAfectadas > 0) {
                System.out.println("✅ Tipo de contraseña actualizado - usuario: " + idUsuario);
                return true;
            } else {
                System.out.println("⚠️ No se actualizó el tipo de contraseña");
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error marcarContrasenaComoDeTipo: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(null, ps, cn);
        }
        return false;
    }

    // ========================================
    // CAMBIAR ESTADO
    // ========================================
    
    public boolean cambiarEstado(int idUsuario, String nuevoEstado) {
        Connection cn = null;
        PreparedStatement ps = null;
        String sql = "UPDATE XEUSU_USUAR SET XEEST_CODIGO = ?, XEUSU_FECMOD = NOW() WHERE XEUSU_ID_USUARIO = ?";

        try {
            cn = conexion.conectar();
            
            if (cn == null) {
                System.out.println("❌ Error: Conexión nula en cambiarEstado");
                return false;
            }
            
            ps = cn.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idUsuario);

            System.out.println("🔄 Cambiando estado de usuario ID " + idUsuario + " a: " + nuevoEstado);
            int filasAfectadas = ps.executeUpdate();
            
            if (filasAfectadas > 0) {
                System.out.println("✅ Estado cambiado exitosamente. Filas afectadas: " + filasAfectadas);
                return true;
            } else {
                System.out.println("⚠️ No se actualizó ninguna fila. Verificar si el ID existe.");
                return false;
            }

        } catch (SQLException e) {
            System.out.println("❌ Error cambiarEstado: " + e.getMessage());
            System.out.println("   SQL State: " + e.getSQLState());
            System.out.println("   Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } finally {
            cerrarRecursos(null, ps, cn);
        }
        return false;
    }

    // ========================================
    // LISTAR TODOS LOS USUARIOS
    // ========================================
    
    public List<Usuario> listarTodos() {
        List<Usuario> usuarios = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT u.XEUSU_ID_USUARIO, u.XEPER_ID, u.XEUSU_USERNAME, "
            + "u.PASSWORDHASH, u.EMAIL_USUARIO, u.XEEST_CODIGO, u.PEEMP_CODIGO, u.FOTO_PATH, "
            + "p.XEPER_NOMBRES, p.XEPER_APELLIDOS, p.XEPER_EMAIL, p.XEPER_CEDULA, "
            + "e.PEEMP_ESTADOEMPLEADO, "
            + "ac.TIPO AS TIPO_USUARIO, ac.ID_ACADEMICO, "
            + "GROUP_CONCAT(per.XEPER_DESCRI SEPARATOR ', ') AS PERFILES "
            + "FROM XEUSU_USUAR u "
            + "INNER JOIN XEPER_PERSONA p ON u.XEPER_ID = p.XEPER_ID "
            + "LEFT JOIN PEEMP_EMPLE e ON u.PEEMP_CODIGO = e.PEEMP_CODIGO "
            + "LEFT JOIN XEUXP_USUPE up ON u.XEUSU_ID_USUARIO = up.XEUSU_ID_USUARIO AND up.XEUXP_FECRET IS NULL "
            + "LEFT JOIN XEPER_PERFI per ON up.XEPER_CODIGO = per.XEPER_CODIGO "
            + "LEFT JOIN XEACU_USR_ACADE ac ON ac.XEUSU_ID_USUARIO = u.XEUSU_ID_USUARIO "
            + "GROUP BY u.XEUSU_ID_USUARIO "
            + "ORDER BY p.XEPER_APELLIDOS, p.XEPER_NOMBRES";

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                usuarios.add(mapearUsuario(rs));
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en listarTodos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }

        return usuarios;
    }

    // ========================================
    // BUSCAR POR ID
    // ========================================
    
    public Usuario obtenerPorId(int idUsuario) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Usuario usuario = null;

        String sql = "SELECT u.XEUSU_ID_USUARIO, u.XEPER_ID, u.XEUSU_USERNAME, "
            + "u.PASSWORDHASH, u.EMAIL_USUARIO, u.XEEST_CODIGO, u.PEEMP_CODIGO, u.FOTO_PATH, "
            + "p.XEPER_NOMBRES, p.XEPER_APELLIDOS, p.XEPER_EMAIL, p.XEPER_CEDULA "
                + "FROM XEUSU_USUAR u "
                + "INNER JOIN XEPER_PERSONA p ON u.XEPER_ID = p.XEPER_ID "
                + "WHERE u.XEUSU_ID_USUARIO = ?";

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                usuario = mapearUsuario(rs);
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en obtenerPorId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }

        return usuario;
    }

    // ========================================
    // BUSCAR POR USERNAME
    // ========================================
    
    public Usuario obtenerPorUsername(String username) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Usuario usuario = null;

        String sql = "SELECT u.XEUSU_ID_USUARIO, u.XEPER_ID, u.XEUSU_USERNAME, "
                + "u.EMAIL_USUARIO, u.XEEST_CODIGO, u.PEEMP_CODIGO, "
                + "p.XEPER_NOMBRES, p.XEPER_APELLIDOS, p.XEPER_EMAIL, p.XEPER_CEDULA "
                + "FROM XEUSU_USUAR u "
                + "INNER JOIN XEPER_PERSONA p ON u.XEPER_ID = p.XEPER_ID "
                + "WHERE u.XEUSU_USERNAME = ?";

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                usuario = mapearUsuario(rs);
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en obtenerPorUsername: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }

        return usuario;
    }

    // ========================================
    // BUSCAR CON FILTROS
    // ========================================
    
    public List<Usuario> buscarConFiltros(String nombre, String rol, String estado) {
        List<Usuario> usuarios = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT DISTINCT u.XEUSU_ID_USUARIO, u.XEPER_ID, u.XEUSU_USERNAME, ")
           .append("u.PASSWORDHASH, u.EMAIL_USUARIO, u.XEEST_CODIGO, u.PEEMP_CODIGO, ")
           .append("p.XEPER_NOMBRES, p.XEPER_APELLIDOS, p.XEPER_EMAIL, p.XEPER_CEDULA ")
           .append("FROM XEUSU_USUAR u ")
           .append("INNER JOIN XEPER_PERSONA p ON u.XEPER_ID = p.XEPER_ID ")
           .append("LEFT JOIN XEUXP_USUPE up ON u.XEUSU_ID_USUARIO = up.XEUSU_ID_USUARIO AND up.XEUXP_FECRET IS NULL ")
           .append("WHERE 1=1 ");

        // Filtro por nombre
        if (nombre != null && !nombre.trim().isEmpty()) {
            sql.append("AND (p.XEPER_NOMBRES LIKE ? OR p.XEPER_APELLIDOS LIKE ? OR u.XEUSU_USERNAME LIKE ?) ");
        }

        // Filtro por rol
        if (rol != null && !rol.trim().isEmpty()) {
            sql.append("AND up.XEPER_CODIGO = ? ");
        }

        // Filtro por estado
        if (estado != null && !estado.trim().isEmpty()) {
            sql.append("AND u.XEEST_CODIGO = ? ");
        }

        sql.append("ORDER BY p.XEPER_APELLIDOS, p.XEPER_NOMBRES");

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Asignar parámetros
            if (nombre != null && !nombre.trim().isEmpty()) {
                String patron = "%" + nombre.trim() + "%";
                ps.setString(paramIndex++, patron);
                ps.setString(paramIndex++, patron);
                ps.setString(paramIndex++, patron);
            }

            if (rol != null && !rol.trim().isEmpty()) {
                ps.setString(paramIndex++, rol);
            }

            if (estado != null && !estado.trim().isEmpty()) {
                ps.setString(paramIndex++, estado);
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                usuarios.add(mapearUsuario(rs));
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en buscarConFiltros: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }

        return usuarios;
    }

    // ========================================
    // VERIFICAR SI USERNAME EXISTE
    // ========================================
    
    public boolean existeUsername(String username, Integer excluyendoIdUsuario) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM XEUSU_USUAR WHERE XEUSU_USERNAME = ?";
        if (excluyendoIdUsuario != null) {
            sql += " AND XEUSU_ID_USUARIO != ?";
        }

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, username);
            if (excluyendoIdUsuario != null) {
                ps.setInt(2, excluyendoIdUsuario);
            }
            
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en existeUsername: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }

        return false;
    }

    // ========================================
    // MAPEAR RESULTSET A USUARIO
    // ========================================
    
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setUsuIdUsuario(rs.getInt("XEUSU_ID_USUARIO"));
        usuario.setXeperId(rs.getInt("XEPER_ID"));
        usuario.setUsername(rs.getString("XEUSU_USERNAME"));
        usuario.setPasswordHash(rs.getString("PASSWORDHASH"));
        usuario.setEmailUsuario(rs.getString("EMAIL_USUARIO"));
        usuario.setEstadoCodigo(rs.getString("XEEST_CODIGO"));
        usuario.setPempCodigo(rs.getString("PEEMP_CODIGO"));
        usuario.setNombreEmpleado(rs.getString("XEPER_NOMBRES"));
        usuario.setApellidoEmpleado(rs.getString("XEPER_APELLIDOS"));
        usuario.setCorreoEmpleado(rs.getString("XEPER_EMAIL"));
        usuario.setCedula(rs.getString("XEPER_CEDULA"));
        try {
            usuario.setFotoPath(rs.getString("FOTO_PATH"));
        } catch (SQLException e) {
            // la columna puede no venir en algunos SELECT
        }
        
        try {
            usuario.setEstadoEmpleado(rs.getString("PEEMP_ESTADOEMPLEADO"));
        } catch (SQLException e) {
            // La columna puede no existir en algunos queries
        }
        try {
            usuario.setPrimerIngreso(rs.getString("PRIMER_INGRESO"));
            usuario.setContrasenaTempora(rs.getString("CONTRASEÑA_TEMPORAL"));
        } catch (SQLException e) {
            // Campos de control de contraseña pueden no estar en algunos queries
        }
        try {
            String tipo = rs.getString("TIPO_USUARIO");
            String idAcad = rs.getString("ID_ACADEMICO");
            // Guardar siempre el ID académico genérico si existe
            if (idAcad != null && !idAcad.isEmpty()) {
                usuario.setIdAcademico(idAcad);
            }
            usuario.setTipoUsuario(tipo);
            if (tipo != null) {
                if ("ESTUDIANTE".equalsIgnoreCase(tipo)) {
                    usuario.setIdEstudiante(idAcad);
                } else if ("DOCENTE".equalsIgnoreCase(tipo)) {
                    usuario.setIdDocente(idAcad);
                }
                // Para otros tipos (ADMIN, SECRETARIO_ACADEMICO, etc.) también guardar el ID
                else if (idAcad != null && !idAcad.isEmpty()) {
                    usuario.setIdAcademico(idAcad);
                }
            }
        } catch (SQLException e) {
            // Tabla académica puede no estar unida en algunas consultas
        }
        
        return usuario;
    }

    // ========================================
    // ACTUALIZAR CONTRASEÑA
    // ========================================
    
    public boolean actualizarContrasena(int idUsuario, String nuevaContrasena) {
        Connection cn = null;
        PreparedStatement ps = null;
        
        String sql = "UPDATE XEUSU_USUAR SET PASSWORDHASH = ?, XEUSU_FECMOD = NOW() " +
                     "WHERE XEUSU_ID_USUARIO = ?";
        
        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, nuevaContrasena);
            ps.setInt(2, idUsuario);
            
            int resultado = ps.executeUpdate();
            
            if (resultado > 0) {
                System.out.println("✅ Contraseña actualizada para usuario ID: " + idUsuario);
                return true;
            } else {
                System.out.println("❌ Error al actualizar contraseña para usuario ID: " + idUsuario);
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en actualizarContrasena: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            cerrarRecursos(null, ps, cn);
        }
    }

    // ========================================
    // BUSCAR POR USUARIO O CORREO
    // ========================================
    
    public Usuario buscarPorUsuarioOCorreo(String usuarioOCorreo) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Usuario usuario = null;

        String sql = "SELECT u.XEUSU_ID_USUARIO, u.XEPER_ID, u.XEUSU_USERNAME, "
                + "u.PASSWORDHASH, u.EMAIL_USUARIO, u.XEEST_CODIGO, u.PEEMP_CODIGO, "
                + "p.XEPER_NOMBRES, p.XEPER_APELLIDOS, p.XEPER_EMAIL, p.XEPER_CEDULA "
                + "FROM XEUSU_USUAR u "
                + "INNER JOIN XEPER_PERSONA p ON u.XEPER_ID = p.XEPER_ID "
                + "WHERE (u.XEUSU_USERNAME = ? OR u.EMAIL_USUARIO = ?) AND u.XEEST_CODIGO = 'A'";

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setString(1, usuarioOCorreo);
            ps.setString(2, usuarioOCorreo);
            rs = ps.executeQuery();

            if (rs.next()) {
                usuario = mapearUsuario(rs);
                System.out.println("✅ Usuario encontrado: " + usuario.getUsername());
            } else {
                System.out.println("❌ Usuario no encontrado: " + usuarioOCorreo);
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en buscarPorUsuarioOCorreo: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }

        return usuario;
    }

    // ========================================
    // CERRAR RECURSOS
    // ========================================
    
    private void cerrarRecursos(ResultSet rs, PreparedStatement ps, Connection cn) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (cn != null) conexion.desconectar(cn);
        } catch (SQLException e) {
            System.out.println("❌ Error al cerrar recursos: " + e.getMessage());
        }
    }

    // ========================================
    // VER PERFIL - OBTENER DATOS COMPLETOS
    // ========================================
    
    public Usuario obtenerPerfilCompleto(int idUsuario) {
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Usuario usuario = null;

        String sql = "SELECT u.XEUSU_ID_USUARIO, u.XEPER_ID, u.XEUSU_USERNAME, "
            + "u.PASSWORDHASH, u.EMAIL_USUARIO, u.XEEST_CODIGO, u.PEEMP_CODIGO, u.FOTO_PATH, "
                + "p.XEPER_NOMBRES, p.XEPER_APELLIDOS, p.XEPER_EMAIL, p.XEPER_CEDULA, "
                + "p.XEPER_SEXO, p.XEPER_ESTADO_CIVIL, p.XEPER_FECHA_NAC, "
                + "p.XEPER_DIRECCION, p.XEPER_TELEFONO, p.XEPER_FECHA_REGISTRO "
                + "FROM XEUSU_USUAR u "
                + "INNER JOIN XEPER_PERSONA p ON u.XEPER_ID = p.XEPER_ID "
                + "WHERE u.XEUSU_ID_USUARIO = ? AND u.XEEST_CODIGO = 'A'";

        try {
            cn = conexion.conectar();
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                usuario = mapearUsuarioCompleto(rs);
                System.out.println("✅ Perfil completo obtenido: " + usuario.getUsername());
            } else {
                System.out.println("❌ Usuario no encontrado: " + idUsuario);
            }

        } catch (SQLException e) {
            System.out.println("❌ Error en obtenerPerfilCompleto: " + e.getMessage());
            e.printStackTrace();
        } finally {
            cerrarRecursos(rs, ps, cn);
        }

        return usuario;
    }

    // ========================================
    // MAPEO COMPLETO DE USUARIO CON DATOS PERSONALES
    // ========================================
    
    private Usuario mapearUsuarioCompleto(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setUsuIdUsuario(rs.getInt("XEUSU_ID_USUARIO"));
        usuario.setXeperId(rs.getInt("XEPER_ID"));
        usuario.setUsername(rs.getString("XEUSU_USERNAME"));
        usuario.setPasswordHash(rs.getString("PASSWORDHASH"));
        usuario.setEmailUsuario(rs.getString("EMAIL_USUARIO"));
        usuario.setEstadoCodigo(rs.getString("XEEST_CODIGO"));
        usuario.setPempCodigo(rs.getString("PEEMP_CODIGO"));
        usuario.setNombreEmpleado(rs.getString("XEPER_NOMBRES"));
        usuario.setApellidoEmpleado(rs.getString("XEPER_APELLIDOS"));
        usuario.setEmail(rs.getString("XEPER_EMAIL"));
        usuario.setCedula(rs.getString("XEPER_CEDULA"));
        usuario.setSexo(rs.getString("XEPER_SEXO"));
        usuario.setEstadoCivil(rs.getString("XEPER_ESTADO_CIVIL"));
        usuario.setFechaNac(rs.getDate("XEPER_FECHA_NAC"));
        usuario.setDireccion(rs.getString("XEPER_DIRECCION"));
        usuario.setTelefono(rs.getString("XEPER_TELEFONO"));
        usuario.setFechaRegistro(rs.getDate("XEPER_FECHA_REGISTRO"));
        try {
            usuario.setFotoPath(rs.getString("FOTO_PATH"));
        } catch (SQLException e) {
            // puede no estar en algunos SELECT
        }
        return usuario;
    }
}