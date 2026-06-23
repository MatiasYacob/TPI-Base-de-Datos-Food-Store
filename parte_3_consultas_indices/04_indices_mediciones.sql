USE food_store;

-- =====================================================
-- PARTE 3 - INDICES, EXPLAIN Y MEDICIONES
-- Proyecto: Food Store
-- =====================================================
-- IMPORTANTE:
-- 1. Ejecutar los bloques por separado, no todo el archivo de una vez.
-- 2. Registrar Duration / Fetch Time de MySQL Workbench.
-- 3. Ejecutar cada SELECT tres veces sin indice y tres veces con indice.
-- 4. La mediana de tres valores es el valor central luego de ordenarlos.
-- =====================================================

-- -----------------------------------------------------
-- PASO 0 - REVISAR LOS INDICES QUE YA EXISTEN
-- Las PK, UNIQUE y FK ya generan indices. Por eso las
-- pruebas usan columnas que no estaban indexadas.
-- -----------------------------------------------------
SHOW INDEX FROM usuarios;
SHOW INDEX FROM pedidos;

-- Si este archivo ya fue ejecutado anteriormente, eliminar
-- manualmente los indices de prueba antes de medir sin indice:
-- DROP INDEX idx_usuarios_apellido ON usuarios;
-- DROP INDEX idx_pedidos_fecha ON pedidos;
-- DROP INDEX idx_usuarios_rol_id ON usuarios;


-- =====================================================
-- PRUEBA 1 - BUSQUEDA POR IGUALDAD
-- Columna elegida: usuarios.apellido
-- Valor existente y selectivo: Apellido40000
-- =====================================================

-- EXPLAIN SIN INDICE
EXPLAIN
SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';

-- EJECUTAR TRES VECES SIN INDICE Y ANOTAR LOS TIEMPOS
SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';

SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';

SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';

-- CREAR INDICE
CREATE INDEX idx_usuarios_apellido
ON usuarios(apellido);

-- EXPLAIN CON INDICE
EXPLAIN
SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';

-- EJECUTAR TRES VECES CON INDICE Y ANOTAR LOS TIEMPOS
SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';

SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';

SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';


-- =====================================================
-- PRUEBA 2 - BUSQUEDA POR RANGO
-- Columna elegida: pedidos.fecha
-- Se usa COUNT para evitar que el tiempo de transferencia
-- de miles de filas distorsione la medicion.
-- =====================================================

-- EXPLAIN SIN INDICE
EXPLAIN
SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha <  '2026-03-08';

-- EJECUTAR TRES VECES SIN INDICE Y ANOTAR LOS TIEMPOS
SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha <  '2026-03-08';

SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha <  '2026-03-08';

SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha <  '2026-03-08';

-- CREAR INDICE
CREATE INDEX idx_pedidos_fecha
ON pedidos(fecha);

-- EXPLAIN CON INDICE
EXPLAIN
SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha <  '2026-03-08';

-- EJECUTAR TRES VECES CON INDICE Y ANOTAR LOS TIEMPOS
SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha <  '2026-03-08';

SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha <  '2026-03-08';

SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha <  '2026-03-08';


-- =====================================================
-- PRUEBA 3 - CONSULTA CON JOIN
-- Se cuentan los pedidos realizados por administradores.
-- En la carga masiva, aproximadamente el 1% de los usuarios
-- tiene rol ADMINISTRADOR, por lo que el indice es selectivo.
-- =====================================================

-- EXPLAIN SIN EL INDICE DE PRUEBA
EXPLAIN
SELECT COUNT(*) AS pedidos_de_administradores
FROM usuarios u
INNER JOIN pedidos pe
    ON pe.id_usuario = u.id_usuario
WHERE u.rol = 'ADMINISTRADOR';

-- EJECUTAR TRES VECES SIN INDICE Y ANOTAR LOS TIEMPOS
SELECT COUNT(*) AS pedidos_de_administradores
FROM usuarios u
INNER JOIN pedidos pe
    ON pe.id_usuario = u.id_usuario
WHERE u.rol = 'ADMINISTRADOR';

SELECT COUNT(*) AS pedidos_de_administradores
FROM usuarios u
INNER JOIN pedidos pe
    ON pe.id_usuario = u.id_usuario
WHERE u.rol = 'ADMINISTRADOR';

SELECT COUNT(*) AS pedidos_de_administradores
FROM usuarios u
INNER JOIN pedidos pe
    ON pe.id_usuario = u.id_usuario
WHERE u.rol = 'ADMINISTRADOR';

-- CREAR INDICE COMPUESTO PARA FILTRAR POR ROL Y DISPONER
-- DEL ID QUE SE USA EN LA UNION.
CREATE INDEX idx_usuarios_rol_id
ON usuarios(rol, id_usuario);

-- EXPLAIN CON INDICE
EXPLAIN
SELECT COUNT(*) AS pedidos_de_administradores
FROM usuarios u
INNER JOIN pedidos pe
    ON pe.id_usuario = u.id_usuario
WHERE u.rol = 'ADMINISTRADOR';

-- EJECUTAR TRES VECES CON INDICE Y ANOTAR LOS TIEMPOS
SELECT COUNT(*) AS pedidos_de_administradores
FROM usuarios u
INNER JOIN pedidos pe
    ON pe.id_usuario = u.id_usuario
WHERE u.rol = 'ADMINISTRADOR';

SELECT COUNT(*) AS pedidos_de_administradores
FROM usuarios u
INNER JOIN pedidos pe
    ON pe.id_usuario = u.id_usuario
WHERE u.rol = 'ADMINISTRADOR';

SELECT COUNT(*) AS pedidos_de_administradores
FROM usuarios u
INNER JOIN pedidos pe
    ON pe.id_usuario = u.id_usuario
WHERE u.rol = 'ADMINISTRADOR';


-- -----------------------------------------------------
-- VERIFICACION FINAL DE LOS INDICES CREADOS
-- -----------------------------------------------------
SHOW INDEX FROM usuarios;
SHOW INDEX FROM pedidos;
