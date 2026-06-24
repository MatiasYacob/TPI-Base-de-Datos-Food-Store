USE food_store;

DROP TABLE IF EXISTS log_transacciones;

CREATE TABLE log_transacciones (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    operacion VARCHAR(80) NOT NULL,
    mensaje VARCHAR(255) NOT NULL
);

START TRANSACTION;
UPDATE productos SET stock = stock - 5 WHERE id_producto = 1;
INSERT INTO log_transacciones(operacion, mensaje)
VALUES ('COMMIT', 'Se desconto stock y se confirmo la transaccion.');
COMMIT;

START TRANSACTION;
UPDATE productos SET stock = stock - 2 WHERE id_producto = 2;
INSERT INTO log_transacciones(operacion, mensaje)
VALUES ('ROLLBACK', 'Se desconto stock pero se revierte la transaccion.');
ROLLBACK;

DROP PROCEDURE IF EXISTS descontar_stock_con_retry;

DELIMITER //

CREATE PROCEDURE descontar_stock_con_retry(
    IN p_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_intentos INT DEFAULT 0;
    DECLARE v_finalizado BOOLEAN DEFAULT FALSE;

    retry_loop: WHILE v_finalizado = FALSE AND v_intentos < 3 DO
        BEGIN
            DECLARE EXIT HANDLER FOR 1213
            BEGIN
                ROLLBACK;
                SET v_intentos = v_intentos + 1;
                DO SLEEP(0.2);
            END;

            START TRANSACTION;

            UPDATE productos
            SET stock = stock - p_cantidad
            WHERE id_producto = p_producto
              AND stock >= p_cantidad;

            IF ROW_COUNT() = 0 THEN
                ROLLBACK;
                INSERT INTO log_transacciones(operacion, mensaje)
                VALUES ('ERROR', 'Stock insuficiente o producto inexistente.');
                SET v_finalizado = TRUE;
            ELSE
                INSERT INTO log_transacciones(operacion, mensaje)
                VALUES ('RETRY_OK', CONCAT('Operacion confirmada en intento ', v_intentos + 1));
                COMMIT;
                SET v_finalizado = TRUE;
            END IF;
        END;
    END WHILE;

    IF v_finalizado = FALSE THEN
        INSERT INTO log_transacciones(operacion, mensaje)
        VALUES ('DEADLOCK', 'Operacion cancelada luego de tres intentos.');
    END IF;
END//

DELIMITER ;

CALL descontar_stock_con_retry(1, 1);

SELECT * FROM log_transacciones ORDER BY id_log DESC;

