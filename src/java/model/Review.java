package model;

import java.sql.Timestamp;

/**
 * Model class for Review entity
 */
public class Review {
    private int id;
    private int tourId;
    private int accountId;
    private int rating;
    private String comment;
    private Timestamp createdDate;
    private Timestamp deletedDate;
    private boolean isDelete;
    
    // User information for display purposes
    private String userName;
    private String userAvatar;
    private String tourName;
    
    // Admin feedback
    private String feedback;

    public Review() {
    }

    public Review(int id, int tourId, int accountId, int rating, String comment, 
                 Timestamp createdDate, Timestamp deletedDate, boolean isDelete) {
        this.id = id;
        this.tourId = tourId;
        this.accountId = accountId;
        this.rating = rating;
        this.comment = comment;
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

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
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
    
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserAvatar() {
        return userAvatar;
    }

    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    @Override
    public String toString() {
        return "Review{" + "id=" + id + ", tourId=" + tourId + ", accountId=" + accountId + 
               ", rating=" + rating + ", comment=" + comment + ", createdDate=" + createdDate + 
               ", deletedDate=" + deletedDate + ", isDelete=" + isDelete + '}';
    }
} 