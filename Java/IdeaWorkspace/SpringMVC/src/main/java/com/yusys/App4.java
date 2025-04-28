package com.yusys;

import com.yusys.factory.AdminFactory;
import com.yusys.service.AdminService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class App4 {
    public static void main(String[] args) {

//        //实例化工厂创建对象的方法
//        AdminFactory adminFactory = new AdminFactory();
//
//        AdminService adminServiceImpl = adminFactory.creatAdminServiceImpl();
//
//        adminServiceImpl.adminNanme();

        //spring管理实例化工厂的方式
        ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationContext.xml");

        AdminService adminServiceImpl = (AdminService) ctx.getBean("adminService");

        adminServiceImpl.adminNanme();

    }
}
