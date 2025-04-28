<template>
  <div class="user-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <h3>User Management</h3>
          <el-button type="primary" size="default" @click="handleAdd">Add User</el-button>
        </div>
      </template>
      
      <!-- 搜索表单 -->
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="Username">
          <el-input v-model="queryParams.username" placeholder="Please enter username" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="Phone Number">
          <el-input v-model="queryParams.phoneNumber" placeholder="Please enter phone number" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="Email">
          <el-input v-model="queryParams.email" placeholder="Please enter email" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="default" @click="handleSearch">Search</el-button>
          <el-button size="default" @click="handleReset">Reset</el-button>
        </el-form-item>
      </el-form>
      
      <!-- 数据表格 -->
      <el-table :data="userList" style="width: 100%" v-loading="loading" border>
        <el-table-column type="index" label="Index" width="60" align="center" />
        <el-table-column prop="username" label="Username" width="120" />
        <el-table-column prop="fullName" label="Name" width="120" />
        <el-table-column prop="email" label="Email" width="180" show-overflow-tooltip />
        <el-table-column prop="phoneNumber" label="Phone Number" width="130" />
        <el-table-column prop="photo" label="Avatar" width="100">
          <template #default="scope">
            <el-avatar v-if="scope.row.photo" :src="scope.row.photo" size="small"></el-avatar>
            <el-avatar v-else size="small" icon="el-icon-user"></el-avatar>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="Created At" width="180" />
        <el-table-column prop="updatedAt" label="Updated At" width="180" />
        <el-table-column label="Actions" fixed="right" min-width="120">
          <template #default="scope">
            <div class="button-column">
              <el-button size="default" type="info" style="width: 100%;" @click="handleView(scope.row)">View</el-button>
              <el-button size="default" type="primary" style="width: 100%;" @click="handleEdit(scope.row)">Edit</el-button>
              <el-button size="default" type="danger" style="width: 100%;" @click="handleDelete(scope.row)">Delete</el-button>
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

    <!-- 用户详情对话框 -->
    <el-dialog v-model="viewDialogVisible" title="User Details" width="50%">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="User ID">{{ currentUser.id }}</el-descriptions-item>
        <el-descriptions-item label="Username">{{ currentUser.username }}</el-descriptions-item>
        <el-descriptions-item label="Name">{{ currentUser.fullName }}</el-descriptions-item>
        <el-descriptions-item label="Email">{{ currentUser.email }}</el-descriptions-item>
        <el-descriptions-item label="Phone Number">{{ currentUser.phoneNumber }}</el-descriptions-item>
        <el-descriptions-item label="Avatar">
          <el-avatar v-if="currentUser.photo" :src="currentUser.photo" :size="60"></el-avatar>
          <el-avatar v-else :size="60" icon="el-icon-user"></el-avatar>
        </el-descriptions-item>
        <el-descriptions-item label="Created At">{{ currentUser.createdAt }}</el-descriptions-item>
        <el-descriptions-item label="Updated At">{{ currentUser.updatedAt }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>

    <!-- 添加/编辑用户对话框 -->
    <el-dialog v-model="editDialogVisible" :title="dialogType === 'add' ? 'Add User' : 'Edit User'">
      <el-form :model="userForm" label-width="100px" :rules="rules" ref="userFormRef">
        <el-form-item label="Username" prop="username">
          <el-input v-model="userForm.username" placeholder="Please enter username" :disabled="dialogType === 'edit'" />
        </el-form-item>
        <el-form-item label="Name" prop="fullName">
          <el-input v-model="userForm.fullName" placeholder="Please enter name" />
        </el-form-item>
        <el-form-item label="Email" prop="email">
          <el-input v-model="userForm.email" placeholder="Please enter email" />
        </el-form-item>
        <el-form-item label="Phone Number" prop="phoneNumber">
          <el-input v-model="userForm.phoneNumber" placeholder="Please enter phone number" />
        </el-form-item>
        <el-form-item label="Password" prop="password" v-if="dialogType === 'add'">
          <el-input v-model="userForm.password" placeholder="Please enter password" show-password />
        </el-form-item>
        <el-form-item label="Avatar" prop="photo">
          <el-upload
            class="avatar-uploader"
            action="/api/upload"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :before-upload="beforeAvatarUpload"
          >
            <img v-if="userForm.photo" :src="userForm.photo" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
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
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'

// API 接口引入 (示例)
// import { getUserList, getUserDetail, addUser, updateUser, deleteUser } from '@/api/user'

// 状态变量
const loading = ref(false)
const userList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const viewDialogVisible = ref(false)
const editDialogVisible = ref(false)
const dialogType = ref('add')
const currentUser = ref({})

// 查询参数
const queryParams = reactive({
  username: '',
  phoneNumber: '',
  email: '',
  page: 1,
  size: 10
})

// 表单对象
const userForm = ref({
  username: '',
  fullName: '',
  email: '',
  phoneNumber: '',
  password: '',
  photo: ''
})

// 表单验证规则
const rules = {
  username: [
    { required: true, message: 'Please enter username', trigger: 'blur' },
    { min: 3, max: 50, message: 'Length should be between 3 to 50 characters', trigger: 'blur' }
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
    { min: 6, message: 'Password length should not be less than 6 characters', trigger: 'blur' }
  ]
}

const userFormRef = ref(null)

// 生命周期钩子
onMounted(() => {
  getUserList()
})

// 获取用户列表
const getUserList = async () => {
  loading.value = true
  try {
    // 调用 API 接口获取数据
    // const res = await getUserList({
    //   ...queryParams,
    //   page: currentPage.value,
    //   size: pageSize.value
    // })
    // userList.value = res.data.records
    // total.value = res.data.total
    
    // 模拟数据
    userList.value = Array.from({ length: 10 }).map((_, index) => ({
      id: index + 1,
      username: `user${index + 1}`,
      fullName: `User${index + 1}`,
      email: `user${index + 1}@example.com`,
      phoneNumber: `1391234567${index}`,
      photo: index % 3 === 0 ? 'https://via.placeholder.com/150' : '',
      createdAt: '2023-09-01 12:00:00',
      updatedAt: '2023-09-01 12:00:00'
    }))
    total.value = 100
  } finally {
    loading.value = false
  }
}

// 处理头像上传成功
const handleAvatarSuccess = (res, file) => {
  userForm.value.photo = res.data.url
}

// 头像上传前的验证
const beforeAvatarUpload = (file) => {
  const isJPG = file.type === 'image/jpeg' || file.type === 'image/png'
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isJPG) {
    ElMessage.error('Uploaded avatar image should be JPG or PNG format!')
  }
  if (!isLt2M) {
    ElMessage.error('Uploaded avatar image size should not exceed 2MB!')
  }
  return isJPG && isLt2M
}

// 查询
const handleSearch = () => {
  currentPage.value = 1
  getUserList()
}

// 重置
const handleReset = () => {
  queryParams.username = ''
  queryParams.phoneNumber = ''
  queryParams.email = ''
  handleSearch()
}

// 改变页码
const handleSizeChange = (size) => {
  pageSize.value = size
  getUserList()
}

// 改变当前页
const handleCurrentChange = (page) => {
  currentPage.value = page
  getUserList()
}

// 查看用户详情
const handleView = (row) => {
  currentUser.value = row
  viewDialogVisible.value = true
}

// 添加用户
const handleAdd = () => {
  dialogType.value = 'add'
  userForm.value = {
    username: '',
    fullName: '',
    email: '',
    phoneNumber: '',
    password: '',
    photo: ''
  }
  editDialogVisible.value = true
}

// 编辑用户
const handleEdit = (row) => {
  dialogType.value = 'edit'
  userForm.value = { ...row }
  editDialogVisible.value = true
}

// 删除用户
const handleDelete = (row) => {
  ElMessageBox.confirm('Are you sure you want to delete this user?', 'Warning', {
    confirmButtonText: 'Confirm',
    cancelButtonText: 'Cancel',
    type: 'warning'
  }).then(async () => {
    try {
      // await deleteUser(row.id)
      ElMessage.success('Delete success')
      getUserList()
    } catch (error) {
      ElMessage.error('Delete failed')
    }
  }).catch(() => {})
}

// 提交表单
const submitForm = async () => {
  userFormRef.value.validate(async (valid) => {
    if (!valid) return

    try {
      if (dialogType.value === 'add') {
        // await addUser(userForm.value)
        ElMessage.success('Add success')
      } else {
        // await updateUser(userForm.value.id, userForm.value)
        ElMessage.success('Update success')
      }
      editDialogVisible.value = false
      getUserList()
    } catch (error) {
      ElMessage.error(dialogType.value === 'add' ? 'Add failed' : 'Update failed')
    }
  })
}
</script>

<style scoped>
.user-container {
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

.button-column {
  display: flex;
  flex-direction: column;
  gap: 5px;
}
</style> 