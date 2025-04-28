import request from '@/utils/request';

// 获取车辆列表
export function getVehicleList(params) {
  return request({
    url: '/vehicles',
    method: 'get',
    params
  });
}

// 获取车辆详情
export function getVehicleDetail(id) {
  return request({
    url: `/vehicles/${id}`,
    method: 'get'
  });
}

// 添加车辆
export function addVehicle(data) {
  return request({
    url: '/vehicles',
    method: 'post',
    data
  });
}

// 更新车辆
export function updateVehicle(id, data) {
  return request({
    url: `/vehicles/${id}`,
    method: 'put',
    data
  });
}

// 删除车辆
export function deleteVehicle(id) {
  return request({
    url: `/vehicles/${id}`,
    method: 'delete'
  });
} 