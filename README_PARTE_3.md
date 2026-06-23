# Parte 3 - Consultas avanzadas, reportes e indices

## Archivos

- `03_consultas_reportes.sql`: contiene cuatro consultas complejas y la vista `vista_resumen_pedidos`.
- `04_indices_mediciones.sql`: contiene las tres pruebas de rendimiento, los `EXPLAIN` y la creacion de indices.

## Orden de trabajo

1. Abrir y ejecutar `03_consultas_reportes.sql` por bloques.
2. Capturar el codigo y el resultado de cada una de las cuatro consultas.
3. Capturar la creacion y una consulta de la vista.
4. Abrir `04_indices_mediciones.sql`.
5. Ejecutar primero los `SHOW INDEX` para documentar los indices existentes.
6. Para cada prueba, ejecutar el `EXPLAIN` sin el indice de prueba.
7. Ejecutar el `SELECT` tres veces y registrar `Duration / Fetch Time`.
8. Crear el indice correspondiente.
9. Ejecutar el nuevo `EXPLAIN`.
10. Ejecutar nuevamente el `SELECT` tres veces y registrar los tiempos.
11. Calcular la mediana de cada grupo de tres mediciones.

---



## Resultados de las mediciones:
Resultado completo de la prueba 1:
Consulta: Igualdad por apellido | Mediana SIN indice: 0,016s | Mediana CON indice: < 0,001s. Conclusión: El indice redujo la búsqueda de unas 50.064 filas estimadas, a 1 fila.
Resultado completo de la prueba 2:
Consulta: Busqueda por rango | Mediana SIN indice: 0,016s | Mediana CON indice: < 0,001s. Conclusión: El indice redujo el tiempo de búsqueda considerablemente.
Resultado completo de la prueba 3:
Consulta: Busqueda de administradores usando JOIN| Mediana SIN indice: 0,016s | Mediana CON indice: < 0,001s. Conclusión: El indice redujo el tiempo de busqueda

Consultas avanzadas, reportes e índices

## Medición de rendimiento

Las mediciones se realizaron sobre la base de datos `food_store`, que contiene aproximadamente 251.010 registros distribuidos entre las tablas principales.

Para cada prueba se ejecutó la consulta tres veces sin el índice propuesto y tres veces después de crearlo. Como valor representativo se utilizó la mediana, ya que permite reducir la influencia de valores atípicos producidos por la carga inicial de datos en memoria o por la caché del SGBD.

Los tiempos fueron obtenidos desde la columna `Duration / Fetch` de MySQL Workbench.

### Tabla de resultados

| Tipo de consulta                   | Tiempos sin índice          | Mediana sin índice | Tiempos con índice          | Mediana con índice |
| ---------------------------------- | --------------------------- | -----------------: | --------------------------- | -----------------: |
| Igualdad por apellido              | 0,016 s — 0,016 s — 0,016 s |            0,016 s | 0,000 s — 0,000 s — 0,000 s |          < 0,001 s |
| Rango por fecha                    | 0,031 s — 0,015 s — 0,016 s |            0,016 s | 0,000 s — 0,000 s — 0,000 s |          < 0,001 s |
| JOIN de pedidos y usuarios por rol | 0,078 s — 0,015 s — 0,016 s |            0,016 s | 0,031 s — 0,000 s — 0,000 s |          < 0,001 s |

Los valores mostrados como `0,000 s` no significan que la consulta haya tardado literalmente cero segundos. MySQL Workbench redondea los tiempos inferiores a un milisegundo, por lo que se registran como `< 0,001 s`.

---

## Prueba 1 — Búsqueda por igualdad

La consulta buscó un usuario por apellido:

```sql
SELECT id_usuario, nombre, apellido, email
FROM usuarios
WHERE apellido = 'Apellido40000';
```

Antes de crear el índice, `EXPLAIN` mostró:

* `type = ALL`
* `key = NULL`
* `rows = 50064`
* `Extra = Using where`

Esto indica que MySQL debía recorrer prácticamente toda la tabla `usuarios`.

Luego se creó el índice:

```sql
CREATE INDEX idx_usuarios_apellido
ON usuarios(apellido);
```

Después de crear el índice, `EXPLAIN` mostró:

* `type = ref`
* `key = idx_usuarios_apellido`
* `rows = 1`
* `Extra = Using index condition`

La cantidad estimada de filas examinadas se redujo de 50.064 a 1.

---

## Prueba 2 — Búsqueda por rango

La consulta contó los pedidos realizados dentro de un intervalo de fechas:

```sql
SELECT COUNT(*) AS pedidos_en_rango
FROM pedidos
WHERE fecha >= '2026-03-01'
  AND fecha < '2026-03-08';
```

El resultado fue de 3.892 pedidos.

Antes de crear el índice, `EXPLAIN` mostró:

* `type = ALL`
* `key = NULL`
* `rows = 100224`
* `Extra = Using where`

Esto indicaba un recorrido completo de la tabla `pedidos`.

Se creó el índice:

```sql
CREATE INDEX idx_pedidos_fecha
ON pedidos(fecha);
```

Después de crearlo, `EXPLAIN` mostró:

* `type = range`
* `key = idx_pedidos_fecha`
* `rows = 3892`
* `Extra = Using where; Using index`

La cantidad estimada de filas examinadas se redujo de 100.224 a 3.892.

---

## Prueba 3 — Consulta con JOIN

La consulta contó los pedidos correspondientes a usuarios administradores:

```sql
SELECT COUNT(*) AS pedidos_de_administradores
FROM usuarios u
INNER JOIN pedidos pe
    ON pe.id_usuario = u.id_usuario
WHERE u.rol = 'ADMINISTRADOR';
```

El resultado fue de 1.000 pedidos.

Antes de crear el nuevo índice, `EXPLAIN` mostró que la tabla `usuarios` era recorrida completamente:

* `type = ALL`
* `key = NULL`
* `rows = 50064`
* `Extra = Using where`

La tabla `pedidos` ya utilizaba el índice generado por la clave foránea:

* `key = fk_pedidos_usuarios`
* `type = ref`
* `rows = 1`

Se creó el siguiente índice compuesto:

```sql
CREATE INDEX idx_usuarios_rol_id
ON usuarios(rol, id_usuario);
```

Después de crearlo, `EXPLAIN` mostró para la tabla `usuarios`:

* `type = ref`
* `key = idx_usuarios_rol_id`
* `rows = 500`
* `Extra = Using where; Using index`

La tabla `pedidos` continuó utilizando correctamente el índice `fk_pedidos_usuarios`.

La cantidad estimada de usuarios examinados se redujo de 50.064 a 500.

---

## Conclusión de rendimiento

Las pruebas realizadas muestran que la creación de índices adecuados mejora el acceso a los datos y modifica favorablemente los planes de ejecución seleccionados por MySQL.

En la consulta por igualdad, el índice sobre `usuarios.apellido` redujo la cantidad estimada de filas examinadas de 50.064 a una sola fila.

En la consulta por rango, el índice sobre `pedidos.fecha` permitió que MySQL utilizara una búsqueda de tipo `range`, evitando recorrer los 100.224 registros de la tabla y examinando únicamente las 3.892 filas comprendidas en el intervalo solicitado.

En la consulta con `JOIN`, el índice compuesto sobre `usuarios(rol, id_usuario)` permitió filtrar directamente los usuarios administradores. La estimación de filas examinadas en la tabla `usuarios` se redujo de 50.064 a 500. La tabla `pedidos` ya utilizaba el índice asociado a su clave foránea.

Las medianas registradas pasaron de aproximadamente 0,016 segundos sin los índices de prueba a valores inferiores a 0,001 segundos después de su creación.

Sin embargo, los índices no deben crearse indiscriminadamente. Si bien mejoran las operaciones de consulta, también ocupan espacio adicional y pueden aumentar el costo de las operaciones `INSERT`, `UPDATE` y `DELETE`, porque las estructuras de los índices deben mantenerse actualizadas.

Por lo tanto, la elección de un índice debe basarse en las columnas utilizadas frecuentemente en filtros, rangos, ordenamientos y relaciones entre tablas.

