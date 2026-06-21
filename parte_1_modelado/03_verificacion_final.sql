USE food_store;

SHOW TABLES;

SELECT 'categorias' AS tabla, COUNT(*) AS cantidad FROM categorias
UNION ALL
SELECT 'usuarios', COUNT(*) FROM usuarios
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'detalle_pedidos', COUNT(*) FROM detalle_pedidos;

SELECT
    p.id_pedido,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario,
    p.fecha,
    p.estado,
    p.forma_pago,
    p.total
FROM pedidos p
INNER JOIN usuarios u ON p.id_usuario = u.id_usuario;

SELECT
    dp.id_detalle,
    dp.id_pedido,
    pr.nombre AS producto,
    dp.cantidad,
    dp.precio_unitario,
    dp.subtotal
FROM detalle_pedidos dp
INNER JOIN productos pr ON dp.id_producto = pr.id_producto;

