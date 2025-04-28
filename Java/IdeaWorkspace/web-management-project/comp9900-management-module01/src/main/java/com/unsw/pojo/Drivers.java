package com.unsw.pojo;

import java.util.Date;
import com.unsw.pojo.enums.DriverStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.Builder;

/**
 * 司机实体类
 * 对应数据库表 drivers
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Drivers {
    /**
     * 主键ID
     */
    private Integer id;

    /**
     * 用户名，不允许为空，唯一
     */
    private String username;

    /**
     * 全名
     */
    private String fullName;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 手机号，不允许为空，唯一
     */
    private String phoneNumber;

    /**
     * 密码(加密后)，不允许为空
     */
    private String password;

    /**
     * 头像URL
     */
    private String photo;

    /**
     * 驾驶证号码
     */
    private String driverLicenseNumber;

    /**
     * 车辆信息
     */
    private String vehicle;

    /**
     * 司机状态: available, busy, offline
     */
    private String status;

    /**
     * 创建时间
     */
    private Date createdAt;

    /**
     * 更新时间
     */
    private Date updatedAt;
    
    /**
     * 获取司机状态枚举
     * @return 状态枚举
     */
    public DriverStatus getStatusEnum() {
        if (status == null) {
            return null;
        }
        return DriverStatus.fromString(status);
    }
    
    /**
     * 设置司机状态枚举
     * @param statusEnum 状态枚举
     */
    public void setStatusEnum(DriverStatus statusEnum) {
        if (statusEnum == null) {
            this.status = null;
        } else {
            this.status = statusEnum.getValue();
        }
    }
}