# Informe Técnico — Ecommerce Dotaciones (Migración)

> **Fecha:** 9 de junio de 2026  
> **Rama actual:** `jeffrey` (push reciente a `origin/jeffrey`)  
> **Arquitectura:** Laravel 11 (Backend) + Vue 3 / Vite (Frontend + Dashboard)

---

## 1. Estado actual del Backend

### Módulos completamente desarrollados

El backend Laravel está **maduro**. Cuenta con **21 controladores**, **20 modelos Eloquent** y **161 líneas de rutas API** que cubren todos los dominios del negocio.

#### Controladores (21 total)

| Controlador | Namespace | Endpoints | Estado |
|---|---|---|---|
| [AuthController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/Api/AuthController.php) | `Api\` | 8 | ✅ Completo |
| [ProductController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/Api/ProductController.php) | `Api\` | 5 | ✅ Completo |
| [UsuarioController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/Api/UsuarioController.php) | `Api\` | 5 | ✅ Completo |
| [ContactoController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/Api/ContactoController.php) | `Api\` | 1 | ✅ Completo |
| [PagoController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/Api/PagoController.php) | `Api\` | 6 | ✅ Completo |
| [EnvioController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/Api/EnvioController.php) | `Api\` | 5 | ✅ Completo |
| [DevolucionController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/Api/DevolucionController.php) | `Api\` | 6 | ✅ Completo |
| [CategoriaController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/CategoriaController.php) | Root | 5 | ✅ Completo |
| [DotacionController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/DotacionController.php) | Root | 5 | ✅ Completo |
| [LonaController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/LonaController.php) | Root | 5 | ✅ Completo |
| [LonaTallaController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/LonaTallaController.php) | Root | 4 | ✅ Completo |
| [HistorialLonaController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/HistorialLonaController.php) | Root | 3 | ✅ Completo |
| [CarritoController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/CarritoController.php) | Root | 6 | ✅ Completo |
| [OrdenController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/OrdenController.php) | Root | 5 | ✅ Completo |
| [DireccionController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/DireccionController.php) | Root | 5 | ✅ Completo |
| [CuponController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/CuponController.php) | Root | 7 | ✅ Completo |
| [NotificacionController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/NotificacionController.php) | Root | 3 | ✅ Completo |
| [DashboardController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/DashboardController.php) | Root | 1 | ✅ Completo |
| [VarianteProductoController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/VarianteProductoController.php) | Root | 3 | ✅ Completo |
| [ImagenProductoController](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Controllers/ImagenProductoController.php) | Root | 4 | ✅ Completo |

#### Modelos Eloquent (20 total)

`Usuario`, `Productos`, `VarianteProducto`, `ImagenProducto`, `Categoria`, `Dotacion`, `Lona`, `LonaTalla`, `HistorialLona`, `Carrito`, `CarritoItem`, `Orden`, `OrdenItem`, `Pago`, `Envio`, `Devolucion`, `Direccion`, `Cupon`, `Notificacion`, `Contacto`

#### Middleware

- [RoleMiddleware](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/app/Http/Middleware/RoleMiddleware.php) — Existe pero **no se aplica** en ninguna ruta de `api.php`.

#### Autenticación

- Laravel Sanctum configurado y funcional
- Rutas protegidas con `auth:sanctum`: `/profile` (GET, PUT, DELETE), `/logout`

#### APIs existentes — Total: ~91 endpoints

Todos definidos en [api.php](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/routes/api.php)

---

## 2. Estado actual del Frontend

### Vistas (10 archivos)

| Vista | Archivo | Funcional | Conectada a API |
|---|---|---|---|
| Home | [Home.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/Home.vue) | ✅ | ❌ Datos estáticos |
| Productos | [products.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/products.vue) | ✅ | ❌ Datos estáticos |
| Detalle Producto | [ProductDetail.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/ProductDetail.vue) | ✅ | ❌ Datos estáticos |
| Carrito | [cart.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/cart.vue) | ✅ | ❌ localStorage local |
| Checkout | [checkout.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/checkout.vue) | ✅ | ❌ Sin API |
| Login/Registro | [login.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/login.vue) | ✅ | ✅ `/login`, `/register` |
| Olvidé Contraseña | [ForgotPassword.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/ForgotPassword.vue) | ✅ | ✅ `/forgot-password` |
| Reset Contraseña | [ResetPassword.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/ResetPassword.vue) | ✅ | ✅ `/reset-password` |
| Mi Cuenta | [MyAccount.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/MyAccount.vue) | ✅ | ✅ `/profile` CRUD |
| Contacto | [contact.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/contact.vue) | ✅ | ✅ `/contactos` |

### Componentes (3 archivos)

| Componente | Conectado a API |
|---|---|
| [Navbar.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/components/Navbar.vue) | ✅ `/logout` |
| [Footer.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/components/Footer.vue) | ❌ Estático |
| [HelloWorld.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/components/HelloWorld.vue) | ❌ Sin uso |

### Páginas únicamente visuales (sin conexión API real)

- **Home.vue** — Productos estáticos hardcodeados (imágenes Unsplash, precios ficticios)
- **products.vue** — 8 productos ficticios hardcodeados en `data()`
- **ProductDetail.vue** — Datos estáticos
- **cart.vue** — Carrito solo con localStorage, no usa API de carrito
- **checkout.vue** — Formulario visual, no crea órdenes reales

---

## 3. Estado actual del Dashboard

### Vistas (6 archivos)

| Vista | Archivo | Fuente de datos |
|---|---|---|
| Overview | [Overview.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/views/Overview.vue) | 🟡 `state.js` (localStorage) |
| Products | [Products.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/views/Products.vue) | 🟡 `state.js` (localStorage) |
| Orders | [Orders.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/views/Orders.vue) | 🟡 `state.js` (localStorage) |
| Dotaciones | [Dotaciones.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/views/Dotaciones.vue) | 🟡 `state.js` (localStorage) |
| Users | [Users.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/views/Users.vue) | ✅ API `/usuarios` |
| Admin Account | [AdminAccount.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/views/AdminAccount.vue) | ✅ API `/profile` |

### Componentes (3 archivos)

| Componente | Conectado a API |
|---|---|
| [AppHeader.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/components/AppHeader.vue) | 🟡 Lee `localStorage` |
| [AppSidebar.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/components/AppSidebar.vue) | ❌ Estático |
| [HelloWorld.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/components/HelloWorld.vue) | ❌ Sin uso |

> [!IMPORTANT]
> El dashboard usa un **store reactivo local** ([state.js](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/store/state.js)) con datos semilla hardcodeados que persisten en `localStorage`. Las vistas Overview, Products, Orders y Dotaciones operan **100% contra este estado local** y **NO consumen la API de Laravel**. Solo Users y AdminAccount consumen la API real.

---

## 4. Estado de la Integración (Backend ↔ Frontend ↔ Dashboard)

| Módulo | Backend API | Frontend | Dashboard | Integración | Estado |
|---|---|---|---|---|---|
| Autenticación (Login/Registro) | ✅ 8 endpoints | ✅ Conectado | ✅ Guard en router | ✅ | **Completo** |
| Verificación Email | ✅ Endpoint | ✅ Modal error | — | ✅ | **Completo** |
| Recuperar Contraseña | ✅ 2 endpoints | ✅ 2 vistas | — | ✅ | **Completo** |
| Perfil de Usuario | ✅ GET/PUT/DELETE | ✅ MyAccount | ✅ AdminAccount | ✅ | **Completo** |
| Contacto | ✅ POST | ✅ contact.vue | — | ✅ | **Completo** |
| Gestión Usuarios (Admin) | ✅ 5 endpoints | — | ✅ Users.vue | ✅ | **Completo** |
| Productos (Catálogo) | ✅ 5 endpoints | ⚠️ Vista estática | 🟡 state.js local | ❌ | **Sin conectar** |
| Variantes Producto | ✅ 3 endpoints | ❌ No existe | 🟡 state.js local | ❌ | **Sin conectar** |
| Imágenes Producto | ✅ 4 endpoints | ❌ Usa Unsplash | ❌ No consume | ❌ | **Sin conectar** |
| Categorías | ✅ 5 endpoints | ❌ No consume | 🟡 Hardcodeado | ❌ | **Sin conectar** |
| Carrito | ✅ 6 endpoints | ⚠️ localStorage | — | ❌ | **Sin conectar** |
| Órdenes | ✅ 5 endpoints | ❌ No existe | 🟡 state.js local | ❌ | **Sin conectar** |
| Pagos | ✅ 6 endpoints | ❌ No existe | ❌ No existe | ❌ | **Pendiente** |
| Envíos | ✅ 5 endpoints | ❌ No existe | 🟡 state.js local | ❌ | **Sin conectar** |
| Direcciones | ✅ 5 endpoints | ❌ No existe | ❌ No existe | ❌ | **Pendiente** |
| Cupones | ✅ 7 endpoints | ❌ No consume | ❌ No existe | ❌ | **Pendiente** |
| Devoluciones | ✅ 6 endpoints | ❌ No existe | ❌ No existe | ❌ | **Pendiente** |
| Dotaciones | ✅ 5 endpoints | — | 🟡 state.js local | ❌ | **Sin conectar** |
| Lonas | ✅ 5 endpoints | — | 🟡 state.js local | ❌ | **Sin conectar** |
| Lona Tallas | ✅ 4 endpoints | — | 🟡 state.js local | ❌ | **Sin conectar** |
| Historial Lonas | ✅ 3 endpoints | — | 🟡 state.js local | ❌ | **Sin conectar** |
| Notificaciones | ✅ 3 endpoints | ❌ No consume | 🟡 state.js local | ❌ | **Sin conectar** |
| Dashboard Resumen | ✅ 1 endpoint | — | 🟡 Calcula local | ❌ | **Sin conectar** |

---

## 5. Funcionalidades completamente operativas (End-to-End)

✅ **Frontend → API → Base de datos:**
1. Login de usuario (email o nombre)
2. Registro de usuario con verificación por email
3. Verificación de email con enlace firmado
4. Olvidé mi contraseña (envío de correo)
5. Restablecer contraseña (con token)
6. Ver perfil del usuario autenticado
7. Editar perfil (nombre, teléfono, contraseña)
8. Eliminar cuenta de usuario
9. Cerrar sesión (revocación de token Sanctum)
10. Envío de formulario de contacto
11. Gestión de usuarios desde dashboard (CRUD completo)
12. Configuración de cuenta de admin (perfil, editar, eliminar)
13. Control de acceso al dashboard (solo admin/super_admin)

---

## 6. Funcionalidades parcialmente implementadas

### Existe en Backend pero NO en Frontend:

| API Backend | Observación |
|---|---|
| `GET /productos` | Frontend muestra productos estáticos |
| `GET /productos/{id}` | ProductDetail.vue usa datos ficticios |
| CRUD Categorías | No consumido |
| CRUD Carrito (6 endpoints) | Cart.vue usa solo localStorage |
| CRUD Órdenes (5 endpoints) | Checkout.vue no crea órdenes reales |
| CRUD Pagos (6 endpoints) | Sin UI en ningún lugar |
| CRUD Envíos + Tracking (5 endpoints) | Sin UI en frontend |
| CRUD Direcciones (5 endpoints) | Sin UI en frontend |
| CRUD Cupones (7 endpoints) | Checkout no valida cupones |
| CRUD Devoluciones (6 endpoints) | Sin UI |
| Notificaciones (3 endpoints) | Sin consumo |
| Dashboard Resumen (1 endpoint) | Overview.vue calcula desde state local |

### Existe en Frontend pero NO consume API:

| Vista Frontend | Observación |
|---|---|
| Home.vue | 4 productos ficticios, 3 colecciones ficticias |
| products.vue | 8 productos hardcodeados con categorías inventadas |
| ProductDetail.vue | Datos estáticos de ejemplo |
| cart.vue | Carrito 100% local |
| checkout.vue | No crea orden, no valida cupón, no registra pago |

### Existe en Dashboard pero NO consume API:

| Vista Dashboard | Observación |
|---|---|
| Overview.vue | KPIs calculados desde `state.js` local |
| Products.vue | CRUD opera solo contra `state.js` |
| Orders.vue | Lista y cambio de estado solo local |
| Dotaciones.vue | Todo el flujo de lonas opera local |

---

## 7. Funcionalidades pendientes (Prioridad)

### 🔴 Crítico

1. **Conectar catálogo de productos al API** — `products.vue`, `Home.vue`, `ProductDetail.vue` deben consumir `GET /productos`
2. **Conectar carrito al API** — `cart.vue` debe usar `POST /carritos`, `/carritos/{id}/items`, etc.
3. **Conectar checkout al API** — Crear orden real vía `POST /ordenes/crear`, registrar pago, crear envío
4. **Conectar dashboard Products al API** — Reemplazar `state.js` por llamadas a `/productos`, `/variantes`, `/imagenes`
5. **Conectar dashboard Orders al API** — Reemplazar `state.js` por llamadas a `/ordenes`
6. **Conectar dashboard Overview al API** — Consumir `GET /dashboard/resumen`

### 🟡 Importante

7. **Conectar dashboard Dotaciones al API** — Reemplazar `state.js` por `/dotaciones`, `/lonas`, `/lona-tallas`, `/historial-lonas`
8. **Conectar notificaciones al API** — AppHeader y Overview deben consumir `/notificaciones`
9. **Crear vista de Mis Pedidos** — El cliente no tiene forma de ver sus órdenes en el frontend
10. **Crear vista de Direcciones** — CRUD para el usuario en el frontend
11. **Gestión de Cupones en dashboard** — Crear vista dashboard para administrar cupones
12. **Gestión de Devoluciones en dashboard** — Crear vista para aprobar/rechazar devoluciones
13. **Proteger rutas API con middleware** — `RoleMiddleware` existe pero no se aplica a ninguna ruta

### 🟢 Opcional

14. **Gestión de Pagos en dashboard** — Vista para verificar comprobantes
15. **Gestión de Envíos en dashboard** — Vista para tracking y cambio de estado
16. **Historial de Lonas visible en dashboard** — Ya existe API, falta tabla/timeline
17. **Eliminar componentes sin uso** — `HelloWorld.vue` en frontend y dashboard
18. **Crear vista de categorías en dashboard** — Para que se listen dinámicamente en Products

---

## 8. Problemas detectados

### 🔴 Seguridad

> [!CAUTION]
> **Rutas API sin protección.** El 85% de los endpoints en `api.php` son **públicos**. Cualquiera puede hacer `DELETE /productos/1` o `PUT /ordenes/1/estado` sin autenticación ni autorización. Solo 4 rutas (`/profile`, `/logout`) usan `auth:sanctum`. El `RoleMiddleware` existe en el código pero **no se usa en ninguna ruta**.

> [!WARNING]
> **Tokens de sesión pasados por URL.** La sincronización de sesión entre frontend (puerto 5173) y dashboard (puerto 5174) pasa `auth_user` y `auth_token` como query params en la URL. Esto es inseguro ya que los tokens pueden quedar en logs del servidor, historial del navegador y referer headers.

### 🟡 Arquitectura

- **Datos duplicados:** El dashboard tiene datos seed hardcodeados en `state.js` (4 usuarios, 4 productos, 4 órdenes, 3 dotaciones, etc.) que **no reflejan** la base de datos real. Si un admin modifica productos en el dashboard, los cambios se guardan en localStorage del navegador, no en MySQL.
- **Namespaces inconsistentes:** Algunos controladores están en `App\Http\Controllers\Api\` y otros directamente en `App\Http\Controllers\`. Hay inconsistencia en capitalización: `API\EnvioController` vs `Api\PagoController`.
- **API_URL hardcodeado:** Se repite `http://localhost:8000/api` en múltiples archivos. Debería centralizarse en una variable de entorno o archivo de configuración.
- **Sin store centralizado en frontend:** No usa Pinia (instalado pero sin configurar) ni Vuex. El estado del carrito no persiste entre componentes de forma confiable.

### 🟢 Código

- **`HelloWorld.vue`** existe en ambos proyectos (frontend y dashboard) sin ser utilizado.
- **Categorías hardcodeadas** en el dashboard Products.vue (`Ropa`, `Camisetas`) en lugar de venir del API `/categorias`.
- **Frontend `products.vue`** tiene datos de ejemplo con precios en dólares ($189) mientras el backend usa COP colombianos.

---

## 9. Roadmap de finalización

### Fase 1 — Seguridad (1-2 días)
1. Aplicar `auth:sanctum` a todas las rutas que lo requieran
2. Aplicar `RoleMiddleware` a rutas administrativas (productos, órdenes, dotaciones, usuarios)
3. Reemplazar sincronización de sesión por URL con un mecanismo seguro (compartir token vía `postMessage` o cookie compartida)

### Fase 2 — Catálogo conectado (2-3 días)
4. Crear servicio API centralizado (`api.js`) en el frontend
5. Conectar `products.vue` → `GET /productos` con datos reales
6. Conectar `ProductDetail.vue` → `GET /productos/{id}`
7. Conectar `Home.vue` → productos destacados desde API
8. Conectar categorías dinámicas desde `GET /categorias`

### Fase 3 — Flujo de compra (3-4 días)
9. Conectar `cart.vue` → API de carrito
10. Conectar `checkout.vue` → `POST /ordenes/crear` + `POST /pagos` + `POST /envios`
11. Crear vista "Mis Pedidos" para el cliente
12. Implementar cupones en checkout → `POST /cupones/validar`
13. Crear CRUD de direcciones del usuario

### Fase 4 — Dashboard conectado a API (3-4 días)
14. Reemplazar `state.js` por llamadas API en Overview.vue → `GET /dashboard/resumen`
15. Conectar Products.vue → API CRUD de productos/variantes/imágenes
16. Conectar Orders.vue → API de órdenes/envíos
17. Conectar Dotaciones.vue → API de dotaciones/lonas/tallas/historial
18. Conectar notificaciones → `GET /notificaciones`

### Fase 5 — Vistas administrativas nuevas (2-3 días)
19. Crear vista de gestión de Cupones en dashboard
20. Crear vista de gestión de Devoluciones en dashboard
21. Crear vista de gestión de Pagos en dashboard
22. Crear vista de gestión de Envíos en dashboard

### Fase 6 — Pulir (1-2 días)
23. Centralizar API_URL en archivo de configuración
24. Configurar Pinia como store centralizado
25. Eliminar componentes sin uso
26. Normalizar namespaces de controladores
27. Tests de integración básicos

---

## 10. Porcentajes estimados de avance

| Área | Avance |
|---|---|
| **Backend (Laravel)** | **95%** — Todos los módulos tienen endpoints, modelos y validaciones. Falta solo aplicar middleware de seguridad a las rutas. |
| **Frontend (Vue.js)** | **40%** — Las 10 vistas existen y se ven bien, pero solo 5 están conectadas a la API (login, registro, perfil, contacto, contraseña). Las 5 más importantes (home, productos, carrito, checkout, detalle) usan datos ficticios. |
| **Dashboard** | **35%** — Las 6 vistas existen y son funcionales visualmente, pero solo 2 (Users, AdminAccount) consumen la API real. Las otras 4 (Overview, Products, Orders, Dotaciones) operan contra datos locales. |
| **Integración Backend ↔ Frontend** | **25%** — De ~91 endpoints disponibles, solo ~15 se consumen realmente desde el frontend o dashboard. |
| **🏗️ Proyecto Total** | **~48%** |

---

## 11. Archivos que deben modificarse para completar la migración

### Frontend — Conectar a API
- [Home.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/Home.vue) — Productos destacados desde API
- [products.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/products.vue) — Catálogo desde API
- [ProductDetail.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/ProductDetail.vue) — Detalle desde API
- [cart.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/cart.vue) — Carrito vía API
- [checkout.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/views/checkout.vue) — Crear orden/pago real
- [router/index.js](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/frontend/src/router/index.js) — Agregar rutas nuevas (mis pedidos, direcciones)

### Frontend — Crear nuevos
- `frontend/src/views/MyOrders.vue` — **[NUEVO]** Vista de pedidos del cliente
- `frontend/src/views/Addresses.vue` — **[NUEVO]** CRUD de direcciones
- `frontend/src/services/api.js` — **[NUEVO]** Servicio centralizado Axios

### Dashboard — Conectar a API
- [Overview.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/views/Overview.vue) — Consumir `/dashboard/resumen`
- [Products.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/views/Products.vue) — CRUD vía API
- [Orders.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/views/Orders.vue) — Órdenes vía API
- [Dotaciones.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/views/Dotaciones.vue) — Dotaciones/lonas vía API
- [state.js](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/store/state.js) — Eliminar datos seed, refactorizar
- [AppHeader.vue](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/dashboard/src/components/AppHeader.vue) — Notificaciones vía API

### Dashboard — Crear nuevos
- `dashboard/src/views/Cupones.vue` — **[NUEVO]**
- `dashboard/src/views/Devoluciones.vue` — **[NUEVO]**
- `dashboard/src/views/Pagos.vue` — **[NUEVO]**
- `dashboard/src/views/Envios.vue` — **[NUEVO]**

### Backend — Seguridad
- [api.php](file:///c:/xampp/htdocs/ecommerce-dotaciones/ecommerce-dotaciones/backend/routes/api.php) — Aplicar middleware `auth:sanctum` y `role`

### Eliminar
- `frontend/src/components/HelloWorld.vue` — **[DELETE]**
- `dashboard/src/components/HelloWorld.vue` — **[DELETE]**
