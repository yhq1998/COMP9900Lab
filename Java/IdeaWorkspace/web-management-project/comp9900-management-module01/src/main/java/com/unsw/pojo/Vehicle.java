package com.unsw.pojo;

import com.unsw.pojo.enums.VehicleType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Vehicle {
    private Integer id;
    private VehicleType type;
    private String plateNumber;
    private String gpsLocation;  // 使用PostGIS时需要特殊处理
    private Boolean available;
    private LocalDateTime createdAt;
}