<template>
  <div class="orders-view">
    
    <!-- PAGE HEADER -->
    <header class="page-header">
      <div class="page-header__title-wrap">
        <p>/ Registro de Operaciones</p>
        <h1 class="title-serif">Gestión de Pedidos</h1>
      </div>
      <div class="page-header__actions">
        <span class="badge badge--info">{{ activeOrdersCount }} pedidos pendientes</span>
      </div>
    </header>

    <!-- STATUS TABS NAVIGATION -->
    <section class="tabs-nav">
      <button 
        v-for="tab in statusTabs" 
        :key="tab.value" 
        :class="['tab-item', { 'tab-item--active': activeTab === tab.value }]"
        @click="activeTab = tab.value"
      >
        {{ tab.label }}
        <span class="tab-item__badge" :class="`badge--${tab.badgeColor}`">
          {{ getOrdersCountByStatus(tab.value) }}
        </span>
      </button>
    </section>

    <!-- ORDERS TABLE -->
    <section class="card table-card">
      <div class="table-wrap">
        <table class="table-custom">
          <thead>
            <tr>
              <th>Código Pedido</th>
              <th>Fecha</th>
              <th>Cliente</th>
              <th>Precio Tipo</th>
              <th>Items</th>
              <th>Total</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in filteredOrders" :key="order.id">
              <td style="font-weight: 700;">{{ order.numero }}</td>
              <td>{{ formatDateString(order.creado_en) }}</td>
              <td>{{ getUserName(order.usuario_id) }}</td>
              <td>
                <span class="badge badge--info">{{ order.tipo_precio }}</span>
              </td>
              <td>{{ getOrderItemsCount(order.id) }} uds</td>
              <td style="font-weight: 600;">${{ formatMoney(order.total) }}</td>
              <td>
                <span :class="['badge', getStatusBadgeClass(order.estado)]">
                  {{ order.estado }}
                </span>
              </td>
              <td>
                <button class="btn btn--secondary btn--sm" style="padding: 6px 14px;" @click="openOrderDetail(order)">
                  Detalle / Editar
                </button>
              </td>
            </tr>
            <tr v-if="filteredOrders.length === 0">
              <td colspan="8" class="text-center text-muted" style="padding: 40px 0;">
                No se encontraron pedidos en esta sección.
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- DETAIL & ACTIONS DRAWER -->
    <div class="drawer-backdrop" :class="{ active: showDrawer }" @click="showDrawer = false"></div>
    <div class="drawer" :class="{ active: showDrawer }">
      <div class="drawer__header" v-if="selectedOrder">
        <div>
          <span class="badge badge--info" style="margin-bottom: 6px;">{{ selectedOrder.numero }}</span>
          <h2 class="title-serif">Modificar Pedido</h2>
        </div>
        <button class="drawer__close" @click="showDrawer = false">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="18" y1="6" x2="6" y2="18"></line>
            <line x1="6" y1="6" x2="18" y2="18"></line>
          </svg>
        </button>
      </div>

      <div class="drawer__body" v-if="selectedOrder">
        
        <!-- STATUS UPDATE AREA -->
        <div class="drawer-section status-update-box">
          <h3>Cambiar Estado del Pedido</h3>
          <div class="form-group" style="margin-bottom: 0;">
            <select class="select-input" :value="selectedOrder.estado" @change="onStatusChange">
              <option value="pendiente">Pendiente (Por confirmar)</option>
              <option value="procesando">Procesando (En fabricación)</option>
              <option value="enviado">Enviado (Despachado)</option>
              <option value="entregado">Entregado (Completado)</option>
              <option value="devuelta">Devuelta (Devolución)</option>
              <option value="cancelada">Cancelada</option>
            </select>
          </div>
        </div>

        <!-- SHIPPING DISPATCH DETAIL PANEL (Visible when order is 'enviado' or updated to 'enviado') -->
        <div class="drawer-section shipping-dispatch-box" v-if="shippingFormVisible">
          <h3>Detalle de Despacho / Guía</h3>
          
          <div class="form-group">
            <label>Transportadora *</label>
            <input type="text" class="input-text" placeholder="Ej: Servientrega, Envía, Coordinadora" v-model="shippingForm.transportadora" />
          </div>

          <div class="form-group">
            <label>Número de Guía (Rastreo) *</label>
            <input type="text" class="input-text" placeholder="Ej: GUIA1234567" v-model="shippingForm.guia" />
          </div>

          <button type="button" class="btn btn--primary btn--sm" @click="saveShippingDetails">
            Confirmar Despacho
          </button>
        </div>

        <!-- CLIENT INFO -->
        <div class="drawer-section">
          <h3>Detalles del Cliente</h3>
          <div class="info-grid">
            <div class="info-row">
              <span class="info-label">Nombre:</span>
              <span class="info-value">{{ getOrderUser(selectedOrder.usuario_id)?.nombre }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Email:</span>
              <span class="info-value">{{ getOrderUser(selectedOrder.usuario_id)?.email }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Teléfono:</span>
              <span class="info-value">{{ getOrderUser(selectedOrder.usuario_id)?.telefono || 'No registra' }}</span>
            </div>
            <div class="info-row" v-if="selectedOrder.notas_cliente">
              <span class="info-label">Notas del Cliente:</span>
              <span class="info-value text-italic">"{{ selectedOrder.notas_cliente }}"</span>
            </div>
          </div>
        </div>

        <!-- LINE ITEMS -->
        <div class="drawer-section">
          <h3>Artículos del Pedido</h3>
          <div class="items-list">
            <div v-for="item in getOrderItems(selectedOrder.id)" :key="item.id" class="item-row">
              <div class="item-details">
                <span class="item-name">{{ getVariantName(item.variante_id) }}</span>
                <span class="item-meta">SKU: {{ getVariantSku(item.variante_id) }} | Cantidad: {{ item.cantidad }}</span>
              </div>
              <span class="item-price">${{ formatMoney(item.total_linea) }}</span>
            </div>
          </div>
        </div>

        <!-- TOTALS -->
        <div class="drawer-section finance-summary">
          <div class="finance-row">
            <span>Subtotal</span>
            <span>${{ formatMoney(selectedOrder.subtotal) }}</span>
          </div>
          <div class="finance-row" v-if="selectedOrder.descuento > 0">
            <span>Descuento</span>
            <span class="text-success">-${{ formatMoney(selectedOrder.descuento) }}</span>
          </div>
          <div class="finance-row">
            <span>Envío</span>
            <span>${{ formatMoney(selectedOrder.envio_costo) }}</span>
          </div>
          <div class="finance-row finance-row--total">
            <span>Total Facturado</span>
            <span>${{ formatMoney(selectedOrder.total) }}</span>
          </div>
        </div>

        <!-- SHIPMENT PREVIEW -->
        <div class="drawer-section" v-if="getOrderShipment(selectedOrder.id) && !shippingFormVisible">
          <h3>Estado del Envío</h3>
          <div class="info-grid">
            <div class="info-row">
              <span class="info-label">Transportadora:</span>
              <span class="info-value">{{ getOrderShipment(selectedOrder.id).transportadora }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Nº Guía:</span>
              <span class="info-value font-mono">{{ getOrderShipment(selectedOrder.id).guia }}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Estado Envío:</span>
              <span class="info-value text-capitalize">{{ getOrderShipment(selectedOrder.id).estado }}</span>
            </div>
            <div class="info-row" v-if="getOrderShipment(selectedOrder.id).entregado_en">
              <span class="info-label">Entregado el:</span>
              <span class="info-value">{{ getOrderShipment(selectedOrder.id).entregado_en }}</span>
            </div>
          </div>
        </div>

      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed, reactive } from 'vue'
import { state, actions } from '../store/state.js'

// Status Tab config
const statusTabs = [
  { label: 'Todos', value: 'all', badgeColor: 'info' },
  { label: 'Pendientes', value: 'pendiente', badgeColor: 'pending' },
  { label: 'Fabricando', value: 'procesando', badgeColor: 'info' },
  { label: 'Enviados', value: 'enviado', badgeColor: 'success' },
  { label: 'Entregados', value: 'entregado', badgeColor: 'success' },
  { label: 'Devueltos', value: 'devuelta', badgeColor: 'danger' }
]

const activeTab = ref('all')

// Statistics computation
const activeOrdersCount = computed(() => {
  return state.ordenes.filter(o => o.estado === 'pendiente' || o.estado === 'procesando').length
})

const getOrdersCountByStatus = (status) => {
  if (status === 'all') return state.ordenes.length
  return state.ordenes.filter(o => o.estado === status).length
}

// Order filter
const filteredOrders = computed(() => {
  if (activeTab.value === 'all') {
    return [...state.ordenes].sort((a, b) => b.id - a.id)
  }
  return [...state.ordenes]
    .filter(o => o.estado === activeTab.value)
    .sort((a, b) => b.id - a.id)
})

// Drawer management
const showDrawer = ref(false)
const selectedOrder = ref(null)

const shippingFormVisible = ref(false)
const shippingForm = reactive({
  transportadora: '',
  guia: ''
})

const openOrderDetail = (order) => {
  selectedOrder.value = order
  shippingFormVisible.value = order.estado === 'enviado' && !getOrderShipment(order.id)
  
  const shipment = getOrderShipment(order.id)
  if (shipment) {
    shippingForm.transportadora = shipment.transportadora
    shippingForm.guia = shipment.guia
  } else {
    shippingForm.transportadora = ''
    shippingForm.guia = ''
  }
  
  showDrawer.value = true
}

const onStatusChange = (event) => {
  const newStatus = event.target.value
  actions.updateOrderStatus(selectedOrder.value.id, newStatus)
  
  if (newStatus === 'enviado') {
    shippingFormVisible.value = true
  } else {
    shippingFormVisible.value = false
    // Update existing shipment status if it exists
    const shipment = getOrderShipment(selectedOrder.value.id)
    if (shipment) {
      actions.updateOrderShipping(selectedOrder.value.id, {
        transportadora: shipment.transportadora,
        guia: shipment.guia,
        estado: newStatus === 'entregado' ? 'entregado' : 'enviado'
      })
    }
  }
}

const saveShippingDetails = () => {
  if (!shippingForm.transportadora || !shippingForm.guia) {
    alert('Ingresa la transportadora y la guía de envío')
    return
  }
  actions.updateOrderShipping(selectedOrder.value.id, {
    transportadora: shippingForm.transportadora,
    guia: shippingForm.guia,
    estado: 'enviado'
  })
  shippingFormVisible.value = false
  alert('Guía de despacho registrada exitosamente')
}

// Helpers
const formatMoney = (amount) => {
  return Number(amount).toLocaleString('es-CO', { minimumFractionDigits: 0, maximumFractionDigits: 0 })
}

const formatDateString = (dateStr) => {
  const date = new Date(dateStr)
  return date.toLocaleDateString('es-ES', { year: 'numeric', month: 'short', day: 'numeric' })
}

const getUserName = (userId) => {
  const user = state.usuarios.find(u => u.id === userId)
  return user ? user.nombre : `Usuario #${userId}`
}

const getOrderUser = (userId) => {
  return state.usuarios.find(u => u.id === userId)
}

const getOrderItemsCount = (orderId) => {
  return state.orden_items
    .filter(oi => oi.orden_id === orderId)
    .reduce((sum, oi) => sum + oi.cantidad, 0)
}

const getStatusBadgeClass = (status) => {
  switch (status) {
    case 'entregado': return 'badge--success'
    case 'pendiente': return 'badge--pending'
    case 'procesando': return 'badge--info'
    case 'enviado': return 'badge--success'
    case 'devuelta': return 'badge--danger'
    case 'cancelada': return 'badge--danger'
    default: return ''
  }
}

const getOrderItems = (orderId) => {
  return state.orden_items.filter(oi => oi.orden_id === orderId)
}

const getVariantName = (variantId) => {
  const variant = state.variantes_producto.find(v => v.id === variantId)
  if (!variant) return 'Producto Desconocido'
  const product = state.productos.find(p => p.id === variant.producto_id)
  return product ? `${product.nombre} (${variant.color} / Talla ${variant.talla})` : 'Producto Desconocido'
}

const getVariantSku = (variantId) => {
  const variant = state.variantes_producto.find(v => v.id === variantId)
  return variant ? variant.sku : 'N/A'
}

const getOrderShipment = (orderId) => {
  return state.envios.find(e => e.orden_id === orderId)
}
</script>

<style scoped>
/* Tabs Navigation styling */
.tabs-nav {
  display: flex;
  gap: 8px;
  border-bottom: 1px solid var(--color-border);
  padding-bottom: 8px;
  overflow-x: auto;
}

.tab-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 18px;
  background: transparent;
  border: none;
  border-bottom: 2px solid transparent;
  color: var(--text-secondary);
  font-family: var(--font-sans);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
  transition: var(--transition-smooth);
}

.tab-item:hover {
  color: var(--text-primary);
}

.tab-item--active {
  border-bottom-color: var(--color-accent);
  color: var(--text-primary);
}

.tab-item__badge {
  font-size: 9px;
  font-weight: 700;
  padding: 1px 6px;
  border-radius: var(--radius-full);
}

/* Status Change elements */
.status-update-box {
  background-color: var(--bg-sidebar);
  border: 1px solid var(--color-border);
  padding: 18px;
  border-radius: var(--radius-md);
}

.status-update-box h3 {
  margin-bottom: 12px;
}

.shipping-dispatch-box {
  background-color: var(--color-accent-light);
  border: 1px dashed var(--color-accent);
  padding: 18px;
  border-radius: var(--radius-md);
}

.shipping-dispatch-box h3 {
  margin-bottom: 14px;
}

.shipping-dispatch-box .btn {
  margin-top: 10px;
}

/* Detail Drawer row adjustments */
.drawer-section h3 {
  font-size: 13px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-secondary);
  margin-bottom: 12px;
}

.info-grid {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  font-size: 13px;
}

.info-label {
  color: var(--text-secondary);
}

.info-value {
  font-weight: 500;
  color: var(--text-primary);
}

.text-italic {
  font-style: italic;
  color: var(--text-secondary);
}

.items-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.item-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  padding: 8px 0;
}

.item-details {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.item-name {
  font-weight: 600;
  color: var(--text-primary);
}

.item-meta {
  font-size: 11px;
  color: var(--text-muted);
}

.item-price {
  font-weight: 600;
  color: var(--text-primary);
}

.finance-summary {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.finance-row {
  display: flex;
  justify-content: space-between;
  font-size: 13px;
  color: var(--text-secondary);
}

.finance-row--total {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-primary);
  border-top: 1px solid var(--color-border);
  padding-top: 10px;
  margin-top: 4px;
}

.font-mono {
  font-family: monospace;
}
</style>
