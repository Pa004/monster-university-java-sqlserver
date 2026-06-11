package ec.edu.monster.controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import ec.edu.monster.modelo.UsuarioDAO;
import ec.edu.monster.modelo.TokenRecuperacionDAO;

/**
 * Servlet para procesar el cambio de contraseña con token
 */
@WebServlet(name = "srvCambiarContrasena", urlPatterns = {"/srvCambiarContrasena"})
public class srvCambiarContrasena extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;
    private TokenRecuperacionDAO tokenDAO;
    
    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
        tokenDAO = new TokenRecuperacionDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");

        // Preferir flujo obligatorio si viene la bandera de sesión o la acción coincide (sin ñ)
        Object requiresPasswordChangeObj = request.getSession().getAttribute("requiresPasswordChange");
        Object cambioObligatorioObj = request.getSession().getAttribute("cambioOblgatorio");
        boolean requiresPasswordChange = requiresPasswordChangeObj != null && (boolean) requiresPasswordChangeObj;
        boolean cambioObligatorio = cambioObligatorioObj != null && (boolean) cambioObligatorioObj;

        if (requiresPasswordChange || cambioObligatorio || (accion != null && accion.equals("cambiarContrasena"))) {
            procesarCambioObligatorio(request, response);
        } else {
            // Cambio con token (recuperación de contraseña)
            procesarCambioConToken(request, response);
        }
    }
    
    /**
     * Procesa el cambio obligatorio desde cambiarContrasenaPrincipal.jsp
     */
    private void procesarCambioObligatorio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nuevaContrasena = request.getParameter("nuevaContrasena");
        String confirmarContrasena = request.getParameter("confirmarContrasena");
        
        try {
            // Verificar que el usuario esté autenticado
            Object usuarioSesion = request.getSession().getAttribute("usuario");
            Object requiresPasswordChangeObj = request.getSession().getAttribute("requiresPasswordChange");
            
            boolean requiresPasswordChange = requiresPasswordChangeObj != null ? 
                                            (boolean) requiresPasswordChangeObj : false;
            
            if (usuarioSesion == null || !requiresPasswordChange) {
                response.sendRedirect("identificar.jsp");
                return;
            }
            
            // No se solicita contraseña actual por requerimiento
            
            if (nuevaContrasena == null || nuevaContrasena.trim().isEmpty()) {
                request.setAttribute("error", "La contraseña no puede estar vacía");
                request.getRequestDispatcher("cambiarContrasenaPrincipal.jsp").forward(request, response);
                return;
            }
            
            // Validar que las contraseñas coincidan
            if (!nuevaContrasena.equals(confirmarContrasena)) {
                request.setAttribute("error", "Las contraseñas no coinciden");
                request.getRequestDispatcher("cambiarContrasenaPrincipal.jsp").forward(request, response);
                return;
            }
            
            // Validar requisitos de contraseña
            if (!validarFortalezaContrasena(nuevaContrasena)) {
                request.setAttribute("error", "La contraseña no cumple los requisitos de seguridad (mín. 8 caracteres, mayúscula, minúscula, número y carácter especial)");
                request.getRequestDispatcher("cambiarContrasenaPrincipal.jsp").forward(request, response);
                return;
            }
            
            // Obtener el usuario de la sesión
            ec.edu.monster.modelo.Usuario usuario = (ec.edu.monster.modelo.Usuario) usuarioSesion;
            int idUsuario = usuario.getUsuIdUsuario();
            
            // No se verifica contraseña actual
            
            // Hash de la nueva contraseña
            String hashedPassword = ec.edu.monster.util.PasswordUtil.hash(nuevaContrasena);
            
            // Actualizar contraseña
            boolean actualizado = usuarioDAO.actualizarPassword(idUsuario, hashedPassword);
            
            if (!actualizado) {
                request.setAttribute("error", "Error al actualizar la contraseña. Intenta nuevamente.");
                request.getRequestDispatcher("cambiarContrasenaPrincipal.jsp").forward(request, response);
                return;
            }
            
            // Marcar contraseña como permanente (limpiar flags)
            usuarioDAO.marcarContrasenaActualizada(idUsuario);
            
            // Limpiar atributos de sesión
            request.getSession().removeAttribute("requiresPasswordChange");
            request.getSession().removeAttribute("cambioOblgatorio");
            
            // Redirigir al dashboard
            response.sendRedirect("index.jsp?mensaje=contrasena_actualizada");
            
        } catch (Exception e) {
            System.out.println("❌ Error en cambio obligatorio: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage());
            try {
                request.getRequestDispatcher("cambiarContrasenaPrincipal.jsp").forward(request, response);
            } catch (ServletException | IOException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    /**
     * Procesa el cambio con token (recuperación de contraseña)
     */
    private void procesarCambioConToken(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        String nuevaContrasena = request.getParameter("nuevaContrasena");
        String confirmarContrasena = request.getParameter("confirmarContrasena");
        
        try {
            // Validar parámetros
            if (token == null || token.trim().isEmpty()) {
                request.setAttribute("error", "Token inválido o no proporcionado");
                request.getRequestDispatcher("cambiarContrasena.jsp?token=" + token).forward(request, response);
                return;
            }
            
            if (nuevaContrasena == null || nuevaContrasena.trim().isEmpty()) {
                request.setAttribute("error", "La contraseña no puede estar vacía");
                request.getRequestDispatcher("cambiarContrasena.jsp?token=" + token).forward(request, response);
                return;
            }
            
            // Validar que las contraseñas coincidan
            if (!nuevaContrasena.equals(confirmarContrasena)) {
                request.setAttribute("error", "Las contraseñas no coinciden");
                request.getRequestDispatcher("cambiarContrasena.jsp?token=" + token).forward(request, response);
                return;
            }
            
            // Validar requisitos de contraseña
            if (!validarFortalezaContrasena(nuevaContrasena)) {
                request.setAttribute("error", "La contraseña no cumple los requisitos de seguridad");
                request.getRequestDispatcher("cambiarContrasena.jsp?token=" + token).forward(request, response);
                return;
            }
            
            // Validar token
            int idUsuario = tokenDAO.validarToken(token);
            
            if (idUsuario == -1) {
                request.setAttribute("error", "El token es inválido o ha expirado. Solicita un nuevo enlace de recuperación.");
                request.getRequestDispatcher("recuperarContrasena.jsp").forward(request, response);
                return;
            }
            
            // Actualizar contraseña del usuario
            String hashedPassword = ec.edu.monster.util.PasswordUtil.hash(nuevaContrasena);
            boolean actualizado = usuarioDAO.actualizarPassword(idUsuario, hashedPassword);
            
            if (!actualizado) {
                request.setAttribute("error", "Error al actualizar la contraseña. Intenta nuevamente.");
                request.getRequestDispatcher("cambiarContrasena.jsp?token=" + token).forward(request, response);
                return;
            }
            
            // Marcar token como usado
            tokenDAO.marcarTokenComoUsado(token);
            
            // Limpiar tokens expirados
            tokenDAO.limpiarTokensExpirados();
            
            // Redirigir al login con mensaje de éxito
            response.sendRedirect("identificar.jsp?mensaje=Contrasena_actualizada");
            
        } catch (Exception e) {
            System.out.println("❌ Error en srvCambiarContrasena: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage());
            try {
                request.getRequestDispatcher("cambiarContrasena.jsp?token=" + token).forward(request, response);
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
    
    /**
     * Validar fortaleza de contraseña
     */
    private boolean validarFortalezaContrasena(String contrasena) {
        if (contrasena == null || contrasena.length() < 8) {
            return false;
        }
        
        boolean tieneUppercase = contrasena.matches(".*[A-Z].*");
        boolean tieneLowercase = contrasena.matches(".*[a-z].*");
        boolean tieneNumero = contrasena.matches(".*\\d.*");
        boolean tieneEspecial = contrasena.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*");
        
        return tieneUppercase && tieneLowercase && tieneNumero && tieneEspecial;
    }
}
