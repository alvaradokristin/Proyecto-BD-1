-- Script para el proyecto #1 de Bases de Datos I

-- # --------------- ELIMINAR BASE DE DATOS SI EXISTE --------------- #
DROP DATABASE IF EXISTS sistemacrm;
GO

-- #----------------------------#
-- #   CREAR LA BASE DE DATOS   #
-- #----------------------------#

CREATE DATABASE sistemacrm;
GO

-- #-------------------------------#
-- #  SELECCIONA LA BASE DE DATOS  #
-- #-------------------------------#
USE sistemacrm;
GO

-- #--------------------------------#
-- #        CREAR CATALOGOS         #
-- #--------------------------------#

-- Se usa por cotizacion
CREATE TABLE Factura (
	numeroFactura smallint NOT NULL PRIMARY KEY,
	detalle varchar(30) NOT NULL
)

-- Se usa por cotizacion
CREATE TABLE Compra (
	ordenCompra smallint NOT NULL PRIMARY KEY,
	detalle varchar(30) NOT NULL
)

-- Se usa por cotizacion
CREATE TABLE Etapa (
	nombre varchar(12) NOT NULL PRIMARY KEY
)

-- Se usa por Cotizacion
CREATE TABLE Inflacion (
	anno date NOT NULL PRIMARY KEY,
	porcentaje decimal(3,2) NOT NULL
)

-- Se usa por Ejecucion
CREATE TABLE Departamento (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL
)

-- Se usa por Cotizacion, ContactoCliente, Actividad
CREATE TABLE Tipo (
	categoria varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL
)

-- Se usa por Cotizacion, ContactoCliente, Cliente
CREATE TABLE Zona (
	nombre varchar(12) NOT NULL PRIMARY KEY
)

-- Se usa por Cotizacion, ContactoCliente, Cliente
CREATE TABLE Sector (
	nombre varchar(12) NOT NULL PRIMARY KEY
)

--Se usa por Tarea, ContactoCliente, Actividad y Caso
CREATE TABLE Estado (
	categoria varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL
)

-- Se usa por Cliente
CREATE TABLE Moneda (
	disminutivo varchar(4) NOT NULL,
	nombre varchar(12) NOT NULL,
	PRIMARY KEY (disminutivo, nombre)
)

-- Se usa por Caso
CREATE TABLE Prioridad (
	tipo varchar(3) NOT NULL PRIMARY KEY -- P0, P1, ...
)

-- Se usa por Usuario
CREATE TABLE Rol (
	nombre varchar(12) NOT NULL PRIMARY KEY
)

-- #--------------------------------#
-- #        CREAR LAS TABLAS        #
-- #--------------------------------#

-- Se usa por Ejecucion
CREATE TABLE Proyecto (
	codigo varchar(10) NOT NULL PRIMARY KEY
)

-- Usa Proyecto y Departamento
CREATE TABLE Ejecucion (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	fecha date,
	codigo_proyecto varchar(10) NOT NULL,
	codigo_departamento varchar(10) NOT NULL,
	FOREIGN KEY (codigo_proyecto) REFERENCES Proyecto(codigo),
	FOREIGN KEY (codigo_departamento) REFERENCES Departamento(codigo)
)

-- Se usa por Cliente, Tarea, Cotizacion y Ejecucion
CREATE TABLE Usuario (
	userLogin varchar(10) NOT NULL PRIMARY KEY,
	cedula varchar(10) NOT NULL UNIQUE,
	nombre varchar(12) NOT NULL,
	primerApellido varchar(12) NOT NULL,
	segundoApellido varchar(12) NOT NULL,
	clave varchar(13) NOT NULL,
	nombre_rol varchar(12) NOT NULL,
	codigo_departamento varchar(10) NOT NULL,
	FOREIGN KEY (codigo_departamento) REFERENCES Departamento(codigo),
	FOREIGN KEY (nombre_rol) REFERENCES Rol(nombre)
)

-- Usa Usuario y Estado
-- Se usa ContactoCliente
CREATE TABLE Tarea (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	descripcion varchar(30) NOT NULL,
	fechaFinalizacion date NOT NULL,
	estado varchar(10) NOT NULL,
	usuario_asignado varchar(10) NOT NULL UNIQUE,
	FOREIGN KEY (estado) REFERENCES Estado(categoria),
	FOREIGN KEY (usuario_asignado) REFERENCES Usuario(cedula)
)

-- Se usa por Producto
CREATE TABLE FamiliaProducto (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	activo bit NOT NULL, -- 1 si esta activo 0 si no
	descripcion varchar(30) NOT NULL
)

-- Usa FamiliaProducto
CREATE TABLE Producto (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	activo bit NOT NULL,
	descripcion varchar(30) NOT NULL,
	precioEstandar decimal(9,2),
	codigo_familia varchar(10) NOT NULL,
	FOREIGN KEY (codigo_familia) REFERENCES FamiliaProducto(codigo)
)

-- Usa Moneda, Sector, Zona
-- Crea a los contactosCliente
-- Tiene que existir un cliente para poder crear algun contacto
CREATE TABLE Cliente (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombreCuenta varchar(12) NOT NULL,
	correo varchar(20) NOT NULL,
	telefono varchar(10) NOT NULL,
	celular varchar(10) NOT NULL,
	sitioWeb varchar(22) NOT NULL,
	informacionAdicional varchar(30) NOT NULL,
	zona varchar(12) NOT NULL,
	sector varchar(12) NOT NULL,
	disminutivo_moneda varchar(4) NOT NULL,
	nombre_moneda varchar(12) NOT NULL,
	CONSTRAINT FK_moneda FOREIGN KEY (disminutivo_moneda, nombre_moneda) REFERENCES Moneda(disminutivo, nombre),
	FOREIGN KEY (zona) REFERENCES Zona(nombre),
	FOREIGN KEY (sector) REFERENCES Sector(nombre)
)

-- Usa Cliente, Sector, Tarea, Estado, Zona, Tipo
-- Registra actividades
CREATE TABLE ContactoCliente (
	codigoCliente varchar(10) NOT NULL PRIMARY KEY,
	motivo varchar(15) NOT NULL,
	nombreContacto varchar(12) NOT NULL,
	correo varchar(20) NOT NULL,
	telefono varchar(10) NOT NULL,
	direccion varchar(35) NOT NULL,
	descripcion varchar(30) NOT NULL,
	FOREIGN KEY (codigoCliente) REFERENCES Cliente(codigo),
	sector varchar(12) NOT NULL,
	codigo_tarea varchar(10) NOT NULL,
	estado varchar(10) NOT NULL,
	zona varchar(12) NOT NULL,
	categoria_tipo varchar(10) NOT NULL,
	FOREIGN KEY (sector) REFERENCES Sector(nombre),
	FOREIGN KEY (codigo_tarea) REFERENCES Tarea(codigo),
	FOREIGN KEY (estado) REFERENCES Estado(categoria),
	FOREIGN KEY (zona) REFERENCES Zona(nombre),
	FOREIGN KEY (categoria_tipo) REFERENCES Tipo(categoria)
)

-- Usa Estado, tipo
-- Asocia casos
-- Es creado por contactoCliente
CREATE TABLE Actividad (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	descripcion varchar(30) NOT NULL,
	estado varchar(10) NOT NULL,
	categoria_tipo varchar(10) NOT NULL,
	codigoCliente_contactoCliente varchar(10) NOT NULL,
	FOREIGN KEY (estado) REFERENCES Estado(categoria),
	FOREIGN KEY (categoria_tipo) REFERENCES Tipo(categoria),
	FOREIGN KEY (codigoCliente_contactoCliente) REFERENCES ContactoCliente(codigoCliente)
)

-- Usa Tipo, Prioridad, Actividad, Estado
-- Cotizacion lo usa
CREATE TABLE Caso (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	origen varchar(12) NOT NULL,
	asunto varchar(10) NOT NULL,
	direccion varchar(35) NOT NULL,
	descripcion varchar(30) NOT NULL,
	categoria_tipo varchar(10) NOT NULL,
	tipo_prioridad varchar(3) NOT NULL,
	codigo_actividad varchar(10) NOT NULL,
	estado varchar(10) NOT NULL,
	FOREIGN KEY (categoria_tipo) REFERENCES Tipo(categoria),
	FOREIGN KEY (tipo_prioridad) REFERENCES Prioridad(tipo),
	FOREIGN KEY (codigo_actividad) REFERENCES Actividad(codigo),
	FOREIGN KEY (estado) REFERENCES Estado(categoria)
)

-- Usa Compra, Factura, Etapa, Tipo, Ejecucion, Zona, Sector, Inflacion, Producto, Caso
CREATE TABLE Cotizacion (
	numeroCotizacion smallint NOT NULL PRIMARY KEY,
	nombreOportunidad varchar(12) NOT NULL,
	fecha date NOT NULL,
	mesAnnoCierre varchar(5) NOT NULL,
	fechaCierre date NOT NULL,
	probabilidad decimal(3,2) NOT NULL,
	descripcion varchar(30) NOT NULL,
	seNego varchar(15) NOT NULL,
	contraQuien varchar(15) NOT NULL,
	ordenCompra smallint NOT NULL,
	numeroFactura smallint NOT NULL,
	nombre_etapa varchar(12) NOT NULL,
	categoria_tipo varchar(10) NOT NULL,
	codigo_ejecucion varchar(10) NOT NULL,
	zona varchar(12) NOT NULL,
	sector varchar(12) NOT NULL,
	anno_inflacion date NOT NULL,
	codigo_producto varchar(10) NOT NULL,
	codigo_caso varchar(10) NOT NULL,
	FOREIGN KEY (ordenCompra) REFERENCES Compra(ordenCompra),
	FOREIGN KEY (numeroFactura) REFERENCES Factura(numeroFactura),
	FOREIGN KEY (nombre_etapa) REFERENCES Etapa(nombre),
	FOREIGN KEY (categoria_tipo) REFERENCES Tipo(categoria),
	FOREIGN KEY (codigo_ejecucion) REFERENCES Ejecucion(codigo),
	FOREIGN KEY (zona) REFERENCES Zona(nombre),
	FOREIGN KEY (sector) REFERENCES Sector(nombre),
	FOREIGN KEY (anno_inflacion) REFERENCES Inflacion(anno),
	FOREIGN KEY (codigo_producto) REFERENCES Producto(codigo),
	FOREIGN KEY (codigo_caso) REFERENCES Caso(codigo)
)


-- #----------------------------#
-- #       CREAR USUARIOS       #
-- #----------------------------#
-- Ejemplo de como crear un usuario
CREATE LOGIN NewAdminName WITH PASSWORD = 'ABCD'
GO

-- Asignar permisos de administrador
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'NewAdminName')
BEGIN
    CREATE USER [NewAdminName] FOR LOGIN [NewAdminName]
    EXEC sp_addrolemember N'db_owner', N'NewAdminName'
END;
GO

-- Asignar permisos
GRANT SELECT ON OBJECT::Region TO Ted; -- Ted es el usuario, Region es la tabla?