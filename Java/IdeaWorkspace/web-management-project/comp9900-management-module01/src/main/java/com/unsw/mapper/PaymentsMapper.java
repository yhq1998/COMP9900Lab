package com.unsw.mapper;

import com.unsw.pojo.Payments;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface PaymentsMapper {
    /**
     * delete by primary key
     *
     * @param id primaryKey
     * @return deleteCount
     */
    int deleteByPrimaryKey(Object id);

    /**
     * insert record to table
     *
     * @param record the record
     * @return insert count
     */
    int insert(Payments record);

    /**
     * insert record to table selective
     *
     * @param record the record
     * @return insert count
     */
    int insertSelective(Payments record);

    /**
     * select by primary key
     *
     * @param id primary key
     * @return object by primary key
     */
    Payments selectByPrimaryKey(Object id);

    /**
     * update record selective
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKeySelective(Payments record);

    /**
     * update record
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKey(Payments record);
    
    /**
     * 分页查询支付记录
     * @param params 查询参数
     * @return 支付记录列表
     */
    List<Payments> findByPage(Map<String, Object> params);
    
    /**
     * 统计支付记录总数
     * @param params 查询条件
     * @return 支付记录总数
     */
    int countPayments(Map<String, Object> params);
    
    /**
     * 根据订单ID查询支付记录
     * @param orderId 订单ID
     * @return 支付记录列表
     */
    List<Payments> findByOrderId(Integer orderId);
    
    /**
     * 根据支付状态查询支付记录
     * @param status 支付状态
     * @return 支付记录列表
     */
    List<Payments> findByStatus(String status);
    
    /**
     * 根据支付方式查询支付记录
     * @param paymentMethod 支付方式
     * @return 支付记录列表
     */
    List<Payments> findByPaymentMethod(String paymentMethod);
    
    /**
     * 更新支付状态
     * @param params 包含id和status的参数
     * @return 更新结果
     */
    int updateStatus(Map<String, Object> params);
    
    /**
     * 更新退款信息
     * @param params 包含id，status，refundAmount和refundReason的参数
     * @return 更新结果
     */
    int updateRefundInfo(Map<String, Object> params);
}