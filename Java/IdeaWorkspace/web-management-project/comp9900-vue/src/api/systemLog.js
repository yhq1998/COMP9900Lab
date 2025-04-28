import request from '@/utils/request'

// 查询系统日志分页列表
export const querySystemLogPageApi = (username, type, page, size) => 
  request.get('/system-logs', { params: { username, type, page, size } })

// 查询系统日志详情
export const querySystemLogInfoApi = (id) => 
  request.get(`/system-logs/${id}`)

// 删除系统日志
export const deleteSystemLogApi = (id) => 
  request.delete(`/system-logs/${id}`)

// 清空指定类型的系统日志
export const clearSystemLogByTypeApi = (type) => 
  request.delete(`/system-logs/type/${type}`)

// 获取系统日志列表
export function getSystemLogList(params) {
  return request({
    url: '/system-logs',
    method: 'get',
    params
  });
}

// 获取系统日志详情
export function getSystemLogDetail(id) {
  return request({
    url: `/system-logs/${id}`,
    method: 'get'
  });
}

// 清除特定类型的系统日志
export function clearSystemLogs(type) {
  return request({
    url: `/system-logs/type/${type}`,
    method: 'delete'
  });
}

// 导出系统日志
export function exportSystemLogs(params) {
  return request({
    url: '/system-logs/export',
    method: 'get',
    params,
    responseType: 'blob'
  });
}