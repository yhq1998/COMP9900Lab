package com.unsw.service;

import com.unsw.pojo.Admin;

import java.util.List;

/**
 * 管理员服务接口
 */
public interface AdminService {
    /**
     * 根据ID查询管理员
     *
     * @param id 管理员ID
     * @return 管理员对象
     */
    Admin findById(Integer id);

    /**
     * 根据用户名查询管理员
     *
     * @param username 用户名
     * @return 管理员对象
     */
    Admin findByUsername(String username);

    /**
     * 查询所有管理员
     *
     * @return 管理员列表
     */
    List<Admin> findAll();

    /**
     * 保存管理员
     *
     * @param admin 管理员对象
     * @return 保存结果
     */
    int save(Admin admin);

    /**
     * 更新管理员
     *
     * @param admin 管理员对象
     * @return 更新结果
     */
    int update(Admin admin);

    /**
     * 删除管理员
     *
     * @param id 管理员ID
     * @return 删除结果
     */
    int delete(Integer id);
}