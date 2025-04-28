package com.unsw.controller;

import com.unsw.pojo.Payments;
import com.unsw.pojo.Result;
import com.unsw.service.PaymentsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/payments")
public class PaymentController {

    @Autowired
    private PaymentsService paymentsService;

    /**
     * 分页查询支付记录
     * @param orderId 订单ID
     * @param status 支付状态
     * @param paymentMethod 支付方式
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @param page 页码
     * @param size 每页大小
     * @return 分页结果
     */
    @GetMapping
    public Result list(
            @RequestParam(required = false) Integer orderId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String paymentMethod,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        
        System.out.println("分页查询支付记录: page=" + page + ", size=" + size);
        
        Map<String, Object> params = new HashMap<>();
        params.put("orderId", orderId);
        params.put("status", status);
        params.put("paymentMethod", paymentMethod);
        params.put("page", page);
        params.put("size", size);
        
        // 处理日期范围
        if (startDate != null && !startDate.isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                params.put("startDate", sdf.parse(startDate));
            } catch (ParseException e) {
                return Result.error("开始日期格式错误，请使用yyyy-MM-dd格式");
            }
        }
        
        if (endDate != null && !endDate.isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date end = sdf.parse(endDate);
                // 将结束日期设置为当天的23:59:59
                end.setHours(23);
                end.setMinutes(59);
                end.setSeconds(59);
                params.put("endDate", end);
            } catch (ParseException e) {
                return Result.error("结束日期格式错误，请使用yyyy-MM-dd格式");
            }
        }
        
        Map<String, Object> result = paymentsService.findByPage(params);
        return Result.success(result);
    }

    /**
     * 根据ID查询支付记录
     * @param id 支付记录ID
     * @return 支付记录信息
     */
    @GetMapping("/{id}")
    public Result getById(@PathVariable Object id) {
        System.out.println("根据ID查询支付记录: " + id);
        Payments payment = paymentsService.selectByPrimaryKey(id);
        if (payment != null) {
            return Result.success(payment);
        } else {
            return Result.error("支付记录不存在");
        }
    }

    /**
     * 根据订单ID查询支付记录
     * @param orderId 订单ID
     * @return 支付记录列表
     */
    @GetMapping("/order/{orderId}")
    public Result getByOrderId(@PathVariable Integer orderId) {
        System.out.println("根据订单ID查询支付记录: " + orderId);
        return Result.success(paymentsService.findByOrderId(orderId));
    }

    /**
     * 创建新支付记录
     * @param payment 支付记录信息
     * @return 创建结果
     */
    @PostMapping
    public Result save(@RequestBody Payments payment) {
        System.out.println("创建新支付记录");
        // 设置创建时间
        payment.setCreatedAt(new Date());
        
        // 如果未设置状态，默认设置为pending
        if (payment.getStatus() == null || payment.getStatus().toString().isEmpty()) {
            payment.setStatus("pending");
        }
        
        int result = paymentsService.insert(payment);
        if (result > 0) {
            return Result.success(payment);
        } else {
            return Result.error("创建支付记录失败");
        }
    }

    /**
     * 更新支付记录信息
     * @param id 支付记录ID
     * @param payment 更新的支付记录信息
     * @return 更新结果
     */
    @PutMapping("/{id}")
    public Result update(@PathVariable Object id, @RequestBody Payments payment) {
        System.out.println("更新支付记录信息: " + id);
        payment.setId(id);
        
        int result = paymentsService.updateByPrimaryKeySelective(payment);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("更新支付记录失败");
        }
    }

    /**
     * 更新支付状态
     * @param id 支付记录ID
     * @param status 新状态
     * @return 更新结果
     */
    @PutMapping("/{id}/status")
    public Result updateStatus(
            @PathVariable Object id,
            @RequestParam String status) {
        System.out.println("更新支付状态: " + id + " -> " + status);
        
        int result = paymentsService.updateStatus(id, status);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("更新支付状态失败");
        }
    }

    /**
     * 处理支付确认
     * @param id 支付记录ID
     * @param paymentMethod 支付方式
     * @param transactionId 交易号
     * @return 处理结果
     */
    @PostMapping("/{id}/confirm")
    public Result confirmPayment(
            @PathVariable Object id,
            @RequestParam String paymentMethod,
            @RequestParam(required = false) String transactionId) {
        System.out.println("确认支付: " + id);
        
        // 首先获取支付记录
        Payments payment = paymentsService.selectByPrimaryKey(id);
        if (payment == null) {
            return Result.error("支付记录不存在");
        }
        
        // 更新支付记录
        payment.setPaymentMethod(paymentMethod);
        payment.setStatus("paid");
        // 在实际应用中，可能还需要记录transaction_id等字段
        
        int result = paymentsService.updateByPrimaryKeySelective(payment);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("确认支付失败");
        }
    }

    /**
     * 处理退款
     * @param id 支付记录ID
     * @param refundAmount 退款金额
     * @param reason 退款原因
     * @return 处理结果
     */
    @PostMapping("/{id}/refund")
    public Result refund(
            @PathVariable Object id,
            @RequestParam BigDecimal refundAmount,
            @RequestParam String reason) {
        System.out.println("退款: " + id + ", 金额: " + refundAmount);
        
        int result = paymentsService.processRefund(id, refundAmount, reason);
        if (result > 0) {
            return Result.success();
        } else if (result == -1) {
            return Result.error("退款金额不能大于支付金额");
        } else {
            return Result.error("退款处理失败");
        }
    }

    /**
     * 取消支付
     * @param id 支付记录ID
     * @return 取消结果
     */
    @PostMapping("/{id}/cancel")
    public Result cancel(@PathVariable Object id) {
        System.out.println("取消支付: " + id);
        
        int result = paymentsService.updateStatus(id, "cancelled");
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("取消支付失败");
        }
    }

    /**
     * 删除支付记录
     * @param id 支付记录ID
     * @return 删除结果
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Object id) {
        System.out.println("删除支付记录: " + id);
        int result = paymentsService.deleteByPrimaryKey(id);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("删除支付记录失败");
        }
    }
}