package com.unsw.service;

import org.springframework.stereotype.Service;

import org.springframework.beans.factory.annotation.Autowired;

import com.unsw.mapper.NotificationsMapper;
import com.unsw.pojo.Notifications;
import com.unsw.service.NotificationsService;
@Service
public class NotificationsServiceImpl implements NotificationsService{

    @Autowired
    private NotificationsMapper notificationsMapper;

    @Override
    public int deleteByPrimaryKey(Integer id) {
        return notificationsMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(Notifications record) {
        return notificationsMapper.insert(record);
    }

    @Override
    public int insertSelective(Notifications record) {
        return notificationsMapper.insertSelective(record);
    }

    @Override
    public Notifications selectByPrimaryKey(Integer id) {
        return notificationsMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(Notifications record) {
        return notificationsMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(Notifications record) {
        return notificationsMapper.updateByPrimaryKey(record);
    }

}
