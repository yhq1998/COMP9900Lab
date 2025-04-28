package com.unsw.pojo;

import java.math.BigDecimal;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Trips {
    private Integer id;

    private Integer orderId;

    private Integer driverId;

    private Integer vehicleId;

    private Date startTime;

    private Date endTime;

    private BigDecimal distance;
}