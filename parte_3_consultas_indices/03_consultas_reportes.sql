USE food_store;

-- =====================================================
-- PARTE 3 - CONSULTAS AVANZADAS, REPORTES Y VISTA
-- Proyecto: Food Store
-- =====================================================

-- -----------------------------------------------------
-- CONSULTA 1
-- Total vendido por categoria, sin considerar pedidos
-- cancelados ni registros eliminados.
-- Cumple: JOIN, GROUP BY, SUM y ORDER BY.
-- -----------------------------------------------------
SELECT
    c.id_categoria,
    c.nombre AS categoria,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.subtotal) AS total_vendido
FROM detalle_pedidos dp
INNER JOIN pedidos pe
    ON pe.id_pedido = dp.id_pedido
INNER JOIN productos pr
    ON pr.id_producto = dp.id_producto
INNER JOIN categorias c
    ON c.id_categoria = pr.id_categoria
WHERE pe.estado <> 'CANCELADO'
  AND pe.eliminado = FALSE
  AND dp.eliminado = FALSE
  AND pr.eliminado = FALSE
  AND c.eliminado = FALSE
GROUP BY c.id_categoria, c.nombre
ORDER BY total_vendido DESC;


-- -----------------------------------------------------
-- CONSULTA 2
-- Diez productos con mayor cantidad vendida.
-- Como criterio secundario se utiliza el importe vendido.
-- Cumple: JOIN, GROUP BY, SUM, ORDER BY y LIMIT.
-- -----------------------------------------------------
SELECT
    pr.id_producto,
    pr.nombre AS producto,
    c.nombre AS categoria,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.subtotal) AS total_vendido
FROM detalle_pedidos dp
INNER JOIN pedidos pe
    ON pe.id_pedido = dp.id_pedido
INNER JOIN productos pr
    ON pr.id_producto = dp.id_producto
INNER JOIN categorias c
    ON c.id_categoria = pr.id_categoria
WHERE pe.estado <> 'CANCELADO'
  AND pe.eliminado = FALSE
  AND dp.eliminado = FALSE
  AND pr.eliminado = FALSE
GROUP BY pr.id_producto, pr.nombre, c.nombre
ORDER BY unidades_vendidas DESC, total_vendido DESC
LIMIT 10;


-- -----------------------------------------------------
-- CONSULTA 3
-- Usuarios con al menos dos pedidos no cancelados y un
-- gasto acumulado superior a 20000.
-- Cumple: JOIN, GROUP BY y HAVING.
-- -----------------------------------------------------
SELECT
    u.id_usuario,
    u.nombre,
    u.apellido,
    COUNT(pe.id_pedido) AS cantidad_pedidos,
    SUM(pe.total) AS total_comprado
FROM usuarios u
INNER JOIN pedidos pe
    ON pe.id_usuario = u.id_usuario
WHERE pe.estado <> 'CANCELADO'
  AND u.eliminado = FALSE
  AND pe.eliminado = FALSE
GROUP BY u.id_usuario, u.nombre, u.apellido
HAVING COUNT(pe.id_pedido) >= 2
   AND SUM(pe.total) > 20000
ORDER BY total_comprado DESC
LIMIT 20;


-- -----------------------------------------------------
-- CONSULTA 4
-- Pedidos no cancelados cuyo total supera el promedio
-- de los pedidos no cancelados.
-- Cumple: JOIN y subconsulta.
-- -----------------------------------------------------
SELECT
    pe.id_pedido,
    pe.fecha,
    pe.estado,
    pe.forma_pago,
    pe.total,
    u.id_usuario,
    u.nombre,
    u.apellido
FROM pedidos pe
INNER JOIN usuarios u
    ON u.id_usuario = pe.id_usuario
WHERE pe.estado <> 'CANCELADO'
  AND pe.eliminado = FALSE
  AND u.eliminado = FALSE
  AND pe.total > (
        SELECT AVG(p2.total)
        FROM pedidos p2
        WHERE p2.estado <> 'CANCELADO'
          AND p2.eliminado = FALSE
  )
ORDER BY pe.total DESC
LIMIT 20;


-- =====================================================
-- VISTA UTIL PARA REPORTES
-- Reune los datos principales del pedido y del usuario.
-- =====================================================
CREATE OR REPLACE VIEW vista_resumen_pedidos AS
SELECT
    pe.id_pedido,
    pe.fecha,
    pe.estado,
    pe.forma_pago,
    pe.total,
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.email
FROM pedidos pe
INNER JOIN usuarios u
    ON u.id_usuario = pe.id_usuario
WHERE pe.eliminado = FALSE
  AND u.eliminado = FALSE;

-- Verificacion de la vista.
SELECT *
FROM vista_resumen_pedidos
ORDER BY fecha DESC, id_pedido DESC
LIMIT 20;
