package com.unsw.service;

import org.springframework.stereotype.Service;

import org.springframework.beans.factory.annotation.Autowired;

import com.unsw.mapper.SpatialRefSysMapper;
import com.unsw.pojo.SpatialRefSys;
import com.unsw.service.SpatialRefSysService;
@Service
public class SpatialRefSysServiceImpl implements SpatialRefSysService{

    @Autowired
    private SpatialRefSysMapper spatialRefSysMapper;

    @Override
    public int deleteByPrimaryKey(Integer srid) {
        return spatialRefSysMapper.deleteByPrimaryKey(srid);
    }

    @Override
    public int insert(SpatialRefSys record) {
        return spatialRefSysMapper.insert(record);
    }

    @Override
    public int insertSelective(SpatialRefSys record) {
        return spatialRefSysMapper.insertSelective(record);
    }

    @Override
    public SpatialRefSys selectByPrimaryKey(Integer srid) {
        return spatialRefSysMapper.selectByPrimaryKey(srid);
    }

    @Override
    public int updateByPrimaryKeySelective(SpatialRefSys record) {
        return spatialRefSysMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(SpatialRefSys record) {
        return spatialRefSysMapper.updateByPrimaryKey(record);
    }

}
