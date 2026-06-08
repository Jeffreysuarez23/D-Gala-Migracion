<template>
  <div class="products-page">
    <div class="products__inner">

      <!-- ─── HEADER ── -->
      <div class="products__header">
        <div>
          <p class="eyebrow">/ NUESTRA COLECCIÓN</p>
          <h1 class="products__title">
            <strong>Todos los</strong> Productos
          </h1>
        </div>
        <span class="products__count">{{ filteredProducts.length }} artículos</span>
      </div>

      <!-- ─── FILTERS BAR ── -->
      <div class="filters-bar">
        <div class="filters-bar__categories">
          <button
            v-for="cat in categories"
            :key="cat"
            class="filter-btn"
            :class="{ 'filter-btn--active': activeCategory === cat }"
            @click="activeCategory = cat"
          >
            {{ cat }}
          </button>
        </div>

        <div class="filters-bar__sorts">
          <select class="sort-select" v-model="priceFilter">
            <option value="">Todos los precios</option>
            <option value="under100">Menos de $100</option>
            <option value="100to200">$100 – $200</option>
            <option value="over200">Más de $200</option>
          </select>
          <select class="sort-select" v-model="sortBy">
            <option value="featured">Destacados</option>
            <option value="price-asc">Precio: Menor a Mayor</option>
            <option value="price-desc">Precio: Mayor a Menor</option>
            <option value="rating">Mejor Calificados</option>
          </select>
        </div>
      </div>

      <!-- ─── PRODUCTS GRID ── -->
      <div class="products__grid">
        <div
          v-for="product in filteredProducts"
          :key="product.id"
          class="product-card"
        >
          <div class="product-card__image-wrap" @click="goToProduct(product.id)">
            <img :src="product.image" :alt="product.name" class="product-card__image" />
            <span
              v-if="product.badge"
              class="product-card__badge"
              :class="`product-card__badge--${product.badgeType}`"
            >
              {{ product.badge }}
            </span>
            <button class="product-card__quick-add" @click="addToCart(product)">
              Añadir al Carrito
            </button>
          </div>

          <div class="product-card__info">
            <p class="product-card__category">{{ product.category }}</p>
            <p class="product-card__name">{{ product.name }}</p>
            <div class="product-card__pricing">
              <span class="product-card__price">${{ product.price }}</span>
              <span v-if="product.originalPrice" class="product-card__original">${{ product.originalPrice }}</span>
            </div>
            <div class="product-card__rating">
              <span class="star">★</span>
              <span class="rating-value">{{ product.rating }}</span>
              <span class="rating-count">({{ product.reviews }})</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty state -->
      <div v-if="filteredProducts.length === 0" class="products__empty">
        <p>No se encontraron productos para este filtro.</p>
      </div>

    </div>
  </div>
</template>

<script>
export default {
  name: 'ProductsView',
  data() {
    return {
      activeCategory: 'Todos',
      priceFilter: '',
      sortBy: 'featured',
      categories: ['Todos', 'Abrigos', 'Tejidos', 'Pantalones', 'Vestidos', 'Tops', 'Accesorios', 'Calzado'],
      products: [
        {
          id: 1,
          name: 'Blazer Oversize de Lino',
          category: 'Abrigos',
          price: 189,
          originalPrice: 240,
          badge: 'Oferta',
          badgeType: 'dark',
          rating: 4.8,
          reviews: 124,
          image: 'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=600&q=80'
        },
        {
          id: 2,
          name: 'Suéter de Merino Acanalado',
          category: 'Tejidos',
          price: 145,
          originalPrice: null,
          badge: 'Más Vendido',
          badgeType: 'light',
          rating: 4.9,
          reviews: 89,
          image: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=600&q=80'
        },
        {
          id: 3,
          name: 'Pantalones de Pierna Ancha',
          category: 'Pantalones',
          price: 129,
          originalPrice: null,
          badge: null,
          badgeType: null,
          rating: 4.7,
          reviews: 67,
          image: 'https://images.unsplash.com/photo-1594938298603-c8148c4b9f50?w=600&q=80'
        },
        {
          id: 4,
          name: 'Bolso Cruzado de Cuero',
          category: 'Accesorios',
          price: 295,
          originalPrice: null,
          badge: 'Nuevo',
          badgeType: 'outline',
          rating: 4.9,
          reviews: 203,
          image: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&q=80'
        },
        {
          id: 5,
          name: 'Vestido de Seda',
          category: 'Vestidos',
          price: 215,
          originalPrice: null,
          badge: null,
          badgeType: null,
          rating: 4.6,
          reviews: 45,
          image: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=600&q=80'
        },
        {
          id: 6,
          name: 'Camisa de Popelín de Algodón',
          category: 'Tops',
          price: 98,
          originalPrice: null,
          badge: null,
          badgeType: null,
          rating: 4.7,
          reviews: 156,
          image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&q=80'
        },
        {
          id: 7,
          name: 'Cárdigan de Cachemira',
          category: 'Tejidos',
          price: 265,
          originalPrice: 320,
          badge: 'Oferta',
          badgeType: 'dark',
          rating: 4.9,
          reviews: 78,
          image: 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=600&q=80'
        },
        {
          id: 8,
          name: 'Botas Chelsea de Cuero',
          category: 'Calzado',
          price: 345,
          originalPrice: null,
          badge: 'Nuevo',
          badgeType: 'outline',
          rating: 4.8,
          reviews: 92,
          image: 'https://images.unsplash.com/photo-1638247025967-b4e38f787b76?w=600&q=80'
        }
      ]
    }
  },
  computed: {
    filteredProducts() {
      let list = [...this.products]

      // Category filter
      if (this.activeCategory !== 'Todos') {
        list = list.filter(p => p.category === this.activeCategory)
      }

      // Price filter
      if (this.priceFilter === 'under100') {
        list = list.filter(p => p.price < 100)
      } else if (this.priceFilter === '100to200') {
        list = list.filter(p => p.price >= 100 && p.price <= 200)
      } else if (this.priceFilter === 'over200') {
        list = list.filter(p => p.price > 200)
      }

      // Sort
      if (this.sortBy === 'price-asc') {
        list.sort((a, b) => a.price - b.price)
      } else if (this.sortBy === 'price-desc') {
        list.sort((a, b) => b.price - a.price)
      } else if (this.sortBy === 'rating') {
        list.sort((a, b) => b.rating - a.rating)
      }

      return list
    }
  },
  methods: {
    addToCart(product) {
      this.$emit('add-to-cart', product)
    },
    goToProduct(id) {
      this.$router.push(`/product/${id}`)
    }
  }
}
</script>

<style scoped>
.products-page {
  padding-top: 100px;
  min-height: 100vh;
  background: #fff;
  font-family: 'Cormorant Garamond', 'Georgia', serif;
}

.products__inner {
  max-width: 1400px;
  margin: 0 auto;
  padding: 48px 40px 80px;
}

/* ── Header ── */
.eyebrow {
  font-family: 'Inter', sans-serif;
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.15em;
  color: #999;
  margin: 0 0 10px 0;
}

.products__header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-bottom: 40px;
}

.products__title {
  font-size: clamp(32px, 4vw, 48px);
  font-weight: 300;
  color: #1a1a1a;
  margin: 0;
  line-height: 1.1;
}

.products__title strong {
  font-weight: 800;
}

.products__count {
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  color: #aaa;
  padding-bottom: 8px;
}

/* ── Filters Bar ── */
.filters-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20px 0;
  border-top: 1px solid #f0ede8;
  border-bottom: 1px solid #f0ede8;
  margin-bottom: 48px;
  gap: 16px;
  flex-wrap: wrap;
}

.filters-bar__categories {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.filter-btn {
  padding: 8px 20px;
  border-radius: 100px;
  border: 1px solid #ddd;
  background: transparent;
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  font-weight: 500;
  color: #555;
  cursor: pointer;
  transition: all 0.2s ease;
  white-space: nowrap;
}

.filter-btn:hover {
  border-color: #1a1a1a;
  color: #1a1a1a;
}

.filter-btn--active {
  background: #1a1a1a;
  border-color: #1a1a1a;
  color: white;
}

.filters-bar__sorts {
  display: flex;
  gap: 12px;
}

.sort-select {
  padding: 8px 36px 8px 16px;
  border-radius: 8px;
  border: 1px solid #ddd;
  background: white;
  font-family: 'Inter', sans-serif;
  font-size: 13px;
  color: #555;
  cursor: pointer;
  outline: none;
  appearance: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 12px center;
  transition: border-color 0.2s ease;
}

.sort-select:focus {
  border-color: #1a1a1a;
}

/* ── Product Grid ── */
.products__grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 28px 24px;
}

.product-card {
  cursor: pointer;
}

.product-card__image-wrap {
  position: relative;
  border-radius: 12px;
  overflow: hidden;
  background: #f5f3ef;
  aspect-ratio: 3 / 4;
  margin-bottom: 16px;
}

.product-card__image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.product-card:hover .product-card__image {
  transform: scale(1.04);
}

.product-card__badge {
  position: absolute;
  top: 14px;
  left: 14px;
  padding: 6px 14px;
  border-radius: 100px;
  font-family: 'Inter', sans-serif;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.03em;
  z-index: 2;
}

.product-card__badge--dark {
  background: #1a1a1a;
  color: white;
}

.product-card__badge--light {
  background: #f5f0e8;
  color: #7a6a50;
  border: 1px solid #e0d5c0;
}

.product-card__badge--outline {
  background: white;
  color: #1a1a1a;
  border: 1px solid #d0cdc8;
}

.product-card__quick-add {
  position: absolute;
  bottom: 14px;
  left: 50%;
  transform: translateX(-50%) translateY(8px);
  opacity: 0;
  white-space: nowrap;
  padding: 10px 24px;
  border-radius: 100px;
  background: white;
  border: none;
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  font-weight: 600;
  color: #1a1a1a;
  cursor: pointer;
  transition: opacity 0.25s ease, transform 0.25s ease;
  box-shadow: 0 4px 16px rgba(0,0,0,0.12);
  z-index: 3;
}

.product-card:hover .product-card__quick-add {
  opacity: 1;
  transform: translateX(-50%) translateY(0);
}

.product-card__info {
  padding: 0 2px;
}

.product-card__category {
  font-family: 'Inter', sans-serif;
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.15em;
  color: #aaa;
  margin: 0 0 6px 0;
  text-transform: uppercase;
}

.product-card__name {
  font-size: 17px;
  font-weight: 500;
  color: #1a1a1a;
  margin: 0 0 8px 0;
  line-height: 1.3;
}

.product-card__pricing {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 6px;
}

.product-card__price {
  font-size: 16px;
  font-weight: 600;
  color: #1a1a1a;
}

.product-card__original {
  font-size: 14px;
  color: #bbb;
  text-decoration: line-through;
}

.product-card__rating {
  display: flex;
  align-items: center;
  gap: 4px;
  font-family: 'Inter', sans-serif;
  font-size: 12px;
}

.star {
  color: #f5a623;
  font-size: 13px;
}

.rating-value {
  font-weight: 600;
  color: #1a1a1a;
}

.rating-count {
  color: #aaa;
}

/* ── Empty state ── */
.products__empty {
  text-align: center;
  padding: 80px 0;
  font-size: 18px;
  color: #aaa;
  font-style: italic;
}

/* ── Responsive ── */
@media (max-width: 1100px) {
  .products__grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .products__inner {
    padding: 40px 20px 60px;
  }
  .products__grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .filters-bar {
    flex-direction: column;
    align-items: flex-start;
  }
}

@media (max-width: 480px) {
  .products__grid {
    grid-template-columns: 1fr;
  }
}
</style>