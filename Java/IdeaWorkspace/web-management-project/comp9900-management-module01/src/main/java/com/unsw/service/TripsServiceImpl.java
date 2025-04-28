package com.unsw.service;

import org.springframework.stereotype.Service;

import org.springframework.beans.factory.annotation.Autowired;

import com.unsw.pojo.Trips;
import com.unsw.mapper.TripsMapper;
import com.unsw.service.TripsService;
@Service
public class TripsServiceImpl implements TripsService{

    @Autowired
    private TripsMapper tripsMapper;

    @Override
    public int deleteByPrimaryKey(Integer id) {
        return tripsMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(Trips record) {
        return tripsMapper.insert(record);
    }

    @Override
    public int insertSelective(Trips record) {
        return tripsMapper.insertSelective(record);
    }

    @Override
    public Trips selectByPrimaryKey(Integer id) {
        return tripsMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(Trips record) {
        return tripsMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(Trips record) {
        return tripsMapper.updateByPrimaryKey(record);
    }

}
