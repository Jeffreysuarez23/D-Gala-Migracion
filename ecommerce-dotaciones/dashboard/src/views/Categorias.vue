<template>
  <div class="products-view">
    
    <!-- PAGE HEADER -->
    <header class="page-header">
      <div class="page-header__title-wrap">
        <p>/ Gestión de Inventario</p>
        <h1 class="title-serif">Categorías</h1>
      </div>
      <div class="page-header__actions">
        <button class="btn btn--primary" @click="openCreateDrawer">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <line x1="12" y1="5" x2="12" y2="19"></line>
            <line x1="5" y1="12" x2="19" y2="12"></line>
          </svg>
          Nueva Categoría
        </button>
      </div>
    </header>

    <!-- GLOBAL ALERTS -->
    <div v-if="successMsg && !showDrawer" class="alert alert--success" style="margin-top: 0; margin-bottom: 24px;">{{ successMsg }}</div>
    <div v-if="errorMsg && !showDrawer" class="alert alert--error" style="margin-top: 0; margin-bottom: 24px;">{{ errorMsg }}</div>

    <!-- CATEGORÍAS TABLE -->
    <section class="card table-card">
      <div class="table-wrap">
        <table class="table-custom">
          <thead>
            <tr>
              <th>ID</th>
              <th>Nombre de la Categoría</th>
              <th>Nivel</th>
              <th>Orden</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="cat in flatCategorias" :key="cat.id">
              <td>#{{ cat.id }}</td>
              <td style="font-weight: 600; color: var(--color-accent);">{{ cat.displayName }}</td>
              <td>
                <span :class="['badge', cat.isSub ? 'badge--info' : 'badge--success']">
                  {{ cat.isSub ? 'Subcategoría' : 'Principal' }}
                </span>
              </td>
              <td>{{ cat.orden }}</td>
              <td>
                <div class="action-buttons">
                  <button class="btn-icon-action" title="Editar Categoría" @click="openEditDrawer(cat)">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                      <path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                    </svg>
                  </button>
                  <button class="btn-icon-action btn-icon-action--danger" title="Eliminar Categoría" @click="confirmDelete(cat)">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <polyline points="3 6 5 6 21 6"></polyline>
                      <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
            <tr v-if="flatCategorias.length === 0">
              <td colspan="5" class="text-center text-muted" style="padding: 40px 0;">
                No hay categorías registradas
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- ─── DRAWER BACKDROP ─── -->
    <div class="drawer-backdrop" :class="{ active: showDrawer }" @click="closeDrawer"></div>

    <!-- ─── DRAWER (CREAR/EDITAR) ─── -->
    <div class="drawer" :class="{ active: showDrawer }">
      <!-- Drawer Header -->
      <div class="drawer__header">
        <div class="drawer__header-left">
          <div class="drawer-avatar" v-if="isEditMode">
            {{ form.nombre?.charAt(0)?.toUpperCase() || '?' }}
          </div>
          <div class="drawer-avatar drawer-avatar--new" v-else>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <line x1="12" y1="5" x2="12" y2="19"></line>
              <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
          </div>
          <div>
            <p class="drawer__subtitle">{{ isEditMode ? 'Editando categoría' : 'Nuevo registro' }}</p>
            <h2 class="drawer__title title-serif">{{ isEditMode ? form.nombre : 'Crear Categoría' }}</h2>
          </div>
        </div>
        <button class="drawer__close" @click="closeDrawer">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <line x1="18" y1="6" x2="6" y2="18"></line>
            <line x1="6" y1="6" x2="18" y2="18"></line>
          </svg>
        </button>
      </div>

      <!-- Drawer Body -->
      <div class="drawer__body">
        <form @submit.prevent="submitForm">
          
          <div class="form-group">
            <label class="form-label">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
              </svg>
              Nombre de la Categoría *
            </label>
            <input type="text" class="input-text" v-model="form.nombre" placeholder="Ej: Ropa, Uniformes, Camisetas..." required />
          </div>

          <div class="grid-2">
            <div class="form-group">
              <label class="form-label">
                Categoría Padre (Opcional)
              </label>
              <select class="select-input" v-model="form.padre_id">
                <option :value="null">Ninguna</option>
                <option v-for="parent in parentCategorias" :key="parent.id" :value="parent.id" :disabled="isEditMode && parent.id === form.id">
                  {{ parent.nombre }}
                </option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">
                Orden de aparición
              </label>
              <input type="number" class="input-text" v-model="form.orden" placeholder="Ej: 0, 1, 2" min="0" />
            </div>
          </div>

          <div v-if="successMsg" class="alert alert--success">{{ successMsg }}</div>
          <div v-if="errorMsg" class="alert alert--error">{{ errorMsg }}</div>

          <div class="drawer__divider"></div>

          <div class="form-actions">
            <button type="button" class="btn btn--secondary" @click="closeDrawer">Cancelar</button>
            <button type="submit" class="btn btn--primary" :disabled="saving">
              <span class="spinner" v-if="saving"></span>
              <svg v-else width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <polyline points="20 6 9 17 4 12"></polyline>
              </svg>
              {{ saving ? 'Guardando...' : (isEditMode ? 'Guardar Cambios' : 'Crear Categoría') }}
            </button>
          </div>

        </form>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <Transition name="modal">
      <div v-if="showDeleteModal" class="modal-overlay" @click.self="showDeleteModal = false">
        <div class="modal-card">
          <div class="modal-icon">
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#b91c1c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10" class="modal-circle" />
              <line x1="12" y1="8" x2="12" y2="12" class="modal-line" />
              <line x1="12" y1="16" x2="12.01" y2="16" />
            </svg>
          </div>
          <h2 class="modal-title">¿Eliminar esta categoría?</h2>
          <p class="modal-text">Se eliminará permanentemente la categoría <strong>{{ catToDelete?.nombre }}</strong>. Esta acción no se puede deshacer.</p>
          
          <div v-if="deleteError" class="alert alert--error" style="margin-top: 15px; font-size: 13px; text-align: left;">
            {{ deleteError }}
          </div>

          <div class="modal-actions">
            <button class="modal-btn modal-btn--cancel" @click="showDeleteModal = false" :disabled="deleting">Cancelar</button>
            <button class="modal-btn modal-btn--danger" @click="executeDelete" :disabled="deleting">
              <span v-if="deleting">Eliminando...</span>
              <span v-else>Sí, eliminar</span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import axios from 'axios'

const API_URL = 'http://localhost:8000/api'

// States
const categoriasRaw = ref([])
const showDrawer = ref(false)
const isEditMode = ref(false)
const saving = ref(false)
const errorMsg = ref('')
const successMsg = ref('')
const showDeleteModal = ref(false)
const catToDelete = ref(null)
const deleting = ref(false)
const deleteError = ref('')

// Form
const emptyForm = () => ({
  id: null,
  nombre: '',
  padre_id: null,
  orden: 0
})
const form = reactive(emptyForm())

// Computed lists
const flatCategorias = computed(() => {
  const flat = []
  const flatten = (cats, prefix = '', isSub = false) => {
    cats.forEach(c => {
      flat.push({
        ...c,
        displayName: prefix + c.nombre,
        isSub: isSub
      })
      if (c.hijos && c.hijos.length > 0) {
        flatten(c.hijos, c.nombre + ' > ', true)
      }
    })
  }
  flatten(categoriasRaw.value)
  return flat
})

const parentCategorias = computed(() => {
  // Only top-level categories can be parents, as API only supports 2 levels effectively
  // or rather, we just filter the raw ones
  return categoriasRaw.value
})

// Fetch
const fetchCategorias = async () => {
  try {
    const { data } = await axios.get(`${API_URL}/categorias`)
    categoriasRaw.value = data
  } catch (error) {
    console.error('Error fetching categorias', error)
  }
}

onMounted(() => {
  fetchCategorias()
})

// Drawer Logic
const openCreateDrawer = () => {
  errorMsg.value = ''
  successMsg.value = ''
  isEditMode.value = false
  Object.assign(form, emptyForm())
  showDrawer.value = true
  document.body.style.overflow = 'hidden'
}

const openEditDrawer = (cat) => {
  errorMsg.value = ''
  successMsg.value = ''
  isEditMode.value = true
  Object.assign(form, {
    id: cat.id,
    nombre: cat.nombre,
    padre_id: cat.padre_id,
    orden: cat.orden || 0
  })
  showDrawer.value = true
  document.body.style.overflow = 'hidden'
}

const closeDrawer = () => {
  showDrawer.value = false
  document.body.style.overflow = ''
}

// Save (Create/Update)
const submitForm = async () => {
  errorMsg.value = ''
  successMsg.value = ''
  
  // Validaciones Profesionales
  const nombreLimpio = form.nombre.trim()
  
  if (!nombreLimpio) {
    errorMsg.value = 'El nombre de la categoría es obligatorio.'
    return
  }
  
  if (nombreLimpio.length < 3) {
    errorMsg.value = 'El nombre debe tener al menos 3 caracteres.'
    return
  }
  
  if (nombreLimpio.length > 40) {
    errorMsg.value = 'El nombre es muy largo (máximo 40 caracteres).'
    return
  }

  // Regex para permitir letras, números y espacios (sin caracteres extraños)
  const regex = /^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ\s]+$/
  if (!regex.test(nombreLimpio)) {
    errorMsg.value = 'El nombre contiene caracteres inválidos.'
    return
  }
  
  saving.value = true
  try {
    const payload = {
      nombre: nombreLimpio,
      padre_id: form.padre_id || null,
      orden: form.orden
    }
    
    if (isEditMode.value) {
      await axios.put(`${API_URL}/categorias/${form.id}`, payload)
      successMsg.value = 'Categoría actualizada correctamente'
    } else {
      await axios.post(`${API_URL}/categorias`, payload)
      successMsg.value = 'Categoría creada correctamente'
    }
    
    await fetchCategorias()
    closeDrawer()
  } catch (error) {
    errorMsg.value = error.response?.data?.message || 'Error al guardar la categoría'
  } finally {
    saving.value = false
  }
}

// Delete Logic
const confirmDelete = (cat) => {
  catToDelete.value = cat
  deleteError.value = ''
  showDeleteModal.value = true
}

const executeDelete = async () => {
  if (!catToDelete.value) return
  deleting.value = true
  deleteError.value = ''
  
  try {
    await axios.delete(`${API_URL}/categorias/${catToDelete.value.id}`)
    successMsg.value = 'Categoría eliminada con éxito'
    showDeleteModal.value = false
    await fetchCategorias()
  } catch (error) {
    if (error.response?.status === 400) {
      deleteError.value = error.response.data.message || 'No se puede eliminar esta categoría'
    } else {
      deleteError.value = 'Ocurrió un error al intentar eliminar la categoría.'
    }
  } finally {
    deleting.value = false
  }
}
</script>

<style scoped>
/* Respetando exactamente las dimensiones y centro de Products.vue y Users.vue */
.products-view {
  display: flex;
  flex-direction: column;
  gap: 24px;
  padding: 24px;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
}

.table-custom th {
  padding: 16px 24px;
}

.table-custom td {
  padding: 22px 24px;
  vertical-align: middle;
}

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

/* ─── Drawer Header ─── */
.drawer__header-left {
  display: flex;
  align-items: center;
  gap: 14px;
}

.drawer-avatar {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: var(--color-accent);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  font-weight: 700;
  flex-shrink: 0;
}

.drawer-avatar--new {
  background: var(--color-accent-light);
  color: var(--color-accent);
  border: 1.5px dashed var(--color-accent);
}

.drawer__subtitle {
  font-size: 10px;
  font-weight: 600;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--text-muted);
  margin: 0 0 3px;
}

.drawer__title {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
  line-height: 1.2;
}

/* Modal styles copied for delete modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.45);
  backdrop-filter: blur(6px);
}

.modal-card {
  background: var(--bg-card);
  border-radius: 20px;
  padding: 48px 40px 36px;
  max-width: 400px;
  width: 90%;
  text-align: center;
  box-shadow: 0 25px 60px rgba(0, 0, 0, 0.2), 0 0 0 1px var(--color-border);
  animation: modalPop 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.modal-icon {
  margin: 0 auto 24px;
  width: 80px;
  height: 80px;
  background: rgba(185, 28, 28, 0.1);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-title {
  font-size: 24px;
  font-weight: 700;
  margin: 0 0 12px;
  color: var(--text-primary);
  line-height: 1.2;
}

.modal-text {
  font-size: 15px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin: 0 0 32px;
}

.modal-actions {
  display: flex;
  gap: 12px;
}

.modal-btn {
  flex: 1;
  padding: 14px 20px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  border: none;
}

.modal-btn--cancel {
  background: var(--bg-input);
  color: var(--text-primary);
  border: 1px solid var(--color-border);
}

.modal-btn--cancel:hover {
  background: var(--color-border);
}

.modal-btn--danger {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
  color: white;
}

.modal-btn--danger:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(239, 68, 68, 0.3);
}

@keyframes modalPop {
  from { opacity: 0; transform: scale(0.85) translateY(20px); }
  to { opacity: 1; transform: scale(1) translateY(0); }
}
</style>
