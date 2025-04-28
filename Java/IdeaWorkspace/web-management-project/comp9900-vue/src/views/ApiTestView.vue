<template>
  <div class="api-test-container">
    <h1>Frontend-Backend Connectivity Test</h1>
    
    <el-card class="test-card">
      <template #header>
        <div class="card-header">
          <h2>Test Control Panel</h2>
          <el-button type="primary" @click="runAllTests" :loading="isLoading">Run All Tests</el-button>
        </div>
      </template>
      
      <div class="test-options">
        <el-checkbox v-model="testOptions.register">User Registration</el-checkbox>
        <el-checkbox v-model="testOptions.login">User Login</el-checkbox>
        <el-checkbox v-model="testOptions.userList">Get User List</el-checkbox>
        <el-checkbox v-model="testOptions.createOrder">Create Order</el-checkbox>
        <el-checkbox v-model="testOptions.orderList">Get Order List</el-checkbox>
        <el-checkbox v-model="testOptions.updateOrder">Update Order</el-checkbox>
        <el-checkbox v-model="testOptions.orderDetail">Get Order Details</el-checkbox>
        <el-checkbox v-model="testOptions.deleteOrder">Delete Order</el-checkbox>
      </div>
    </el-card>
    
    <el-card class="test-card" v-if="testResults.length > 0">
      <template #header>
        <div class="card-header">
          <h2>Test Results</h2>
          <el-tag :type="allTestsPassed ? 'success' : 'danger'">
            {{ allTestsPassed ? 'All Passed' : 'Some Failed' }}
          </el-tag>
        </div>
      </template>
      
      <el-table :data="testResults" style="width: 100%">
        <el-table-column prop="test" label="Test Item" width="180" />
        <el-table-column prop="status" label="Status" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.success ? 'success' : 'danger'">
              {{ scope.row.success ? 'Success' : 'Failed' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="message" label="Details" />
        <el-table-column label="Action" width="120">
          <template #default="scope">
            <el-button 
              type="primary" 
              size="small" 
              @click="showResponseDetails(scope.row)"
              :disabled="!scope.row.data"
            >
              View Details
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <!-- 响应详情对话框 -->
    <el-dialog
      v-model="dialogVisible"
      title="Response Details"
      width="50%"
    >
      <pre class="response-json">{{ JSON.stringify(currentResponseData, null, 2) }}</pre>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';
import { ElMessage } from 'element-plus';

export default {
  name: 'ApiTestView',
  data() {
    return {
      isLoading: false,
      testOptions: {
        register: true,
        login: true,
        userList: true,
        createOrder: true,
        orderList: true,
        updateOrder: true,
        orderDetail: true,
        deleteOrder: true
      },
      testResults: [],
      dialogVisible: false,
      currentResponseData: null,
      // 测试数据
      testData: {
        user: {
          username: 'testuser1',
          fullName: 'Test User',
          email: 'test@example.com',
          phoneNumber: '1234567890',
          password: 'password123'
        },
        order: {
          orderNumber: 'ORD-TEST-001',
          userId: 1,
          startLocation: 'Sydney CBD',
          endLocation: 'Bondi Beach',
          estimatedTime: 30,
          fare: 25.50,
          passengerCount: 2,
          luggageInfo: '2 bags',
          status: 'PENDING'
        }
      },
      createdOrderId: null
    };
  },
  computed: {
    allTestsPassed() {
      return this.testResults.length > 0 && this.testResults.every(result => result.success);
    }
  },
  methods: {
    async runAllTests() {
      this.isLoading = true;
      this.testResults = [];
      this.createdOrderId = null;
      
      // 设置API基础URL
      const api = axios.create({
        baseURL: '/api',  // 使用相对路径，依赖于Vue的代理配置
        timeout: 10000,
        headers: {
          'Content-Type': 'application/json'
        }
      });
      
      try {
        // 1. 测试用户注册
        if (this.testOptions.register) {
          try {
            const registerResponse = await api.post('/auth/register', this.testData.user);
            this.addTestResult('User Registration', true, 'Registration successful', registerResponse.data);
          } catch (error) {
            this.addTestResult('User Registration', false, this.getErrorMessage(error), error.response?.data);
          }
        }
        
        // 2. 测试用户登录
        if (this.testOptions.login) {
          try {
            const loginResponse = await api.post('/auth/login', {
              username: this.testData.user.username,
              password: this.testData.user.password
            });
            this.addTestResult('User Login', true, 'Login successful', loginResponse.data);
          } catch (error) {
            this.addTestResult('User Login', false, this.getErrorMessage(error), error.response?.data);
          }
        }
        
        // 3. 测试获取所有用户
        if (this.testOptions.userList) {
          try {
            const usersResponse = await api.get('/users');
            this.addTestResult('Get User List', true, `Successfully retrieved ${usersResponse.data?.data?.length || 0} users`, usersResponse.data);
          } catch (error) {
            this.addTestResult('Get User List', false, this.getErrorMessage(error), error.response?.data);
          }
        }
        
        // 4. 测试创建订单
        if (this.testOptions.createOrder) {
          try {
            const orderResponse = await api.post('/orders', this.testData.order);
            this.createdOrderId = orderResponse.data?.data?.id;
            this.addTestResult('Create Order', true, `Successfully created order ID: ${this.createdOrderId}`, orderResponse.data);
          } catch (error) {
            this.addTestResult('Create Order', false, this.getErrorMessage(error), error.response?.data);
          }
        }
        
        // 5. 测试获取所有订单
        if (this.testOptions.orderList) {
          try {
            const ordersResponse = await api.get('/orders');
            this.addTestResult('Get Order List', true, `Successfully retrieved ${ordersResponse.data?.data?.length || 0} orders`, ordersResponse.data);
          } catch (error) {
            this.addTestResult('Get Order List', false, this.getErrorMessage(error), error.response?.data);
          }
        }
        
        // 如果有订单ID，测试更新和删除
        if (this.createdOrderId) {
          // 6. 测试更新订单
          if (this.testOptions.updateOrder) {
            try {
              const updateResponse = await api.put(`/orders/${this.createdOrderId}`, {
                id: this.createdOrderId,
                fare: 30.00,
                status: 'CONFIRMED'
              });
              this.addTestResult('Update Order', true, `Successfully updated order ID: ${this.createdOrderId}`, updateResponse.data);
            } catch (error) {
              this.addTestResult('Update Order', false, this.getErrorMessage(error), error.response?.data);
            }
          }
          
          // 7. 测试获取特定订单
          if (this.testOptions.orderDetail) {
            try {
              const orderDetailResponse = await api.get(`/orders/${this.createdOrderId}`);
              this.addTestResult('Get Order Details', true, `Successfully retrieved details for order ID: ${this.createdOrderId}`, orderDetailResponse.data);
            } catch (error) {
              this.addTestResult('Get Order Details', false, this.getErrorMessage(error), error.response?.data);
            }
          }
          
          // 8. 测试删除订单
          if (this.testOptions.deleteOrder) {
            try {
              const deleteResponse = await api.delete(`/orders/${this.createdOrderId}`);
              this.addTestResult('Delete Order', true, `Successfully deleted order ID: ${this.createdOrderId}`, deleteResponse.data);
            } catch (error) {
              this.addTestResult('Delete Order', false, this.getErrorMessage(error), error.response?.data);
            }
          }
        } else if (this.testOptions.updateOrder || this.testOptions.orderDetail || this.testOptions.deleteOrder) {
          // 如果没有创建订单但选择了这些测试
          if (this.testOptions.updateOrder) {
            this.addTestResult('Update Order', false, 'Cannot execute: Failed to create order or get order ID');
          }
          if (this.testOptions.orderDetail) {
            this.addTestResult('Get Order Details', false, 'Cannot execute: Failed to create order or get order ID');
          }
          if (this.testOptions.deleteOrder) {
            this.addTestResult('Delete Order', false, 'Cannot execute: Failed to create order or get order ID');
          }
        }
        
      } catch (error) {
        ElMessage.error('Error occurred during test: ' + error.message);
      } finally {
        this.isLoading = false;
      }
    },
    
    addTestResult(test, success, message, data = null) {
      this.testResults.push({
        test,
        success,
        message,
        data
      });
    },
    
    getErrorMessage(error) {
      return error.response?.data?.msg || error.message || 'Unknown error';
    },
    
    showResponseDetails(row) {
      this.currentResponseData = row.data;
      this.dialogVisible = true;
    }
  }
};
</script>

<style scoped>
.api-test-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.test-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.test-options {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-bottom: 20px;
}

.response-json {
  background-color: #f5f7fa;
  padding: 15px;
  border-radius: 4px;
  overflow: auto;
  max-height: 400px;
}
</style>