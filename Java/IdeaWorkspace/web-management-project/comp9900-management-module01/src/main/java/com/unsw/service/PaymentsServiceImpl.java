package com.unsw.service;

import org.springframework.stereotype.Service;

import org.springframework.beans.factory.annotation.Autowired;

import com.unsw.mapper.PaymentsMapper;
import com.unsw.pojo.Payments;
import com.unsw.service.PaymentsService;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PaymentsServiceImpl implements PaymentsService{

    @Autowired
    private PaymentsMapper paymentsMapper;

    @Override
    public int deleteByPrimaryKey(Object id) {
        return paymentsMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(Payments record) {
        // 设置创建时间
        if (record.getCreatedAt() == null) {
            record.setCreatedAt(new Date());
        }
        return paymentsMapper.insert(record);
    }

    @Override
    public int insertSelective(Payments record) {
        // 设置创建时间
        if (record.getCreatedAt() == null) {
            record.setCreatedAt(new Date());
        }
        return paymentsMapper.insertSelective(record);
    }

    @Override
    public Payments selectByPrimaryKey(Object id) {
        return paymentsMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(Payments record) {
        return paymentsMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(Payments record) {
        return paymentsMapper.updateByPrimaryKey(record);
    }
    
    @Override
    public Map<String, Object> findByPage(Map<String, Object> params) {
        // 查询数据
        List<Payments> payments = paymentsMapper.findByPage(params);
        // 查询总数
        int total = paymentsMapper.countPayments(params);
        
        Map<String, Object> result = new HashMap<>();
        result.put("records", payments);
        result.put("total", total);
        
        return result;
    }
    
    @Override
    public List<Payments> findByOrderId(Integer orderId) {
        return paymentsMapper.findByOrderId(orderId);
    }
    
    @Override
    public List<Payments> findByStatus(String status) {
        return paymentsMapper.findByStatus(status);
    }
    
    @Override
    public List<Payments> findByPaymentMethod(String paymentMethod) {
        return paymentsMapper.findByPaymentMethod(paymentMethod);
    }
    
    @Override
    public int updateStatus(Object id, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        params.put("status", status);
        
        return paymentsMapper.updateStatus(params);
    }
    
    @Override
    public int processRefund(Object id, BigDecimal refundAmount, String reason) {
        // 首先检查支付记录是否存在
        Payments payment = selectByPrimaryKey(id);
        if (payment == null) {
            return 0;
        }
        
        // 检查退款金额是否合理
        if (refundAmount.compareTo(payment.getAmount()) > 0) {
            // 退款金额不能大于支付金额
            return -1;
        }
        
        // 更新支付状态为已退款
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        params.put("status", "refunded");
        params.put("refundAmount", refundAmount);
        params.put("refundReason", reason);
        
        return paymentsMapper.updateRefundInfo(params);
    }
}
