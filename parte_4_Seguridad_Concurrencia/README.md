# Parte 4 - Seguridad, Integridad, Concurrencia y Transacciones


## Descripción

En esta etapa del proyecto se implementaron los conceptos de seguridad, integridad, concurrencia y transacciones utilizando MySQL. El objetivo fue garantizar la protección de los datos, validar restricciones de integridad, controlar el acceso mediante permisos específicos y analizar el comportamiento de múltiples transacciones ejecutándose de forma concurrente.

## Seguridad

Se creó un usuario de base de datos denominado `food_reader` con privilegios mínimos, aplicando el principio de menor privilegio. Este usuario únicamente posee permisos de lectura sobre determinadas vistas, sin acceso directo a las tablas principales del sistema. Para ello se utilizaron sentencias `CREATE USER` y `GRANT`, verificando posteriormente que el usuario no pudiera realizar operaciones no autorizadas como modificaciones o eliminaciones de registros.

## Vistas para ocultar información sensible

Se crearon dos vistas destinadas a exponer únicamente la información necesaria para determinados usuarios. La vista `vista_productos_publicos` permite consultar los productos disponibles junto con su categoría, mientras que la vista `vista_usuarios_publicos` expone únicamente datos básicos de los usuarios, ocultando información sensible y reduciendo la exposición directa de las tablas originales.

## Pruebas de integridad

Se realizaron pruebas para verificar el correcto funcionamiento de las restricciones definidas en el modelo de datos. En primer lugar se comprobó la restricción `UNIQUE` intentando insertar un usuario con un correo electrónico ya existente, obteniendo el error correspondiente. Posteriormente se verificó la integridad referencial mediante una restricción `FOREIGN KEY`, intentando registrar un producto asociado a una categoría inexistente, lo que generó un error y evitó la inserción. Estas pruebas demostraron que la base de datos protege la consistencia de la información almacenada.

## Prevención de inyección SQL

Se desarrolló un ejemplo en Java utilizando `PreparedStatement` para realizar consultas parametrizadas de forma segura. Se probó una entrada maliciosa del tipo `' OR '1'='1`, comúnmente utilizada en ataques de inyección SQL. Gracias al uso de parámetros, el valor fue tratado como texto literal y no como parte de la consulta SQL, evitando cualquier acceso indebido a los datos. Esta prueba permitió demostrar una técnica efectiva para prevenir vulnerabilidades de seguridad en aplicaciones conectadas a la base de datos.

## Transacciones

Se realizaron pruebas utilizando transacciones explícitas para analizar el comportamiento de las operaciones `COMMIT` y `ROLLBACK`. En la prueba de `COMMIT`, los cambios realizados dentro de la transacción fueron confirmados y persistieron en la base de datos. En la prueba de `ROLLBACK`, los cambios fueron revertidos completamente, recuperando el estado previo de los datos. Estas pruebas permitieron comprobar el principio de atomicidad y la capacidad de recuperar la consistencia ante errores o cancelaciones.

## Concurrencia y Deadlocks

Se trabajó con dos sesiones independientes de MySQL para simular operaciones concurrentes sobre los mismos registros. Mediante actualizaciones cruzadas sobre distintos productos se generó una situación de espera circular, produciendo un deadlock. MySQL detectó automáticamente el conflicto y canceló una de las transacciones involucradas, demostrando los mecanismos internos de resolución de bloqueos y control de concurrencia del motor de base de datos.

## Comparación de niveles de aislamiento

Se compararon los niveles de aislamiento `READ COMMITTED` y `REPEATABLE READ`. En `READ COMMITTED` fue posible observar cambios confirmados por otras transacciones entre diferentes lecturas realizadas por una misma sesión. En cambio, bajo `REPEATABLE READ`, las lecturas realizadas dentro de una misma transacción mantuvieron una visión consistente de los datos, incluso cuando otra sesión realizó modificaciones y confirmó los cambios. Esta comparación permitió comprender las diferencias de comportamiento entre ambos niveles de aislamiento y su impacto en la concurrencia.

## Uso de Inteligencia Artificial

Durante el desarrollo de esta etapa se utilizó inteligencia artificial como herramienta de apoyo para la comprensión de conceptos relacionados con seguridad, integridad, transacciones, concurrencia, deadlocks y niveles de aislamiento. La IA fue empleada para resolver dudas conceptuales, interpretar errores obtenidos durante las pruebas y asistir en la elaboración de ejemplos prácticos, manteniendo siempre la validación y ejecución de las soluciones dentro del entorno de trabajo.

## Conclusión

En esta etapa se aplicaron conceptos de seguridad, integridad, transacciones y concurrencia sobre la base de datos del sistema Food Store. Las pruebas realizadas permitieron verificar el correcto funcionamiento de los permisos, las restricciones de integridad, las transacciones con COMMIT y ROLLBACK, y el manejo de situaciones de concurrencia como los deadlocks. De esta manera, se comprobó que la base de datos mantiene la consistencia y seguridad de la información ante distintos escenarios de uso.
