import request from '@/utils/request';

// 获取核心数据统计
export function getCoreStats() {
  return request({
    url: '/auth/analysis/core',
    method: 'get'
  });
}

// 获取订单趋势数据
export function getOrderTrend(params) {
  return request({
    url: '/auth/analysis/order/trend',
    method: 'get',
    params
  });
}

// 获取收入趋势数据
export function getRevenueTrend(params) {
  return request({
    url: '/auth/analysis/revenue/trend',
    method: 'get',
    params
  });
}

// 获取订单状态分布
export function getOrderStatusDistribution() {
  return request({
    url: '/auth/analysis/order/status',
    method: 'get'
  });
}

// 获取支付方式分布
export function getPaymentMethodDistribution() {
  return request({
    url: '/auth/analysis/payment/method',
    method: 'get'
  });
}

// 获取车型使用率
export function getVehicleTypeDistribution() {
  return request({
    url: '/auth/analysis/vehicle/type',
    method: 'get'
  });
}

// 获取司机排行榜
export function getDriverRanking(params) {
  return request({
    url: '/auth/analysis/driver/ranking',
    method: 'get',
    params
  });
}

// 获取线路排行榜
export function getRouteRanking(params) {
  return request({
    url: '/auth/analysis/route/ranking',
    method: 'get',
    params
  });
}

// 获取热门线路地图数据
export function getRouteHotmap() {
  return request({
    url: '/auth/analysis/route/hotmap',
    method: 'get'
  });
} 