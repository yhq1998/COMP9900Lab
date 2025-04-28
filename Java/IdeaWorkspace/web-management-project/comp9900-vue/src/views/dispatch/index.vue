<template>
  <div class="vehicle-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <h3>Vehicle Management</h3>
          <el-button type="primary" @click="handleAdd">Add Vehicle</el-button>
        </div>
      </template>
      
      <el-table :data="vehicleList" style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="plateNumber" label="License Plate" width="120" />
        <el-table-column prop="vehicleType" label="Vehicle Type" width="120" />
        <el-table-column prop="seats" label="Seats" width="100" />
        <el-table-column prop="status" label="Status">
          <template #default="scope">
            <el-tag :type="scope.row.status === 'ACTIVE' ? 'success' : 'danger'">
              {{ scope.row.status === 'ACTIVE' ? 'Active' : 'Maintenance' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="driverName" label="Current Driver" width="120" />
        <el-table-column prop="lastMaintenance" label="Last Maintenance" width="180" />
        <el-table-column label="Actions" width="200">
          <template #default="scope">
            <el-button size="small" @click="handleEdit(scope.row)">Edit</el-button>
            <el-button size="small" type="danger" @click="handleDelete(scope.row)">Delete</el-button>
          </template>
        </el-table-column>
      </el-table>
      
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

    <!-- 添加/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogType === 'add' ? 'Add Vehicle' : 'Edit Vehicle'">
      <el-form :model="vehicleForm" label-width="100px" :rules="rules" ref="vehicleFormRef">
        <el-form-item label="License Plate" prop="plateNumber">
          <el-input v-model="vehicleForm.plateNumber" placeholder="Please enter license plate" />
        </el-form-item>
        <el-form-item label="Vehicle Type" prop="vehicleType">
          <el-select v-model="vehicleForm.vehicleType" placeholder="Please select vehicle type" style="width: 100%">
            <el-option label="Mini Bus" value="MINI_BUS" />
            <el-option label="Medium Bus" value="MEDIUM_BUS" />
            <el-option label="Large Bus" value="LARGE_BUS" />
          </el-select>
        </el-form-item>
        <el-form-item label="Seats" prop="seats">
          <el-input-number v-model="vehicleForm.seats" :min="1" :max="50" style="width: 100%" />
        </el-form-item>
        <el-form-item label="Status" prop="status">
          <el-select v-model="vehicleForm.status" placeholder="Please select status" style="width: 100%">
            <el-option label="Active" value="ACTIVE" />
            <el-option label="Maintenance" value="MAINTENANCE" />
          </el-select>
        </el-form-item>
        <el-form-item label="Driver" prop="driverId">
          <el-select v-model="vehicleForm.driverId" placeholder="Please select driver" style="width: 100%">
            <el-option v-for="driver in driverList" :key="driver.id" :label="driver.name" :value="driver.id" />
          </el-select>
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
import { ref, onMounted, reactive } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { getVehicleList, addVehicle, updateVehicle, deleteVehicle } from '@/api/vehicle';
import { getDriverList } from '@/api/driver';

// 数据列表
const vehicleList = ref([]);
const driverList = ref([]);
const total = ref(0);
const loading = ref(false);
const currentPage = ref(1);
const pageSize = ref(10);

// 表单数据
const dialogVisible = ref(false);
const dialogType = ref('add'); // 'add' 或 'edit'
const vehicleFormRef = ref(null);
const vehicleForm = reactive({
  id: null,
  plateNumber: '',
  vehicleType: '',
  seats: 10,
  status: 'ACTIVE',
  driverId: null,
});

// 表单验证规则
const rules = {
  plateNumber: [
    { required: true, message: 'Please enter license plate', trigger: 'blur' },
  ],
  vehicleType: [
    { required: true, message: 'Please select vehicle type', trigger: 'change' },
  ],
  seats: [
    { required: true, message: 'Please enter number of seats', trigger: 'blur' },
  ],
  status: [
    { required: true, message: 'Please select status', trigger: 'change' },
  ],
};

// 获取车辆列表
const fetchVehicleList = async () => {
  loading.value = true;
  try {
    const res = await getVehicleList({
      page: currentPage.value,
      pageSize: pageSize.value
    });
    vehicleList.value = res.data;
    total.value = res.total;
  } catch (error) {
    console.error('Failed to get vehicle list:', error);
    ElMessage.error('Failed to get vehicle list');
  } finally {
    loading.value = false;
  }
};

// 获取司机列表
const fetchDriverList = async () => {
  try {
    const res = await getDriverList({
      page: 1,
      pageSize: 100
    });
    driverList.value = res.data;
  } catch (error) {
    console.error('Failed to get driver list:', error);
  }
};

// 处理添加车辆
const handleAdd = () => {
  dialogType.value = 'add';
  vehicleForm.id = null;
  vehicleForm.plateNumber = '';
  vehicleForm.vehicleType = '';
  vehicleForm.seats = 10;
  vehicleForm.status = 'ACTIVE';
  vehicleForm.driverId = null;
  dialogVisible.value = true;
};

// 处理编辑车辆
const handleEdit = (row) => {
  dialogType.value = 'edit';
  vehicleForm.id = row.id;
  vehicleForm.plateNumber = row.plateNumber;
  vehicleForm.vehicleType = row.vehicleType;
  vehicleForm.seats = row.seats;
  vehicleForm.status = row.status;
  vehicleForm.driverId = row.driverId;
  dialogVisible.value = true;
};

// 处理删除车辆
const handleDelete = (row) => {
  ElMessageBox.confirm('Are you sure you want to delete this vehicle?', 'Warning', {
    confirmButtonText: 'Confirm',
    cancelButtonText: 'Cancel',
    type: 'warning',
  }).then(async () => {
    try {
      await deleteVehicle(row.id);
      ElMessage.success('Delete successful');
      fetchVehicleList();
    } catch (error) {
      console.error('Failed to delete vehicle:', error);
      ElMessage.error('Failed to delete vehicle');
    }
  }).catch(() => {});
};

// 提交表单
const submitForm = async () => {
  if (!vehicleFormRef.value) return;
  
  await vehicleFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (dialogType.value === 'add') {
          await addVehicle(vehicleForm);
          ElMessage.success('Add successful');
        } else {
          await updateVehicle(vehicleForm.id, vehicleForm);
          ElMessage.success('Update successful');
        }
        dialogVisible.value = false;
        fetchVehicleList();
      } catch (error) {
        console.error('Operation failed:', error);
        ElMessage.error('Operation failed');
      }
    }
  });
};

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val;
  fetchVehicleList();
};

const handleCurrentChange = (val) => {
  currentPage.value = val;
  fetchVehicleList();
};

// 初始化
onMounted(() => {
  fetchVehicleList();
  fetchDriverList();
});
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

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>