package com.unsw.pojo;

import com.unsw.pojo.enums.OrderStatus;
import com.unsw.pojo.enums.OrderType;
import com.unsw.pojo.enums.VehicleType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order {
    private Integer id;
    private String orderNumber;
    private Integer userId;
    private Integer driverId;
    private Integer vehicleId;
    private OrderType orderType;
    private String startLocation;
    private String endLocation;
    private Integer estimatedTime;
    private BigDecimal fare;
    private Integer passengerCount;
    private String luggageInfo;
    private OrderStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}