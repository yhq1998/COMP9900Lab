package com.unsw.mapper;

import com.unsw.pojo.Vehicles;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface VehiclesMapper {
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
    int insert(Vehicles record);

    /**
     * insert record to table selective
     *
     * @param record the record
     * @return insert count
     */
    int insertSelective(Vehicles record);

    /**
     * select by primary key
     *
     * @param id primary key
     * @return object by primary key
     */
    Vehicles selectByPrimaryKey(Integer id);

    /**
     * update record selective
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKeySelective(Vehicles record);

    /**
     * update record
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKey(Vehicles record);
    
    /**
     * find all vehicles
     *
     * @return list of all vehicles
     */
    java.util.List<Vehicles> findAll();
}