package ec.edu.monster.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordUtil {
    private static final int ITERATIONS = 120000; // OWASP recommendation range
    private static final int SALT_LEN = 16; // 128-bit salt
    private static final int KEY_LEN = 256; // 256-bit derived key

    public static String hash(String password) {
        try {
            byte[] salt = new byte[SALT_LEN];
            SecureRandom.getInstanceStrong().nextBytes(salt);
            byte[] dk = pbkdf2(password.toCharArray(), salt, ITERATIONS, KEY_LEN);
            return "PBKDF2$" + ITERATIONS + "$" + Base64.getEncoder().encodeToString(salt) + "$" + Base64.getEncoder().encodeToString(dk);
        } catch (Exception e) {
            throw new RuntimeException("Error generating password hash", e);
        }
    }

    public static boolean verify(String password, String stored) {
        if (stored == null || !stored.startsWith("PBKDF2$")) {
            // Fallback: legacy plain comparison
            return stored != null && password != null && password.equals(stored);
        }
        try {
            String[] parts = stored.split("\\$");
            int iter = Integer.parseInt(parts[1]);
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expected = Base64.getDecoder().decode(parts[3]);
            byte[] dk = pbkdf2(password.toCharArray(), salt, iter, expected.length * 8);
            return slowEquals(expected, dk);
        } catch (Exception e) {
            return false;
        }
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int keyLen)
            throws NoSuchAlgorithmException, InvalidKeySpecException {
        PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, keyLen);
        SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        return skf.generateSecret(spec).getEncoded();
    }

    private static boolean slowEquals(byte[] a, byte[] b) {
        if (a.length != b.length) return false;
        int diff = 0;
        for (int i = 0; i < a.length; i++) diff |= a[i] ^ b[i];
        return diff == 0;
    }
}
