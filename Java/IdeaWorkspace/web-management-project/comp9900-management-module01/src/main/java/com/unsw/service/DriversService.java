package com.unsw.service;

import com.unsw.pojo.Drivers;
import java.util.List;
import java.util.Map;

public interface DriversService {

    int deleteByPrimaryKey(Integer id);

    int insert(Drivers record);

    int insertSelective(Drivers record);

    Drivers selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Drivers record);

    int updateByPrimaryKey(Drivers record);
    
    List<Drivers> findAll();
    
    /**
     * 分页查询司机列表
     * @param params 包含分页参数(page, size)和查询条件(username, phoneNumber, status)
     * @return 分页结果，包含数据和总数
     */
    Map<String, Object> findByPage(Map<String, Object> params);
    
    /**
     * 根据用户名查询司机
     * @param username 用户名
     * @return 司机信息
     */
    Drivers findByUsername(String username);
    
    /**
     * 根据手机号查询司机
     * @param phoneNumber 手机号
     * @return 司机信息
     */
    Drivers findByPhoneNumber(String phoneNumber);
    
    /**
     * 根据状态查询司机
     * @param status 状态
     * @return 司机列表
     */
    List<Drivers> findByStatus(String status);
    
    /**
     * 更新司机状态
     * @param id 司机ID
     * @param status 新状态
     * @return 更新结果
     */
    int updateStatus(Integer id, String status);
    
    /**
     * 检查用户名是否已存在
     * @param username 用户名
     * @return true if exists, false otherwise
     */
    boolean checkUsernameExists(String username);
    
    /**
     * 检查手机号是否已存在
     * @param phoneNumber 手机号
     * @return true if exists, false otherwise
     */
    boolean checkPhoneNumberExists(String phoneNumber);
}
