package com.unsw.pojo;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notifications {
    private Integer id;

    private String title;

    private String message;

    private Integer recipientId;

    private String notificationType;

    private Boolean isRead;

    private Date createdAt;

    private Date updatedAt;
}