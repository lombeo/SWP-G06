package model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Trip model class that represents the trip table in the database
 */
public class Trip {
    private int id;
    private int departureCityId;
    private int destinationCityId;
    private int tourId;
    private Timestamp departureDate;
    private Timestamp returnDate;
    private String startTime;
    private String endTime;
    private int availableSlot;
    private Timestamp createdDate;
    private Timestamp deletedDate;
    private boolean isDelete;
    
    // Reference to Tour object (not stored in database)
    private Tour tour;
    
    // Constructors
    public Trip() {
    }
    
    public Trip(int id, int departureCityId, int destinationCityId, int tourId, 
                Timestamp departureDate, Timestamp returnDate, String startTime, String endTime, 
                int availableSlot, Timestamp createdDate, Timestamp deletedDate, boolean isDelete) {
        this.id = id;
        this.departureCityId = departureCityId;
        this.destinationCityId = destinationCityId;
        this.tourId = tourId;
        this.departureDate = departureDate;
        this.returnDate = returnDate;
        setStartTime(startTime); // Use setter for validation
        setEndTime(endTime);     // Use setter for validation
        this.availableSlot = availableSlot;
        this.createdDate = createdDate;
        this.deletedDate = deletedDate;
        this.isDelete = isDelete;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getDepartureCityId() {
        return departureCityId;
    }

    public void setDepartureCityId(int departureCityId) {
        this.departureCityId = departureCityId;
    }

    public int getDestinationCityId() {
        return destinationCityId;
    }

    public void setDestinationCityId(int destinationCityId) {
        this.destinationCityId = destinationCityId;
    }

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public Timestamp getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(Timestamp departureDate) {
        this.departureDate = departureDate;
    }

    public Timestamp getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Timestamp returnDate) {
        this.returnDate = returnDate;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = formatTimeForSqlServer(startTime);
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = formatTimeForSqlServer(endTime);
    }

    public int getAvailableSlot() {
        return availableSlot;
    }

    public void setAvailableSlot(int availableSlot) {
        this.availableSlot = availableSlot;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getDeletedDate() {
        return deletedDate;
    }

    public void setDeletedDate(Timestamp deletedDate) {
        this.deletedDate = deletedDate;
    }

    public boolean isIsDelete() {
        return isDelete;
    }

    public void setIsDelete(boolean isDelete) {
        this.isDelete = isDelete;
    }
    
    public Tour getTour() {
        return tour;
    }
    
    public void setTour(Tour tour) {
        this.tour = tour;
    }
    
    /**
     * Format a date as SQL Server datetime string (YYYY-MM-DD HH:MM:SS)
     * @return Formatted datetime string
     */
    public String getFormattedDepartureDate() {
        if (departureDate == null) return null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(departureDate);
    }
    
    /**
     * Format a date as SQL Server datetime string (YYYY-MM-DD HH:MM:SS)
     * @return Formatted datetime string
     */
    public String getFormattedReturnDate() {
        if (returnDate == null) return null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(returnDate);
    }
    
    /**
     * Format time string for SQL Server time(7) type
     * @param timeStr Input time string
     * @return Formatted time string in SQL Server format
     */
    private String formatTimeForSqlServer(String timeStr) {
        if (timeStr == null || timeStr.isEmpty()) {
            return "00:00:00"; // Default if not provided
        }
        
        // Try to extract HH:MM pattern
        Pattern pattern = Pattern.compile("(\\d{1,2}):(\\d{2})(?::(\\d{2})?)?");
        Matcher matcher = pattern.matcher(timeStr);
        
        if (matcher.find()) {
            // Extract hours and minutes
            String hours = matcher.group(1);
            String minutes = matcher.group(2);
            String seconds = matcher.groupCount() >= 3 && matcher.group(3) != null ? matcher.group(3) : "00";
            
            // Ensure leading zeros
            if (hours.length() == 1) {
                hours = "0" + hours;
            }
            
            // Return in HH:MM:SS format
            return hours + ":" + minutes + ":" + seconds;
        } else {
            // If not matching the pattern, return default
            return timeStr.length() <= 8 ? timeStr : timeStr.substring(0, 8);
        }
    }
    
    /**
     * Get a SQL Server compatible time string (HH:MM:SS)
     * @param timeStr The time string to format
     * @return Formatted time string
     */
    public static String cleanTimeForSQL(String timeStr) {
        if (timeStr == null || timeStr.isEmpty()) {
            return "00:00:00";
        }
        
        // Extract HH:MM pattern if present
        Pattern pattern = Pattern.compile("(\\d{1,2}):(\\d{2})");
        Matcher matcher = pattern.matcher(timeStr);
        
        if (matcher.find()) {
            String hours = matcher.group(1);
            String minutes = matcher.group(2);
            
            // Ensure hours has leading zero if needed
            if (hours.length() == 1) {
                hours = "0" + hours;
            }
            
            // Return formatted time with seconds
            return hours + ":" + minutes + ":00";
        }
        
        // If no match, return original or default
        return timeStr.length() <= 8 ? timeStr : "00:00:00";
    }
    
    @Override
    public String toString() {
        return "Trip{" + "id=" + id + ", departureCityId=" + departureCityId + ", destinationCityId=" + destinationCityId + 
               ", tourId=" + tourId + ", departureDate=" + departureDate + ", returnDate=" + returnDate + 
               ", startTime=" + startTime + ", endTime=" + endTime + ", availableSlot=" + availableSlot + 
               ", createdDate=" + createdDate + ", deletedDate=" + deletedDate + 
               ", isDelete=" + isDelete + '}';
    }
} 