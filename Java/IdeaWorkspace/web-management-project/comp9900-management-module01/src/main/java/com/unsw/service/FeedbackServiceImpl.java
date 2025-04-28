package com.unsw.service;

import org.springframework.stereotype.Service;

import org.springframework.beans.factory.annotation.Autowired;

import com.unsw.mapper.FeedbackMapper;
import com.unsw.pojo.Feedback;
import com.unsw.service.FeedbackService;
@Service
public class FeedbackServiceImpl implements FeedbackService{

    @Autowired
    private FeedbackMapper feedbackMapper;

    @Override
    public int deleteByPrimaryKey(Integer id) {
        return feedbackMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(Feedback record) {
        return feedbackMapper.insert(record);
    }

    @Override
    public int insertSelective(Feedback record) {
        return feedbackMapper.insertSelective(record);
    }

    @Override
    public Feedback selectByPrimaryKey(Integer id) {
        return feedbackMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(Feedback record) {
        return feedbackMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(Feedback record) {
        return feedbackMapper.updateByPrimaryKey(record);
    }

}
