package com.unsw.controller;

import com.unsw.pojo.Result;
import com.unsw.pojo.User;
import com.unsw.pojo.Users;
import com.unsw.service.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/passengers")
public class UserController {

    @Autowired
    private UsersService usersService;
    
    /**
     * 查询所有用户（乘客）数据
     * @param username 用户名（可选）
     * @param page 页码
     * @param size 每页大小
     * @return 用户列表
     */
    @GetMapping
    public Result list(
            @RequestParam(required = false) String username,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        System.out.println("查询所有用户(乘客)数据，参数：username=" + username + ", page=" + page + ", size=" + size);
        
        // 查询所有用户数据
        List<Users> userList = usersService.findAll();
        
        // 构建返回结果，包含分页信息
        Map<String, Object> data = new HashMap<>();
        data.put("rows", userList);
        data.put("total", userList.size());
        
        return Result.success(data);
    }
    
    /**
     * 根据ID查询用户
     * @param id 用户ID
     * @return 用户信息
     */
    @GetMapping("/{id}")
    public Result getById(@PathVariable Integer id) {
        System.out.println("根据ID查询用户: " + id);
        Users user = usersService.selectByPrimaryKey(id);
        if (user != null) {
            return Result.success(user);
        } else {
            return Result.error("用户不存在");
        }
    }
    
    /**
     * 创建新用户
     * @param user 用户信息
     * @return 创建结果
     */
    @PostMapping
    public Result save(@RequestBody Users user) {
        System.out.println("创建新用户");
        int result = usersService.save(user);
        if (result > 0) {
            return Result.success(user);
        } else {
            return Result.error("创建用户失败");
        }
    }
    
    /**
     * 更新用户信息
     * @param id 用户ID
     * @param user 更新的用户信息
     * @return 更新结果
     */
    @PutMapping("/{id}")
    public Result update(@PathVariable Integer id, @RequestBody Users user) {
        System.out.println("更新用户信息: " + id);
        user.setId(id);
        
        int result = usersService.updateByPrimaryKeySelective(user);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("更新用户失败");
        }
    }
    
    /**
     * 删除用户
     * @param id 用户ID
     * @return 删除结果
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        System.out.println("删除用户: " + id);
        int result = usersService.deleteByPrimaryKey(id);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("删除用户失败");
        }
    }
}
