package model;

import java.sql.Timestamp;

public class TourPromotion {
    private int tourId;
    private int promotionId;
    private Timestamp createdDate;
    
    // References to related objects
    private Tour tour;
    private Promotion promotion;
    
    // Constructors
    public TourPromotion() {
    }
    
    public TourPromotion(int tourId, int promotionId) {
        this.tourId = tourId;
        this.promotionId = promotionId;
        this.createdDate = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and setters
    public int getTourId() {
        return tourId;
    }
    
    public void setTourId(int tourId) {
        this.tourId = tourId;
    }
    
    public int getPromotionId() {
        return promotionId;
    }
    
    public void setPromotionId(int promotionId) {
        this.promotionId = promotionId;
    }
    
    public Timestamp getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
    
    public Tour getTour() {
        return tour;
    }
    
    public void setTour(Tour tour) {
        this.tour = tour;
    }
    
    public Promotion getPromotion() {
        return promotion;
    }
    
    public void setPromotion(Promotion promotion) {
        this.promotion = promotion;
    }
    
    @Override
    public String toString() {
        return "TourPromotion{" + "tourId=" + tourId + ", promotionId=" + promotionId + '}';
    }
} 