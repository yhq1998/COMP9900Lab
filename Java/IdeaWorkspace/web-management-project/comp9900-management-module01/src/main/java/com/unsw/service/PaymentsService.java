package com.unsw.service;

import com.unsw.pojo.Payments;
import java.util.List;
import java.util.Map;

public interface PaymentsService{

    int deleteByPrimaryKey(Object id);

    int insert(Payments record);

    int insertSelective(Payments record);

    Payments selectByPrimaryKey(Object id);

    int updateByPrimaryKeySelective(Payments record);

    int updateByPrimaryKey(Payments record);
    
    /**
     * 分页查询支付记录
     * @param params 包含分页参数(page, size)和查询条件(orderId, status, paymentMethod)
     * @return 分页结果，包含数据和总数
     */
    Map<String, Object> findByPage(Map<String, Object> params);
    
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
     * @param id 支付ID
     * @param status 新状态
     * @return 更新结果
     */
    int updateStatus(Object id, String status);
    
    /**
     * 处理退款
     * @param id 支付ID
     * @param refundAmount 退款金额
     * @param reason 退款原因
     * @return 处理结果
     */
    int processRefund(Object id, java.math.BigDecimal refundAmount, String reason);
}
