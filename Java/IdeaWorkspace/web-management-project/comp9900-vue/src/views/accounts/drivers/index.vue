<template>
  <div class="driver-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <h3>Driver Management</h3>
          <el-button type="primary" size="default" @click="handleAdd">Add Driver</el-button>
        </div>
      </template>
      
      <!-- Search Form -->
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="Username">
          <el-input v-model="queryParams.username" placeholder="Enter username" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="Phone">
          <el-input v-model="queryParams.phoneNumber" placeholder="Enter phone number" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="Status">
          <el-select v-model="queryParams.status" placeholder="Select status" clearable>
            <el-option label="Available" value="available" />
            <el-option label="Busy" value="busy" />
            <el-option label="Offline" value="offline" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="default" @click="handleSearch">Search</el-button>
          <el-button size="default" @click="handleReset">Reset</el-button>
        </el-form-item>
      </el-form>
      
      <!-- Data Table -->
      <el-table :data="driverList" style="width: 100%" v-loading="loading" border>
        <el-table-column type="index" label="No." width="60" align="center" />
        <el-table-column prop="username" label="Username" width="120" />
        <el-table-column prop="fullName" label="Full Name" width="120" />
        <el-table-column prop="email" label="Email" width="180" show-overflow-tooltip />
        <el-table-column prop="phoneNumber" label="Phone" width="130" />
        <el-table-column prop="driverLicenseNumber" label="License No." width="150" />
        <el-table-column prop="vehicle" label="Vehicle" width="120" />
        <el-table-column prop="status" label="Status" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.status === 'available'" type="success">Available</el-tag>
            <el-tag v-else-if="scope.row.status === 'busy'" type="warning">Busy</el-tag>
            <el-tag v-else-if="scope.row.status === 'offline'" type="info">Offline</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="Created At" width="180" />
        <el-table-column label="Actions" fixed="right" min-width="150">
          <template #default="scope">
            <div class="button-column">
              <el-button size="default" type="info" style="width: 100%;" @click="handleView(scope.row)">View</el-button>
              <el-button size="default" type="primary" style="width: 100%;" @click="handleEdit(scope.row)">Edit</el-button>
              <el-button size="default" type="danger" style="width: 100%;" @click="handleDelete(scope.row)">Delete</el-button>
              <el-button 
                size="default" 
                style="width: 100%;"
                :type="scope.row.status === 'offline' ? 'success' : 'warning'"
                @click="handleChangeStatus(scope.row)">
                {{ scope.row.status === 'offline' ? 'Online' : 'Offline' }}
              </el-button>
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
      />
    </el-card>

    <!-- Driver Details Dialog -->
    <el-dialog v-model="viewDialogVisible" title="Driver Details" width="50%">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="Driver ID">{{ currentDriver.id }}</el-descriptions-item>
        <el-descriptions-item label="Username">{{ currentDriver.username }}</el-descriptions-item>
        <el-descriptions-item label="Full Name">{{ currentDriver.fullName }}</el-descriptions-item>
        <el-descriptions-item label="Email">{{ currentDriver.email }}</el-descriptions-item>
        <el-descriptions-item label="Phone">{{ currentDriver.phoneNumber }}</el-descriptions-item>
        <el-descriptions-item label="Photo">
          <el-avatar v-if="currentDriver.photo" :src="currentDriver.photo" :size="60"></el-avatar>
          <el-avatar v-else :size="60" icon="el-icon-user"></el-avatar>
        </el-descriptions-item>
        <el-descriptions-item label="License No.">{{ currentDriver.driverLicenseNumber }}</el-descriptions-item>
        <el-descriptions-item label="Vehicle">{{ currentDriver.vehicle }}</el-descriptions-item>
        <el-descriptions-item label="Status">
          <el-tag v-if="currentDriver.status === 'available'" type="success">Available</el-tag>
          <el-tag v-else-if="currentDriver.status === 'busy'" type="warning">Busy</el-tag>
          <el-tag v-else-if="currentDriver.status === 'offline'" type="info">Offline</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="Created At">{{ currentDriver.createdAt }}</el-descriptions-item>
        <el-descriptions-item label="Updated At">{{ currentDriver.updatedAt }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>

    <!-- Add/Edit Driver Dialog -->
    <el-dialog v-model="editDialogVisible" :title="dialogType === 'add' ? 'Add Driver' : 'Edit Driver'">
      <el-form :model="driverForm" label-width="100px" :rules="rules" ref="driverFormRef">
        <el-form-item label="Username" prop="username">
          <el-input v-model="driverForm.username" placeholder="Enter username" :disabled="dialogType === 'edit'" />
        </el-form-item>
        <el-form-item label="Full Name" prop="fullName">
          <el-input v-model="driverForm.fullName" placeholder="Enter full name" />
        </el-form-item>
        <el-form-item label="Email" prop="email">
          <el-input v-model="driverForm.email" placeholder="Enter email" />
        </el-form-item>
        <el-form-item label="Phone" prop="phoneNumber">
          <el-input v-model="driverForm.phoneNumber" placeholder="Enter phone number" />
        </el-form-item>
        <el-form-item label="Password" prop="password" v-if="dialogType === 'add'">
          <el-input v-model="driverForm.password" placeholder="Enter password" show-password />
        </el-form-item>
        <el-form-item label="Photo" prop="photo">
          <el-upload
            class="avatar-uploader"
            action="/api/files/upload" 
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :on-error="handleAvatarError"
            :before-upload="beforeAvatarUpload"
            :headers="uploadHeaders"
          >
            <img v-if="driverForm.photo" :src="driverForm.photo" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div class="upload-tip">
            <small>* Support jpg, png format, max size 2MB</small>
          </div>
        </el-form-item>
        <el-form-item label="License No." prop="driverLicenseNumber">
          <el-input v-model="driverForm.driverLicenseNumber" placeholder="Enter driver license number" />
        </el-form-item>
        <el-form-item label="Vehicle" prop="vehicle">
          <el-input v-model="driverForm.vehicle" placeholder="Enter vehicle information" />
        </el-form-item>
        <el-form-item label="Status" prop="status">
          <el-select v-model="driverForm.status" placeholder="Select status">
            <el-option label="Available" value="available" />
            <el-option label="Busy" value="busy" />
            <el-option label="Offline" value="offline" />
          </el-select>
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
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'

// API 接口引入
import { getDriverList, getDriverDetail, addDriver, updateDriver, deleteDriver, updateDriverStatus as changeDriverStatus } from '@/api/driver'

// 状态变量
const loading = ref(false)
const driverList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const viewDialogVisible = ref(false)
const editDialogVisible = ref(false)
const dialogType = ref('add')
const currentDriver = ref({})

// 查询参数
const queryParams = reactive({
  username: '',
  phoneNumber: '',
  status: '',
  page: 1,
  size: 10
})

// 表单对象
const driverForm = ref({
  username: '',
  fullName: '',
  email: '',
  phoneNumber: '',
  password: '',
  photo: '',
  driverLicenseNumber: '',
  vehicle: '',
  status: 'available'
})

// 表单验证规则
const rules = {
  username: [
    { required: true, message: 'Please enter username', trigger: 'blur' },
    { min: 3, max: 50, message: 'Length should be 3 to 50 characters', trigger: 'blur' }
  ],
  fullName: [
    { required: true, message: 'Please enter full name', trigger: 'blur' }
  ],
  email: [
    { required: true, message: 'Please enter email address', trigger: 'blur' },
    { type: 'email', message: 'Please enter a valid email address', trigger: ['blur', 'change'] }
  ],
  phoneNumber: [
    { required: true, message: 'Please enter phone number', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: 'Please enter a valid phone number', trigger: 'blur' }
  ],
  password: [
    { required: true, message: 'Please enter password', trigger: 'blur' },
    { min: 6, message: 'Password must be at least 6 characters', trigger: 'blur' }
  ],
  driverLicenseNumber: [
    { required: true, message: 'Please enter license number', trigger: 'blur' }
  ],
  vehicle: [
    { required: true, message: 'Please enter vehicle information', trigger: 'blur' }
  ],
  status: [
    { required: true, message: 'Please select status', trigger: 'change' }
  ]
}

const driverFormRef = ref(null)

// 生命周期钩子
onMounted(() => {
  getDrivers()
})

// 获取司机列表
const getDrivers = async () => {
  loading.value = true
  try {
    // 调用 API 接口获取数据
    const res = await getDriverList({
      username: queryParams.username || null,
      phoneNumber: queryParams.phoneNumber || null,
      status: queryParams.status || null,
      page: currentPage.value,
      size: pageSize.value
    })
    
    // 添加调试日志，查看实际返回的数据结构
    console.log('API returns original data:', res)
    
    // 根据后端Result类的实际实现，修改数据处理逻辑
    // Result类的属性为：code(1表示成功，0表示失败)、msg、data
    if (res && res.code === 1) { // 注意这里是1，不是200
      // 分析data的结构
      if (res.data && res.data.data && Array.isArray(res.data.data)) {
        // findByPage返回的结构是 { data: [], total: 100 }
        driverList.value = res.data.data
        total.value = res.data.total || 0
        console.log('Parsed driver list:', driverList.value)
      } else if (Array.isArray(res.data)) {
        // 直接返回数组的情况
        driverList.value = res.data
        // 如果没有返回总数，就使用数组长度作为总数
        total.value = res.total || res.data.length || 0
        console.log('Parsed driver list (array):', driverList.value)
      } else {
        console.error('Returned data structure unexpected:', res.data)
        driverList.value = []
        total.value = 0
      }
    } else {
      console.error('API request failed:', res)
      ElMessage.error(res?.msg || 'Failed to get driver list')
      driverList.value = []
      total.value = 0
    }
  } catch (error) {
    console.error('Error getting driver list:', error)
    ElMessage.error('Failed to get driver list')
    driverList.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

// 提交表单
const submitForm = async () => {
  if (!driverFormRef.value) return
  
  driverFormRef.value.validate(async (valid) => {
    if (!valid) {
      ElMessage.warning('Form validation failed, please check your input')
      return
    }

    // 确保必要字段已填写
    if (dialogType.value === 'add' && !driverForm.value.password) {
      ElMessage.warning('Please enter password')
      return
    }

    try {
      // 添加调试日志
      console.log('Form data to submit:', JSON.stringify(driverForm.value))
      
      if (dialogType.value === 'add') {
        // 准备添加司机的数据
        const driverData = {
          ...driverForm.value,
          // 确保状态字段有值
          status: driverForm.value.status || 'available'
        }
        
        const res = await addDriver(driverData)
        // 检查是否成功
        if (res && res.code === 1) { // 使用正确的成功状态码
          console.log('Add driver response:', res)
          ElMessage.success('Added successfully')
          editDialogVisible.value = false
          getDrivers()
        } else {
          ElMessage.error(res?.msg || 'Failed to add')
        }
      } else {
        // 准备更新司机的数据，确保ID存在
        if (!driverForm.value.id) {
          ElMessage.error('Missing driver ID, cannot update')
          return
        }
        
        const res = await updateDriver(driverForm.value.id, driverForm.value)
        // 检查是否成功
        if (res && res.code === 1) { // 使用正确的成功状态码
          console.log('Update driver response:', res)
          ElMessage.success('Updated successfully')
          editDialogVisible.value = false
          getDrivers()
        } else {
          ElMessage.error(res?.msg || 'Failed to update')
        }
      }
    } catch (error) {
      console.error(dialogType.value === 'add' ? 'Failed to add driver:' : 'Failed to update driver:', error)
      // 显示更详细的错误信息
      let errorMsg = dialogType.value === 'add' ? 'Failed to add' : 'Failed to update'
      if (error.response) {
        errorMsg += `: ${error.response.data?.msg || error.message || 'Unknown error'}`
      } else if (error.message) {
        errorMsg += `: ${error.message}`
      }
      ElMessage.error(errorMsg)
    }
  })
}

// 设置上传请求头，确保携带token
const uploadHeaders = computed(() => {
  const token = localStorage.getItem('loginUser') ? JSON.parse(localStorage.getItem('loginUser')).token : null
  return {
    Authorization: token ? `Bearer ${token}` : ''
  }
})

// 处理头像上传成功
const handleAvatarSuccess = (res, file) => {
  console.log('Avatar upload success:', res)
  // 检查响应格式，确保正确获取URL
  if (res.data && res.data.url) {
    driverForm.value.photo = res.data.url
  } else if (res.url) {
    driverForm.value.photo = res.url
  } else if (typeof res === 'string') {
    // 如果直接返回URL字符串
    driverForm.value.photo = res
  } else {
    console.error('Cannot get image URL from response:', res)
    ElMessage.warning('Avatar uploaded successfully, but could not get URL')
  }
}

// 处理头像上传错误
const handleAvatarError = (err) => {
  console.error('Avatar upload failed:', err)
  let errorMsg = 'Failed to upload avatar'
  if (err.response) {
    errorMsg += `: ${err.response.data?.msg || err.message || 'Server rejected request'}`
  } else if (err.message) {
    errorMsg += `: ${err.message}`
  }
  ElMessage.error(errorMsg)
}

// 头像上传前的验证
const beforeAvatarUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('Avatar must be an image file!')
  }
  if (!isLt2M) {
    ElMessage.error('Avatar size cannot exceed 2MB!')
  }
  
  return isImage && isLt2M
}

// 查询
const handleSearch = () => {
  currentPage.value = 1
  getDrivers()
}

// 重置
const handleReset = () => {
  queryParams.username = ''
  queryParams.phoneNumber = ''
  queryParams.status = ''
  handleSearch()
}

// 改变页码
const handleSizeChange = (size) => {
  pageSize.value = size
  getDrivers()
}

// 改变当前页
const handleCurrentChange = (page) => {
  currentPage.value = page
  getDrivers()
}

// 查看司机详情
const handleView = async (row) => {
  try {
    const res = await getDriverDetail(row.id)
    console.log('Get driver detail response:', res)
    
    // 检查响应格式
    if (res && res.code === 1) { // 使用正确的成功状态码
      // 根据实际响应结构解析数据
      currentDriver.value = res.data || row
      // 打开对话框
      viewDialogVisible.value = true
    } else {
      ElMessage.error(res?.msg || 'Failed to get driver details')
      // 如果API请求失败，也可以使用行数据
      currentDriver.value = row
      viewDialogVisible.value = true
    }
  } catch (error) {
    console.error('Failed to get driver details:', error)
    ElMessage.error('Failed to get driver details')
    // 出错时也可以显示行数据
    currentDriver.value = row
    viewDialogVisible.value = true
  }
}

// 添加司机
const handleAdd = () => {
  dialogType.value = 'add'
  driverForm.value = {
    username: '',
    fullName: '',
    email: '',
    phoneNumber: '',
    password: '',
    photo: '',
    driverLicenseNumber: '',
    vehicle: '',
    status: 'available'
  }
  editDialogVisible.value = true
}

// 编辑司机
const handleEdit = async (row) => {
  dialogType.value = 'edit'
  try {
    const res = await getDriverDetail(row.id)
    console.log('Edit driver get detail:', res)
    
    // 检查响应格式
    if (res && res.code === 1) { // 使用正确的成功状态码
      driverForm.value = { ...res.data } || { ...row }
    } else {
      ElMessage.error(res?.msg || 'Failed to get driver details')
      driverForm.value = { ...row }
    }
    
    editDialogVisible.value = true
  } catch (error) {
    console.error('Failed to get driver details:', error)
    ElMessage.error('Failed to get driver details')
    // 失败时也可以使用行数据
    driverForm.value = { ...row }
    editDialogVisible.value = true
  }
}

// 删除司机
const handleDelete = (row) => {
  ElMessageBox.confirm('Are you sure you want to delete this driver?', 'Warning', {
    confirmButtonText: 'Confirm',
    cancelButtonText: 'Cancel',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteDriver(row.id)
      if (res && res.code === 1) {
        ElMessage.success('Deleted successfully')
        getDrivers()
      } else {
        ElMessage.error(res?.msg || 'Failed to delete')
      }
    } catch (error) {
      console.error('Failed to delete driver:', error)
      ElMessage.error('Failed to delete')
    }
  }).catch(() => {})
}

// 改变司机状态
const handleChangeStatus = (row) => {
  const newStatus = row.status === 'offline' ? 'available' : 'offline'
  const statusText = newStatus === 'available' ? 'Online' : 'Offline'
  
  ElMessageBox.confirm(`Are you sure you want to set this driver ${statusText.toLowerCase()}?`, 'Confirm', {
    confirmButtonText: 'Confirm',
    cancelButtonText: 'Cancel',
    type: 'warning'
  }).then(async () => {
    try {
      // 调用更新状态API
      const res = await changeDriverStatus(row.id, { status: newStatus })
      
      if (res && res.code === 1) { // 使用正确的成功状态码
        ElMessage.success(`Set ${statusText.toLowerCase()} successfully`)
        getDrivers()
      } else {
        ElMessage.error(res?.msg || `Failed to set ${statusText.toLowerCase()}`)
      }
    } catch (error) {
      console.error(`Failed to set driver ${statusText.toLowerCase()}:`, error)
      ElMessage.error(`Failed to set ${statusText.toLowerCase()}`)
    }
  }).catch(() => {})
}
</script>

<style scoped>
.driver-container {
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

.avatar-uploader {
  width: 178px;
  height: 178px;
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.avatar-uploader:hover {
  border-color: #409eff;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  line-height: 178px;
  text-align: center;
}

.avatar {
  width: 178px;
  height: 178px;
  display: block;
}

.upload-tip {
  margin-top: 10px;
  text-align: right;
}

.button-column {
  display: flex;
  flex-direction: column;
  gap: 5px;
}
</style>