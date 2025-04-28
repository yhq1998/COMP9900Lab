package com.unsw.service;

import org.springframework.stereotype.Service;

import org.springframework.beans.factory.annotation.Autowired;

import com.unsw.pojo.GpsTracking;
import com.unsw.mapper.GpsTrackingMapper;
import com.unsw.service.GpsTrackingService;
@Service
public class GpsTrackingServiceImpl implements GpsTrackingService{

    @Autowired
    private GpsTrackingMapper gpsTrackingMapper;

    @Override
    public int deleteByPrimaryKey(Integer id) {
        return gpsTrackingMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(GpsTracking record) {
        return gpsTrackingMapper.insert(record);
    }

    @Override
    public int insertSelective(GpsTracking record) {
        return gpsTrackingMapper.insertSelective(record);
    }

    @Override
    public GpsTracking selectByPrimaryKey(Integer id) {
        return gpsTrackingMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(GpsTracking record) {
        return gpsTrackingMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(GpsTracking record) {
        return gpsTrackingMapper.updateByPrimaryKey(record);
    }

}
