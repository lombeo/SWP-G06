package controller;

import dao.BookingDAO;
import dao.TourDAO;
import dao.TripDAO;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Tour;
import model.Trip;
import model.User;
import vnpay.Config;

@WebServlet(name = "PaymentController", urlPatterns = {"/payment"})
public class PaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward GET request to POST method
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set character encoding to properly handle Vietnamese characters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Get session and user info
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                response.sendRedirect("login?redirect=booking");
                return;
            }
            
            // Get parameters from booking form
            int tourId = Integer.parseInt(request.getParameter("tourId"));
            int adultCount = Integer.parseInt(request.getParameter("adultCount"));
            int childCount = Integer.parseInt(request.getParameter("childCount"));
            String paymentMethod = request.getParameter("paymentMethod");
            boolean agreeToTerms = "on".equals(request.getParameter("agree"));
            
            // Check if a specific trip ID was selected
            int specificTripId = 0;
            String tripIdParam = request.getParameter("tripId");
            if (tripIdParam != null && !tripIdParam.isEmpty()) {
                try {
                    specificTripId = Integer.parseInt(tripIdParam);
                    System.out.println("Specific trip ID selected: " + specificTripId);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid trip ID parameter: " + tripIdParam);
                }
            }
            
            // Validate data (moved from ProcessBookingServlet)
            if (adultCount <= 0) {
                request.setAttribute("errorMessage", "Số lượng người lớn phải lớn hơn 0");
                request.getRequestDispatcher("booking?tourId=" + tourId).forward(request, response);
                return;
            }
            
            if (!agreeToTerms) {
                request.setAttribute("errorMessage", "Bạn phải đồng ý với điều khoản để tiếp tục");
                request.getRequestDispatcher("booking?tourId=" + tourId).forward(request, response);
                return;
            }
            
            // Validate payment method
            if (!"VNPAY".equals(paymentMethod)) {
                request.setAttribute("errorMessage", "Phương thức thanh toán không được hỗ trợ!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Get tour information
            TourDAO tourDAO = new TourDAO();
            Tour tour = tourDAO.getTourById(tourId);
            
            if (tour == null) {
                response.sendRedirect("tour");
                return;
            }
            
            // Get an available trip for this tour
            TripDAO tripDAO = new TripDAO();
            
            // Log more booking details
            System.out.println("Looking for trip with these parameters:");
            System.out.println("- Tour ID: " + tourId);
            System.out.println("- Adult Count: " + adultCount);
            System.out.println("- Child Count: " + childCount);
            System.out.println("- Total required slots: " + (adultCount + childCount));
            System.out.println("- Current system date: " + new java.util.Date());
            if (specificTripId > 0) {
                System.out.println("- Specific Trip ID requested: " + specificTripId);
            }
            
            Trip trip = null;
            
            // If a specific trip ID was provided, try to use that trip
            if (specificTripId > 0) {
                trip = tripDAO.getTripById(specificTripId);
                
                // Verify this trip belongs to the requested tour and has enough available slots
                if (trip != null) {
                    if (trip.getTourId() != tourId) {
                        System.out.println("Warning: Requested trip " + specificTripId + 
                                         " belongs to tour " + trip.getTourId() + 
                                         " not tour " + tourId);
                        trip = null; // Don't use this trip
                    } else if (trip.getAvailableSlot() < (adultCount + childCount)) {
                        System.out.println("Warning: Requested trip " + specificTripId + 
                                         " does not have enough available slots (" + 
                                         trip.getAvailableSlot() + " available, " + 
                                         (adultCount + childCount) + " needed)");
                        trip = null; // Don't use this trip
                    } else if (trip.getDepartureDate().before(new Date())) {
                        System.out.println("Warning: Requested trip " + specificTripId + 
                                         " has a departure date in the past: " + 
                                         trip.getDepartureDate());
                        trip = null; // Don't use this trip
                    }
                }
            }
            
            // If no specific trip was requested or the requested trip wasn't valid,
            // get the first available trip for this tour
            if (trip == null) {
                trip = tripDAO.getAvailableTripForTour(tourId, adultCount + childCount);
            }
            
            if (trip == null) {
                // Enhanced error handling
                System.out.println("ERROR: No suitable trip found for tour " + tourId);
                request.setAttribute("errorMessage", "Không tìm thấy chuyến đi phù hợp cho tour này!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Log trip information
            System.out.println("Using trip for booking: Trip ID=" + trip.getId() + 
                ", Tour ID=" + trip.getTourId() + 
                ", Current available slots=" + trip.getAvailableSlot() + 
                ", Requested slots=" + (adultCount + childCount));
            
            // Create a new booking (but don't save it to DB yet - only save after payment success)
            Booking booking = new Booking();
            booking.setTripId(trip.getId());
            booking.setAccountId(user.getId());
            booking.setAdultNumber(adultCount);
            booking.setChildNumber(childCount);
            booking.setCreatedDate(new java.sql.Timestamp(System.currentTimeMillis()));
            
            // Log the created booking
            System.out.println("Created pending booking: Account ID=" + user.getId() + 
                ", Trip ID=" + booking.getTripId() + 
                ", Adult Count=" + adultCount + 
                ", Child Count=" + childCount);
            
            // Store the booking object in session for later use
            session.setAttribute("pendingBooking", booking);
            
            // Get promotion information if it exists
            boolean hasPromotion = Boolean.parseBoolean(request.getParameter("hasPromotion"));
            float discountPercent = 0;
            if (hasPromotion && request.getParameter("discountPercent") != null) {
                try {
                    discountPercent = Float.parseFloat(request.getParameter("discountPercent"));
                } catch (NumberFormatException e) {
                    log("Error parsing discount percent: " + e.getMessage());
                }
            }
            
            // Calculate total amount (in VND)
            long totalAmount;
            // Use the totalAmount from the form if provided, otherwise calculate it
            if (request.getParameter("totalAmount") != null) {
                totalAmount = Long.parseLong(request.getParameter("totalAmount"));
            } else {
                // Fallback calculation if totalAmount is not provided
                long adultPrice = (long) (adultCount * tour.getPriceAdult());
                long childPrice = (long) (childCount * tour.getPriceChildren());
                
                // Apply discount if there's a valid promotion
                if (hasPromotion && discountPercent > 0) {
                    float discountMultiplier = 1 - (discountPercent / 100);
                    adultPrice = (long) (adultPrice * discountMultiplier);
                    childPrice = (long) (childPrice * discountMultiplier);
                }
                
                totalAmount = adultPrice + childPrice;
            }
            
            // Create VNPAY payment URL
            String vnp_TxnRef = Config.getRandomNumber(8);
            String vnp_TmnCode = Config.vnp_TmnCode;
            
            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", Config.vnp_Version);
            vnp_Params.put("vnp_Command", Config.vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(totalAmount * 100)); // Số tiền x100 (currency là VND)
            vnp_Params.put("vnp_CurrCode", Config.vnp_CurrCode);
            
            // Encode payment description with booking details
            String vnp_OrderInfo = "Thanh toan dat tour - TourID: " + tourId;
            vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
            vnp_Params.put("vnp_OrderType", Config.vnp_OrderType);
            vnp_Params.put("vnp_Locale", Config.vnp_Locale);
            
            // Thêm IP khách hàng
            String vnp_IpAddr = Config.getIpAddress(request);
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
            
            // Không chỉ định ngân hàng, để VNPAY hiển thị trang chọn ngân hàng
            // vnp_Params.put("vnp_BankCode", "NCB");
            
            // Store transaction reference in session to verify on return
            session.setAttribute("vnp_TxnRef", vnp_TxnRef);
            
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_ReturnUrl", Config.vnp_Returnurl);
            
            // Set expiry time for payment (15 minutes)
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
            
            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
            
            // Build the payment URL
            List fieldNames = new ArrayList(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            
            Iterator itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = (String) itr.next();
                String fieldValue = vnp_Params.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    // Build hash data
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    
                    // Build query
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
            
            String queryUrl = query.toString();
            String vnp_SecureHash = Config.hmacSHA512(Config.vnp_HashSecret, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
            
            // Log payment URL for debugging
            System.out.println("VNPAY Payment URL: " + paymentUrl);
            System.out.println("Hash data: " + hashData.toString());
            System.out.println("Hash result: " + vnp_SecureHash);
            
            // Redirect to VNPAY payment gateway
            response.sendRedirect(paymentUrl);
            
            // Lưu các thông tin quan trọng vào session để có thể truy cập sau khi quay lại
            session.setAttribute("totalAmount", totalAmount);
            session.setAttribute("tourInfo", tour);
            session.setAttribute("tripInfo", trip);
        } catch (Exception e) {
            log("Payment error: " + e.getMessage());
            e.printStackTrace(); // In ra lỗi chi tiết
            request.setAttribute("errorMessage", "Đã xảy ra lỗi trong quá trình thanh toán: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 