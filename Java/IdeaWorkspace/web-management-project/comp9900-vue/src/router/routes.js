/**
 * 路由配置文件
 * 集中管理所有路由，避免路由冲突
 */

// 布局组件
import Layout from '@/views/layout/index.vue';

// 页面组件
import Index from '@/views/dashboard/index.vue';
import Login from '@/views/login/index.vue';
import OrderManagement from '@/views/orders/index.vue';
import PassengerManagement from '@/views/accounts/passengers/index.vue';
import DriverManagement from '@/views/accounts/drivers/index.vue';
import AdminManagement from '@/views/accounts/admins/index.vue';
import PaymentManagement from '@/views/finance/payments/index.vue';
import DispatchManagement from '@/views/dispatch/index.vue';
import VehicleManagement from '@/views/vehicles/index.vue';
import AdvertisementManagement from '@/views/finance/advertisements/index.vue';

/**
 * 路由配置
 * 使用统一的路由结构，避免重复和冲突
 */
const routes = [
  { 
    path: '/', 
    name: 'Login',
    component: Login,
    meta: { title: 'Login' }
  },
  { 
    path: '/admin', 
    component: Layout,
    redirect: '/admin/dashboard',
    children: [
      { 
        path: 'dashboard', 
        name: 'Dashboard',
        component: Index,
        meta: { title: 'Dashboard', icon: 'HomeFilled' }
      },
      { 
        path: 'passengers', 
        name: 'PassengerManagement',
        component: PassengerManagement,
        meta: { title: 'Passenger Management', icon: 'Avatar' }
      },
      { 
        path: 'drivers', 
        name: 'DriverManagement',
        component: DriverManagement,
        meta: { title: 'Driver Management', icon: 'UserFilled' }
      },
      { 
        path: 'dispatch', 
        name: 'DispatchManagement',
        component: DispatchManagement,
        meta: { title: 'Dispatch Optimization', icon: 'Van' }
      },
      {
        path: 'vehicles',
        name: 'VehicleManagement',
        component: VehicleManagement,
        meta: { title: 'Vehicle Management', icon: 'Truck' }
      },
      { 
        path: 'admins', 
        name: 'AdminManagement',
        component: AdminManagement,
        meta: { title: 'Administrator', icon: 'Setting' }
      },
      { 
        path: 'orders', 
        name: 'OrderManagement',
        component: OrderManagement,
        meta: { title: 'Order Management', icon: 'Document' }
      },
      { 
        path: 'payments', 
        name: 'PaymentManagement',
        component: PaymentManagement,
        meta: { title: 'Payment Management', icon: 'CreditCard' }
      },
      { 
        path: 'advertisements', 
        name: 'AdvertisementManagement',
        component: AdvertisementManagement,
        meta: { title: 'Advertisement Management', icon: 'Promotion' }
      }
    ]
  },
  { 
    path: '/login', 
    name: 'Login',
    component: Login,
    meta: { title: 'Login' }
  },
  { 
    path: '/register', 
    name: 'Register',
    component: () => import('@/views/register/index.vue'),
    meta: { title: 'Register' }
  },
  // 404路由
  { 
    path: '/:pathMatch(.*)*', 
    redirect: '/' 
  }
];

export default routes;