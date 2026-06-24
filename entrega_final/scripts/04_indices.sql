USE food_store;

DROP PROCEDURE IF EXISTS crear_indice_si_no_existe;

DELIMITER //

CREATE PROCEDURE crear_indice_si_no_existe(
    IN p_tabla VARCHAR(64),
    IN p_indice VARCHAR(64),
    IN p_columnas VARCHAR(255)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = p_tabla
          AND index_name = p_indice
    ) THEN
        SET @sql = CONCAT('CREATE INDEX ', p_indice, ' ON ', p_tabla, '(', p_columnas, ')');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END//

DELIMITER ;

CALL crear_indice_si_no_existe('usuarios', 'idx_usuarios_apellido', 'apellido');
CALL crear_indice_si_no_existe('pedidos', 'idx_pedidos_fecha', 'fecha');
CALL crear_indice_si_no_existe('usuarios', 'idx_usuarios_rol_id', 'rol, id_usuario');

DROP PROCEDURE IF EXISTS crear_indice_si_no_existe;

SHOW INDEX FROM usuarios;
SHOW INDEX FROM pedidos;

