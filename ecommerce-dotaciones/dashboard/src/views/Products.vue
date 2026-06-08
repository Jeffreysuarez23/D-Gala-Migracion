<template>
  <div class="products-view">
    
    <!-- PAGE HEADER -->
    <header class="page-header">
      <div class="page-header__title-wrap">
        <p>/ Gestión de Inventario</p>
        <h1 class="title-serif">Catálogo de Productos</h1>
      </div>
      <div class="page-header__actions">
        <button class="btn btn--primary" @click="openCreateDrawer">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
          Nuevo Producto
        </button>
      </div>
    </header>

    <!-- SEARCH & FILTERS -->
    <section class="card filter-card">
      <div class="filter-grid">
        <div class="form-group" style="margin-bottom: 0;">
          <label>Buscar Producto</label>
          <div class="search-input-wrap">
            <input 
              type="text" 
              class="input-text" 
              placeholder="Buscar por nombre, SKU o descripción..." 
              v-model="filters.search"
            />
          </div>
        </div>
        
        <div class="form-group" style="margin-bottom: 0;">
          <label>Categoría</label>
          <select class="select-input" v-model="filters.category">
            <option :value="null">Todas las categorías</option>
            <option :value="1">Ropa</option>
            <option :value="2">Camisetas</option>
          </select>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
          <label>Visibilidad</label>
          <select class="select-input" v-model="filters.status">
            <option value="all">Todos</option>
            <option value="published">Publicados</option>
            <option value="draft">Borrador</option>
          </select>
        </div>
      </div>
    </section>

    <!-- PRODUCTS TABLE -->
    <section class="card table-card">
      <div class="table-wrap">
        <table class="table-custom">
          <thead>
            <tr>
              <th>ID</th>
              <th>Producto</th>
              <th>Precios (Min / May)</th>
              <th>Cant. Mayorista</th>
              <th>Variantes</th>
              <th>Stock Total</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="product in filteredProducts" :key="product.id">
              <td>#{{ product.id }}</td>
              <td>
                <div class="product-info-cell">
                  <span class="product-name">{{ product.nombre }}</span>
                  <span class="product-slug">/{{ product.slug }}</span>
                </div>
              </td>
              <td style="font-weight: 500;">
                <span class="price-retail">${{ formatMoney(product.precio_minorista) }}</span>
                <span class="price-divider">|</span>
                <span class="price-wholesale">${{ formatMoney(product.precio_mayorista) }}</span>
              </td>
              <td>{{ product.min_cantidad_mayorista }} uds.</td>
              <td>
                <span class="badge badge--info">{{ getVariantsCount(product.id) }} vars</span>
              </td>
              <td style="font-weight: 600;">
                <span :class="{ 'text-danger': getProductStock(product.id) === 0 }">
                  {{ getProductStock(product.id) }} uds
                </span>
              </td>
              <td>
                <span :class="['badge', product.publicado ? 'badge--success' : 'badge--pending']">
                  {{ product.publicado ? 'Publicado' : 'Borrador' }}
                </span>
              </td>
              <td>
                <div class="action-buttons">
                  <button class="btn-icon-action" title="Editar Producto" @click="openEditDrawer(product)">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                      <path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                    </svg>
                  </button>
                  <button class="btn-icon-action btn-icon-action--danger" title="Eliminar Producto" @click="confirmDelete(product)">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <polyline points="3 6 5 6 21 6"></polyline>
                      <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
            <tr v-if="filteredProducts.length === 0">
              <td colspan="8" class="text-center text-muted" style="padding: 40px 0;">
                No se encontraron productos con los filtros seleccionados
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- DRAWER FOR CREATE/EDIT -->
    <div class="drawer-backdrop" :class="{ active: showDrawer }" @click="showDrawer = false"></div>
    <div class="drawer" :class="{ active: showDrawer }">
      <div class="drawer__header">
        <h2 class="title-serif">{{ isEditMode ? 'Editar Producto' : 'Crear Producto' }}</h2>
        <button class="drawer__close" @click="showDrawer = false">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="18" y1="6" x2="6" y2="18"></line>
            <line x1="6" y1="6" x2="18" y2="18"></line>
          </svg>
        </button>
      </div>

      <div class="drawer__body">
        <form @submit.prevent="submitForm">
          
          <!-- Nombre -->
          <div class="form-group">
            <label>Nombre del Producto *</label>
            <input type="text" class="input-text" v-model="form.nombre" required />
          </div>

          <!-- Descripción -->
          <div class="form-group">
            <label>Descripción</label>
            <textarea class="textarea-input" v-model="form.descripcion"></textarea>
          </div>

          <!-- Categoría -->
          <div class="form-group">
            <label>Categoría</label>
            <select class="select-input" v-model="form.categoria_id">
              <option :value="null">Ninguna</option>
              <option :value="1">Ropa</option>
              <option :value="2">Camisetas</option>
            </select>
          </div>

          <!-- Precios Grid -->
          <div class="grid-2">
            <div class="form-group">
              <label>Precio Detal (COP) *</label>
              <input type="number" class="input-text" v-model="form.precio_minorista" required />
            </div>
            <div class="form-group">
              <label>Precio Mayorista (COP) *</label>
              <input type="number" class="input-text" v-model="form.precio_mayorista" required />
            </div>
          </div>

          <!-- Cantidad Mayorista Mínima -->
          <div class="form-group">
            <label>Cant. Mínima Mayorista</label>
            <input type="number" class="input-text" v-model="form.min_cantidad_mayorista" />
          </div>

          <!-- Checkbox Toggles -->
          <div class="checkbox-group">
            <label class="checkbox-label">
              <input type="checkbox" v-model="form.publicado" />
              <span>Publicar en catálogo inmediatamente</span>
            </label>
            <label class="checkbox-label">
              <input type="checkbox" v-model="form.permitir_sin_stock" />
              <span>Permitir pedidos sin stock disponible</span>
            </label>
          </div>

          <!-- VARIANTS PANEL (Nested in edit mode) -->
          <div class="variants-panel-wrap" v-if="isEditMode">
            <div class="variants-panel__header">
              <h3>Variantes & Stock</h3>
              <button type="button" class="btn-text-action" @click="showAddVariantForm = !showAddVariantForm">
                {{ showAddVariantForm ? 'Cancelar' : '+ Agregar Variante' }}
              </button>
            </div>

            <!-- Add Variant Form -->
            <div class="add-variant-box" v-if="showAddVariantForm">
              <div class="grid-2">
                <div class="form-group">
                  <label>SKU</label>
                  <input type="text" class="input-text" placeholder="Ej: POLO-004" v-model="newVar.sku" />
                </div>
                <div class="form-group">
                  <label>Color</label>
                  <input type="text" class="input-text" placeholder="Ej: Azul" v-model="newVar.color" />
                </div>
              </div>
              <div class="grid-2">
                <div class="form-group">
                  <label>Talla</label>
                  <input type="text" class="input-text" placeholder="Ej: M" v-model="newVar.talla" />
                </div>
                <div class="form-group">
                  <label>Stock Inicial</label>
                  <input type="number" class="input-text" v-model="newVar.stock" />
                </div>
              </div>
              <div class="form-group">
                <label>Lona Asociada (ID)</label>
                <select class="select-input" v-model="newVar.lona_id">
                  <option :value="null">Ninguna lona</option>
                  <option v-for="l in state.lonas" :key="l.id" :value="l.id">
                    {{ l.codigo }} - {{ l.tipo_producto }} ({{ l.color }})
                  </option>
                </select>
              </div>
              <button type="button" class="btn btn--primary btn--sm" @click="saveNewVariant">Guardar Variante</button>
            </div>

            <!-- Existing Variants List -->
            <div class="variants-list">
              <div v-for="v in getProductVariants(form.id)" :key="v.id" class="variant-item">
                <div class="variant-item__info">
                  <span class="v-sku">{{ v.sku }}</span>
                  <span class="v-details">Color: {{ v.color }} | Talla: {{ v.talla }}</span>
                </div>
                
                <!-- Stock Modifier -->
                <div class="variant-item__stock">
                  <button type="button" class="btn-stock-mod" @click="updateVarStock(v, -1)">-</button>
                  <input type="number" class="input-stock-val" :value="v.stock" readonly />
                  <button type="button" class="btn-stock-mod" @click="updateVarStock(v, 1)">+</button>
                </div>

                <button type="button" class="btn-delete-var" @click="deleteVar(v.id)">×</button>
              </div>
            </div>
          </div>

          <div class="form-actions">
            <button type="button" class="btn btn--secondary" @click="showDrawer = false">Cancelar</button>
            <button type="submit" class="btn btn--primary">Guardar Producto</button>
          </div>

        </form>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed, reactive } from 'vue'
import { state, actions } from '../store/state.js'

// Filter state
const filters = reactive({
  search: '',
  category: null,
  status: 'all'
})

// Drawer state
const showDrawer = ref(false)
const isEditMode = ref(false)
const showAddVariantForm = ref(false)

const form = reactive({
  id: null,
  nombre: '',
  descripcion: '',
  categoria_id: null,
  precio_minorista: 0,
  precio_mayorista: 0,
  min_cantidad_mayorista: 12,
  publicado: true,
  permitir_sin_stock: true
})

const newVar = reactive({
  sku: '',
  color: '',
  talla: '',
  stock: 0,
  lona_id: null,
  precio_extra: 0
})

// Filter computation
const filteredProducts = computed(() => {
  return state.productos.filter(p => {
    // Search filter
    const matchesSearch = !filters.search || 
      p.nombre.toLowerCase().includes(filters.search.toLowerCase()) || 
      (p.descripcion && p.descripcion.toLowerCase().includes(filters.search.toLowerCase())) || 
      p.slug.toLowerCase().includes(filters.search.toLowerCase())
    
    // Category filter
    const matchesCat = filters.category === null || p.categoria_id === Number(filters.category)

    // Visibility filter
    const matchesStatus = filters.status === 'all' || 
      (filters.status === 'published' && p.publicado === 1) || 
      (filters.status === 'draft' && p.publicado === 0)

    return matchesSearch && matchesCat && matchesStatus
  })
})

// Helper methods
const formatMoney = (amount) => {
  return Number(amount).toLocaleString('es-CO', { minimumFractionDigits: 0, maximumFractionDigits: 0 })
}

const getVariantsCount = (productId) => {
  return state.variantes_producto.filter(v => v.producto_id === productId).length
}

const getProductStock = (productId) => {
  return state.variantes_producto
    .filter(v => v.producto_id === productId)
    .reduce((sum, v) => sum + v.stock, 0)
}

const getProductVariants = (productId) => {
  return state.variantes_producto.filter(v => v.producto_id === productId)
}

// Actions
const openCreateDrawer = () => {
  isEditMode.value = false
  showAddVariantForm.value = false
  form.id = null
  form.nombre = ''
  form.descripcion = ''
  form.categoria_id = null
  form.precio_minorista = 0
  form.precio_mayorista = 0
  form.min_cantidad_mayorista = 12
  form.publicado = true
  form.permitir_sin_stock = true
  showDrawer.value = true
}

const openEditDrawer = (product) => {
  isEditMode.value = true
  showAddVariantForm.value = false
  form.id = product.id
  form.nombre = product.nombre
  form.descripcion = product.descripcion
  form.categoria_id = product.categoria_id
  form.precio_minorista = product.precio_minorista
  form.precio_mayorista = product.precio_mayorista
  form.min_cantidad_mayorista = product.min_cantidad_mayorista
  form.publicado = product.publicado === 1
  form.permitir_sin_stock = product.permitir_sin_stock === 1
  showDrawer.value = true
}

const submitForm = () => {
  if (isEditMode.value) {
    actions.updateProduct(form.id, form)
  } else {
    actions.addProduct(form)
  }
  showDrawer.value = false
}

const confirmDelete = (product) => {
  if (confirm(`¿Estás seguro de eliminar el producto "${product.nombre}"? Esto eliminará también todas sus variantes.`)) {
    actions.deleteProduct(product.id)
  }
}

// Nested Variants Management
const saveNewVariant = () => {
  if (!newVar.sku) {
    alert('El SKU es obligatorio')
    return
  }
  actions.addVariant(form.id, newVar)
  // Reset fields
  newVar.sku = ''
  newVar.color = ''
  newVar.talla = ''
  newVar.stock = 0
  newVar.lona_id = null
  showAddVariantForm.value = false
}

const updateVarStock = (variant, change) => {
  // If the variant is connected to a Lona, modify the stock via adjustLonaStock (to trigger SQL-like triggers/audits)
  if (variant.lona_id) {
    actions.adjustLonaStock(variant.lona_id, variant.talla, change)
  } else {
    actions.updateVariant(variant.id, { stock: variant.stock + change })
  }
}

const deleteVar = (variantId) => {
  if (confirm('¿Eliminar esta variante?')) {
    actions.deleteVariant(variantId)
  }
}
</script>

<style scoped>
.filter-card {
  padding: 18px 24px;
}

.filter-grid {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr;
  gap: 20px;
  align-items: center;
}

@media (max-width: 768px) {
  .filter-grid {
    grid-template-columns: 1fr;
    gap: 12px;
  }
}

/* Cell alignment styling */
.product-info-cell {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.product-name {
  font-weight: 600;
  color: var(--text-primary);
}

.product-slug {
  font-size: 11px;
  color: var(--text-muted);
  font-family: monospace;
}

.price-divider {
  color: var(--color-border);
  margin: 0 6px;
}

.price-retail {
  color: var(--text-primary);
}

.price-wholesale {
  color: var(--color-accent);
}

/* Action button configurations */
.action-buttons {
  display: flex;
  gap: 8px;
}

.btn-icon-action {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: var(--radius-md);
  border: 1px solid var(--color-border);
  background-color: var(--bg-card);
  color: var(--text-secondary);
  cursor: pointer;
  transition: var(--transition-smooth);
}

.btn-icon-action:hover {
  border-color: var(--color-accent);
  color: var(--color-accent);
  background-color: var(--color-accent-light);
}

.btn-icon-action--danger:hover {
  border-color: var(--color-danger);
  color: var(--color-danger);
  background-color: var(--color-danger-light);
}

/* Checkbox alignment */
.checkbox-group {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 24px;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 13px;
  color: var(--text-secondary);
  cursor: pointer;
}

.checkbox-label input {
  cursor: pointer;
}

/* Nested variants panel styling */
.variants-panel-wrap {
  border-top: 1px solid var(--color-border);
  margin-top: 24px;
  padding-top: 20px;
  margin-bottom: 24px;
}

.variants-panel__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.variants-panel__header h3 {
  font-size: 14px;
  font-weight: 700;
  text-transform: uppercase;
  color: var(--text-primary);
}

.add-variant-box {
  background-color: var(--bg-sidebar);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  padding: 16px;
  margin-bottom: 16px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.variants-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.variant-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 14px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background-color: var(--bg-input);
}

.variant-item__info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.v-sku {
  font-size: 12px;
  font-weight: 700;
  color: var(--text-primary);
  font-family: monospace;
}

.v-details {
  font-size: 11px;
  color: var(--text-muted);
}

.variant-item__stock {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-left: auto;
  margin-right: 16px;
}

.btn-stock-mod {
  width: 24px;
  height: 24px;
  border-radius: var(--radius-sm);
  border: 1px solid var(--color-border);
  background: var(--bg-card);
  color: var(--text-primary);
  font-weight: 700;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-stock-mod:hover {
  background-color: var(--color-accent-light);
  border-color: var(--color-accent);
}

.input-stock-val {
  width: 40px;
  text-align: center;
  border: none;
  background: transparent;
  font-weight: 600;
  font-size: 13px;
  outline: none;
}

.btn-delete-var {
  background: none;
  border: none;
  font-size: 18px;
  color: var(--text-muted);
  cursor: pointer;
  padding: 2px;
}

.btn-delete-var:hover {
  color: var(--color-danger);
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  border-top: 1px solid var(--color-border);
  padding-top: 20px;
}
</style>
