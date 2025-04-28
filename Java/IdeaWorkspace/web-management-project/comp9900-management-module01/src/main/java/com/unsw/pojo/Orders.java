package com.unsw.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Orders {
    private Integer id;

    private String orderNumber;

    private Integer userId;

    private Integer driverId;

    private Integer vehicleId;

    private Object orderType;

    private String startLocation;

    private String endLocation;

    private Integer estimatedTime;

    private BigDecimal fare;

    private Integer passengerCount;

    private String luggageInfo;

    private Object status;

    private Date createdAt;

    private Date updatedAt;

    // Explicitly add getter and setter for id
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    // Explicitly add getter and setter for createdAt
    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // Explicitly add getter and setter for updatedAt
    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}