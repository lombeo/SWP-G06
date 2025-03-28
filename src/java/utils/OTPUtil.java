package utils;

import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class OTPUtil {
    // Store OTPs in memory with their creation timestamps
    private static final Map<String, OTPData> otpStorage = new ConcurrentHashMap<>();
    private static final int OTP_LENGTH = 6;
    private static final long OTP_VALIDITY_DURATION = 5 * 60 * 1000; // 5 minutes in milliseconds
    
    /**
     * Generates a random OTP for the given email
     * 
     * @param email The email to generate an OTP for
     * @return The generated OTP
     */
    public static String generateOTP(String email) {
        // Generate random numeric OTP
        SecureRandom random = new SecureRandom();
        StringBuilder otp = new StringBuilder();
        
        for (int i = 0; i < OTP_LENGTH; i++) {
            otp.append(random.nextInt(10)); // Digits 0-9
        }
        
        String otpValue = otp.toString();
        
        // Store OTP with creation timestamp
        otpStorage.put(email, new OTPData(otpValue, System.currentTimeMillis()));
        
        return otpValue;
    }
    
    /**
     * Validates the provided OTP for the given email
     * 
     * @param email The user's email
     * @param userOTP The OTP provided by the user
     * @return true if the OTP is valid, false otherwise
     */
    public static boolean validateOTP(String email, String userOTP) {
        OTPData storedOTPData = otpStorage.get(email);
        
        if (storedOTPData == null) {
            return false; // No OTP found for this email
        }
        
        // Check if OTP has expired
        long currentTime = System.currentTimeMillis();
        if (currentTime - storedOTPData.timestamp > OTP_VALIDITY_DURATION) {
            otpStorage.remove(email); // Remove expired OTP
            return false;
        }
        
        // Validate OTP value
        boolean isValid = storedOTPData.otp.equals(userOTP);
        
        if (isValid) {
            otpStorage.remove(email); // Remove the OTP after successful validation
        }
        
        return isValid;
    }
    
    /**
     * Removes the OTP for the given email
     * 
     * @param email The email to remove the OTP for
     */
    public static void removeOTP(String email) {
        otpStorage.remove(email);
    }
    
    /**
     * Private static class to store OTP data
     */
    private static class OTPData {
        private final String otp;
        private final long timestamp;
        
        public OTPData(String otp, long timestamp) {
            this.otp = otp;
            this.timestamp = timestamp;
        }
    }
} 