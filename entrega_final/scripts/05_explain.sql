USE food_store;

EXPLAIN
SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';

SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';

EXPLAIN
SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha <  '2026-03-08';

SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha <  '2026-03-08';

EXPLAIN
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

