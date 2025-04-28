package com.unsw.pojo;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Feedback {
    private Integer id;

    private Integer orderId;

    private Integer rating;

    private Date createdAt;
}