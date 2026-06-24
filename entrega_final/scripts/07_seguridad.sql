USE food_store;

DROP USER IF EXISTS 'food_reader'@'localhost';
CREATE USER 'food_reader'@'localhost' IDENTIFIED BY 'Reader123!';

GRANT SELECT ON food_store.vista_productos_publicos TO 'food_reader'@'localhost';
GRANT SELECT ON food_store.vista_usuarios_publicos TO 'food_reader'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'food_reader'@'localhost';

DROP PROCEDURE IF EXISTS buscar_usuario_publico_seguro;

DELIMITER //

CREATE PROCEDURE buscar_usuario_publico_seguro(IN p_texto VARCHAR(120))
BEGIN
    SELECT id_usuario, nombre, apellido, rol
    FROM vista_usuarios_publicos
    WHERE nombre = p_texto
       OR apellido = p_texto
    LIMIT 20;
END//

DELIMITER ;

CALL buscar_usuario_publico_seguro('Usuario10');

-- Prueba anti-inyeccion:
-- La entrada se trata como texto literal dentro del parametro p_texto.
CALL buscar_usuario_publico_seguro(''' OR ''1''=''1');

-- Pruebas de integridad documentadas:
-- Ejecutar de a una para ver el error esperado.
-- INSERT INTO usuarios (nombre, apellido, email, rol)
-- VALUES ('Prueba', 'Duplicado', 'usuario1@foodstore.com', 'CLIENTE');
-- INSERT INTO productos(nombre, descripcion, precio, stock, id_categoria)
-- VALUES('Producto Test', 'Debe fallar por FK', 100, 10, 999);

