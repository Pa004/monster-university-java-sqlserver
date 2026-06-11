package ec.edu.monster.util;

import java.security.SecureRandom;
import java.util.Random;

/**
 * Utilidad para generar contraseñas temporales seguras
 */
public class TemporaryPasswordUtil {
    private static final String UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
    private static final String DIGITS = "0123456789";
    private static final String SPECIAL = "!@#$%^&*";
    private static final String ALL = UPPERCASE + LOWERCASE + DIGITS + SPECIAL;
    private static final Random random = new SecureRandom();

    /**
     * Genera una contraseña temporal segura
     * Formato: 12 caracteres con mayúsculas, minúsculas, números y caracteres especiales
     * Ejemplo: aB3!xK9@pQr2
     * @return Contraseña temporal
     */
    public static String generarContrasenaTemporal() {
        StringBuilder sb = new StringBuilder();
        
        // Garantizar al menos 1 de cada tipo
        sb.append(UPPERCASE.charAt(random.nextInt(UPPERCASE.length())));
        sb.append(LOWERCASE.charAt(random.nextInt(LOWERCASE.length())));
        sb.append(DIGITS.charAt(random.nextInt(DIGITS.length())));
        sb.append(SPECIAL.charAt(random.nextInt(SPECIAL.length())));
        
        // Llenar el resto con caracteres aleatorios
        for (int i = 4; i < 12; i++) {
            sb.append(ALL.charAt(random.nextInt(ALL.length())));
        }
        
        // Mezclar para evitar patrones predecibles
        return mezclar(sb.toString());
    }

    private static String mezclar(String s) {
        char[] chars = s.toCharArray();
        for (int i = chars.length - 1; i > 0; i--) {
            int j = random.nextInt(i + 1);
            char temp = chars[i];
            chars[i] = chars[j];
            chars[j] = temp;
        }
        return new String(chars);
    }
}
