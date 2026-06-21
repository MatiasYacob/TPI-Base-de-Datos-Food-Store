# TPI Base de Datos - Food Store

Repositorio del Trabajo Final Integrador de Bases de Datos I basado en el sistema Food Store.

El objetivo del trabajo es llevar el dominio del sistema a una base de datos relacional, aplicando modelado, restricciones, carga de datos, consultas, reportes, seguridad e integridad.

## Estructura

- `parte_1_modelado`: creacion de base de datos, tablas, relaciones, constraints, DER y evidencias.
- `parte_2_carga_masiva`: scripts de carga masiva de datos.
- `parte_3_consultas_reportes`: consultas avanzadas, reportes e indices.
- `parte_4_seguridad_transacciones`: seguridad, integridad, transacciones y concurrencia.
- `documentacion`: documentos finales del trabajo.

## Base de datos

Nombre de la base:

```sql
food_store
```

Tablas principales:

- `categorias`
- `usuarios`
- `productos`
- `pedidos`
- `detalle_pedidos`

## Uso

Para crear la base inicial, ejecutar en MySQL Workbench:

```sql
parte_1_modelado/01_creacion_base_y_tablas.sql
```

Luego ejecutar:

```sql
parte_1_modelado/02_pruebas_constraints.sql
```

Para verificar la estructura y los datos:

```sql
parte_1_modelado/03_verificacion_final.sql
```

