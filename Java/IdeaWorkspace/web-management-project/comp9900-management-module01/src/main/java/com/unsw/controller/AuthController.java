package com.unsw.controller;

import com.unsw.pojo.Admin;
import com.unsw.pojo.Result;
import com.unsw.pojo.Users;
import com.unsw.service.AdminService;
import com.unsw.service.UsersService;
import com.unsw.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private AuthenticationManager authenticationManager;
    
    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/register")
    public Result register(@RequestBody Admin admin) {
        // 检查用户名是否已存在
        if (adminService.findByUsername(admin.getUsername()) != null) {
            return Result.error("管理员用户名已存在");
        }

        // 加密密码
        admin.setPassword(passwordEncoder.encode(admin.getPassword()));
        // 设置角色
        admin.setRole("ADMIN");

        // 保存管理员
        adminService.save(admin);

        return Result.success();
    }

    @PostMapping("/admin/login")
    public Result adminLogin(@RequestBody Admin admin) {
        try {
            Admin existingAdmin = adminService.findByUsername(admin.getUsername());
            if (existingAdmin != null && passwordEncoder.matches(admin.getPassword(), existingAdmin.getPassword())) {
                String token = jwtUtil.generateToken(existingAdmin.getUsername());
                Map<String, Object> data = new HashMap<>();
                data.put("token", token);
                data.put("admin", existingAdmin);
                data.put("role", "ADMIN");
                return Result.success(data);
            }
            return Result.error("管理员用户名或密码错误");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("管理员登录失败: " + e.getMessage());
        }
    }

    @PostMapping("/logout")
    public Result logout() {
        SecurityContextHolder.clearContext();
        return Result.success("退出成功");
    }
}