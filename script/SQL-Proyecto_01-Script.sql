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
	anno varchar(4) NOT NULL PRIMARY KEY,
	porcentaje decimal(3,2) NOT NULL
)

-- Se usa por Ejecucion
CREATE TABLE Departamento (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL
)

-- Se usa por Cotizacion, ContactoCliente, Actividad
CREATE TABLE Tipo (
	categoria varchar(10) NOT NULL,
	nombre varchar(12) NOT NULL,
	PRIMARY KEY (categoria, nombre)
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
	categoria varchar(10) NOT NULL,
	nombre varchar(12) NOT NULL,
	PRIMARY KEY (categoria, nombre)
)

-- Se usa por Cliente
CREATE TABLE Moneda (
	abreviatura varchar(4) NOT NULL,
	nombre varchar(12) NOT NULL,
	PRIMARY KEY (abreviatura, nombre)
)

-- Se usa por Caso
CREATE TABLE Prioridad (
	tipo varchar(3) NOT NULL PRIMARY KEY -- P0, P1, ...
)

-- Se usa por Usuario y funciones
CREATE TABLE Rol (
	nombre varchar(12) NOT NULL PRIMARY KEY
)

-- Se usa para el manejo de usuarios
CREATE TABLE FuncionesXRol (
	nombre varchar(12) NOT NULL,
	nombreRol varchar(12) NOT NULL,
	PRIMARY KEY (nombre, nombreRol),
	FOREIGN KEY (nombreRol) REFERENCES Rol(nombre)
)

-- Se usa por Cotizacion
-- Catalogo para contra quien se pierde
CREATE TABLE Competencia (
	nombre varchar(15) NOT NULL PRIMARY KEY
)

-- Se usa por Caso
CREATE TABLE Origen (
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
-- La encriptacion de la clave se va a manejar en el backend ya que consideramos que es mas 
-- seguro y sencillo de aplicar y validar a la hora de realizar los logins
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

-- Se usa apara el manejo de usuarios
-- Ya que el usuario tiene mas de un rol
CREATE TABLE RolXUsuario (
	nombreRol varchar(12) NOT NULL,
	userLogin varchar(10) NOT NULL,
	PRIMARY KEY (nombreRol, userLogin),
	FOREIGN KEY (nombreRol) REFERENCES Rol(nombre),
	FOREIGN KEY (userLogin) REFERENCES Usuario(userLogin)
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
	abreviatura_moneda varchar(4) NOT NULL,
	nombre_moneda varchar(12) NOT NULL,
	login_usuario varchar(10) NOT NULL,
	FOREIGN KEY (login_usuario) REFERENCES Usuario(userLogin),
	CONSTRAINT FK_moneda FOREIGN KEY (abreviatura_moneda, nombre_moneda) REFERENCES Moneda(abreviatura, nombre),
	FOREIGN KEY (zona) REFERENCES Zona(nombre),
	FOREIGN KEY (sector) REFERENCES Sector(nombre)
)

SELECT * FROM Cliente

-- Usa Cliente, Sector, Tarea, Estado, Zona, Tipo
-- Registra actividades
CREATE TABLE ContactoCliente (
	codigoCliente varchar(10) NOT NULL,
	motivo varchar(15) NOT NULL,
	nombreContacto varchar(12) NOT NULL,
	correo varchar(20) NOT NULL,
	telefono varchar(10) NOT NULL,
	direccion varchar(35) NOT NULL,
	descripcion varchar(30) NOT NULL,
	sector varchar(12) NOT NULL,
	categoria_estado varchar(10) NOT NULL,
	nombre_estado varchar(12) NOT NULL,
	zona varchar(12) NOT NULL,
	categoria_tipo varchar(10) NOT NULL,
	nombre_tipo varchar(12) NOT NULL,
	PRIMARY KEY (codigoCliente, motivo),
	FOREIGN KEY (codigoCliente) REFERENCES Cliente(codigo),
	FOREIGN KEY (sector) REFERENCES Sector(nombre),
	FOREIGN KEY (categoria_estado, nombre_estado) REFERENCES Estado(categoria, nombre),
	FOREIGN KEY (zona) REFERENCES Zona(nombre),
	FOREIGN KEY (categoria_tipo, nombre_tipo) REFERENCES Tipo(categoria, nombre),
)

-- Usa Usuario y Estado
CREATE TABLE Tarea (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	descripcion varchar(30) NOT NULL,
	fechaInicio date NOT NULL,
	fechaFinalizacion date NOT NULL,
	categoria_estado varchar(10) NOT NULL,
	nombre_estado varchar(12) NOT NULL,
	usuario_asignado varchar(10) NOT NULL,
	FOREIGN KEY (categoria_estado, nombre_estado) REFERENCES Estado(categoria, nombre),
	FOREIGN KEY (usuario_asignado) REFERENCES Usuario(cedula)
)

-- Usa Estado, Tipo y Usuario
CREATE TABLE Actividad (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	descripcion varchar(30) NOT NULL,
	categoria_estado varchar(10) NOT NULL,
	nombre_estado varchar(12) NOT NULL,
	categoria_tipo varchar(10) NOT NULL,
	nombre_tipo varchar(12) NOT NULL,
	usuario_asignado varchar(10) NOT NULL,
	FOREIGN KEY (categoria_estado, nombre_estado) REFERENCES Estado(categoria, nombre),
	FOREIGN KEY (categoria_tipo, nombre_tipo) REFERENCES Tipo(categoria, nombre),
	FOREIGN KEY (usuario_asignado) REFERENCES Usuario(cedula)
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
	nombre_competencia varchar(15) NOT NULL, -- contraQuien
	ordenCompra smallint NOT NULL,
	numero_factura smallint NOT NULL,
	nombre_etapa varchar(12) NOT NULL,
	categoria_tipo varchar(10) NOT NULL,
	nombre_tipo varchar(12) NOT NULL,
	codigo_ejecucion varchar(10) NOT NULL,
	zona varchar(12) NOT NULL,
	sector varchar(12) NOT NULL,
	anno_inflacion varchar(4) NOT NULL,
	codigo_caso varchar(10) NOT NULL,
	login_usuario varchar(10) NOT NULL,
	FOREIGN KEY (login_usuario) REFERENCES Usuario(userLogin),
	FOREIGN KEY (ordenCompra) REFERENCES Compra(ordenCompra),
	FOREIGN KEY (numero_factura) REFERENCES Factura(numeroFactura),
	FOREIGN KEY (nombre_etapa) REFERENCES Etapa(nombre),
	FOREIGN KEY (categoria_tipo, nombre_tipo) REFERENCES Tipo(categoria, nombre),
	FOREIGN KEY (codigo_ejecucion) REFERENCES Ejecucion(codigo),
	FOREIGN KEY (zona) REFERENCES Zona(nombre),
	FOREIGN KEY (sector) REFERENCES Sector(nombre),
	FOREIGN KEY (anno_inflacion) REFERENCES Inflacion(anno),
	FOREIGN KEY (nombre_competencia) REFERENCES Competencia(nombre)
)

-- Usa Tipo, Prioridad, Actividad, Estado, Cotizacion
CREATE TABLE Caso (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	origen varchar(12) NOT NULL,
	asunto varchar(10) NOT NULL,
	direccion varchar(35) NOT NULL,
	descripcion varchar(30) NOT NULL,
	categoria_tipo varchar(10) NOT NULL,
	nombre_tipo varchar(12) NOT NULL,
	tipo_prioridad varchar(3) NOT NULL,
	categoria_estado varchar(10) NOT NULL,
	nombre_estado varchar(12) NOT NULL,
	nombre_origen varchar(12) NOT NULL,
	FOREIGN KEY (categoria_tipo, nombre_tipo) REFERENCES Tipo(categoria, nombre),
	FOREIGN KEY (tipo_prioridad) REFERENCES Prioridad(tipo),
	FOREIGN KEY (categoria_estado, nombre_estado) REFERENCES Estado(categoria, nombre),
	FOREIGN KEY (nombre_origen) REFERENCES Origen(nombre)
)

-- Usa Producto y Cotizacion
-- Cada cotizacion puede usar mas de un producto
CREATE TABLE ProductoXCotizacion (
	codigo_producto varchar(10) NOT NULL,
	numero_cotizacion smallint NOT NULL,
	PRIMARY KEY (codigo_producto, numero_cotizacion),
	FOREIGN KEY (codigo_producto) REFERENCES Producto(codigo),
	FOREIGN KEY (numero_cotizacion) REFERENCES Cotizacion(numeroCotizacion)
)

-- Usa Actividad y ContactoCliente
CREATE TABLE ActividadXContactoCliente (
	cliente_contacto varchar(10) NOT NULL,
	motivo_contacto varchar(15) NOT NULL,
	codigo_actividad varchar(10) NOT NULL,
	PRIMARY KEY (cliente_contacto, motivo_contacto, codigo_actividad),
	FOREIGN KEY (codigo_actividad) REFERENCES Actividad(codigo),
	FOREIGN KEY (cliente_contacto, motivo_contacto) REFERENCES ContactoCliente(codigoCliente, motivo)
)

-- Usa Tarea y ContactoCliente
CREATE TABLE TareaXContactoCliente (
	cliente_contacto varchar(10) NOT NULL,
	motivo_contacto varchar(15) NOT NULL,
	codigo_tarea varchar(10) NOT NULL,
	PRIMARY KEY (cliente_contacto, motivo_contacto, codigo_tarea),
	FOREIGN KEY (codigo_tarea) REFERENCES Tarea(codigo),
	FOREIGN KEY (cliente_contacto, motivo_contacto) REFERENCES ContactoCliente(codigoCliente, motivo)
)

-- Usa Actividad y Cotizacion
CREATE TABLE ActividadXCotizacion (
	numero_cotizacion smallint NOT NULL,
	codigo_actividad varchar(10) NOT NULL,
	PRIMARY KEY (numero_cotizacion, codigo_actividad),
	FOREIGN KEY (numero_cotizacion) REFERENCES Cotizacion(numeroCotizacion),
	FOREIGN KEY (codigo_actividad) REFERENCES Actividad(codigo)
)

-- Usa Tarea y Cotizacion
CREATE TABLE TareaXCotizacion (
	numero_cotizacion smallint NOT NULL,
	codigo_tarea varchar(10) NOT NULL,
	PRIMARY KEY (numero_cotizacion, codigo_tarea),
	FOREIGN KEY (numero_cotizacion) REFERENCES Cotizacion(numeroCotizacion),
	FOREIGN KEY (codigo_tarea) REFERENCES Tarea(codigo)
)

-- Usa Actividad y Ejecucion
CREATE TABLE ActividadXEjecucion (
	codigo_ejecucion varchar(10) NOT NULL,
	codigo_actividad varchar(10) NOT NULL,
	PRIMARY KEY (codigo_ejecucion, codigo_actividad),
	FOREIGN KEY (codigo_ejecucion) REFERENCES Ejecucion(codigo),
	FOREIGN KEY (codigo_actividad) REFERENCES Actividad(codigo)
)

-- Usa Tarea y Ejecucion
CREATE TABLE TareaXEjecucion (
	codigo_ejecucion varchar(10) NOT NULL,
	codigo_tarea varchar(10) NOT NULL,
	PRIMARY KEY (codigo_ejecucion, codigo_tarea),
	FOREIGN KEY (codigo_ejecucion) REFERENCES Ejecucion(codigo),
	FOREIGN KEY (codigo_tarea) REFERENCES Tarea(codigo)
)

-- Usa Actividad y Caso
CREATE TABLE ActividadXCaso (
	codigo_caso varchar(10) NOT NULL,
	codigo_actividad varchar(10) NOT NULL,
	PRIMARY KEY (codigo_caso, codigo_actividad),
	FOREIGN KEY (codigo_caso) REFERENCES Caso(codigo),
	FOREIGN KEY (codigo_actividad) REFERENCES Actividad(codigo)
)

-- Usa Tarea y Caso
CREATE TABLE TareaXCaso (
	codigo_caso varchar(10) NOT NULL,
	codigo_tarea varchar(10) NOT NULL,
	PRIMARY KEY (codigo_caso, codigo_tarea),
	FOREIGN KEY (codigo_caso) REFERENCES Caso(codigo),
	FOREIGN KEY (codigo_tarea) REFERENCES Tarea(codigo)
)

-- #----------------------------#
-- #       CREAR USUARIOS       #
-- #----------------------------#
---- Ejemplo de como crear un usuario
--CREATE LOGIN kalva WITH PASSWORD = 'MyPass0102'
--GO

---- Asignar permisos de administrador
--IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'Kristin')
--BEGIN
--    CREATE USER Kristin FOR LOGIN kalva
--    EXEC sp_addrolemember N'db_owner', N'Kristin'
--END;
--GO

-- Asignar permisos
--GRANT SELECT ON OBJECT::Cotizacion TO Kristin;

-- #----------------------------#
-- #          INSERTS           #
-- #----------------------------#

INSERT INTO Departamento (codigo,nombre)
VALUES	('DP01', 'Desarrollo'),
		('DP02', 'Backend'),
		('DP03', 'Frontend'),
		('DP04', 'Debugging'),
		('DP05', 'QA');

INSERT INTO Rol (nombre)
VALUES	('Editor'),
		('Visor'),
		('Reportero');

INSERT INTO Usuario (userLogin, cedula, nombre, primerApellido, segundoApellido, clave, nombre_rol, codigo_departamento)
VALUES	('amr', '123456789', 'Aivy', 'Masis', 'Rivera', 'amr123','Editor', 'DP01');

INSERT INTO Usuario (userLogin, cedula, nombre, primerApellido, segundoApellido, clave, nombre_rol, codigo_departamento)
VALUES	('jsm', '789456123', 'test', 'test1', 'test2', 'jsm123','Visor', 'DP03');

INSERT INTO Moneda (abreviatura, nombre)
VALUES	('USD', 'dolar'),
		('CRC', 'colon');

INSERT INTO Zona (nombre)
VALUES	('Cartago'),
		('San Jose'),
		('Heredia');

INSERT INTO Sector (nombre)
VALUES	('Tres Rios'),
		('San Jose'),
		('Barva');

INSERT INTO Cliente (codigo, nombreCuenta, correo, telefono, celular, sitioWeb, informacionAdicional, zona, sector, abreviatura_moneda, nombre_moneda, login_usuario)
VALUES	('C01', 'CuentaAMR', 'asd@asd.com', '123456', '456789', 'www.asd.cr', 'NO', 'Cartago', 'Tres Rios', 'CRC', 'colon', 'amr');

INSERT INTO Cliente (codigo, nombreCuenta, correo, telefono, celular, sitioWeb, informacionAdicional, zona, sector, abreviatura_moneda, nombre_moneda, login_usuario)
VALUES	('C02', 'CuentaJSM', 'zxc@zxc.com', '456123', '789456', 'www.zxc.org', 'NO', 'Heredia', 'San Jose', 'USD', 'dolar', 'jsm');