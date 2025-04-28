package com.unsw.service;

import org.springframework.stereotype.Service;

import org.springframework.beans.factory.annotation.Autowired;

import com.unsw.pojo.Promotions;
import com.unsw.mapper.PromotionsMapper;
import com.unsw.service.PromotionsService;
@Service
public class PromotionsServiceImpl implements PromotionsService{

    @Autowired
    private PromotionsMapper promotionsMapper;

    @Override
    public int deleteByPrimaryKey(Integer id) {
        return promotionsMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(Promotions record) {
        return promotionsMapper.insert(record);
    }

    @Override
    public int insertSelective(Promotions record) {
        return promotionsMapper.insertSelective(record);
    }

    @Override
    public Promotions selectByPrimaryKey(Integer id) {
        return promotionsMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(Promotions record) {
        return promotionsMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(Promotions record) {
        return promotionsMapper.updateByPrimaryKey(record);
    }

}
