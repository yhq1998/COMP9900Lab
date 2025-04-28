package com.yusys;

import com.yusys.dao.BookDao;
import com.yusys.service.Bookservice;
import com.yusys.service.impl.BookServiceImpl;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class App2 {
    public static void main(String[] args) {
        //获取容器
        ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationContext.xml");

//        //获取容器中的bean对象
//        BookDao bookDao = (BookDao) ctx.getBean("BookDao");
//        //调用bookDao中的方法
//        bookDao.save();

        //测试一下获取service对象
        Bookservice bookService = (Bookservice) ctx.getBean("BookService");
        bookService.save();


    }
}
