package com.unsw.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.filter.CorsFilter;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

    private final CorsFilter corsFilter;

    // 注入CorsFilter，而不是重新创建
    public WebSecurityConfig(CorsFilter corsFilter) {
        this.corsFilter = corsFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // 针对Docker部署临时配置：暂时禁用安全限制，允许所有请求通过
        http.csrf(csrf -> csrf.disable())
            // 添加CORS过滤器
            .addFilterBefore(corsFilter, UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(authorize -> authorize
                // 允许所有请求，以便排除其他问题
                .anyRequest().permitAll()
            );
        
        return http.build();
    }
} 