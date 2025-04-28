import request from '@/utils/request';

// 获取车辆GPS轨迹历史
export function getTrackingHistory(vehicleId, params) {
  return request({
    url: `/vehicles/${vehicleId}/tracking-history`,
    method: 'get',
    params
  });
}