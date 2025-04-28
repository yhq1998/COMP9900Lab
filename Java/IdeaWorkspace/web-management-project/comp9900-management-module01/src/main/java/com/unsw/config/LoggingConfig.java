package com.unsw.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Profile;

/**
 * 禁用生产环境中的日志记录功能
 */
@Configuration
@EnableAspectJAutoProxy
public class LoggingConfig {
    // 配置类存在，但不配置任何AOP切面，从而禁用日志记录功能
} 