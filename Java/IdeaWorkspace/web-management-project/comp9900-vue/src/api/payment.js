import request from '@/utils/request'

/**
 * 分页查询支付记录
 * @param {Object} params 查询参数
 * @returns Promise
 */
export const queryPaymentPageApi = (params) => {
  return request.get('/payments', { params })
}

/**
 * 获取支付详情
 * @param {String} id 支付ID
 * @returns Promise
 */
export const getPaymentDetailApi = (id) => {
  return request.get(`/payments/${id}`)
}

/**
 * 根据订单ID查询支付记录
 * @param {Number} orderId 订单ID
 * @returns Promise
 */
export const getPaymentsByOrderIdApi = (orderId) => {
  return request.get(`/payments/order/${orderId}`)
}

/**
 * 创建支付记录
 * @param {Object} data 支付数据
 * @returns Promise
 */
export const createPaymentApi = (data) => {
  return request.post('/payments', data)
}

/**
 * 更新支付记录
 * @param {String} id 支付ID
 * @param {Object} data 更新数据
 * @returns Promise
 */
export const updatePaymentApi = (id, data) => {
  return request.put(`/payments/${id}`, data)
}

/**
 * 删除支付记录
 * @param {String} id 支付ID
 * @returns Promise
 */
export const deletePaymentApi = (id) => {
  return request.delete(`/payments/${id}`)
}

/**
 * 更新支付状态
 * @param {String} id 支付ID
 * @param {String} status 支付状态
 * @returns Promise
 */
export const updatePaymentStatusApi = (id, status) => {
  return request.put(`/payments/${id}/status?status=${status}`)
}

/**
 * 确认支付
 * @param {String} id 支付ID
 * @param {Object} data 支付确认数据
 * @returns Promise
 */
export const confirmPaymentApi = (id, data) => {
  return request.post(`/payments/${id}/confirm`, null, { params: data })
}

/**
 * 退款处理
 * @param {String} id 支付ID
 * @param {Object} data 退款数据
 * @returns Promise
 */
export const refundPaymentApi = (id, data) => {
  return request.post(`/payments/${id}/refund`, null, { params: data })
}

/**
 * 取消支付
 * @param {String} id 支付ID
 * @returns Promise
 */
export const cancelPaymentApi = (id) => {
  return request.post(`/payments/${id}/cancel`)
}