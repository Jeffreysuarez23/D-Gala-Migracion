<template>
  <div class="dotaciones-view">
    
    <!-- PAGE HEADER -->
    <header class="page-header">
      <div class="page-header__title-wrap">
        <p>/ Registro de Suministros</p>
        <h1 class="title-serif">Dotaciones & Lonas de Uniformes</h1>
      </div>
      <div class="page-header__actions" style="display: flex; gap: 12px;">
        <button class="btn btn--secondary" @click="openCreateLonaDrawer">
          + Agregar Lona
        </button>
        <button class="btn btn--primary" @click="openCreateDotacionDrawer">
          + Nueva Dotación
        </button>
      </div>
    </header>

    <!-- DOTACIONES LIST & OVERVIEW -->
    <section class="grid-3">
      <div v-for="dot in state.dotaciones" :key="dot.id" class="card dotacion-card">
        <div class="dotacion-card__header">
          <span class="badge badge--info">ID: #{{ dot.id }}</span>
          <span class="dot-status-icon" :class="getDotationStatusClass(dot)"></span>
        </div>
        <div class="dotacion-card__body">
          <h3 class="dotacion-name">{{ dot.nombre }}</h3>
          <p class="dotacion-desc">{{ dot.descripcion }}</p>
          
          <!-- Limits Gauge -->
          <div class="dotation-gauge">
            <div class="gauge-labels">
              <span>Lonas Activas: <strong>{{ getLonasCountForDot(dot.id) }}</strong></span>
              <span>Límites: {{ dot.min_lonas }} - {{ dot.max_lonas }}</span>
            </div>
            <div class="gauge-bar-wrap">
              <div class="gauge-bar" :style="{ width: getGaugePercentage(dot) + '%' }" :class="getGaugeColorClass(dot)"></div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- LONAS DETAIL GRID & STOCK MODIFIER -->
    <section class="card lonas-section">
      <h2 class="section-title title-serif" style="margin-bottom: 20px;">Inventario Detallado de Lonas</h2>
      
      <div class="table-wrap">
        <table class="table-custom">
          <thead>
            <tr>
              <th>Código Lona</th>
              <th>Dotación Relacionada</th>
              <th>Prenda / Categoría</th>
              <th>Color</th>
              <th>Estado Físico</th>
              <th>Tallas & Cantidades</th>
              <th>Total Stock</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="lona in state.lonas" :key="lona.id">
              <td class="font-mono" style="font-weight: 700;">{{ lona.codigo }}</td>
              <td>{{ getDotationName(lona.dotacion_id) }}</td>
              <td>
                <div class="product-cell">
                  <span class="p-type">{{ lona.tipo_producto }}</span>
                  <span class="p-cat">/ {{ lona.categoria }}</span>
                </div>
              </td>
              <td>
                <div class="color-indicator-wrap">
                  <span class="color-badge" :style="{ backgroundColor: getColorHex(lona.color) }"></span>
                  <span>{{ lona.color }}</span>
                </div>
              </td>
              <td>
                <span :class="['badge', lona.estado === 'nuevo' ? 'badge--success' : 'badge--pending']">
                  {{ lona.estado }}
                </span>
              </td>
              <td>
                <!-- Sizes Grid details -->
                <div class="sizes-badges">
                  <div v-for="lt in getLonaTallas(lona.id)" :key="lt.id" class="size-pill">
                    <span class="size-label">{{ lt.talla }}:</span>
                    <strong class="size-qty" :class="{ 'text-danger': lt.cantidad === 0 }">{{ lt.cantidad }}</strong>
                  </div>
                </div>
              </td>
              <td style="font-weight: 700;">
                {{ getLonaTotalStock(lona.id) }} uds
              </td>
              <td>
                <button class="btn btn--secondary btn--sm" style="padding: 6px 14px;" @click="openStockAdjustDrawer(lona)">
                  Ajustar Stock
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- AUDIT TRAIL TIMELINE (Mapping to historial_lonas) -->
    <section class="card audit-section">
      <h2 class="section-title title-serif" style="margin-bottom: 20px;">Historial de Movimientos (Auditoría)</h2>
      
      <div class="timeline">
        <div v-for="log in sortedLogs" :key="log.id" class="timeline-item" :class="`timeline-item--${log.accion}`">
          <div class="timeline-item__badge">
            <span v-if="log.accion === 'ingreso'">📥</span>
            <span v-else-if="log.accion === 'descuento'">📤</span>
            <span v-else>⚙️</span>
          </div>
          <div class="timeline-item__content">
            <div class="timeline-item__meta">
              <span class="timeline-action">{{ getActionLabel(log.accion) }}</span>
              <span class="timeline-date">{{ log.creado_en }}</span>
            </div>
            <p class="timeline-desc">
              Lona <strong>{{ getLonaCode(log.lona_id) }}</strong> | Talla <strong>{{ log.talla }}</strong> | 
              Cantidad: <strong :class="log.cantidad_cambio < 0 ? 'text-danger' : 'text-success'">{{ log.cantidad_cambio > 0 ? '+' : '' }}{{ log.cantidad_cambio }} uds</strong>
            </p>
            <p class="timeline-notes" v-if="log.notas">Nota: {{ log.notas }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- DRAWER FOR NEW DOTACION -->
    <div class="drawer-backdrop" :class="{ active: showDotationDrawer }" @click="showDotationDrawer = false"></div>
    <div class="drawer" :class="{ active: showDotationDrawer }">
      <div class="drawer__header">
        <h2 class="title-serif">Nueva Dotación Corporativa</h2>
        <button class="drawer__close" @click="showDotationDrawer = false">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="18" y1="6" x2="6" y2="18"></line>
            <line x1="6" y1="6" x2="18" y2="18"></line>
          </svg>
        </button>
      </div>
      <div class="drawer__body">
        <form @submit.prevent="submitDotation">
          <div class="form-group">
            <label>Nombre de la Dotación *</label>
            <input type="text" class="input-text" placeholder="Ej: Dotación Operativa Masculina" v-model="dotationForm.nombre" required />
          </div>
          <div class="form-group">
            <label>Descripción</label>
            <textarea class="textarea-input" placeholder="Detalle a qué área de la empresa o temporada aplica..." v-model="dotationForm.descripcion"></textarea>
          </div>
          <div class="grid-2">
            <div class="form-group">
              <label>Min Lonas Alerta *</label>
              <input type="number" class="input-text" v-model="dotationForm.min_lonas" required />
            </div>
            <div class="form-group">
              <label>Max Lonas Capacidad *</label>
              <input type="number" class="input-text" v-model="dotationForm.max_lonas" required />
            </div>
          </div>
          <div class="form-actions">
            <button type="button" class="btn btn--secondary" @click="showDotationDrawer = false">Cancelar</button>
            <button type="submit" class="btn btn--primary">Crear Dotación</button>
          </div>
        </form>
      </div>
    </div>

    <!-- DRAWER FOR NEW LONA -->
    <div class="drawer-backdrop" :class="{ active: showLonaDrawer }" @click="showLonaDrawer = false"></div>
    <div class="drawer" :class="{ active: showLonaDrawer }">
      <div class="drawer__header">
        <h2 class="title-serif">Nueva Lona de Textil</h2>
        <button class="drawer__close" @click="showLonaDrawer = false">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="18" y1="6" x2="6" y2="18"></line>
            <line x1="6" y1="6" x2="18" y2="18"></line>
          </svg>
        </button>
      </div>
      <div class="drawer__body">
        <form @submit.prevent="submitLona">
          <div class="form-group">
            <label>Código de Lona *</label>
            <input type="text" class="input-text" placeholder="Ej: LONA-004" v-model="lonaForm.codigo" required />
          </div>
          <div class="form-group">
            <label>Dotación Asociada *</label>
            <select class="select-input" v-model="lonaForm.dotacion_id" required>
              <option v-for="d in state.dotaciones" :key="d.id" :value="d.id">{{ d.nombre }}</option>
            </select>
          </div>
          <div class="grid-2">
            <div class="form-group">
              <label>Tipo de Prenda *</label>
              <input type="text" class="input-text" placeholder="Ej: Camiseta Polo, Overol" v-model="lonaForm.tipo_producto" required />
            </div>
            <div class="form-group">
              <label>Categoría Tela *</label>
              <input type="text" class="input-text" placeholder="Ej: Deportiva, Antifluido" v-model="lonaForm.categoria" required />
            </div>
          </div>
          <div class="grid-2">
            <div class="form-group">
              <label>Color *</label>
              <input type="text" class="input-text" placeholder="Ej: Azul, Blanco" v-model="lonaForm.color" required />
            </div>
            <div class="form-group">
              <label>Estado Inicial *</label>
              <select class="select-input" v-model="lonaForm.estado">
                <option value="nuevo">Nuevo</option>
                <option value="usado">Usado</option>
              </select>
            </div>
          </div>
          
          <!-- Initial stock seed -->
          <div class="form-group">
            <label>Stock Inicial por Talla</label>
            <div class="initial-sizes-grid">
              <div class="size-seed-row">
                <span>Talla S:</span>
                <input type="number" class="input-text size-seed-input" v-model="lonaForm.tallas.S" />
              </div>
              <div class="size-seed-row">
                <span>Talla M:</span>
                <input type="number" class="input-text size-seed-input" v-model="lonaForm.tallas.M" />
              </div>
              <div class="size-seed-row">
                <span>Talla L:</span>
                <input type="number" class="input-text size-seed-input" v-model="lonaForm.tallas.L" />
              </div>
              <div class="size-seed-row">
                <span>Talla XL:</span>
                <input type="number" class="input-text size-seed-input" v-model="lonaForm.tallas.XL" />
              </div>
            </div>
          </div>

          <div class="form-actions">
            <button type="button" class="btn btn--secondary" @click="showLonaDrawer = false">Cancelar</button>
            <button type="submit" class="btn btn--primary">Registrar Lona</button>
          </div>
        </form>
      </div>
    </div>

    <!-- DRAWER FOR STOCK ADJUSTMENT -->
    <div class="drawer-backdrop" :class="{ active: showStockAdjustDrawer }" @click="showStockAdjustDrawer = false"></div>
    <div class="drawer" :class="{ active: showStockAdjustDrawer }">
      <div class="drawer__header" v-if="selectedLona">
        <div>
          <span class="badge badge--info" style="margin-bottom: 6px;">{{ selectedLona.codigo }}</span>
          <h2 class="title-serif">Ajustar Tallas / Stock</h2>
        </div>
        <button class="drawer__close" @click="showStockAdjustDrawer = false">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="18" y1="6" x2="6" y2="18"></line>
            <line x1="6" y1="6" x2="18" y2="18"></line>
          </svg>
        </button>
      </div>
      <div class="drawer__body" v-if="selectedLona">
        
        <div class="adjust-sizes-list">
          <div v-for="lt in getLonaTallas(selectedLona.id)" :key="lt.id" class="adjust-size-item">
            <span class="size-tag">{{ lt.talla }}</span>
            <span class="qty-status">Cantidad: <strong>{{ lt.cantidad }}</strong></span>
            
            <div class="adjust-controls">
              <input type="number" class="input-text val-adjust-input" placeholder="Cant" v-model.number="adjustInputs[lt.talla]" />
              <button class="btn btn--secondary btn-adjust-sub" @click="adjustStock(lt.talla, -1)">- Quitar</button>
              <button class="btn btn--primary btn-adjust-add" @click="adjustStock(lt.talla, 1)">+ Añadir</button>
            </div>
          </div>

          <!-- Add new size option to lona if not exists -->
          <div class="add-new-size-to-lona">
            <h3>Añadir Talla Faltante</h3>
            <div class="grid-2" style="margin-top: 8px;">
              <input type="text" class="input-text" placeholder="Ej: XXL, XS" v-model="newSizeField.talla" />
              <button type="button" class="btn btn--secondary" @click="addNewSizeToLona">Crear Talla</button>
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

// Drawers toggles
const showDotationDrawer = ref(false)
const showLonaDrawer = ref(false)
const showStockAdjustDrawer = ref(false)
const selectedLona = ref(null)

// Forms data
const dotationForm = reactive({
  nombre: '',
  descripcion: '',
  min_lonas: 3,
  max_lonas: 10
})

const lonaForm = reactive({
  codigo: '',
  dotacion_id: 1,
  tipo_producto: '',
  categoria: '',
  color: '',
  estado: 'nuevo',
  tallas: { S: 0, M: 0, L: 0, XL: 0 }
})

const adjustInputs = reactive({
  S: null,
  M: null,
  L: null,
  XL: null,
  XXL: null
})

const newSizeField = reactive({
  talla: ''
})

// Timeline Logs
const sortedLogs = computed(() => {
  return [...state.historial_lonas].sort((a, b) => b.id - a.id)
})

// Helpers
const getLonasCountForDot = (dotId) => {
  return state.lonas.filter(l => l.dotacion_id === dotId).length
}

const getDotationName = (dotId) => {
  const dot = state.dotaciones.find(d => d.id === dotId)
  return dot ? dot.nombre : 'Desconocido'
}

const getDotationStatusClass = (dot) => {
  const count = getLonasCountForDot(dot.id)
  if (count < dot.min_lonas) return 'dot-status-icon--danger'
  if (count > dot.max_lonas) return 'dot-status-icon--warning'
  return 'dot-status-icon--success'
}

const getGaugePercentage = (dot) => {
  const count = getLonasCountForDot(dot.id)
  return Math.min((count / dot.max_lonas) * 100, 100)
}

const getGaugeColorClass = (dot) => {
  const count = getLonasCountForDot(dot.id)
  if (count < dot.min_lonas) return 'gauge-bar--danger'
  if (count > dot.max_lonas) return 'gauge-bar--warning'
  return 'gauge-bar--success'
}

const getLonaTallas = (lonaId) => {
  return state.lona_tallas.filter(lt => lt.lona_id === lonaId)
}

const getLonaTotalStock = (lonaId) => {
  return state.lona_tallas
    .filter(lt => lt.lona_id === lonaId)
    .reduce((sum, lt) => sum + lt.cantidad, 0)
}

const getColorHex = (colorName) => {
  const colors = {
    'Azul': '#3b82f6',
    'Blanco': '#f3f4f6',
    'Naranja': '#f97316',
    'Rojo': '#ef4444',
    'Negro': '#1f2937',
    'Gris': '#9ca3af',
    'Verde': '#22c55e'
  }
  return colors[colorName] || '#7a6a53'
}

const getLonaCode = (lonaId) => {
  const lona = state.lonas.find(l => l.id === lonaId)
  return lona ? lona.codigo : `Lona #${lonaId}`
}

const getActionLabel = (action) => {
  switch (action) {
    case 'ingreso': return 'Ingreso Stock'
    case 'descuento': return 'Venta / Descuento'
    case 'ajuste_manual': return 'Ajuste Manual'
    case 'agotado': return 'Agotamiento'
    default: return 'Movimiento'
  }
}

// Drawer openers
const openCreateDotacionDrawer = () => {
  dotationForm.nombre = ''
  dotationForm.descripcion = ''
  dotationForm.min_lonas = 3
  dotationForm.max_lonas = 10
  showDotationDrawer.value = true
}

const openCreateLonaDrawer = () => {
  lonaForm.codigo = ''
  lonaForm.tipo_producto = ''
  lonaForm.categoria = ''
  lonaForm.color = ''
  lonaForm.estado = 'nuevo'
  lonaForm.tallas = { S: 0, M: 0, L: 0, XL: 0 }
  showLonaDrawer.value = true
}

const openStockAdjustDrawer = (lona) => {
  selectedLona.value = lona
  // Reset fields
  Object.keys(adjustInputs).forEach(k => adjustInputs[k] = null)
  showStockAdjustDrawer.value = true
}

// Submits
const submitDotation = () => {
  actions.addDotacion(dotationForm)
  showDotationDrawer.value = false
  alert('Nueva dotación registrada exitosamente')
}

const submitLona = () => {
  actions.addLona(lonaForm)
  showLonaDrawer.value = false
  alert('Nueva lona de material agregada')
}

const adjustStock = (talla, direction) => {
  const amount = adjustInputs[talla]
  if (!amount || amount <= 0) {
    alert('Ingresa una cantidad válida mayor a 0')
    return
  }
  
  const change = amount * direction
  actions.adjustLonaStock(selectedLona.value.id, talla, change)
  
  // Clear input
  adjustInputs[talla] = null
  alert('Inventario actualizado con éxito')
}

const addNewSizeToLona = () => {
  const size = newSizeField.talla.toUpperCase().trim()
  if (!size) {
    alert('Ingresa una talla válida')
    return
  }
  
  // Check if exists
  const exists = state.lona_tallas.some(lt => lt.lona_id === selectedLona.value.id && lt.talla === size)
  if (exists) {
    alert('Esa talla ya existe en la lona')
    return
  }

  // Seed size
  state.lona_tallas.push({
    id: Date.now(),
    lona_id: selectedLona.value.id,
    talla: size,
    cantidad: 0
  })

  adjustInputs[size] = null
  newSizeField.talla = ''
}
</script>

<style scoped>
/* Dotaciones card grids */
.dotacion-card {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.dotacion-card__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dot-status-icon {
  width: 10px;
  height: 10px;
  border-radius: var(--radius-full);
}

.dot-status-icon--success { background-color: var(--color-success); }
.dot-status-icon--warning { background-color: var(--color-pending); }
.dot-status-icon--danger { background-color: var(--color-danger); }

.dotacion-name {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 4px;
}

.dotacion-desc {
  font-size: 12px;
  color: var(--text-secondary);
  line-height: 1.4;
  margin-bottom: 16px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Gauge Bar */
.dotation-gauge {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.gauge-labels {
  display: flex;
  justify-content: space-between;
  font-size: 11px;
  color: var(--text-secondary);
}

.gauge-bar-wrap {
  height: 6px;
  background-color: var(--color-border);
  border-radius: var(--radius-full);
  overflow: hidden;
}

.gauge-bar {
  height: 100%;
  border-radius: var(--radius-full);
  transition: width 0.4s ease;
}

.gauge-bar--success { background-color: var(--color-success); }
.gauge-bar--warning { background-color: var(--color-pending); }
.gauge-bar--danger { background-color: var(--color-danger); }

/* Detailed lonas grid elements */
.product-cell {
  display: flex;
  flex-direction: column;
}

.p-type {
  font-weight: 600;
}

.p-cat {
  font-size: 11px;
  color: var(--text-muted);
}

.color-indicator-wrap {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
}

.color-badge {
  width: 14px;
  height: 14px;
  border-radius: var(--radius-full);
  border: 1px solid var(--color-border);
}

.sizes-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.size-pill {
  display: inline-flex;
  gap: 4px;
  background-color: var(--bg-sidebar);
  border: 1px solid var(--color-border);
  padding: 2px 8px;
  border-radius: var(--radius-sm);
  font-size: 11px;
}

.size-label {
  color: var(--text-secondary);
}

/* Audit logs timeline styling */
.timeline {
  display: flex;
  flex-direction: column;
  gap: 16px;
  position: relative;
  padding-left: 20px;
}

.timeline::before {
  content: '';
  position: absolute;
  top: 8px;
  bottom: 8px;
  left: 6px;
  width: 1px;
  background-color: var(--color-border);
}

.timeline-item {
  display: flex;
  gap: 16px;
  position: relative;
}

.timeline-item__badge {
  background-color: var(--bg-card);
  border: 1px solid var(--color-border);
  width: 28px;
  height: 28px;
  border-radius: var(--radius-full);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  z-index: 1;
  position: absolute;
  left: -28px;
}

.timeline-item__content {
  background-color: var(--bg-sidebar);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  padding: 12px 16px;
  flex-grow: 1;
}

.timeline-item__meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}

.timeline-action {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  color: var(--color-accent);
}

.timeline-date {
  font-size: 10px;
  color: var(--text-muted);
}

.timeline-desc {
  font-size: 13px;
  color: var(--text-primary);
}

.timeline-notes {
  font-size: 11px;
  color: var(--text-secondary);
  margin-top: 4px;
  font-style: italic;
}

/* Seeding forms */
.initial-sizes-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
}

.size-seed-row {
  display: flex;
  flex-direction: column;
  gap: 4px;
  font-size: 11px;
  color: var(--text-secondary);
}

.size-seed-input {
  padding: 6px 10px;
}

/* Adjust Stock Drawer items */
.adjust-sizes-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.adjust-size-item {
  display: flex;
  align-items: center;
  padding: 14px;
  border: 1px solid var(--color-border);
  background-color: var(--bg-sidebar);
  border-radius: var(--radius-md);
}

.size-tag {
  background-color: var(--color-accent);
  color: white;
  width: 32px;
  height: 32px;
  border-radius: var(--radius-full);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 13px;
  margin-right: 12px;
}

.qty-status {
  font-size: 13px;
  color: var(--text-primary);
}

.adjust-controls {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-left: auto;
}

.val-adjust-input {
  width: 60px;
  padding: 6px;
  text-align: center;
}

.btn-adjust-sub {
  padding: 6px 12px;
  font-size: 11px;
}

.btn-adjust-add {
  padding: 6px 12px;
  font-size: 11px;
}

.add-new-size-to-lona {
  border-top: 1px solid var(--color-border);
  padding-top: 16px;
  margin-top: 8px;
}

.add-new-size-to-lona h3 {
  font-size: 13px;
  font-weight: 700;
  color: var(--text-primary);
}

.text-success { color: var(--color-success); }
.text-danger { color: var(--color-danger); }
.font-mono { font-family: monospace; }
</style>
