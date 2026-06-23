USE food_store;

-- 1. DEADLOCK (DOS SESIONES)

-- SESION A
-- START TRANSACTION;
-- UPDATE productos SET stock = stock - 1 WHERE id_producto = 1;
-- (esperar SESION B)
-- UPDATE productos SET stock = stock - 1 WHERE id_producto = 2;
-- COMMIT;

-- SESION B
-- START TRANSACTION;
-- UPDATE productos SET stock = stock - 1 WHERE id_producto = 2;
-- (esperar SESION A)
-- UPDATE productos SET stock = stock - 1 WHERE id_producto = 1;
-- COMMIT;

-- Resultado esperado: ERROR 1213 (deadlock)


-- 2. COMMIT vs ROLLBACK

-- EJEMPLO COMMIT
START TRANSACTION;
UPDATE productos SET stock = stock - 5 WHERE id_producto = 1;
COMMIT;

-- EJEMPLO ROLLBACK
START TRANSACTION;
UPDATE productos SET stock = stock - 2 WHERE id_producto = 2;
ROLLBACK;


-- 3. ISOLATION LEVEL - READ COMMITTED

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;
SELECT stock FROM productos WHERE id_producto = 1;
-- (otra sesion modifica y hace COMMIT)
SELECT stock FROM productos WHERE id_producto = 1;
COMMIT;


-- 4. ISOLATION LEVEL - REPEATABLE READ

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;
SELECT stock FROM productos WHERE id_producto = 1;
-- (otra sesion modifica y hace COMMIT)
SELECT stock FROM productos WHERE id_producto = 1;
COMMIT;