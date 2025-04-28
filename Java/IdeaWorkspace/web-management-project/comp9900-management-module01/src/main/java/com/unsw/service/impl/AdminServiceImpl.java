package com.unsw.service.impl;

import com.unsw.mapper.AdminMapper;
import com.unsw.pojo.Admin;
import com.unsw.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 管理员服务实现类
 */
@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMapper adminMapper;
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public Admin findById(Integer id) {
        return adminMapper.selectByPrimaryKey(id);
    }

    @Override
    public Admin findByUsername(String username) {
        return adminMapper.findByUsername(username);
    }

    @Override
    public List<Admin> findAll() {
        return adminMapper.findAll();
    }

    @Override
    public int save(Admin admin) {
        if (admin.getId() != null) {
            return adminMapper.updateByPrimaryKeySelective(admin);
        } else {
            return adminMapper.insertSelective(admin);
        }
    }

    @Override
    public int update(Admin admin) {
        return adminMapper.updateByPrimaryKeySelective(admin);
    }

    @Override
    public int delete(Integer id) {
        return adminMapper.deleteByPrimaryKey(id);
    }
}