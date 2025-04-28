package com.unsw.mapper;

import com.unsw.pojo.Orders;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface OrdersMapper {
    /**
     * delete by primary key
     *
     * @param id primaryKey
     * @return deleteCount
     */
    int deleteByPrimaryKey(Integer id);

    /**
     * insert record to table
     *
     * @param record the record
     * @return insert count
     */
    int insert(Orders record);

    /**
     * insert record to table selective
     *
     * @param record the record
     * @return insert count
     */
    int insertSelective(Orders record);

    /**
     * select by primary key
     *
     * @param id primary key
     * @return object by primary key
     */
    Orders selectByPrimaryKey(Integer id);

    /**
     * update record selective
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKeySelective(Orders record);

    /**
     * update record
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKey(Orders record);
    
    /**
     * 查询所有订单
     * 
     * @return 订单列表
     */
    List<Orders> findAll();
    
    /**
     * 根据参数查询订单列表
     *
     * @param params 查询参数
     * @return 订单列表
     */
    List<Orders> findByParams(Map<String, Object> params);
    
    /**
     * 根据参数统计订单数量
     *
     * @param params 查询参数
     * @return 订单数量
     */
    int countByParams(Map<String, Object> params);
    
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
     * 根据订单状态查询订单
     *
     * @param status 订单状态
     * @return 订单列表
     */
    List<Orders> findByStatus(String status);
}