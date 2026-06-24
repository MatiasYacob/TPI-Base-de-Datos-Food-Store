USE food_store;

INSERT INTO categorias(nombre, descripcion)
VALUES
('Bebidas', 'Bebidas frias y calientes'),
('Hamburguesas', 'Hamburguesas simples y completas'),
('Pizzas', 'Pizzas de diferentes sabores'),
('Postres', 'Opciones dulces'),
('Promociones', 'Combos y ofertas'),
('Ensaladas', 'Opciones frescas y saludables'),
('Pastas', 'Pastas y platos calientes'),
('Sandwiches', 'Sandwiches simples y especiales'),
('Cafeteria', 'Cafe, te y bebidas calientes'),
('Acompanamientos', 'Papas, salsas y guarniciones')
ON DUPLICATE KEY UPDATE
    descripcion = VALUES(descripcion),
    eliminado = FALSE;

SELECT 'categorias' AS tabla, COUNT(*) AS cantidad
FROM categorias;

