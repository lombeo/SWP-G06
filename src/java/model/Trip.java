package model;

import java.sql.Timestamp;

public class Trip {
    private int id;
    private int tourId;
    private int departureCityId;
    private int destinationCityId;
    private Timestamp departureDate;
    private Timestamp returnDate;
    private String startTime;
    private String endTime;
    private int availableSlot;
    private String status;
    private Timestamp createdDate;
    private Timestamp deletedDate;
    private boolean isDelete;
    
    public Trip() {
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
        this.startTime = startTime;
    }
    
    public String getEndTime() {
        return endTime;
    }
    
    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }
    
    public int getAvailableSlot() {
        return availableSlot;
    }
    
    public void setAvailableSlot(int availableSlot) {
        this.availableSlot = availableSlot;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
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
} 