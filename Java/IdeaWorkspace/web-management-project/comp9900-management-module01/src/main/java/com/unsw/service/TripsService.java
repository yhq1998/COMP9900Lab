package com.unsw.service;

import com.unsw.pojo.Trips;
public interface TripsService{

    int deleteByPrimaryKey(Integer id);

    int insert(Trips record);

    int insertSelective(Trips record);

    Trips selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Trips record);

    int updateByPrimaryKey(Trips record);

}
