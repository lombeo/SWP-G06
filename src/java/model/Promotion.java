package model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Promotion {
    private int id;
    private String title;
    private double discountPercentage;
    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp createdDate;
    private Timestamp deletedDate;
    private boolean isDelete;
    private boolean hasLinkedTours;
    
    // Constructors
    public Promotion() {
    }
    
    public Promotion(int id, String title, double discountPercentage, Timestamp startDate, Timestamp endDate) {
        this.id = id;
        this.title = title;
        this.discountPercentage = discountPercentage;
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    // Getters and setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public double getDiscountPercentage() {
        return discountPercentage;
    }
    
    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }
    
    public Timestamp getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }
    
    public Timestamp getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
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
    
    public boolean isHasLinkedTours() {
        return hasLinkedTours;
    }
    
    public void setHasLinkedTours(boolean hasLinkedTours) {
        this.hasLinkedTours = hasLinkedTours;
    }
    
    // Helper methods
    public String getFormattedStartDate() {
        if (startDate == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        return sdf.format(startDate);
    }
    
    public String getFormattedEndDate() {
        if (endDate == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        return sdf.format(endDate);
    }
    
    public String getFormattedDiscount() {
        return String.format("%.1f%%", discountPercentage);
    }
    
    public boolean isActive() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return !isDelete && startDate.before(now) && endDate.after(now);
    }
    
    public String getStatus() {
        if (isDelete) {
            return "Deleted";
        }
        
        Timestamp now = new Timestamp(System.currentTimeMillis());
        if (startDate.after(now)) {
            return "Upcoming";
        } else if (endDate.before(now)) {
            return "Expired";
        } else {
            return "Active";
        }
    }
    
    @Override
    public String toString() {
        return "Promotion{" + "id=" + id + ", title=" + title + ", discountPercentage=" + discountPercentage + 
                ", startDate=" + startDate + ", endDate=" + endDate + '}';
    }
} 