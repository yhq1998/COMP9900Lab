package com.unsw.pojo.enums;

public enum DriverStatus {
    AVAILABLE("available"), 
    BUSY("busy"), 
    OFFLINE("offline");
    
    private final String value;
    
    DriverStatus(String value) {
        this.value = value;
    }
    
    public String getValue() {
        return this.value;
    }
    
    /**
     * 将字符串转换为枚举
     * @param value 状态字符串
     * @return 枚举值
     */
    public static DriverStatus fromString(String value) {
        for (DriverStatus status : DriverStatus.values()) {
            if (status.value.equalsIgnoreCase(value)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown driver status: " + value);
    }
}

