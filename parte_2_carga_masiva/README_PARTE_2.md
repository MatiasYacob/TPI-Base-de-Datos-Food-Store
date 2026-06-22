
# Parte 2 - Generación y Carga Masiva de Datos

## Trabajo Final Integrador - Bases de Datos I

## Proyecto: Food Store

Esta carpeta contiene los archivos correspondientes a la **Etapa 2: Generación y carga de datos masivos con SQL puro**.

El objetivo de esta parte fue generar un volumen importante de datos ficticios para la base `food_store`, respetando la integridad referencial, las cardinalidades del modelo y las restricciones definidas en la Etapa 1.

## Archivos incluidos

* `02_carga_masiva.sql`: script principal de carga masiva.
* `03_verificaciones_carga_masiva.sql`: consultas de conteo y verificación de consistencia.

## Estrategia utilizada

La carga se realizó siguiendo el orden lógico del DER:

1. `categorias`
2. `productos`
3. `usuarios`
4. `pedidos`
5. `detalle_pedidos`

Este orden permite respetar las claves foráneas, ya que primero se cargan las tablas principales y luego las tablas dependientes.

Para generar los datos masivos se creó una tabla auxiliar llamada `numeros`, con valores del 1 al 100.000. A partir de esa tabla se generaron automáticamente usuarios, productos, pedidos y detalles de pedidos mediante SQL puro, utilizando instrucciones como `INSERT INTO ... SELECT`, `CROSS JOIN`, `MOD`, `CASE`, `CONCAT` y `DATE_ADD`.

## Volumen de datos cargado

La carga final generó los siguientes registros en las tablas principales:

| Tabla           | Cantidad de registros |
| --------------- | --------------------: |
| categorias      |                    10 |
| productos       |                 1.000 |
| usuarios        |                50.000 |
| pedidos         |               100.000 |
| detalle_pedidos |               100.000 |

Total de registros cargados en tablas principales: **251.010 registros**.

## Verificaciones realizadas

Se ejecutaron consultas de consistencia para validar que la carga masiva no generara datos huérfanos ni inconsistencias.

Las verificaciones realizadas fueron:

* Productos sin categoría.
* Pedidos sin usuario.
* Detalles sin pedido.
* Detalles sin producto.
* Pedidos con total incorrecto.

Todas las verificaciones devolvieron resultado **0**, lo que indica que la carga fue consistente y respetó la integridad referencial del modelo.

## Observación

Antes de realizar la carga final, se ejecutó una carga reducida de prueba para validar que el script funcionara correctamente. Luego de confirmar los resultados, se limpió la base y se ejecutó la carga masiva final.

