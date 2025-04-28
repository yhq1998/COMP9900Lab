package com.unsw.pojo;

import java.math.BigDecimal;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Promotions {
    private Integer id;

    private String code;

    private String title;

    private String description;

    private BigDecimal discount;

    private Date startDate;

    private Date endDate;

    private Boolean active;

    private Date createdAt;

    private Date updatedAt;
}