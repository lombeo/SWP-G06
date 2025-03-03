package model;

public class Tour {
    private int id;
    private String name;
    private String img;
    private String region;
    private double priceChildren;
    private double priceAdult;
    private String suitableFor;
    private String bestTime;
    private String cuisine;
    private String duration;
    private String sightseeing;
    private int availableSlot;
    private int maxCapacity;
    private int departureLocationId;
    private String departureCity;
    private int categoryId;
    private String destinationCity;
    private double discountPercentage;

    public Tour() {
    }

    public Tour(int id, String name, String img, String region, double priceChildren, 
                double priceAdult, String suitableFor, String bestTime, String cuisine, 
                String duration, String sightseeing, int availableSlot, int maxCapacity, 
                int departureLocationId, String departureCity, int categoryId,
                String destinationCity, double discountPercentage) {
        this.id = id;
        this.name = name;
        this.img = img;
        this.region = region;
        this.priceChildren = priceChildren;
        this.priceAdult = priceAdult;
        this.suitableFor = suitableFor;
        this.bestTime = bestTime;
        this.cuisine = cuisine;
        this.duration = duration;
        this.sightseeing = sightseeing;
        this.availableSlot = availableSlot;
        this.maxCapacity = maxCapacity;
        this.departureLocationId = departureLocationId;
        this.departureCity = departureCity;
        this.categoryId = categoryId;
        this.destinationCity = destinationCity;
        this.discountPercentage = discountPercentage;
    }

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

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public double getPriceChildren() {
        return priceChildren;
    }

    public void setPriceChildren(double priceChildren) {
        this.priceChildren = priceChildren;
    }

    public double getPriceAdult() {
        return priceAdult;
    }

    public void setPriceAdult(double priceAdult) {
        this.priceAdult = priceAdult;
    }

    public String getSuitableFor() {
        return suitableFor;
    }

    public void setSuitableFor(String suitableFor) {
        this.suitableFor = suitableFor;
    }

    public String getBestTime() {
        return bestTime;
    }

    public void setBestTime(String bestTime) {
        this.bestTime = bestTime;
    }

    public String getCuisine() {
        return cuisine;
    }

    public void setCuisine(String cuisine) {
        this.cuisine = cuisine;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getSightseeing() {
        return sightseeing;
    }

    public void setSightseeing(String sightseeing) {
        this.sightseeing = sightseeing;
    }

    public int getAvailableSlot() {
        return availableSlot;
    }

    public void setAvailableSlot(int availableSlot) {
        this.availableSlot = availableSlot;
    }

    public int getMaxCapacity() {
        return maxCapacity;
    }

    public void setMaxCapacity(int maxCapacity) {
        this.maxCapacity = maxCapacity;
    }

    public int getDepartureLocationId() {
        return departureLocationId;
    }

    public void setDepartureLocationId(int departureLocationId) {
        this.departureLocationId = departureLocationId;
    }

    public String getDepartureCity() {
        return departureCity;
    }

    public void setDepartureCity(String departureCity) {
        this.departureCity = departureCity;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getDestinationCity() {
        return destinationCity;
    }

    public void setDestinationCity(String destinationCity) {
        this.destinationCity = destinationCity;
    }

    public double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }
} 