package com.unsw.service;

import com.unsw.pojo.Vehicles;
import java.util.List;

public interface VehiclesService{

    int deleteByPrimaryKey(Integer id);

    int insert(Vehicles record);

    int insertSelective(Vehicles record);

    Vehicles selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Vehicles record);

    int updateByPrimaryKey(Vehicles record);
    
    List<Vehicles> findAll();

}
