package com.unsw.service.impl;

import com.unsw.mapper.VehiclesMapper;
import com.unsw.pojo.Vehicles;
import com.unsw.service.VehiclesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VehiclesServiceImpl implements VehiclesService {

    @Autowired
    private VehiclesMapper vehiclesMapper;

    @Override
    public int deleteByPrimaryKey(Integer id) {
        return vehiclesMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(Vehicles record) {
        // 可以添加默认值或校验逻辑
        // record.setCreatedAt(new java.util.Date()); // 如果数据库没有默认值
        return vehiclesMapper.insert(record);
    }

    @Override
    public int insertSelective(Vehicles record) {
        // 可以添加默认值或校验逻辑
        // if (record.getCreatedAt() == null) {
        //     record.setCreatedAt(new java.util.Date());
        // }
        return vehiclesMapper.insertSelective(record);
    }

    @Override
    public Vehicles selectByPrimaryKey(Integer id) {
        return vehiclesMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(Vehicles record) {
        // record.setUpdatedAt(new java.util.Date()); // 更新时间戳
        return vehiclesMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(Vehicles record) {
        // record.setUpdatedAt(new java.util.Date()); // 更新时间戳
        return vehiclesMapper.updateByPrimaryKey(record);
    }

    @Override
    public List<Vehicles> findAll() {
        return vehiclesMapper.findAll();
    }

    // 可以根据需要添加其他业务方法，例如：
    // - 分页查询
    // - 根据条件查询 (车牌号, 类型, 可用状态)
    // - 更新GPS位置
    // - 切换可用状态
}