package com.yusys.factory;

import com.yusys.service.AdminService;
import com.yusys.service.impl.AdminServiceImpl;
import org.springframework.beans.factory.FactoryBean;

public class AdminFactoryBean implements FactoryBean<AdminService> {
    @Override
    public AdminService getObject() throws Exception {
        return new AdminServiceImpl();
    }

    @Override
    public Class<?> getObjectType() {
        return AdminService.class;
    }

    @Override
    public boolean isSingleton() {
        return true;
    }
}
