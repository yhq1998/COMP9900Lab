package com.unsw.mapper;

import com.unsw.pojo.SpatialRefSys;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SpatialRefSysMapper {
    /**
     * delete by primary key
     *
     * @param srid primaryKey
     * @return deleteCount
     */
    int deleteByPrimaryKey(Integer srid);

    /**
     * insert record to table
     *
     * @param record the record
     * @return insert count
     */
    int insert(SpatialRefSys record);

    /**
     * insert record to table selective
     *
     * @param record the record
     * @return insert count
     */
    int insertSelective(SpatialRefSys record);

    /**
     * select by primary key
     *
     * @param srid primary key
     * @return object by primary key
     */
    SpatialRefSys selectByPrimaryKey(Integer srid);

    /**
     * update record selective
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKeySelective(SpatialRefSys record);

    /**
     * update record
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKey(SpatialRefSys record);
}