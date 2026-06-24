USE food_store;

-- GUIA DE PRUEBA DE CONCURRENCIA EN DOS SESIONES MYSQL
-- Abrir dos pestañas/conexiones en MySQL Workbench: SESION A y SESION B.

-- =====================================================
-- PRUEBA 1 - DEADLOCK
-- =====================================================

-- SESION A:
-- START TRANSACTION;
-- UPDATE productos SET stock = stock - 1 WHERE id_producto = 1;
-- Esperar a que SESION B actualice el producto 2.
-- UPDATE productos SET stock = stock - 1 WHERE id_producto = 2;
-- COMMIT;

-- SESION B:
-- START TRANSACTION;
-- UPDATE productos SET stock = stock - 1 WHERE id_producto = 2;
-- Esperar a que SESION A intente actualizar el producto 2.
-- UPDATE productos SET stock = stock - 1 WHERE id_producto = 1;
-- COMMIT;

-- Resultado observado: MySQL detecta espera circular y devuelve ERROR 1213.

-- =====================================================
-- PRUEBA 2 - READ COMMITTED
-- =====================================================

-- SESION A:
-- SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- START TRANSACTION;
-- SELECT stock FROM productos WHERE id_producto = 1;
-- Ejecutar la modificacion y COMMIT en SESION B.
-- SELECT stock FROM productos WHERE id_producto = 1;
-- COMMIT;

-- SESION B:
-- START TRANSACTION;
-- UPDATE productos SET stock = stock + 1 WHERE id_producto = 1;
-- COMMIT;

-- Resultado observado: SESION A puede ver el cambio confirmado por SESION B
-- en la segunda lectura.

-- =====================================================
-- PRUEBA 3 - REPEATABLE READ
-- =====================================================

-- SESION A:
-- SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- START TRANSACTION;
-- SELECT stock FROM productos WHERE id_producto = 1;
-- Ejecutar la modificacion y COMMIT en SESION B.
-- SELECT stock FROM productos WHERE id_producto = 1;
-- COMMIT;

-- SESION B:
-- START TRANSACTION;
-- UPDATE productos SET stock = stock + 1 WHERE id_producto = 1;
-- COMMIT;

-- Resultado observado: SESION A mantiene la misma lectura dentro de su
-- transaccion hasta confirmar o cerrar la operacion.

