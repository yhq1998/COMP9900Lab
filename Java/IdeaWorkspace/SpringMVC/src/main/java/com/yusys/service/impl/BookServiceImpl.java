package com.yusys.service.impl;


import com.yusys.dao.impl.BookDaoImpl;
import com.yusys.service.Bookservice;

public class BookServiceImpl implements Bookservice {

    private BookDaoImpl bookDaoImpl;

    @Override
    public void save() {
        System.out.println("this is bookServiceImpl");
        bookDaoImpl.save();
    }

    public void setBookDaoImpl(BookDaoImpl bookDaoImpl) {
        this.bookDaoImpl = bookDaoImpl;
    }
}
