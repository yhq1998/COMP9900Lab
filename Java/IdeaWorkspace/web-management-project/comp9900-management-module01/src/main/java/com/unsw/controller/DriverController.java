package com.unsw.controller;

import com.unsw.pojo.Drivers;
import com.unsw.pojo.Result;
import com.unsw.pojo.enums.DriverStatus;
import com.unsw.service.DriversService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/drivers")
public class DriverController {

    @Autowired
    private DriversService driversService;

    /**
     * 分页查询司机列表
     * @param username 用户名
     * @param phoneNumber 手机号
     * @param status 状态
     * @param page 页码
     * @param size 每页大小
     * @return 分页结果
     */
    @GetMapping
    public Result list(
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String phoneNumber,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        
        System.out.println("分页查询司机数据: page=" + page + ", size=" + size);
        
        Map<String, Object> params = new HashMap<>();
        params.put("username", username);
        params.put("phoneNumber", phoneNumber);
        params.put("status", status);
        params.put("page", page);
        params.put("size", size);
        
        Map<String, Object> result = driversService.findByPage(params);
        return Result.success(result);
    }

    /**
     * 查询所有司机（不分页）
     * @return 司机列表
     */
    @GetMapping("/all")
    public Result listAll() {
        System.out.println("查询所有司机数据");
        List<Drivers> driversList = driversService.findAll();
        return Result.success(driversList);
    }

    /**
     * 根据ID查询司机
     * @param id 司机ID
     * @return 司机信息
     */
    @GetMapping("/{id}")
    public Result getById(@PathVariable Integer id) {
        System.out.println("根据ID查询司机: " + id);
        Drivers driver = driversService.selectByPrimaryKey(id);
        if (driver != null) {
            return Result.success(driver);
        } else {
            return Result.error("司机不存在");
        }
    }

    /**
     * 创建新司机
     * @param driver 司机信息
     * @return 创建结果
     */
    @PostMapping
    public Result save(@RequestBody Drivers driver) {
        System.out.println("创建新司机: " + driver.getUsername());
        
        // 验证必填字段
        if (driver.getUsername() == null || driver.getUsername().trim().isEmpty()) {
            return Result.error("用户名不能为空");
        }
        if (driver.getPhoneNumber() == null || driver.getPhoneNumber().trim().isEmpty()) {
            return Result.error("手机号不能为空");
        }
        if (driver.getPassword() == null || driver.getPassword().trim().isEmpty()) {
            return Result.error("密码不能为空");
        }
        
        // 检查用户名和手机号是否已存在
        if (driversService.checkUsernameExists(driver.getUsername())) {
            return Result.error("用户名已存在");
        }
        if (driversService.checkPhoneNumberExists(driver.getPhoneNumber())) {
            return Result.error("手机号已存在");
        }
        
        // 设置默认状态
        if (driver.getStatus() == null || driver.getStatus().trim().isEmpty()) {
            driver.setStatus("available");
        }
        
        // 设置创建时间和更新时间
        Date now = new Date();
        driver.setCreatedAt(now);
        driver.setUpdatedAt(now);
        
        try {
            int result = driversService.insert(driver);
            if (result > 0) {
                return Result.success(driver);
            } else {
                return Result.error("创建司机失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("创建司机失败: " + e.getMessage());
        }
    }

    /**
     * 更新司机信息
     * @param id 司机ID
     * @param driver 更新的司机信息
     * @return 更新结果
     */
    @PutMapping("/{id}")
    public Result update(@PathVariable Integer id, @RequestBody Drivers driver) {
        System.out.println("更新司机信息: " + id);
        
        // 检查司机是否存在
        if (driversService.selectByPrimaryKey(id) == null) {
            return Result.error("司机不存在");
        }
        
        // 设置ID和更新时间
        driver.setId(id);
        driver.setUpdatedAt(new Date());
        
        try {
            int result = driversService.updateByPrimaryKeySelective(driver);
            if (result > 0) {
                return Result.success();
            } else {
                return Result.error("更新司机失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新司机失败: " + e.getMessage());
        }
    }

    /**
     * 更新司机状态
     * @param id 司机ID
     * @param statusMap 包含状态的Map
     * @return 更新结果
     */
    @PutMapping("/{id}/status")
    public Result updateStatus(@PathVariable Integer id, @RequestBody Map<String, String> statusMap) {
        String status = statusMap.get("status");
        System.out.println("更新司机状态: " + id + ", 新状态: " + status);
        
        // 验证状态值
        if (status == null || status.trim().isEmpty()) {
            return Result.error("状态不能为空");
        }
        
        try {
            // 验证状态是否合法
            try {
                DriverStatus.fromString(status);
            } catch (IllegalArgumentException e) {
                return Result.error("无效的状态值，必须是 available、busy 或 offline");
            }
            
            int result = driversService.updateStatus(id, status);
            if (result > 0) {
                return Result.success();
            } else {
                return Result.error("更新状态失败，可能司机不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新状态失败: " + e.getMessage());
        }
    }

    /**
     * 删除司机
     * @param id 司机ID
     * @return 删除结果
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        System.out.println("删除司机: " + id);
        try {
            int result = driversService.deleteByPrimaryKey(id);
            if (result > 0) {
                return Result.success();
            } else {
                return Result.error("删除司机失败，可能司机不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("删除司机失败: " + e.getMessage());
        }
    }
}