package com.unsw.pojo;

import java.math.BigDecimal;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class GpsTracking {
    private Integer id;

    private Integer vehicleId;

    private BigDecimal latitude;

    private BigDecimal longitude;

    private Date timestamp;
}