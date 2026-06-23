USE food_store;
CREATE USER IF NOT EXISTS 'food_reader'@'localhost' IDENTIFIED BY 'Reader123!';

CREATE OR REPLACE VIEW vista_productos_publicos AS
SELECT
    p.id_producto,
    p.nombre,
    p.descripcion,
    p.precio,
    p.stock,
    c.nombre AS categoria
FROM productos p
JOIN categorias c
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

GRANT SELECT ON food_store.vista_productos_publicos TO 'food_reader'@'localhost';
GRANT SELECT ON food_store.vista_usuarios_publicos TO 'food_reader'@'localhost';

FLUSH PRIVILEGES;

-- Error por UNIQUE
INSERT INTO usuarios (nombre, apellido, email, rol)
VALUES ('Prueba', 'Duplicado', 'juan.perez@email.com', 'CLIENTE');

-- ERROR por FK
INSERT INTO productos(nombre, descripcion, precio, stock, id_categoria)
VALUES('Producto Test', 'Debe fallar', 100, 10, 999);