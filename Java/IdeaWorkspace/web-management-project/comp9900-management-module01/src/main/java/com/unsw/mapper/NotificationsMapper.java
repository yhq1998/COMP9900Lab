package com.unsw.mapper;

import com.unsw.pojo.Notifications;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface NotificationsMapper {
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
    int insert(Notifications record);

    /**
     * insert record to table selective
     *
     * @param record the record
     * @return insert count
     */
    int insertSelective(Notifications record);

    /**
     * select by primary key
     *
     * @param id primary key
     * @return object by primary key
     */
    Notifications selectByPrimaryKey(Integer id);

    /**
     * update record selective
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKeySelective(Notifications record);

    /**
     * update record
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKey(Notifications record);
}