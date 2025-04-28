package com.yusys.factory;

import com.yusys.service.UserService;
import com.yusys.service.impl.UserServiceImpl;

public class UserFactory {
    public static UserService userService(){

        return new UserServiceImpl();
    }
}
