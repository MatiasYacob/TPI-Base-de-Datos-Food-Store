USE food_store;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE detalle_pedidos;
TRUNCATE TABLE pedidos;
TRUNCATE TABLE productos;
TRUNCATE TABLE usuarios;
DROP TABLE IF EXISTS numeros;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE numeros (
    n INT PRIMARY KEY
);

INSERT INTO numeros(n)
SELECT
    unidades.n
    + decenas.n * 10
    + centenas.n * 100
    + miles.n * 1000
    + dec_miles.n * 10000
    + 1 AS n
FROM
    (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) unidades
CROSS JOIN
    (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) decenas
CROSS JOIN
    (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) centenas
CROSS JOIN
    (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) miles
CROSS JOIN
    (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) dec_miles
WHERE
    unidades.n
    + decenas.n * 10
    + centenas.n * 100
    + miles.n * 1000
    + dec_miles.n * 10000
    + 1 <= 100000;

INSERT INTO productos(nombre, descripcion, precio, stock, id_categoria)
SELECT
    CONCAT('Producto ', n),
    CONCAT('Producto generado automaticamente para carga masiva ', n),
    ROUND(1000 + (MOD(n, 300) * 18.75), 2),
    10 + MOD(n, 200),
    1 + MOD(n - 1, 10)
FROM numeros
WHERE n <= 1000;

INSERT INTO usuarios(nombre, apellido, email, rol)
SELECT
    CONCAT('Usuario', n),
    CONCAT('Apellido', n),
    CONCAT('usuario', n, '@foodstore.com'),
    CASE
        WHEN MOD(n, 100) = 0 THEN 'ADMINISTRADOR'
        ELSE 'CLIENTE'
    END
FROM numeros
WHERE n <= 50000;

INSERT INTO pedidos(id_usuario, fecha, estado, forma_pago, total)
SELECT
    1 + MOD(n - 1, 50000),
    DATE_ADD('2026-01-01', INTERVAL MOD(n, 180) DAY),
    CASE MOD(n, 4)
        WHEN 0 THEN 'PENDIENTE'
        WHEN 1 THEN 'CONFIRMADO'
        WHEN 2 THEN 'ENTREGADO'
        ELSE 'CANCELADO'
    END,
    CASE MOD(n, 3)
        WHEN 0 THEN 'EFECTIVO'
        WHEN 1 THEN 'TARJETA'
        ELSE 'TRANSFERENCIA'
    END,
    0
FROM numeros
WHERE n <= 100000;

INSERT INTO detalle_pedidos(id_pedido, id_producto, cantidad, precio_unitario, subtotal)
SELECT
    num.n AS id_pedido,
    pr.id_producto,
    1 + MOD(num.n, 4) AS cantidad,
    pr.precio AS precio_unitario,
    (1 + MOD(num.n, 4)) * pr.precio AS subtotal
FROM numeros num
INNER JOIN productos pr
    ON pr.id_producto = 1 + MOD(num.n - 1, 1000)
WHERE num.n <= 100000;

UPDATE pedidos p
INNER JOIN (
    SELECT id_pedido, SUM(subtotal) AS total_calculado
    FROM detalle_pedidos
    GROUP BY id_pedido
) dp ON p.id_pedido = dp.id_pedido
SET p.total = dp.total_calculado
WHERE p.id_pedido > 0;

SELECT 'categorias' AS tabla, COUNT(*) AS cantidad FROM categorias
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'usuarios', COUNT(*) FROM usuarios
UNION ALL SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL SELECT 'detalle_pedidos', COUNT(*) FROM detalle_pedidos;

