package model;

public class City {
    private int id;
    private String name;
    private Integer departureCount;
    private Integer destinationCount;
    
    public City() {
    }
    
    public City(int id, String name) {
        this.id = id;
        this.name = name;
    }
    
    // Getters và Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public Integer getDepartureCount() {
        return departureCount;
    }
    
    public void setDepartureCount(Integer departureCount) {
        this.departureCount = departureCount;
    }
    
    public Integer getDestinationCount() {
        return destinationCount;
    }
    
    public void setDestinationCount(Integer destinationCount) {
        this.destinationCount = destinationCount;
    }
} 