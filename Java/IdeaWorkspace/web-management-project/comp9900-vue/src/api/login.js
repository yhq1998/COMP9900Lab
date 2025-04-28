import { login } from './auth'
import request from '@/utils/request'

//管理员登录
export const loginApi = login

//管理员注册
export const registerApi = async (data) => {
  console.log('管理员注册API被调用，参数：', data)
  try {
    const response = await request.post('/auth/register', data)
    console.log('管理员注册API响应：', response)
    return response
  } catch (error) {
    console.error('管理员注册API错误：', error)
    throw error
  }
}