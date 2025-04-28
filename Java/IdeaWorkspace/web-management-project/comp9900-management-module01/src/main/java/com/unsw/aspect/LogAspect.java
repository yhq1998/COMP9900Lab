package com.unsw.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.unsw.mapper.SystemLogMapper;
import com.unsw.pojo.SystemLog;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.lang.reflect.Method;
import java.time.LocalDateTime;
import java.util.Arrays;

@Aspect
@Component
public class LogAspect {

    @Autowired
    private SystemLogMapper systemLogMapper;

    @Autowired
    private ObjectMapper objectMapper;

    @Pointcut("@annotation(org.springframework.web.bind.annotation.RequestMapping) || " +
            "@annotation(org.springframework.web.bind.annotation.GetMapping) || " +
            "@annotation(org.springframework.web.bind.annotation.PostMapping) || " +
            "@annotation(org.springframework.web.bind.annotation.PutMapping) || " +
            "@annotation(org.springframework.web.bind.annotation.DeleteMapping)")
    public void webLog() {}

    @Around("webLog()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        long beginTime = System.currentTimeMillis();
        
        // 执行方法
        Object result = null;
        try {
            result = point.proceed();
        } catch (Throwable e) {
            saveLog(point, beginTime, e);
            throw e;
        }
        
        // 执行时长(毫秒)
        long time = System.currentTimeMillis() - beginTime;
        // 保存日志
        saveLog(point, time, null);
        
        return result;
    }

    private void saveLog(ProceedingJoinPoint joinPoint, long time, Throwable e) {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        SystemLog systemLog = new SystemLog();
        
        // 请求的方法名
        String className = joinPoint.getTarget().getClass().getName();
        String methodName = method.getName();
        systemLog.setMethod(className + "." + methodName + "()");
        
        // 请求的参数
        Object[] args = joinPoint.getArgs();
        try {
            String params = objectMapper.writeValueAsString(args);
            systemLog.setParams(params);
        } catch (Exception ex) {
            systemLog.setParams(Arrays.toString(args));
        }

        // 获取request
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes != null) {
            HttpServletRequest request = attributes.getRequest();
            // 设置IP地址
            systemLog.setIp(request.getRemoteAddr());
        }

        // 获取当前用户
        try {
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            systemLog.setUsername(username);
        } catch (Exception ex) {
            systemLog.setUsername("anonymous");
        }

        systemLog.setTime(time);
        systemLog.setCreateTime(LocalDateTime.now());
        
        // 是否有异常
        if (e != null) {
            systemLog.setType("ERROR");
            systemLog.setException(e.toString());
        } else {
            systemLog.setType("INFO");
        }

        // 保存系统日志
        systemLogMapper.insert(systemLog);
    }
}