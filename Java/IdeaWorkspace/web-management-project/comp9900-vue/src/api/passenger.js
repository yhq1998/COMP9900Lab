import request from '@/utils/request'

// 获取乘客列表
export function getPassengerList(params) {
  return request({
    url: '/passengers',
    method: 'get',
    params
  });
}

// 获取乘客详情
export function getPassengerDetail(id) {
  return request({
    url: `/passengers/${id}`,
    method: 'get'
  });
}

// 添加乘客
export function addPassenger(data) {
  return request({
    url: '/passengers',
    method: 'post',
    data
  });
}

// 更新乘客
export function updatePassenger(id, data) {
  return request({
    url: `/passengers/${id}`,
    method: 'put',
    data
  });
}

// 删除乘客
export function deletePassenger(id) {
  return request({
    url: `/passengers/${id}`,
    method: 'delete'
  });
}

// 切换乘客状态
export function togglePassengerStatus(id) {
  return request({
    url: `/passengers/${id}/toggle-status`,
    method: 'put'
  });
}