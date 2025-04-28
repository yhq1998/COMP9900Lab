package com.unsw.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SystemLog {
    private Long id;
    private String username;    // 操作用户
    private String operation;   // 操作内容
    private String method;      // 请求方法
    private String params;      // 请求参数
    private String ip;          // 请求IP
    private Long time;          // 执行时长
    private String exception;   // 异常信息
    private LocalDateTime createTime; // 创建时间
    private String description; // 操作描述
    private String type;        // 日志类型（操作日志、异常日志）
}