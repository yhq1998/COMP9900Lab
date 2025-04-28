package com.unsw.mapper;

import com.unsw.pojo.Users;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UsersMapper {
    /**
     * delete by primary key
     *
     * @param id primaryKey
     * @return deleteCount
     */
    int deleteByPrimaryKey(Integer id);

    /**
     * insert record to table
     *
     * @param record the record
     * @return insert count
     */
    int insert(Users record);

    /**
     * insert record to table selective
     *
     * @param record the record
     * @return insert count
     */
    int insertSelective(Users record);

    /**
     * select by primary key
     *
     * @param id primary key
     * @return object by primary key
     */
    Users selectByPrimaryKey(Integer id);

    /**
     * update record selective
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKeySelective(Users record);

    /**
     * update record
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKey(Users record);

    List<Users> findAll();

    /**
     * find user by username
     *
     * @param username the username
     * @return user by username
     */
    Users findByUsername(String username);
}