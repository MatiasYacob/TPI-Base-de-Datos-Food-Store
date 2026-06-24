USE food_store;

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

CREATE OR REPLACE VIEW vista_productos_publicos AS
SELECT
    p.id_producto,
    p.nombre,
    p.descripcion,
    p.precio,
    p.stock,
    c.nombre AS categoria
FROM productos p
INNER JOIN categorias c
    ON p.id_categoria = c.id_categoria
WHERE p.eliminado = FALSE;

CREATE OR REPLACE VIEW vista_usuarios_publicos AS
SELECT
    id_usuario,
    nombre,
    apellido,
    rol
FROM usuarios
WHERE eliminado = FALSE;

SELECT *
FROM vista_resumen_pedidos
ORDER BY fecha DESC, id_pedido DESC
LIMIT 20;

