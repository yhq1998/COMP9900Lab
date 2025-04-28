<template>
  <div class="dashboard-container">
    <!-- 欢迎区域 -->
    <div class="welcome-section">
      <div class="welcome-content">
        <h1 class="dashboard-title">Welcome to MiniBus Management</h1>
        <p class="welcome-text">Hello, <span class="user-name">{{ userName }}</span>. Here's your system overview.</p>
      </div>
      <div class="date-display">
        <el-icon><Calendar /></el-icon>
        <span>{{ currentDate }}</span>
      </div>
    </div>
    
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stat-cards">
      <el-col :xs="24" :sm="12" :md="6" v-for="(stat, index) in statCards" :key="index">
        <div class="stat-card" :class="`stat-card-${index + 1}`">
          <div class="stat-icon">
            <el-icon><component :is="stat.icon" /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stat.value }}</div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
          <div class="stat-trend" :class="{ 'is-up': stat.trend > 0, 'is-down': stat.trend < 0 }">
            <el-icon v-if="stat.trend > 0"><ArrowUp /></el-icon>
            <el-icon v-else-if="stat.trend < 0"><ArrowDown /></el-icon>
            <span>{{ Math.abs(stat.trend) }}%</span>
          </div>
        </div>
      </el-col>
    </el-row>
    
    <!-- 快捷操作区域 -->
    <div class="quick-actions-section">
      <h2 class="section-title">Quick Actions</h2>
      <el-row :gutter="20" class="quick-actions">
        <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="(action, index) in quickActions" :key="index">
          <div class="action-card" @click="navigateTo(action.route)">
            <el-icon><component :is="action.icon" /></el-icon>
            <span>{{ action.label }}</span>
          </div>
        </el-col>
      </el-row>
    </div>
    
    <!-- 图表区域 - 已注释，不再显示 -->
    <!-- <el-row :gutter="20" class="chart-section">
      <el-col :xs="24" :lg="16">
        <div class="chart-card">
          <div class="chart-header">
            <h3>Monthly Orders</h3>
            <el-radio-group v-model="orderChartPeriod" size="small">
              <el-radio-button label="week">Week</el-radio-button>
              <el-radio-button label="month">Month</el-radio-button>
              <el-radio-button label="year">Year</el-radio-button>
            </el-radio-group>
          </div>
          <div class="chart-placeholder" ref="orderChartRef">
            <div class="chart-loading">
              <el-icon class="is-loading"><Loading /></el-icon>
              <span>Loading chart data...</span>
            </div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :lg="8">
        <div class="chart-card">
          <div class="chart-header">
            <h3>Revenue Distribution</h3>
          </div>
          <div class="chart-placeholder pie-chart-placeholder" ref="pieChartRef">
            <div class="chart-loading">
              <el-icon class="is-loading"><Loading /></el-icon>
              <span>Loading chart data...</span>
            </div>
          </div>
        </div>
      </el-col>
    </el-row> -->
    
    <!-- 最近活动 -->
    <div class="recent-activity-section">
      <h2 class="section-title">Recent Activities</h2>
      <div class="activity-timeline">
        <div class="timeline-item" v-for="(activity, index) in recentActivities" :key="index">
          <div class="timeline-icon" :class="`timeline-icon-${activity.type}`">
            <el-icon><component :is="activity.icon" /></el-icon>
          </div>
          <div class="timeline-content">
            <div class="timeline-title">{{ activity.title }}</div>
            <div class="timeline-desc">{{ activity.description }}</div>
            <div class="timeline-time">{{ activity.time }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

// 用户名称
const userName = ref('Admin')

// 当前日期
const currentDate = computed(() => {
  const now = new Date()
  return now.toLocaleDateString('en-US', { 
    weekday: 'long', 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  })
})

// 统计卡片数据
const statCards = ref([
  { label: 'Total Orders', value: '2,851', icon: 'Tickets', trend: 12.5 },
  { label: 'Total Revenue', value: '$9,271', icon: 'Money', trend: 8.2 },
  { label: 'Active Drivers', value: '152', icon: 'User', trend: -2.4 },
  { label: 'Passengers', value: '3,427', icon: 'Avatar', trend: 5.7 }
])

// 快捷操作
const quickActions = ref([
  { label: 'New Order', icon: 'Plus', route: '/orders' },
  { label: 'Manage Passengers', icon: 'Avatar', route: '/passengers' },
  { label: 'Manage Drivers', icon: 'User', route: '/drivers' },
  { label: 'View Payments', icon: 'CreditCard', route: '/payments' },
  { label: 'Data Analysis', icon: 'DataAnalysis', route: '/dashboard' },
  { label: 'Settings', icon: 'Setting', route: '/admins' }
])

// 图表周期选择 - 虽然已经不再使用，但为避免引用错误保留变量
const orderChartPeriod = ref('month')

// 最近活动
const recentActivities = ref([
  {
    title: 'New order created',
    description: 'Order #38291 was created by John Doe',
    time: '10 minutes ago',
    type: 'success',
    icon: 'Tickets'
  },
  {
    title: 'Payment received',
    description: 'Payment of $58.50 was received for order #38290',
    time: '1 hour ago',
    type: 'primary',
    icon: 'CreditCard'
  },
  {
    title: 'New driver registered',
    description: 'Michael Brown registered as a new driver',
    time: '3 hours ago',
    type: 'warning',
    icon: 'User'
  },
  {
    title: 'System update',
    description: 'System was updated to version 2.4.0',
    time: '1 day ago',
    type: 'info',
    icon: 'Refresh'
  }
])

// 图表引用 - 虽然已经不再使用，但为避免引用错误保留变量
const orderChartRef = ref(null)
const pieChartRef = ref(null)

// 导航到指定路由
const navigateTo = (route) => {
  router.push(route)
}

// 模拟加载图表数据
onMounted(() => {
  // 这里可以添加实际的图表初始化代码
  // 例如使用ECharts等图表库
  
  // 获取登录用户名
  const loginUser = JSON.parse(localStorage.getItem('loginUser'))
  if (loginUser && loginUser.name) {
    userName.value = loginUser.name
  }
})
</script>

<style scoped>
/* 主容器 */
.dashboard-container {
  padding: 24px;
  min-height: 100%;
}

/* 欢迎区域 */
.welcome-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  background: linear-gradient(to right, var(--primary-color), #36cfc9);
  border-radius: var(--border-radius-large);
  padding: 24px;
  color: white;
  box-shadow: var(--shadow-small);
}

.dashboard-title {
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 8px;
}

.welcome-text {
  font-size: 16px;
  opacity: 0.9;
}

.user-name {
  font-weight: 600;
}

.date-display {
  display: flex;
  align-items: center;
  background-color: rgba(255, 255, 255, 0.2);
  padding: 8px 16px;
  border-radius: var(--border-radius-medium);
  font-size: 14px;
}

.date-display .el-icon {
  margin-right: 8px;
}

/* 统计卡片 */
.stat-cards {
  margin-bottom: 24px;
}

.stat-card {
  background-color: white;
  border-radius: var(--border-radius-medium);
  padding: 20px;
  box-shadow: var(--shadow-small);
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  position: relative;
  overflow: hidden;
  transition: transform 0.3s, box-shadow 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: var(--shadow-medium);
}

.stat-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 6px;
  height: 100%;
  background-color: var(--primary-color);
}

.stat-card-1::before { background-color: var(--primary-color); }
.stat-card-2::before { background-color: var(--success-color); }
.stat-card-3::before { background-color: var(--warning-color); }
.stat-card-4::before { background-color: var(--error-color); }

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  background-color: var(--primary-light);
  color: var(--primary-color);
}

.stat-card-1 .stat-icon { background-color: var(--primary-light); color: var(--primary-color); }
.stat-card-2 .stat-icon { background-color: rgba(82, 196, 26, 0.1); color: var(--success-color); }
.stat-card-3 .stat-icon { background-color: rgba(250, 173, 20, 0.1); color: var(--warning-color); }
.stat-card-4 .stat-icon { background-color: rgba(245, 34, 45, 0.1); color: var(--error-color); }

.stat-icon .el-icon {
  font-size: 24px;
}

.stat-content {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 4px;
}

.stat-label {
  font-size: 14px;
  color: var(--text-secondary);
}

.stat-trend {
  font-size: 14px;
  display: flex;
  align-items: center;
}

.stat-trend.is-up {
  color: var(--success-color);
}

.stat-trend.is-down {
  color: var(--error-color);
}

.stat-trend .el-icon {
  margin-right: 4px;
}

/* 快捷操作区域 */
.section-title {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 16px;
  color: var(--text-primary);
}

.quick-actions-section {
  margin-bottom: 24px;
}

.action-card {
  background-color: white;
  border-radius: var(--border-radius-medium);
  padding: 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  box-shadow: var(--shadow-small);
  cursor: pointer;
  transition: all 0.3s;
  margin-bottom: 20px;
  height: 120px;
}

.action-card:hover {
  transform: translateY(-5px);
  box-shadow: var(--shadow-medium);
  background-color: var(--primary-color);
  color: white;
}

.action-card .el-icon {
  font-size: 32px;
  margin-bottom: 12px;
}

/* 图表区域 */
.chart-section {
  margin-bottom: 24px;
}

.chart-card {
  background-color: white;
  border-radius: var(--border-radius-medium);
  padding: 20px;
  box-shadow: var(--shadow-small);
  margin-bottom: 20px;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.chart-header h3 {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0;
}

.chart-placeholder {
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--background-lighter);
  border-radius: var(--border-radius-medium);
}

.pie-chart-placeholder {
  height: 300px;
}

.chart-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  color: var(--text-secondary);
}

.chart-loading .el-icon {
  font-size: 24px;
  margin-bottom: 8px;
}

/* 最近活动 */
.recent-activity-section {
  margin-bottom: 24px;
}

.activity-timeline {
  background-color: white;
  border-radius: var(--border-radius-medium);
  padding: 20px;
  box-shadow: var(--shadow-small);
}

.timeline-item {
  display: flex;
  padding: 16px 0;
  border-bottom: 1px solid var(--divider-color);
}

.timeline-item:last-child {
  border-bottom: none;
}

.timeline-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  flex-shrink: 0;
}

.timeline-icon-success { background-color: rgba(82, 196, 26, 0.1); color: var(--success-color); }
.timeline-icon-primary { background-color: var(--primary-light); color: var(--primary-color); }
.timeline-icon-warning { background-color: rgba(250, 173, 20, 0.1); color: var(--warning-color); }
.timeline-icon-info { background-color: rgba(24, 144, 255, 0.1); color: var(--info-color); }

.timeline-content {
  flex: 1;
}

.timeline-title {
  font-weight: 600;
  margin-bottom: 4px;
  color: var(--text-primary);
}

.timeline-desc {
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 4px;
}

.timeline-time {
  font-size: 12px;
  color: var(--text-disabled);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .welcome-section {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .date-display {
    margin-top: 16px;
  }
  
  .chart-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .chart-header .el-radio-group {
    margin-top: 8px;
  }
}
</style>