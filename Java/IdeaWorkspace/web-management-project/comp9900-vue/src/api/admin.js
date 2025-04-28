import request from '@/utils/request'

// 查询管理员列表
export const queryAdminPageApi = (username, page, size) => 
  request.get('/admins', { params: { username, page, size } })

// 添加管理员
export const addAdminApi = (data) => 
  request.post('/admins', data)

// 查询管理员详情
export const queryAdminInfoApi = (id) => 
  request.get(`/admins/${id}`)

// 更新管理员信息
export const updateAdminApi = (data) => 
  request.put(`/admins/${data.id}`, data)

// 删除管理员
export const deleteAdminApi = (id) => 
  request.delete(`/admins/${id}`)