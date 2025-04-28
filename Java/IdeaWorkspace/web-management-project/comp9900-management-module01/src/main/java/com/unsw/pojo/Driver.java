package com.unsw.pojo;

import com.unsw.pojo.enums.DriverStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Driver {
    private Integer id;
    private String username;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String password;
    private String photo;
    private String driverLicenseNumber;
    private String vehicle;
    private DriverStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}