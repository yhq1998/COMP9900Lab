/**
 * 用户状态管理
 */
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { loginApi } from '@/api'
import { setStorageItem, removeStorageItem } from '@/utils/helpers'
import router from '@/router'
import { ElMessage } from 'element-plus'

export const useUserStore = defineStore('user', () => {
  // 状态
  const currentUser = ref(null)
  const token = ref('')
  const isLoggedIn = computed(() => !!token.value)
  
  // 用户名和角色
  const username = computed(() => currentUser.value?.name || '')
  const userRole = computed(() => currentUser.value?.role || 'user')
  
  // 登录方法
  const login = async (loginData) => {
    try {
      const res = await loginApi(loginData)
      if (res.code === 1) {
        // 保存管理员信息和token
        currentUser.value = res.data.admin || {}
        token.value = res.data.token
        
        // 构建完整的登录管理员信息对象
        const loginUserData = {
          ...currentUser.value,
          token: res.data.token,
          role: 'admin' // 固定为admin角色
        }
        
        // 存储到localStorage
        setStorageItem('loginUser', loginUserData)
        
        // 提示登录成功
        ElMessage.success('Login successful')
        
        // 跳转到首页
        router.push('/admin/dashboard')
        return true
      } else {
        ElMessage.error(res.msg || '登录失败')
        return false
      }
    } catch (error) {
      console.error('登录异常:', error)
      ElMessage.error('登录异常，请稍后重试')
      return false
    }
  }
  
  // 退出登录
  const logout = () => {
    // 清除用户信息
    currentUser.value = null
    token.value = ''
    
    // 清除localStorage
    removeStorageItem('loginUser')
    
    // 跳转到登录页
    router.push('/')
  }
  
  // 从localStorage恢复用户状态
  const restoreUserState = () => {
    const storedUser = localStorage.getItem('loginUser')
    if (storedUser) {
      try {
        const userData = JSON.parse(storedUser)
        currentUser.value = userData
        token.value = userData.token
      } catch (error) {
        console.error('恢复用户状态失败:', error)
        removeStorageItem('loginUser')
      }
    }
  }
  
  return {
    currentUser,
    token,
    isLoggedIn,
    username,
    userRole,
    login,
    logout,
    restoreUserState
  }
})