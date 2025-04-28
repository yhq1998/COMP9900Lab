-- 创建系统日志表
CREATE TABLE system_log (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    operation VARCHAR(255),
    method VARCHAR(255),
    params TEXT,
    ip VARCHAR(50),
    time BIGINT,
    exception TEXT,
    create_time TIMESTAMP,
    description VARCHAR(255),
    type VARCHAR(20)
);

-- 创建索引以提高查询性能
CREATE INDEX idx_system_log_username ON system_log(username);
CREATE INDEX idx_system_log_type ON system_log(type);
CREATE INDEX idx_system_log_create_time ON system_log(create_time);