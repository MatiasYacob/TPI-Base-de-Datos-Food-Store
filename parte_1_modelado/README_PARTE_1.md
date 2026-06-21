# Parte 1 - Modelado y constraints

## Objetivo

Esta parte se encarga de crear la estructura inicial de la base de datos del sistema Food Store.

El objetivo principal es transformar el modelo del proyecto de Programacion 2 en tablas relacionales, definiendo claves primarias, claves foraneas y restricciones de integridad.

## Tablas creadas

### categorias

Representa las categorias de productos del sistema.

Campos principales:

- `id_categoria`: identificador unico.
- `nombre`: nombre de la categoria.
- `descripcion`: detalle de la categoria.
- `eliminado`: permite aplicar baja logica.

Restricciones:

- El nombre no puede estar vacio.
- La descripcion no puede estar vacia.
- El nombre de la categoria no se puede repetir.

### usuarios

Representa los usuarios que pueden realizar pedidos.

Campos principales:

- `id_usuario`: identificador unico.
- `nombre`: nombre del usuario.
- `apellido`: apellido del usuario.
- `email`: correo electronico.
- `rol`: tipo de usuario.
- `eliminado`: permite aplicar baja logica.

Restricciones:

- El nombre no puede estar vacio.
- El apellido no puede estar vacio.
- El email no puede estar vacio.
- El email no se puede repetir.

### productos

Representa los productos disponibles en Food Store.

Campos principales:

- `id_producto`: identificador unico.
- `nombre`: nombre del producto.
- `descripcion`: detalle del producto.
- `precio`: precio del producto.
- `stock`: cantidad disponible.
- `id_categoria`: categoria asociada.
- `eliminado`: permite aplicar baja logica.

Restricciones:

- El producto debe pertenecer a una categoria existente.
- El nombre no puede estar vacio.
- La descripcion no puede estar vacia.
- El precio debe ser mayor o igual a cero.
- El stock debe ser mayor o igual a cero.
- El nombre del producto no se puede repetir.

### pedidos

Representa los pedidos realizados por usuarios.

Campos principales:

- `id_pedido`: identificador unico.
- `id_usuario`: usuario que realizo el pedido.
- `fecha`: fecha y hora del pedido.
- `estado`: estado actual del pedido.
- `forma_pago`: forma de pago seleccionada.
- `total`: importe total del pedido.
- `eliminado`: permite aplicar baja logica.

Restricciones:

- El pedido debe pertenecer a un usuario existente.
- El total debe ser mayor o igual a cero.

### detalle_pedidos

Representa los productos incluidos dentro de un pedido.

Campos principales:

- `id_detalle`: identificador unico.
- `id_pedido`: pedido asociado.
- `id_producto`: producto asociado.
- `cantidad`: cantidad comprada.
- `precio_unitario`: precio del producto al momento del pedido.
- `subtotal`: resultado de cantidad por precio unitario.
- `eliminado`: permite aplicar baja logica.

Restricciones:

- El detalle debe pertenecer a un pedido existente.
- El detalle debe tener un producto existente.
- La cantidad debe ser mayor a cero.
- El precio unitario debe ser mayor o igual a cero.
- El subtotal debe ser mayor o igual a cero.

## Relaciones

- Una categoria puede tener muchos productos.
- Un producto pertenece a una categoria.
- Un usuario puede tener muchos pedidos.
- Un pedido pertenece a un usuario.
- Un pedido puede tener muchos detalles.
- Un detalle pertenece a un pedido.
- Un detalle referencia a un producto.

## Archivos de esta parte

- `01_creacion_base_y_tablas.sql`: crea la base de datos, tablas, claves y restricciones.
- `02_pruebas_constraints.sql`: carga datos validos y deja ejemplos de pruebas con errores esperados.
- `03_verificacion_final.sql`: consulta las tablas y muestra datos para verificar que la estructura funciona.

## Capturas recomendadas

Para documentar esta parte conviene sacar capturas de:

1. La base `food_store` creada en MySQL Workbench.
2. Las cinco tablas creadas.
3. El resultado de `SHOW TABLES`.
4. El resultado de los `SELECT` con datos cargados.
5. Una prueba de restriccion fallida, por ejemplo precio negativo o email repetido.

## Conclusion

La parte 1 deja creada la base estructural del sistema Food Store. A partir de esta estructura, los demas integrantes pueden cargar datos masivos, realizar consultas avanzadas, crear reportes, trabajar con indices y probar seguridad, integridad y transacciones.

