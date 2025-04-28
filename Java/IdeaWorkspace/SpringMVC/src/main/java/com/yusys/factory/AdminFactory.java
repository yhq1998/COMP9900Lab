package com.yusys.factory;

import com.yusys.service.AdminService;
import com.yusys.service.impl.AdminServiceImpl;

public class AdminFactory {
    public AdminService creatAdminServiceImpl(){
        return new AdminServiceImpl();
    }
}
