package com.unsw.controller;

import com.unsw.mapper.SystemLogMapper;
import com.unsw.pojo.Result;
import com.unsw.pojo.SystemLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/system-logs")
public class SystemLogController {

    @Autowired
    private SystemLogMapper systemLogMapper;

    /**
     * 分页查询系统日志
     */
    @GetMapping
    public Result getSystemLogs(
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String type,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        
        // 根据条件查询日志
        List<SystemLog> logs;
        if (username != null && !username.isEmpty()) {
            logs = systemLogMapper.findByUsername(username);
        } else if (type != null && !type.isEmpty()) {
            logs = systemLogMapper.findByType(type);
        } else {
            logs = systemLogMapper.findAll();
        }
        
        // 简单分页处理
        int start = (page - 1) * size;
        int end = Math.min(start + size, logs.size());
        List<SystemLog> pagedLogs = logs.subList(start, end);
        
        Map<String, Object> data = new HashMap<>();
        data.put("records", pagedLogs);
        data.put("total", logs.size());
        data.put("size", size);
        data.put("current", page);
        
        return Result.success(data);
    }

    /**
     * 获取日志详情
     */
    @GetMapping("/{id}")
    public Result getSystemLogById(@PathVariable Long id) {
        // 这里需要添加根据ID查询的方法，暂时返回空结果
        return Result.success(null);
    }

    /**
     * 删除日志
     */
    @DeleteMapping("/{id}")
    public Result deleteSystemLog(@PathVariable Long id) {
        // 删除指定ID的日志
        // systemLogMapper.deleteById(id); // 需要在Mapper中添加此方法
        return Result.success();
    }

    /**
     * 清空指定类型的日志
     */
    @DeleteMapping("/type/{type}")
    public Result clearSystemLogByType(@PathVariable String type) {
        systemLogMapper.deleteByType(type);
        return Result.success();
    }
}