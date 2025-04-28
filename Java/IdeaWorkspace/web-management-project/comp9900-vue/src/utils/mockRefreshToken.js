/**
 * 模拟刷新token的工具函数
 * 由于后端可能没有实现刷新token的API，这个函数模拟了刷新token的逻辑
 * 在生产环境中，应该替换为真实的API调用
 */

// 这个函数解析JWT token并提取payload
export function parseJwt(token) {
  try {
    if (!token || typeof token !== 'string') {
      console.error('解析JWT：无效的token格式', token);
      return null;
    }
    
    const parts = token.split('.');
    if (parts.length !== 3) {
      console.error('解析JWT：token结构不符合JWT标准', token);
      return null;
    }
    
    try {
      const base64Url = parts[1];
      const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
      const jsonPayload = decodeURIComponent(atob(base64).split('').map(c => {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
      }).join(''));

      const payload = JSON.parse(jsonPayload);
      console.log('JWT payload解析成功:', JSON.stringify(payload));
      
      // 检查token是否过期
      if (payload.exp && payload.exp * 1000 < Date.now()) {
        console.warn('token已过期，过期时间:', new Date(payload.exp * 1000).toLocaleString());
      }
      
      return payload;
    } catch (decodeError) {
      console.error('JWT payload解码或解析失败:', decodeError);
      return null;
    }
  } catch (e) {
    console.error('解析JWT token失败:', e);
    return null;
  }
}

// 这个函数生成一个新的JWT token，模拟后端刷新token的行为
export function generateMockToken(oldToken) {
  console.log('准备生成模拟token，旧token:', oldToken ? oldToken.substring(0, 20) + '...' : 'null');
  
  // 解析原始token获取payload
  const payload = parseJwt(oldToken);
  
  if (!payload) {
    console.error('无法从旧token中提取payload，token可能无效');
    return null;
  }
  
  // 复制payload并设置新的过期时间（1小时后）
  const newPayload = { ...payload };
  newPayload.exp = Math.floor(Date.now() / 1000) + 60 * 60; // 1小时后过期
  // 确保刷新token时间戳更新
  newPayload.iat = Math.floor(Date.now() / 1000); // 当前时间
  
  console.log('新token颁发时间:', new Date(newPayload.iat * 1000).toLocaleString());
  console.log('新token过期时间:', new Date(newPayload.exp * 1000).toLocaleString());
  
  // 用于签名的secret key（在实际环境中，这应该是服务器保密的）
  const secretKey = 'mockSecretKey123';
  
  // 创建JWT header
  const header = {
    alg: 'HS256',
    typ: 'JWT'
  };
  
  try {
    // 编码header和payload
    const encodedHeader = btoa(JSON.stringify(header))
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=/g, '');
      
    const encodedPayload = btoa(JSON.stringify(newPayload))
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=/g, '');
    
    // 生成签名（在生产环境中，应该使用密码学安全的算法）
    // 这里我们只是简单地使用base64编码模拟签名
    const signature = btoa(`${encodedHeader}.${encodedPayload}.${secretKey}`)
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=/g, '');
    
    // 返回新的JWT token
    const newToken = `${encodedHeader}.${encodedPayload}.${signature}`;
    console.log('生成的模拟token:', newToken.substring(0, 20) + '...');
    return newToken;
  } catch (encodeError) {
    console.error('生成模拟token失败:', encodeError);
    return null;
  }
}

// 模拟刷新token的API
export async function mockRefreshToken(oldToken) {
  console.log('开始模拟刷新token...');
  return new Promise((resolve) => {
    // 模拟网络延迟
    setTimeout(() => {
      if (!oldToken) {
        console.error('刷新token失败：oldToken不存在');
        resolve({
          code: 401,
          message: '刷新token失败：无效token'
        });
        return;
      }
      
      try {
        // 检查token格式
        if (typeof oldToken !== 'string' || !oldToken.includes('.')) {
          console.error('刷新token失败：token格式不正确', oldToken);
          resolve({
            code: 401,
            message: '刷新token失败：token格式不正确'
          });
          return;
        }
        
        // 生成新token
        const newToken = generateMockToken(oldToken);
        
        // 模拟API响应
        if (newToken) {
          console.log('模拟刷新token成功');
          resolve({
            code: 200,
            message: '刷新token成功',
            token: newToken
          });
        } else {
          console.error('模拟刷新token失败');
          resolve({
            code: 401,
            message: '刷新token失败：无法生成新token'
          });
        }
      } catch (error) {
        console.error('模拟刷新token过程中发生异常:', error);
        resolve({
          code: 500,
          message: '刷新token过程中发生异常'
        });
      }
    }, 300); // 模拟300ms网络延迟
  });
} 