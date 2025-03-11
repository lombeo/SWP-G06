package model;

import java.util.Date;
import java.util.List;

/**
 * Booking model class that represents the booking table in the database
 */
public class Booking {
    private int id;
    private int tripId;
    private int accountId;
    private int adultNumber;
    private int childNumber;
    private Date createdDate;
    private Date deletedDate;
    private boolean isDelete;
    private String status;
    
    // References to related objects (not stored in database)
    private User user;
    private Trip trip;
    private List<Transaction> transactions;
    
    // Constructors
    public Booking() {
    }
    
    public Booking(int id, int tripId, int accountId, int adultNumber, int childNumber, 
                  Date createdDate, Date deletedDate, boolean isDelete) {
        this.id = id;
        this.tripId = tripId;
        this.accountId = accountId;
        this.adultNumber = adultNumber;
        this.childNumber = childNumber;
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

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getAdultNumber() {
        return adultNumber;
    }

    public void setAdultNumber(int adultNumber) {
        this.adultNumber = adultNumber;
    }

    public int getChildNumber() {
        return childNumber;
    }

    public void setChildNumber(int childNumber) {
        this.childNumber = childNumber;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getDeletedDate() {
        return deletedDate;
    }

    public void setDeletedDate(Date deletedDate) {
        this.deletedDate = deletedDate;
    }

    public boolean isIsDelete() {
        return isDelete;
    }

    public void setIsDelete(boolean isDelete) {
        this.isDelete = isDelete;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public Trip getTrip() {
        return trip;
    }
    
    public void setTrip(Trip trip) {
        this.trip = trip;
    }
    
    public List<Transaction> getTransactions() {
        return transactions;
    }
    
    public void setTransactions(List<Transaction> transactions) {
        this.transactions = transactions;
    }
    
    /**
     * Calculate the total amount from all Payment transactions
     * @return The total amount or 0 if no payment transactions found
     */
    public double getTotalAmount() {
        if (transactions == null || transactions.isEmpty()) {
            return 0;
        }
        
        double total = 0;
        for (Transaction transaction : transactions) {
            if (transaction.getTransactionType().equals("Payment")) {
                total += transaction.getAmount();
            }
        }
        return total;
    }
    
    @Override
    public String toString() {
        return "Booking{" + "id=" + id + ", tripId=" + tripId + ", accountId=" + accountId + 
               ", adultNumber=" + adultNumber + ", childNumber=" + childNumber + 
               ", createdDate=" + createdDate + ", deletedDate=" + deletedDate + 
               ", isDelete=" + isDelete + ", status=" + status + '}';
    }
} 