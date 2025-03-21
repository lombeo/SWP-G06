package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class PasswordHashing {
    private static final String SALT = "TourNest@2024"; // Salt cố định

    public static String hashPassword(String password) throws NoSuchAlgorithmException {
        String saltedPassword = SALT + password;
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedBytes = md.digest(saltedPassword.getBytes());
        return Base64.getEncoder().encodeToString(hashedBytes);
    }
    
    public static boolean verifyPassword(String inputPassword, String storedHash) throws NoSuchAlgorithmException {
        if (storedHash == null || inputPassword == null) {
            return false;
        }
        
        // Trim any possible whitespace
        storedHash = storedHash.trim();
        String hashedInput = hashPassword(inputPassword);
        
        // For debugging
        System.out.println("Input password hash: " + hashedInput);
        System.out.println("Stored password hash: " + storedHash);
        System.out.println("Hashes match: " + hashedInput.equals(storedHash));
        
        return hashedInput.equals(storedHash);
    }
} 