TFI Bases de Datos I - Food Store
Scripts finales de entrega

Motor utilizado:
MySQL

Orden de ejecucion:
1. 01_esquema.sql
2. 02_catalogos.sql
3. 03_carga_masiva.sql
4. 06_vistas.sql
5. 04_indices.sql
6. 05_consultas.sql
7. 05_explain.sql
8. 07_seguridad.sql
9. 08_transacciones.sql
10. 09_concurrencia_guiada.sql

Notas:
- 01_esquema.sql recrea la base food_store desde cero.
- 02_catalogos.sql carga categorias base.
- 03_carga_masiva.sql carga productos, usuarios, pedidos y detalle_pedidos.
- 06_vistas.sql debe ejecutarse antes de 07_seguridad.sql porque los permisos se otorgan sobre vistas.
- 04_indices.sql crea indices de forma idempotente usando una rutina auxiliar temporal.
- 05_explain.sql muestra planes de ejecucion y consultas usadas para mediciones.
- 07_seguridad.sql crea usuario de lectura, permisos, procedimiento seguro y pruebas anti-inyeccion.
- 08_transacciones.sql muestra COMMIT, ROLLBACK y un procedimiento con retry ante deadlock.
- 09_concurrencia_guiada.sql contiene instrucciones para ejecutar pruebas en dos sesiones.

Repositorio:
https://github.com/MatiasYacob/TPI-Base-de-Datos-Food-Store

Video:
https://www.youtube.com/watch?v=eZ3U9Z-Lu90

