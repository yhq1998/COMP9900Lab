package com.unsw.service;

import com.unsw.pojo.Orders;
import java.util.List;
import java.util.Map;

public interface OrdersService {

    int deleteByPrimaryKey(Integer id);

    int insert(Orders record);

    int insertSelective(Orders record);

    Orders selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Orders record);

    int updateByPrimaryKey(Orders record);
    
    List<Orders> findAll();
    
    /**
     * 分页查询订单列表
     *
     * @param params 查询参数
     * @return 订单列表及总数
     */
    Map<String, Object> getOrderList(Map<String, Object> params);
    
    /**
     * 获取订单详情
     *
     * @param id 订单ID
     * @return 订单详情
     */
    Map<String, Object> getOrderDetail(Integer id);
    
    /**
     * 更新订单状态
     *
     * @param id 订单ID
     * @param status 新状态
     * @return 更新结果
     */
    int updateOrderStatus(Integer id, String status);
    
    /**
     * 根据用户ID查询订单
     *
     * @param userId 用户ID
     * @return 订单列表
     */
    List<Orders> findByUserId(Integer userId);
    
    /**
     * 根据司机ID查询订单
     *
     * @param driverId 司机ID
     * @return 订单列表
     */
    List<Orders> findByDriverId(Integer driverId);
    
    /**
     * 生成订单号
     *
     * @return 唯一订单号
     */
    String generateOrderNumber();
}
