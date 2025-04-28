import axios from 'axios'
import { mockRefreshToken } from '@/utils/mockRefreshToken'

// 获取request实例（避免循环依赖）
const getRequest = () => {
  return require('@/utils/request').default
}

// 用户登录
export function login(data) {
  console.log('开始登录请求，数据:', JSON.stringify(data))
  const request = getRequest()
  return request({
    url: '/auth/admin/login',
    method: 'post',
    data
  })
}

// 检查登录响应，确保token格式正确
export function checkLoginResponse(response) {
  if (!response) {
    console.error('登录响应为空')
    return false
  }
  
  console.log('登录响应:', JSON.stringify(response))
  
  if (!response.token) {
    console.error('登录响应中没有token')
    return false
  }
  
  // 检查token格式是否为JWT格式（简单检查）
  const tokenParts = response.token.split('.')
  if (tokenParts.length !== 3) {
    console.error('token不符合JWT格式')
    return false
  }
  
  return true
}

// 刷新token - 使用原始axios实例而非带拦截器的request
// 避免陷入循环调用refresh token
export async function refreshToken(token) {
  console.log('refreshToken被调用，token:', token ? token.substring(0, 20) + '...' : 'null')
  
  if (!token) {
    console.error('refreshToken: token为空')
    return null
  }
  
  try {
    // TODO: 在后端实现真实的刷新token接口后替换为下面注释的代码
    /*
    const response = await axios({
      method: 'post',
      url: 'http://localhost:8080/auth/refresh-token',
      headers: {
        'Authorization': `Bearer ${token}`
      }
    })
    return response.data
    */
    
    // 使用模拟刷新token功能
    const result = await mockRefreshToken(token)
    console.log('mockRefreshToken结果:', JSON.stringify(result))
    return result
  } catch (error) {
    console.error('刷新token失败:', error)
    return null
  }
}

// 用户登出
export function logout() {
  console.log('调用登出API')
  const request = getRequest()
  return request({
    url: '/auth/logout',
    method: 'post'
  })
}

// 获取当前用户信息
export function getUserInfo() {
  console.log('获取用户信息')
  const request = getRequest()
  return request({
    url: '/auth/user-info',
    method: 'get'
  })
} 