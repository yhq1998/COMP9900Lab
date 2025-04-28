package com.unsw.service;

import com.unsw.pojo.Promotions;
public interface PromotionsService{

    int deleteByPrimaryKey(Integer id);

    int insert(Promotions record);

    int insertSelective(Promotions record);

    Promotions selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Promotions record);

    int updateByPrimaryKey(Promotions record);

}
