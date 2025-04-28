package com.unsw.pojo;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Vehicles {
    private Integer id;

    private String type; // Changed from Object to String to match ENUM handling

    private String plateNumber;

    private String gpsLocation; // Changed from Object to String for WKT representation

    private Boolean available;

    private Date createdAt;
    
    private Date updatedAt;
    // Lombok should handle getters and setters
}