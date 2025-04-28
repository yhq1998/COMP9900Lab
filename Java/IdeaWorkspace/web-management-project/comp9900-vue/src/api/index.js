/**
 * API统一导出文件
 * 集中管理所有API请求，避免重复导入和冲突
 */
import request from '@/utils/request'

// 导入新的订单API
import { 
  getOrderList, 
  getOrderDetail, 
  addOrder, 
  updateOrder, 
  deleteOrder,
  updateOrderStatus
} from './order'

// 登录相关API
export const loginApi = (data) => request.post('/auth/admin/login', data)

// 系统日志相关API
export * from './systemLog'

// 乘客管理API
export const queryPassengerPageApi = (page, size) => 
  request.get('/passengers', { params: { page, size } })

export const addPassengerApi = (data) => 
  request.post('/passengers', data)

export const queryPassengerInfoApi = (id) => 
  request.get(`/passengers/${id}`)

export const updatePassengerApi = (data) => 
  request.put(`/passengers/${data.id}`, data)

export const deletePassengerApi = (id) => 
  request.delete(`/passengers/${id}`)

// 司机管理API
export const queryDriverPageApi = (username, licenseNumber, page, size) => 
  request.get('/drivers', { params: { username, licenseNumber, page, size } })

export const addDriverApi = (data) => 
  request.post('/drivers', data)

export const queryDriverInfoApi = (id) => 
  request.get(`/drivers/${id}`)

export const updateDriverApi = (data) => 
  request.put(`/drivers/${data.id}`, data)

export const deleteDriverApi = (id) => 
  request.delete(`/drivers/${id}`)

// 订单管理API - 使用新API保持兼容性
export const queryOrderAllApi = () => getOrderList({})

export const queryOrderPageApi = (params) => getOrderList(params)

export const addOrderApi = (data) => addOrder(data)

export const queryOrderInfoApi = (id) => getOrderDetail(id)

export const updateOrderApi = (data) => updateOrder(data.id, data)

export const deleteOrderApi = (id) => deleteOrder(id)

// 支付管理API
export const queryPaymentPageApi = (orderId, status, page, size) => 
  request.get('/payments', { params: { orderId, status, page, size } })

export const addPaymentApi = (data) => 
  request.post('/payments', data)

export const queryPaymentInfoApi = (id) => 
  request.get(`/payments/${id}`)

export const updatePaymentApi = (data) => 
  request.put(`/payments/${data.id}`, data)

export const deletePaymentApi = (id) => 
  request.delete(`/payments/${id}`)

// 日志管理API
export const queryLogPageApi = (params) => 
  request.get('/logs', { params })

// 报表相关API
export const queryEmpJobDataApi = () => request.get('/report/emp/job')
export const queryEmpGenderDataApi = () => request.get('/report/emp/gender')
export const queryStudentCountDataApi = () => request.get('/report/stu/count')
export const queryStudentDegreeDataApi = () => request.get('/report/stu/degree')