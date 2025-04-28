package com.unsw.service;

import com.unsw.pojo.SpatialRefSys;
public interface SpatialRefSysService{

    int deleteByPrimaryKey(Integer srid);

    int insert(SpatialRefSys record);

    int insertSelective(SpatialRefSys record);

    SpatialRefSys selectByPrimaryKey(Integer srid);

    int updateByPrimaryKeySelective(SpatialRefSys record);

    int updateByPrimaryKey(SpatialRefSys record);

}
