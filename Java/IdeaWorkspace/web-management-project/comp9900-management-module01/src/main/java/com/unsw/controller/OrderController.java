package com.unsw.controller;

import com.unsw.pojo.Orders;
import com.unsw.pojo.Result;
import com.unsw.service.OrdersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/orders")
public class OrderController {

    @Autowired
    private OrdersService ordersService;

    /**
     * 查询所有订单
     * @return 订单列表
     */
    @GetMapping
    public Result list() {
        System.out.println("查询所有订单数据");
        List<Orders> ordersList = ordersService.findAll();
        return Result.success(ordersList);
    }

    /**
     * 根据ID查询订单
     * @param id 订单ID
     * @return 订单信息
     */
    @GetMapping("/{id}")
    public Result getById(@PathVariable Integer id) {
        System.out.println("根据ID查询订单: " + id);
        Orders order = ordersService.selectByPrimaryKey(id);
        if (order != null) {
            return Result.success(order);
        } else {
            return Result.error("订单不存在");
        }
    }

    /**
     * 创建新订单
     * @param order 订单信息
     * @return 创建结果
     */
    @PostMapping
    public Result save(@RequestBody Orders order) {
        System.out.println("创建新订单");
        // 设置创建时间和更新时间
        Date now = new Date();
        order.setCreatedAt(now);
        order.setUpdatedAt(now);
        
        int result = ordersService.insert(order);
        if (result > 0) {
            return Result.success(order);
        } else {
            return Result.error("创建订单失败");
        }
    }

    /**
     * 更新订单信息
     * @param id 订单ID
     * @param order 更新的订单信息
     * @return 更新结果
     */
    @PutMapping("/{id}")
    public Result update(@PathVariable Integer id, @RequestBody Orders order) {
        System.out.println("更新订单信息: " + id);
        order.setId(id);
        order.setUpdatedAt(new Date());
        
        int result = ordersService.updateByPrimaryKeySelective(order);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("更新订单失败");
        }
    }

    /**
     * 删除订单
     * @param id 订单ID
     * @return 删除结果
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        System.out.println("删除订单: " + id);
        int result = ordersService.deleteByPrimaryKey(id);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("删除订单失败");
        }
    }
}