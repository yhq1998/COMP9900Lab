<script setup>
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus';
import { useRouter, useRoute } from 'vue-router'
import { getStorageItem, removeStorageItem } from '@/utils/helpers'

const router = useRouter()
const route = useRoute()

// 用户信息
const loginUser = ref(null)
const loginName = computed(() => loginUser.value?.name || 'User')

// 获取登录用户信息
onMounted(() => {
  const userInfo = getStorageItem('loginUser')
  if (userInfo) {
    loginUser.value = userInfo
  }
})

// 退出登录
const logout = () => {
  ElMessageBox.confirm('Are you sure to logout?', 'Notice', {
    confirmButtonText: 'Confirm',
    cancelButtonText: 'Cancel',
    type: 'warning'
  }).then(() => {
    ElMessage.success('Logout successfully')
    removeStorageItem('loginUser')
    router.push('/login')
  })
}
</script>

<template>
  <div class="common-layout">
    <el-container>
      <!-- Header 区域 -->
      <el-header class="header">
        <div class="header-left">
          <el-icon class="logo-icon"><TrendCharts /></el-icon>
          <span class="title">MiniBus Management System</span>
        </div>
        <div class="header-right">
          <el-dropdown trigger="click">
            <span class="user-dropdown">
              <el-avatar :size="32" src="https://picsum.photos/200" />
              <span class="username">{{ loginName }}</span>
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item>
                  <el-icon><User /></el-icon> Profile
                </el-dropdown-item>
                <el-dropdown-item>
                  <el-icon><EditPen /></el-icon> Reset Password
                </el-dropdown-item>
                <el-dropdown-item divided @click="logout">
                  <el-icon><SwitchButton /></el-icon> Logout
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      
      <el-container class="main-container">
        <!-- 左侧菜单 -->
        <el-aside width="240px" class="aside">
          <!-- 用户信息卡片 -->
          <div class="user-card">
            <el-avatar :size="64" src="https://picsum.photos/200" class="user-avatar" />
            <div class="user-info">
              <h3 class="user-name">{{ loginName }}</h3>
              <span class="user-role">Administrator</span>
            </div>
          </div>

          <!-- 导航菜单 -->
          <el-menu 
            router 
            :default-active="$route.path"
            class="sidebar-menu"
            :collapse="false">
            <!-- 首页菜单 -->
            <el-menu-item index="/dashboard">
              <el-icon><HomeFilled /></el-icon>
              <template #title>Dashboard</template>
            </el-menu-item>
            
            <!-- 账户管理菜单 -->
            <el-sub-menu index="/accounts">
              <template #title>
                <el-icon><User /></el-icon>
                <span>Account Management</span>
              </template>
              <el-menu-item index="/passengers">
                <el-icon><Avatar /></el-icon>
                <span>Passenger</span>
              </el-menu-item>
              <el-menu-item index="/drivers">
                <el-icon><UserFilled /></el-icon>
                <span>Driver</span>
              </el-menu-item>
              <el-menu-item index="/admins">
                <el-icon><Setting /></el-icon>
                <span>Admin</span>
              </el-menu-item>
            </el-sub-menu>
            
            <!-- 订单信息管理 -->
            <el-sub-menu index="/orders-management">
              <template #title>
                <el-icon><Tickets /></el-icon>
                <span>Order Management</span>
              </template>
              <el-menu-item index="/orders">
                <el-icon><Document /></el-icon>
                <span>Order</span>
              </el-menu-item>
            </el-sub-menu>

            <!-- 支付信息管理 -->
            <el-sub-menu index="/finance">
              <template #title>
                <el-icon><Money /></el-icon>
                <span>Finance Management</span>
              </template>
              <el-menu-item index="/advertisements">
                <el-icon><Promotion /></el-icon>
                <span>Advertisement</span>
              </el-menu-item>
              <el-menu-item index="/payments">
                <el-icon><CreditCard /></el-icon>
                <span>Payment</span>
              </el-menu-item>
            </el-sub-menu>
            
            <!-- 车辆管理 -->
            <el-sub-menu index="vehicle-management-submenu">
              <template #title>
                <el-icon><Van /></el-icon>
                <span>Vehicle Management</span>
              </template>
              <el-menu-item index="/vehicles">
                <el-icon><Truck /></el-icon>
                <span>Vehicles</span>
              </el-menu-item>
            </el-sub-menu>
          </el-menu>
        </el-aside>
        
        <!-- 主展示区域 -->
        <el-main class="main-content">
          <div class="content-wrapper">
            <router-view></router-view>
          </div>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<style scoped>
/* 整体布局 */
.common-layout {
  height: 100vh;
  overflow: hidden;
}

/* 头部样式 */
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  background: linear-gradient(to right, var(--primary-color), #36cfc9);
  box-shadow: var(--shadow-small);
  color: white;
  height: 64px;
}

.header-left {
  display: flex;
  align-items: center;
}

.logo-icon {
  font-size: 24px;
  margin-right: 12px;
}

.title {
  color: white;
  font-size: 20px;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-dropdown {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: var(--border-radius-medium);
  transition: background-color 0.3s;
}

.user-dropdown:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.username {
  margin: 0 8px;
  font-size: 14px;
}

/* 主容器 */
.main-container {
  height: calc(100vh - 64px);
}

/* 侧边栏样式 */
.aside {
  background-color: white;
  border-right: 1px solid var(--divider-color);
  box-shadow: var(--shadow-small);
  padding: 16px 0;
  overflow-y: auto;
  transition: width 0.3s;
}

/* 用户卡片 */
.user-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px;
  margin-bottom: 24px;
  border-bottom: 1px solid var(--divider-color);
}

.user-avatar {
  margin-bottom: 12px;
  box-shadow: var(--shadow-small);
}

.user-info {
  text-align: center;
}

.user-name {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 4px;
  color: var(--text-primary);
}

.user-role {
  font-size: 12px;
  color: var(--text-secondary);
}

/* 菜单样式 */
.sidebar-menu {
  border-right: none;
}

.sidebar-menu .el-menu-item,
.sidebar-menu .el-sub-menu__title {
  height: 50px;
  line-height: 50px;
  padding-left: 20px !important;
  margin: 4px 16px;
  border-radius: var(--border-radius-medium);
  transition: all 0.3s;
}

.sidebar-menu .el-menu-item:hover,
.sidebar-menu .el-sub-menu__title:hover {
  background-color: var(--primary-light);
}

.sidebar-menu .el-menu-item.is-active {
  background-color: var(--primary-light);
  color: var(--primary-color);
  font-weight: 500;
}

.sidebar-menu .el-menu-item [class^="el-icon"],
.sidebar-menu .el-sub-menu__title [class^="el-icon"] {
  margin-right: 12px;
  font-size: 18px;
  vertical-align: middle;
}

/* 主内容区域 */
.main-content {
  background-color: var(--background-light);
  padding: 20px;
  overflow-y: auto;
}

.content-wrapper {
  background-color: white;
  border-radius: var(--border-radius-large);
  box-shadow: var(--shadow-small);
  padding: 24px;
  min-height: calc(100% - 48px);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .aside {
    width: 64px !important;
  }
  
  .user-card {
    padding: 8px;
  }
  
  .user-info {
    display: none;
  }
}
</style>