package com.unsw.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private Integer id;
    private String username;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String password;
    private String photo;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}