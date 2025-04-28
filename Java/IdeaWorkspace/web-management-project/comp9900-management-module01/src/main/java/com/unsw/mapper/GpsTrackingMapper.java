package com.unsw.mapper;

import com.unsw.pojo.GpsTracking;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface GpsTrackingMapper {
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
    int insert(GpsTracking record);

    /**
     * insert record to table selective
     *
     * @param record the record
     * @return insert count
     */
    int insertSelective(GpsTracking record);

    /**
     * select by primary key
     *
     * @param id primary key
     * @return object by primary key
     */
    GpsTracking selectByPrimaryKey(Integer id);

    /**
     * update record selective
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKeySelective(GpsTracking record);

    /**
     * update record
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKey(GpsTracking record);
}