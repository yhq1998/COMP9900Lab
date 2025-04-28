package com.unsw.service;

import com.unsw.pojo.User;
import com.unsw.pojo.Users;

import java.util.List;

public interface UsersService {

    int deleteByPrimaryKey(Integer id);

    int insert(Users record);

    int insertSelective(Users record);

    Users selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Users record);

    int updateByPrimaryKey(Users record);

    List<Users> findAll();

    Users findByUsername(String username);

    int save(Users user);
}

