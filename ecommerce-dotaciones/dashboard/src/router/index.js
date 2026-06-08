import { createRouter, createWebHistory } from 'vue-router'
import Overview from '../views/Overview.vue'
import Products from '../views/Products.vue'
import Orders from '../views/Orders.vue'
import Dotaciones from '../views/Dotaciones.vue'
import Users from '../views/Users.vue'

const routes = [
  {
    path: '/',
    name: 'Overview',
    component: Overview
  },
  {
    path: '/products',
    name: 'Products',
    component: Products
  },
  {
    path: '/orders',
    name: 'Orders',
    component: Orders
  },
  {
    path: '/dotaciones',
    name: 'Dotaciones',
    component: Dotaciones
  },
  {
    path: '/users',
    name: 'Users',
    component: Users
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router
