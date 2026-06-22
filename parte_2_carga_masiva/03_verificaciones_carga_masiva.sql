
USE food_store;

-- =====================================================
-- PARTE 2 - VERIFICACIONES DE CARGA MASIVA
-- Base de datos: food_store
-- =====================================================

-- 1. Conteo general de registros por tabla
SELECT 'categorias' AS tabla, COUNT(*) AS cantidad FROM categorias
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'usuarios', COUNT(*) FROM usuarios
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'detalle_pedidos', COUNT(*) FROM detalle_pedidos;

--  Productos sin categoría: debe dar 0
SELECT COUNT(*) AS productos_sin_categoria
FROM productos p
LEFT JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE c.id_categoria IS NULL;

-- Pedidos sin usuario: debe dar 0
SELECT COUNT(*) AS pedidos_sin_usuario
FROM pedidos p
LEFT JOIN usuarios u ON p.id_usuario = u.id_usuario
WHERE u.id_usuario IS NULL;

-- Detalles sin pedido: debe dar 0
SELECT COUNT(*) AS detalles_sin_pedido
FROM detalle_pedidos dp
LEFT JOIN pedidos p ON dp.id_pedido = p.id_pedido
WHERE p.id_pedido IS NULL;

-- Detalles sin producto: debe dar 0
SELECT COUNT(*) AS detalles_sin_producto
FROM detalle_pedidos dp
LEFT JOIN productos pr ON dp.id_producto = pr.id_producto
WHERE pr.id_producto IS NULL;

-- Pedidos con total incorrecto: debe dar 0
SELECT COUNT(*) AS pedidos_con_total_incorrecto
FROM pedidos p
INNER JOIN (
    SELECT id_pedido, SUM(subtotal) AS suma_detalles
    FROM detalle_pedidos
    GROUP BY id_pedido
) dp ON p.id_pedido = dp.id_pedido
WHERE p.total <> dp.suma_detalles;