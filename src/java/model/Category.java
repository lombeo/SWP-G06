package model;

public class Category {
    private int id;
    private String name;
    private int tourCount;
    
    public Category() {
    }
    
    public Category(int id, String name) {
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
    
    public int getTourCount() {
        return tourCount;
    }
    
    public void setTourCount(int tourCount) {
        this.tourCount = tourCount;
    }
} 