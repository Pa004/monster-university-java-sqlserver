package ec.edu.monster.controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import ec.edu.monster.modelo.UsuarioDAO;
import ec.edu.monster.modelo.Usuario;
import ec.edu.monster.modelo.TokenRecuperacionDAO;
import ec.edu.monster.util.EmailService;
import ec.edu.monster.util.TemporaryPasswordUtil;
import ec.edu.monster.util.PasswordUtil;

/**
 * Servlet para manejar la recuperación de contraseña
 */
@WebServlet(name = "srvRecuperarContrasena", urlPatterns = {"/srvRecuperarContrasena"})
public class srvRecuperarContrasena extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    private TokenRecuperacionDAO tokenDAO;
    private EmailService emailService;
    
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
        tokenDAO = new TokenRecuperacionDAO();
        emailService = new EmailService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String usuarioOCorreo = request.getParameter("usuarioOCorreo");
        
        try {
            if (usuarioOCorreo == null || usuarioOCorreo.trim().isEmpty()) {
                request.setAttribute("error", "Por favor ingresa un usuario o correo");
                request.getRequestDispatcher("recuperarContrasena.jsp").forward(request, response);
                return;
            }
            
            // Buscar usuario por nombre de usuario o email
            Usuario usuario = usuarioDAO.buscarPorUsuarioOCorreo(usuarioOCorreo.trim());
            
            if (usuario == null) {
                // No revelar si el usuario existe o no (seguridad)
                request.setAttribute("mensaje", 
                    "Si existe una cuenta con ese usuario o correo, recibirás tu contraseña en breve.");
                request.setAttribute("tipoMensaje", "success");
                request.getRequestDispatcher("recuperarContrasena.jsp").forward(request, response);
                return;
            }
            
            // Obtener contraseña del usuario
            String contrasena = usuario.getPasswordHash();
            
            if (contrasena == null || contrasena.isEmpty()) {
                request.setAttribute("error", "No se puede recuperar la contraseña. Contacta al administrador.");
                request.getRequestDispatcher("recuperarContrasena.jsp").forward(request, response);
                return;
            }
            
            // Generar contraseña temporal nueva
            String contrasenaTemporar = TemporaryPasswordUtil.generarContrasenaTemporal();
            String contrasenaHash = PasswordUtil.hash(contrasenaTemporar);
            
            // Actualizar contraseña y marcar como temporal
            boolean actualizado = usuarioDAO.actualizarPassword(usuario.getUsuIdUsuario(), contrasenaHash);
            
            if (actualizado) {
                // Marcar como contraseña temporal
                usuarioDAO.marcarContrasenaComoDeTipo(usuario.getUsuIdUsuario(), 'S', 'S'); // PRIMER_INGRESO='S', CONTRASEÑA_TEMPORAL='S'
            }
            
            if (!actualizado) {
                request.setAttribute("error", "No se pudo actualizar la contraseña. Intenta más tarde.");
                request.getRequestDispatcher("recuperarContrasena.jsp").forward(request, response);
                return;
            }
            
            System.out.println("✅ Contraseña temporal generada para usuario: " + usuario.getUsername());
            
            // Construir nombre completo
            String nombreCompleto = ((usuario.getNombreEmpleado() == null ? "" : usuario.getNombreEmpleado()) + " " +
                                    (usuario.getApellidoEmpleado() == null ? "" : usuario.getApellidoEmpleado())).trim();
            
            // Enviar solo a correo personal (XEPER_EMAIL)
            String correoPersonal = usuario.getCorreoEmpleado();
            if (correoPersonal == null || correoPersonal.trim().isEmpty()) {
                request.setAttribute("error", "No hay correo personal registrado. Contacta al administrador.");
                request.getRequestDispatcher("recuperarContrasena.jsp").forward(request, response);
                return;
            }
            
            boolean emailEnviado = emailService.enviarContrasena(correoPersonal, nombreCompleto, usuario.getUsername(), contrasenaTemporar);
            
            if (emailEnviado) {
                System.out.println("✅ Contraseña temporal enviada a correo personal: " + correoPersonal);
                request.setAttribute("mensaje", 
                    "Se ha generado una contraseña temporal y se ha enviado a tu correo personal. Revisa tu bandeja de entrada (y spam).");
                request.setAttribute("tipoMensaje", "success");
            } else {
                System.out.println("❌ Error al enviar correo a: " + correoPersonal);
                request.setAttribute("error", "Error al enviar la contraseña temporal. Intenta más tarde.");
            }
            
            request.getRequestDispatcher("recuperarContrasena.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("❌ Error en srvRecuperarContrasena: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage());
            try {
                request.getRequestDispatcher("recuperarContrasena.jsp").forward(request, response);
            } catch (ServletException | IOException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
