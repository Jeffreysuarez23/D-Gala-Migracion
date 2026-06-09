-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-06-2026 a las 17:11:37
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ecommerce`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banners`
--

CREATE TABLE `banners` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `titulo` varchar(150) DEFAULT NULL,
  `subtitulo` varchar(250) DEFAULT NULL,
  `url_imagen` varchar(500) NOT NULL,
  `url_enlace` varchar(500) DEFAULT NULL,
  `orden` int(11) DEFAULT 0,
  `activo` tinyint(1) DEFAULT 1,
  `inicio_en` timestamp NULL DEFAULT NULL,
  `fin_en` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carritos`
--

CREATE TABLE `carritos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` bigint(20) UNSIGNED DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `cupon_id` bigint(20) UNSIGNED DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `carritos`
--

INSERT INTO `carritos` (`id`, `usuario_id`, `session_id`, `cupon_id`, `creado_en`, `actualizado_en`) VALUES
(1, NULL, 'abc123', NULL, '2026-05-22 19:02:39', '2026-05-22 19:02:39'),
(2, NULL, NULL, NULL, '2026-05-26 18:12:01', '2026-05-26 18:12:01'),
(3, NULL, 'abc123', NULL, '2026-05-26 18:12:08', '2026-05-26 18:12:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carrito_items`
--

CREATE TABLE `carrito_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `carrito_id` bigint(20) UNSIGNED NOT NULL,
  `variante_id` bigint(20) UNSIGNED NOT NULL,
  `lona_id` bigint(20) UNSIGNED DEFAULT NULL,
  `cantidad` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `padre_id` bigint(20) UNSIGNED DEFAULT NULL,
  `orden` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `slug`, `padre_id`, `orden`) VALUES
(1, 'Ropa', 'ropa', NULL, 0),
(2, 'Camisetas', 'camisetas', 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuraciones_cms`
--

CREATE TABLE `configuraciones_cms` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `clave` varchar(100) NOT NULL,
  `valor` text DEFAULT NULL,
  `tipo` enum('texto','color','imagen','json','booleano') DEFAULT 'texto',
  `grupo` varchar(50) DEFAULT 'branding',
  `actualizado_por` bigint(20) UNSIGNED DEFAULT NULL,
  `actualizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contactos`
--

CREATE TABLE `contactos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `status` enum('pendiente','leido','resuelto') NOT NULL DEFAULT 'pendiente',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `contactos`
--

INSERT INTO `contactos` (`id`, `first_name`, `last_name`, `email`, `subject`, `message`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Jeffrey', 'Suarez', 'jeffrey@gmail.com', 'order', 'no me ha llegado.', 'pendiente', '2026-06-09 02:07:59', '2026-06-09 02:07:59'),
(2, 'dsfdsffds', 'fdsdsfdsfd', 'sfdsdfsdf@gmail.com', 'product', 'que es eso?', 'pendiente', '2026-06-09 02:09:23', '2026-06-09 02:09:23'),
(3, 'dfdfsfds', 'dsffdsdfs', 'sfdsdffdsfds@gmail.com', 'return', 'quiero mi plata', 'pendiente', '2026-06-09 02:11:12', '2026-06-09 02:11:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cupones`
--

CREATE TABLE `cupones` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `tipo` enum('porcentaje','fijo') NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `monto_minimo_pedido` decimal(10,2) DEFAULT 0.00,
  `limite_usos` int(11) DEFAULT NULL,
  `usos_actuales` int(11) DEFAULT 0,
  `activo` tinyint(1) DEFAULT 1,
  `expira_en` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `orden_id` bigint(20) UNSIGNED NOT NULL,
  `motivo` text NOT NULL,
  `estado` enum('pendiente','aprobada','rechazada','resuelta') DEFAULT 'pendiente',
  `resolucion_admin` text DEFAULT NULL,
  `resuelto_por` bigint(20) UNSIGNED DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `devoluciones`
--

INSERT INTO `devoluciones` (`id`, `orden_id`, `motivo`, `estado`, `resolucion_admin`, `resuelto_por`, `creado_en`) VALUES
(1, 1, 'La camiseta llegó con defectos de fabricación', 'resuelta', NULL, NULL, '2026-06-02 20:59:09');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones`
--

CREATE TABLE `direcciones` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` bigint(20) UNSIGNED NOT NULL,
  `etiqueta` varchar(50) DEFAULT 'Casa',
  `departamento` varchar(80) NOT NULL,
  `ciudad` varchar(80) NOT NULL,
  `direccion` varchar(250) NOT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `es_principal` tinyint(1) DEFAULT 0,
  `eliminado_en` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `direcciones`
--

INSERT INTO `direcciones` (`id`, `usuario_id`, `etiqueta`, `departamento`, `ciudad`, `direccion`, `codigo_postal`, `es_principal`, `eliminado_en`) VALUES
(1, 1, 'Casa', 'Atlántico', 'Barranquilla', 'Calle 123 #45-67', '080001', 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dotaciones`
--

CREATE TABLE `dotaciones` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `min_lonas` tinyint(3) UNSIGNED DEFAULT 3,
  `max_lonas` tinyint(3) UNSIGNED DEFAULT 10,
  `lonas_activas` int(11) DEFAULT 0,
  `alerta_enviada_en` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `dotaciones`
--

INSERT INTO `dotaciones` (`id`, `nombre`, `descripcion`, `min_lonas`, `max_lonas`, `lonas_activas`, `alerta_enviada_en`) VALUES
(1, 'Dotación Editada', 'prueba update', 3, 10, 0, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `envios`
--

CREATE TABLE `envios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `orden_id` bigint(20) UNSIGNED NOT NULL,
  `transportadora` varchar(100) DEFAULT NULL,
  `guia` varchar(100) DEFAULT NULL,
  `estado` enum('preparando','enviado','en_ruta','entregado','fallido') DEFAULT 'preparando',
  `fecha_entrega_estimada` date DEFAULT NULL,
  `entregado_en` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `envios`
--

INSERT INTO `envios` (`id`, `orden_id`, `transportadora`, `guia`, `estado`, `fecha_entrega_estimada`, `entregado_en`) VALUES
(1, 1, 'Servientrega', 'GUIA-6A17617A90E1C', 'en_ruta', '2026-05-30', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_lonas`
--

CREATE TABLE `historial_lonas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `lona_id` bigint(20) UNSIGNED NOT NULL,
  `orden_item_id` bigint(20) UNSIGNED DEFAULT NULL,
  `accion` enum('descuento','ajuste_manual','ingreso','agotado') NOT NULL,
  `talla` varchar(10) DEFAULT NULL,
  `cantidad_cambio` int(11) DEFAULT NULL,
  `cantidad_restante` int(11) DEFAULT NULL,
  `snapshot_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Estado de tallas al momento del evento' CHECK (json_valid(`snapshot_json`)),
  `notas` text DEFAULT NULL,
  `creado_por` bigint(20) UNSIGNED DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_lonas`
--

INSERT INTO `historial_lonas` (`id`, `lona_id`, `orden_item_id`, `accion`, `talla`, `cantidad_cambio`, `cantidad_restante`, `snapshot_json`, `notas`, `creado_por`, `creado_en`) VALUES
(1, 1, NULL, 'ingreso', 'M', 10, 45, NULL, 'Ingreso manual inicial', NULL, '2026-05-22 18:51:42'),
(2, 1, NULL, 'descuento', 'M', -2, 18, NULL, 'Venta Orden #1 | Variante 2', NULL, '2026-05-27 18:41:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `imagenes_producto`
--

CREATE TABLE `imagenes_producto` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `producto_id` bigint(20) UNSIGNED NOT NULL,
  `variante_id` bigint(20) UNSIGNED DEFAULT NULL,
  `url` varchar(500) NOT NULL,
  `es_portada` tinyint(1) DEFAULT 0,
  `orden` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lonas`
--

CREATE TABLE `lonas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `dotacion_id` bigint(20) UNSIGNED NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `tipo_producto` varchar(80) DEFAULT NULL,
  `categoria` varchar(80) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `estado` enum('nuevo','usado') DEFAULT 'nuevo',
  `activa` tinyint(1) DEFAULT 1,
  `creado_en` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lonas`
--

INSERT INTO `lonas` (`id`, `dotacion_id`, `codigo`, `tipo_producto`, `categoria`, `color`, `estado`, `activa`, `creado_en`) VALUES
(1, 1, 'LONA-001', 'Camiseta', 'Deportiva', 'Azul', 'usado', 0, '2026-05-20 22:05:05');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lona_tallas`
--

CREATE TABLE `lona_tallas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `lona_id` bigint(20) UNSIGNED NOT NULL,
  `talla` varchar(10) NOT NULL,
  `cantidad` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lona_tallas`
--

INSERT INTO `lona_tallas` (`id`, `lona_id`, `talla`, `cantidad`) VALUES
(2, 1, 'M', 18);

--
-- Disparadores `lona_tallas`
--
DELIMITER $$
CREATE TRIGGER `trg_stock_lona_insert` AFTER INSERT ON `lona_tallas` FOR EACH ROW BEGIN
    UPDATE variantes_producto
    SET stock = (
        SELECT IFNULL(SUM(cantidad),0)
        FROM lona_tallas
        WHERE lona_id = NEW.lona_id
    )
    WHERE lona_id = NEW.lona_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_stock_lona_update` AFTER UPDATE ON `lona_tallas` FOR EACH ROW BEGIN
    UPDATE variantes_producto
    SET stock = (
        SELECT IFNULL(SUM(cantidad),0)
        FROM lona_tallas
        WHERE lona_id = NEW.lona_id
    )
    WHERE lona_id = NEW.lona_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(5, '2026_06_02_205429_create_jobs_table', 1),
(6, '2026_06_02_205446_create_job_batches_table', 2),
(7, '2026_06_02_205513_create_cache_table', 3),
(8, '2026_06_08_210453_create_contactos_table', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'NULL = Para todos los admins',
  `tipo` enum('stock_bajo','orden','sistema','marketing') DEFAULT 'sistema',
  `titulo` varchar(200) DEFAULT NULL,
  `mensaje` text DEFAULT NULL,
  `leido_en` timestamp NULL DEFAULT NULL,
  `confirmado_por` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'Doble check de la BD vieja',
  `creado_en` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes`
--

CREATE TABLE `ordenes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` bigint(20) UNSIGNED NOT NULL,
  `direccion_id` bigint(20) UNSIGNED NOT NULL,
  `cupon_id` bigint(20) UNSIGNED DEFAULT NULL,
  `numero` varchar(30) NOT NULL,
  `estado` enum('pendiente','confirmada','procesando','enviado','entregado','cancelada','devuelta') DEFAULT 'pendiente',
  `tipo_precio` enum('minorista','mayorista') DEFAULT 'minorista',
  `subtotal` decimal(10,2) NOT NULL,
  `descuento` decimal(10,2) DEFAULT 0.00,
  `envio_costo` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `notas_cliente` text DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ordenes`
--

INSERT INTO `ordenes` (`id`, `usuario_id`, `direccion_id`, `cupon_id`, `numero`, `estado`, `tipo_precio`, `subtotal`, `descuento`, `envio_costo`, `total`, `notas_cliente`, `creado_en`) VALUES
(1, 1, 1, NULL, 'ORD-1779907296', 'devuelta', 'minorista', 70000.00, 0.00, 0.00, 70000.00, NULL, '2026-05-27 18:41:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orden_items`
--

CREATE TABLE `orden_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `orden_id` bigint(20) UNSIGNED NOT NULL,
  `variante_id` bigint(20) UNSIGNED NOT NULL,
  `lona_id_snapshot` bigint(20) UNSIGNED DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `total_linea` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `orden_items`
--

INSERT INTO `orden_items` (`id`, `orden_id`, `variante_id`, `lona_id_snapshot`, `cantidad`, `precio_unitario`, `total_linea`) VALUES
(1, 1, 2, 1, 2, 35000.00, 70000.00);

--
-- Disparadores `orden_items`
--
DELIMITER $$
CREATE TRIGGER `trg_descuento_stock_venta` BEFORE INSERT ON `orden_items` FOR EACH ROW BEGIN
    DECLARE stock_actual INT;
    DECLARE lona_ref BIGINT;
    DECLARE talla_ref VARCHAR(10);

    -- Obtener lona y talla de la variante
    SELECT lona_id, talla 
    INTO lona_ref, talla_ref
    FROM variantes_producto
    WHERE id = NEW.variante_id
    LIMIT 1;

    -- Validar que exista
    IF lona_ref IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Variante sin lona asociada';
    END IF;

    -- Obtener stock actual
    SELECT cantidad 
    INTO stock_actual
    FROM lona_tallas
    WHERE lona_id = lona_ref
    AND talla = talla_ref
    LIMIT 1;

    -- Validar existencia
    IF stock_actual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No existe stock para esa talla';
    END IF;

    -- Validar stock suficiente
    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;

    -- Descontar stock
    UPDATE lona_tallas
    SET cantidad = cantidad - NEW.cantidad
    WHERE lona_id = lona_ref
    AND talla = talla_ref;

    -- Auditoría (SIN usar NEW.id para evitar problemas)
    INSERT INTO historial_lonas (
        lona_id,
        orden_item_id,
        accion,
        talla,
        cantidad_cambio,
        cantidad_restante,
        notas
    )
    VALUES (
        lona_ref,
        NULL,
        'descuento',
        talla_ref,
        (NEW.cantidad * -1),
        stock_actual - NEW.cantidad,
        CONCAT('Venta Orden #', NEW.orden_id, ' | Variante ', NEW.variante_id)
    );

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `orden_id` bigint(20) UNSIGNED NOT NULL,
  `metodo` varchar(50) DEFAULT NULL,
  `referencia_pasarela` varchar(100) DEFAULT NULL,
  `estado` enum('pendiente','aprobado','rechazado','reembolsado') DEFAULT 'pendiente',
  `monto` decimal(10,2) NOT NULL,
  `pagado_en` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id`, `orden_id`, `metodo`, `referencia_pasarela`, `estado`, `monto`, `pagado_en`) VALUES
(1, 1, 'Nequi', 'NEQ-999', 'reembolsado', 35000.00, '2026-05-27 20:43:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '5a455b774a376fde7e1917889f4baa36d212873bf0ab6950c6ef2fe25c127ecc', '[\"*\"]', NULL, NULL, '2026-04-24 19:10:54', '2026-04-24 19:10:54'),
(2, 'App\\Models\\User', 1, 'auth_token', '4a6e62faf36a4963a2a93a37c620760f24d228e9f7d5c0873e80d5454b62b550', '[\"*\"]', '2026-05-06 19:34:04', NULL, '2026-05-06 17:35:04', '2026-05-06 19:34:04'),
(4, 'App\\Models\\Usuario', 2, 'auth_token', '390116a454a355cdf847e4dba388e5508251ea4f0f051399656a7c3c09b2ecbf', '[\"*\"]', NULL, NULL, '2026-06-08 23:08:13', '2026-06-08 23:08:13'),
(5, 'App\\Models\\Usuario', 3, 'auth_token', 'd1f80ac44a18c6a567e9f75e5926fe116a02bbeadcaade80c228fc548ee4e10a', '[\"*\"]', NULL, NULL, '2026-06-08 23:11:04', '2026-06-08 23:11:04'),
(6, 'App\\Models\\Usuario', 2, 'auth_token', '93e25dd76e5f45114753f9fb24cd6aa390c5084115a6c8c75f1c213436480d15', '[\"*\"]', NULL, NULL, '2026-06-08 23:11:52', '2026-06-08 23:11:52'),
(7, 'App\\Models\\Usuario', 2, 'auth_token', '1c52852add37826e672ac579c63cf59bbbf0d2b32adb85a381742b46c505f1d0', '[\"*\"]', NULL, NULL, '2026-06-08 23:14:03', '2026-06-08 23:14:03'),
(15, 'App\\Models\\Usuario', 7, 'auth_token', 'cef2810b473acd9ea9ddb2eb56032bde056770b4aab49bb4742a9ae41a4d4851', '[\"*\"]', '2026-06-09 02:11:31', NULL, '2026-06-09 01:10:44', '2026-06-09 02:11:31'),
(17, 'App\\Models\\Usuario', 7, 'auth_token', 'ddc743320bc83b2f408c685373fd406351a19823c19112afe07f2b3dc2197502', '[\"*\"]', '2026-06-09 02:36:36', NULL, '2026-06-09 02:36:31', '2026-06-09 02:36:36'),
(23, 'App\\Models\\Usuario', 7, 'auth_token', '050c2759b3c15c1ca14a2bf7c45473e0fd264357fa230be1dea1d486e9b8ffb4', '[\"*\"]', NULL, NULL, '2026-06-09 19:46:29', '2026-06-09 19:46:29'),
(24, 'App\\Models\\Usuario', 7, 'auth_token', 'beb4332339db8c9bf6a29d052926e5a9bf6084b4f66b188a3efcb388818f4b48', '[\"*\"]', '2026-06-09 19:57:56', NULL, '2026-06-09 19:47:48', '2026-06-09 19:57:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `categoria_id` bigint(20) UNSIGNED DEFAULT NULL,
  `nombre` varchar(150) NOT NULL,
  `slug` varchar(160) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio_minorista` decimal(10,2) NOT NULL,
  `precio_mayorista` decimal(10,2) NOT NULL,
  `min_cantidad_mayorista` int(11) DEFAULT 12,
  `publicado` tinyint(1) DEFAULT 0,
  `permitir_sin_stock` tinyint(1) DEFAULT 1,
  `eliminado_en` timestamp NULL DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `categoria_id`, `nombre`, `slug`, `descripcion`, `precio_minorista`, `precio_mayorista`, `min_cantidad_mayorista`, `publicado`, `permitir_sin_stock`, `eliminado_en`, `creado_en`) VALUES
(1, NULL, 'Camiseta básica', 'camiseta-basica', NULL, 25000.00, 18000.00, 12, 1, 1, NULL, '2026-05-06 19:34:04'),
(2, NULL, 'Camiseta premium', 'camiseta-premium', NULL, 30000.00, 20000.00, 16, 1, 1, NULL, '2026-05-06 20:54:37'),
(5, NULL, 'Polo deportivo', 'polo-deportivo', NULL, 35000.00, 25000.00, 12, 1, 1, NULL, '2026-05-26 17:56:12');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('1oGvAYmQ38LSAucfixgdVLtxhXZXWCXUT59wgOKR', NULL, '127.0.0.1', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidkJycFZnN3pJUnN6UDNwWThPYlpON2MxUjRDRWdzZnprZ3dKbkFzYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779476638),
('5AoLDsJeeD6MCuqfZ51mCcDByA49mUYuRtpn1i0U', NULL, '127.0.0.1', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieHpscW44STA2UDY2WU1VaWptSEtiMEh2a2lyUnZJTXhsVFc1blZuNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779821134),
('buGLdwgWdOix7E2R7YqFPDQOb66r4ux6e0IrjYic', NULL, '127.0.0.1', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTGprUldiWmtBZUFUU0hDc0pyYzVhR2pYN2V1S2U5aFBjdmxuVVczYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779476949),
('CdSZlZ4MUrIeif9EamOS97U50kd2JVn9TMeyxdK0', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.121.0 Chrome/142.0.7444.265 Electron/39.8.8 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWW15OElSQXRmS2Voc0s0Snd0dWZZeFVTT3NtTzZDenVYUUtoRkRqVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779826146),
('CInKXL6WI8toFa6OeiIo97Jdc9jXNfe3MkK0xSKG', NULL, '172.18.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTE9RZllNWU9zSTZlQkdpN0xMRVpXZlJPeXpwNEp3aHV1VDFnaFZVYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1777054958),
('DGovnC562AlH43dm12VrVAE7bH60mmwVjy0WYaVY', NULL, '127.0.0.1', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieGpzWTNyVjUzVEVmOThhY0RaV0F2elR2MXc3WjlWbGpKalBTYmJJOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779314413),
('DWxzrtBH8KLunutJIxPpHGFwxJiFxOAqoriIzcTL', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 OPR/131.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic2NjWGxmMUNGYmE1UUYxeG15MkFZZUNkanh1VDRoN0FwdnNhTVNjMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1780943948),
('FPmjQnISeXQYigScdUi4dgZmPS15HYu8o7QAZNJx', NULL, '127.0.0.1', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMngyb3hObk9TYUtVclZZdTRYWlFDUE1VMW1oZ09nOE11cm5PRjhPTCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779906543),
('oSuZ37wPOTqv9vrm4RbWx4jKwSSg5Rn1iC33kgWv', NULL, '127.0.0.1', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWXQ0SGtsZjlVOUxJOHppUUlKeWhrS0NaM3JIR3l6RVZGNzZzVGxQUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779914554),
('PTtmOe8yU079uwauZFC8bSQVf1VmwA9mWoAAld4n', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.121.0 Chrome/142.0.7444.265 Electron/39.8.8 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS3pub281azZ5S3RQOHRuS3FuRkhCcEh6TUhURXQzSHhnS0RpWUZmTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779817446),
('rKq5CZ6VeVHhro5wIWVwF2L2nXoCHxw1lDHHeXpD', NULL, '172.18.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUt2YUlIRFcxeWpJdmtiV0F2aFduaEZTQTRBTWdHS3BIcTB0NEh6YiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1776892464),
('S1O837tz1gQB2LRQQPucdKvH0EH2xEEj5kzbr5na', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.121.0 Chrome/142.0.7444.265 Electron/39.8.8 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNDR1YmNYS3lhQ2cwUHR4UzZKd3hwY2tjU1RUNWdVbzlwMjhzV2hLZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779745625),
('sKHYM32OJMTjWlFfRQ4cbzN42o9rfqseS8wGV11f', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.121.0 Chrome/142.0.7444.265 Electron/39.8.8 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoialAzSWluR21nSzFqN2ZtcVZaQXdJY3hrM0VxTEpQNHQ3NlpSQnhzYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779906312),
('u7U6z70U4007juVikRYtRt3J8ZEe99aaYdqPK0VD', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.120.0 Chrome/142.0.7444.265 Electron/39.8.8 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidDRYZ0RaNmRpNkpQcnpmejQ3SVB1WTN2MVdWOXJIaDhLTUZkTVZhSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779314405),
('Uo6drstSYmv5zXWtgzwdIfSYSfQykj2IlkRp0UH5', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.121.0 Chrome/142.0.7444.265 Electron/39.8.8 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVE14VWx5UndwcmtsY0dZbjM5VmhENGY0WDJLQ1BMdEUxTWpjVlJWYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779475209),
('UYX2dZmrDzNKaAYKcEfaPnI258IspgNysi40T8jr', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.121.0 Chrome/142.0.7444.265 Electron/39.8.8 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVUxuUHplWkJBYU1ZTDlreUlkTGd0cWQwU01jTGhqVHVtc0NBNnJWayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779914535),
('v5kzK9XYP30mqhogYR2FV9vHjwyxBhO8Fit3h5EW', NULL, '172.18.0.1', 'Thunder Client (https://www.thunderclient.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ1dOTjM4amlIS2haaUlQa1R0UjZON3FDS2tvR2FWdnRhSGFESjltWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1778091147),
('w9RSKYEKiTt7qp0UIAA6HAGGrhFPhlLcOcIyc9y4', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.122.1 Chrome/142.0.7444.265 Electron/39.8.8 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNW5HR2Vaa1NrekwwY3J4T1M5Q1hJY2FuVXI2T2NQV0Zpb1VDaDFTSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1780423671);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tokens_restablecimiento_password`
--

CREATE TABLE `tokens_restablecimiento_password` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(180) NOT NULL,
  `token` varchar(255) NOT NULL,
  `creado_en` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(180) NOT NULL,
  `password` varchar(255) DEFAULT NULL COMMENT 'NULL si usa Google OAuth',
  `google_id` varchar(100) DEFAULT NULL,
  `rol` enum('cliente','admin','super_admin') DEFAULT 'cliente',
  `telefono` varchar(20) DEFAULT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `email_verificado_en` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `eliminado_en` timestamp NULL DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `password`, `google_id`, `rol`, `telefono`, `avatar_url`, `email_verificado_en`, `remember_token`, `eliminado_en`, `creado_en`, `actualizado_en`) VALUES
(1, 'Alejandro', 'test@gmail.com', '$2y$12$jaaZNDO.XKDO432O90tRG.WWoSqjdPgBa1OgSetWo89.otsoER6DG', NULL, 'cliente', NULL, NULL, NULL, NULL, NULL, '2026-04-24 19:10:54', '2026-04-24 19:10:54'),
(7, 'Jeffrey hermoso divino', 'jeffrey232008suarez@gmail.com', '$2y$12$y7hNmzOV43ks7URJgmKWBO6znmC9O2mU2EzBWsUZmuR9fm7FH/K2K', NULL, 'super_admin', '111111', NULL, '2026-06-09 01:10:29', NULL, NULL, '2026-06-08 20:10:14', '2026-06-09 14:56:41'),
(8, 'GABO', 'GAB@GMAIL.COM', '$2y$12$LE8.EjDkoAZ/W7a61EBw.Oe0T7kszClt5M0J0kZ95RE6cPquJ12vq', NULL, 'cliente', '111122222', NULL, NULL, NULL, NULL, '2026-06-08 22:46:00', '2026-06-08 22:46:00'),
(9, 'evelyn', 'edfssdf@gmail.com', '$2y$12$eHOvT4NPCL2bXPtf5dghluQ/dFYRp38gNqdZqRzmqEq0rxdpm63jm', NULL, 'cliente', '324324324', NULL, NULL, NULL, NULL, '2026-06-08 22:52:16', '2026-06-08 22:52:16'),
(10, 'evelyn', 'evelyn@gmail.com', '$2y$12$6XZA8qZSszGMP/bdzaqMtezA7sJJV0M.d/FIoVUiI9c6tpcKf1WW6', NULL, 'cliente', '123', NULL, '2026-06-09 03:57:06', NULL, NULL, '2026-06-08 22:55:36', '2026-06-08 22:57:06'),
(14, 'beatriz', 'beatrizcatano0121@gmail.com', '$2y$12$2yB74Wz9o8arcPTqRdc1dOLOHl/Kvgtiy2Z/k4HnGPIMIe19wNVT2', NULL, 'cliente', '342432324', NULL, '2026-06-09 04:10:39', NULL, NULL, '2026-06-08 23:10:10', '2026-06-08 23:10:39');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `variantes_producto`
--

CREATE TABLE `variantes_producto` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `producto_id` bigint(20) UNSIGNED NOT NULL,
  `lona_id` bigint(20) UNSIGNED DEFAULT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `talla` varchar(10) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  `precio_extra` decimal(10,2) DEFAULT 0.00,
  `eliminado_en` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `variantes_producto`
--

INSERT INTO `variantes_producto` (`id`, `producto_id`, `lona_id`, `sku`, `color`, `talla`, `stock`, `precio_extra`, `eliminado_en`) VALUES
(2, 5, 1, 'POLO-001', 'Azul', 'M', 18, 0.00, NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indices de la tabla `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indices de la tabla `carritos`
--
ALTER TABLE `carritos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_carrito_usuario` (`usuario_id`),
  ADD KEY `cupon_id` (`cupon_id`);

--
-- Indices de la tabla `carrito_items`
--
ALTER TABLE `carrito_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_carrito` (`carrito_id`,`variante_id`),
  ADD KEY `variante_id` (`variante_id`),
  ADD KEY `idx_carrito` (`carrito_id`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `padre_id` (`padre_id`);

--
-- Indices de la tabla `configuraciones_cms`
--
ALTER TABLE `configuraciones_cms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clave` (`clave`),
  ADD KEY `actualizado_por` (`actualizado_por`);

--
-- Indices de la tabla `contactos`
--
ALTER TABLE `contactos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cupones`
--
ALTER TABLE `cupones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`);

--
-- Indices de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orden_id` (`orden_id`),
  ADD KEY `resuelto_por` (`resuelto_por`);

--
-- Indices de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `dotaciones`
--
ALTER TABLE `dotaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `envios`
--
ALTER TABLE `envios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_envio_orden` (`orden_id`),
  ADD KEY `idx_estado_envio` (`estado`);

--
-- Indices de la tabla `historial_lonas`
--
ALTER TABLE `historial_lonas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lona_id` (`lona_id`),
  ADD KEY `creado_por` (`creado_por`);

--
-- Indices de la tabla `imagenes_producto`
--
ALTER TABLE `imagenes_producto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `producto_id` (`producto_id`),
  ADD KEY `variante_id` (`variante_id`);

--
-- Indices de la tabla `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indices de la tabla `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `lonas`
--
ALTER TABLE `lonas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `dotacion_id` (`dotacion_id`);

--
-- Indices de la tabla `lona_tallas`
--
ALTER TABLE `lona_tallas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `lona_id` (`lona_id`,`talla`),
  ADD KEY `idx_lona_talla` (`lona_id`,`talla`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `confirmado_por` (`confirmado_por`);

--
-- Indices de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero` (`numero`),
  ADD KEY `cupon_id` (`cupon_id`),
  ADD KEY `idx_usuario` (`usuario_id`),
  ADD KEY `idx_direccion` (`direccion_id`);

--
-- Indices de la tabla `orden_items`
--
ALTER TABLE `orden_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_orden` (`orden_id`),
  ADD KEY `idx_variante` (`variante_id`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pago_orden` (`orden_id`),
  ADD KEY `idx_estado_pago` (`estado`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indices de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `categoria_id` (`categoria_id`);
ALTER TABLE `productos` ADD FULLTEXT KEY `nombre` (`nombre`,`descripcion`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indices de la tabla `tokens_restablecimiento_password`
--
ALTER TABLE `tokens_restablecimiento_password`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_token` (`token`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `google_id` (`google_id`),
  ADD KEY `idx_usuarios_rol` (`rol`);

--
-- Indices de la tabla `variantes_producto`
--
ALTER TABLE `variantes_producto`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `producto_id` (`producto_id`,`color`,`talla`),
  ADD KEY `idx_filtros` (`color`,`talla`,`stock`),
  ADD KEY `idx_lona` (`lona_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `banners`
--
ALTER TABLE `banners`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `carritos`
--
ALTER TABLE `carritos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `carrito_items`
--
ALTER TABLE `carrito_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `configuraciones_cms`
--
ALTER TABLE `configuraciones_cms`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `contactos`
--
ALTER TABLE `contactos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `cupones`
--
ALTER TABLE `cupones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `dotaciones`
--
ALTER TABLE `dotaciones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `envios`
--
ALTER TABLE `envios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `historial_lonas`
--
ALTER TABLE `historial_lonas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `imagenes_producto`
--
ALTER TABLE `imagenes_producto`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `lonas`
--
ALTER TABLE `lonas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `lona_tallas`
--
ALTER TABLE `lona_tallas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `orden_items`
--
ALTER TABLE `orden_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tokens_restablecimiento_password`
--
ALTER TABLE `tokens_restablecimiento_password`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `variantes_producto`
--
ALTER TABLE `variantes_producto`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `carritos`
--
ALTER TABLE `carritos`
  ADD CONSTRAINT `carritos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `carritos_ibfk_2` FOREIGN KEY (`cupon_id`) REFERENCES `cupones` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `carrito_items`
--
ALTER TABLE `carrito_items`
  ADD CONSTRAINT `carrito_items_ibfk_1` FOREIGN KEY (`carrito_id`) REFERENCES `carritos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `carrito_items_ibfk_2` FOREIGN KEY (`variante_id`) REFERENCES `variantes_producto` (`id`);

--
-- Filtros para la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD CONSTRAINT `categorias_ibfk_1` FOREIGN KEY (`padre_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `configuraciones_cms`
--
ALTER TABLE `configuraciones_cms`
  ADD CONSTRAINT `configuraciones_cms_ibfk_1` FOREIGN KEY (`actualizado_por`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD CONSTRAINT `devoluciones_ibfk_1` FOREIGN KEY (`orden_id`) REFERENCES `ordenes` (`id`),
  ADD CONSTRAINT `devoluciones_ibfk_2` FOREIGN KEY (`resuelto_por`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD CONSTRAINT `direcciones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `envios`
--
ALTER TABLE `envios`
  ADD CONSTRAINT `envios_ibfk_1` FOREIGN KEY (`orden_id`) REFERENCES `ordenes` (`id`);

--
-- Filtros para la tabla `historial_lonas`
--
ALTER TABLE `historial_lonas`
  ADD CONSTRAINT `historial_lonas_ibfk_1` FOREIGN KEY (`lona_id`) REFERENCES `lonas` (`id`),
  ADD CONSTRAINT `historial_lonas_ibfk_2` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `imagenes_producto`
--
ALTER TABLE `imagenes_producto`
  ADD CONSTRAINT `imagenes_producto_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `imagenes_producto_ibfk_2` FOREIGN KEY (`variante_id`) REFERENCES `variantes_producto` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `lonas`
--
ALTER TABLE `lonas`
  ADD CONSTRAINT `lonas_ibfk_1` FOREIGN KEY (`dotacion_id`) REFERENCES `dotaciones` (`id`);

--
-- Filtros para la tabla `lona_tallas`
--
ALTER TABLE `lona_tallas`
  ADD CONSTRAINT `lona_tallas_ibfk_1` FOREIGN KEY (`lona_id`) REFERENCES `lonas` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `notificaciones_ibfk_2` FOREIGN KEY (`confirmado_por`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `ordenes`
--
ALTER TABLE `ordenes`
  ADD CONSTRAINT `ordenes_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `ordenes_ibfk_2` FOREIGN KEY (`direccion_id`) REFERENCES `direcciones` (`id`),
  ADD CONSTRAINT `ordenes_ibfk_3` FOREIGN KEY (`cupon_id`) REFERENCES `cupones` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `orden_items`
--
ALTER TABLE `orden_items`
  ADD CONSTRAINT `orden_items_ibfk_1` FOREIGN KEY (`orden_id`) REFERENCES `ordenes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orden_items_ibfk_2` FOREIGN KEY (`variante_id`) REFERENCES `variantes_producto` (`id`);

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`orden_id`) REFERENCES `ordenes` (`id`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `variantes_producto`
--
ALTER TABLE `variantes_producto`
  ADD CONSTRAINT `variantes_producto_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `variantes_producto_ibfk_2` FOREIGN KEY (`lona_id`) REFERENCES `lonas` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
