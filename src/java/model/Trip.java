package model;

import java.sql.Timestamp;

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
        this.startTime = startTime;
        this.endTime = endTime;
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
    
    @Override
    public String toString() {
        return "Trip{" + "id=" + id + ", departureCityId=" + departureCityId + ", destinationCityId=" + destinationCityId + 
               ", tourId=" + tourId + ", departureDate=" + departureDate + ", returnDate=" + returnDate + 
               ", startTime=" + startTime + ", endTime=" + endTime + ", availableSlot=" + availableSlot + 
               ", createdDate=" + createdDate + ", deletedDate=" + deletedDate + 
               ", isDelete=" + isDelete + '}';
    }
} 