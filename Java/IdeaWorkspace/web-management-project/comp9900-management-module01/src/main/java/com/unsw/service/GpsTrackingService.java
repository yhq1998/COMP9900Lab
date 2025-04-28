package com.unsw.service;

import com.unsw.pojo.GpsTracking;
public interface GpsTrackingService{

    int deleteByPrimaryKey(Integer id);

    int insert(GpsTracking record);

    int insertSelective(GpsTracking record);

    GpsTracking selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(GpsTracking record);

    int updateByPrimaryKey(GpsTracking record);

}
