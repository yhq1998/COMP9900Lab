import { createRouter, createWebHistory } from 'vue-router';
import routes from './routes';

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// 全局前置守卫
router.beforeEach((to, from, next) => {
  // 设置页面标题
  document.title = to.meta.title ? `${to.meta.title} - MiniBus Management` : 'MiniBus Management';
  
  // 登录验证
  const isLoggedIn = localStorage.getItem('loginUser');
  if (to.path !== '/login' && to.path !== '/register' && !isLoggedIn) {
    next('/login');
  } else {
    next();
  }
});

export default router;