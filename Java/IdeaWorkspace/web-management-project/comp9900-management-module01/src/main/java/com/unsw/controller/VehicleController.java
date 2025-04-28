package com.unsw.controller;

import com.unsw.pojo.Result;
import com.unsw.pojo.Vehicles;
import com.unsw.service.VehiclesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/vehicles")
public class VehicleController {

    @Autowired
    private VehiclesService vehiclesService;

    /**
     * 查询所有车辆
     * @return 车辆列表
     */
    @GetMapping
    public Result list() {
        System.out.println("查询所有车辆数据");
        List<Vehicles> vehiclesList = vehiclesService.findAll();
        return Result.success(vehiclesList);
    }

    /**
     * 根据ID查询车辆
     * @param id 车辆ID
     * @return 车辆信息
     */
    @GetMapping("/{id}")
    public Result getById(@PathVariable Integer id) {
        System.out.println("根据ID查询车辆: " + id);
        Vehicles vehicle = vehiclesService.selectByPrimaryKey(id);
        if (vehicle != null) {
            return Result.success(vehicle);
        } else {
            return Result.error("车辆不存在");
        }
    }

    /**
     * 创建新车辆
     * @param vehicle 车辆信息
     * @return 创建结果
     */
    @PostMapping
    public Result save(@RequestBody Vehicles vehicle) {
        System.out.println("创建新车辆: " + vehicle);
        // Let the database handle createdAt default value
        // vehicle.setCreatedAt(new Date());

        // Construct WKT string for gpsLocation if longitude and latitude are provided
        // Assuming the request body might contain separate longitude/latitude or a pre-formatted gpsLocation string
        // If separate fields are expected, adjust the logic here to read them and construct the WKT string.
        // For now, we assume vehicle.gpsLocation might be pre-formatted or needs construction based on other fields if available.
        // Example: if request has longitude/latitude fields:
        // if (vehicle.getLongitude() != null && vehicle.getLatitude() != null) {
        //     vehicle.setGpsLocation(String.format("POINT(%s %s)", vehicle.getLongitude(), vehicle.getLatitude()));
        // } else {
        //     vehicle.setGpsLocation(null);
        // }
        // The current POJO only has gpsLocation, assuming it's sent directly as WKT or null

        int result = vehiclesService.insertSelective(vehicle); // Use insertSelective to handle nulls properly
        if (result > 0) {
            // Return the vehicle with the generated ID (if keyProperty is set in mapper)
            return Result.success(vehicle);
        } else {
            return Result.error("创建车辆失败");
        }
    }

    /**
     * 更新车辆信息
     * @param id 车辆ID
     * @param vehicle 更新的车辆信息
     * @return 更新结果
     */
    @PutMapping("/{id}")
    public Result update(@PathVariable Integer id, @RequestBody Vehicles vehicle) {
        System.out.println("更新车辆信息: " + id + ", data: " + vehicle);
        vehicle.setId(id);

        // Construct WKT string for gpsLocation similar to the POST method if needed
        // Assuming vehicle.gpsLocation is sent directly as WKT or null/empty string for removal
        // If longitude/latitude are sent separately:
        // if (vehicle.getLongitude() != null && vehicle.getLatitude() != null && !vehicle.getLongitude().isEmpty() && !vehicle.getLatitude().isEmpty()) {
        //     vehicle.setGpsLocation(String.format("POINT(%s %s)", vehicle.getLongitude(), vehicle.getLatitude()));
        // } else {
        //     // If lat/lon are empty, mapper handles setting gps_location to NULL if gpsLocation field is empty string or null
        //     vehicle.setGpsLocation(null); 
        // }

        int result = vehiclesService.updateByPrimaryKeySelective(vehicle);
        if (result > 0) {
            return Result.success();
        } else {
            // It might be that the vehicle with the given ID doesn't exist
            Vehicles existing = vehiclesService.selectByPrimaryKey(id);
            if (existing == null) {
                return Result.error("车辆不存在，无法更新");
            }
            return Result.error("更新车辆失败");
        }
    }

    /**
     * 删除车辆
     * @param id 车辆ID
     * @return 删除结果
     */
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        System.out.println("删除车辆: " + id);
        int result = vehiclesService.deleteByPrimaryKey(id);
        if (result > 0) {
            return Result.success();
        } else {
            return Result.error("删除车辆失败");
        }
    }
}