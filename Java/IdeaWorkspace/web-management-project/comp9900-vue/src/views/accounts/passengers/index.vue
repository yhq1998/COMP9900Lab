<template>
  <div class="passenger-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <h3>Passenger Management</h3>
          <el-button type="primary" @click="handleAdd">Add Passenger</el-button>
        </div>
      </template>
      
      <!-- 搜索表单 -->
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="Username">
          <el-input v-model="queryParams.username" placeholder="Please enter username" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="Full Name">
          <el-input v-model="queryParams.fullName" placeholder="Please enter passenger name" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="Phone Number">
          <el-input v-model="queryParams.phoneNumber" placeholder="Please enter phone number" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">Search</el-button>
          <el-button @click="handleReset">Reset</el-button>
        </el-form-item>
      </el-form>
      
      <!-- 数据表格 -->
      <el-table :data="passengerList" style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="Username" width="120" />
        <el-table-column prop="fullName" label="Full Name" width="120" />
        <el-table-column prop="phoneNumber" label="Phone Number" width="130" />
        <el-table-column prop="email" label="Email" width="180" show-overflow-tooltip />
        <el-table-column prop="createdAt" label="Registration Time" width="180" />
        <el-table-column label="Actions" fixed="right" width="200">
          <template #default="scope">
            <el-button size="small" @click="handleEdit(scope.row)">Edit</el-button>
            <el-button size="small" type="danger" @click="handleDelete(scope.row)">Delete</el-button>
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

    <!-- 添加/编辑乘客对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogType === 'add' ? 'Add Passenger' : 'Edit Passenger Information'">
      <el-form :model="passengerForm" label-width="100px" :rules="rules" ref="passengerFormRef">
        <el-form-item label="Username" prop="username">
          <el-input v-model="passengerForm.username" placeholder="Please enter username" />
        </el-form-item>
        <el-form-item label="Full Name" prop="fullName">
          <el-input v-model="passengerForm.fullName" placeholder="Please enter full name" />
        </el-form-item>
        <el-form-item label="Password" prop="password" v-if="dialogType === 'add'">
          <el-input v-model="passengerForm.password" type="password" placeholder="Please enter password" show-password />
        </el-form-item>
        <el-form-item label="Phone Number" prop="phoneNumber">
          <el-input v-model="passengerForm.phoneNumber" placeholder="Please enter phone number" />
        </el-form-item>
        <el-form-item label="Email" prop="email">
          <el-input v-model="passengerForm.email" placeholder="Please enter email" />
        </el-form-item>
        <el-form-item label="Avatar" prop="photo">
          <el-input v-model="passengerForm.photo" placeholder="Please enter avatar URL" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="submitForm">Confirm</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, nextTick } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { getPassengerList, addPassenger, updatePassenger, deletePassenger } from '@/api/passenger';

// 查询参数
const queryParams = reactive({
  username: '',
  fullName: '',
  phoneNumber: ''
});

// 数据列表
const passengerList = ref([]);
const total = ref(0);
const loading = ref(false);
const currentPage = ref(1);
const pageSize = ref(10);

// 对话框
const dialogVisible = ref(false);
const dialogType = ref('add'); // 'add' 或 'edit'
const passengerFormRef = ref(null);
const passengerForm = reactive({
  id: null,
  username: '',
  fullName: '',
  password: '',
  phoneNumber: '',
  email: '',
  photo: '',
  createdAt: null,
  updatedAt: null
});

// 表单验证规则
const rules = {
  username: [
    { required: true, message: 'Please enter username', trigger: 'blur' },
    { min: 3, max: 20, message: 'Length should be between 3 to 20 characters', trigger: 'blur' }
  ],
  fullName: [
    { required: true, message: 'Please enter full name', trigger: 'blur' },
    { min: 2, max: 50, message: 'Length should be between 2 to 50 characters', trigger: 'blur' }
  ],
  password: [
    { required: true, message: 'Please enter password', trigger: 'blur' },
    { min: 6, max: 20, message: 'Length should be between 6 to 20 characters', trigger: 'blur' }
  ],
  phoneNumber: [
    { required: true, message: 'Please enter phone number', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: 'Please enter a valid phone number', trigger: 'blur' }
  ],
  email: [
    { required: true, message: 'Please enter email', trigger: 'blur' },
    { type: 'email', message: 'Please enter a valid email address', trigger: 'blur' }
  ]
};

// 获取乘客列表
const fetchPassengerList = async () => {
  loading.value = true;
  try {
    const res = await getPassengerList({
      ...queryParams,
      page: currentPage.value,
      pageSize: pageSize.value
    });
    console.log("获取到乘客数据:", res);
    
    // 适配不同格式的返回数据
    if (res.code === 1 || res.code === 200) {
      if (res.data && res.data.rows) {
        passengerList.value = res.data.rows;
        total.value = res.data.total;
      } else if (Array.isArray(res.data)) {
        passengerList.value = res.data;
        total.value = res.data.length;
      } else {
        passengerList.value = [];
        total.value = 0;
      }
    } else {
      ElMessage.error(res.msg || '获取乘客列表失败');
      passengerList.value = [];
      total.value = 0;
    }
  } catch (error) {
    console.error('获取乘客列表失败:', error);
    ElMessage.error('获取乘客列表失败');
    passengerList.value = [];
    total.value = 0;
  } finally {
    loading.value = false;
  }
};

// 重置查询参数
const handleReset = () => {
  queryParams.username = '';
  queryParams.fullName = '';
  queryParams.phoneNumber = '';
  handleSearch();
};

// 查询
const handleSearch = () => {
  currentPage.value = 1;
  fetchPassengerList();
};

// 处理添加乘客
const handleAdd = () => {
  dialogType.value = 'add';
  passengerForm.id = null;
  passengerForm.username = '';
  passengerForm.fullName = '';
  passengerForm.password = '';
  passengerForm.phoneNumber = '';
  passengerForm.email = '';
  passengerForm.photo = '';
  passengerForm.createdAt = new Date();
  passengerForm.updatedAt = new Date();
  dialogVisible.value = true;
  nextTick(() => {
    if (passengerFormRef.value) {
      passengerFormRef.value.resetFields();
    }
  });
};

// 处理编辑乘客
const handleEdit = (row) => {
  dialogType.value = 'edit';
  passengerForm.id = row.id;
  passengerForm.username = row.username;
  passengerForm.fullName = row.fullName;
  passengerForm.password = ''; // 编辑时不需要填写密码
  passengerForm.phoneNumber = row.phoneNumber;
  passengerForm.email = row.email;
  passengerForm.photo = row.photo || '';
  passengerForm.createdAt = row.createdAt;
  passengerForm.updatedAt = new Date(); // 更新时设置更新时间
  dialogVisible.value = true;
};

// 处理删除乘客
const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该乘客吗？此操作将不可恢复！', '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  }).then(async () => {
    try {
      await deletePassenger(row.id);
      ElMessage.success('Delete successful');
      fetchPassengerList();
    } catch (error) {
      console.error('删除乘客失败:', error);
      ElMessage.error('删除乘客失败');
    }
  }).catch(() => {});
};

// 提交表单
const submitForm = async () => {
  if (!passengerFormRef.value) return;
  
  await passengerFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        // 构建提交的数据
        const submitData = {
          id: passengerForm.id,
          username: passengerForm.username,
          fullName: passengerForm.fullName,
          phoneNumber: passengerForm.phoneNumber,
          email: passengerForm.email,
          photo: passengerForm.photo,
          createdAt: passengerForm.createdAt,
          updatedAt: passengerForm.updatedAt
        };
        
        // 只有新增时才包含密码
        if (dialogType.value === 'add') {
          submitData.password = passengerForm.password;
        }
        
        if (dialogType.value === 'add') {
          await addPassenger(submitData);
          ElMessage.success('Add successful');
        } else {
          await updatePassenger(passengerForm.id, submitData);
          ElMessage.success('Update successful');
        }
        dialogVisible.value = false;
        fetchPassengerList();
      } catch (error) {
        console.error('操作失败:', error);
        ElMessage.error('操作失败: ' + (error.message || '未知错误'));
      }
    }
  });
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  fetchPassengerList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  fetchPassengerList();
};

// 初始化
onMounted(() => {
  fetchPassengerList();
});
</script>

<style scoped>
.passenger-container {
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

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>