package com.unsw.controller;

import com.unsw.pojo.Admin;
import com.unsw.pojo.Result;
import com.unsw.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理员控制器
 * 提供管理员的增删改查功能
 */
@RestController
@RequestMapping("/admins")
public class AdminController {

    @Autowired
    private AdminService adminService;
    
    /**
     * 查询所有管理员数据
     * @param username 用户名（可选）
     * @param page 页码
     * @param size 每页大小
     * @return 管理员列表
     */
    @GetMapping
    public Result list(
            @RequestParam(required = false) String username,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        System.out.println("查询所有管理员数据，参数：username=" + username + ", page=" + page + ", size=" + size);
        
        // 查询所有管理员数据
        List<Admin> adminList = adminService.findAll();
        
        // 构建返回结果，包含分页信息
        Map<String, Object> data = new HashMap<>();
        data.put("rows", adminList);
        data.put("total", adminList.size());
        
        return Result.success(data);
    }
    
    /**
     * 根据ID查询管理员
     * @param id 管理员ID
     * @return 管理员信息
     */
    @GetMapping("/{id}")
    public Result getById(@PathVariable Integer id) {
        System.out.println("根据ID查询管理员: " + id);
        Admin admin = adminService.findById(id);
        if (admin != null) {
            return Result.success(admin);
        } else {
            return Result.error("管理员不存在");
        }
    }
    
    /**
     * 创建新管理员
     * @param admin 管理员信息
     * @return 创建结果
     */
    @PostMapping
    public Result save(@RequestBody Admin admin) {
        System.out.println("创建新管理员");
        int result = adminService.save(admin);
        if (result > 0) {
            return Result.success(admin);
        } else {
            return Result.error("创建管理员失败");
        }
    }
    
    /**
     * 更新管理员信息
     * @param id 管理员ID
     * @param admin 更新的管理员信息
     * @return 更新结果
     */
    @PutMapping("/{id}")
    public Result update(@PathVariable Integer id, @RequestBody Admin admin) {
        System.out.println("更新管理员信息: " + id);
        admin.setId(id);
        
        int result = adminService.update(admin);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("更新管理员失败");
        }
    }
    
    /**
     * 删除管理员
     * @param id 管理员ID
     * @return 删除结果
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        System.out.println("删除管理员: " + id);
        int result = adminService.delete(id);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("删除管理员失败");
        }
    }
}