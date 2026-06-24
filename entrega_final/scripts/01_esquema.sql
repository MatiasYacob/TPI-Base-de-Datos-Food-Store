DROP DATABASE IF EXISTS food_store;
CREATE DATABASE food_store;
USE food_store;

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_categorias PRIMARY KEY (id_categoria),
    CONSTRAINT uk_categorias_nombre UNIQUE (nombre),
    CONSTRAINT chk_categorias_nombre CHECK (TRIM(nombre) <> ''),
    CONSTRAINT chk_categorias_descripcion CHECK (TRIM(descripcion) <> '')
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    email VARCHAR(120) NOT NULL,
    rol ENUM('CLIENTE', 'ADMINISTRADOR') NOT NULL DEFAULT 'CLIENTE',
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_usuarios PRIMARY KEY (id_usuario),
    CONSTRAINT uk_usuarios_email UNIQUE (email),
    CONSTRAINT chk_usuarios_nombre CHECK (TRIM(nombre) <> ''),
    CONSTRAINT chk_usuarios_apellido CHECK (TRIM(apellido) <> ''),
    CONSTRAINT chk_usuarios_email CHECK (TRIM(email) <> '')
);

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    id_categoria INT NOT NULL,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_productos PRIMARY KEY (id_producto),
    CONSTRAINT uk_productos_nombre UNIQUE (nombre),
    CONSTRAINT fk_productos_categorias
        FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    CONSTRAINT chk_productos_nombre CHECK (TRIM(nombre) <> ''),
    CONSTRAINT chk_productos_descripcion CHECK (TRIM(descripcion) <> ''),
    CONSTRAINT chk_productos_precio CHECK (precio >= 0),
    CONSTRAINT chk_productos_stock CHECK (stock >= 0)
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('PENDIENTE', 'CONFIRMADO', 'ENTREGADO', 'CANCELADO') NOT NULL DEFAULT 'PENDIENTE',
    forma_pago ENUM('EFECTIVO', 'TARJETA', 'TRANSFERENCIA') NOT NULL,
    total DECIMAL(10,2) NOT NULL DEFAULT 0,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_pedidos PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedidos_usuarios
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT chk_pedidos_total CHECK (total >= 0)
);

CREATE TABLE detalle_pedidos (
    id_detalle INT AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_detalle_pedidos PRIMARY KEY (id_detalle),
    CONSTRAINT fk_detalle_pedidos_pedidos
        FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_detalle_pedidos_productos
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT chk_detalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_detalle_precio_unitario CHECK (precio_unitario >= 0),
    CONSTRAINT chk_detalle_subtotal CHECK (subtotal >= 0)
);

