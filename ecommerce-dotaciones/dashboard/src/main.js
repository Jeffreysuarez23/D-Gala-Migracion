import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'

// Initialize Theme
const storedState = localStorage.getItem('ecommerce_dashboard_state')
if (storedState) {
  try {
    const state = JSON.parse(storedState)
    if (state.theme) {
      document.documentElement.className = state.theme
    }
  } catch (e) {
    console.error('Failed to parse initial state theme', e)
  }
} else {
  document.documentElement.className = 'light'
}

const app = createApp(App)
app.use(router)
app.mount('#app')
