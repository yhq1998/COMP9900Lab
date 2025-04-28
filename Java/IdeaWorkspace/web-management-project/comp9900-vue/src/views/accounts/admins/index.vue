<template>
  <div class="admin-container">
    <div class="search-box">
      <el-form :inline="true" :model="searchForm" class="demo-form-inline">
        <el-form-item label="Username">
          <el-input v-model="searchForm.username" placeholder="Please enter admin username" clearable></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">Search</el-button>
          <el-button type="success" @click="handleAdd">Add</el-button>
        </el-form-item>
      </el-form>
    </div>

    <el-table :data="tableData" style="width: 100%" border>
      <el-table-column prop="id" label="ID" width="80"></el-table-column>
      <el-table-column prop="username" label="Username" width="120"></el-table-column>
      <el-table-column prop="name" label="Name" width="120"></el-table-column>
      <el-table-column prop="email" label="Email" width="180"></el-table-column>
      <el-table-column prop="phone" label="Phone" width="120"></el-table-column>
      <el-table-column prop="role" label="Role" width="100"></el-table-column>
      <el-table-column prop="createTime" label="Create Time" width="180"></el-table-column>
      <el-table-column label="Operation" width="180">
        <template #default="scope">
          <el-button size="small" @click="handleEdit(scope.row)">Edit</el-button>
          <el-button size="small" type="danger" @click="handleDelete(scope.row)">Delete</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="currentPage"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="total"
    >
    </el-pagination>

    <!-- Add/Edit Dialog -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="Username" prop="username">
          <el-input v-model="form.username" placeholder="Please enter username"></el-input>
        </el-form-item>
        <el-form-item label="Password" prop="password" v-if="!form.id">
          <el-input v-model="form.password" type="password" placeholder="Please enter password"></el-input>
        </el-form-item>
        <el-form-item label="Name" prop="name">
          <el-input v-model="form.name" placeholder="Please enter name"></el-input>
        </el-form-item>
        <el-form-item label="Email" prop="email">
          <el-input v-model="form.email" placeholder="Please enter email"></el-input>
        </el-form-item>
        <el-form-item label="Phone" prop="phone">
          <el-input v-model="form.phone" placeholder="Please enter phone number"></el-input>
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

<script>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { queryAdminPageApi, addAdminApi, queryAdminInfoApi, updateAdminApi, deleteAdminApi } from '@/api/admin'

export default {
  name: 'AdminManagement',
  setup() {
    // Search form
    const searchForm = reactive({
      username: ''
    })

    // Table data
    const tableData = ref([])
    const currentPage = ref(1)
    const pageSize = ref(10)
    const total = ref(0)

    // Dialog
    const dialogVisible = ref(false)
    const dialogTitle = ref('')
    const formRef = ref(null)
    const form = reactive({
      id: null,
      username: '',
      password: '',
      name: '',
      email: '',
      phone: '',
      role: 'ADMIN'
    })

    // Form validation rules
    const rules = {
      username: [
        { required: true, message: 'Please enter username', trigger: 'blur' },
        { min: 3, max: 20, message: 'Length should be between 3 and 20 characters', trigger: 'blur' }
      ],
      password: [
        { required: true, message: 'Please enter password', trigger: 'blur' },
        { min: 6, max: 20, message: 'Length should be between 6 and 20 characters', trigger: 'blur' }
      ],
      name: [
        { required: true, message: 'Please enter name', trigger: 'blur' }
      ],
      email: [
        { required: true, message: 'Please enter email', trigger: 'blur' },
        { type: 'email', message: 'Please enter a valid email address', trigger: 'blur' }
      ],
      phone: [
        { required: true, message: 'Please enter phone number', trigger: 'blur' }
      ]
    }

    // Get admin list
    const getAdminList = async () => {
      try {
        const res = await queryAdminPageApi(searchForm.username, currentPage.value, pageSize.value)
        console.log('Back-end returned raw data:', res)
        
        if (res.code === 1) {  // Note: Back-end success status code is 1, not 200
          // Ensure data and rows exist, compatible with various back-end return structures
          if (res.data && res.data.rows) {
            console.log('Found standard paging data structure:', res.data.rows)
            tableData.value = res.data.rows
            total.value = res.data.total
          } else if (Array.isArray(res.data)) {
            // If back-end directly returns an array
            console.log('Found array data:', res.data)
            tableData.value = res.data
            total.value = res.data.length
          } else {
            // Other cases, try to use data directly
            console.log('Using other data structure:', res.data)
            tableData.value = [res.data]
            total.value = 1
          }
          
          // Field mapping processing
          tableData.value = tableData.value.map(item => {
            return {
              id: item.id,
              username: item.username,
              name: item.fullName || item.name,  // Back-end may use fullName instead of name
              email: item.email,
              phone: item.phoneNumber || item.phone, // Back-end may use phoneNumber instead of phone
              role: item.role,
              createTime: item.createdAt || item.createTime // Back-end may use createdAt instead of createTime
            }
          })
          
          console.log('Processed data to display:', tableData.value)
        } else {
          console.error('Interface returned error:', res)
          ElMessage.error(res.msg || 'Failed to get admin list')
          tableData.value = []
          total.value = 0
        }
      } catch (error) {
        console.error('Error getting admin list:', error)
        ElMessage.error('Failed to get admin list')
        tableData.value = []
        total.value = 0
      }
    }

    // Search
    const handleSearch = () => {
      currentPage.value = 1
      getAdminList()
    }

    // Add admin
    const handleAdd = () => {
      resetForm()
      dialogTitle.value = 'Add Admin'
      dialogVisible.value = true
    }

    // Edit admin
    const handleEdit = async (row) => {
      resetForm()
      dialogTitle.value = 'Edit Admin'
      try {
        const res = await queryAdminInfoApi(row.id)
        if (res.code === 200) {
          Object.assign(form, res.data)
          dialogVisible.value = true
        } else {
          ElMessage.error(res.msg || 'Failed to get admin info')
        }
      } catch (error) {
        console.error('Error getting admin info:', error)
        ElMessage.error('Failed to get admin info')
      }
    }

    // Delete admin
    const handleDelete = (row) => {
      ElMessageBox.confirm('Are you sure you want to delete this admin?', 'Warning', {
        confirmButtonText: 'Confirm',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deleteAdminApi(row.id)
          if (res.code === 200) {
            ElMessage.success('Delete successful')
            getAdminList()
          } else {
            ElMessage.error(res.msg || 'Delete failed')
          }
        } catch (error) {
          console.error('Error deleting admin:', error)
          ElMessage.error('Delete failed')
        }
      }).catch(() => {
        // Cancel delete
      })
    }

    // Submit form
    const submitForm = async () => {
      if (!formRef.value) return
      
      formRef.value.validate(async (valid) => {
        if (valid) {
          try {
            let res
            if (form.id) {
              // Update
              res = await updateAdminApi(form)
            } else {
              // Add
              res = await addAdminApi(form)
            }
            
            if (res.code === 200) {
              ElMessage.success(form.id ? 'Update successful' : 'Add successful')
              dialogVisible.value = false
              getAdminList()
            } else {
              ElMessage.error(res.msg || (form.id ? 'Update failed' : 'Add failed'))
            }
          } catch (error) {
            console.error(form.id ? 'Error updating admin:' : 'Error adding admin:', error)
            ElMessage.error(form.id ? 'Update failed' : 'Add failed')
          }
        }
      })
    }

    // Reset form
    const resetForm = () => {
      if (formRef.value) {
        formRef.value.resetFields()
      }
      Object.assign(form, {
        id: null,
        username: '',
        password: '',
        name: '',
        email: '',
        phone: '',
        role: 'ADMIN'
      })
    }

    // Pagination
    const handleSizeChange = (val) => {
      pageSize.value = val
      getAdminList()
    }

    const handleCurrentChange = (val) => {
      currentPage.value = val
      getAdminList()
    }

    onMounted(() => {
      getAdminList()
    })

    return {
      searchForm,
      tableData,
      currentPage,
      pageSize,
      total,
      dialogVisible,
      dialogTitle,
      formRef,
      form,
      rules,
      handleSearch,
      handleAdd,
      handleEdit,
      handleDelete,
      submitForm,
      handleSizeChange,
      handleCurrentChange
    }
  }
}
</script>

<style scoped>
.admin-container {
  padding: 20px;
}

.search-box {
  margin-bottom: 20px;
}

.el-pagination {
  margin-top: 20px;
  text-align: right;
}
</style>