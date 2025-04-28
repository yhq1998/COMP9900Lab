package com.unsw.pojo;

import lombok.Data;
import java.io.Serializable;
import java.util.List;

@Data
public class Result{

    private Integer code; // success: 1 fail: 0
    private String msg; // error message
    private Object data; // data

    public static Result success(){
        Result result = new Result();
        result.code = 1;
        result.msg = "success";
        return result;
    }

    public static Result success(Object object) {
        Result result = new Result();
        result.code = 1;
        result.msg = "success";
        result.data = object;
        return result;
    }

    public static Result error(String msg) {
        Result result = new Result();
        result.code = 0;
        result.msg = msg;
        return result; 
    }
}