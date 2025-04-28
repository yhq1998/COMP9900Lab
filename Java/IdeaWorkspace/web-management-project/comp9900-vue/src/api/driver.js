import request from '@/utils/request';

// 获取司机列表
export function getDriverList(params) {
  return request({
    url: '/drivers',
    method: 'get',
    params,
    headers: {
      'Content-Type': 'application/json'
    }
  });
}

// 获取司机详情
export function getDriverDetail(id) {
  return request({
    url: `/drivers/${id}`,
    method: 'get',
    headers: {
      'Content-Type': 'application/json'
    }
  });
}

// 添加司机
export function addDriver(data) {
  return request({
    url: '/drivers',
    method: 'post',
    headers: {
      'Content-Type': 'application/json'
    },
    data: data
  })
}

// 更新司机
export function updateDriver(id, data) {
  return request({
    url: `/drivers/${id}`,
    method: 'put',
    data,
    headers: {
      'Content-Type': 'application/json'
    }
  });
}

// 删除司机
export function deleteDriver(id) {
  return request({
    url: `/drivers/${id}`,
    method: 'delete',
    headers: {
      'Content-Type': 'application/json'
    }
  });
}

// 更新司机状态
export function updateDriverStatus(id, data) {
  return request({
    url: `/drivers/${id}/status`,
    method: 'put',
    data,
    headers: {
      'Content-Type': 'application/json'
    }
  });
} 