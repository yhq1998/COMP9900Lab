package com.unsw.pojo;

import com.unsw.pojo.enums.OrderStatus;
import com.unsw.pojo.enums.OrderType;
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
public class Payment {
    private UUID id;
    private Integer orderId;
    private BigDecimal amount;
    private PaymentMethodType paymentMethod;
    private PaymentStatus status;
    private LocalDateTime createdAt;
}