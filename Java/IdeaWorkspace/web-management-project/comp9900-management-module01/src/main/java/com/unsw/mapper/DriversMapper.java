package com.unsw.mapper;

import com.unsw.pojo.Drivers;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface DriversMapper {
    /**
     * delete by primary key
     *
     * @param id primaryKey
     * @return deleteCount
     */
    int deleteByPrimaryKey(Integer id);
    
    /**
     * 查询所有司机
     * 
     * @return 司机列表
     */
    List<Drivers> findAll();
    
    /**
     * 分页查询司机列表
     * @param params 包含分页参数和查询条件
     * @return 司机列表
     */
    List<Drivers> findByPage(Map<String, Object> params);
    
    /**
     * 统计司机总数
     * @param params 查询条件
     * @return 司机总数
     */
    int countDrivers(Map<String, Object> params);
    
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
    int updateStatus(@Param("id") Integer id, @Param("status") String status);

    /**
     * insert record to table
     *
     * @param record the record
     * @return insert count
     */
    int insert(Drivers record);

    /**
     * insert record to table selective
     *
     * @param record the record
     * @return insert count
     */
    int insertSelective(Drivers record);

    /**
     * select by primary key
     *
     * @param id primary key
     * @return object by primary key
     */
    Drivers selectByPrimaryKey(Integer id);

    /**
     * update record selective
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKeySelective(Drivers record);

    /**
     * update record
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKey(Drivers record);
}