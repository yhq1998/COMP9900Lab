package com.unsw.mapper;

import com.unsw.pojo.SystemLog;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface SystemLogMapper {
    void insert(SystemLog log);
    
    List<SystemLog> findAll();
    
    List<SystemLog> findByType(String type);
    
    List<SystemLog> findByUsername(String username);
    
    void deleteById(Long id);
    
    void deleteByType(String type);
}