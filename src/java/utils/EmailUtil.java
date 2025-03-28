package utils;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;

public class EmailUtil {
    // Email configuration constants
    private static final String HOST = "smtp.gmail.com";
    private static final String PORT = "587";
    private static final String USERNAME = "longrpk200313@gmail.com";
    private static final String PASSWORD = "zoen whrc geph qeqb"; 
    private static final String FROM_EMAIL = "longrpk200313@gmail.com"; 
    
    /**
     * Sends an email with the given parameters
     * 
     * @param toEmail The recipient's email address
     * @param subject The email subject
     * @param content The email content (HTML supported)
     * @return true if email was sent successfully, false otherwise
     */
    public static boolean sendEmail(String toEmail, String subject, String content) {
        try {
            // Set properties
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", HOST);
            props.put("mail.smtp.port", PORT);
            
            // Create session
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(USERNAME, PASSWORD);
                }
            });
            
            // Create message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            
            // Properly encode subject for Unicode characters
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
            
            // Set content with UTF-8 charset
            message.setContent(content, "text/html; charset=utf-8");
            
            // Send message
            Transport.send(message);
            
            return true;
        } catch (MessagingException | UnsupportedEncodingException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Sends an OTP verification email
     * 
     * @param toEmail The recipient's email address
     * @param otp The OTP code
     * @param userName The user's name
     * @return true if email was sent successfully, false otherwise
     */
    public static boolean sendOTPEmail(String toEmail, String otp, String userName) {
        String subject = "Xác thực tài khoản TourNest của bạn";
        
        // Create HTML content with OTP
        String content = ""
                + "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>"
                + "<div style='background-color: #4F46E5; padding: 20px; text-align: center; color: white;'>"
                + "<h1>TourNest - Xác thực tài khoản</h1>"
                + "</div>"
                + "<div style='padding: 20px; background-color: #f9f9f9;'>"
                + "<p>Xin chào <strong>" + userName + "</strong>,</p>"
                + "<p>Cảm ơn bạn đã đăng ký tài khoản tại TourNest. Để hoàn tất quá trình đăng ký, vui lòng nhập mã OTP sau đây:</p>"
                + "<div style='background-color: #ffffff; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 5px; margin: 20px 0; border: 1px dashed #ccc;'>"
                + otp
                + "</div>"
                + "<p>Mã OTP này sẽ hết hạn sau 5 phút.</p>"
                + "<p>Nếu bạn không thực hiện đăng ký tài khoản này, vui lòng bỏ qua email này.</p>"
                + "<p>Trân trọng,<br>Đội ngũ TourNest</p>"
                + "</div>"
                + "<div style='background-color: #f1f1f1; padding: 15px; text-align: center; font-size: 12px; color: #666;'>"
                + "<p>© " + java.time.Year.now().getValue() + " TourNest. Tất cả các quyền được bảo lưu.</p>"
                + "</div>"
                + "</div>";
        
        return sendEmail(toEmail, subject, content);
    }
} 