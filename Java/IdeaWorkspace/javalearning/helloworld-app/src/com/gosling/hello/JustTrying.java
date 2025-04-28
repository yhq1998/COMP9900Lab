package com.gosling.hello;

public class JustTrying {
    public static void main(String[] args) {
        // To find the max number among the three nums
        int i = 14;
        int j = 45;
        int k = 34;
        int temp;
        int rs;
        temp = i > j ? i : j;
        rs = temp > k ? temp : k;
        System.out.println(rs);
    }
}
