<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'
import { User, Lock } from '@element-plus/icons-vue'
import { registerApi } from '@/api/login'

// 路由实例
const router = useRouter()

// 表单引用
const registerFormRef = ref(null)

// 加载状态
const loading = ref(false)

// 注册表单数据
const registerForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  fullName: '',
  email: '',
  phoneNumber: ''
})

// 表单验证规则
const registerRules = {
  username: [
    { required: true, message: 'Please enter username', trigger: 'blur' },
    { min: 3, max: 20, message: 'Username length should be 3-20 characters', trigger: 'blur' }
  ],
  password: [
    { required: true, message: 'Please enter password', trigger: 'blur' },
    { min: 6, max: 20, message: 'Password length should be 6-20 characters', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: 'Please confirm password', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== registerForm.password) {
          callback(new Error('Passwords do not match'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ],
  fullName: [
    { required: false, message: 'Please enter full name', trigger: 'blur' }
  ],
  email: [
    { required: false, message: 'Please enter email', trigger: 'blur' },
    { type: 'email', message: 'Please enter a valid email address', trigger: 'blur' }
  ],
  phoneNumber: [
    { required: false, message: 'Please enter phone number', trigger: 'blur' }
  ]
}

// 注册方法
const handleRegister = async () => {
  if (!registerFormRef.value) return

  try {
    // 表单验证
    await registerFormRef.value.validate()
    
    // 设置加载状态
    loading.value = true
    
    // 添加调试信息
    console.log('Preparing to call register API with parameters:', {
      username: registerForm.username,
      password: registerForm.password,
      fullName: registerForm.fullName,
      email: registerForm.email,
      phoneNumber: registerForm.phoneNumber
    })
    
    // 调用注册接口
    const res = await registerApi({
      username: registerForm.username,
      password: registerForm.password,
      fullName: registerForm.fullName,
      email: registerForm.email,
      phoneNumber: registerForm.phoneNumber
    })
    
    console.log('Register API response:', res)
    
    if (res.code === 1) {
      ElMessage.success('Registration successful, please login')
      router.push('/login')
    } else {
      ElMessage.error(res.msg || 'Registration failed, please try again')
    }
  } catch (error) {
    console.error('Error during registration:', error)
    if (error?.message) {
      ElMessage.error(error.message)
    } else {
      ElMessage.error('Registration failed, please check your input and try again')
    }
  } finally {
    loading.value = false
  }
}

// 返回登录页
const goToLogin = () => {
  router.push('/login')
}
</script>

<template>
  <div class="register-container">
    <div class="register-box">
      <div class="register-header">
        <h2 class="register-title">MiniBus Management System</h2>
        <p class="register-subtitle">User Registration</p>
      </div>
      
      <el-form
        ref="registerFormRef"
        :model="registerForm"
        :rules="registerRules"
        class="register-form"
        @keyup.enter="handleRegister"
      >
        <el-form-item prop="username">
          <el-input
            v-model="registerForm.username"
            placeholder="Username"
            :prefix-icon="User"
            clearable
            autocomplete="off"
          />
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="registerForm.password"
            type="password"
            placeholder="Password"
            :prefix-icon="Lock"
            show-password
            clearable
            autocomplete="off"
          />
        </el-form-item>
        
        <el-form-item prop="confirmPassword">
          <el-input
            v-model="registerForm.confirmPassword"
            type="password"
            placeholder="Confirm Password"
            :prefix-icon="Lock"
            show-password
            clearable
            autocomplete="off"
          />
        </el-form-item>
        
        <el-form-item prop="fullName">
          <el-input
            v-model="registerForm.fullName"
            placeholder="Full Name (Optional)"
            clearable
            autocomplete="off"
          />
        </el-form-item>
        
        <el-form-item prop="email">
          <el-input
            v-model="registerForm.email"
            placeholder="Email (Optional)"
            clearable
            autocomplete="off"
          />
        </el-form-item>
        
        <el-form-item prop="phoneNumber">
          <el-input
            v-model="registerForm.phoneNumber"
            placeholder="Phone Number (Optional)"
            clearable
            autocomplete="off"
          />
        </el-form-item>
        
        <el-form-item class="register-btn-container">
          <el-button
            type="primary"
            :loading="loading"
            class="register-button"
            @click="handleRegister"
          >
            {{ loading ? 'Registering...' : 'Register' }}
          </el-button>
        </el-form-item>
        
        <div class="login-link">
          Already have an account? <el-button type="text" @click="goToLogin">Login now</el-button>
        </div>
      </el-form>
    </div>
  </div>
</template>

<style scoped>
.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.register-box {
  width: 100%;
  max-width: 400px;
  padding: 40px;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
}

.register-header {
  text-align: center;
  margin-bottom: 30px;
}

.register-title {
  font-size: 24px;
  color: #333;
  margin-bottom: 10px;
  font-weight: 600;
}

.register-subtitle {
  font-size: 14px;
  color: #666;
}

.register-form {
  margin-top: 20px;
}

.register-button {
  width: 100%;
  padding: 12px 0;
  font-size: 16px;
}

.register-btn-container {
  margin-top: 30px;
}

.login-link {
  text-align: center;
  margin-top: 15px;
  font-size: 14px;
  color: #666;
}

:deep(.el-input__wrapper) {
  box-shadow: 0 0 0 1px #dcdfe6 inset;
}

:deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #c0c4cc inset;
}

:deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #409eff inset;
}
</style>