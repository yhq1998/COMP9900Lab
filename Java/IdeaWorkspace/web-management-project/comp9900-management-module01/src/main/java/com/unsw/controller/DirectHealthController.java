package com.unsw.controller;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * 直接使用Servlet API响应，绕过Spring框架的AOP和其他处理
 */
@RestController
public class DirectHealthController {

    @GetMapping("/health")
    public void healthCheck(HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter writer = response.getWriter();
        writer.write("{\"status\":\"UP\",\"message\":\"服务正常运行\",\"timestamp\":" + System.currentTimeMillis() + "}");
        writer.flush();
    }
} 