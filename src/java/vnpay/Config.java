package vnpay;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import jakarta.servlet.http.HttpServletRequest;

/**
 * VNPAY Configuration and Utility functions
 */
public class Config {

    // VNPAY API Configuration
    public static String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static String vnp_Returnurl = "http://localhost:9999/SWP-G06/payment-return";
    
    // Thông tin tài khoản test của VNPAY Sandbox
    public static String vnp_TmnCode = "CSJ9A6DD"; // Terminal ID provided by VNPAY
    public static String vnp_HashSecret = "SZLK6UZG3QMAQHNXT5O2UGCWJ80VM0NZ"; // Secret key provided by VNPAY
    
    public static String vnp_Version = "2.1.0";
    public static String vnp_Command = "pay";
    public static String vnp_CurrCode = "VND";
    public static String vnp_Locale = "vn";
    public static String vnp_OrderType = "other";
    
    // Utility method to format amount - remove decimal points and convert to cents
    public static String getAmount(double amount) {
        long amountInCents = (long) (amount * 100);
        return String.valueOf(amountInCents);
    }
    
    // Get client IP address
    public static String getIpAddress(HttpServletRequest request) {
        String ipAdress;
        try {
            ipAdress = request.getHeader("X-FORWARDED-FOR");
            if (ipAdress == null) {
                ipAdress = request.getRemoteAddr();
            }
            return ipAdress;
        } catch (Exception e) {
            return "127.0.0.1";
        }
    }
    
    /**
     * Generate HMAC-SHA512 signature for VNPAY request
     */
    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException();
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes();
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            return "";
        }
    }
    
    /**
     * Generate a secure hash from payment parameters
     */
    public static String hashAllFields(Map fields) {
        List fieldNames = new ArrayList(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder sb = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                sb.append(fieldName);
                sb.append("=");
                sb.append(fieldValue);
                if (itr.hasNext()) {
                    sb.append("&");
                }
            }
        }
        String signData = sb.toString();
        System.out.println("Hash string for signing: " + signData);
        return hmacSHA512(vnp_HashSecret, signData);
    }
    
    /**
     * Generate a secure transaction reference
     */
    public static String getRandomNumber(int len) {
        Random rnd = new Random();
        String chars = "0123456789";
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
} 