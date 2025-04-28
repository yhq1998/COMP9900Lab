package com.unsw.mapper;

import com.unsw.pojo.Trips;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TripsMapper {
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
    int insert(Trips record);

    /**
     * insert record to table selective
     *
     * @param record the record
     * @return insert count
     */
    int insertSelective(Trips record);

    /**
     * select by primary key
     *
     * @param id primary key
     * @return object by primary key
     */
    Trips selectByPrimaryKey(Integer id);

    /**
     * update record selective
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKeySelective(Trips record);

    /**
     * update record
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKey(Trips record);
}