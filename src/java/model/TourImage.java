package model;

public class TourImage {
    private int id;
    private int tourId;
    private String imageUrl;
    
    public TourImage() {
    }
    
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
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
} 