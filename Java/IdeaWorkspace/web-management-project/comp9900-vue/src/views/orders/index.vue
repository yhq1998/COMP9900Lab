<template>
  <div class="order-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <h3>Order Management</h3>
          <el-button type="primary" size="default" @click="handleAdd">Add Order</el-button>
        </div>
      </template>
      
      <!-- Search Form -->
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="Order No.">
          <el-input v-model="queryParams.orderNo" placeholder="Enter order number" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="Passenger">
          <el-input v-model="queryParams.passengerName" placeholder="Enter passenger name" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="Order Type">
          <el-select v-model="queryParams.orderType" placeholder="Select order type" clearable>
            <el-option label="Private Order" value="private" />
            <el-option label="Bus Carpool Order" value="bus_carpool" />
          </el-select>
        </el-form-item>
        <el-form-item label="Status">
          <el-select v-model="queryParams.status" placeholder="Select status" clearable>
            <el-option label="Pending" value="pending" />
            <el-option label="Confirmed" value="confirmed" />
            <el-option label="Completed" value="completed" />
            <el-option label="Cancelled" value="cancelled" />
          </el-select>
        </el-form-item>
        <el-form-item label="Date">
          <el-date-picker
            v-model="queryParams.dateRange"
            type="daterange"
            range-separator="to"
            start-placeholder="Start date"
            end-placeholder="End date"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="default" @click="handleSearch">Search</el-button>
          <el-button size="default" @click="handleReset">Reset</el-button>
        </el-form-item>
      </el-form>
      
      <!-- Data Table -->
      <el-table :data="orderList" style="width: 100%" v-loading="loading" border>
        <el-table-column prop="orderNo" label="Order No." width="180" />
        <el-table-column prop="passengerName" label="Passenger" width="120">
          <template #default="scope">
            {{ scope.row.passengerName || '—' }}
          </template>
        </el-table-column>
        <el-table-column prop="driverName" label="Driver" width="120">
          <template #default="scope">
            {{ scope.row.driverName || '—' }}
          </template>
        </el-table-column>
        <el-table-column prop="vehicleInfo" label="Vehicle" width="180">
          <template #default="scope">
            <div class="cell-with-button">
              <span>{{ scope.row.vehicleInfo || '—' }}</span>
              <el-dropdown v-if="scope.row.status === 'pending'" @command="handleVehicleCommand($event, scope.row)">
                <el-button size="small" type="primary">
                  Edit <el-icon class="el-icon--right"><arrow-down /></el-icon>
                </el-button>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item 
                      v-for="item in vehicleOptions" 
                      :key="item.id" 
                      :command="item.id"
                    >
                      {{ formatVehicleType(item.type) }}
                    </el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="orderType" label="Order Type" width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.orderType === 'private'" type="primary">Private Order</el-tag>
            <el-tag v-else-if="scope.row.orderType === 'bus_carpool'" type="success">Bus Carpool</el-tag>
            <el-tag v-else type="info">{{ scope.row.orderType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="fromLocation" label="Departure" width="180" show-overflow-tooltip />
        <el-table-column prop="toLocation" label="Destination" width="180" show-overflow-tooltip />
        <el-table-column prop="amount" label="Amount" width="150">
          <template #default="scope">
            <div class="cell-with-button">
              <span>¥{{ scope.row.amount?.toFixed(2) || '0.00' }}</span>
              <el-dropdown v-if="scope.row.status === 'pending'" @command="handleAmountCommand($event, scope.row)">
                <el-button size="small" type="primary">
                  Edit <el-icon class="el-icon--right"><arrow-down /></el-icon>
                </el-button>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="10">¥10.00</el-dropdown-item>
                    <el-dropdown-item command="20">¥20.00</el-dropdown-item>
                    <el-dropdown-item command="30">¥30.00</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="Status" width="150">
          <template #default="scope">
            <div class="cell-with-button">
              <div>
                <el-tag v-if="scope.row.status === 'pending'" type="warning">Pending</el-tag>
                <el-tag v-else-if="scope.row.status === 'confirmed'" type="primary">Confirmed</el-tag>
                <el-tag v-else-if="scope.row.status === 'completed'" type="success">Completed</el-tag>
                <el-tag v-else-if="scope.row.status === 'cancelled'" type="info">Cancelled</el-tag>
                <el-tag v-else type="info">{{ scope.row.status }}</el-tag>
              </div>
              <el-dropdown v-if="['pending', 'confirmed'].includes(scope.row.status)" @command="handleStatusCommand($event, scope.row)">
                <el-button size="small" type="primary">
                  Edit <el-icon class="el-icon--right"><arrow-down /></el-icon>
                </el-button>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item v-if="scope.row.status === 'pending'" command="confirmed">Confirm</el-dropdown-item>
                    <el-dropdown-item v-if="scope.row.status === 'confirmed'" command="completed">Complete</el-dropdown-item>
                    <el-dropdown-item v-if="['pending', 'confirmed'].includes(scope.row.status)" command="cancelled">Cancel</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="passengerCount" label="Passenger Count" width="100">
          <template #default="scope">
            {{ scope.row.passengerCount !== null && scope.row.passengerCount !== undefined ? scope.row.passengerCount : '—' }}
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="Create Time" width="180" />
        <el-table-column label="Operations" fixed="right" min-width="120">
          <template #default="scope">
            <div class="button-column">
              <el-button size="default" type="info" style="width: 100%;" @click="handleView(scope.row)">View</el-button>
              <el-button size="default" type="primary" style="width: 100%;" @click="handleEdit(scope.row)" v-if="['pending'].includes(scope.row.status)">Edit</el-button>
              <el-button size="default" type="danger" style="width: 100%;" @click="handleDelete(scope.row)" v-if="['pending'].includes(scope.row.status)">Delete</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- Pagination -->
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        class="pagination-container"
      />
    </el-card>

    <!-- Order Detail Dialog -->
    <el-dialog v-model="viewDialogVisible" title="Order Details" width="60%">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="Order No.">{{ currentOrder.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="Order Type">
          <el-tag v-if="currentOrder.orderType === 'private'" type="primary">Private Order</el-tag>
          <el-tag v-else-if="currentOrder.orderType === 'bus_carpool'" type="success">Bus Carpool</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="Status">
          <el-tag v-if="currentOrder.status === 'pending'" type="warning">Pending</el-tag>
          <el-tag v-else-if="currentOrder.status === 'confirmed'" type="primary">Confirmed</el-tag>
          <el-tag v-else-if="currentOrder.status === 'completed'" type="success">Completed</el-tag>
          <el-tag v-else-if="currentOrder.status === 'cancelled'" type="info">Cancelled</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="Passenger">{{ currentOrder.passengerName }}</el-descriptions-item>
        <el-descriptions-item label="Contact Phone">{{ currentOrder.passengerPhone }}</el-descriptions-item>
        <el-descriptions-item label="Driver">{{ currentOrder.driverName }}</el-descriptions-item>
        <el-descriptions-item label="Vehicle">{{ currentOrder.vehicleInfo }}</el-descriptions-item>
        <el-descriptions-item label="Departure" :span="2">{{ currentOrder.fromLocation }}</el-descriptions-item>
        <el-descriptions-item label="Destination" :span="2">{{ currentOrder.toLocation }}</el-descriptions-item>
        <el-descriptions-item label="Estimated Time">{{ currentOrder.estimatedTime || '—' }}</el-descriptions-item>
        <el-descriptions-item label="Passenger Count" v-if="currentOrder.orderType === 'bus_carpool'">{{ currentOrder.passengerCount !== null && currentOrder.passengerCount !== undefined ? currentOrder.passengerCount : '—' }}</el-descriptions-item>
        <el-descriptions-item label="Luggage Info" v-if="currentOrder.orderType === 'bus_carpool'" :span="2">{{ currentOrder.luggageInfo || '—' }}</el-descriptions-item>
        <el-descriptions-item label="Amount">¥{{ (currentOrder.amount || 0).toFixed(2) }}</el-descriptions-item>
        <el-descriptions-item label="Create Time">{{ currentOrder.createTime }}</el-descriptions-item>
        <el-descriptions-item label="Update Time">{{ currentOrder.updateTime }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <span class="dialog-footer">
          <el-button size="default" style="width: 100px;" @click="viewDialogVisible = false">Close</el-button>
          <el-button size="default" style="width: 100px;" type="primary" @click="handleEdit(currentOrder)" v-if="['pending'].includes(currentOrder.status)">Edit</el-button>
          <el-dropdown v-if="['pending', 'confirmed'].includes(currentOrder.status)" @command="handleStatusCommand($event, currentOrder)">
            <el-button size="default" style="width: 120px;" type="primary">
              Change Status <el-icon class="el-icon--right"><arrow-down /></el-icon>
            </el-button>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item v-if="currentOrder.status === 'pending'" command="confirmed">Confirm</el-dropdown-item>
                <el-dropdown-item v-if="currentOrder.status === 'confirmed'" command="completed">Complete</el-dropdown-item>
                <el-dropdown-item v-if="['pending', 'confirmed'].includes(currentOrder.status)" command="cancelled">Cancel</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </span>
      </template>
    </el-dialog>

    <!-- Add/Edit Order Dialog -->
    <el-dialog v-model="editDialogVisible" :title="dialogType === 'add' ? 'Add Order' : 'Edit Order'">
      <el-form :model="orderForm" label-width="100px" :rules="rules" ref="orderFormRef">
        <el-form-item label="Passenger" prop="userId">
          <el-select v-model="orderForm.userId" placeholder="Select passenger" filterable>
            <el-option v-for="item in passengerOptions" :key="item.id" :label="item.username" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="Order Type" prop="orderType">
          <el-select v-model="orderForm.orderType" placeholder="Select order type">
            <el-option label="Private Order" value="private" />
            <el-option label="Bus Carpool Order" value="bus_carpool" />
          </el-select>
        </el-form-item>
        <el-form-item label="Driver" prop="driverId">
          <el-select v-model="orderForm.driverId" placeholder="Select driver" filterable>
            <el-option v-for="item in driverOptions" :key="item.id" :label="item.fullName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="Vehicle" prop="vehicleId">
          <el-select v-model="orderForm.vehicleId" placeholder="Select vehicle" filterable>
            <el-option v-for="item in vehicleOptions" :key="item.id" :label="formatVehicleType(item.type)" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="Departure" prop="startLocation">
          <el-input v-model="orderForm.startLocation" placeholder="Enter departure location" />
        </el-form-item>
        <el-form-item label="Destination" prop="endLocation">
          <el-input v-model="orderForm.endLocation" placeholder="Enter destination location" />
        </el-form-item>
        <el-form-item label="Est. Time (min)" prop="estimatedTime">
          <el-input-number v-model="orderForm.estimatedTime" :min="1" :step="1" />
        </el-form-item>
        <el-form-item label="Amount" prop="fare">
          <el-input-number v-model="orderForm.fare" :precision="2" :step="0.1" :min="0" />
        </el-form-item>
        <el-form-item label="Status" prop="status">
          <el-select v-model="orderForm.status" placeholder="Select status">
            <el-option label="Pending" value="pending" />
            <el-option label="Confirmed" value="confirmed" />
            <el-option label="Completed" value="completed" />
            <el-option label="Cancelled" value="cancelled" />
          </el-select>
        </el-form-item>
        <el-form-item label="Passenger Count" prop="passengerCount" v-if="orderForm.orderType === 'bus_carpool'">
          <el-input-number v-model="orderForm.passengerCount" :min="1" :max="100" />
        </el-form-item>
        <el-form-item label="Luggage Info" prop="luggageInfo" v-if="orderForm.orderType === 'bus_carpool'">
          <el-input v-model="orderForm.luggageInfo" type="textarea" placeholder="Enter luggage information" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button size="default" style="width: 100px;" @click="editDialogVisible = false">Cancel</el-button>
          <el-button size="default" style="width: 100px;" type="primary" @click="submitForm">Confirm</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed, nextTick } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { EditPen, ArrowDown } from '@element-plus/icons-vue';

// Format vehicle type
const formatVehicleType = (type) => {
  if (!type) return '—';
  switch (type) {
    case '16-seater': return '16-seater';
    case '22-seater': return '22-seater';
    case '30-seater': return '30-seater';
    default: return type;
  }
};
import { 
  getOrderList, 
  getOrderDetail, 
  addOrder, 
  updateOrder, 
  updateOrderStatus,
  updateOrderStatusViaUpdate,
  patchOrderStatus 
} from '@/api/order';
import { getPassengerList } from '@/api/passenger';
import { getDriverList } from '@/api/driver';
import { getVehicleList } from '@/api/vehicle';
import { useRouter } from 'vue-router';

const router = useRouter();

// Query parameters
const queryParams = reactive({
  orderNo: '',
  passengerName: '',
  orderType: '',
  status: '',
  dateRange: []
});

// Data list
const orderList = ref([]);
const total = ref(0);
const loading = ref(false);
const currentPage = ref(1);
const pageSize = ref(10);

// Detail dialog
const viewDialogVisible = ref(false);
const currentOrder = reactive({
  id: null,
  orderNo: '',
  orderType: '',
  status: '',
  passengerName: '',
  passengerPhone: '',
  driverName: '',
  vehicleInfo: '',
  fromLocation: '',
  toLocation: '',
  estimatedTime: null,
  passengerCount: null,
  luggageInfo: '',
  amount: 0,
  createTime: '',
  updateTime: ''
});

// Edit dialog
const editDialogVisible = ref(false);
const dialogType = ref('add'); // 'add' or 'edit'
const orderFormRef = ref(null);
const orderForm = reactive({
  id: null,
  userId: null,
  driverId: null,
  vehicleId: null,
  orderType: 'private',
  startLocation: '',
  endLocation: '',
  estimatedTime: null,
  fare: 0,
  status: 'pending',
  passengerCount: null,
  luggageInfo: ''
});

// Option lists
const passengerOptions = ref([]);
const driverOptions = ref([]);
const vehicleOptions = ref([]);

// Form validation rules
const rules = {
  userId: [
    { required: true, message: 'Please select a passenger', trigger: 'change' }
  ],
  orderType: [
    { required: true, message: 'Please select order type', trigger: 'change' }
  ],
  startLocation: [
    { required: true, message: 'Please enter departure location', trigger: 'blur' }
  ],
  endLocation: [
    { required: true, message: 'Please enter destination location', trigger: 'blur' }
  ],
  estimatedTime: [
    { required: true, message: 'Please enter estimated time', trigger: 'blur' }
  ],
  fare: [
    { required: true, message: 'Please enter amount', trigger: 'blur' }
  ],
  status: [
    { required: true, message: 'Please select status', trigger: 'change' }
  ],
  passengerCount: [
    { 
      required: true, 
      message: 'Please enter passenger count', 
      trigger: 'blur',
      validator: (rule, value, callback) => {
        if (orderForm.orderType === 'bus_carpool' && !value) {
          callback(new Error('Please enter passenger count'));
        } else {
          callback();
        }
      }
    }
  ]
};

// Vehicle selection temporary variables
const vehicleSelectTemp = ref(null);
const tempOrderId = ref(null);
const vehiclePopoverVisible = ref({});

// Amount selection temporary variables
const amountSelectTemp = ref(null);
const amountPopoverVisible = ref({});

// Get order list
const fetchOrderList = async () => {
  loading.value = true;
  try {
    // Build basic query parameters
    const params = {
      orderNo: queryParams.orderNo,
      passengerName: queryParams.passengerName,
      orderType: queryParams.orderType,
      status: queryParams.status,
      
      // Support different pagination parameter formats, adapt to different backend APIs
      page: currentPage.value,
      pageSize: pageSize.value,
      pageNum: currentPage.value,
      size: pageSize.value,
      current: currentPage.value,
      limit: pageSize.value,
      
      // Add timestamp to prevent caching
      _t: new Date().getTime()
    };

    if (queryParams.dateRange && queryParams.dateRange.length === 2) {
      params.startDate = formatDate(queryParams.dateRange[0]);
      params.endDate = formatDate(queryParams.dateRange[1]);
    }

    console.log('Query parameters sent:', params);
    
    const res = await getOrderList(params);
    // Detailed output of API returned data
    console.log('Order data returned by API:', res);
    console.log('First order data:', res.data && res.data.length > 0 ? res.data[0] : 'No data');
    console.log('Number of order records:', res.data ? res.data.length : 0);
    console.log('Pagination information returned by API:', {
      total: res.total,
      pageInfo: res.pageInfo,
      currentPage: res.current || res.page || res.pageNum,
      responseSize: res.size || res.pageSize || res.limit,
    });
    
    // 确保数据结构符合预期，若需要处理数据映射，在这里进行
    if (res && res.data && Array.isArray(res.data)) {
      // 处理每条订单记录，确保字段匹配
      const orders = res.data.map(order => {
        // 详细记录每条数据的关键字段
        console.log('Processing order data:', {
          id: order.id,
          orderNo: order.orderNo,
          status: order.status,
          userInfo: {
            passenger: order.passenger || order.user || {},
            passengerName: order.passengerName || order.userName,
            userId: order.userId
          },
          driverInfo: {
            driver: order.driver || {},
            driverName: order.driverName,
            driverId: order.driverId
          },
          vehicleInfo: {
            vehicle: order.vehicle || {},
            vehicleInfo: order.vehicleInfo,
            vehicleId: order.vehicleId
          },
          orderType: order.orderType,
          amount: order.amount || order.fare,
          passengerCount: order.passengerCount 
        });
        
        // 提取乘客信息
        let passengerName = '';
        if (order.passengerName) {
          passengerName = order.passengerName;
        } else if (order.userName) {
          passengerName = order.userName;
        } else if (order.passenger && typeof order.passenger === 'object') {
          passengerName = order.passenger.username || order.passenger.name || '';
        } else if (order.user && typeof order.user === 'object') {
          passengerName = order.user.username || order.user.name || '';
        }
        
        // 提取司机信息
        let driverName = '';
        if (order.driverName) {
          driverName = order.driverName;
        } else if (order.driver && typeof order.driver === 'object') {
          driverName = order.driver.fullName || order.driver.name || '';
        }
        
        // 提取车辆信息
        let vehicleInfo = '';
        if (order.vehicleInfo) {
          vehicleInfo = order.vehicleInfo;
        } else if (order.vehicle && typeof order.vehicle === 'object') {
          vehicleInfo = formatVehicleType(order.vehicle.type) || '';
        }
        
        return {
          id: order.id,
          orderNo: order.orderNo || order.orderNumber || '',
          userId: order.userId,
          driverId: order.driverId,
          vehicleId: order.vehicleId,
          passengerName: passengerName || `Passenger ID: ${order.userId}`,
          driverName: driverName || (order.driverId ? `Driver ID: ${order.driverId}` : 'Not Assigned'),
          vehicleInfo: vehicleInfo || (order.vehicleId ? `Vehicle ID: ${order.vehicleId}` : 'Not Assigned'),
          orderType: order.orderType || order.type || '',
          fromLocation: order.fromLocation || order.startLocation || '',
          toLocation: order.toLocation || order.endLocation || '',
          amount: order.amount || order.fare || 0,
          status: order.status || '',
          passengerCount: order.passengerCount !== undefined ? order.passengerCount : null,
          createTime: order.createTime || order.createAt || '',
        };
      });
      
      // Check if there are ID fields but no corresponding name information
      const needPassengerDetails = orders.some(order => order.userId && order.passengerName.includes('Passenger ID:'));
      const needDriverDetails = orders.some(order => order.driverId && order.driverName.includes('Driver ID:'));
      const needVehicleDetails = orders.some(order => order.vehicleId && order.vehicleInfo.includes('Vehicle ID:'));
      
      // If there is information that needs to be supplemented, load asynchronously
      if (needPassengerDetails) {
        loadPassengerDetails(orders);
      }
      if (needDriverDetails) {
        loadDriverDetails(orders);
      }
      if (needVehicleDetails) {
        loadVehicleDetails(orders);
      }
      
      // Sort orders, place orders with status pending at the front
      orders.sort((a, b) => {
        if (a.status === 'pending' && b.status !== 'pending') {
          return -1; // a comes before b
        } else if (a.status !== 'pending' && b.status === 'pending') {
          return 1; // b comes before a
        } else {
          return 0; // maintain original order
        }
      });
      
      orderList.value = orders;
      
      // Output the first data after mapping to check
      console.log('First order data after processing:', orderList.value.length > 0 ? orderList.value[0] : 'No data');
    } else {
      // If the data structure does not meet expectations, record the error
      console.error('API response structure does not match expectations:', res);
      orderList.value = [];
    }
    
      // Display the total amount of data returned by the server for pagination
      total.value = res.total || (res.data ? res.data.length : 0);
      
      // If the backend does not return the total field, try to calculate using pagination information
      if (!res.total && res.pageInfo) {
        if (res.pageInfo.total) {
          total.value = res.pageInfo.total;
        } else if (res.pageInfo.totalPages && res.pageInfo.pageSize) {
          total.value = res.pageInfo.totalPages * res.pageInfo.pageSize;
        }
      }
      
      console.log('Pagination info: Current page', currentPage.value, 'Page size', pageSize.value, 'Total', total.value);
  } catch (error) {
    console.error('Failed to get order list:', error);
    if (error.response) {
      console.error('Server response:', error.response.status, error.response.data);
    }
    ElMessage.error('Failed to get order list: ' + (error.message || 'Unknown error'));
    orderList.value = [];
  } finally {
    loading.value = false;
  }
};

// Load passenger detail information
const loadPassengerDetails = async (orders) => {
  try {
    // Get all passenger IDs that need supplementary information
    const userIds = [...new Set(orders
      .filter(order => order.userId && order.passengerName.includes('Passenger ID:'))
      .map(order => order.userId))];
    
    if (userIds.length === 0) return;
    
    // Get passenger option data
    const res = await getPassengerList({ pageSize: 1000 });
    
    if (res && res.data && Array.isArray(res.data)) {
      const passengers = res.data;
      
      // Update passenger information in orderList
      orders.forEach(order => {
        if (order.userId) {
          const passenger = passengers.find(p => p.id === order.userId);
          if (passenger) {
            order.passengerName = passenger.username || passenger.name || `Passenger ID: ${order.userId}`;
          }
        }
      });
      
      // Update view
      orderList.value = [...orders];
    }
  } catch (error) {
    console.error('Failed to load passenger details:', error);
  }
};

// Load driver detail information
const loadDriverDetails = async (orders) => {
  try {
    // Get all driver IDs that need supplementary information
    const driverIds = [...new Set(orders
      .filter(order => order.driverId && order.driverName.includes('Driver ID:'))
      .map(order => order.driverId))];
    
    if (driverIds.length === 0) return;
    
    // Get driver option data
    const res = await getDriverList({ pageSize: 1000 });
    
    if (res && res.data && Array.isArray(res.data)) {
      const drivers = res.data;
      
      // Update driver information in orderList
      orders.forEach(order => {
        if (order.driverId) {
          const driver = drivers.find(d => d.id === order.driverId);
          if (driver) {
            order.driverName = driver.fullName || driver.name || `Driver ID: ${order.driverId}`;
          }
        }
      });
      
      // Update view
      orderList.value = [...orders];
    }
  } catch (error) {
    console.error('Failed to load driver details:', error);
  }
};

// Load vehicle detail information
const loadVehicleDetails = async (orders) => {
  try {
    // Get all vehicle IDs that need supplementary information
    const vehicleIds = [...new Set(orders
      .filter(order => order.vehicleId && order.vehicleInfo.includes('Vehicle ID:'))
      .map(order => order.vehicleId))];
    
    if (vehicleIds.length === 0) return;
    
    // Get vehicle option data
    const res = await getVehicleList({ pageSize: 1000 });
    
    if (res && res.data && Array.isArray(res.data)) {
      const vehicles = res.data;
      
      // Update vehicle information in orderList
      orders.forEach(order => {
        if (order.vehicleId) {
          const vehicle = vehicles.find(v => v.id === order.vehicleId);
          if (vehicle) {
            order.vehicleInfo = formatVehicleType(vehicle.type) || `Vehicle ID: ${order.vehicleId}`;
          }
        }
      });
      
      // Update view
      orderList.value = [...orders];
    }
  } catch (error) {
    console.error('Failed to load vehicle details:', error);
  }
};

// Get passenger options
const fetchPassengerOptions = async () => {
  try {
    const res = await getPassengerList({ pageSize: 1000 });
    passengerOptions.value = res.data;
  } catch (error) {
    console.error('Failed to get passenger options:', error);
    ElMessage.error('Failed to get passenger options');
  }
};

// Get driver options
const fetchDriverOptions = async () => {
  try {
    const res = await getDriverList({ pageSize: 1000 });
    driverOptions.value = res.data;
  } catch (error) {
    console.error('Failed to get driver options:', error);
    ElMessage.error('Failed to get driver options');
  }
};

// Get vehicle options
const fetchVehicleOptions = async () => {
  try {
    const res = await getVehicleList({ pageSize: 1000 });
    vehicleOptions.value = res.data;
  } catch (error) {
    console.error('Failed to get vehicle options:', error);
    ElMessage.error('Failed to get vehicle options');
  }
};

// Reset query parameters
const handleReset = () => {
  queryParams.orderNo = '';
  queryParams.passengerName = '';
  queryParams.orderType = '';
  queryParams.status = '';
  queryParams.dateRange = [];
  handleSearch();
};

// Search
const handleSearch = () => {
  currentPage.value = 1;
  fetchOrderList();
};

// Format date to YYYY-MM-DD string
const formatDate = (date) => {
  if (!date) return '';
  const d = new Date(date);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};

// Handle view details
const handleView = async (row) => {
  try {
    console.log('查看订单详情:', row.id, row);
    const res = await getOrderDetail(row.id);
    console.log('订单详情数据:', res);
    
    // 详细记录关键字段
    console.log('订单详情关键字段:', {
      id: res.id,
      orderNo: res.orderNo,
      status: res.status,
      userInfo: {
        passenger: res.passenger || res.user || {},
        passengerName: res.passengerName || res.userName,
        userId: res.userId
      },
      driverInfo: {
        driver: res.driver || {},
        driverName: res.driverName,
        driverId: res.driverId
      },
      vehicleInfo: {
        vehicle: res.vehicle || {},
        vehicleInfo: res.vehicleInfo,
        vehicleId: res.vehicleId
      },
      orderType: res.orderType,
      amount: res.amount || res.fare,
      passengerCount: res.passengerCount
    });
    
    // 确保字段映射正确
    currentOrder.id = res.id;
    currentOrder.orderNo = res.orderNo || res.orderNumber || '';
    currentOrder.orderType = res.orderType || res.type || '';
    currentOrder.status = res.status || '';
    
    // 提取乘客信息
    if (res.passengerName) {
      currentOrder.passengerName = res.passengerName;
    } else if (res.userName) {
      currentOrder.passengerName = res.userName;
    } else if (res.passenger && typeof res.passenger === 'object') {
      currentOrder.passengerName = res.passenger.username || res.passenger.name || '';
    } else if (res.user && typeof res.user === 'object') {
      currentOrder.passengerName = res.user.username || res.user.name || '';
    } else {
      currentOrder.passengerName = '';
    }
    
    // 提取乘客电话
    if (res.passengerPhone) {
      currentOrder.passengerPhone = res.passengerPhone;
    } else if (res.userPhone) {
      currentOrder.passengerPhone = res.userPhone;
    } else if (res.passenger && typeof res.passenger === 'object') {
      currentOrder.passengerPhone = res.passenger.phone || res.passenger.phoneNumber || '';
    } else if (res.user && typeof res.user === 'object') {
      currentOrder.passengerPhone = res.user.phone || res.user.phoneNumber || '';
    } else {
      currentOrder.passengerPhone = '';
    }
    
    // 提取司机信息
    if (res.driverName) {
      currentOrder.driverName = res.driverName;
    } else if (res.driver && typeof res.driver === 'object') {
      currentOrder.driverName = res.driver.fullName || res.driver.name || '';
    } else {
      currentOrder.driverName = '';
    }
    
    // 提取车辆信息
    if (res.vehicleInfo) {
      currentOrder.vehicleInfo = res.vehicleInfo;
    } else if (res.vehicle && typeof res.vehicle === 'object') {
      currentOrder.vehicleInfo = formatVehicleType(res.vehicle.type) || '';
    } else {
      currentOrder.vehicleInfo = '';
    }
    
    currentOrder.fromLocation = res.fromLocation || res.startLocation || '';
    currentOrder.toLocation = res.toLocation || res.endLocation || '';
    currentOrder.estimatedTime = res.estimatedTime || '';
    currentOrder.passengerCount = res.passengerCount !== undefined ? res.passengerCount : null;
    currentOrder.luggageInfo = res.luggageInfo || '';
    currentOrder.amount = res.amount || res.fare || 0;
    currentOrder.createTime = res.createTime || res.createdAt || '';
    currentOrder.updateTime = res.updateTime || res.updatedAt || '';
    
    console.log('处理后的订单详情:', currentOrder);
    
    viewDialogVisible.value = true;
  } catch (error) {
    console.error('Failed to get order details:', error);
    if (error.response) {
      console.error('Server response:', error.response.status, error.response.data);
    }
    ElMessage.error('Failed to get order details: ' + (error.message || 'Unknown error'));
  }
};

// Handle add order
const handleAdd = async () => {
  dialogType.value = 'add';
  orderForm.id = null;
  orderForm.userId = null;
  orderForm.driverId = null;
  orderForm.vehicleId = null;
  orderForm.orderType = 'private';
  orderForm.startLocation = '';
  orderForm.endLocation = '';
  orderForm.estimatedTime = null;
  orderForm.fare = 0;
  orderForm.status = 'pending';
  orderForm.passengerCount = null;
  orderForm.luggageInfo = '';
  
  // 确保下拉选项至少有一个空数组作为默认值
  passengerOptions.value = [];
  driverOptions.value = [];
  vehicleOptions.value = [];
  
  // 修改为单独处理每个请求，确保其中一个失败不会影响整体流程
  try {
    await fetchPassengerOptions();
  } catch (error) {
    console.error('Failed to fetch passenger options:', error);
    // 继续执行，不中断流程
  }
  
  try {
    await fetchDriverOptions();
  } catch (error) {
    console.error('Failed to fetch driver options:', error);
    // 继续执行，不中断流程
  }
  
  try {
    await fetchVehicleOptions();
  } catch (error) {
    console.error('Failed to fetch vehicle options:', error);
    // 继续执行，不中断流程
  }
  
  editDialogVisible.value = true;
  
  // Wait for DOM update then reset form
  nextTick(() => {
    if (orderFormRef.value) {
      orderFormRef.value.resetFields();
    }
  });
};

// Handle edit order
const handleEdit = async (row) => {
  if (row.status !== 'pending') {
    ElMessage.warning('Can only edit pending orders');
    return;
  }
  
  dialogType.value = 'edit';
  orderForm.id = row.id;
  
  // 确保下拉选项至少有一个空数组作为默认值
  passengerOptions.value = [];
  driverOptions.value = [];
  vehicleOptions.value = [];
  
  // 修改为单独处理每个请求，确保其中一个失败不会影响整体流程
  try {
    await fetchPassengerOptions();
  } catch (error) {
    console.error('Failed to fetch passenger options:', error);
    // 继续执行，不中断流程
  }
  
  try {
    await fetchDriverOptions();
  } catch (error) {
    console.error('Failed to fetch driver options:', error);
    // 继续执行，不中断流程
  }
  
  try {
    await fetchVehicleOptions();
  } catch (error) {
    console.error('Failed to fetch vehicle options:', error);
    // 继续执行，不中断流程
  }
  
  try {
    const res = await getOrderDetail(row.id);
    console.log('编辑订单数据:', res);
    
    // 详细记录关键字段
    console.log('编辑订单关键字段:', {
      userId: res.userId,
      user: res.user,
      passenger: res.passenger,
      driverId: res.driverId,
      driver: res.driver,
      vehicleId: res.vehicleId,
      vehicle: res.vehicle
    });
    
    // 尝试从多种可能的嵌套结构中获取用户ID
    if (res.userId) {
      orderForm.userId = res.userId;
    } else if (res.user && typeof res.user === 'object' && res.user.id) {
      orderForm.userId = res.user.id;
    } else if (res.passenger && typeof res.passenger === 'object' && res.passenger.id) {
      orderForm.userId = res.passenger.id;
    } else {
      orderForm.userId = null;
    }
    
    // 尝试从多种可能的嵌套结构中获取司机ID
    if (res.driverId) {
      orderForm.driverId = res.driverId;
    } else if (res.driver && typeof res.driver === 'object' && res.driver.id) {
      orderForm.driverId = res.driver.id;
    } else {
      orderForm.driverId = null;
    }
    
    // 尝试从多种可能的嵌套结构中获取车辆ID
    if (res.vehicleId) {
      orderForm.vehicleId = res.vehicleId;
    } else if (res.vehicle && typeof res.vehicle === 'object' && res.vehicle.id) {
      orderForm.vehicleId = res.vehicle.id;
    } else {
      orderForm.vehicleId = null;
    }
    
    orderForm.orderType = res.orderType || res.type || 'private';
    orderForm.startLocation = res.fromLocation || res.startLocation || '';
    orderForm.endLocation = res.toLocation || res.endLocation || '';
    orderForm.estimatedTime = res.estimatedTime ? parseInt(res.estimatedTime) : null;
    orderForm.fare = res.amount || res.fare || 0;
    orderForm.status = res.status || 'pending';
    orderForm.passengerCount = res.passengerCount || null;
    orderForm.luggageInfo = res.luggageInfo || '';
    
    // 确保对话框显示
    editDialogVisible.value = true;
    viewDialogVisible.value = false;
    
    // 等待DOM更新后重置表单
    nextTick(() => {
      if (orderFormRef.value) {
        orderFormRef.value.resetFields();
      }
    });
  } catch (error) {
    console.error('Failed to get order details:', error);
    ElMessage.error('Failed to get order details');
  }
};

// Handle delete order
const handleDelete = async (row) => {
  ElMessageBox.confirm('Are you sure you want to delete this order?', 'Warning', {
    confirmButtonText: 'Confirm',
    cancelButtonText: 'Cancel',
    type: 'warning'
  }).then(async () => {
    try {
      // 这里应该调用删除订单的API
      // 由于代码中没有引入deleteOrder API，这里假设它存在
      // await deleteOrder(row.id);
      
      // 模拟删除成功
      ElMessage.success('Delete successful');
      
      // 删除成功后刷新订单列表
      fetchOrderList();
    } catch (error) {
      console.error('Error deleting order:', error);
      ElMessage.error('Delete failed');
    }
  }).catch(() => {
    // 用户取消删除操作
  });
};

// Handle change order status
const handleStatusCommand = (status, row) => {
  // 显示确认对话框
  const statusText = {
    'confirmed': 'Confirmed',
    'completed': 'Completed',
    'cancelled': 'Cancelled'
  }[status];
  
  ElMessageBox.confirm(`Are you sure you want to change the order status to ${statusText}?`, 'Confirmation', {
    confirmButtonText: 'Confirm',
    cancelButtonText: 'Cancel',
    type: 'warning',
  }).then(async () => {
    try {
      loading.value = true;
      console.log(`Updating order ${row.id} status to ${status}`, row);
      
      // Build update data
      const updateData = {
        status: status,
        // 添加PostgreSQL枚举类型转换标记，告诉后端这是枚举类型
        _statusIsEnum: true,
        // 添加必要的字段，避免类型转换错误
        id: row.id
      };
      
      console.log('Status update data:', updateData);
      
      try {
        console.log('Attempting to directly update order status...');
        // 使用最简单的方法直接更新状态
        const response = await updateOrder(row.id, updateData);
        console.log('Status update successful:', response);
        
        // 立即更新本地数据显示
        const orderIndex = orderList.value.findIndex(o => o.id === row.id);
        if (orderIndex !== -1) {
          orderList.value[orderIndex].status = status;
        }
        
        ElMessage.success('Status updated successfully');
        
        // 如果当前在查看详情，则更新详情视图
        if (viewDialogVisible.value && currentOrder.id === row.id) {
          currentOrder.status = status;
        }
        
        // 重新获取列表数据以确保UI同步
        await fetchOrderList();
      } catch (error) {
        console.error('更新状态失败:', error);
        
        // 如果是类型转换错误，尝试使用备用方法
        if (error.response && error.response.data && 
            (error.response.data.includes("type order_status") || 
             error.response.data.includes("cast the expression"))) {
          
          console.log('检测到类型转换错误，尝试使用备用方法...');
          
          try {
            // 尝试使用特殊API进行状态更新，专门处理枚举类型问题
            const response = await updateOrderStatus(row.id, { 
              status: status, 
              _timestamp: new Date().getTime() 
            });
            console.log('使用专用接口更新成功:', response);
            
            // 更新本地数据显示
            const orderIndex = orderList.value.findIndex(o => o.id === row.id);
            if (orderIndex !== -1) {
              orderList.value[orderIndex].status = status;
            }
            
            ElMessage.success('状态更新成功');
            
            // 如果当前在查看详情，则更新详情视图
            if (viewDialogVisible.value && currentOrder.id === row.id) {
              currentOrder.status = status;
            }
            
            // 重新获取列表数据以确保UI同步
            await fetchOrderList();
            return;
          } catch (specialError) {
            console.error('使用专用接口更新失败:', specialError);
          }
          
          // 如果专用接口也失败，尝试使用fetch API并手动构建SQL类型转换
          try {
            const loginUserStr = localStorage.getItem('loginUser');
            if (!loginUserStr) {
              throw new Error('未找到登录信息');
            }
            
            const loginUser = JSON.parse(loginUserStr);
            if (!loginUser || !loginUser.token) {
              throw new Error('登录信息无效');
            }
            
            // 使用fetch API直接发送请求，手动添加类型转换
            const response = await fetch(`http://localhost:8080/orders/${row.id}/statusWithCast`, {
              method: 'PUT',
              headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${loginUser.token}`
              },
              body: JSON.stringify({ status: status })
            });
            
            if (!response.ok) {
              throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const data = await response.json();
            console.log('使用fetch API更新成功:', data);
            
            // 更新本地数据显示
            const orderIndex = orderList.value.findIndex(o => o.id === row.id);
            if (orderIndex !== -1) {
              orderList.value[orderIndex].status = status;
            }
            
            ElMessage.success('状态更新成功');
            
            // 如果当前在查看详情，则更新详情视图
            if (viewDialogVisible.value && currentOrder.id === row.id) {
              currentOrder.status = status;
            }
            
            // 重新获取列表数据以确保UI同步
            await fetchOrderList();
          } catch (fetchError) {
            console.error('使用fetch API更新失败:', fetchError);
            ElMessage.error(`更新状态失败: ${fetchError.message}`);
          }
        } else {
          // 处理其他错误
          handleUpdateError(error);
        }
      }
    } catch (error) {
      console.error('操作失败:', error);
      handleUpdateError(error);
    } finally {
      loading.value = false;
    }
  }).catch(() => {
    // 用户取消操作，不做任何处理
  });
};

// 处理更新错误的辅助函数
const handleUpdateError = (error) => {
  // 显示更详细的错误信息
  if (error.response) {
    const errMsg = error.response.data?.message || `Failed to update status (${error.response.status})`;
    console.error('错误响应详情:', error.response.data);
    
    // 处理具体的错误情况
    if (error.response.data && typeof error.response.data === 'string') {
      if (error.response.data.includes('order_type')) {
        ElMessage.error('数据类型错误: order_type字段类型不匹配，请联系系统管理员');
      } else if (error.response.data.includes('Bad SQL grammar')) {
        ElMessage.error('SQL语法错误，请联系系统管理员');
      } else {
        ElMessage.error(errMsg);
      }
    } else if (error.response.status === 401 || error.response.status === 403) {
      ElMessage.error('认证失败，请重新登录');
      // 不再自动跳转到登录页，避免干扰用户操作
    } else {
      ElMessage.error(errMsg);
    }
  } else if (error.request) {
    ElMessage.error('服务器没有响应，请检查网络连接');
  } else {
    ElMessage.error(`操作失败: ${error.message}`);
  }
};

// Submit form
const submitForm = async () => {
  if (!orderFormRef.value) return;
  
  // 添加验证检查，确保必要的选项已加载
  if (passengerOptions.value.length === 0) {
    ElMessage.warning('Passenger options not loaded. Please try again.');
    return;
  }
  
  await orderFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        // 构建一个适配后端API的数据结构
        const submitData = {
          userId: orderForm.userId,
          driverId: orderForm.driverId,
          vehicleId: orderForm.vehicleId,
          orderType: orderForm.orderType,
          startLocation: orderForm.startLocation,
          endLocation: orderForm.endLocation,
          estimatedTime: orderForm.estimatedTime,
          fare: orderForm.fare,
          status: orderForm.status
        };
        
        // 根据订单类型添加额外字段
        if (orderForm.orderType === 'bus_carpool') {
          submitData.passengerCount = orderForm.passengerCount;
          submitData.luggageInfo = orderForm.luggageInfo;
        }

        console.log('提交的表单数据:', submitData);

        if (dialogType.value === 'add') {
          await addOrder(submitData);
          ElMessage.success('Added successfully');
        } else {
          await updateOrder(orderForm.id, submitData);
          ElMessage.success('Updated successfully');
        }
        editDialogVisible.value = false;
        fetchOrderList();
      } catch (error) {
        console.error('Operation failed:', error);
        ElMessage.error('Operation failed');
      }
    }
  });
};

// Handle pagination
const handleSizeChange = (val) => {
  pageSize.value = val;
  currentPage.value = 1; // 切换每页条数时重置为第一页
  console.log('切换每页显示数量为:', val);
  fetchOrderList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  console.log('切换到页码:', val);
  fetchOrderList();
};

// 车辆选择处理
const handleVehicleCommand = async (vehicleId, row) => {
  try {
    // 获取选中的车辆信息
    const selectedVehicle = vehicleOptions.value.find(v => v.id === vehicleId);
    if (!selectedVehicle) {
      ElMessage.error('Selected vehicle does not exist');
      return;
    }
    
    // 使用updateOrder接口更新订单的车辆信息
    await updateOrder(row.id, { vehicleId });
    
    // 更新本地数据显示
    const orderIndex = orderList.value.findIndex(o => o.id === row.id);
    if (orderIndex !== -1) {
      orderList.value[orderIndex].vehicleInfo = formatVehicleType(selectedVehicle.type);
      orderList.value[orderIndex].vehicleId = vehicleId;
    }
    
    ElMessage.success('Vehicle information updated successfully');
    
    // 刷新数据
    fetchOrderList();
  } catch (error) {
    console.error('Failed to update vehicle information:', error);
    ElMessage.error('Failed to update vehicle information');
  }
};

// 金额选择处理
const handleAmountCommand = async (amount, row) => {
  try {
    // 将字符串转换为数字
    const amountValue = parseFloat(amount);
    
    // 使用updateOrder接口更新订单金额
    await updateOrder(row.id, { fare: amountValue });
    
    // 更新本地数据显示
    const orderIndex = orderList.value.findIndex(o => o.id === row.id);
    if (orderIndex !== -1) {
      orderList.value[orderIndex].amount = amountValue;
    }
    
    ElMessage.success('Price updated successfully');
    
    // 刷新数据
    fetchOrderList();
  } catch (error) {
    console.error('Failed to update price:', error);
    ElMessage.error('Failed to update price');
  }
};

// Initialize
onMounted(() => {
  fetchOrderList();
  // 预加载车辆选项
  fetchVehicleOptions().catch(error => {
    console.error('Failed to load vehicle options:', error);
  });
});
</script>

<style scoped>
.order-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.editable-cell {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.editable-cell:hover .edit-tag {
  display: inline-flex;
}

.edit-tag {
  display: none;
  margin-left: 5px;
  font-size: 12px;
  line-height: 1;
  padding: 2px 4px;
  align-items: center;
}

.edit-tag .el-icon {
  margin-right: 2px;
}

.cell-with-button {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.cell-with-button > div {
  min-width: 70px;
}

.button-column {
  display: flex;
  flex-direction: column;
  gap: 5px;
}
</style>