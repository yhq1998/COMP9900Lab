import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '../router'
import { refreshToken as refreshTokenApi } from '../api/auth'
import { parseJwt } from './mockRefreshToken'

// 创建axios实例对象
const request = axios.create({
  baseURL: '/api',  // 修改为使用统一的API前缀
  timeout: 10000,
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 记录是否正在刷新token
let isRefreshing = false
// 存储等待刷新token的请求队列
let refreshSubscribers = []

// 执行队列中的请求
const onRefreshed = (token) => {
  refreshSubscribers.forEach(callback => callback(token))
  refreshSubscribers = []
}

// 添加请求到队列
const addSubscriber = (callback) => {
  refreshSubscribers.push(callback)
}

// 检查token是否过期
const isTokenExpired = (token) => {
  try {
    const decoded = parseJwt(token)
    return decoded.exp * 1000 < Date.now()
  } catch (error) {
    console.error('Failed to parse token:', error)
    return true
  }
}

// 刷新token
const refreshToken = async () => {
  try {
    const loginUserStr = localStorage.getItem('loginUser')
    if (loginUserStr) {
      const loginUser = JSON.parse(loginUserStr)
      if (loginUser && loginUser.refreshToken) {
        const response = await refreshTokenApi(loginUser.refreshToken)
        if (response && response.token) {
          // 更新localStorage中的token
          loginUser.token = response.token
          localStorage.setItem('loginUser', JSON.stringify(loginUser))
          return response.token
        }
      }
    }
    return null
  } catch (error) {
    console.error('刷新token失败:', error)
    return null
  }
}

// axios的请求 request 拦截器
request.interceptors.request.use(
  async (config) => {
    console.log(`发起请求: ${config.method} ${config.url}`)
    
    // 标记重试请求以避免无限循环
    if (config.retryAttempt) {
      console.log('这是重试请求:', config.url);
    }
    
    // 强制刷新token的请求类型
    const isStatusUpdate = config.headers && config.headers['X-Request-Type'] === 'status-update';
    
    // 检查是否需要添加认证信息
    const needsAuth = !config.url.includes('/login') && !config.url.includes('/register');
    
    if (needsAuth) {
      // 对于订单状态更新，每次都获取最新的token，不依赖缓存
      const loginUserStr = localStorage.getItem('loginUser');
      if (loginUserStr) {
        try {
          const loginUser = JSON.parse(loginUserStr);
          if (loginUser && loginUser.token) {
            console.log('找到token:', loginUser.token.substring(0, 20) + '...');
            
            // 检查token是否过期或强制刷新
            const tokenExpired = isTokenExpired(loginUser.token);
            
            if (tokenExpired) {
              console.log('Token已过期，尝试刷新...');
              
              // 如果已经在刷新token，则将请求加入队列
              if (isRefreshing) {
                console.log('已有刷新token过程在进行，将请求加入队列');
                return new Promise((resolve) => {
                  addSubscriber(token => {
                    config.headers.Authorization = `Bearer ${token}`;
                    console.log('使用新token更新请求:', config.url);
                    resolve(config);
                  });
                });
              }
              
              isRefreshing = true;
              
              try {
                // 尝试刷新token
                const newToken = await refreshToken();
                
                if (newToken) {
                  console.log('Token刷新成功, 新token:', newToken.substring(0, 20) + '...');
                  config.headers.Authorization = `Bearer ${newToken}`;
                  onRefreshed(newToken);
                } else {
                  console.log('Token刷新失败');
                  
                  // 状态更新请求不跳转到登录页，而是继续尝试使用旧token
                  if (isStatusUpdate) {
                    console.log('状态更新请求，尝试使用旧token继续');
                    config.headers.Authorization = `Bearer ${loginUser.token}`;
                  } else {
                    console.log('非状态更新请求，跳转到登录页');
                    // 刷新失败，清除信息并跳转到登录页
                    localStorage.removeItem('loginUser');
                    ElMessage.error('登录已过期，请重新登录');
                    router.push('/login');
                    return Promise.reject('登录已过期');
                  }
                }
              } finally {
                isRefreshing = false;
              }
            } else {
              // token未过期，正常使用
              console.log('Token有效，添加到请求头');
              config.headers.Authorization = `Bearer ${loginUser.token}`;
            }
            
            // 打印请求头，确认token被正确设置
            console.log('请求头:', JSON.stringify(config.headers));
          } else {
            console.log('没有找到有效token');
          }
        } catch (error) {
          console.error('解析loginUser出错:', error);
        }
      } else {
        console.log('localStorage中未找到loginUser');
      }
    }
    
    return config;
  },
  error => {
    console.error('请求拦截器错误:', error);
    return Promise.reject(error);
  }
);

// 创建请求重试函数
const retryRequest = async (error) => {
  const config = error.config;
  
  // 如果已经重试过了，不再重试
  if (config.retryAttempt) {
    return Promise.reject(error);
  }
  
  // 标记这是一个重试请求
  config.retryAttempt = true;
  
  // 刷新token
  try {
    const newToken = await refreshToken();
    if (newToken) {
      console.log('Token已刷新，重试请求:', config.url);
      config.headers.Authorization = `Bearer ${newToken}`;
      return request(config);
    }
  } catch (refreshError) {
    console.error('刷新token失败:', refreshError);
  }
  
  return Promise.reject(error);
};

// axios的响应 response 拦截器
request.interceptors.response.use(
  (response) => { // 成功回调
    console.log(`Request successful: ${response.config.url}`, response.status);
    return response.data;
  },
  async (error) => { // 失败回调
    console.error('Request failed:', error);
    
    // 检查是否为状态更新请求
    const isStatusUpdate = error.config?.headers && error.config.headers['X-Request-Type'] === 'status-update';
    
    if (error.response) {
      console.log('Server response:', error.response.status, error.response.data);
      
      // 检查是否为订单操作
      const isOrderOperation = error.config && 
        error.config.url.includes('/orders/');
        
      // Handle 401 and 403 status codes
      if (error.response.status === 401 || error.response.status === 403) {
        // 状态更新请求特殊处理：不跳转登录页，返回错误给前端处理
        if (isStatusUpdate) {
          console.log('状态更新请求认证失败，返回给前端处理');
          return Promise.reject(error);
        }
        
        // 如果是订单操作且没有尝试过重试，先尝试刷新token并重试请求
        if (isOrderOperation && !error.config.retryAttempt) {
          console.log('订单操作请求失败，尝试刷新token后重试:', error.config.url);
          try {
            return await retryRequest(error);
          } catch (retryError) {
            console.error('重试失败:', retryError);
            // 状态更新请求不显示全局消息，让前端处理
            if (!isStatusUpdate) {
              ElMessage.error('操作失败，请检查您的登录状态');
            }
            return Promise.reject(retryError);
          }
        }
        
        // 如果是订单操作，只显示错误消息，不跳转
        if (isOrderOperation) {
          console.log('订单操作失败，不跳转登录页:', error.config.url);
          return Promise.reject(error);
        }
        
        // Only clear login info and redirect if not refreshing token and not order status update
        if (!isRefreshing && !isStatusUpdate) {
          console.log('Server responded with 401/403, checking authentication status', error.response);
          
          // Avoid duplicate messages
          const errorMsg = error.response.data?.message || 'Login expired or insufficient permissions, please login again';
          ElMessage.error(errorMsg);
          
          // Clear invalid login info
          localStorage.removeItem('loginUser');
          
          // Redirect to login page
          if (router.currentRoute.value.path !== '/login') {
            router.push('/login');
          }
        }
      } else {
        // Handle other errors
        // 状态更新请求不显示全局消息，让前端处理
        if (!isStatusUpdate) {
          ElMessage.error(error.response.data?.message || 'Request failed');
        }
      }
    } else if (error.request) {
      // Request sent but no response received
      console.log('No response received:', error.request);
      // 状态更新请求不显示全局消息，让前端处理
      if (!isStatusUpdate) {
        ElMessage.error('Server not responding, please check network connection');
      }
    } else {
      // Request configuration error
      console.log('Request configuration error:', error.message);
      // 状态更新请求不显示全局消息，让前端处理
      if (!isStatusUpdate) {
        ElMessage.error('Request error: ' + error.message);
      }
    }
    
    return Promise.reject(error);
  }
);

export default request