package com.unsw.pojo;

import com.unsw.pojo.enums.PaymentMethodType;
import com.unsw.pojo.enums.PaymentStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Trip {
    private Integer id;
    private Integer orderId;
    private Integer driverId;
    private Integer vehicleId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private BigDecimal distance;
}