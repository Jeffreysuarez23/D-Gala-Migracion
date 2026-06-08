<template>
  <div class="detail-page">

    <!-- ─── BREADCRUMB ── -->
    <div class="detail__breadcrumb-wrap">
      <div class="detail__breadcrumb">
        <router-link to="/" class="breadcrumb__link">Inicio</router-link>
        <span class="breadcrumb__sep">/</span>
        <router-link to="/products" class="breadcrumb__link">Productos</router-link>
        <span class="breadcrumb__sep">/</span>
        <span class="breadcrumb__current">{{ product.name }}</span>
      </div>
    </div>

    <!-- ─── PRODUCT LAYOUT ── -->
    <div class="detail__inner">
      <div class="detail__layout">

        <!-- LEFT: Gallery -->
        <div class="detail__gallery">
          <div class="gallery__main">
            <img :src="activeImage" :alt="product.name" class="gallery__main-img" />
            <span
              v-if="product.badge"
              class="gallery__badge"
              :class="`gallery__badge--${product.badgeType}`"
            >
              {{ product.badge }}
            </span>
          </div>
          <div class="gallery__thumbs">
            <button
              v-for="(img, i) in product.images"
              :key="i"
              class="gallery__thumb"
              :class="{ 'gallery__thumb--active': activeImageIndex === i }"
              @click="activeImageIndex = i"
            >
              <img :src="img" :alt="`${product.name} view ${i + 1}`" />
            </button>
          </div>
        </div>

        <!-- RIGHT: Info -->
        <div class="detail__info">
          <p class="detail__category">{{ product.category }}</p>
          <h1 class="detail__name">{{ product.name }}</h1>

          <div class="detail__pricing">
            <span class="detail__price">${{ currentPrice.toFixed(2) }}</span>
            <span v-if="product.originalPrice" class="detail__original">${{ product.originalPrice.toFixed(2) }}</span>
            <span v-if="product.originalPrice" class="detail__discount">
              -{{ Math.round((1 - product.price / product.originalPrice) * 100) }}%
            </span>
          </div>

          <div class="detail__rating">
            <div class="detail__stars">
              <span v-for="n in 5" :key="n" class="star" :class="{ 'star--filled': n <= Math.round(product.rating) }">★</span>
            </div>
            <span class="detail__rating-text">{{ product.rating }} ({{ product.reviews }} reseñas)</span>
          </div>

          <p class="detail__description">{{ product.description }}</p>

          <div class="detail__divider"></div>

          <!-- Color Selector -->
          <div class="detail__option">
            <p class="detail__option-label">
              Color: <span class="detail__option-value">{{ selectedColor }}</span>
            </p>
            <div class="color-options">
              <button
                v-for="color in product.colors"
                :key="color.name"
                class="color-swatch"
                :class="{ 'color-swatch--active': selectedColor === color.name }"
                :style="{ background: color.hex }"
                :title="color.name"
                @click="selectedColor = color.name"
              >
                <svg v-if="selectedColor === color.name" width="14" height="14" viewBox="0 0 24 24" fill="none" :stroke="color.checkColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                  <polyline points="20 6 9 17 4 12"/>
                </svg>
              </button>
            </div>
          </div>

          <!-- Size Selector -->
          <div class="detail__option">
            <p class="detail__option-label">
              Talla: <span class="detail__option-value">{{ selectedSize }}</span>
            </p>
            <div class="size-options">
              <button
                v-for="size in product.sizes"
                :key="size.label"
                class="size-btn"
                :class="{
                  'size-btn--active': selectedSize === size.label,
                  'size-btn--disabled': !size.inStock
                }"
                :disabled="!size.inStock"
                @click="selectedSize = size.label"
              >
                {{ size.label }}
              </button>
            </div>
          </div>

          <!-- Quantity -->
          <div class="detail__option">
            <p class="detail__option-label">Cantidad</p>
            <div class="quantity-selector">
              <button class="qty-btn" @click="quantity > 1 && quantity--" :disabled="quantity <= 1">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
              </button>
              <span class="qty-value">{{ quantity }}</span>
              <button class="qty-btn" @click="quantity++">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <line x1="12" y1="5" x2="12" y2="19"/>
                  <line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
              </button>
            </div>
          </div>

          <div class="detail__divider"></div>

          <!-- Actions -->
          <div class="detail__actions">
            <button class="add-to-cart-btn" @click="addToCart">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/>
              </svg>
              <span v-if="!added">Añadir al Carrito — ${{ (currentPrice * quantity).toFixed(2) }}</span>
              <span v-else>Añadido ✓</span>
            </button>
          </div>

          <!-- Shipping info -->
          <div class="detail__shipping-info">
            <div class="shipping-item">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>
              </svg>
              <span>Envío gratis por más de $200</span>
            </div>
            <div class="shipping-item">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 11-2.12-9.36L23 10"/>
              </svg>
              <span>Devoluciones fáciles (30 días)</span>
            </div>
            <div class="shipping-item">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0110 0v4"/>
              </svg>
              <span>Pago seguro</span>
            </div>
          </div>
        </div>

      </div>
    </div>

  </div>
</template>

<script>
export default {
  name: 'ProductDetailView',
  data() {
    return {
      activeImageIndex: 0,
      selectedColor: '',
      selectedSize: '',
      quantity: 1,
      added: false,
      // Sample products - in production these come from API
      allProducts: [
        {
          id: 1,
          name: 'Blazer Oversize de Lino',
          category: 'ABRIGOS',
          price: 189,
          originalPrice: 240,
          badge: 'Oferta',
          badgeType: 'dark',
          rating: 4.8,
          reviews: 124,
          description: 'Confeccionado en lino europeo de primera calidad, este blazer de ajuste relajado presenta un hombro estructurado y cierre de un solo botón. Perfecto para combinar.',
          images: [
            'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=800&q=80',
            'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&q=80',
            'https://images.unsplash.com/photo-1594938298603-c8148c4b9f50?w=800&q=80'
          ],
          colors: [
            { name: 'Arena', hex: '#c8b89a', checkColor: '#1a1a1a' },
            { name: 'Carbón', hex: '#3a3a3a', checkColor: '#fff' },
            { name: 'Marfil', hex: '#f0ebe3', checkColor: '#1a1a1a' }
          ],
          sizes: [
            { label: 'XS', inStock: true },
            { label: 'S', inStock: true },
            { label: 'M', inStock: true },
            { label: 'L', inStock: true },
            { label: 'XL', inStock: false }
          ]
        },
        {
          id: 2,
          name: 'Suéter de Merino Acanalado',
          category: 'TEJIDOS',
          price: 145,
          originalPrice: null,
          badge: 'Más Vendido',
          badgeType: 'light',
          rating: 4.9,
          reviews: 89,
          description: 'Hecho de lana merino australiana ultra fina, este suéter acanalado ofrece una sensación lujosamente suave. Un esencial atemporal para los meses más fríos.',
          images: [
            'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&q=80',
            'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800&q=80',
            'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&q=80'
          ],
          colors: [
            { name: 'Avena', hex: '#d4c5a9', checkColor: '#1a1a1a' },
            { name: 'Marino', hex: '#1e2d4a', checkColor: '#fff' },
            { name: 'Bosque', hex: '#3a5a40', checkColor: '#fff' }
          ],
          sizes: [
            { label: 'XS', inStock: true },
            { label: 'S', inStock: true },
            { label: 'M', inStock: true },
            { label: 'L', inStock: true },
            { label: 'XL', inStock: true }
          ]
        },
        {
          id: 3,
          name: 'Pantalones de Pierna Ancha',
          category: 'PANTALONES',
          price: 129,
          originalPrice: null,
          badge: null,
          badgeType: null,
          rating: 4.7,
          reviews: 67,
          description: 'De cintura alta y fluidos, estos pantalones de pierna ancha caen maravillosamente y se mueven contigo. Hechos de una mezcla de algodón y lino.',
          images: [
            'https://images.unsplash.com/photo-1594938298603-c8148c4b9f50?w=800&q=80',
            'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=800&q=80',
            'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800&q=80'
          ],
          colors: [
            { name: 'Negro', hex: '#1a1a1a', checkColor: '#fff' },
            { name: 'Topos', hex: '#b5a892', checkColor: '#1a1a1a' }
          ],
          sizes: [
            { label: 'XS', inStock: false },
            { label: 'S', inStock: true },
            { label: 'M', inStock: true },
            { label: 'L', inStock: true },
            { label: 'XL', inStock: true }
          ]
        },
        {
          id: 4,
          name: 'Bolso Cruzado de Cuero',
          category: 'ACCESORIOS',
          price: 295,
          originalPrice: null,
          badge: 'Nuevo',
          badgeType: 'outline',
          rating: 4.9,
          reviews: 203,
          description: 'Hecho a mano con cuero italiano de plena flor, este bolso cruzado cuenta con correa ajustable y cierre magnético. Envejece maravillosamente con el tiempo.',
          images: [
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&q=80',
            'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&q=80',
            'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&q=80'
          ],
          colors: [
            { name: 'Cognac', hex: '#8b5e3c', checkColor: '#fff' },
            { name: 'Negro', hex: '#1a1a1a', checkColor: '#fff' },
            { name: 'Canela', hex: '#c8a96e', checkColor: '#1a1a1a' }
          ],
          sizes: [
            { label: 'Única', inStock: true }
          ]
        },
        {
          id: 5,
          name: 'Vestido de Seda',
          category: 'VESTIDOS',
          price: 215,
          originalPrice: null,
          badge: null,
          badgeType: null,
          rating: 4.6,
          reviews: 45,
          description: 'Un vestido fluido de seda con escote en V y delicados tirantes de espagueti. El corte al bies sigue tu silueta de forma natural.',
          images: [
            'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800&q=80',
            'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&q=80',
            'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=800&q=80'
          ],
          colors: [
            { name: 'Champán', hex: '#f0e5c9', checkColor: '#1a1a1a' },
            { name: 'Noir', hex: '#1a1a1a', checkColor: '#fff' }
          ],
          sizes: [
            { label: 'XS', inStock: true },
            { label: 'S', inStock: true },
            { label: 'M', inStock: true },
            { label: 'L', inStock: false },
            { label: 'XL', inStock: false }
          ]
        },
        {
          id: 6,
          name: 'Camisa de Popelín de Algodón',
          category: 'TOPS',
          price: 98,
          originalPrice: null,
          badge: null,
          badgeType: null,
          rating: 4.7,
          reviews: 156,
          description: 'Una impecable camisa de popelín de algodón con un ajuste holgado y oversize. Cuenta con botones de nácar.',
          images: [
            'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&q=80',
            'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&q=80',
            'https://images.unsplash.com/photo-1594938298603-c8148c4b9f50?w=800&q=80'
          ],
          colors: [
            { name: 'Blanco', hex: '#ffffff', checkColor: '#1a1a1a' },
            { name: 'Azul Claro', hex: '#a8c4db', checkColor: '#1a1a1a' },
            { name: 'Rayas', hex: 'repeating-linear-gradient(90deg, #fff 0px, #fff 3px, #c8c8c8 3px, #c8c8c8 4px)', checkColor: '#1a1a1a' }
          ],
          sizes: [
            { label: 'XS', inStock: true },
            { label: 'S', inStock: true },
            { label: 'M', inStock: true },
            { label: 'L', inStock: true },
            { label: 'XL', inStock: true }
          ]
        },
        {
          id: 7,
          name: 'Cárdigan de Cachemira',
          category: 'TEJIDOS',
          price: 265,
          originalPrice: 320,
          badge: 'Oferta',
          badgeType: 'dark',
          rating: 4.9,
          reviews: 78,
          description: 'Cachemira mongola pura, suave como la mantequilla al tacto. Este cárdigan abierto presenta puños acanalados.',
          images: [
            'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800&q=80',
            'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&q=80',
            'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=800&q=80'
          ],
          colors: [
            { name: 'Camello', hex: '#c8a96e', checkColor: '#1a1a1a' },
            { name: 'Gris', hex: '#9a9a9a', checkColor: '#1a1a1a' },
            { name: 'Negro', hex: '#1a1a1a', checkColor: '#fff' }
          ],
          sizes: [
            { label: 'XS', inStock: true },
            { label: 'S', inStock: true },
            { label: 'M', inStock: true },
            { label: 'L', inStock: true },
            { label: 'XL', inStock: false }
          ]
        },
        {
          id: 8,
          name: 'Botas Chelsea de Cuero',
          category: 'CALZADO',
          price: 345,
          originalPrice: null,
          badge: 'Nuevo',
          badgeType: 'outline',
          rating: 4.8,
          reviews: 92,
          description: 'Hechas a mano en Portugal en cuero de becerro pulido. Cuenta con paneles laterales elásticos, suela de cuero y un cómodo tacón bajo.',
          images: [
            'https://images.unsplash.com/photo-1638247025967-b4e38f787b76?w=800&q=80',
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&q=80',
            'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&q=80'
          ],
          colors: [
            { name: 'Negro', hex: '#1a1a1a', checkColor: '#fff' },
            { name: 'Marrón', hex: '#6b4226', checkColor: '#fff' }
          ],
          sizes: [
            { label: '38', inStock: true },
            { label: '39', inStock: true },
            { label: '40', inStock: true },
            { label: '41', inStock: true },
            { label: '42', inStock: true },
            { label: '43', inStock: false }
          ]
        }
      ]
    }
  },
  computed: {
    product() {
      const id = parseInt(this.$route.params.id)
      return this.allProducts.find(p => p.id === id) || this.allProducts[0]
    },
    activeImage() {
      return this.product.images[this.activeImageIndex] || this.product.images[0]
    },
    currentPrice() {
      return this.product.price
    }
  },
  watch: {
    product: {
      handler(p) {
        if (p) {
          this.selectedColor = p.colors[0]?.name || ''
          this.selectedSize = p.sizes.find(s => s.inStock)?.label || ''
          this.activeImageIndex = 0
          this.quantity = 1
          this.added = false
        }
      },
      immediate: true
    }
  },
  methods: {
    addToCart() {
      if (!this.selectedSize) return
      this.added = true
      this.$emit('add-to-cart', {
        product: this.product,
        color: this.selectedColor,
        size: this.selectedSize,
        quantity: this.quantity
      })
      setTimeout(() => { this.added = false }, 2500)
    }
  }
}
</script>

<style scoped>
.detail-page {
  padding-top: 100px;
  min-height: 100vh;
  background: #fff;
  font-family: 'Cormorant Garamond', 'Georgia', serif;
  color: #1a1a1a;
}

/* ── Breadcrumb ── */
.detail__breadcrumb-wrap {
  background: #faf8f4;
  border-bottom: 1px solid #ede8de;
  padding: 16px 40px;
}

.detail__breadcrumb {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 8px;
  font-family: 'Inter', sans-serif;
  font-size: 12px;
}

.breadcrumb__link {
  color: #999;
  text-decoration: none;
  transition: color 0.2s;
}

.breadcrumb__link:hover {
  color: #1a1a1a;
}

.breadcrumb__sep {
  color: #ddd;
}

.breadcrumb__current {
  color: #1a1a1a;
  font-weight: 600;
}

/* ── Layout ── */
.detail__inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 36px 40px 80px;
}

.detail__layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 56px;
  align-items: start;
}

/* ── Gallery ── */
.gallery__main {
  position: relative;
  border-radius: 12px;
  overflow: hidden;
  background: #f5f3ef;
  aspect-ratio: 1 / 1;
  max-height: 480px;
  margin-bottom: 12px;
}

.gallery__main-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.6s ease;
}

.gallery__main:hover .gallery__main-img {
  transform: scale(1.03);
}

.gallery__badge {
  position: absolute;
  top: 14px;
  left: 14px;
  padding: 5px 14px;
  border-radius: 100px;
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.03em;
  z-index: 2;
}

.gallery__badge--dark { background: #1a1a1a; color: white; }
.gallery__badge--light { background: #f5f0e8; color: #7a6a50; border: 1px solid #e0d5c0; }
.gallery__badge--outline { background: white; color: #1a1a1a; border: 1px solid #d0cdc8; }

.gallery__thumbs {
  display: flex;
  gap: 12px;
}

.gallery__thumb {
  width: 64px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  border: 2px solid transparent;
  background: #f5f3ef;
  cursor: pointer;
  padding: 0;
  transition: border-color 0.2s ease, opacity 0.2s ease;
}

.gallery__thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.gallery__thumb--active {
  border-color: #1a1a1a;
}

.gallery__thumb:not(.gallery__thumb--active):hover {
  opacity: 0.7;
}

/* ── Info ── */
.detail__category {
  font-family: 'Inter', sans-serif;
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.15em;
  color: #aaa;
  text-transform: uppercase;
  margin: 0 0 10px 0;
}

.detail__name {
  font-size: clamp(22px, 2.5vw, 30px);
  font-weight: 700;
  line-height: 1.2;
  margin: 0 0 14px 0;
  color: #1a1a1a;
}

.detail__pricing {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.detail__price {
  font-size: 22px;
  font-weight: 700;
  color: #1a1a1a;
}

.detail__original {
  font-size: 15px;
  color: #bbb;
  text-decoration: line-through;
}

.detail__discount {
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  font-weight: 600;
  background: #fce4e4;
  color: #c0392b;
  padding: 4px 10px;
  border-radius: 100px;
}

.detail__rating {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 20px;
}

.detail__stars {
  display: flex;
  gap: 2px;
}

.star {
  font-size: 16px;
  color: #e0d8cc;
}

.star--filled {
  color: #f5a623;
}

.detail__rating-text {
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  color: #888;
}

.detail__description {
  font-size: 14px;
  line-height: 1.65;
  color: #666;
  margin: 0;
}

.detail__divider {
  height: 1px;
  background: #f0ebe3;
  margin: 20px 0;
}

/* ── Options ── */
.detail__option {
  margin-bottom: 18px;
}

.detail__option-label {
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  font-weight: 500;
  color: #444;
  margin: 0 0 8px 0;
}

.detail__option-value {
  font-weight: 600;
  color: #1a1a1a;
}

/* Colors */
.color-options {
  display: flex;
  gap: 10px;
}

.color-swatch {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: 2px solid transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  transition: all 0.2s ease;
  box-shadow: inset 0 0 0 1px rgba(0,0,0,0.08);
}

.color-swatch:hover {
  transform: scale(1.1);
}

.color-swatch--active {
  border-color: #1a1a1a;
  box-shadow: 0 0 0 2px #fff, 0 0 0 4px #1a1a1a;
}

/* Sizes */
.size-options {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.size-btn {
  min-width: 42px;
  height: 38px;
  padding: 0 14px;
  border: 1px solid #e0ddd8;
  border-radius: 8px;
  background: white;
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  font-weight: 500;
  color: #444;
  cursor: pointer;
  transition: all 0.2s ease;
}

.size-btn:hover:not(:disabled) {
  border-color: #1a1a1a;
  color: #1a1a1a;
}

.size-btn--active {
  background: #1a1a1a;
  border-color: #1a1a1a;
  color: white;
}

.size-btn--disabled {
  opacity: 0.35;
  cursor: not-allowed;
  text-decoration: line-through;
}

/* Quantity */
.quantity-selector {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  background: #f5f0e8;
  border-radius: 100px;
  padding: 6px 14px;
}

.qty-btn {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: white;
  border: 1px solid #d0cdc8;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: #1a1a1a;
  transition: all 0.2s ease;
}

.qty-btn:hover:not(:disabled) {
  background: #1a1a1a;
  color: white;
  border-color: #1a1a1a;
}

.qty-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.qty-value {
  font-family: 'Inter', sans-serif;
  font-weight: 600;
  font-size: 15px;
  min-width: 28px;
  text-align: center;
}

/* ── Actions ── */
.detail__actions {
  margin-bottom: 28px;
}

.add-to-cart-btn {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 16px 28px;
  background: #1a1a1a;
  color: white;
  border: none;
  border-radius: 100px;
  font-family: 'Cormorant Garamond', serif;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.25s ease;
}

.add-to-cart-btn:hover {
  background: #6b5f4e;
  transform: translateY(-1px);
}

/* ── Shipping info ── */
.detail__shipping-info {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.shipping-item {
  display: flex;
  align-items: center;
  gap: 10px;
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  color: #888;
}

.shipping-item svg {
  color: #7a9e7e;
  flex-shrink: 0;
}

/* ── Responsive ── */
@media (max-width: 900px) {
  .detail__layout {
    grid-template-columns: 1fr;
    gap: 40px;
  }

  .detail__inner {
    padding: 32px 20px 60px;
  }

  .detail__breadcrumb-wrap {
    padding: 14px 20px;
  }

  .gallery__thumbs {
    gap: 8px;
  }

  .gallery__thumb {
    width: 60px;
    height: 76px;
  }
}
</style>
