<template>
  <h1>Advertisement Order Management</h1>

  <!-- Button displayed on the right side of the page -->
  <el-button type="primary" size="default" style="width: 120px; float: right;" @click="addOrder()"> + Add Order</el-button> <br><br>

  <!-- Data display table -->
  <el-table :data="orderData" border style="width: 100%;">
    <el-table-column type="index" label="ID" width="80" align="center"/>
    <el-table-column prop="orderNumber" label="Order Number" width="180" align="center"/>
    <el-table-column prop="orderType" label="Type" width="120" align="center">
      <template #default="scope">{{ mapOrderType(scope.row.orderType) }}</template>
    </el-table-column>
    <el-table-column prop="startLocation" label="Start" width="200" align="center"/>
    <el-table-column prop="endLocation" label="End" width="200" align="center"/>
    <el-table-column prop="status" label="Status" width="120" align="center">
      <template #default="scope">{{ mapStatus(scope.row.status) }}</template>
    </el-table-column>
    <el-table-column prop="createdAt" label="Created At" width="180" align="center"/>
    <el-table-column fixed="right" label="Actions" align="center" width="120">
      <template #default="{ row }">
        <div class="button-column">
          <el-button size="default" type="primary" style="width: 100%;" @click="handleEdit(row)">Edit</el-button>
          <el-button size="default" type="danger" style="width: 100%;" @click="handleDelete(row)">Delete</el-button>
        </div>
      </template>
    </el-table-column>
  </el-table>

  <!-- Add/Edit Order Dialog -->
  <el-dialog v-model="showDialog" :title="formTitle" width="60%" @close="resetForm">
    <el-form :model="orderForm" :rules="formRules" ref="orderFormRef">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="Order Number" prop="orderNumber" label-width="120px">
            <el-input v-model="orderForm.orderNumber" autocomplete="off"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="User ID" prop="userId" label-width="120px">
            <el-input v-model="orderForm.userId" type="number"></el-input>
          </el-form-item>
        </el-col>
      </el-row>

      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="Driver ID" prop="driverId" label-width="120px">
            <el-input v-model="orderForm.driverId" type="number"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="Vehicle ID" prop="vehicleId" label-width="120px">
            <el-input v-model="orderForm.vehicleId" type="number"></el-input>
          </el-form-item>
        </el-col>
      </el-row>

      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="Order Type" prop="orderType" label-width="120px">
            <el-select v-model="orderForm.orderType" placeholder="Select type">
              <el-option label="Private" value="private"/>
              <el-option label="Business" value="business"/>
              <el-option label="Group" value="group"/>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="Passenger Count" prop="passengerCount" label-width="120px">
            <el-input v-model="orderForm.passengerCount" type="number"></el-input>
          </el-form-item>
        </el-col>
      </el-row>

      <el-form-item label="Start Location" prop="startLocation" label-width="120px">
        <el-input v-model="orderForm.startLocation" type="textarea" :rows="3"></el-input>
      </el-form-item>

      <el-form-item label="End Location" prop="endLocation" label-width="120px">
        <el-input v-model="orderForm.endLocation" type="textarea" :rows="3"></el-input>
      </el-form-item>
    </el-form>

    <template #footer>
      <span class="dialog-footer">
        <el-button size="default" style="width: 100px;" @click="showDialog = false">Cancel</el-button>
        <el-button size="default" style="width: 100px;" type="primary" @click="saveOrder">Confirm</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  getOrderList, 
  getOrderDetail, 
  addOrder as createOrder, 
  updateOrder, 
  deleteOrder 
} from '@/api/order'

// Declare list display data
let orderData = ref([])

// Dynamically load data - query orders
const queryAllOrders = async () => {
  const result = await getOrderList({})
  orderData.value = result.data
}

// Hook function
onMounted(() => {
  queryAllOrders()
})

const formTitle = ref('')
// Add order
const addOrder = () => {
  formTitle.value = 'Add Order'
  showDialog.value = true
  orderForm.value = {
    orderNumber: '',
    userId: null,
    driverId: null,
    vehicleId: null,
    orderType: 'private',
    startLocation: '',
    endLocation: '',
    passengerCount: 1
  }
}

// Edit order - query data by ID for display
const handleEdit = async (row) => {
  formTitle.value = 'Edit Order'
  showDialog.value = true
  
  const result = await getOrderDetail(row.id)
  if(result.code){
    orderForm.value = result.data
  }
};

// Delete order - delete order by ID
const handleDelete = (row) => {
  ElMessageBox.confirm('This operation will permanently delete the order, proceed?', 'Warning', {
    confirmButtonText: 'Yes',
    cancelButtonText: 'No',
    type: 'warning'
  }).then(async () => {
    const result = await deleteOrder(row.id)
    if(result.code){
      ElMessage.success('Order deleted')
      queryAllOrders()
    }
  })
};

// Dialog state
const showDialog = ref(false)
// Form data
const orderForm = ref({})
// Form validation rules
const formRules = ref({
  orderNumber: [
    { required: true, message: 'Order number is required', trigger: 'blur' }
  ],
  userId: [
    { required: true, message: 'User ID is required', trigger: 'blur' },
    { type: 'number', message: 'Must be a valid number', trigger: 'blur' }
  ],
  startLocation: [
    { required: true, message: 'Start location is required', trigger: 'blur' }
  ],
  endLocation: [
    { required: true, message: 'End location is required', trigger: 'blur' }
  ]
})

// Form reference
const orderFormRef = ref(null)

// Reset form
const resetForm = () => {
  orderFormRef.value?.resetFields()
}

// Submit form
const saveOrder = async () => {
  await orderFormRef.value.validate(async valid => {
    if (!valid) return
    
    const result = orderForm.value.id 
      ? await updateOrder(orderForm.value.id, orderForm.value) 
      : await createOrder(orderForm.value)
    
    if(result.code){
      ElMessage.success('Operation successful')
      showDialog.value = false
      resetForm()
      queryAllOrders()
    }else {
      ElMessage.error(result.msg)
    }
  })
}

// Enum value mapping
const mapOrderType = (type) => {
  return {
    private: 'Private',
    business: 'Business',
    group: 'Group'
  }[type] || 'Unknown'
}

const mapStatus = (status) => {
  return {
    pending: 'Pending',
    confirmed: 'Confirmed',
    completed: 'Completed',
    cancelled: 'Cancelled'
  }[status] || 'Unknown'
}
</script>

<style scoped>
/* Maintain original styles or adjust as needed */
.button-column {
  display: flex;
  flex-direction: column;
  gap: 5px;
}
</style>