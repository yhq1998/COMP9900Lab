<template>
  <div class="vehicle-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <h3>Vehicle Management</h3>
          <el-button type="primary" @click="handleAdd">Add Vehicle</el-button>
        </div>
      </template>
      
      <!-- 搜索表单 -->
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="License Plate">
          <el-input v-model="queryParams.plateNumber" placeholder="Enter license plate number" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="Type">
          <el-select v-model="queryParams.type" placeholder="Select type" clearable>
            <el-option label="16-seater" value="16-seater" />
            <el-option label="22-seater" value="22-seater" />
            <el-option label="30-seater" value="30-seater" />
          </el-select>
        </el-form-item>
        <el-form-item label="Status">
          <el-select v-model="queryParams.available" placeholder="Select status" clearable>
            <el-option label="Available" :value="true" />
            <el-option label="Unavailable" :value="false" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">Search</el-button>
          <el-button @click="handleReset">Reset</el-button>
        </el-form-item>
      </el-form>
      
      <!-- 数据表格 -->
      <el-table :data="vehicleList" style="width: 100%" v-loading="loading" border>
        <el-table-column type="index" label="No." width="60" align="center" />
        <el-table-column prop="plateNumber" label="License Plate" width="120" />
        <el-table-column prop="type" label="Type" width="100">
          <template #default="scope">
            {{ formatVehicleType(scope.row.type) }}
          </template>
        </el-table-column>
        <el-table-column prop="available" label="Status" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.available ? 'success' : 'danger'">
              {{ scope.row.available ? 'Available' : 'Unavailable' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="GPS Location" width="300">
          <template #default="scope">
            <div v-if="scope.row.gpsLocation">
              Longitude: {{ formatCoordinate(scope.row.gpsLocation.longitude) }},
              Latitude: {{ formatCoordinate(scope.row.gpsLocation.latitude) }}
            </div>
            <div v-else>Not Located</div>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="Created Time" width="180" />
        <el-table-column label="Actions" fixed="right" min-width="120">
          <template #default="scope">
            <div class="button-column">
              <el-button size="small" @click="handleView(scope.row)">View</el-button>
              <el-button size="small" type="primary" @click="handleEdit(scope.row)">Edit</el-button>
              <el-button size="small" type="danger" @click="handleDelete(scope.row)">Delete</el-button>
              <el-button
                size="small"
                :type="scope.row.available ? 'warning' : 'success'"
                @click="handleToggleAvailable(scope.row)">
                {{ scope.row.available ? 'Set Unavailable' : 'Set Available' }}
              </el-button>
              <el-button
                size="small"
                type="info"
                @click="viewTrackingHistory(scope.row)">
                View Tracking
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页 -->
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </el-card>

    <!-- 车辆详情对话框 -->
    <el-dialog v-model="viewDialogVisible" title="Vehicle Details" width="50%">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="Vehicle ID">{{ currentVehicle.id }}</el-descriptions-item>
        <el-descriptions-item label="License Plate">{{ currentVehicle.plateNumber }}</el-descriptions-item>
        <el-descriptions-item label="Type">{{ formatVehicleType(currentVehicle.type) }}</el-descriptions-item>
        <el-descriptions-item label="Status">
          <el-tag :type="currentVehicle.available ? 'success' : 'danger'">
            {{ currentVehicle.available ? 'Available' : 'Unavailable' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="GPS Location" :span="2">
          <div v-if="currentVehicle.gpsLocation">
            Longitude: {{ formatCoordinate(currentVehicle.gpsLocation.longitude) }},
            Latitude: {{ formatCoordinate(currentVehicle.gpsLocation.latitude) }}
          </div>
          <div v-else>Not Located</div>
        </el-descriptions-item>
        <el-descriptions-item label="Created Time">{{ currentVehicle.createdAt }}</el-descriptions-item>
      </el-descriptions>

      <div v-if="currentVehicle.gpsLocation" class="map-container">
        <h4>Location Preview</h4>
        <div class="map-placeholder">
          A map component should be displayed here to show the vehicle location
          <br>
          Longitude: {{ formatCoordinate(currentVehicle.gpsLocation.longitude) }},
          Latitude: {{ formatCoordinate(currentVehicle.gpsLocation.latitude) }}
        </div>
      </div>
    </el-dialog>

    <!-- 添加/编辑车辆对话框 -->
    <el-dialog v-model="editDialogVisible" :title="dialogType === 'add' ? 'Add Vehicle' : 'Edit Vehicle'">
      <el-form :model="vehicleForm" label-width="100px" :rules="rules" ref="vehicleFormRef">
        <el-form-item label="License Plate" prop="plateNumber">
          <el-input v-model="vehicleForm.plateNumber" placeholder="Enter license plate number" :disabled="dialogType === 'edit'" />
        </el-form-item>
        <el-form-item label="Type" prop="type">
          <el-select v-model="vehicleForm.type" placeholder="Select type">
            <el-option label="16-seater" value="16-seater" />
            <el-option label="22-seater" value="22-seater" />
            <el-option label="30-seater" value="30-seater" />
          </el-select>
        </el-form-item>
        <el-form-item label="Status" prop="available">
          <el-switch
            v-model="vehicleForm.available"
            active-text="Available"
            inactive-text="Unavailable"
          />
        </el-form-item>
        <el-form-item label="GPS Location" v-if="dialogType === 'edit'">
          <el-row :gutter="10">
            <el-col :span="11">
              <el-form-item label="Longitude" prop="longitude">
                <el-input v-model="vehicleForm.longitude" placeholder="Enter longitude" />
              </el-form-item>
            </el-col>
            <el-col :span="11">
              <el-form-item label="Latitude" prop="latitude">
                <el-input v-model="vehicleForm.latitude" placeholder="Enter latitude" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="editDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="submitForm">Confirm</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- 轨迹历史对话框 -->
    <el-dialog v-model="trackingDialogVisible" title="GPS Tracking History" width="70%">
      <el-form :inline="true" class="tracking-form">
        <el-form-item label="Time Range">
          <el-date-picker
            v-model="trackingDateRange"
            type="datetimerange"
            range-separator="to"
            start-placeholder="Start Time"
            end-placeholder="End Time"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="searchTrackingHistory">Search</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="trackingHistory" style="width: 100%" v-loading="trackingLoading" border>
        <el-table-column type="index" label="No." width="60" align="center" />
        <el-table-column prop="latitude" label="Latitude" width="150">
          <template #default="scope">
            {{ formatCoordinate(scope.row.latitude) }}
          </template>
        </el-table-column>
        <el-table-column prop="longitude" label="Longitude" width="150">
          <template #default="scope">
            {{ formatCoordinate(scope.row.longitude) }}
          </template>
        </el-table-column>
        <el-table-column prop="timestamp" label="Time" width="180" />
      </el-table>

      <div class="map-container">
        <h4>Tracking Preview</h4>
        <div class="map-placeholder">
          A map component should be displayed here to show the vehicle tracking route
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

// API 接口引入
import { getVehicleList, getVehicleDetail, addVehicle, updateVehicle, deleteVehicle } from '@/api/vehicle'

// 状态变量
const loading = ref(false)
const vehicleList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const viewDialogVisible = ref(false)
const editDialogVisible = ref(false)
const trackingDialogVisible = ref(false)
const dialogType = ref('add')
const currentVehicle = ref({})
const trackingHistory = ref([])
const trackingLoading = ref(false)
const trackingDateRange = ref([])

// 查询参数
const queryParams = reactive({
  plateNumber: '',
  type: '',
  available: '',
  page: 1,
  size: 10
})

// 表单对象
const vehicleForm = ref({
  plateNumber: '',
  type: '16-seater',
  available: true,
  longitude: '',
  latitude: ''
})

// 表单验证规则
const rules = {
  plateNumber: [
    { required: true, message: 'Please enter the license plate number', trigger: 'blur' },
    { pattern: /^[\u4e00-\u9fa5][A-Z][A-Z0-9]{5}$/, message: 'Please enter a valid license plate number format', trigger: 'blur' }
  ],
  type: [
    { required: true, message: 'Please select vehicle type', trigger: 'change' }
  ]
}

const vehicleFormRef = ref(null)

// 生命周期钩子
onMounted(() => {
  fetchVehicleList()
})

// 格式化车辆类型
const formatVehicleType = (type) => {
  const typeMap = {
    '16-seater': '16-seater',
    '22-seater': '22-seater',
    '30-seater': '30-seater'
  }
  return typeMap[type] || type
}

// 格式化坐标
const formatCoordinate = (coord) => {
  return coord ? parseFloat(coord).toFixed(6) : '-'
}

// 获取车辆列表
const fetchVehicleList = async () => {
  loading.value = true
  try {
    const res = await getVehicleList({
      plateNumber: queryParams.plateNumber,
      type: queryParams.type,
      available: queryParams.available,
      page: currentPage.value,
      size: pageSize.value
    })
    if (res.code === 1) {
      vehicleList.value = res.data
      total.value = res.total || res.data.length
    } else {
      ElMessage.error(res.msg || 'Failed to get vehicle list')
    }
  } catch (error) {
    console.error('Failed to get vehicle list:', error)
    ElMessage.error('Failed to get vehicle list')
  } finally {
    loading.value = false
  }
}

// 查询
const handleSearch = () => {
  currentPage.value = 1
  fetchVehicleList()
}

// 重置
const handleReset = () => {
  queryParams.plateNumber = ''
  queryParams.type = ''
  queryParams.available = ''
  handleSearch()
}

// 改变页码
const handleSizeChange = (size) => {
  pageSize.value = size
  fetchVehicleList()
}

// 改变当前页
const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchVehicleList()
}

// 查看车辆详情
const handleView = (row) => {
  currentVehicle.value = row
  viewDialogVisible.value = true
}

// 添加车辆
const handleAdd = () => {
  dialogType.value = 'add'
  vehicleForm.value = {
    plateNumber: '',
    type: '16-seater',
    available: true,
    longitude: '',
    latitude: ''
  }
  editDialogVisible.value = true
}

// 编辑车辆
const handleEdit = (row) => {
  dialogType.value = 'edit'
  vehicleForm.value = { 
    ...row,
    longitude: row.gpsLocation?.longitude || '',
    latitude: row.gpsLocation?.latitude || ''
  }
  editDialogVisible.value = true
}

// 删除车辆
const handleDelete = (row) => {
  ElMessageBox.confirm('Are you sure you want to delete this vehicle?', 'Warning', {
    confirmButtonText: 'Confirm',
    cancelButtonText: 'Cancel',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteVehicle(row.id)
      if (res.code === 1) {
        ElMessage.success('Deleted successfully')
        fetchVehicleList()
      } else {
        ElMessage.error(res.msg || 'Failed to delete')
      }
    } catch (error) {
      console.error('Failed to delete vehicle:', error)
      ElMessage.error('Failed to delete')
    }
  }).catch(() => {})
}

// 切换可用状态
const handleToggleAvailable = (row) => {
  const newStatus = !row.available
  const statusText = newStatus ? 'Available' : 'Unavailable'
  
  ElMessageBox.confirm(`Are you sure you want to set the vehicle to ${statusText}?`, 'Tip', {
    confirmButtonText: 'Confirm',
    cancelButtonText: 'Cancel',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await updateVehicle(row.id, { available: newStatus })
      if (res.code === 1) {
        ElMessage.success('Set successfully')
        fetchVehicleList()
      } else {
        ElMessage.error(res.msg || 'Failed to set')
      }
    } catch (error) {
      console.error('Failed to update vehicle status:', error)
      ElMessage.error('Failed to set')
    }
  }).catch(() => {})
}

// 查看轨迹历史
const viewTrackingHistory = (row) => {
  currentVehicle.value = row
  trackingDialogVisible.value = true
  
  // 设置默认时间范围为过去24小时
  const endDate = new Date()
  const startDate = new Date()
  startDate.setDate(startDate.getDate() - 1)
  trackingDateRange.value = [startDate, endDate]
  
  searchTrackingHistory()
}

// 搜索轨迹历史
const searchTrackingHistory = async () => {
  if (!trackingDateRange.value || !trackingDateRange.value[0] || !trackingDateRange.value[1]) {
    ElMessage.warning('Please select time range')
    return
  }
  
  trackingLoading.value = true
  try {
    const params = {
      startTime: trackingDateRange.value[0].toISOString(),
      endTime: trackingDateRange.value[1].toISOString()
    }
    
    trackingHistory.value = Array.from({ length: 20 }).map((_, index) => {
      const timestamp = new Date(trackingDateRange.value[0].getTime() + 
        (trackingDateRange.value[1].getTime() - trackingDateRange.value[0].getTime()) * (index / 19))
      
      return {
        id: index + 1,
        vehicleId: currentVehicle.value.id,
        latitude: 39.9 + Math.random() * 0.1,
        longitude: 116.3 + Math.random() * 0.1,
        timestamp: timestamp.toLocaleString()
      }
    })
  } catch (error) {
    console.error('Failed to get tracking history:', error)
    ElMessage.error('Failed to get tracking history')
  } finally {
    trackingLoading.value = false
  }
}

// 提交表单
const submitForm = async () => {
  vehicleFormRef.value.validate(async (valid) => {
    if (!valid) return

    try {
      const formData = { ...vehicleForm.value }
      
      // 处理GPS位置 - 转换为WKT格式字符串
      if (dialogType.value === 'edit' && formData.longitude && formData.latitude) {
        formData.gpsLocation = `POINT(${formData.longitude} ${formData.latitude})`
      }
      
      delete formData.longitude
      delete formData.latitude
      
      let res
      if (dialogType.value === 'add') {
        res = await addVehicle(formData)
        if (res.code === 1) {
          ElMessage.success('添加成功')
        } else {
          throw new Error(res.msg || '添加失败')
        }
      } else {
        res = await updateVehicle(formData.id, formData)
        if (res.code === 1) {
          ElMessage.success('更新成功')
        } else {
          throw new Error(res.msg || '更新失败')
        }
      }
      editDialogVisible.value = false
      fetchVehicleList()
    } catch (error) {
      console.error(dialogType.value === 'add' ? '添加车辆失败:' : '更新车辆失败:', error)
      ElMessage.error(dialogType.value === 'add' ? '添加失败' : '更新失败')
    }
  })
}
</script>

<style scoped>
.vehicle-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form, .tracking-form {
  margin-bottom: 20px;
}

.map-container {
  margin-top: 20px;
}

.map-placeholder {
  height: 300px;
  background-color: #f0f0f0;
  display: flex;
  justify-content: center;
  align-items: center;
  border-radius: 4px;
  flex-direction: column;
}

.button-column {
  display: flex;
  flex-direction: column;
  gap: 5px;
}
</style>