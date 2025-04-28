package com.unsw.pojo;

import java.math.BigDecimal;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Payments {
    private Object id;

    private Integer orderId;

    private BigDecimal amount;

    private Object paymentMethod;

    private Object status;

    private Date createdAt;
}