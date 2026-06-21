USE food_store;

INSERT INTO categorias (nombre, descripcion)
VALUES
('Bebidas', 'Productos liquidos para consumo'),
('Comidas', 'Platos principales y comidas preparadas'),
('Postres', 'Productos dulces y postres');

INSERT INTO usuarios (nombre, apellido, email, rol)
VALUES
('Matias', 'Yacob', 'matias.yacob@email.com', 'ADMINISTRADOR'),
('Juan', 'Perez', 'juan.perez@email.com', 'CLIENTE'),
('Ana', 'Gomez', 'ana.gomez@email.com', 'CLIENTE');

INSERT INTO productos (nombre, descripcion, precio, stock, id_categoria)
VALUES
('Agua mineral', 'Botella de agua mineral 500ml', 900.00, 50, 1),
('Hamburguesa', 'Hamburguesa completa con papas', 5500.00, 20, 2),
('Flan', 'Flan casero con dulce de leche', 1800.00, 15, 3);

INSERT INTO pedidos (id_usuario, estado, forma_pago, total)
VALUES
(2, 'PENDIENTE', 'EFECTIVO', 7300.00);

INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario, subtotal)
VALUES
(1, 2, 1, 5500.00, 5500.00),
(1, 3, 1, 1800.00, 1800.00);

SELECT * FROM categorias;
SELECT * FROM usuarios;
SELECT * FROM productos;
SELECT * FROM pedidos;
SELECT * FROM detalle_pedidos;

-- Pruebas de errores esperados.
-- Ejecutar de a una si se quiere demostrar que las restricciones funcionan.

-- Error por nombre de categoria repetido:
-- INSERT INTO categorias (nombre, descripcion) VALUES ('Bebidas', 'Categoria duplicada');

-- Error por email repetido:
-- INSERT INTO usuarios (nombre, apellido, email, rol)
-- VALUES ('Pedro', 'Lopez', 'juan.perez@email.com', 'CLIENTE');

-- Error por precio negativo:
-- INSERT INTO productos (nombre, descripcion, precio, stock, id_categoria)
-- VALUES ('Producto invalido', 'Precio negativo', -10.00, 5, 1);

-- Error por stock negativo:
-- INSERT INTO productos (nombre, descripcion, precio, stock, id_categoria)
-- VALUES ('Stock invalido', 'Stock negativo', 100.00, -1, 1);

-- Error por producto con categoria inexistente:
-- INSERT INTO productos (nombre, descripcion, precio, stock, id_categoria)
-- VALUES ('Sin categoria', 'Categoria inexistente', 100.00, 5, 99);

-- Error por pedido con usuario inexistente:
-- INSERT INTO pedidos (id_usuario, estado, forma_pago, total)
-- VALUES (99, 'PENDIENTE', 'EFECTIVO', 1000.00);

-- Error por detalle con cantidad menor o igual a cero:
-- INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario, subtotal)
-- VALUES (1, 1, 0, 900.00, 0.00);

