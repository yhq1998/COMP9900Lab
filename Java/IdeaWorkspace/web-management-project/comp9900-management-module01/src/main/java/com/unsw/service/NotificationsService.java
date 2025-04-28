package com.unsw.service;

import com.unsw.pojo.Notifications;
public interface NotificationsService{

    int deleteByPrimaryKey(Integer id);

    int insert(Notifications record);

    int insertSelective(Notifications record);

    Notifications selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Notifications record);

    int updateByPrimaryKey(Notifications record);

}
