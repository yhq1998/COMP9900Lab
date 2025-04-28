<template>
  <div class="payment-container">
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <h3>Payment Management</h3>
        </div>
      </template>
      
      <!-- Search Form -->
      <el-form :inline="true" :model="queryParams" class="search-form">
        <el-form-item label="Order No">
          <el-input v-model="queryParams.orderId" placeholder="Enter order number" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="Payment Status">
          <el-select v-model="queryParams.status" placeholder="Select status" clearable>
            <el-option label="Pending" value="pending" />
            <el-option label="Paid" value="paid" />
            <el-option label="Refunded" value="refunded" />
            <el-option label="Cancelled" value="cancelled" />
          </el-select>
        </el-form-item>
        <el-form-item label="Payment Method">
          <el-select v-model="queryParams.paymentMethod" placeholder="Select payment method" clearable>
            <el-option label="WeChat Pay" value="wechat" />
            <el-option label="Alipay" value="alipay" />
            <el-option label="Credit Card" value="credit_card" />
            <el-option label="Cash" value="cash" />
          </el-select>
        </el-form-item>
        <el-form-item label="Date Range">
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
      <el-table :data="paymentList" style="width: 100%" v-loading="loading" border>
        <el-table-column prop="id" label="Payment ID" width="220" show-overflow-tooltip />
        <el-table-column prop="orderId" label="Order ID" width="100" />
        <el-table-column prop="orderNumber" label="Order No" width="180" />
        <el-table-column prop="amount" label="Amount" width="120">
          <template #default="scope">
            ¥ {{ formatAmount(scope.row.amount) }}
          </template>
        </el-table-column>
        <el-table-column prop="paymentMethod" label="Payment Method" width="120">
          <template #default="scope">
            <el-tag v-if="scope.row.paymentMethod === 'wechat'" type="success">WeChat Pay</el-tag>
            <el-tag v-else-if="scope.row.paymentMethod === 'alipay'" type="primary">Alipay</el-tag>
            <el-tag v-else-if="scope.row.paymentMethod === 'credit_card'" type="warning">Credit Card</el-tag>
            <el-tag v-else-if="scope.row.paymentMethod === 'cash'" type="info">Cash</el-tag>
            <el-tag v-else>{{ scope.row.paymentMethod }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="Status" width="100">
          <template #default="scope">
            <el-tag v-if="scope.row.status === 'pending'" type="warning">Pending</el-tag>
            <el-tag v-else-if="scope.row.status === 'paid'" type="success">Paid</el-tag>
            <el-tag v-else-if="scope.row.status === 'refunded'" type="info">Refunded</el-tag>
            <el-tag v-else-if="scope.row.status === 'cancelled'" type="danger">Cancelled</el-tag>
            <el-tag v-else>{{ scope.row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="Created Time" width="180" />
        <el-table-column label="Actions" fixed="right" min-width="120">
          <template #default="scope">
            <div class="button-column">
              <el-button size="default" type="info" style="width: 100%;" @click="handleView(scope.row)">View</el-button>
              <el-button 
                size="default" 
                type="primary" 
                style="width: 100%;"
                @click="handleConfirmPayment(scope.row)" 
                v-if="scope.row.status === 'pending'"
              >Confirm Payment</el-button>
              <el-button 
                size="default" 
                type="warning" 
                style="width: 100%;"
                @click="handleRefund(scope.row)" 
                v-if="scope.row.status === 'paid'"
              >Refund</el-button>
              <el-button 
                size="default" 
                type="danger" 
                style="width: 100%;"
                @click="handleCancel(scope.row)" 
                v-if="scope.row.status === 'pending'"
              >Cancel</el-button>
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

    <!-- Payment Details Dialog -->
    <el-dialog v-model="viewDialogVisible" title="Payment Details" width="50%">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="Payment ID">{{ currentPayment.id }}</el-descriptions-item>
        <el-descriptions-item label="Order ID">{{ currentPayment.orderId }}</el-descriptions-item>
        <el-descriptions-item label="Order No">{{ currentPayment.orderNumber }}</el-descriptions-item>
        <el-descriptions-item label="Amount">¥ {{ formatAmount(currentPayment.amount) }}</el-descriptions-item>
        <el-descriptions-item label="Payment Method">
          <el-tag v-if="currentPayment.paymentMethod === 'wechat'" type="success">WeChat Pay</el-tag>
          <el-tag v-else-if="currentPayment.paymentMethod === 'alipay'" type="primary">Alipay</el-tag>
          <el-tag v-else-if="currentPayment.paymentMethod === 'credit_card'" type="warning">Credit Card</el-tag>
          <el-tag v-else-if="currentPayment.paymentMethod === 'cash'" type="info">Cash</el-tag>
          <el-tag v-else>{{ currentPayment.paymentMethod }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="Status">
          <el-tag v-if="currentPayment.status === 'pending'" type="warning">Pending</el-tag>
          <el-tag v-else-if="currentPayment.status === 'paid'" type="success">Paid</el-tag>
          <el-tag v-else-if="currentPayment.status === 'refunded'" type="info">Refunded</el-tag>
          <el-tag v-else-if="currentPayment.status === 'cancelled'" type="danger">Cancelled</el-tag>
          <el-tag v-else>{{ currentPayment.status }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="Created Time">{{ currentPayment.createdAt }}</el-descriptions-item>
        <el-descriptions-item label="User Information" v-if="currentPayment.user">{{ currentPayment.user.username }} ({{ currentPayment.user.fullName }})</el-descriptions-item>
        <el-descriptions-item label="Transaction ID" v-if="currentPayment.transactionId">{{ currentPayment.transactionId }}</el-descriptions-item>
      </el-descriptions>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button size="default" style="width: 100px;" @click="viewDialogVisible = false">Close</el-button>
          <el-button 
            size="default"
            type="primary" 
            style="width: 100px;"
            @click="handleConfirmPayment(currentPayment)" 
            v-if="currentPayment.status === 'pending'"
          >Confirm Payment</el-button>
          <el-button 
            size="default"
            type="warning" 
            style="width: 100px;"
            @click="handleRefund(currentPayment)" 
            v-if="currentPayment.status === 'paid'"
          >Refund</el-button>
          <el-button 
            size="default"
            type="danger" 
            style="width: 100px;"
            @click="handleCancel(currentPayment)" 
            v-if="currentPayment.status === 'pending'"
          >Cancel</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- Confirm Payment Dialog -->
    <el-dialog v-model="confirmPaymentDialogVisible" title="Confirm Payment" width="40%">
      <el-form :model="paymentForm" :rules="paymentRules" ref="paymentFormRef" label-width="120px">
        <el-form-item label="Payment Method" prop="paymentMethod">
          <el-select v-model="paymentForm.paymentMethod" placeholder="Select payment method">
            <el-option label="WeChat Pay" value="wechat" />
            <el-option label="Alipay" value="alipay" />
            <el-option label="Credit Card" value="credit_card" />
            <el-option label="Cash" value="cash" />
          </el-select>
        </el-form-item>
        <el-form-item label="Transaction ID" prop="transactionId" v-if="paymentForm.paymentMethod !== 'cash'">
          <el-input v-model="paymentForm.transactionId" placeholder="Enter transaction ID" />
        </el-form-item>
        <el-form-item label="Remarks" prop="remark">
          <el-input v-model="paymentForm.remark" type="textarea" rows="3" placeholder="Enter remarks" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button size="default" style="width: 100px;" @click="confirmPaymentDialogVisible = false">Cancel</el-button>
          <el-button size="default" style="width: 100px;" type="primary" @click="submitConfirmPayment">Confirm</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- Refund Dialog -->
    <el-dialog v-model="refundDialogVisible" title="Refund" width="40%">
      <el-form :model="refundForm" :rules="refundRules" ref="refundFormRef" label-width="120px">
        <el-form-item label="Refund Amount" prop="amount">
          <el-input-number 
            v-model="refundForm.amount" 
            :precision="2" 
            :step="0.01" 
            :min="0" 
            :max="refundForm.maxAmount"
            style="width: 100%;"
          />
        </el-form-item>
        <el-form-item label="Refund Reason" prop="reason">
          <el-input v-model="refundForm.reason" type="textarea" rows="3" placeholder="Enter refund reason" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button size="default" style="width: 100px;" @click="refundDialogVisible = false">Cancel</el-button>
          <el-button size="default" style="width: 100px;" type="primary" @click="submitRefund">Confirm Refund</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  queryPaymentPageApi, 
  getPaymentDetailApi, 
  createPaymentApi, 
  updatePaymentApi, 
  deletePaymentApi,
  confirmPaymentApi,
  refundPaymentApi,
  cancelPaymentApi
} from '@/api/payment'

// Status variables
const loading = ref(false)
const paymentList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const viewDialogVisible = ref(false)
const confirmPaymentDialogVisible = ref(false)
const refundDialogVisible = ref(false)
const currentPayment = ref({})

// Query parameters
const queryParams = reactive({
  orderId: '',
  status: '',
  paymentMethod: '',
  dateRange: null,
  page: 1,
  size: 10
})

// Payment form
const paymentForm = ref({
  id: '',
  paymentMethod: '',
  transactionId: '',
  remark: ''
})

// Refund form
const refundForm = ref({
  id: '',
  amount: 0,
  maxAmount: 0,
  reason: ''
})

// Form validation rules
const paymentRules = {
  paymentMethod: [
    { required: true, message: 'Please select payment method', trigger: 'change' }
  ],
  transactionId: [
    { required: true, message: 'Please enter transaction ID', trigger: 'blur' }
  ]
}

const refundRules = {
  amount: [
    { required: true, message: 'Please enter refund amount', trigger: 'blur' }
  ],
  reason: [
    { required: true, message: 'Please enter refund reason', trigger: 'blur' }
  ]
}

const paymentFormRef = ref(null)
const refundFormRef = ref(null)

// Lifecycle hook
onMounted(() => {
  getPaymentList()
})

// Format amount
const formatAmount = (amount) => {
  return parseFloat(amount || 0).toFixed(2)
}

// Get payment list
const getPaymentList = async () => {
  loading.value = true
  try {
    // Prepare API parameters
    const params = {
      orderId: queryParams.orderId || null,
      status: queryParams.status || null,
      paymentMethod: queryParams.paymentMethod || null,
      page: currentPage.value,
      size: pageSize.value
    }
    
    // Process date range
    if (queryParams.dateRange && queryParams.dateRange.length === 2) {
      const [startDate, endDate] = queryParams.dateRange
      params.startDate = startDate ? formatDate(startDate) : null
      params.endDate = endDate ? formatDate(endDate) : null
    }
    
    const res = await queryPaymentPageApi(params)
    paymentList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('Failed to fetch payment list', error)
    ElMessage.error('Failed to fetch payment list')
    paymentList.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

// Format date
const formatDate = (date) => {
  if (!date) return ''
  if (typeof date === 'string') return date
  
  const d = new Date(date)
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

// Search
const handleSearch = () => {
  currentPage.value = 1
  getPaymentList()
}

// Reset
const handleReset = () => {
  queryParams.orderId = ''
  queryParams.status = ''
  queryParams.paymentMethod = ''
  queryParams.dateRange = null
  handleSearch()
}

// Change page size
const handleSizeChange = (size) => {
  pageSize.value = size
  getPaymentList()
}

// Change current page
const handleCurrentChange = (page) => {
  currentPage.value = page
  getPaymentList()
}

// View payment details
const handleView = (row) => {
  currentPayment.value = row
  viewDialogVisible.value = true
}

// Confirm payment
const handleConfirmPayment = (row) => {
  currentPayment.value = row
  paymentForm.value = {
    id: row.id,
    paymentMethod: row.paymentMethod || '',
    transactionId: '',
    remark: ''
  }
  confirmPaymentDialogVisible.value = true
}

// Submit confirmation
const submitConfirmPayment = () => {
  paymentFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    try {
      const params = {
        paymentMethod: paymentForm.value.paymentMethod,
        transactionId: paymentForm.value.transactionId
      }
      
      await confirmPaymentApi(paymentForm.value.id, params)
      
      ElMessage.success('Payment confirmed successfully')
      confirmPaymentDialogVisible.value = false
      getPaymentList()
      if (viewDialogVisible.value) {
        viewDialogVisible.value = false
      }
    } catch (error) {
      console.error('Failed to confirm payment', error)
      ElMessage.error('Operation failed: ' + (error.response?.data?.message || 'Unknown error'))
    }
  })
}

// Refund
const handleRefund = (row) => {
  currentPayment.value = row
  refundForm.value = {
    id: row.id,
    amount: row.amount,
    maxAmount: row.amount,
    reason: ''
  }
  refundDialogVisible.value = true
}

// Submit refund
const submitRefund = () => {
  refundFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    try {
      const params = {
        refundAmount: refundForm.value.amount,
        reason: refundForm.value.reason
      }
      
      await refundPaymentApi(refundForm.value.id, params)
      
      ElMessage.success('Refund processed successfully')
      refundDialogVisible.value = false
      getPaymentList()
      if (viewDialogVisible.value) {
        viewDialogVisible.value = false
      }
    } catch (error) {
      console.error('Refund failed', error)
      ElMessage.error('Operation failed: ' + (error.response?.data?.message || 'Unknown error'))
    }
  })
}

// Cancel payment
const handleCancel = (row) => {
  ElMessageBox.confirm('Are you sure you want to cancel this payment?', 'Warning', {
    confirmButtonText: 'Confirm',
    cancelButtonText: 'Cancel',
    type: 'warning'
  }).then(async () => {
    try {
      await cancelPaymentApi(row.id)
      
      ElMessage.success('Payment cancelled')
      getPaymentList()
      if (viewDialogVisible.value) {
        viewDialogVisible.value = false
      }
    } catch (error) {
      console.error('Failed to cancel payment', error)
      ElMessage.error('Operation failed: ' + (error.response?.data?.message || 'Unknown error'))
    }
  }).catch(() => {})
}
</script>

<style scoped>
.payment-container {
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

.button-column {
  display: flex;
  flex-direction: column;
  gap: 5px;
}
</style>