package ec.edu.monster.util;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Servicio para enviar correos electrónicos
 * Configura SMTP para enviar correos de recuperación de contraseña
 */
public class EmailService {
    
    // Configuración de SMTP (cambiar según tu proveedor)
    private static final String EMAIL_FROM = "juandiegoq21@gmail.com"; // Cambiar
    private static final String EMAIL_PASSWORD = "ajbq kwtv rddf aqax"; // Cambiar
    private static final String SMTP_HOST = "smtp.gmail.com"; // Para Gmail
    private static final String SMTP_PORT = "587";
    
    /**
     * Enviar contraseña al usuario
     * @param destinatario Correo del usuario
     * @param nombre Nombre del usuario
     * @param usuario Usuario del sistema
     * @param contrasena Contraseña a enviar
     * @return true si se envió exitosamente
     */
    public boolean enviarContrasena(String destinatario, String nombre, String usuario, String contrasena) {
        try {
            // Configurar propiedades SMTP
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.socketFactory.port", SMTP_PORT);
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            
            // Crear sesión
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });
            
            // Crear mensaje
            Message mensaje = new MimeMessage(session);
            mensaje.setFrom(new InternetAddress(EMAIL_FROM));
            mensaje.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            mensaje.setSubject("Tu Contraseña - Monster University");
            
            // HTML del correo
            String contenidoHTML = generarContenidoContrasena(nombre, usuario, contrasena);
            mensaje.setContent(contenidoHTML, "text/html; charset=utf-8");
            
            // Enviar
            Transport.send(mensaje);
            
            System.out.println("✅ Contraseña enviada a: " + destinatario);
            return true;
            
        } catch (MessagingException e) {
            System.out.println("❌ Error al enviar contraseña: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Generar contenido HTML del correo con contraseña
     */
    private String generarContenidoContrasena(String nombre, String usuario, String contrasena) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><meta charset='utf-8'></head>" +
               "<body style='font-family: Arial, sans-serif; background: #f4f4f4;'>" +
               "<div style='max-width: 600px; margin: 20px auto; background: white; padding: 40px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'>" +
               "  <div style='text-align: center; margin-bottom: 30px;'>" +
               "    <h1 style='color: #667eea; margin: 0; font-size: 28px;'>🔑 Tu Contraseña</h1>" +
               "  </div>" +
               "  <p style='color: #333; font-size: 16px;'>Hola <strong>" + nombre + "</strong>,</p>" +
               "  <p style='color: #666; line-height: 1.6;'>" +
               "    Aquí están tus datos para acceder al Sistema de Gestión Académica de Monster University:" +
               "  </p>" +
               "  <div style='background: #f9f9f9; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #667eea;'>" +
               "    <p style='margin: 0 0 10px 0; color: #666;'><strong>Usuario:</strong></p>" +
               "    <p style='margin: 0 0 15px 0; font-size: 16px; color: #667eea; font-family: monospace; word-break: break-all;'>" + usuario + "</p>" +
               "    <p style='margin: 0 0 10px 0; color: #666;'><strong>Contraseña:</strong></p>" +
               "    <p style='margin: 0; font-size: 16px; color: #667eea; font-family: monospace; word-break: break-all;'>" + contrasena + "</p>" +
               "  </div>" +
               "  <p style='color: #999; font-size: 12px;'>" +
               "    💡 <strong>Recomendación:</strong> Te sugerimos que cambies tu contraseña después de acceder al sistema." +
               "  </p>" +
               "  <hr style='border: none; border-top: 1px solid #e0e0e0; margin: 20px 0;'>" +
               "  <p style='color: #999; font-size: 12px;'>" +
               "    Si no solicitaste esta información, contacta inmediatamente con el administrador del sistema." +
               "  </p>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * Enviar correo de recuperación de contraseña
     * @param destinatario Correo del usuario
     * @param nombre Nombre del usuario
     * @param enlace Enlace para recuperar contraseña
     * @return true si se envió exitosamente
     */
    public boolean enviarCorreoRecuperacion(String destinatario, String nombre, String enlace) {
        try {
            // Configurar propiedades SMTP
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.socketFactory.port", SMTP_PORT);
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            
            // Crear sesión
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });
            
            // Crear mensaje
            Message mensaje = new MimeMessage(session);
            mensaje.setFrom(new InternetAddress(EMAIL_FROM));
            mensaje.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            mensaje.setSubject("Recupera tu contraseña - Monster University");
            
            // HTML del correo
            String contenidoHTML = generarContenidoRecuperacion(nombre, enlace);
            mensaje.setContent(contenidoHTML, "text/html; charset=utf-8");
            
            // Enviar
            Transport.send(mensaje);
            
            System.out.println("✅ Correo de recuperación enviado a: " + destinatario);
            return true;
            
        } catch (MessagingException e) {
            System.out.println("❌ Error al enviar correo: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Enviar correo de bienvenida
     * @param destinatario Correo del usuario
     * @param nombre Nombre del usuario
     * @return true si se envió exitosamente
     */
    public boolean enviarCorreoBienvenida(String destinatario, String nombre) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });
            
            Message mensaje = new MimeMessage(session);
            mensaje.setFrom(new InternetAddress(EMAIL_FROM));
            mensaje.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            mensaje.setSubject("Bienvenido a Monster University");
            
            String contenidoHTML = generarContenidoBienvenida(nombre);
            mensaje.setContent(contenidoHTML, "text/html; charset=utf-8");
            
            Transport.send(mensaje);
            
            System.out.println("✅ Correo de bienvenida enviado a: " + destinatario);
            return true;
            
        } catch (MessagingException e) {
            System.out.println("❌ Error al enviar correo de bienvenida: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Generar contenido HTML del correo de recuperación
     */
    private String generarContenidoRecuperacion(String nombre, String enlace) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><meta charset='utf-8'></head>" +
               "<body style='font-family: Arial, sans-serif; background: #f4f4f4;'>" +
               "<div style='max-width: 600px; margin: 20px auto; background: white; padding: 40px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'>" +
               "  <div style='text-align: center; margin-bottom: 30px;'>" +
               "    <h1 style='color: #667eea; margin: 0; font-size: 28px;'>🔐 Recupera tu Contraseña</h1>" +
               "  </div>" +
               "  <p style='color: #333; font-size: 16px;'>Hola <strong>" + nombre + "</strong>,</p>" +
               "  <p style='color: #666; line-height: 1.6;'>" +
               "    Hemos recibido una solicitud para recuperar tu contraseña en Monster University. " +
               "    Si no fuiste tú quien solicitó esto, puedes ignorar este correo." +
               "  </p>" +
               "  <div style='text-align: center; margin: 30px 0;'>" +
               "    <a href='" + enlace + "' style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 12px 40px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;'>" +
               "      Restablecer Contraseña" +
               "    </a>" +
               "  </div>" +
               "  <p style='color: #999; font-size: 12px;'>O copia y pega este enlace en tu navegador:</p>" +
               "  <p style='color: #667eea; word-break: break-all; font-size: 12px;'>" + enlace + "</p>" +
               "  <hr style='border: none; border-top: 1px solid #e0e0e0; margin: 20px 0;'>" +
               "  <p style='color: #999; font-size: 12px;'>" +
               "    <strong>Importante:</strong> Este enlace expira en 24 horas por razones de seguridad.<br>" +
               "    Si necesitas ayuda, contacta con el administrador del sistema." +
               "  </p>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
    
    /**
     * Generar contenido HTML del correo de bienvenida
     */
    private String generarContenidoBienvenida(String nombre) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><meta charset='utf-8'></head>" +
               "<body style='font-family: Arial, sans-serif; background: #f4f4f4;'>" +
               "<div style='max-width: 600px; margin: 20px auto; background: white; padding: 40px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'>" +
               "  <div style='text-align: center; margin-bottom: 30px;'>" +
               "    <h1 style='color: #667eea; margin: 0; font-size: 28px;'>🎓 ¡Bienvenido a Monster University!</h1>" +
               "  </div>" +
               "  <p style='color: #333; font-size: 16px;'>Hola <strong>" + nombre + "</strong>,</p>" +
               "  <p style='color: #666; line-height: 1.6;'>" +
               "    Tu cuenta ha sido creada exitosamente en el Sistema de Gestión Académica de Monster University. " +
               "    Estamos felices de tenerte con nosotros." +
               "  </p>" +
               "  <hr style='border: none; border-top: 1px solid #e0e0e0; margin: 20px 0;'>" +
               "  <p style='color: #999; font-size: 12px;'>" +
               "    Si tienes preguntas o necesitas ayuda, no dudes en contactar al administrador del sistema." +
               "  </p>" +
               "</div>" +
               "</body>" +
               "</html>";
    }

    /**
     * Enviar credenciales de acceso al nuevo usuario
     * @param destinatario Correo del usuario
     * @param nombre Nombre completo del usuario
     * @param username Nombre de usuario
     * @param password Contraseña en plaintext
     * @return true si se envió exitosamente
     */
    public boolean enviarCredenciales(String destinatario, String nombre, String username, String password) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.socketFactory.port", SMTP_PORT);
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });
            
            Message mensaje = new MimeMessage(session);
            mensaje.setFrom(new InternetAddress(EMAIL_FROM));
            mensaje.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            mensaje.setSubject("Tu Cuenta en Monster University - Datos de Acceso");
            
            String contenidoHTML = generarContenidoCredenciales(nombre, username, password);
            mensaje.setContent(contenidoHTML, "text/html; charset=utf-8");
            
            Transport.send(mensaje);
            
            System.out.println("✅ Credenciales enviadas a: " + destinatario);
            return true;
            
        } catch (MessagingException e) {
            System.out.println("❌ Error al enviar credenciales: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Generar contenido HTML del correo con credenciales de acceso
     */
    private String generarContenidoCredenciales(String nombre, String username, String password) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><meta charset='utf-8'></head>" +
               "<body style='font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); margin: 0; padding: 0;'>" +
               "<div style='max-width: 600px; margin: 20px auto; background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.2);'>" +
               "  <div style='text-align: center; margin-bottom: 40px;'>" +
               "    <h1 style='color: #667eea; margin: 0; font-size: 32px; font-weight: 700;'>🎓 Monster University</h1>" +
               "    <p style='color: #999; margin: 10px 0 0 0; font-size: 14px;'>Sistema de Gestión Académica</p>" +
               "  </div>" +
               "  <div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px; margin-bottom: 30px; text-align: center;'>" +
               "    <h2 style='margin: 0 0 20px 0; font-size: 24px;'>¡Bienvenido!</h2>" +
               "    <p style='margin: 0; font-size: 16px; line-height: 1.6;'>Tu cuenta ha sido creada exitosamente en Monster University. Aquí están tus datos de acceso:</p>" +
               "  </div>" +
               "  <p style='color: #333; font-size: 16px; margin-bottom: 20px;'>Hola <strong>" + nombre + "</strong>,</p>" +
               "  <div style='background: #f8f9fa; padding: 25px; border-radius: 10px; margin: 25px 0; border: 2px solid #667eea;'>" +
               "    <h3 style='color: #667eea; margin: 0 0 20px 0; font-size: 16px; text-transform: uppercase; letter-spacing: 1px;'>📋 Datos de Acceso</h3>" +
               "    <div style='margin-bottom: 20px;'>" +
               "      <p style='margin: 0 0 8px 0; color: #666; font-size: 14px; font-weight: 600;'><i class='fa fa-user'></i> USUARIO:</p>" +
               "      <p style='margin: 0; font-size: 18px; color: #667eea; font-family: \"Courier New\", monospace; word-break: break-all; font-weight: 700; background: white; padding: 12px; border-radius: 6px; border-left: 4px solid #667eea;'>" + username + "</p>" +
               "    </div>" +
               "    <div>" +
               "      <p style='margin: 0 0 8px 0; color: #666; font-size: 14px; font-weight: 600;'><i class='fa fa-lock'></i> CONTRASEÑA:</p>" +
               "      <p style='margin: 0; font-size: 18px; color: #667eea; font-family: \"Courier New\", monospace; word-break: break-all; font-weight: 700; background: white; padding: 12px; border-radius: 6px; border-left: 4px solid #667eea;'>" + password + "</p>" +
               "    </div>" +
               "  </div>" +
               "  <div style='background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; border-radius: 6px; margin: 25px 0;'>" +
               "    <p style='margin: 0; color: #856404; font-size: 14px;'>" +
               "      <strong>⚠️ Importante:</strong> Por razones de seguridad, te recomendamos cambiar tu contraseña después de iniciar sesión por primera vez." +
               "    </p>" +
               "  </div>" +
               "  <div style='background: #e7f3ff; border-left: 4px solid #2196F3; padding: 15px; border-radius: 6px; margin: 25px 0;'>" +
               "    <p style='margin: 0; color: #0c5aa0; font-size: 14px;'>" +
               "      <strong>💡 Próximos pasos:</strong>" +
               "    </p>" +
               "    <ul style='margin: 10px 0 0 0; padding-left: 20px; color: #0c5aa0; font-size: 14px;'>" +
               "      <li>Accede al sistema con tus credenciales</li>" +
               "      <li>Completa tu perfil de usuario</li>" +
               "      <li>Cambia tu contraseña a algo más seguro</li>" +
               "    </ul>" +
               "  </div>" +
               "  <hr style='border: none; border-top: 2px solid #e0e0e0; margin: 30px 0;'>" +
               "  <p style='color: #999; font-size: 12px; text-align: center; margin: 0;'>" +
               "    Si no creaste esta cuenta o tienes preguntas, contacta inmediatamente al administrador del sistema.<br>" +
               "    <strong>No compartas tus credenciales con nadie.</strong>" +
               "  </p>" +
               "  <p style='color: #999; font-size: 11px; text-align: center; margin: 15px 0 0 0;'>" +
               "    © 2024 Monster University. Todos los derechos reservados." +
               "  </p>" +
               "</div>" +
               "</body>" +
               "</html>";
    }
}
