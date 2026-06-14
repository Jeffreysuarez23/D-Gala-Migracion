# 🏢 Reporte de Auditoría de Código y Arquitectura

Este documento representa un análisis exhaustivo de ingeniería inversa realizado sobre el código fuente del proyecto `ecommerce-dotaciones`.

---

## 1. ARQUITECTURA GENERAL Y ORGANIZACIÓN DEL CÓDIGO

### Patrón de Arquitectura
El sistema no es un monolito tradicional ni una arquitectura estricta de microservicios, sino una **Arquitectura Desacoplada (Headless CMS/E-commerce)**. 
*   **Backend (API)**: Construido como una API RESTful pura.
*   **Frontend (Clientes)**: Construido como Single Page Applications (SPA) totalmente independientes.

### Organización y Modularidad
El repositorio está dividido lógicamente en tres directorios principales que funcionan como proyectos autónomos, cada uno con su propia gestión de dependencias (`package.json` / `composer.json`):

1.  **`backend/` (Laravel 12 + PHP 8.2+)**: 
    *   Sigue el patrón **MVC (Model-View-Controller)** de Laravel, pero se omiten completamente las Vistas (Views) de Blade.
    *   Las peticiones se resuelven puramente desde los Controladores hacia respuestas JSON.
    *   Existe una modularización inicial hacia una capa de servicios (`app/Services/PayPalService.php`) para abstraer lógica compleja de pasarelas de pago, lo que demuestra un acercamiento a los principios de responsabilidad única (SOLID).
2.  **`frontend/` (Vue.js 3 + Vite)**: 
    *   Es la aplicación SPA de cara al cliente (tienda).
    *   Organizada en vistas (`src/views/`) para páginas principales y componentes.
3.  **`dashboard/` (Vue.js 3 + Vite)**: 
    *   Aplicación SPA independiente para la administración del sistema.

### Patrones de Diseño Detectados
*   **MVC (Model-View-Controller)**: Base estructural de Laravel y de los componentes en Vue.
*   **Service Pattern**: Implementado en el backend (ej. `PayPalService`) para aislar la lógica de negocio de los controladores.
*   **Active Record**: A través de Eloquent ORM de Laravel para la gestión e interacción con la base de datos.
*   **Singleton & Dependency Injection**: Utilizados nativamente por el Service Container de Laravel para inyectar dependencias en controladores y servicios.
*   **Facade**: Uso intensivo de las fachadas de Laravel (`Route::`, `Auth::`, `DB::`).

---

## 2. INTEGRACIÓN COMPLETA LARAVEL <-> VUE.JS

### Mecanismo de Conexión
La comunicación se realiza **estrictamente a través de una API RESTful**. 
No se utiliza GraphQL, ni Inertia.js, ni Laravel Livewire. Ambos entornos (Backend y Frontend) están completamente desacoplados y se comunican enviando y recibiendo payloads en formato JSON.

### Flujo de Datos y Enrutamiento (Routing)
1.  **Enrutamiento Frontend**: Está gestionado internamente por `vue-router` v4.6.4 en modo History. Vue intercepta los cambios de URL y carga las vistas correspondientes (ej. `Home`, `Cart`, `Checkout`, `ProductDetail`) sin recargar la página.
2.  **Peticiones HTTP**: El frontend utiliza `axios` v1.17.0 para lanzar peticiones HTTP (GET, POST, PUT, DELETE) hacia los endpoints publicados por el backend.
3.  **Gestión de Estado**: El frontend utiliza **Pinia** v2.3.1 (`createPinia()`) para gestionar el estado global reactivo (como el contenido del carrito de compras o la sesión del usuario).
4.  **Enrutamiento Backend**: Laravel define y expone las rutas en `routes/api.php`. Dependiendo de la ruta, la petición es filtrada (o no) por middlewares de seguridad antes de llegar al controlador correspondiente (ej. `OrdenController`).

---

## 3. GESTIÓN DE DATOS Y APIS

### APIs Expuestas (Internas)
El backend expone un ecosistema robusto de rutas API bajo `api.php`. Los módulos principales son:
*   **Catálogo**: `/productos`, `/categorias`, `/variantes`, `/imagenes`
*   **Gestión de Inventario (Específico)**: `/dotaciones`, `/lonas`, `/lona-tallas`, `/historial-lonas`
*   **Ventas**: `/carritos`, `/ordenes` (creación y cancelación), `/cupones`
*   **Usuarios**: `/profile`, `/direcciones`, `/auth` (login/register)
*   **Operaciones Post-venta**: `/envios`, `/devoluciones`, `/pagos`

### APIs Consumidas (Externas)
*   **PayPal**: Implementación de creación y captura de órdenes (`/paypal/create-order`, `/paypal/capture-order`) y Webhooks (`/paypal/webhook`).
*   **MercadoPago**: Existe la dependencia instalada (`mercadopago/dx-php` v3.10), pero las rutas del controlador (`MercadoPagoController`) están actualmente **comentadas/deshabilitadas**.

### Arquitectura de Datos, Persistencia y ORM
La persistencia de datos utiliza una base de datos relacional, gestionada mediante **Eloquent ORM**. 
La arquitectura de tablas abarca más de 20 modelos interrelacionados en `app/Models`, entre los cuales destacan:
*   **Entidades Principales**: `Usuario`, `Productos`, `Categoria`, `Dotacion`, `Lona`.
*   **Relaciones Transaccionales**: `Carrito` -> `CarritoItem`, `Orden` -> `OrdenItem`, vinculados a su vez con `Pago` y `Direccion`.
*   Las migraciones (ej. `2026_06_10_171855_add_destacada_to_categorias_table.php`) permiten construir la base de datos de manera incremental.

---

## 4. LÓGICA GENERADA POR INTELIGENCIA ARTIFICIAL (IA)

En el código fuente se busca firmas de integraciones de LLMs como llamadas a OpenAI, Gemini, Claude, uso de prompts predefinidos o cadenas "AI"/"LLM":

*   El sistema es un **E-commerce Transaccional Tradicional**. No existen chatbots impulsados por IA nativos en el código de backend, ni flujos de generación dinámica de descripciones de productos mediante Prompts automatizados en los Controladores.

---

## 5. FLUJO DE EJECUCIÓN Y SEGURIDAD

### Ciclo de Vida de una Petición (Request/Response)
1.  **Interacción**: El usuario hace clic en "Añadir al Carrito" en la vista `ProductDetail.vue`.
2.  **Acción Frontend**: Pinia/Axios empaquetan la petición POST enviando el ID del producto hacia `/api/carritos/{id}/items`.
3.  **Intercepción y Middlewares**:
    *   La petición entra a Laravel y pasa por la protección **CORS** (permitiendo que el Frontend en otro puerto/dominio pueda acceder a la API).
    *   Pasa por el middleware general. Si es una ruta protegida (ej. `/mis-pedidos`), cruza por el middleware `auth:sanctum`.
4.  **Controlador**: `CarritoController::agregarItem` recibe la solicitud, valida los inputs y usa Eloquent para guardar el registro en la BD.
5.  **Respuesta**: Laravel retorna un JSON con un código 200/201.
6.  **Actualización UI**: Axios recibe el JSON, Pinia actualiza el carrito global en memoria y Vue re-renderiza el icono del carrito instantáneamente en el `AppHeader.vue`.

### Capa de Seguridad
1.  **Autenticación API**: Se utiliza **Laravel Sanctum** (`laravel/sanctum` v4.3) para emitir tokens portadores (Bearer Tokens) a las SPAs de Vue. Rutas críticas están encapsuladas en `Route::middleware('auth:sanctum')`.
2.  **CORS**: Configurado en Laravel para evitar vulnerabilidades Cross-Origin.
3.  **Autorización (Roles)**: Implementado de manera ad-hoc dentro de los controladores (ej. `UsuarioController::updateRole` y rutas del admin de Dashboard).
4.  **Validación de Inputs**: Laravel filtra las inyecciones SQL mediante su Query Builder (PDO) y procesa reglas estrictas en las Request enviadas a los controladores.
5.  **Webhooks**: Las rutas de webhooks (ej. `/paypal/webhook`) están expuestas públicamente pero deben contener firmas y validaciones internas específicas con la pasarela para asegurar que el pago es legítimo.
