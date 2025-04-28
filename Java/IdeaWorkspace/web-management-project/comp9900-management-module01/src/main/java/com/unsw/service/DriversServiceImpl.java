package com.unsw.service;

import com.unsw.mapper.DriversMapper;
import com.unsw.pojo.Drivers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DriversServiceImpl implements DriversService {

    @Autowired
    private DriversMapper driversMapper;

    @Override
    public int deleteByPrimaryKey(Integer id) {
        return driversMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(Drivers record) {
        return driversMapper.insert(record);
    }

    @Override
    public int insertSelective(Drivers record) {
        return driversMapper.insertSelective(record);
    }

    @Override
    public Drivers selectByPrimaryKey(Integer id) {
        return driversMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(Drivers record) {
        return driversMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(Drivers record) {
        return driversMapper.updateByPrimaryKey(record);
    }
    
    @Override
    public List<Drivers> findAll() {
        return driversMapper.findAll();
    }
    
    @Override
    public Map<String, Object> findByPage(Map<String, Object> params) {
        // 查询数据
        List<Drivers> drivers = driversMapper.findByPage(params);
        // 查询总数
        int total = driversMapper.countDrivers(params);
        
        Map<String, Object> result = new HashMap<>();
        result.put("data", drivers);
        result.put("total", total);
        
        return result;
    }
    
    @Override
    public Drivers findByUsername(String username) {
        return driversMapper.findByUsername(username);
    }
    
    @Override
    public Drivers findByPhoneNumber(String phoneNumber) {
        return driversMapper.findByPhoneNumber(phoneNumber);
    }
    
    @Override
    public List<Drivers> findByStatus(String status) {
        return driversMapper.findByStatus(status);
    }
    
    @Override
    public int updateStatus(Integer id, String status) {
        return driversMapper.updateStatus(id, status);
    }
    
    @Override
    public boolean checkUsernameExists(String username) {
        return driversMapper.findByUsername(username) != null;
    }
    
    @Override
    public boolean checkPhoneNumberExists(String phoneNumber) {
        return driversMapper.findByPhoneNumber(phoneNumber) != null;
    }
}
