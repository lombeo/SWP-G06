package model;

/**
 * Account model class that represents the Account table in the database
 */
public class Account {
    private int id;
    private String fullName;
    private String email;
    private int roleId;
    private String phone;
    private String address;
    private boolean gender;
    private String dob;
    private String avatar;
    private boolean isDelete;
    
    // Constructors
    public Account() {
    }
    
    public Account(int id, String fullName, String email, int roleId) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.roleId = roleId;
    }
    
    public Account(int id, String fullName, String email, int roleId, 
                  String phone, String address, boolean gender, 
                  String dob, String avatar, boolean isDelete) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.roleId = roleId;
        this.phone = phone;
        this.address = address;
        this.gender = gender;
        this.dob = dob;
        this.avatar = avatar;
        this.isDelete = isDelete;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public boolean isIsDelete() {
        return isDelete;
    }

    public void setIsDelete(boolean isDelete) {
        this.isDelete = isDelete;
    }
} 