// 前端API测试脚本
import axios from 'axios';

// 设置API基础URL
const BASE_URL = 'http://localhost:8080';
const api = axios.create({
  baseURL: BASE_URL,
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json'
  }
});

// 测试函数
async function testApiConnectivity() {
  console.log('开始测试前后端连通性...');
  const results = [];

  try {
    // 1. 测试用户注册
    console.log('\n测试用户注册...');
    try {
      const registerResponse = await api.post('/auth/register', {
        username: 'testuser1',
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '1234567890',
        password: 'password123'
      });
      console.log('注册响应:', registerResponse.data);
      results.push({ test: '用户注册', success: true, data: registerResponse.data });
    } catch (error) {
      console.error('注册失败:', error.response?.data || error.message);
      results.push({ test: '用户注册', success: false, error: error.response?.data || error.message });
    }

    // 2. 测试用户登录
    console.log('\n测试用户登录...');
    let loginData;
    try {
      const loginResponse = await api.post('/auth/login', {
        username: 'testuser1',
        password: 'password123'
      });
      loginData = loginResponse.data;
      console.log('登录响应:', loginData);
      results.push({ test: '用户登录', success: true, data: loginData });
    } catch (error) {
      console.error('登录失败:', error.response?.data || error.message);
      results.push({ test: '用户登录', success: false, error: error.response?.data || error.message });
    }

    // 3. 测试获取所有用户
    console.log('\n测试获取所有用户...');
    try {
      const usersResponse = await api.get('/users');
      console.log('用户列表响应:', usersResponse.data);
      results.push({ test: '获取用户列表', success: true, data: usersResponse.data });
    } catch (error) {
      console.error('获取用户列表失败:', error.response?.data || error.message);
      results.push({ test: '获取用户列表', success: false, error: error.response?.data || error.message });
    }

    // 4. 测试创建订单
    console.log('\n测试创建订单...');
    let orderId;
    try {
      const orderResponse = await api.post('/orders', {
        orderNumber: 'ORD-TEST-001',
        userId: 1,
        startLocation: 'Sydney CBD',
        endLocation: 'Bondi Beach',
        estimatedTime: 30,
        fare: 25.50,
        passengerCount: 2,
        luggageInfo: '2 bags',
        status: 'PENDING'
      });
      console.log('创建订单响应:', orderResponse.data);
      results.push({ test: '创建订单', success: true, data: orderResponse.data });
      
      // 提取订单ID
      if (orderResponse.data && orderResponse.data.data && orderResponse.data.data.id) {
        orderId = orderResponse.data.data.id;
      }
    } catch (error) {
      console.error('创建订单失败:', error.response?.data || error.message);
      results.push({ test: '创建订单', success: false, error: error.response?.data || error.message });
    }

    // 5. 测试获取所有订单
    console.log('\n测试获取所有订单...');
    try {
      const ordersResponse = await api.get('/orders');
      console.log('订单列表响应:', ordersResponse.data);
      results.push({ test: '获取订单列表', success: true, data: ordersResponse.data });
    } catch (error) {
      console.error('获取订单列表失败:', error.response?.data || error.message);
      results.push({ test: '获取订单列表', success: false, error: error.response?.data || error.message });
    }

    // 如果有订单ID，测试更新和删除
    if (orderId) {
      // 6. 测试更新订单
      console.log(`\n测试更新订单 ID: ${orderId}...`);
      try {
        const updateResponse = await api.put(`/orders/${orderId}`, {
          id: orderId,
          fare: 30.00,
          status: 'CONFIRMED'
        });
        console.log('更新订单响应:', updateResponse.data);
        results.push({ test: '更新订单', success: true, data: updateResponse.data });
      } catch (error) {
        console.error('更新订单失败:', error.response?.data || error.message);
        results.push({ test: '更新订单', success: false, error: error.response?.data || error.message });
      }

      // 7. 测试获取特定订单
      console.log(`\n测试获取特定订单 ID: ${orderId}...`);
      try {
        const orderDetailResponse = await api.get(`/orders/${orderId}`);
        console.log('订单详情响应:', orderDetailResponse.data);
        results.push({ test: '获取订单详情', success: true, data: orderDetailResponse.data });
      } catch (error) {
        console.error('获取订单详情失败:', error.response?.data || error.message);
        results.push({ test: '获取订单详情', success: false, error: error.response?.data || error.message });
      }

      // 8. 测试删除订单
      console.log(`\n测试删除订单 ID: ${orderId}...`);
      try {
        const deleteResponse = await api.delete(`/orders/${orderId}`);
        console.log('删除订单响应:', deleteResponse.data);
        results.push({ test: '删除订单', success: true, data: deleteResponse.data });
      } catch (error) {
        console.error('删除订单失败:', error.response?.data || error.message);
        results.push({ test: '删除订单', success: false, error: error.response?.data || error.message });
      }
    }

  } catch (error) {
    console.error('测试过程中发生错误:', error);
  }

  // 输出测试结果摘要
  console.log('\n测试结果摘要:');
  results.forEach(result => {
    console.log(`${result.test}: ${result.success ? '成功' : '失败'}`);
  });

  return results;
}

// 导出测试函数
export default testApiConnectivity;