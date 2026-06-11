package ec.edu.monster.controlador;

import ec.edu.monster.modelo.*;
import ec.edu.monster.util.EmailService;
import java.io.IOException;
import java.io.ByteArrayOutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet(name = "srvUsuario", urlPatterns = {"/srvUsuario"})
@MultipartConfig(maxFileSize = 2 * 1024 * 1024, fileSizeThreshold = 1024 * 1024)
public class srvUsuario extends HttpServlet {

    private UsuarioDAO usuarioDAO;
    private PersonaDAO personaDAO;
    private PerfilDAO perfilDAO;
    private UsuarioPerfilDAO usuarioPerfilDAO;
    private UsuarioAcademicoDAO usuarioAcademicoDAO;
    private static final String UPLOAD_DIR = System.getProperty("user.home") + File.separator + "monsteru" + File.separator + "uploads" + File.separator + "fotos";
    
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
        personaDAO = new PersonaDAO();
        perfilDAO = new PerfilDAO();
        usuarioPerfilDAO = new UsuarioPerfilDAO();
        usuarioAcademicoDAO = new UsuarioAcademicoDAO();
        System.out.println("✅ Servlet srvUsuario inicializado correctamente");
    }

    // =====================================
    // Utilidades para foto de perfil
    // =====================================
    private String guardarFotoPerfil(Part part) throws Exception {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        if (!part.getContentType().toLowerCase().startsWith("image/")) {
            throw new Exception("El archivo debe ser una imagen (jpg, png, webp)");
        }

        if (part.getSize() > 2 * 1024 * 1024) {
            throw new Exception("La imagen no debe superar los 2 MB");
        }

        String extension = obtenerExtension(part);
        String nombreArchivo = UUID.randomUUID().toString() + extension;

        Path directorio = Paths.get(UPLOAD_DIR);
        Files.createDirectories(directorio);

        Path destino = directorio.resolve(nombreArchivo);
        try (InputStream is = part.getInputStream()) {
            Files.copy(is, destino, StandardCopyOption.REPLACE_EXISTING);
        }

        // Guardamos ruta relativa para servirla después con un servlet/handler
        String relative = "uploads/fotos/" + nombreArchivo;
        System.out.println("📸 Foto guardada en: " + destino.toString());
        return relative;
    }

    private void eliminarFotoAnterior(String relativePath) {
        if (relativePath == null || relativePath.trim().isEmpty()) return;
        try {
            Path ruta = Paths.get(UPLOAD_DIR).resolve(Paths.get(relativePath).getFileName().toString());
            Files.deleteIfExists(ruta);
            System.out.println("🧹 Foto anterior eliminada: " + ruta.toString());
        } catch (Exception e) {
            System.out.println("⚠️ No se pudo eliminar la foto anterior: " + e.getMessage());
        }
    }

    private String obtenerExtension(Part part) {
        String submitted = part.getSubmittedFileName();
        if (submitted != null && submitted.contains(".")) {
            return submitted.substring(submitted.lastIndexOf('.')).toLowerCase();
        }
        // fallback por tipo MIME
        String mime = part.getContentType();
        if (mime != null) {
            if (mime.contains("png")) return ".png";
            if (mime.contains("webp")) return ".webp";
        }
        return ".jpg";
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String accion = request.getParameter("accion");
        
        System.out.println("🔍 Acción recibida: " + accion);
        
        if (accion == null || accion.trim().isEmpty()) {
            System.out.println("⚠️ Acción es null, redirigiendo a identificar.jsp");
            response.sendRedirect("identificar.jsp");
            return;
        }
        
        // Enrutamiento de acciones
        switch (accion) {
            case "verificar":
                verificarLogin(request, response);
                break;
            case "logout":
                cerrarSesion(request, response);
                break;
            case "listar":
                listarUsuarios(request, response);
                break;
            case "nuevo":
                mostrarFormularioNuevo(request, response);
                break;
            case "crear":
                crearUsuario(request, response);
                break;
            case "editar":
                mostrarFormularioEditar(request, response);
                break;
            case "actualizar":
                actualizarUsuario(request, response);
                break;
            case "eliminar":
                eliminarUsuario(request, response);
                break;
            case "cambiarEstado":
                cambiarEstado(request, response);
                break;
            case "buscar":
                buscarUsuarios(request, response);
                break;
            case "exportarCsv":
                exportarUsuariosCsv(response);
                break;
            case "exportarPdf":
                exportarUsuariosPdf(response);
                break;
            case "verPerfil":
                verPerfilUsuario(request, response);
                break;
            default:
                System.out.println("⚠️ Acción desconocida: " + accion);
                response.sendRedirect("identificar.jsp");
        }
    }
    
    // ========================================
    // AUTENTICACIÓN
    // ========================================
    
    private void verificarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("📝 Entrando a verificarLogin()");
        
        String username = request.getParameter("txtUsu");
        String password = request.getParameter("txtPass");
        
        System.out.println("👤 Usuario recibido: " + username);
        
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            System.out.println("❌ Campos vacíos detectados");
            request.setAttribute("mensaje", "Por favor ingrese usuario y contraseña");
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("identificar.jsp").forward(request, response);
            return;
        }
        
        try {
            Usuario usuario = usuarioDAO.validarUsuario(username, password);
            
            if (usuario != null) {
                System.out.println("✅ Usuario válido: " + usuario.getNombreCompleto());
                
                // Verificar si necesita cambiar contraseña (primer ingreso o temporal)
                String primerIngreso = usuario.getPrimerIngreso();
                String contrasenaTemporal = usuario.getContrasenaTempora();
                
                if (("S".equals(primerIngreso) || "S".equals(contrasenaTemporal))) {
                    System.out.println("⚠️ Usuario debe cambiar contraseña obligatoriamente");
                    HttpSession session = request.getSession(true);
                    session.setAttribute("usuario", usuario);
                    session.setAttribute("username", usuario.getUsername());
                    session.setAttribute("nombreCompleto", usuario.getNombreCompleto());
                    session.setAttribute("email", usuario.getEmailUsuario());
                    session.setAttribute("idUsuario", usuario.getUsuIdUsuario());
                    // Bandera de cambio obligatorio (compatibilidad con distintos nombres)
                    session.setAttribute("cambioOblgatorio", true);
                    session.setAttribute("requiresPasswordChange", true);
                    
                    response.sendRedirect("cambiarContrasenaPrincipal.jsp");
                    return;
                }
                
                HttpSession session = request.getSession(true);
                session.setAttribute("usuario", usuario);
                session.setAttribute("username", usuario.getUsername());
                session.setAttribute("nombreCompleto", usuario.getNombreCompleto());
                session.setAttribute("email", usuario.getEmailUsuario());
                session.setAttribute("codigoEmpleado", usuario.getPempCodigo());
                session.setAttribute("idUsuario", usuario.getUsuIdUsuario());
                session.setAttribute("fotoPath", usuario.getFotoPath());
                
                System.out.println("✅ Sesión creada, redirigiendo a index.jsp");
                response.sendRedirect("index.jsp");
                
            } else {
                System.out.println("❌ Usuario o contraseña incorrectos");
                request.setAttribute("mensaje", "Usuario o contraseña incorrectos");
                request.setAttribute("tipoMensaje", "error");
                request.setAttribute("username", username);
                request.getRequestDispatcher("identificar.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("💥 ERROR en verificarLogin: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensaje", "Error del sistema: " + e.getMessage());
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("identificar.jsp").forward(request, response);
        }
    }
    
    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("👋 Cerrando sesión del usuario");
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
            System.out.println("✅ Sesión cerrada correctamente");
        }
        response.sendRedirect("identificar.jsp");
    }

    // ========================================
    // LISTAR USUARIOS
    // ========================================
    
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Usuario> usuarios = usuarioDAO.listarTodos();
            List<Perfil> perfiles = perfilDAO.listarTodos();
            
            request.setAttribute("usuarios", usuarios);
            request.setAttribute("perfiles", perfiles);
            
            System.out.println("✅ Listando " + usuarios.size() + " usuarios");
            request.getRequestDispatcher("gestionUsuarios.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("❌ Error en listarUsuarios: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al listar usuarios: " + e.getMessage());
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    // ========================================
    // MOSTRAR FORMULARIO NUEVO USUARIO
    // ========================================
    
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Perfil> perfiles = perfilDAO.listarTodos();
            
            request.setAttribute("perfiles", perfiles);
            request.setAttribute("accion", "crear");
            
            System.out.println("✅ Mostrando formulario para crear nuevo usuario");
            request.getRequestDispatcher("formUsuario.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("❌ Error en mostrarFormularioNuevo: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al cargar el formulario: " + e.getMessage());
            request.setAttribute("tipoMensaje", "error");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

// ========================================
// CREAR USUARIO - VERSIÓN CON DEBUG MEJORADO
// ========================================
// Copiar este método dentro de srvUsuario.java

private void crearUsuario(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    System.out.println("========================================");
    System.out.println("🔵 INICIANDO CREACIÓN DE USUARIO");
    System.out.println("========================================");
    
    try {
        // ====================================
        // 1. CAPTURAR Y VALIDAR PARÁMETROS
        // ====================================
        System.out.println("📥 Capturando parámetros del formulario...");
        
        // Datos de usuario
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String emailUsuario = request.getParameter("emailUsuario");
        
        // Datos personales
        String cedula = request.getParameter("cedula");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String fechaNacStr = request.getParameter("fechaNac");
        String sexo = request.getParameter("sexo");
        String estadoCivil = request.getParameter("estadoCivil");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        
        // Perfiles
        String[] perfilesSeleccionados = request.getParameterValues("perfiles");

        // Foto de perfil
        Part fotoPart = null;
        try {
            fotoPart = request.getPart("fotoPerfil");
        } catch (IllegalStateException ex) {
            throw new Exception("La foto excede el tamaño máximo permitido (2MB)");
        }
        
        // ====================================
        // 2. IMPRIMIR VALORES RECIBIDOS
        // ====================================
        System.out.println("📋 Datos de Usuario:");
        System.out.println("   - Username: " + username);
        System.out.println("   - Password: " + (password != null ? "***" : "NULL"));
        System.out.println("   - Email Usuario: " + emailUsuario);
        
        System.out.println("📋 Datos Personales:");
        System.out.println("   - Cédula: " + cedula);
        System.out.println("   - Nombres: " + nombres);
        System.out.println("   - Apellidos: " + apellidos);
        System.out.println("   - Fecha Nac: " + fechaNacStr);
        System.out.println("   - Sexo: " + sexo);
        System.out.println("   - Estado Civil: " + estadoCivil);
        System.out.println("   - Dirección: " + direccion);
        System.out.println("   - Teléfono: " + telefono);
        System.out.println("   - Email Personal: " + email);
        
        System.out.println("📋 Perfiles:");
        if (perfilesSeleccionados != null) {
            for (String perfil : perfilesSeleccionados) {
                System.out.println("   - " + perfil);
            }
        } else {
            System.out.println("   - NINGUNO");
        }
        
        // ====================================
        // 3. VALIDAR DATOS OBLIGATORIOS
        // ====================================
        System.out.println("\n✔ Validando datos obligatorios...");
        
        if (username == null || username.trim().isEmpty()) {
            throw new Exception("El username es obligatorio");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new Exception("La contraseña es obligatoria");
        }
        if (cedula == null || cedula.trim().isEmpty()) {
            throw new Exception("La cédula es obligatoria");
        }
        if (nombres == null || nombres.trim().isEmpty()) {
            throw new Exception("Los nombres son obligatorios");
        }
        if (apellidos == null || apellidos.trim().isEmpty()) {
            throw new Exception("Los apellidos son obligatorios");
        }
        if (fechaNacStr == null || fechaNacStr.trim().isEmpty()) {
            throw new Exception("La fecha de nacimiento es obligatoria");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new Exception("El email personal es obligatorio");
        }
        if (sexo == null || sexo.trim().isEmpty()) {
            throw new Exception("El sexo es obligatorio");
        }
        if (estadoCivil == null || estadoCivil.trim().isEmpty()) {
            throw new Exception("El estado civil es obligatorio");
        }
        
        System.out.println("✅ Todos los campos obligatorios están presentes");
        
        // ====================================
        // 3.5. VALIDAR PERFILES (Estudiante es exclusivo)
        // ====================================
        if (perfilesSeleccionados != null && perfilesSeleccionados.length > 0) {
            List<String> listaPerfilesTemp = new ArrayList<>();
            boolean tieneEstudiante = false;
            boolean tieneOtros = false;
            
            for (String perfil : perfilesSeleccionados) {
                String perfilUpper = perfil.toUpperCase();
                if (perfilUpper.contains("ESTUD")) {
                    tieneEstudiante = true;
                } else {
                    tieneOtros = true;
                }
                listaPerfilesTemp.add(perfil);
            }
            
            // Validar: Si es Estudiante, no puede tener otros perfiles
            if (tieneEstudiante && tieneOtros) {
                System.out.println("❌ Error: Estudiante no puede tener otros perfiles");
                throw new Exception("El perfil de Estudiante no puede combinarse con otros perfiles");
            }
            
            System.out.println("✅ Validación de perfiles correcta");
        }
        
        // ====================================
        // 3.6. DETECTAR TIPO DE USUARIO Y GENERAR ID ACADÉMICO
        // ====================================
        System.out.println("\n🎓 Detectando tipo de usuario académico...");
        String tipoUsuario = usuarioAcademicoDAO.detectarTipoUsuario(perfilesSeleccionados);
        String idAcademico = null;
        String fotoPath = null;
        
        if (tipoUsuario != null) {
            System.out.println("✅ Tipo detectado: " + tipoUsuario);
            System.out.println("🔢 Generando ID académico automático...");
            idAcademico = usuarioAcademicoDAO.generarIdAcademico(tipoUsuario);
            
            if (idAcademico == null) {
                throw new Exception("Error al generar el ID académico");
            }
            System.out.println("✅ ID Académico generado: " + idAcademico);
        } else {
            System.out.println("ℹ️ No se detectó tipo académico (no requiere ID)");
        }

        // ====================================
        // 3.7. Guardar foto de perfil (opcional)
        // ====================================
        if (fotoPart != null && fotoPart.getSize() > 0) {
            System.out.println("📸 Procesando foto de perfil...");
            fotoPath = guardarFotoPerfil(fotoPart);
        }
        
        // ====================================
        // 4. VALIDAR USERNAME ÚNICO
        // ====================================
        System.out.println("\n🔍 Verificando username único...");
        if (usuarioDAO.existeUsername(username, null)) {
            System.out.println("❌ El username ya existe: " + username);
            request.setAttribute("mensaje", "El nombre de usuario ya existe");
            request.setAttribute("tipoMensaje", "error");
            List<Perfil> perfiles = perfilDAO.listarTodos();
            request.setAttribute("perfiles", perfiles);
            request.setAttribute("accion", "crear");
            request.getRequestDispatcher("formUsuario.jsp").forward(request, response);
            return;
        }
        System.out.println("✅ Username disponible");
        
        // ====================================
        // 5. CREAR OBJETO PERSONA
        // ====================================
        System.out.println("\n👤 Creando objeto Persona...");
        Persona persona = new Persona();
        persona.setEstadoCivilCodigo(estadoCivil);
        persona.setSexoCodigo(sexo);
        persona.setCedula(cedula);
        persona.setNombres(nombres);
        persona.setApellidos(apellidos);
        
        // Convertir fecha
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            persona.setFechaNac(sdf.parse(fechaNacStr));
            System.out.println("   ✅ Fecha parseada correctamente: " + fechaNacStr);
        } catch (ParseException e) {
            System.out.println("   ❌ Error al parsear fecha: " + e.getMessage());
            throw new Exception("Formato de fecha inválido. Use: YYYY-MM-DD");
        }
        
        persona.setDireccion(direccion);
        persona.setTelefono(telefono);
        persona.setEmail(email);
        persona.setFechaRegistro(new Date());
        persona.setTipoPersona("U"); // U = Usuario del sistema
        
        System.out.println("✅ Objeto Persona creado");
        
        // ====================================
        // 6. REGISTRAR PERSONA EN BD
        // ====================================
        System.out.println("\n💾 Insertando persona en BD...");
        int idPersona = personaDAO.registrarPersona(persona);
        
        if (idPersona <= 0) {
            System.out.println("❌ Error: No se pudo registrar la persona (ID retornado: " + idPersona + ")");
            throw new Exception("Error al registrar la persona en la base de datos");
        }
        System.out.println("✅ Persona registrada con ID: " + idPersona);
        
        // ====================================
        // 7. CREAR OBJETO USUARIO
        // ====================================
        System.out.println("\n🔑 Creando objeto Usuario...");
        Usuario usuario = new Usuario();
        usuario.setXeperId(idPersona);
        usuario.setUsername(username);
        // Hash de contraseña antes de guardar
        usuario.setPasswordHash(ec.edu.monster.util.PasswordUtil.hash(password));
        usuario.setEmailUsuario(emailUsuario != null ? emailUsuario : email);
        usuario.setEstadoCodigo("A"); // Activo por defecto
        usuario.setPempCodigo(null); // Se asigna cuando se crea registro en PEEMP_EMPLE
        usuario.setFotoPath(fotoPath);

        // Set académico
        if (tipoUsuario != null && !tipoUsuario.trim().isEmpty()) {
            usuario.setTipoUsuario(tipoUsuario);
            if (tipoUsuario.equalsIgnoreCase("ESTUDIANTE")) {
                usuario.setIdEstudiante(idAcademico);
            } else if (tipoUsuario.equalsIgnoreCase("DOCENTE")) {
                usuario.setIdDocente(idAcademico);
            }
        }
        
        System.out.println("✅ Objeto Usuario creado");
        
        // ====================================
        // 8. REGISTRAR USUARIO EN BD
        // ====================================
        System.out.println("\n💾 Insertando usuario en BD...");
        int idUsuario = usuarioDAO.crearUsuario(usuario);
        
        if (idUsuario <= 0) {
            System.out.println("❌ Error: No se pudo crear el usuario (ID retornado: " + idUsuario + ")");
            throw new Exception("Error al crear el usuario en la base de datos");
        }
        System.out.println("✅ Usuario creado con ID: " + idUsuario);

        // 8.1 Guardar datos académicos si aplica
        if (tipoUsuario != null && !tipoUsuario.trim().isEmpty()) {
            boolean okAcad = usuarioAcademicoDAO.guardar(idUsuario, tipoUsuario, idAcademico);
            System.out.println(okAcad ? "✅ Datos académicos guardados" : "⚠️ No se guardaron datos académicos");
        }
        
        // ====================================
        // 9. ASIGNAR PERFILES
        // ====================================
        System.out.println("\n🛡 Asignando perfiles...");
        if (perfilesSeleccionados != null && perfilesSeleccionados.length > 0) {
            List<String> listaPerfiles = new ArrayList<>();
            for (String perfil : perfilesSeleccionados) {
                listaPerfiles.add(perfil);
                System.out.println("   - Agregando perfil: " + perfil);
            }
            
            boolean perfilesAsignados = usuarioPerfilDAO.asignarPerfiles(idUsuario, listaPerfiles);
            if (perfilesAsignados) {
                System.out.println("✅ Perfiles asignados correctamente");
            } else {
                System.out.println("⚠️ Advertencia: No se pudieron asignar los perfiles");
            }
        } else {
            System.out.println("⚠️ No se seleccionaron perfiles");
        }
        
        // ====================================
        // 10. ENVIAR CREDENCIALES POR EMAIL
        // ====================================
        System.out.println("\n📧 Enviando credenciales al correo...");
        EmailService emailService = new EmailService();
        String nombreCompleto = nombres + " " + apellidos;
        boolean emailEnviado = emailService.enviarCredenciales(email, nombreCompleto, username, password);
        
        if (emailEnviado) {
            System.out.println("✅ Credenciales enviadas a: " + email);
        } else {
            System.out.println("⚠️ Advertencia: No se pudieron enviar las credenciales al correo");
        }
        
        // ====================================
        // 11. ÉXITO - REDIRECCIONAR
        // ====================================
        System.out.println("\n✅ ¡USUARIO CREADO EXITOSAMENTE!");
        System.out.println("   Username: " + username);
        System.out.println("   ID Usuario: " + idUsuario);
        System.out.println("   ID Persona: " + idPersona);
        System.out.println("========================================\n");
        
        response.sendRedirect("srvUsuario?accion=listar&mensaje=Usuario creado exitosamente y credenciales enviadas al correo&tipo=success");
        
    } catch (ParseException e) {
        System.out.println("\n❌ ERROR DE FORMATO DE FECHA");
        System.out.println("   Mensaje: " + e.getMessage());
        System.out.println("========================================\n");
        e.printStackTrace();
        
        request.setAttribute("mensaje", "Error en el formato de fecha");
        request.setAttribute("tipoMensaje", "error");
        request.setAttribute("accion", "crear");
        List<Perfil> perfiles = perfilDAO.listarTodos();
        request.setAttribute("perfiles", perfiles);
        request.getRequestDispatcher("formUsuario.jsp").forward(request, response);
        
    } catch (Exception e) {
        System.out.println("\n❌ ERROR GENERAL EN CREACIÓN DE USUARIO");
        System.out.println("   Mensaje: " + e.getMessage());
        System.out.println("========================================\n");
        e.printStackTrace();
        
        request.setAttribute("mensaje", "Error al crear usuario: " + e.getMessage());
        request.setAttribute("tipoMensaje", "error");
        request.setAttribute("accion", "crear");
        List<Perfil> perfiles = perfilDAO.listarTodos();
        request.setAttribute("perfiles", perfiles);
        request.getRequestDispatcher("formUsuario.jsp").forward(request, response);
    }
}

    // ========================================
    // MOSTRAR FORMULARIO EDITAR
    // ========================================
    
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int idUsuario = Integer.parseInt(request.getParameter("id"));
            
            Usuario usuario = usuarioDAO.obtenerPorId(idUsuario);
            Persona persona = personaDAO.obtenerPorId(usuario.getXeperId());
            List<Perfil> perfiles = perfilDAO.listarTodos();
            List<String> perfilesActivos = usuarioPerfilDAO.obtenerCodigosPerfilesActivos(idUsuario);
            
            request.setAttribute("usuario", usuario);
            request.setAttribute("persona", persona);
            request.setAttribute("perfiles", perfiles);
            request.setAttribute("perfilesActivos", perfilesActivos);
            request.setAttribute("accion", "actualizar");
            
            System.out.println("✅ Mostrando formulario editar usuario ID: " + idUsuario);
            request.getRequestDispatcher("formUsuario.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("❌ Error en mostrarFormularioEditar: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("srvUsuario?accion=listar&mensaje=Error al cargar usuario&tipo=error");
        }
    }

    // ========================================
    // ACTUALIZAR USUARIO
    // ========================================
    
    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            Part fotoPart = null;
            try {
                fotoPart = request.getPart("fotoPerfil");
            } catch (IllegalStateException ex) {
                throw new Exception("La foto excede el tamaño máximo permitido (2MB)");
            }
            
            // Validar username único (excluyendo el usuario actual)
            String username = request.getParameter("username");
            if (usuarioDAO.existeUsername(username, idUsuario)) {
                request.setAttribute("mensaje", "El nombre de usuario ya existe");
                request.setAttribute("tipoMensaje", "error");
                response.sendRedirect("srvUsuario?accion=editar&id=" + idUsuario + "&error=username");
                return;
            }
            
            // Obtener usuario y persona existentes
            Usuario usuario = usuarioDAO.obtenerPorId(idUsuario);
            Persona persona = personaDAO.obtenerPorId(usuario.getXeperId());
            
            // Actualizar datos personales
            persona.setNombres(request.getParameter("nombres"));
            persona.setApellidos(request.getParameter("apellidos"));
            persona.setCedula(request.getParameter("cedula"));
            persona.setEmail(request.getParameter("email"));
            persona.setTelefono(request.getParameter("telefono"));
            persona.setDireccion(request.getParameter("direccion"));
            
            System.out.println("📝 Actualizando datos personales de persona ID: " + persona.getId());
            boolean personaActualizada = personaDAO.actualizarPersona(persona);
            
            if (!personaActualizada) {
                System.out.println("⚠️ Advertencia: No se actualizaron los datos personales");
            } else {
                System.out.println("✅ Datos personales actualizados correctamente");
            }
            
            // Actualizar datos del usuario
            usuario.setUsername(username);
            
            // Solo actualizar password si se proporcionó uno nuevo
            String password = request.getParameter("password");
            if (password != null && !password.trim().isEmpty()) {
                usuario.setPasswordHash(ec.edu.monster.util.PasswordUtil.hash(password));
            }
            
            usuario.setEmailUsuario(request.getParameter("emailUsuario"));
            usuario.setEstadoCodigo(request.getParameter("estado"));
            usuario.setPempCodigo(request.getParameter("pempCodigo"));

            // Foto: si se sube una nueva, guardar y eliminar la anterior
            if (fotoPart != null && fotoPart.getSize() > 0) {
                String nuevaFoto = guardarFotoPerfil(fotoPart);
                eliminarFotoAnterior(usuario.getFotoPath());
                usuario.setFotoPath(nuevaFoto);
            }
            
            boolean actualizado = usuarioDAO.actualizarUsuario(usuario);
            
            if (!actualizado) {
                throw new Exception("Error al actualizar el usuario");
            }
            
            // Actualizar perfiles
            String[] perfilesSeleccionados = request.getParameterValues("perfiles");
            List<String> listaPerfiles = new ArrayList<>();
            if (perfilesSeleccionados != null) {
                boolean tieneEstudiante = false;
                boolean tieneOtros = false;
                
                for (String perfil : perfilesSeleccionados) {
                    String perfilUpper = perfil.toUpperCase();
                    if (perfilUpper.contains("ESTUD")) {
                        tieneEstudiante = true;
                    } else {
                        tieneOtros = true;
                    }
                    listaPerfiles.add(perfil);
                }
                
                // Validar: Si es Estudiante, no puede tener otros perfiles
                if (tieneEstudiante && tieneOtros) {
                    System.out.println("❌ Error: Estudiante no puede tener otros perfiles");
                    throw new Exception("El perfil de Estudiante no puede combinarse con otros perfiles");
                }
            }
            usuarioPerfilDAO.asignarPerfiles(idUsuario, listaPerfiles);

            // Actualizar datos académicos según perfiles seleccionados
            String tipoDetectado = null;
            if (!listaPerfiles.isEmpty()) {
                tipoDetectado = usuarioAcademicoDAO.detectarTipoUsuario(listaPerfiles.toArray(new String[0]));
            }

            String[] acadActual = usuarioAcademicoDAO.obtenerTipoEIdPorUsuario(idUsuario);
            String tipoActual = (acadActual != null) ? acadActual[0] : null;
            String idAcadActual = (acadActual != null) ? acadActual[1] : null;

            if (tipoDetectado != null) {
                String idAcadNuevo;
                // Generar nuevo ID solo si cambió el tipo o no existía
                if (tipoActual == null || !tipoActual.equalsIgnoreCase(tipoDetectado) || idAcadActual == null || idAcadActual.trim().isEmpty()) {
                    idAcadNuevo = usuarioAcademicoDAO.generarIdAcademico(tipoDetectado);
                } else {
                    idAcadNuevo = idAcadActual;
                }

                if (idAcadNuevo == null || idAcadNuevo.trim().isEmpty()) {
                    throw new Exception("Error al generar el ID académico");
                }

                // Persistir/actualizar registro académico
                usuarioAcademicoDAO.guardar(idUsuario, tipoDetectado, idAcadNuevo);
            }
            
            System.out.println("✅ Usuario actualizado exitosamente: " + username);
            response.sendRedirect("srvUsuario?accion=listar&mensaje=Usuario actualizado exitosamente&tipo=success");
            
        } catch (Exception e) {
            System.out.println("❌ Error en actualizarUsuario: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("srvUsuario?accion=listar&mensaje=Error al actualizar usuario&tipo=error");
        }
    }

    // ========================================
    // ELIMINAR USUARIO
    // ========================================
    
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int idUsuario = Integer.parseInt(request.getParameter("id"));
            
            System.out.println("🗑️ Intentando eliminar (inactivar) usuario ID: " + idUsuario);
            
            boolean eliminado = usuarioDAO.eliminarUsuario(idUsuario);
            
            if (eliminado) {
                System.out.println("✅ Usuario eliminado (inactivado) exitosamente ID: " + idUsuario);
                response.sendRedirect("srvUsuario?accion=listar&mensaje=Usuario eliminado exitosamente&tipo=success");
            } else {
                System.out.println("❌ No se pudo eliminar el usuario ID: " + idUsuario);
                throw new Exception("No se pudo eliminar el usuario");
            }
            
        } catch (NumberFormatException e) {
            System.out.println("❌ Error: ID de usuario inválido - " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("srvUsuario?accion=listar&mensaje=ID de usuario inválido&tipo=error");
        } catch (Exception e) {
            System.out.println("❌ Error en eliminarUsuario: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("srvUsuario?accion=listar&mensaje=Error al eliminar usuario&tipo=error");
        }
    }

    // ========================================
    // CAMBIAR ESTADO
    // ========================================
    
    private void cambiarEstado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int idUsuario = Integer.parseInt(request.getParameter("id"));
            String nuevoEstado = request.getParameter("estado");
            
            boolean cambiado = usuarioDAO.cambiarEstado(idUsuario, nuevoEstado);
            
            if (cambiado) {
                String estadoTexto = "A".equals(nuevoEstado) ? "activado" : "inactivado";
                System.out.println("✅ Usuario " + estadoTexto + " exitosamente ID: " + idUsuario);
                response.sendRedirect("srvUsuario?accion=listar&mensaje=Estado cambiado exitosamente&tipo=success");
            } else {
                throw new Exception("No se pudo cambiar el estado");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error en cambiarEstado: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("srvUsuario?accion=listar&mensaje=Error al cambiar estado&tipo=error");
        }
    }

    // ========================================
    // BUSCAR USUARIOS
    // ========================================
    
    private void buscarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String nombre = request.getParameter("nombre");
            String rol = request.getParameter("rol");
            String estado = request.getParameter("estado");
            
            List<Usuario> usuarios = usuarioDAO.buscarConFiltros(nombre, rol, estado);
            List<Perfil> perfiles = perfilDAO.listarTodos();
            
            request.setAttribute("usuarios", usuarios);
            request.setAttribute("perfiles", perfiles);
            request.setAttribute("nombreBusqueda", nombre);
            request.setAttribute("rolBusqueda", rol);
            request.setAttribute("estadoBusqueda", estado);
            
            System.out.println("✅ Búsqueda completada: " + usuarios.size() + " resultados");
            request.getRequestDispatcher("gestionUsuarios.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("❌ Error en buscarUsuarios: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("srvUsuario?accion=listar&mensaje=Error en la búsqueda&tipo=error");
        }
    }

    // ========================================
    // EXPORTAR USUARIOS - CSV / PDF
    // ========================================

    private void exportarUsuariosCsv(HttpServletResponse response) throws IOException {
        try {
            List<Usuario> usuarios = usuarioDAO.listarTodos();
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=usuarios.csv");

            String encabezado = "ID,Username,Nombre Completo,Email,Tipo,Estado,ID Academico\n";
            response.getWriter().write(encabezado);

            for (Usuario u : usuarios) {
                String tipo = determinarTipoUsuario(u);
                String estado = "A".equalsIgnoreCase(u.getEstadoCodigo()) ? "Activo" : "Inactivo";
                String linea = String.join(",",
                        safeCsv(String.valueOf(u.getUsuIdUsuario())),
                        safeCsv(u.getUsername()),
                        safeCsv(u.getNombreCompleto()),
                        safeCsv(u.getEmailUsuario()),
                        safeCsv(tipo),
                        safeCsv(estado),
                        safeCsv(u.getIdAcademico())
                );
                response.getWriter().write(linea + "\n");
            }

            response.getWriter().flush();
        } catch (Exception e) {
            System.out.println("❌ Error al exportar CSV: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo generar el CSV");
        }
    }

    private void exportarUsuariosPdf(HttpServletResponse response) throws IOException {
        try {
            List<Usuario> usuarios = usuarioDAO.listarTodos();
            
            // Usando StringBuilder para construir HTML que se convierte a PDF
            StringBuilder html = new StringBuilder();
            html.append("<!DOCTYPE html><html><head>");
            html.append("<meta charset='UTF-8'>");
            html.append("<style>");
            html.append("body { font-family: Arial, sans-serif; margin: 20px; }");
            html.append("h1 { color: #333; text-align: center; }");
            html.append(".fecha { text-align: center; color: #666; font-size: 12px; margin-bottom: 20px; }");
            html.append("table { width: 100%; border-collapse: collapse; margin-top: 20px; }");
            html.append("th { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 12px; text-align: left; font-weight: bold; }");
            html.append("td { border: 1px solid #ddd; padding: 10px; }");
            html.append("tr:nth-child(even) { background-color: #f9f9f9; }");
            html.append("tr:hover { background-color: #f0f0f0; }");
            html.append(".badge { padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; }");
            html.append(".badge-estudiante { background: #f39c12; color: white; }");
            html.append(".badge-docente { background: #605ca8; color: white; }");
            html.append(".badge-admin { background: #34495e; color: white; }");
            html.append(".badge-secretario { background: #00c0ef; color: white; }");
            html.append(".badge-activo { background: #27ae60; color: white; }");
            html.append(".badge-inactivo { background: #e74c3c; color: white; }");
            html.append(".resumen { margin-top: 30px; padding: 15px; background: #f5f5f5; border-left: 4px solid #667eea; }");
            html.append(".resumen p { margin: 5px 0; }");
            html.append("</style>");
            html.append("</head><body>");
            
            html.append("<h1>📊 Reporte de Usuarios y Estados</h1>");
            html.append("<div class='fecha'>Generado: ").append(new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date())).append("</div>");
            
            html.append("<table>");
            html.append("<thead><tr>");
            html.append("<th>ID</th>");
            html.append("<th>Usuario</th>");
            html.append("<th>Nombre Completo</th>");
            html.append("<th>Email</th>");
            html.append("<th>Tipo</th>");
            html.append("<th>Estado</th>");
            html.append("<th>ID Académico</th>");
            html.append("</tr></thead>");
            html.append("<tbody>");
            
            int contadorActivos = 0;
            int contadorInactivos = 0;
            
            for (Usuario u : usuarios) {
                String tipo = determinarTipoUsuario(u);
                String estado = "A".equalsIgnoreCase(u.getEstadoCodigo()) ? "Activo" : "Inactivo";
                String badgeTipo = tipo.toLowerCase().contains("estudiante") ? "badge-estudiante" : 
                                    tipo.toLowerCase().contains("docente") ? "badge-docente" : 
                                    tipo.toLowerCase().contains("admin") ? "badge-admin" : "badge-secretario";
                String badgeEstado = "Activo".equals(estado) ? "badge-activo" : "badge-inactivo";
                
                if ("Activo".equals(estado)) contadorActivos++;
                else contadorInactivos++;
                
                html.append("<tr>");
                html.append("<td>").append(u.getUsuIdUsuario()).append("</td>");
                html.append("<td><strong>").append(nullSafe(u.getUsername())).append("</strong></td>");
                html.append("<td>").append(nullSafe(u.getNombreCompleto())).append("</td>");
                html.append("<td>").append(nullSafe(u.getEmailUsuario())).append("</td>");
                html.append("<td><span class='badge ").append(badgeTipo).append("'>").append(tipo).append("</span></td>");
                html.append("<td><span class='badge ").append(badgeEstado).append("'>").append(estado).append("</span></td>");
                html.append("<td><code>").append(nullSafe(u.getIdAcademico())).append("</code></td>");
                html.append("</tr>");
            }
            
            html.append("</tbody>");
            html.append("</table>");
            
            html.append("<div class='resumen'>");
            html.append("<p><strong>📈 Resumen:</strong></p>");
            html.append("<p>✅ Usuarios Activos: ").append(contadorActivos).append("</p>");
            html.append("<p>❌ Usuarios Inactivos: ").append(contadorInactivos).append("</p>");
            html.append("<p>📊 Total: ").append(usuarios.size()).append("</p>");
            html.append("</div>");
            
            html.append("</body></html>");
            
            // Convertir HTML a PDF usando iText (necesita JAR descargado)
            generarPdfDesdeHtml(html.toString(), usuarios, response);
            
        } catch (Exception e) {
            System.out.println("❌ Error al exportar PDF: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo generar el PDF");
        }
    }

    private void generarPdfDesdeHtml(String html, List<Usuario> usuarios, HttpServletResponse response) throws IOException {
        try {
            // Intentar cargar HtmlConverter vía reflexión para evitar dependencia directa en compilación
            Class<?> converterClass = Class.forName("com.itextpdf.html2pdf.HtmlConverter");
            java.io.ByteArrayOutputStream pdfStream = new java.io.ByteArrayOutputStream();
            java.lang.reflect.Method convertMethod = converterClass.getMethod("convertToPdf", String.class, java.io.OutputStream.class);
            convertMethod.invoke(null, html, pdfStream);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=usuarios_reporte.pdf");
            response.setContentLength(pdfStream.size());
            pdfStream.writeTo(response.getOutputStream());

        } catch (ClassNotFoundException e) {
            // iText no está disponible, generar PDF con tabla profesional
            System.out.println("⚠️ iText no encontrado. Generando PDF con formato de tabla...");
            generarPdfConTabla(usuarios, response);
        } catch (Exception e) {
            // Cualquier otro error al invocar iText: usar fallback nativo
            System.out.println("❌ Error al generar PDF con iText: " + e.getMessage());
            generarPdfConTabla(usuarios, response);
        }
    }

    private void generarPdfConTabla(List<Usuario> usuarios, HttpServletResponse response) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=usuarios_reporte.pdf");
        
        java.io.ByteArrayOutputStream pdf = new java.io.ByteArrayOutputStream();
        
        // PDF 1.4 con soporte mejorado para tablas usando códigos PDF nativos
        pdf.write("%PDF-1.4\n".getBytes());
        
        // Object 1: Catálogo
        int pos1 = pdf.size();
        pdf.write("1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n".getBytes());
        
        // Object 2: Páginas
        int pos2 = pdf.size();
        pdf.write("2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n".getBytes());
        
        // Object 3: Página (orientación horizontal/landscape)
        int pos3 = pdf.size();
        pdf.write("3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 792 612] /Resources 4 0 R /Contents 5 0 R >>\nendobj\n".getBytes());
        
        // Object 4: Recursos (fuentes y colores)
        int pos4 = pdf.size();
        String resources = "4 0 obj\n<< /Font << /F1 << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> /FB << /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >> >> >>\nendobj\n";
        pdf.write(resources.getBytes());
        
        // Object 5: Contenido (tabla formateada con datos reales)
        int pos5 = pdf.size();
        String content = generarContenidoPdfTabla(usuarios);
        byte[] contentBytes = content.getBytes("UTF-8");
        String streamStart = "5 0 obj\n<< /Length " + contentBytes.length + " >>\nstream\n";
        pdf.write(streamStart.getBytes());
        pdf.write(contentBytes);
        pdf.write("\nendstream\nendobj\n".getBytes());
        
        // Cross-reference table
        java.util.List<Integer> xrefOffsets = java.util.Arrays.asList(pos1, pos2, pos3, pos4, pos5);
        int xrefPos = pdf.size();
        pdf.write(("xref\n0 " + (xrefOffsets.size() + 1) + "\n").getBytes());
        pdf.write("0000000000 65535 f \n".getBytes());
        for (int offset : xrefOffsets) {
            pdf.write(String.format("%010d 00000 n \n", offset).getBytes());
        }
        
        // Trailer
        pdf.write("trailer\n<< /Size 6 /Root 1 0 R >>\n".getBytes());
        pdf.write("startxref\n".getBytes());
        pdf.write(Integer.toString(xrefPos).getBytes());
        pdf.write("\n%%EOF".getBytes());
        
        response.setContentLength(pdf.size());
        pdf.writeTo(response.getOutputStream());
    }

    private String generarContenidoPdfTabla(List<Usuario> usuarios) {
        StringBuilder sb = new StringBuilder();

        // Título
        sb.append("BT\n/FB 20 Tf\n50 560 Td\n(Reporte de Usuarios y Estados) Tj\nET\n");

        // Fecha
        String fecha = "Generado: " + new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date());
        sb.append("BT\n/F1 9 Tf\n50 540 Td\n(").append(pdfEscape(fecha)).append(") Tj\nET\n");

        // Línea separadora
        sb.append("50 530 m\n740 530 l\nS\n");

        // Encabezados con más espacio
        sb.append("BT\n/FB 10 Tf\n");
        sb.append("50 515 Td\n(ID) Tj\n");
        sb.append("50 0 Td\n(Usuario) Tj\n");
        sb.append("120 0 Td\n(Nombre) Tj\n");
        sb.append("150 0 Td\n(Tipo) Tj\n");
        sb.append("130 0 Td\n(Estado) Tj\n");
        sb.append("80 0 Td\n(ID Acad) Tj\nET\n");

        // Línea separadora
        sb.append("50 505 m\n740 505 l\nS\n");

        // Filas
        int y = 490;
        int activos = 0;
        int inactivos = 0;

        for (Usuario u : usuarios) {
            if (y < 80) break; // evitar salir de página
            String tipo = determinarTipoUsuario(u);
            String estado = "A".equalsIgnoreCase(u.getEstadoCodigo()) ? "Activo" : "Inactivo";
            if ("Activo".equals(estado)) activos++; else inactivos++;

            String usuario = nullSafe(u.getUsername());
            String nombre = nullSafe(u.getNombreCompleto());
            String idAcad = nullSafe(u.getIdAcademico());

            // recortar para evitar desbordes con más espacio
            usuario = usuario.length() > 25 ? usuario.substring(0,25) : usuario;
            nombre = nombre.length() > 32 ? nombre.substring(0,32) : nombre;
            idAcad = idAcad.length() > 18 ? idAcad.substring(0,18) : idAcad;

            sb.append("BT\n/F1 8 Tf\n");
            sb.append("50 ").append(y).append(" Td\n(").append(u.getUsuIdUsuario()).append(") Tj\n");
            sb.append("50 0 Td\n(").append(pdfEscape(usuario)).append(") Tj\n");
            sb.append("120 0 Td\n(").append(pdfEscape(nombre)).append(") Tj\n");
            sb.append("150 0 Td\n(").append(pdfEscape(tipo)).append(") Tj\n");
            sb.append("130 0 Td\n(").append(pdfEscape(estado)).append(") Tj\n");
            sb.append("80 0 Td\n(").append(pdfEscape(idAcad)).append(") Tj\nET\n");

            y -= 14;
        }

        // Línea final
        sb.append("50 ").append(y).append(" m\n740 ").append(y).append(" l\nS\n");

        // Resumen
        int resumeY = y - 20;
        sb.append("BT\n/FB 11 Tf\n50 ").append(resumeY).append(" Td\n(Resumen) Tj\nET\n");
        sb.append("BT\n/F1 9 Tf\n50 ").append(resumeY - 16).append(" Td\n(Usuarios Activos: ").append(activos).append(") Tj\nET\n");
        sb.append("BT\n/F1 9 Tf\n50 ").append(resumeY - 30).append(" Td\n(Usuarios Inactivos: ").append(inactivos).append(") Tj\nET\n");
        sb.append("BT\n/F1 9 Tf\n50 ").append(resumeY - 44).append(" Td\n(Total: ").append(usuarios.size()).append(") Tj\nET\n");

        return sb.toString();
    }

    private String safeCsv(String val) {
        if (val == null) return "";
        String clean = val.replace("\"", "\"\"");
        if (clean.contains(",") || clean.contains("\n") || clean.contains("\r")) {
            return "\"" + clean + "\"";
        }
        return clean;
    }

    private String determinarTipoUsuario(Usuario u) {
        if (u.getTipoUsuario() != null && !u.getTipoUsuario().trim().isEmpty()) {
            return u.getTipoUsuario();
        }
        if (u.getIdEstudiante() != null && !u.getIdEstudiante().isEmpty()) return "ESTUDIANTE";
        if (u.getIdDocente() != null && !u.getIdDocente().isEmpty()) return "DOCENTE";
        return "USUARIO";
    }

    // Generador PDF minimalista (sin dependencias externas)

    private String pdfEscape(String text) {
        if (text == null) return "";
        // Escapar caracteres especiales en PDF
        text = text.replace("\\", "\\\\");
        text = text.replace("(", "\\(");
        text = text.replace(")", "\\)");
        text = text.replace("\n", " ");
        text = text.replace("\r", " ");
        text = text.replace("\t", " ");
        // Limitar solo a caracteres ASCII imprimibles
        return text.replaceAll("[^\\x20-\\x7E]", "?");
    }

    private String nullSafe(String s) {
        return s == null ? "" : s;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet de Gestión Completa de Usuarios";
    }

    // ========================================
    // VER PERFIL USUARIO
    // ========================================
    
    private void verPerfilUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int idUsuario = Integer.parseInt(request.getParameter("id"));
            
            Usuario usuario = usuarioDAO.obtenerPerfilCompleto(idUsuario);
            List<String> perfiles = usuarioPerfilDAO.obtenerCodigosPerfilesActivos(idUsuario);
            
            if (usuario != null) {
                request.setAttribute("usuario", usuario);
                request.setAttribute("perfiles", perfiles);
                System.out.println("✅ Perfil cargado: " + usuario.getUsername());
                request.getRequestDispatcher("verPerfil.jsp").forward(request, response);
            } else {
                System.out.println("❌ Usuario no encontrado");
                response.sendRedirect("srvUsuario?accion=listar&mensaje=Usuario no encontrado&tipo=error");
            }
            
        } catch (NumberFormatException e) {
            System.out.println("❌ ID inválido: " + e.getMessage());
            response.sendRedirect("srvUsuario?accion=listar&mensaje=ID inválido&tipo=error");
        } catch (Exception e) {
            System.out.println("❌ Error en verPerfilUsuario: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("srvUsuario?accion=listar&mensaje=Error al cargar perfil&tipo=error");
        }
    }
}
