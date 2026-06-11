<template>
  <div class="checkout-page">

    <!-- ─── HERO ── -->
    <div class="checkout__hero">
      <div class="checkout__hero-bg"></div>
      <div class="checkout__hero-content">
        <p class="checkout__eyebrow">/ PAGO SEGURO</p>
        <h1 class="checkout__title">
          Completa tu<br />
          <span class="checkout__title--light">pedido</span>
        </h1>
      </div>
    </div>

    <!-- ─── STEPPER ── -->
    <div class="stepper-wrap" v-if="currentStep < 3">
      <div class="stepper">
        <div v-for="(s, i) in steps" :key="i" class="stepper__item" :class="{
          'stepper__item--active': currentStep === i,
          'stepper__item--done': currentStep > i
        }">
          <div class="stepper__circle">
            <svg v-if="currentStep > i" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
              stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="20 6 9 17 4 12" />
            </svg>
            <span v-else>{{ i + 1 }}</span>
          </div>
          <span class="stepper__label">{{ s }}</span>
          <div v-if="i < steps.length - 1" class="stepper__line" :class="{ 'stepper__line--done': currentStep > i }">
          </div>
        </div>
      </div>
    </div>

    <!-- ─── BODY ── -->
    <div class="checkout__body">
      <div class="checkout__layout" :class="{ 'checkout__layout--centered': currentStep === 3 }">

        <!-- LEFT: Forms -->
        <div class="checkout__forms">

          <!-- STEP 0: Shipping -->
          <div v-if="currentStep === 0" class="form-section">
            <h2 class="form-section__title">Dirección de Envío</h2>

            <div class="form-row">
              <div class="form-group">
                <label class="form-label">Nombre de quien recibe <span class="required">*</span></label>
                <input type="text" class="form-input" v-model="shipping.nombre_recibe" placeholder="John Doe" />
              </div>
              <div class="form-group">
                <label class="form-label">Teléfono</label>
                <input type="tel" class="form-input" v-model="shipping.telefono" placeholder="+57 300 000 0000" />
              </div>
            </div>

            <div class="form-group">
              <label class="form-label">Dirección <span class="required">*</span></label>
              <input type="text" class="form-input" v-model="shipping.direccion" placeholder="Calle 123 #45-67" />
            </div>

            <div class="form-row">
              <div class="form-group">
                <label class="form-label">Departamento <span class="required">*</span></label>
                <input type="text" class="form-input" v-model="shipping.departamento" placeholder="Atlántico" />
              </div>
              <div class="form-group">
                <label class="form-label">Ciudad <span class="required">*</span></label>
                <input type="text" class="form-input" v-model="shipping.ciudad" placeholder="Barranquilla" />
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label class="form-label">Código Postal</label>
                <input type="text" class="form-input" v-model="shipping.codigo_postal" placeholder="080001" />
              </div>
              <div class="form-group">
                <label class="form-label">Referencia <span class="optional">(opcional)</span></label>
                <input type="text" class="form-input" v-model="shipping.referencia" placeholder="Apto 302, Torre B" />
              </div>
            </div>

            <div class="form-group">
              <label class="form-label">Notas del pedido <span class="optional">(opcional)</span></label>
              <textarea class="form-textarea" v-model="notas_cliente" rows="3"
                placeholder="Instrucciones de entrega..."></textarea>
            </div>

            <div v-if="shippingError" class="form-error">{{ shippingError }}</div>

            <button class="next-btn" @click="nextStep">
              Continuar al Pago
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="5" y1="12" x2="19" y2="12" />
                <polyline points="12 5 19 12 12 19" />
              </svg>
            </button>
          </div>

          <!-- STEP 1: Payment -->
          <div v-if="currentStep === 1" class="form-section">
            <h2 class="form-section__title">Método de Pago</h2>

            <div class="payment-methods">
              <label v-for="m in paymentMethods" :key="m.id" class="payment-card"
                :class="{ 'payment-card--selected': payment.method === m.id }">
                <input type="radio" :value="m.id" v-model="payment.method" class="payment-radio" />
                <div class="payment-card__icon" v-html="m.icon"></div>
                <div class="payment-card__info">
                  <p class="payment-card__name">{{ m.name }}</p>
                  <p class="payment-card__desc">{{ m.desc }}</p>
                </div>
                <div class="payment-card__check">
                  <svg v-if="payment.method === m.id" width="18" height="18" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12" />
                  </svg>
                </div>
              </label>
            </div>

            <div class="form-actions">
              <button class="back-btn" @click="prevStep">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <line x1="19" y1="12" x2="5" y2="12" />
                  <polyline points="12 19 5 12 12 5" />
                </svg>
                Atrás
              </button>
              <button class="next-btn" @click="nextStep">
                Revisar Pedido
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <line x1="5" y1="12" x2="19" y2="12" />
                  <polyline points="12 5 19 12 12 19" />
                </svg>
              </button>
            </div>
          </div>

          <!-- STEP 2: Review -->
          <div v-if="currentStep === 2" class="form-section">
            <h2 class="form-section__title">Revisa tu Pedido</h2>

            <!-- Shipping review -->
            <div class="review-block">
              <div class="review-block__header">
                <p class="review-block__label">DIRECCIÓN DE ENVÍO</p>
                <button class="review-block__edit" @click="currentStep = 0">Editar</button>
              </div>
              <p class="review-block__text">
                {{ shipping.nombre_recibe }}<br />
                {{ shipping.direccion }}<br />
                {{ shipping.ciudad }}, {{ shipping.departamento }} {{ shipping.codigo_postal }}
              </p>
            </div>

            <!-- Payment review -->
            <div class="review-block">
              <div class="review-block__header">
                <p class="review-block__label">MÉTODO DE PAGO</p>
                <button class="review-block__edit" @click="currentStep = 1">Editar</button>
              </div>
              <p class="review-block__text">
                {{ selectedPaymentName }}
              </p>
            </div>

            <!-- Items review -->
            <div class="review-block">
              <p class="review-block__label">ARTÍCULOS DEL PEDIDO</p>
              <div class="review-items">
                <div v-for="item in cartItems" :key="item.id" class="review-item">
                  <img :src="item.image" :alt="item.name" class="review-item__img" />
                  <div class="review-item__info">
                    <p class="review-item__name">{{ item.name }}</p>
                    <p class="review-item__meta">Cant: {{ item.quantity }}</p>
                  </div>
                  <p class="review-item__price">{{ formatPrice(item.price * item.quantity) }}</p>
                </div>
              </div>
            </div>

            <div v-if="orderError" class="form-error">{{ orderError }}</div>

            <div class="form-actions">
              <button class="back-btn" @click="prevStep">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <line x1="19" y1="12" x2="5" y2="12" />
                  <polyline points="12 19 5 12 12 5" />
                </svg>
                Atrás
              </button>
              <button class="place-order-btn" @click="placeOrder" :disabled="placing">
                <span v-if="!placing">Realizar Pedido</span>
                <span v-else>Procesando...</span>
                <svg v-if="!placing" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                  stroke-width="2.5">
                  <polyline points="20 6 9 17 4 12" />
                </svg>
              </button>
            </div>
          </div>

          <!-- STEP 3: Confirmation -->
          <div v-if="currentStep === 3" class="form-section confirmation">
            <div class="confirmation__icon" :class="{ 'confirmation__icon--error': confirmStatus === 'failure' }">
              <svg v-if="confirmStatus !== 'failure'" width="64" height="64" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10" />
                <polyline points="16 8 10 16 7 13" />
              </svg>
              <svg v-else width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10" />
                <line x1="15" y1="9" x2="9" y2="15" />
                <line x1="9" y1="9" x2="15" y2="15" />
              </svg>
            </div>
            <h2 class="confirmation__title">{{ confirmTitle }}</h2>
            <p class="confirmation__subtitle">{{ confirmSubtitle }}</p>
            <p v-if="orderNumber" class="confirmation__order-number">Pedido #{{ orderNumber }}</p>
            <p class="confirmation__message">{{ confirmMessage }}</p>
            <div class="confirmation__btns">
              <router-link to="/mis-pedidos" class="confirmation__btn" v-if="confirmStatus !== 'failure'">
                Ver Mis Pedidos
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <line x1="5" y1="12" x2="19" y2="12" />
                  <polyline points="12 5 19 12 12 19" />
                </svg>
              </router-link>
              <router-link to="/products" class="confirmation__btn confirmation__btn--secondary">
                Seguir Comprando
              </router-link>
            </div>
          </div>

        </div>

        <!-- RIGHT: Order Summary (sticky) -->
        <div class="checkout__sidebar" v-if="currentStep < 3">
          <div class="summary__card">
            <p class="summary__title">Resumen del Pedido</p>

            <div class="summary__items">
              <div v-for="item in cartItems" :key="item.id" class="summary__item">
                <div class="summary__item-img-wrap">
                  <img :src="item.image" :alt="item.name" class="summary__item-img" />
                  <span class="summary__item-qty">{{ item.quantity }}</span>
                </div>
                <div class="summary__item-info">
                  <p class="summary__item-name">{{ item.name }}</p>
                  <p class="summary__item-category">{{ item.category }}</p>
                </div>
                <p class="summary__item-price">{{ formatPrice(item.price * item.quantity) }}</p>
              </div>
            </div>

            <div class="summary__divider"></div>

            <div class="summary__row">
              <span>Subtotal</span>
              <span>{{ formatPrice(subtotal) }}</span>
            </div>
            <div class="summary__row">
              <span>Envío</span>
              <span v-if="subtotal > 200000" class="shipping--free">Gratis</span>
              <span v-else>{{ formatPrice(15000) }}</span>
            </div>
            <div class="summary__row summary__row--total">
              <span>Total</span>
              <span class="total-amount">{{ formatPrice(total) }}</span>
            </div>

            <div class="summary__secure">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                <path d="M7 11V7a5 5 0 0110 0v4" />
              </svg>
              <span>Pago seguro cifrado con SSL</span>
            </div>
          </div>
        </div>

      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import axios from 'axios'
import { updateCartCount } from '../cartState'

const router = useRouter()
const route = useRoute()

const API = 'http://localhost:8000/api'

const steps = ['Envío', 'Pago', 'Revisión']
const currentStep = ref(0)
const placing = ref(false)
const orderNumber = ref('')
const orderError = ref('')
const shippingError = ref('')
const confirmStatus = ref('success')

// Cart data from API
const cartItems = ref([])

const fetchCart = async () => {
  const cartId = localStorage.getItem('carrito_id')
  if (!cartId) return

  try {
    const { data } = await axios.get(`${API}/carritos/${cartId}`)
    if (data && data.items && data.items.length > 0) {
      cartItems.value = data.items.map(item => {
        const v = item.variante
        const p = v.producto || {}

        let extra = parseFloat(v.precio_extra) || 0
        let base = parseFloat(p.precio_minorista || 0) + extra
        let descuentoPorcentaje = parseInt(v.descuento) || 0
        let precioFinal = base * (1 - descuentoPorcentaje / 100)

        let image = 'https://via.placeholder.com/400'
        if (p.imagenes && p.imagenes.length > 0) {
          const cover = p.imagenes.find(img => img.es_portada === 1)
          image = cover ? cover.url : p.imagenes[0].url
        }

        return {
          id: item.id,
          variante_id: item.variante_id,
          name: `${p.nombre || 'Producto'} (${v.color} - ${v.talla})`,
          category: p.categoria ? p.categoria.nombre : 'General',
          price: precioFinal,
          quantity: item.cantidad,
          image: image
        }
      })
    } else {
      // Cart empty - redirect to cart
      router.push('/cart')
    }
  } catch (error) {
    console.error('Error fetching cart:', error)
  }
}

onMounted(() => {
  // Check if user is logged in
  if (!localStorage.getItem('auth_token')) {
    router.push('/login')
    return
  }

  // Check if returning from Wompi
  const status = route.query.id || route.query.env
  if (route.query.status === 'wompi_return') {
    handleWompiReturn()
    return
  }

  fetchCart()
})

const handleWompiReturn = () => {
  const ordenId = route.query.orden_id
  currentStep.value = 3

  // We show a generic pending or success view since the webhook confirms it definitively
  confirmStatus.value = 'success'
  orderNumber.value = ordenId ? `ORD-${ordenId}` : ''
}

const subtotal = computed(() => cartItems.value.reduce((sum, item) => sum + (item.price * item.quantity), 0))
const shippingCost = computed(() => subtotal.value > 200000 ? 0 : 15000)
const total = computed(() => subtotal.value + shippingCost.value)

const formatPrice = (value) => {
  if (value === undefined || value === null) return '$ 0'
  return new Intl.NumberFormat('es-CO', {
    style: 'currency',
    currency: 'COP',
    minimumFractionDigits: 0
  }).format(value)
}

// Shipping form
const shipping = ref({
  nombre_recibe: '',
  telefono: '',
  direccion: '',
  departamento: '',
  ciudad: '',
  codigo_postal: '',
  referencia: ''
})

const notas_cliente = ref('')

// Payment
const payment = ref({
  method: 'wompi'
})

const paymentMethods = [
  {
    id: 'wompi',
    name: 'Pago en Línea (Wompi Bancolombia)',
    desc: 'Nequi, PSE, Tarjetas, Corresponsal, Bancolombia',
    icon: '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>'
  },
  {
    id: 'transferencia',
    name: 'Transferencia Bancaria',
    desc: 'Transferencia directa (confirmación manual)',
    icon: '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>'
  }
]

const selectedPaymentName = computed(() => {
  const m = paymentMethods.find(p => p.id === payment.value.method)
  return m ? m.name : ''
})

const confirmTitle = computed(() => {
  if (confirmStatus.value === 'success') return '¡Pedido Confirmado!'
  if (confirmStatus.value === 'pending') return 'Pago Pendiente'
  return 'Error en el Pago'
})

const confirmSubtitle = computed(() => {
  if (confirmStatus.value === 'success') return 'Gracias por tu compra. Tu pedido se ha realizado con éxito.'
  if (confirmStatus.value === 'pending') return 'Tu pago está siendo procesado. Te notificaremos cuando se confirme.'
  return 'Hubo un problema con tu pago. Por favor, intenta de nuevo.'
})

const confirmMessage = computed(() => {
  if (confirmStatus.value === 'success') return 'Se ha enviado un correo de confirmación a tu bandeja de entrada. Puedes hacer seguimiento desde Mis Pedidos.'
  if (confirmStatus.value === 'pending') return 'Una vez confirmado el pago, recibirás un correo de confirmación.'
  return 'Puedes intentar de nuevo o contactarnos si el problema persiste.'
})

const validateShipping = () => {
  shippingError.value = ''
  if (!shipping.value.nombre_recibe.trim()) {
    shippingError.value = 'El nombre de quien recibe es obligatorio'
    return false
  }
  if (!shipping.value.direccion.trim()) {
    shippingError.value = 'La dirección es obligatoria'
    return false
  }
  if (!shipping.value.departamento.trim()) {
    shippingError.value = 'El departamento es obligatorio'
    return false
  }
  if (!shipping.value.ciudad.trim()) {
    shippingError.value = 'La ciudad es obligatoria'
    return false
  }
  return true
}

const nextStep = () => {
  if (currentStep.value === 0 && !validateShipping()) return
  if (currentStep.value < 2) currentStep.value++
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const prevStep = () => {
  if (currentStep.value > 0) currentStep.value--
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const getAuthHeaders = () => {
  const token = localStorage.getItem('auth_token')
  return { headers: { Authorization: `Bearer ${token}` } }
}

const placeOrder = async () => {
  placing.value = true
  orderError.value = ''

  try {
    const token = localStorage.getItem('auth_token')
    const user = JSON.parse(localStorage.getItem('auth_user') || '{}')
    const cartId = localStorage.getItem('carrito_id')

    if (!token || !user.id || !cartId) {
      orderError.value = 'Debes iniciar sesión para continuar'
      placing.value = false
      return
    }

    // 1. Crear dirección
    const dirRes = await axios.post(`${API}/direcciones`, {
      usuario_id: user.id,
      nombre_recibe: shipping.value.nombre_recibe,
      telefono: shipping.value.telefono,
      departamento: shipping.value.departamento,
      ciudad: shipping.value.ciudad,
      direccion: shipping.value.direccion,
      referencia: shipping.value.referencia,
      codigo_postal: shipping.value.codigo_postal,
    }, getAuthHeaders())

    const direccionId = dirRes.data.data.id

    // 2. Crear orden desde carrito
    const ordenRes = await axios.post(`${API}/ordenes/crear`, {
      carrito_id: parseInt(cartId),
      direccion_id: direccionId,
      notas_cliente: notas_cliente.value,
    }, getAuthHeaders())

    const orden = ordenRes.data.data
    orderNumber.value = orden.numero

    // 3. Según método de pago
    if (payment.value.method === 'wompi') {
      try {
        const wompiRes = await axios.post(`${API}/wompi/generar-firma`, {
          orden_id: orden.id
        }, getAuthHeaders())

        const data = wompiRes.data;

        // Función para abrir el Widget
        const openWompi = () => {
          const checkout = new window.WidgetCheckout({
            currency: data.currency,
            amountInCents: parseInt(data.amount_in_cents, 10),
            reference: data.reference,
            publicKey: data.public_key,
            signature: { integrity: data.signature },
            redirectUrl: data.redirect_url
          });

          checkout.open(function (result) {
            // Callback en caso de que Wompi no redirija automáticamente
            window.location.href = data.redirect_url;
          });
        };

        // Cargar script dinámicamente si no existe
        // Cargar script de Wompi de forma confiable
        const cargarWompiYAbrir = () => {
          return new Promise((resolve) => {
            if (window.WidgetCheckout) {
              resolve();
            } else {
              // Remover script anterior si existe (evita duplicados)
              const existing = document.querySelector('script[src*="wompi"]');
              if (existing) existing.remove();

              const script = document.createElement('script');
              script.src = 'https://checkout.wompi.co/widget.js';
              script.onload = () => resolve();
              script.onerror = () => resolve(); // si falla, igual continuar
              document.body.appendChild(script);
            }
          });
        };

        await cargarWompiYAbrir();
        openWompi();
        await updateCartCount();
        placing.value = false;
        return;
      } catch (wompiError) {
        console.error('Error con Wompi:', wompiError)
        await updateCartCount()
        confirmStatus.value = 'pending'
        currentStep.value = 3
        window.scrollTo({ top: 0, behavior: 'smooth' })
      }
    } else {
      // Transferencia bancaria - orden queda pendiente
      // Registrar pago manual pendiente
      await axios.post(`${API}/pagos`, {
        orden_id: orden.id,
        metodo: 'transferencia',
        referencia_pasarela: null,
        monto: orden.total
      })

      await updateCartCount()
      confirmStatus.value = 'pending'
      currentStep.value = 3
      window.scrollTo({ top: 0, behavior: 'smooth' })
    }

  } catch (error) {
    console.error('Error placing order:', error)
    if (error.response?.status === 401) {
      // Token expirado o inválido, redirigir al login
      localStorage.removeItem('auth_token')
      localStorage.removeItem('auth_user')
      orderError.value = 'Tu sesión ha expirado. Redirigiendo al login...'
      setTimeout(() => router.push('/login'), 2000)
    } else {
      orderError.value = error.response?.data?.message || 'Error al procesar el pedido. Intenta de nuevo.'
    }
  } finally {
    placing.value = false
  }
}
</script>

<style scoped>
/* ── Base ── */
.checkout-page {
  font-family: 'Cormorant Garamond', 'Georgia', serif;
  padding-top: 100px;
  background: #faf8f4;
  min-height: 100vh;
}

/* ── Hero ── */
.checkout__hero {
  position: relative;
  background: #1a1a1a;
  padding: 80px 40px 60px;
}

.checkout__hero-bg {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, #1a1a1a 0%, #2a2a2a 100%);
  opacity: 0.95;
}

.checkout__hero-content {
  position: relative;
  z-index: 2;
  max-width: 1400px;
  margin: 0 auto;
}

.checkout__eyebrow {
  font-family: 'Inter', 'Helvetica Neue', sans-serif;
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.15em;
  color: rgba(255, 255, 255, 0.5);
  text-transform: uppercase;
  margin: 0 0 12px 0;
}

.checkout__title {
  font-size: clamp(42px, 5vw, 72px);
  font-weight: 800;
  line-height: 1;
  margin: 0;
  color: white;
}

.checkout__title--light {
  font-weight: 300;
  font-style: italic;
}

/* ── Stepper ── */
.stepper-wrap {
  background: #fff;
  border-bottom: 1px solid #ede8de;
  padding: 28px 40px;
}

.stepper {
  max-width: 600px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stepper__item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.stepper__circle {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #f0ebe3;
  border: 2px solid #e0d8cc;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  font-weight: 600;
  color: #aaa;
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.stepper__item--active .stepper__circle {
  background: #1a1a1a;
  border-color: #1a1a1a;
  color: white;
}

.stepper__item--done .stepper__circle {
  background: #7a9e7e;
  border-color: #7a9e7e;
  color: white;
}

.stepper__label {
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  font-weight: 500;
  color: #aaa;
  transition: color 0.3s ease;
}

.stepper__item--active .stepper__label {
  color: #1a1a1a;
  font-weight: 600;
}

.stepper__item--done .stepper__label {
  color: #7a9e7e;
}

.stepper__line {
  width: 60px;
  height: 2px;
  background: #e0d8cc;
  margin: 0 12px;
  border-radius: 2px;
  transition: background 0.3s ease;
}

.stepper__line--done {
  background: #7a9e7e;
}

/* ── Body ── */
.checkout__body {
  max-width: 1400px;
  margin: 0 auto;
  padding: 48px 40px 100px;
}

.checkout__layout {
  display: grid;
  grid-template-columns: 1fr 400px;
  gap: 60px;
  align-items: start;
  transition: all 0.3s ease;
}

.checkout__layout--centered {
  grid-template-columns: minmax(auto, 800px);
  justify-content: center;
}

/* ── Form Section ── */
.form-section {
  background: white;
  border-radius: 16px;
  padding: 40px;
  box-shadow: 0 2px 16px rgba(0, 0, 0, 0.04);
}

.form-section__title {
  font-size: 24px;
  font-weight: 700;
  color: #1a1a1a;
  margin: 0 0 32px 0;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 20px;
}

.form-label {
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  font-weight: 500;
  color: #444;
  display: flex;
  align-items: center;
  gap: 4px;
}

.required {
  color: #c0392b;
}

.optional {
  font-weight: 400;
  color: #bbb;
  font-size: 12px;
}

.form-input,
.form-textarea {
  width: 100%;
  padding: 13px 16px;
  border: 1px solid #e0ddd8;
  border-radius: 8px;
  font-family: 'Cormorant Garamond', serif;
  font-size: 15px;
  color: #1a1a1a;
  background: #fff;
  outline: none;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
  box-sizing: border-box;
}

.form-input:focus,
.form-textarea:focus {
  border-color: #1a1a1a;
  box-shadow: 0 0 0 3px rgba(26, 26, 26, 0.06);
}

.form-input::placeholder,
.form-textarea::placeholder {
  color: #bbb;
}

.form-textarea {
  resize: vertical;
  min-height: 80px;
  line-height: 1.6;
}

.form-error {
  background: #fef2f2;
  color: #991b1b;
  border: 1px solid #fecaca;
  padding: 12px 16px;
  border-radius: 10px;
  font-family: 'Inter', sans-serif;
  font-size: 14px;
  margin-bottom: 16px;
}

/* ── Buttons ── */
.next-btn,
.place-order-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  width: 100%;
  padding: 18px 32px;
  background: #1a1a1a;
  color: white;
  border: none;
  border-radius: 100px;
  font-family: 'Cormorant Garamond', serif;
  font-size: 17px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.25s ease;
  margin-top: 12px;
}

.next-btn:hover,
.place-order-btn:hover:not(:disabled) {
  background: #6b5f4e;
  transform: translateY(-1px);
}

.place-order-btn:disabled {
  background: #aaa;
  cursor: default;
}

.back-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  background: none;
  border: 1px solid #e0d8cc;
  padding: 14px 24px;
  border-radius: 100px;
  font-family: 'Cormorant Garamond', serif;
  font-size: 15px;
  font-weight: 600;
  color: #1a1a1a;
  cursor: pointer;
  transition: all 0.2s ease;
}

.back-btn:hover {
  border-color: #1a1a1a;
  background: #faf8f4;
}

.form-actions {
  display: flex;
  gap: 16px;
  margin-top: 12px;
}

.form-actions .next-btn,
.form-actions .place-order-btn {
  flex: 1;
}

/* ── Payment Methods ── */
.payment-methods {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 24px;
}

.payment-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 18px 20px;
  border: 1px solid #e0ddd8;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s ease;
  background: #fff;
}

.payment-card:hover {
  border-color: #bbb;
}

.payment-card--selected {
  border-color: #1a1a1a;
  background: #faf8f4;
  box-shadow: 0 0 0 1px #1a1a1a;
}

.payment-radio {
  display: none;
}

.payment-card__icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  background: #f0ebe3;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #6b5f4e;
  flex-shrink: 0;
}

.payment-card--selected .payment-card__icon {
  background: #1a1a1a;
  color: white;
}

.payment-card__info {
  flex: 1;
}

.payment-card__name {
  font-family: 'Inter', sans-serif;
  font-size: 14px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 0 0 2px 0;
}

.payment-card__desc {
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  color: #999;
  margin: 0;
}

.payment-card__check {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #7a9e7e;
}

/* ── Review ── */
.review-block {
  background: #faf8f4;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 20px;
}

.review-block__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.review-block__label {
  font-family: 'Inter', sans-serif;
  font-size: 10px;
  font-weight: 600;
  letter-spacing: 0.12em;
  color: #aaa;
  margin: 0;
}

.review-block__edit {
  background: none;
  border: none;
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  font-weight: 500;
  color: #6b5f4e;
  cursor: pointer;
  text-decoration: underline;
}

.review-block__edit:hover {
  color: #1a1a1a;
}

.review-block__text {
  font-size: 15px;
  line-height: 1.6;
  color: #444;
  margin: 0;
}

.review-items {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-top: 16px;
}

.review-item {
  display: flex;
  align-items: center;
  gap: 16px;
}

.review-item__img {
  width: 56px;
  height: 72px;
  object-fit: cover;
  border-radius: 8px;
}

.review-item__info {
  flex: 1;
}

.review-item__name {
  font-size: 15px;
  font-weight: 500;
  color: #1a1a1a;
  margin: 0 0 2px 0;
}

.review-item__meta {
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  color: #999;
  margin: 0;
}

.review-item__price {
  font-size: 15px;
  font-weight: 600;
  color: #6b5f4e;
  margin: 0;
}

/* ── Confirmation ── */
.confirmation {
  text-align: center;
  padding: 60px 40px;
  max-width: 600px;
  margin: 0 auto;
}

.confirmation__icon {
  color: #7a9e7e;
  margin-bottom: 24px;
  animation: confirmPop 0.5s ease;
}

.confirmation__icon--error {
  color: #c44a2c;
}

@keyframes confirmPop {
  0% {
    transform: scale(0.6);
    opacity: 0;
  }

  60% {
    transform: scale(1.1);
  }

  100% {
    transform: scale(1);
    opacity: 1;
  }
}

.confirmation__title {
  font-size: 36px;
  font-weight: 800;
  color: #1a1a1a;
  margin: 0 0 12px 0;
}

.confirmation__subtitle {
  font-size: 16px;
  color: #666;
  margin: 0 0 24px 0;
  line-height: 1.6;
}

.confirmation__order-number {
  font-family: 'Inter', sans-serif;
  font-size: 14px;
  font-weight: 600;
  color: #6b5f4e;
  background: #f5f0e8;
  display: inline-block;
  padding: 8px 20px;
  border-radius: 100px;
  margin: 0 0 20px 0;
}

.confirmation__message {
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  color: #999;
  line-height: 1.7;
  margin: 0 0 32px 0;
}

.confirmation__btns {
  display: flex;
  flex-direction: column;
  gap: 12px;
  align-items: center;
}

.confirmation__btn {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  background: #1a1a1a;
  color: white;
  padding: 16px 32px;
  border-radius: 100px;
  text-decoration: none;
  font-family: 'Cormorant Garamond', serif;
  font-size: 16px;
  font-weight: 600;
  transition: all 0.25s ease;
}

.confirmation__btn:hover {
  background: #6b5f4e;
  gap: 14px;
}

.confirmation__btn--secondary {
  background: transparent;
  color: #6b5f4e;
  border: 1px solid #e0d8cc;
}

.confirmation__btn--secondary:hover {
  background: #faf8f4;
  border-color: #1a1a1a;
  color: #1a1a1a;
}

/* ── Sidebar: Summary ── */
.checkout__sidebar {
  position: sticky;
  top: 100px;
  align-self: start;
}

.summary__card {
  background: white;
  border-radius: 16px;
  padding: 32px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.summary__title {
  font-size: 20px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 0 0 24px 0;
  letter-spacing: -0.02em;
}

.summary__items {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-bottom: 20px;
}

.summary__item {
  display: flex;
  align-items: center;
  gap: 14px;
}

.summary__item-img-wrap {
  position: relative;
  flex-shrink: 0;
}

.summary__item-img {
  width: 56px;
  height: 72px;
  object-fit: cover;
  border-radius: 8px;
}

.summary__item-qty {
  position: absolute;
  top: -6px;
  right: -6px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #1a1a1a;
  color: white;
  font-family: 'Inter', sans-serif;
  font-size: 10px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
}

.summary__item-info {
  flex: 1;
}

.summary__item-name {
  font-size: 14px;
  font-weight: 500;
  color: #1a1a1a;
  margin: 0 0 2px 0;
}

.summary__item-category {
  font-family: 'Inter', sans-serif;
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.1em;
  color: #aaa;
  margin: 0;
}

.summary__item-price {
  font-size: 14px;
  font-weight: 600;
  color: #6b5f4e;
  margin: 0;
}

.summary__divider {
  height: 1px;
  background: #f0ebe3;
  margin: 4px 0 16px;
}

.summary__row {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  font-family: 'Inter', sans-serif;
  font-size: 14px;
  color: #555;
}

.summary__row--total {
  padding-top: 16px;
  margin-top: 8px;
  border-top: 1px solid #f0ebe3;
  font-weight: 700;
  font-size: 18px;
  color: #1a1a1a;
}

.total-amount {
  color: #6b5f4e;
  font-size: 20px;
  font-weight: 700;
}

.shipping--free {
  color: #7a9e7e;
  font-weight: 500;
}

.summary__secure {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-top: 20px;
  padding-top: 16px;
  border-top: 1px solid #f0ebe3;
  font-family: 'Inter', sans-serif;
  font-size: 11px;
  color: #aaa;
}

.summary__secure svg {
  color: #7a9e7e;
}

/* ── Responsive ── */
@media (max-width: 900px) {
  .checkout__layout {
    grid-template-columns: 1fr;
    gap: 32px;
  }

  .checkout__body {
    padding: 32px 20px 60px;
  }

  .checkout__hero {
    padding: 60px 20px 40px;
  }

  .stepper-wrap {
    padding: 20px 16px;
    overflow-x: auto;
  }

  .stepper__line {
    width: 30px;
    margin: 0 6px;
  }

  .stepper__label {
    font-size: 11px;
  }

  .form-section {
    padding: 28px 20px;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .form-actions {
    flex-direction: column-reverse;
  }

  .checkout__sidebar {
    position: static;
  }

  .confirmation {
    padding: 40px 20px;
  }
}
</style>
