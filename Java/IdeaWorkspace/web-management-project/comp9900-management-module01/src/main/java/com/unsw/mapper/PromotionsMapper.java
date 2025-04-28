package com.unsw.mapper;

import com.unsw.pojo.Promotions;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PromotionsMapper {
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
    int insert(Promotions record);

    /**
     * insert record to table selective
     *
     * @param record the record
     * @return insert count
     */
    int insertSelective(Promotions record);

    /**
     * select by primary key
     *
     * @param id primary key
     * @return object by primary key
     */
    Promotions selectByPrimaryKey(Integer id);

    /**
     * update record selective
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKeySelective(Promotions record);

    /**
     * update record
     *
     * @param record the updated record
     * @return update count
     */
    int updateByPrimaryKey(Promotions record);
}