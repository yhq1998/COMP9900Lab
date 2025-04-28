package com.unsw.service;

import org.springframework.stereotype.Service;

import org.springframework.beans.factory.annotation.Autowired;

import com.unsw.mapper.OrdersMapper;
import com.unsw.mapper.UsersMapper;
import com.unsw.mapper.DriversMapper;
import com.unsw.mapper.VehiclesMapper;
import com.unsw.pojo.Orders;
import com.unsw.pojo.Users;
import com.unsw.pojo.Drivers;
import com.unsw.pojo.Vehicles;
import com.unsw.service.OrdersService;

import java.util.*;
import java.text.SimpleDateFormat;

@Service
public class OrdersServiceImpl implements OrdersService{

    @Autowired
    private OrdersMapper ordersMapper;
    
    @Autowired
    private UsersMapper usersMapper;
    
    @Autowired
    private DriversMapper driversMapper;
    
    @Autowired
    private VehiclesMapper vehiclesMapper;

    @Override
    public int deleteByPrimaryKey(Integer id) {
        return ordersMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(Orders record) {
        // 设置订单创建和更新时间
        Date now = new Date();
        record.setCreatedAt(now);
        record.setUpdatedAt(now);
        
        // 如果没有订单号，则生成一个
        if (record.getOrderNumber() == null || record.getOrderNumber().isEmpty()) {
            record.setOrderNumber(generateOrderNumber());
        }
        
        // 如果没有设置状态，默认为待处理
        if (record.getStatus() == null) {
            record.setStatus("pending");
        }
        
        return ordersMapper.insert(record);
    }

    @Override
    public int insertSelective(Orders record) {
        // 设置订单创建和更新时间
        Date now = new Date();
        if (record.getCreatedAt() == null) {
            record.setCreatedAt(now);
        }
        record.setUpdatedAt(now);
        
        // 如果没有订单号，则生成一个
        if (record.getOrderNumber() == null || record.getOrderNumber().isEmpty()) {
            record.setOrderNumber(generateOrderNumber());
        }
        
        // 如果没有设置状态，默认为待处理
        if (record.getStatus() == null) {
            record.setStatus("pending");
        }
        
        return ordersMapper.insertSelective(record);
    }

    @Override
    public Orders selectByPrimaryKey(Integer id) {
        return ordersMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(Orders record) {
        // 更新时间
        record.setUpdatedAt(new Date());
        return ordersMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(Orders record) {
        // 更新时间
        record.setUpdatedAt(new Date());
        return ordersMapper.updateByPrimaryKey(record);
    }
    
    @Override
    public List<Orders> findAll() {
        return ordersMapper.findAll();
    }
    
    @Override
    public Map<String, Object> getOrderList(Map<String, Object> params) {
        // 获取分页参数
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int pageSize = params.get("pageSize") != null ? Integer.parseInt(params.get("pageSize").toString()) : 10;
        
        // 设置分页参数
        params.put("offset", (page - 1) * pageSize);
        params.put("limit", pageSize);
        
        // 查询订单列表和总数
        List<Orders> orderList = ordersMapper.findByParams(params);
        int total = ordersMapper.countByParams(params);
        
        // 组装返回数据
        List<Map<String, Object>> resultList = new ArrayList<>();
        for (Orders order : orderList) {
            Map<String, Object> orderMap = new HashMap<>();
            orderMap.put("id", order.getId());
            orderMap.put("orderNo", order.getOrderNumber());
            
            // 获取用户信息
            Users user = usersMapper.selectByPrimaryKey(order.getUserId());
            orderMap.put("passengerName", user != null ? user.getUsername() : "");
            
            // 获取司机信息
            if (order.getDriverId() != null) {
                Drivers driver = driversMapper.selectByPrimaryKey(order.getDriverId());
                orderMap.put("driverName", driver != null ? driver.getFullName() : "");
            } else {
                orderMap.put("driverName", "未分配");
            }
            
            // 获取车辆信息
            if (order.getVehicleId() != null) {
                Vehicles vehicle = vehiclesMapper.selectByPrimaryKey(order.getVehicleId());
                orderMap.put("vehicleInfo", vehicle != null ? vehicle.getPlateNumber() : "");
            } else {
                orderMap.put("vehicleInfo", "未分配");
            }
            
            orderMap.put("orderType", order.getOrderType());
            orderMap.put("fromLocation", order.getStartLocation());
            orderMap.put("toLocation", order.getEndLocation());
            orderMap.put("estimatedTime", order.getEstimatedTime());
            orderMap.put("amount", order.getFare());
            orderMap.put("passengerCount", order.getPassengerCount());
            orderMap.put("luggageInfo", order.getLuggageInfo());
            orderMap.put("status", order.getStatus());
            orderMap.put("createTime", order.getCreatedAt());
            orderMap.put("updateTime", order.getUpdatedAt());
            
            resultList.add(orderMap);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("data", resultList);
        result.put("total", total);
        
        return result;
    }
    
    @Override
    public Map<String, Object> getOrderDetail(Integer id) {
        Orders order = ordersMapper.selectByPrimaryKey(id);
        if (order == null) {
            return null;
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("id", order.getId());
        result.put("orderNo", order.getOrderNumber());
        result.put("orderType", order.getOrderType());
        
        // 获取用户信息
        Users user = usersMapper.selectByPrimaryKey(order.getUserId());
        result.put("userId", order.getUserId());
        result.put("passengerName", user != null ? user.getUsername() : "");
        result.put("passengerPhone", user != null ? user.getPhoneNumber() : "");
        
        // 获取司机信息
        if (order.getDriverId() != null) {
            Drivers driver = driversMapper.selectByPrimaryKey(order.getDriverId());
            result.put("driverId", order.getDriverId());
            result.put("driverName", driver != null ? driver.getFullName() : "");
        } else {
            result.put("driverName", "未分配");
        }
        
        // 获取车辆信息
        if (order.getVehicleId() != null) {
            Vehicles vehicle = vehiclesMapper.selectByPrimaryKey(order.getVehicleId());
            result.put("vehicleId", order.getVehicleId());
            result.put("vehicleInfo", vehicle != null ? vehicle.getPlateNumber() : "");
        } else {
            result.put("vehicleInfo", "未分配");
        }
        
        result.put("fromLocation", order.getStartLocation());
        result.put("toLocation", order.getEndLocation());
        result.put("estimatedTime", order.getEstimatedTime() + " 分钟");
        result.put("amount", order.getFare());
        result.put("passengerCount", order.getPassengerCount());
        result.put("luggageInfo", order.getLuggageInfo());
        result.put("status", order.getStatus());
        result.put("createTime", order.getCreatedAt());
        result.put("updateTime", order.getUpdatedAt());
        
        return result;
    }
    
    @Override
    public int updateOrderStatus(Integer id, String status) {
        Orders order = new Orders();
        order.setId(id);
        order.setStatus(status);
        order.setUpdatedAt(new Date());
        
        return ordersMapper.updateByPrimaryKeySelective(order);
    }
    
    @Override
    public List<Orders> findByUserId(Integer userId) {
        return ordersMapper.findByUserId(userId);
    }
    
    @Override
    public List<Orders> findByDriverId(Integer driverId) {
        return ordersMapper.findByDriverId(driverId);
    }
    
    @Override
    public String generateOrderNumber() {
        // 生成订单号：年月日时分秒 + 4位随机数
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        Random random = new Random();
        int randomNum = random.nextInt(10000);
        
        return sdf.format(new Date()) + String.format("%04d", randomNum);
    }
}
