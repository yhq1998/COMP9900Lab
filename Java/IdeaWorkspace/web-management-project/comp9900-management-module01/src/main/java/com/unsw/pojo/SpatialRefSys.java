package com.unsw.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SpatialRefSys {
    private Integer srid;

    private String authName;

    private Integer authSrid;

    private String srtext;

    private String proj4text;
}