package com.yusys;

import com.yusys.factory.UserFactory;
import com.yusys.service.UserService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class App3 {
    public static void main(String[] args) {
//        //通过工厂的方式进行解耦
//        UserService userServiceImpl = UserFactory.userService();
//        userServiceImpl.name();

        //通过spring管理的方式进行解耦
        ApplicationContext ctx =  new ClassPathXmlApplicationContext("applicationContext.xml");

        UserService userServiceImpl = (UserService) ctx.getBean("userService");

        userServiceImpl.name();
    }
}
