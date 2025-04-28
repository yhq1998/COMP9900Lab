package com.yusys.dao.impl;

import com.yusys.dao.BookDao;

public class BookDaoImpl implements BookDao {
    @Override
    public void save() {
        System.out.println("this is bookDaoImpl");
    }
}
