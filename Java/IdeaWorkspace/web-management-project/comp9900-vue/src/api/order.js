import request from '@/utils/request';

// 获取订单列表
export function getOrderList(params) {
  return request({
    url: '/orders',
    method: 'get',
    params
  });
}

// 获取订单详情
export function getOrderDetail(id) {
  return request({
    url: `/orders/${id}`,
    method: 'get'
  });
}

// 添加订单
export function addOrder(data) {
  return request({
    url: '/orders',
    method: 'post',
    data
  });
}

// 更新订单
export function updateOrder(id, data) {
  // 确保传递时间戳以避免缓存问题
  const updatedData = {
    ...data,
    _timestamp: new Date().getTime()
  };
  
  // 如果只有状态字段，则仅更新状态
  const isStatusOnly = Object.keys(data).length === 1 && data.status;
  
  console.log(`更新订单 ${id}${isStatusOnly ? ` 的状态为 ${data.status}` : ''}`, updatedData);
  
  return request({
    url: `/orders/${id}`,
    method: 'put',
    data: updatedData,
    // 添加额外头信息确保请求正确处理
    headers: {
      'X-Request-Type': isStatusOnly ? 'status-update' : 'full-update'
    }
  });
}

// 转换order_type字符串为PostgreSQL枚举类型（使用CAST语法）
// 在后端是PostgreSQL数据库，使用了自定义枚举类型
function getOrderTypeEnumCast(orderType) {
  if (!orderType) return null;
  return `${orderType}::order_type`; // PostgreSQL的类型转换语法
}

// 更新订单状态（使用专用的状态更新接口）
export function updateOrderStatus(id, data) {
  console.log(`使用专用接口更新订单 ${id} 的状态为 ${data.status}`);
  
  // 使用专用的status接口
  return request({
    url: `/orders/${id}/status`, 
    method: 'put',
    data: {
      status: data.status, // 只传递状态字段
      _timestamp: new Date().getTime() // 添加时间戳防止缓存
    }
  });
}

// 更新订单状态（使用普通的更新接口）
export function updateOrderStatusViaUpdate(id, data) {
  console.log(`使用普通更新接口更新订单 ${id} 的状态为 ${data.status}`);
  
  // 使用通用的更新接口
  return request({
    url: `/orders/${id}`,
    method: 'put',
    data: {
      status: data.status, // 只传递状态字段
      _timestamp: new Date().getTime() // 添加时间戳防止缓存
    }
  });
}

// 使用PATCH方法更新状态（仅更新部分字段）
export function patchOrderStatus(id, data) {
  console.log(`使用PATCH方法更新订单 ${id} 的状态为 ${data.status}`);
  
  return request({
    url: `/orders/${id}`,
    method: 'patch',
    data: {
      status: data.status,
      _timestamp: new Date().getTime() // 添加时间戳防止缓存
    }
  });
}

// 删除订单
export function deleteOrder(id) {
  return request({
    url: `/orders/${id}`,
    method: 'delete'
  });
}