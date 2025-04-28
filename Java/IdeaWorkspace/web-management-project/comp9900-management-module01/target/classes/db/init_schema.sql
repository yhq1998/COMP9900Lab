-- 创建系统日志表
CREATE TABLE IF NOT EXISTS system_log (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    operation VARCHAR(100),
    method VARCHAR(255),
    params TEXT,
    ip VARCHAR(50),
    time BIGINT,
    exception TEXT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    type VARCHAR(20)
);

-- 创建管理员表
CREATE TABLE IF NOT EXISTS admin (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    role VARCHAR(20) DEFAULT 'ADMIN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建用户表
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    photo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建驾驶员表
CREATE TABLE IF NOT EXISTS drivers (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    license_number VARCHAR(50),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    photo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入超级管理员用户 (密码: 123456)
INSERT INTO admin (username, password, full_name, email, role)
VALUES ('admin', '$2a$10$1eW8HITl0yXn/ZjJNz1eeeUSTMHbxYU9lKW07wq0KYVkQA9VR5S.u', 'Administrator', 'admin@example.com', 'ADMIN')
ON CONFLICT (username) DO NOTHING; 