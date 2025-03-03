package model;

public class TourSchedule {
    private int id;
    private int tourId;
    private int dayNumber;
    private String itinerary;
    private String description;
    
    public TourSchedule() {
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
    
    public int getDayNumber() {
        return dayNumber;
    }
    
    public void setDayNumber(int dayNumber) {
        this.dayNumber = dayNumber;
    }
    
    public String getItinerary() {
        return itinerary;
    }
    
    public void setItinerary(String itinerary) {
        this.itinerary = itinerary;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
} 