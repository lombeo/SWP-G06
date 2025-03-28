package model;

public class User {
    private int id;
    private String fullName;
    private String email;
    private String password;
    private int roleId;
    private String phone;
    private String address;
    private boolean gender; // true = Nam, false = Nữ
    private String dob;
    private String avatar;
    private String googleId;
    private String createDate;
    private boolean isDelete;
    private boolean emailVerified; // New field for email verification status
    
    public User() {
    }

    public User(String fullName, String email, String password, int roleId) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.roleId = roleId;
        this.emailVerified = false; // Default to false for new users
    }

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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getPhone() {
        if (phone == null || phone.isEmpty()) {
            return phone;
        }
        
        // If the phone number doesn't start with 0, add it
        if (!phone.startsWith("0")) {
            return "0" + phone;
        }
        
        return phone;
    }

    public void setPhone(String phone) {
        // If the phone number starts with 0, remove it for database storage as integer
        if (phone != null && phone.startsWith("0")) {
            this.phone = phone.substring(1);
        } else {
            this.phone = phone;
        }
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

    public String getGenderText() {
        return gender ? "Nam" : "Nữ";
    }

    public void setGenderFromText(String genderText) {
        this.gender = "Nam".equals(genderText);
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

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public String getCreateDate() {
        return createDate;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }

    public boolean isIsDelete() {
        return isDelete;
    }

    public void setIsDelete(boolean isDelete) {
        this.isDelete = isDelete;
    }
    
    public boolean isEmailVerified() {
        return emailVerified;
    }

    public void setEmailVerified(boolean emailVerified) {
        this.emailVerified = emailVerified;
    }
} 