import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import en from 'element-plus/es/locale/lang/en'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

// Import base styles
import './assets/main.css'
// Import theme styles
import './assets/theme.css'

// Create app instance
const app = createApp(App)

// Register Pinia state management
const pinia = createPinia()
app.use(pinia)

// Register router
app.use(router)

// Register ElementPlus
app.use(ElementPlus, {locale: en})

// Register all ElementPlus icons
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

// Global error handling
app.config.errorHandler = (err, vm, info) => {
  console.error('Application error:', err)
  console.error('Error information:', info)
}

// Mount application
app.mount('#app')
