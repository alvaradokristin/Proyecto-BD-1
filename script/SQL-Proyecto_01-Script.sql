-- Script para el proyecto #3 de Bases de Datos I

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
	detalle varchar(60) NOT NULL
)

-- Se usa por cotizacion
CREATE TABLE Compra (
	ordenCompra smallint NOT NULL PRIMARY KEY,
	detalle varchar(60) NOT NULL
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

-- Usa Proyecto y Departamento
CREATE TABLE Ejecucion (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	fecha date,
	fechaCierre date,
	codigo_proyecto varchar(10) NOT NULL,
	codigo_departamento varchar(10) NOT NULL,
	userLogin varchar(10) NOT NULL,
	FOREIGN KEY (codigo_proyecto) REFERENCES Proyecto(codigo),
	FOREIGN KEY (codigo_departamento) REFERENCES Departamento(codigo),
	FOREIGN KEY (userLogin) REFERENCES Usuario(userLogin)
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

-- Usa Cliente, Sector, Tarea, Estado, Zona, Tipo
-- Registra actividades
CREATE TABLE ContactoCliente (
	codigoCliente varchar(10) NOT NULL,
	motivo varchar(15) NOT NULL,
	fecha date NOT NULL,
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
	asesor varchar(10) NOT NULL,
	PRIMARY KEY (codigoCliente, motivo),
	FOREIGN KEY (codigoCliente) REFERENCES Cliente(codigo),
	FOREIGN KEY (sector) REFERENCES Sector(nombre),
	FOREIGN KEY (categoria_estado, nombre_estado) REFERENCES Estado(categoria, nombre),
	FOREIGN KEY (zona) REFERENCES Zona(nombre),
	FOREIGN KEY (categoria_tipo, nombre_tipo) REFERENCES Tipo(categoria, nombre),
	FOREIGN KEY (asesor) REFERENCES Usuario(userLogin)
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
	FOREIGN KEY (usuario_asignado) REFERENCES Usuario(userLogin)
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
	FOREIGN KEY (usuario_asignado) REFERENCES Usuario(userLogin)
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
	FOREIGN KEY (categoria_tipo, nombre_tipo) REFERENCES Tipo(categoria, nombre),
	FOREIGN KEY (tipo_prioridad) REFERENCES Prioridad(tipo),
	FOREIGN KEY (categoria_estado, nombre_estado) REFERENCES Estado(categoria, nombre),
	FOREIGN KEY (origen) REFERENCES Origen(nombre)
)

-- Usa Compra, Factura, Etapa, Tipo, Ejecucion, Zona, Sector, Inflacion, Producto, Caso
CREATE TABLE Cotizacion (
	numeroCotizacion smallint NOT NULL PRIMARY KEY,
	nombreOportunidad varchar(12) NOT NULL,
	fecha date NOT NULL,
	mesAnnoCierre varchar(7) NOT NULL,
	fechaCierre date NOT NULL,
	probabilidad decimal(5,2) NOT NULL,
	descripcion varchar(30) NOT NULL,
	seNego varchar(15) NOT NULL,
	nombre_competencia varchar(15) NOT NULL, -- contraQuien
	ordenCompra smallint UNIQUE, -- -1 si no se ha hecho la compra todavia
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
	contacto_clienteCodigo varchar(10) NOT NULL,
	contacto_motivo varchar(15) NOT NULL,
	FOREIGN KEY (contacto_clienteCodigo, contacto_motivo) REFERENCES ContactoCliente(codigoCliente, motivo),
	FOREIGN KEY (login_usuario) REFERENCES Usuario(userLogin),
	FOREIGN KEY (ordenCompra) REFERENCES Compra(ordenCompra),
	FOREIGN KEY (numero_factura) REFERENCES Factura(numeroFactura),
	FOREIGN KEY (nombre_etapa) REFERENCES Etapa(nombre),
	FOREIGN KEY (categoria_tipo, nombre_tipo) REFERENCES Tipo(categoria, nombre),
	FOREIGN KEY (codigo_ejecucion) REFERENCES Ejecucion(codigo),
	FOREIGN KEY (codigo_caso) REFERENCES Caso(codigo),
	FOREIGN KEY (zona) REFERENCES Zona(nombre),
	FOREIGN KEY (sector) REFERENCES Sector(nombre),
	FOREIGN KEY (anno_inflacion) REFERENCES Inflacion(anno),
	FOREIGN KEY (nombre_competencia) REFERENCES Competencia(nombre)
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
-- #          INSERTS           #
-- #----------------------------#

DECLARE @maxElement AS int,
@randomMarca AS int,
@randomColor AS int;

INSERT INTO Departamento (codigo,nombre)
VALUES	('DP01', 'Desarrollo'),
		('DP02', 'Backend'),
		('DP03', 'Frontend'),
		('DP04', 'Debugging'),
		('DP05', 'QA'),
		('DP06', 'Ventas'),
		('DP07', 'Serv Cliente'),
		('DP08', 'Operaciones'),
		('DP09', 'UX'),
		('DP10', 'Disenno'),
		('DP11', 'Proyectos');


INSERT INTO Rol (nombre)
VALUES	('Editor'),
		('Visor'),
		('Reportero'),
		('Admin');

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
		('Heredia'),
		('Alajuela'),
		('Guanacaste'),
		('Limon'),
		('Puntarenas');

INSERT INTO Sector (nombre)
VALUES	('Gobierno'),
		('Turismo'),
		('Residencial'),
		('Hoteleria');

INSERT INTO Cliente (codigo, nombreCuenta, correo, telefono, celular, sitioWeb, informacionAdicional, zona, sector, abreviatura_moneda, nombre_moneda, login_usuario)
VALUES	('C01', 'CuentaAMR', 'asd@asd.com', '123456', '456789', 'www.asd.cr', 'NO', 'Cartago', 'Hoteleria', 'CRC', 'colon', 'amr');

INSERT INTO Cliente (codigo, nombreCuenta, correo, telefono, celular, sitioWeb, informacionAdicional, zona, sector, abreviatura_moneda, nombre_moneda, login_usuario)
VALUES	('C02', 'CuentaJSM', 'zxc@zxc.com', '456123', '789456', 'www.zxc.org', 'NO', 'Heredia', 'Turismo', 'USD', 'dolar', 'jsm');

INSERT INTO FamiliaProducto (codigo, nombre, activo, descripcion)
VALUES 
('FMPR0001', 'FamiliaP 01', 1, 'Primera familia de producto'),
('FMPR0002', 'FamiliaP 02', 0, 'Segunda familia de producto'),
('FMPR0003', 'FamiliaP 03', 1, 'Tercera familia de producto'),
('FMPR0004', 'FamiliaP 04', 0, 'Cuarta familia de producto');

-- Agregar estados
-- CC: ContactoCliente
INSERT INTO Estado (categoria, nombre)
VALUES
('CC', 'Inicio'),
('CC', 'En Progreso'),
('CC', 'Finalizado'),
('Actividad', 'Inicio'),
('Actividad', 'En Progreso'),
('Actividad', 'Finalizado'),
('Tarea', 'Inicio'),
('Tarea', 'En Progreso'),
('Tarea', 'Finalizado'),
('Caso', 'Inicio'),
('Caso', 'En Progreso'),
('Caso', 'Finalizado');

-- Agregar tipos
-- CC: ContactoCliente
INSERT INTO Tipo (categoria, nombre)
VALUES
('CC', 'Tipo 1'),
('CC', 'Tipo 2'),
('CC', 'Tipo 3'),
('Actividad', 'Tipo 1'),
('Actividad', 'Tipo 2'),
('Actividad', 'Tipo 3'),
('Cotizacion', 'Tipo 1'),
('Cotizacion', 'Tipo 2'),
('Cotizacion', 'Tipo 3'),
('Caso', 'Tipo 1'),
('Caso', 'Tipo 2'),
('Caso', 'Tipo 3');

INSERT INTO Etapa (nombre)
VALUES
('Cotizacion'),
('Negociacion'),
('Pausa'),
('Facturada');

INSERT INTO Prioridad (tipo)
VALUES
('P0'),
('P1'),
('P2'),
('P3'),
('P4');

INSERT INTO Origen (nombre)
VALUES
('Origen 01'),
('Origen 02'),
('Origen 03'),
('Origen 04'),
('Origen 05'),
('Origen 06');

INSERT INTO Compra (ordenCompra, detalle)
VALUES	(01, 'Ninguna'),
		(02, 'Ninguna'),
		(03, 'Ninguna'),
		(04, 'Ninguna');


INSERT INTO Factura (numeroFactura, detalle)
VALUES	(001, 'no detalle'),
		(002, 'no detalle');

INSERT INTO Proyecto (codigo)
VALUES	('P001'),
		('P002'),
		('P003'),
		('P004');

INSERT INTO Ejecucion (codigo, nombre, fecha, codigo_proyecto, codigo_departamento, userLogin)
VALUES	('E001', 'Ejecucion1', '2022-10-10', 'P003', 'DP02', 'amr'),
		('E002', 'Ejecucion2', '2021-11-11', 'P002', 'DP03', 'jsm');

INSERT INTO Caso (codigo, origen, asunto, direccion, descripcion, categoria_tipo, nombre_tipo, tipo_prioridad, categoria_estado, nombre_estado)
VALUES	('C001', 'Origen 01', 'asunto1', 'direccion del caso', 'descripcion del caso', 'Caso', 'Tipo 2', 'P3', 'Caso', 'En Progreso'),
		('C002', 'Origen 02', 'asunto2', 'direccion del caso2', 'descripcion del caso2', 'Caso', 'Tipo 1', 'P1', 'Caso', 'Inicio');


INSERT INTO Inflacion (anno, porcentaje)
VALUES	('2019', 9.20),
		('2020', 0.20),
		('2021', 1.20),
		('2022', 2.20);

INSERT INTO Competencia (nombre)
VALUES	('Compet1'),
		('Compet2'),
		('Compet3');
GO

INSERT INTO ContactoCliente (codigoCliente, motivo, fecha, nombreContacto, correo, telefono, direccion, descripcion,
sector, categoria_estado, nombre_estado, zona, categoria_tipo, nombre_tipo, asesor)
VALUES
('C01', 'Primer Cont', '2020-01-15', 'Persona 1', 'c01@ejemplo.com', '22222201', 'Direccion 01', 'Contacto a C01', 
'Hoteleria', 'CC', 'Inicio', 'Cartago', 'CC', 'Tipo 1', 'amr'),
('C02', 'Primer Cont', '2020-03-15', 'Persona 2', 'c02@ejemplo.com', '22222202', 'Direccion 02', 'Contacto a C02', 
'Turismo', 'CC', 'Inicio', 'Heredia', 'CC', 'Tipo 1', 'jsm'),
('C02', 'Seguimiento', '2021-01-15', 'Persona 2', 'c02@ejemplo.com', '22222202', 'Direccion 02', 'Contacto a C02', 
'Turismo', 'CC', 'Inicio', 'Heredia', 'CC', 'Tipo 1', 'jsm'),
('C01', 'Seguimiento', '2021-03-15', 'Persona 1', 'c01@ejemplo.com', '22222201', 'Direccion 01', 'Contacto a C01', 
'Hoteleria', 'CC', 'Inicio', 'Cartago', 'CC', 'Tipo 2', 'amr');

INSERT INTO Cotizacion (numeroCotizacion, nombreOportunidad, fecha, mesAnnoCierre, fechaCierre, 
probabilidad, descripcion, seNego, nombre_competencia, ordenCompra, numero_factura, nombre_etapa, 
categoria_tipo, nombre_tipo, codigo_ejecucion, zona, sector, anno_inflacion, codigo_caso, login_usuario, 
contacto_clienteCodigo, contacto_motivo)
VALUES	(01, 'oport01', '2019-8-8', '09-2022', '2023-8-8', 20.3, 'descrip1', 'si', 'Compet1', 01, 001, 'Negociacion', 'Cotizacion', 'Tipo 1', 'E001',
		'Cartago', 'Turismo', '2019', 'C001', 'amr', 'C01', 'Primer Cont'),
		(02, 'oport02', '2020-9-9', '08-2022', '2022-9-9', 30.3, 'descrip2', 'si', 'Compet2', 02, 002, 'Cotizacion', 'Cotizacion', 'Tipo 2', 'E002',
		'Heredia', 'Gobierno', '2020', 'C002', 'amr', 'C01', 'Seguimiento'),
		(03, 'oport03', '2021-10-10', '10-2022', '2022-10-10', 40.3, 'descrip3', 'no', 'Compet3', 04, 001, 'Facturada', 'Cotizacion', 'Tipo 3', 'E001',
		'San Jose', 'Residencial', '2021', 'C001', 'jsm', 'C02', 'Primer Cont'),
		(04, 'oport04', '2018-11-11', '11-2022', '2019-11-11', 60.3, 'descrip4', 'no', 'Compet2', 03, 002 , 'Pausa', 'Cotizacion', 'Tipo 1', 'E002',
		'Heredia', 'Hoteleria', '2022', 'C002', 'jsm', 'C02', 'Seguimiento');
GO

-- #-----------------------------------#
-- #          PROCEDIMIENTOS           #
-- #-----------------------------------#
-- Procedimiento para poder agregar valores a la tabla de Producto
CREATE PROCEDURE insertarProducto
	@ProCodifo varchar(10),
	@ProNombre varchar(12),
	@ProActivo bit,
	@ProDescripcion varchar(30),
	@ProPrecioEstandar decimal(9,2),
	@ProCodigoFamilia varchar(10)
AS
DECLARE @Return int
BEGIN
	BEGIN TRY
		INSERT INTO Producto VALUES (@ProCodifo, @ProNombre, @ProActivo, @ProDescripcion, 
		@ProPrecioEstandar, @ProCodigoFamilia)
		SET @Return = 1
	END TRY

	BEGIN CATCH
		PRINT @@error
		SET @Return = -1
	END CATCH
END
GO

-- Procedimiento para poder ediatr un Producto
CREATE PROCEDURE editarProducto
	@ProCodigo varchar(10),
	@NewProCodigo varchar(10),
	@ProNombre varchar(12),
	@ProActivo bit,
	@ProDescripcion varchar(30),
	@ProPrecioEstandar decimal(9,2),
	@ProCodigoFamilia varchar(10)
AS
DECLARE @Return int
BEGIN
	BEGIN TRY
		UPDATE Producto SET
		codigo = @NewProCodigo,
		nombre = @ProNombre,
		activo = @ProActivo,
		descripcion = @ProDescripcion,
		precioEstandar = @ProPrecioEstandar,
		codigo_familia = @ProCodigoFamilia
		WHERE codigo = @ProCodigo

		UPDATE ProductoXCotizacion SET
		codigo_producto = @NewProCodigo
		WHERE codigo_producto = @ProCodigo
		SET @Return = 1
	END TRY

	BEGIN CATCH
		PRINT @@error
		SET @Return = -1
	END CATCH
END
GO

-- Procedimiento para poder agregar valores a la tabla de ContactoCliente
CREATE PROCEDURE insertarContactoCliente
	@CCCodigoCliente varchar(10),
	@CCMotivo varchar(15),
	@CCFecha date,
	@CCNombreContacto varchar(12),
	@CCCorreo varchar(20),
	@CCTelefono varchar(10),
	@CCDireccion varchar(35),
	@CCDescripcion varchar(30),
	@CCSector varchar(12),
	@CCNombreEstado varchar(12),
	@CCZona varchar(12),
	@CCNombreTipo varchar(12),
	@CCAsesor varchar(10)
AS
DECLARE @Return int
BEGIN
	BEGIN TRY
		INSERT INTO ContactoCliente VALUES 
		(@CCCodigoCliente, @CCMotivo, @CCFecha, @CCNombreContacto, @CCCorreo, @CCTelefono, 
		@CCDireccion, @CCDescripcion, @CCSector, 'CC', @CCNombreEstado, 
		@CCZona, 'CC', @CCNombreTipo, @CCAsesor)
		SET @Return = 1
	END TRY

	BEGIN CATCH
		PRINT @@error
		SET @Return = -1
	END CATCH
END
GO

-- Procedimiento para poder agregar valores a la tabla de Ejecucion
CREATE PROCEDURE insertarEjecucion
	@EjeCodigo varchar(10),
	@EjeNombre varchar(12),
	@EjeFecha date,
	@EjeFechaCierre date,
	@EjeCodigoProyecto varchar(10),
	@EjeCodigoDept varchar(10),
	@EjeAsesor varchar(10)
AS
DECLARE @Return int
BEGIN
	BEGIN TRY
		INSERT INTO Ejecucion VALUES 
		(@EjeCodigo, @EjeNombre, @EjeFecha, @EjeFechaCierre, @EjeCodigoProyecto, @EjeCodigoDept, @EjeAsesor)
		SET @Return = 1
	END TRY

	BEGIN CATCH
		PRINT @@error
		SET @Return = -1
	END CATCH
END
GO

-- Procedimiento para poder agregar valores a la tabla de Caso
CREATE PROCEDURE insertarCaso
	@CasoCodigo varchar(10),
	@CasoOrigen varchar(12),
	@CasoAsunto varchar(10),
	@CasoDireccion varchar(35),
	@CasoDescripcion varchar(30),
	@CasoTipo varchar(12),
	@CasoPrioridad varchar(3),
	@CasoEstado varchar(12)
AS
DECLARE @Return int
BEGIN
	BEGIN TRY
		INSERT INTO Caso VALUES 
		(@CasoCodigo, @CasoOrigen, @CasoAsunto, @CasoDireccion, @CasoDescripcion, 
		'Caso', @CasoTipo, @CasoPrioridad, 'Caso', @CasoEstado)
		SET @Return = 1
	END TRY

	BEGIN CATCH
		PRINT @@error
		SET @Return = -1
	END CATCH
END
GO

-- Procedimiento para poder agregar valores a la tabla de Cotizacion y Factura
CREATE PROCEDURE insertarCotizacionFactura
	@CotNumero smallint,
	@CotNombreOportunidad varchar(12),
	@CotFecha date,
	@CotMesAnnoCierre varchar(7),
	@CotFechaCierre date,
	@CotProbabilidad decimal(5,2),
	@CotDescripcion varchar(30),
	@CotSeNego varchar(15),
	@CotNombreCompetencia varchar(15),
	@CotNumeroFactura smallint,
	@FactDetalle varchar(30),
	@CotEtapa varchar(12),
	@CotTipo varchar(12), -- nombre tipo
	@CotCodigoEjecucion varchar(10),
	@CotZona varchar(12),
	@CotSector varchar(12),
	@CotAnnoInflacion varchar(4),
	@CotCaso varchar(10),
	@CotUsuario varchar(10), -- asesor
	@CotContCliente varchar(10),
	@CotContMotico varchar(15)
AS
DECLARE @Return int
BEGIN
	BEGIN TRY
		INSERT INTO Factura VALUES (@CotNumeroFactura, @FactDetalle)
		INSERT INTO Cotizacion VALUES 
		(@CotNumero, @CotNombreOportunidad, @CotFecha, @CotMesAnnoCierre, @CotFechaCierre, 
		@CotProbabilidad, @CotDescripcion, @CotSeNego, @CotNombreCompetencia, -1, @CotNumeroFactura, 
		@CotEtapa, 'Cotizacion', @CotTipo, @CotCodigoEjecucion, @CotZona, @CotSector,
		@CotAnnoInflacion, @CotCaso, @CotUsuario, @CotContCliente, @CotContMotico)
		SET @Return = 1
	END TRY

	BEGIN CATCH
		PRINT @@error
		SET @Return = -1
	END CATCH
END
GO

-- Procedimiento para poder agregar una Tarea a un Contacto Cliente
CREATE PROCEDURE insertarTareaContacto
	@TCCodigo varchar(10),
	@TCNombre varchar(12),
	@TCDescripcion varchar(30),
	@TCFechaInicio date,
	@TCFechaFinalizacion date,
	@TCEstado varchar(12),
	@TCUsuarioAsignado varchar(10),
	@TCClienteContacto varchar(10),
	@TCMotivoContacto varchar(15)
AS
DECLARE @Return int
BEGIN
	BEGIN TRY
		INSERT INTO Tarea VALUES (@TCCodigo, @TCNombre, @TCDescripcion, @TCFechaInicio, 
		@TCFechaFinalizacion, 'Tarea', @TCEstado, @TCUsuarioAsignado)
		INSERT INTO TareaXContactoCliente VALUES 
		(@TCClienteContacto, @TCMotivoContacto, @TCCodigo)
		SET @Return = 1
	END TRY

	BEGIN CATCH
		PRINT @@error
		SET @Return = -1
	END CATCH
END
GO

-- Procedimiento para poder agregar una Tarea a un Contacto Cliente
CREATE PROCEDURE insertarActividadContacto
	@ACCodigo varchar(10),
	@ACNombre varchar(12),
	@ACDescripcion varchar(30),
	@ACEstado varchar(12),
	@ACTipo varchar(12),
	@ACAsesor varchar(10),
	@ACClienteContacto varchar(10),
	@ACMotivoContacto varchar(15)
AS
DECLARE @Return int
BEGIN
	BEGIN TRY
		INSERT INTO Actividad VALUES (@ACCodigo, @ACNombre, @ACDescripcion, 'Actividad', 
		@ACEstado, 'Actividad', @ACTipo, @ACAsesor)
		INSERT INTO ActividadXContactoCliente VALUES 
		(@ACClienteContacto, @ACMotivoContacto, @ACCodigo)
		SET @Return = 1
	END TRY

	BEGIN CATCH
		PRINT @@error
		SET @Return = -1
	END CATCH
END
GO

EXEC insertarProducto 'PROD001', 'Producto 01', 1, 'Primer producto', 5500, 'FMPR0001';
EXEC insertarProducto 'PROD002', 'Producto 02', 1, 'Segundo producto', 3500, 'FMPR0001';
EXEC insertarProducto 'PROD003', 'Producto 03', 0, 'Tercero producto', 4500, 'FMPR0002';
EXEC insertarProducto 'PROD004', 'Producto 04', 0, 'Cuarto producto', 6000, 'FMPR0003';
EXEC insertarProducto 'PROD005', 'Producto 05', 1, 'Quinto producto', 5533, 'FMPR0004';
EXEC insertarProducto 'PROD006', 'Producto 06', 0, 'Sexto producto', 5030, 'FMPR0004';
EXEC insertarProducto 'PROD006', 'Producto 07', 0, 'Setimo producto', 15500, 'FMPR0003';
EXEC insertarProducto 'PROD006', 'Producto 08', 1, 'Octavo producto', 7777, 'FMPR0003';
GO

INSERT INTO ProductoXCotizacion (codigo_producto, numero_cotizacion)
VALUES
('PROD001', 1),
('PROD002', 1),
('PROD003', 1),
('PROD001', 2),
('PROD002', 2),
('PROD003', 2),
('PROD003', 3),
('PROD001', 3),
('PROD002', 3),
('PROD004', 3),
('PROD005', 3),
('PROD006', 4),
('PROD001', 4);
GO

EXEC insertarContactoCliente 'C01', 'Acercamiento', '2019-03-05', 'Aivy', 'asd@asd.com', '88888888', 'Sabana, San Jose', 'Primer acercamiento', 'Tres Rios', 'Inicio', 'San Jose', 'Tipo1', 'amr';
GO

CREATE PROCEDURE sp_addClient 
	@codigo VARCHAR(10), 
	@nombreCuenta VARCHAR(12), 
	@correo VARCHAR(20), 
	@telefono VARCHAR(10), 
	@celular VARCHAR(10), 
	@sitioWeb VARCHAR(22), 
	@informacionAdicional VARCHAR(30), 
	@zona VARCHAR(12), 
	@sector VARCHAR(12), 
	@abreviatura_moneda VARCHAR(4), 
	@nombre_moneda VARCHAR(12), 
	@login_usuario VARCHAR(10)
AS
DECLARE @Return INT
BEGIN
	BEGIN TRY
    INSERT INTO Cliente(
			codigo, nombreCuenta, correo, telefono, celular, sitioWeb, informacionAdicional, zona, sector, 
			abreviatura_moneda, nombre_moneda, login_usuario)
        VALUES(@codigo, @nombreCuenta, @correo, @telefono, @celular, @sitioWeb, @informacionAdicional, 
			@zona, @sector, @abreviatura_moneda, @nombre_moneda, @login_usuario)
		SET @Return = 1
	END TRY

	BEGIN CATCH
		PRINT @@error
		SET @Return = -1
	END CATCH
END;
GO

CREATE PROCEDURE sp_getClientsBySector @param_sector VARCHAR(12)
AS 
BEGIN
	SELECT * FROM Cliente
	WHERE sector = @param_sector
END;
GO

CREATE PROCEDURE sp_getClientsByZone @param_zona VARCHAR(12)
AS 
BEGIN
	SELECT * FROM Cliente
	WHERE zona = @param_zona
END;
GO

CREATE PROCEDURE sp_getClientsByQuotes @param_numeroCotizacion SMALLINT
AS 
BEGIN

	SELECT c.nombreCuenta, c.correo, c.telefono, c.celular, c.sitioWeb, c.informacionAdicional,
		c.zona, c.sector, c.nombre_moneda, c.login_usuario,
		ct.numeroCotizacion
	FROM Cliente c
		JOIN Cotizacion ct ON c.login_usuario = ct.login_usuario
	WHERE ct.numeroCotizacion = @param_numeroCotizacion
END;
GO

-- #-----------------------------#
-- #           VISTAS            #
-- #-----------------------------#
-- Vista para tomar las cotizaciones con compras
CREATE VIEW cotizacionesCompra AS (
	SELECT DISTINCT
		pxc.codigo_producto
	FROM ProductoXCotizacion AS pxc
	JOIN Cotizacion AS c ON c.numeroCotizacion = pxc.numero_cotizacion
	WHERE c.nombre_etapa = 'Facturada' -- si se efectuo la venta
);
GO

-- Vista para obtener el anno y mes por fecha de cotizacion
CREATE VIEW CotAnnoMes 
AS SELECT DISTINCT
	c.fecha,
	CAST(DATEPART(YEAR, c.fecha) AS varchar(4)) + '-' + CAST(DATEPART(MONTH, c.fecha) AS varchar(4)) AS annoMes
FROM Cotizacion AS c;
GO

-- Vista para obtener las distintas fechas en cotizacion
CREATE VIEW CotFechas 
AS SELECT DISTINCT
	CONVERT(VARCHAR(10), c.fecha, 20) AS fecha
FROM Cotizacion AS c;
GO

-- Vista para obtener los montos de los productos por cotizacion
CREATE VIEW CotMontos
AS SELECT
		pxc.numero_cotizacion,
		SUM(p.precioEstandar) AS monto
	FROM ProductoXCotizacion AS pxc
	JOIN Producto AS p ON p.codigo = pxc.codigo_producto
	GROUP BY pxc.numero_cotizacion;
GO

-- #------------------------------#
-- #          FUNCIONES           #
-- #------------------------------#
-- Funcion para obtener el numero de contactos (TODOS)
-- dentro de un rango de fechas
CREATE FUNCTION contAsesorRangoFechas(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT
		cc.asesor,
		cc.codigoCliente,
		cc.motivo
	FROM ContactoCliente AS cc
	WHERE cc.fecha BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
);
GO

-- Funcion para obtener el numero de cotizacion de las cotizaciones (TODAS)
-- dentro de un rango de fechas
CREATE FUNCTION todasCotEnRangoFechas(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT
		c.numeroCotizacion
	FROM Cotizacion AS c
	WHERE c.fecha BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
);
GO

-- Funcion para obtener el numero de cotizacion de las cotizaciones (NO ventas)
-- dentro de un rango de fechas
CREATE FUNCTION cotEnRangoFechas(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT
		c.numeroCotizacion
	FROM Cotizacion AS c
	WHERE c.nombre_etapa != 'Facturada'
	AND c.fecha BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
);
GO

-- Funcion para obtener el numero de cotizacion (Facturada/Venta) de las cotizaciones dentro
-- de un rango de fechas
CREATE FUNCTION ventEnRangoFechas(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT
		c.numeroCotizacion
	FROM Cotizacion AS c
	WHERE c.nombre_etapa = 'Facturada'
	AND c.fecha BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
);
GO

CREATE FUNCTION cotizacionEnRangoFechas(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT
		c.numeroCotizacion
	FROM Cotizacion AS c
	WHERE c.fecha BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
);
GO

-- Funcion para obtener las tareas en un rango de fechas
CREATE FUNCTION tareasEnRangoFechas(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT
		t.codigo
	FROM Tarea AS t
	WHERE t.fechaInicio BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
);
GO

-- Funcion para obtener las ejecuciones en un rango de fechas
CREATE FUNCTION ejecucionEnRangoFechas(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT
		e.codigo
	FROM Ejecucion AS e
	WHERE e.fecha BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
);
GO

-- Funcion para obtener el valor por el cual se debe multiplicar el monto de la cotizacion para obtener el valor actual
CREATE FUNCTION multiploValorActual(@Desde varchar(4))
RETURNS DECIMAL(3,2)
AS
BEGIN
	DECLARE @ret DECIMAL(3,2);
	SELECT @ret =  EXP(SUM(LOG(porcentaje)))
	FROM Inflacion
	WHERE CAST(anno AS INT) BETWEEN CAST(@Desde AS INT) AND DATENAME(YYYY, getdate()) - 1;
	RETURN @ret
END;
GO

-- Funcion para seleccionar todos los productos
CREATE FUNCTION obtenerFamProd()
RETURNS TABLE
AS
RETURN
(
	SELECT * FROM FamiliaProducto
);
GO

-- Funcion para seleccionar todos los productos
CREATE FUNCTION obtenerProductos()
RETURNS TABLE
AS
RETURN
(
	SELECT * FROM Producto
);
GO

-- Funcion para seleccionar los datos de un producto
CREATE FUNCTION obtenerProducto(@Codigo varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT * 
	FROM Producto
	WHERE codigo = @Codigo
);
GO

-- Funcion para seleccionar todos los contactos a clientes
CREATE FUNCTION obtenerTodosContactos()
RETURNS TABLE
AS
RETURN
(
	SELECT 
	cc.*,
	c.nombreCuenta
	FROM ContactoCliente AS cc
	JOIN Cliente AS c ON c.codigo = cc.codigoCliente
);
GO

-- Funcion para seleccionar todos los contactos a clientes
CREATE FUNCTION obtenerContactosCliente(@Cliente varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT 
	cc.*,
	c.nombreCuenta
	FROM ContactoCliente AS cc
	JOIN Cliente AS c ON c.codigo = cc.codigoCliente
	WHERE codigoCliente = @Cliente
);
GO

-- Funcion para seleccionar todas las tareas por contacto
CREATE FUNCTION obtenerTareasContacto(@Contacto varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT 
	t.*,
	txc.cliente_contacto,
	txc.motivo_contacto
	FROM Tarea AS t
	JOIN TareaXContactoCliente AS txc ON t.codigo = txc.codigo_tarea
	WHERE cliente_contacto = @Contacto
);
GO

-- Funcion para seleccionar todas las actividades por contacto
CREATE FUNCTION obtenerActividadesContacto(@Contacto varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT 
	a.*,
	axc.cliente_contacto,
	axc.motivo_contacto
	FROM Actividad AS a
	JOIN ActividadXContactoCliente AS axc ON a.codigo = axc.codigo_actividad
	WHERE cliente_contacto = @Contacto
);
GO

-- Funcion para seleccionar los productos mas vendidos
CREATE FUNCTION masVendidosProductos()
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT TOP 10
	p.codigo,
	p.nombre,
	p.activo,
	p.descripcion,
	p.precioEstandar,
	p.codigo_familia,
	SUM(CASE WHEN c.nombre_etapa = 'Facturada' THEN 1 ELSE 0 END) AS ventas
	FROM Producto AS p
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN Cotizacion AS c ON c.numeroCotizacion = pxc.numero_cotizacion
	GROUP BY p.codigo, p.nombre, p.activo, p.descripcion, p.precioEstandar, p.codigo_familia
	ORDER BY ventas DESC
);
GO

-- Funcion para seleccionar los productos mas vendidos ordenados DESC por rango de fecha
CREATE FUNCTION masVendidosProductosDESC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT TOP 10
		p.codigo,
		p.nombre,
		p.activo,
		p.descripcion,
		p.precioEstandar,
		p.codigo_familia,
		SUM(p.precioEstandar) AS ventas
	FROM Producto AS p
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN ventEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = pxc.numero_cotizacion
	GROUP BY p.codigo, p.nombre, p.activo, p.descripcion, p.precioEstandar, p.codigo_familia
	ORDER BY ventas DESC
);
GO

-- Funcion para seleccionar los productos mas vendidos ordenados ASC por rango de fecha
CREATE FUNCTION masVendidosProductosASC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT TOP 10
		p.codigo,
		p.nombre,
		p.activo,
		p.descripcion,
		p.precioEstandar,
		p.codigo_familia,
		SUM(p.precioEstandar) AS ventas
	FROM Producto AS p
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN ventEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = pxc.numero_cotizacion
	GROUP BY p.codigo, p.nombre, p.activo, p.descripcion, p.precioEstandar, p.codigo_familia
	ORDER BY ventas ASC
);
GO

-- Funcion para seleccionar los productos mas vendidos cotizados DESC por rango de fecha
CREATE FUNCTION masCotProductosDESC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT TOP 10
		p.codigo,
		p.nombre,
		p.activo,
		p.descripcion,
		p.precioEstandar,
		p.codigo_familia,
		COUNT(pxc.numero_cotizacion) AS cotizaciones
	FROM Producto AS p
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN cotEnRangoFechas(@Desde, @Hasta) AS cerf ON cerf.numeroCotizacion = pxc.numero_cotizacion
	JOIN Cotizacion AS c ON c.numeroCotizacion = cerf.numeroCotizacion
	GROUP BY p.codigo, p.nombre, p.activo, p.descripcion, p.precioEstandar, p.codigo_familia
	ORDER BY cotizaciones DESC
);
GO

-- Funcion para seleccionar los productos mas vendidos cotizados ASC por rango de fecha
CREATE FUNCTION masCotProductosASC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT TOP 10
		p.codigo,
		p.nombre,
		p.activo,
		p.descripcion,
		p.precioEstandar,
		p.codigo_familia,
		COUNT(pxc.numero_cotizacion) AS cotizaciones
	FROM Producto AS p
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN cotEnRangoFechas(@Desde, @Hasta) AS cerf ON cerf.numeroCotizacion = pxc.numero_cotizacion
	JOIN Cotizacion AS c ON c.numeroCotizacion = cerf.numeroCotizacion
	GROUP BY p.codigo, p.nombre, p.activo, p.descripcion, p.precioEstandar, p.codigo_familia
	ORDER BY cotizaciones ASC
);
GO

-- Funcion para seleccionar los 10 clientes con mas ventas DESC
CREATE FUNCTION masVentasClientesDESC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT TOP 10
		cl.codigo,
		cl.nombreCuenta,
		cl.celular,
		cl.correo,
		cl.informacionAdicional,
		cl.login_usuario AS asesor,
		cl.abreviatura_moneda,
		cl.sector,
		cl.sitioWeb,
		cl.telefono,
		cl.zona,
		SUM(CASE WHEN c.nombre_etapa = 'Facturada' THEN cm.monto ELSE 0 END) AS montoCRC,
		SUM(CASE WHEN c.nombre_etapa = 'Facturada' THEN 1 ELSE 0 END) AS ventas,
		SUM(CASE WHEN c.nombre_etapa = 'Facturada' AND cl.abreviatura_moneda = 'CRC' THEN cm.monto
				 WHEN c.nombre_etapa = 'Facturada' AND cl.abreviatura_moneda = 'USD' THEN cm.monto/600
				 ELSE 0 END) AS monto
	FROM Cliente AS cl
	JOIN Cotizacion AS c ON c.contacto_clienteCodigo = cl.codigo
	JOIN CotMontos AS cm ON cm.numero_cotizacion = c.numeroCotizacion
	JOIN ventEnRangoFechas(@Desde, @Hasta) AS tcerf ON tcerf.numeroCotizacion = cm.numero_cotizacion
	GROUP BY cl.abreviatura_moneda, cl.celular, cl.codigo, cl.correo, cl.informacionAdicional, cl.login_usuario,
		cl.nombre_moneda, cl.nombreCuenta, cl.sector, cl.sitioWeb, cl.telefono, cl.zona
	--ORDER BY ventas DESC
	ORDER BY montoCRC DESC
);
GO

-- Funcion para seleccionar los 10 clientes con menos ventas ASC
CREATE FUNCTION masVentasClientesASC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT TOP 10
		cl.codigo,
		cl.nombreCuenta,
		cl.celular,
		cl.correo,
		cl.informacionAdicional,
		cl.login_usuario AS asesor,
		cl.abreviatura_moneda,
		cl.sector,
		cl.sitioWeb,
		cl.telefono,
		cl.zona,
		SUM(CASE WHEN c.nombre_etapa = 'Facturada' THEN cm.monto ELSE 0 END) AS montoCRC,
		SUM(CASE WHEN c.nombre_etapa = 'Facturada' THEN 1 ELSE 0 END) AS ventas,
		SUM(CASE WHEN c.nombre_etapa = 'Facturada' AND cl.abreviatura_moneda = 'CRC' THEN cm.monto
				 WHEN c.nombre_etapa = 'Facturada' AND cl.abreviatura_moneda = 'USD' THEN cm.monto/600
				 ELSE 0 END) AS monto
	FROM Cliente AS cl
	JOIN Cotizacion AS c ON c.contacto_clienteCodigo = cl.codigo
	JOIN CotMontos AS cm ON cm.numero_cotizacion = c.numeroCotizacion
	JOIN ventEnRangoFechas(@Desde, @Hasta) AS tcerf ON tcerf.numeroCotizacion = cm.numero_cotizacion
	GROUP BY cl.abreviatura_moneda, cl.celular, cl.codigo, cl.correo, cl.informacionAdicional, cl.login_usuario,
		cl.nombre_moneda, cl.nombreCuenta, cl.sector, cl.sitioWeb, cl.telefono, cl.zona
	--ORDER BY ventas DESC
	ORDER BY montoCRC ASC
);
GO

-- Funcion para seleccionar las cotizaciones y ventas por departamento
CREATE FUNCTION cotVentaXDepartamento(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT
		d.codigo,
		d.nombre,
		SUM(CASE WHEN c.nombre_etapa = 'Facturada' THEN 1 ELSE 0 END) AS ventas,
		SUM(CASE WHEN c.nombre_etapa != 'Facturada' THEN 1 ELSE 0 END) AS cotizaciones
	FROM Departamento AS d
	JOIN Usuario AS u ON u.codigo_departamento = d.codigo
	JOIN Cotizacion AS c ON c.login_usuario = u.userLogin
	JOIN todasCotEnRangoFechas(@Desde, @Hasta) AS tcerf ON tcerf.numeroCotizacion = c.numeroCotizacion
	GROUP BY d.codigo, d.nombre
);
GO

-- Funcion para seleccionar las familias de productos mas vendidos
CREATE FUNCTION masVendidosFamProductos()
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT TOP 10
	fp.codigo,
	fp.nombre,
	fp.activo,
	fp.descripcion,
	COUNT(DISTINCT pxc.numero_cotizacion) AS ventas
	FROM FamiliaProducto AS fp
	JOIN Producto AS p ON p.codigo_familia = fp.codigo
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN CotizacionesCompra AS cc ON cc.codigo_producto = pxc.codigo_producto
	GROUP BY fp.codigo, fp.nombre, fp.activo, fp.descripcion
	ORDER BY ventas DESC
);
GO

-- Funcion para seleccionar las familias de productos vendidos
CREATE FUNCTION ventasFamProductos(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT
		fp.codigo,
		fp.nombre,
		SUM(p.precioEstandar) AS ventas
	FROM FamiliaProducto AS fp
	JOIN Producto AS p ON p.codigo_familia = fp.codigo
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN ventEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = pxc.numero_cotizacion
	GROUP BY fp.codigo, fp.nombre
);
GO

-- Funcion para seleccionar los productos mas cotizados
CREATE FUNCTION masCotizadosProductos()
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT TOP 10
	p.codigo,
	p.nombre,
	p.activo,
	p.descripcion,
	p.precioEstandar,
	p.codigo_familia,
	SUM(CASE WHEN c.nombre_etapa != 'Facturada' THEN 1 ELSE 0 END) AS cotizaciones
	FROM Producto AS p
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN Cotizacion AS c ON c.numeroCotizacion = pxc.numero_cotizacion
	GROUP BY p.codigo, p.nombre, p.activo, p.descripcion, p.precioEstandar, p.codigo_familia
	ORDER BY cotizaciones DESC
);
GO

-- Funcion para seleccionar las familias de productos mas vendidos
CREATE FUNCTION masCotizadosFamProductos()
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT TOP 10
	fp.codigo,
	fp.nombre,
	fp.activo,
	fp.descripcion,
	COUNT(DISTINCT pxc.numero_cotizacion) AS cotizaciones
	FROM FamiliaProducto AS fp
	JOIN Producto AS p ON p.codigo_familia = fp.codigo
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN Cotizacion AS c ON c.numeroCotizacion = pxc.numero_cotizacion
	GROUP BY fp.codigo, fp.nombre, fp.activo, fp.descripcion
	ORDER BY cotizaciones DESC
);
GO

-- Funcion para seleccionar la informacion basica de los usuarios para usar en los catalogos
CREATE FUNCTION usuarioBasico()
RETURNS TABLE
AS
RETURN
(
	SELECT
	userLogin,
	nombre,
	primerApellido,
	segundoApellido
	FROM Usuario
);
GO

-- Funcion para seleccionar la informacion de los usuarios
CREATE FUNCTION usuarios()
RETURNS TABLE
AS
RETURN
(
	SELECT
	*
	FROM Usuario
);
GO

-- Funcion para seleccionar estado por categoria
CREATE FUNCTION estadoBasico(@Categoria varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT
	nombre
	FROM Estado
	WHERE categoria = @Categoria
);
GO

-- Funcion para seleccionar tipo por categoria
CREATE FUNCTION tipoBasico(@Categoria varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT
	nombre
	FROM Tipo
	WHERE categoria = @Categoria
);
GO

-- Funcion para seleccionar los distintos a�o-mes
CREATE FUNCTION cotDisMesAnno()
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT annoMes FROM CotAnnoMes
);
GO

-- Funcion para seleccionar las zonas
CREATE FUNCTION todas_las_zonas()
RETURNS TABLE
AS
RETURN
(
	SELECT *
	FROM Zona
);
GO

-- Funcion para seleccionar cantidad de ventas y cotizaciones por mes por a�o
CREATE FUNCTION cotVentasMesAnnoCant(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT
		cam.annoMes,
		SUM(CASE WHEN c.nombre_etapa = 'Facturada' THEN 1 ELSE 0 END) AS ventas,
		SUM(CASE WHEN c.nombre_etapa != 'Facturada' THEN 1 ELSE 0 END) AS cotizaciones
	FROM Cotizacion AS c
	JOIN todasCotEnRangoFechas(@Desde, @Hasta) AS tcerf ON tcerf.numeroCotizacion = c.numeroCotizacion
	JOIN CotAnnoMes AS cam ON cam.fecha = c.fecha
	GROUP BY cam.annoMes
);
GO

-- Funcion para seleccionar monto de ventas y cotizaciones por mes por a�o
CREATE FUNCTION cotVentasMesAnnoMonto(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT
		cam.annoMes,
		SUM(CASE WHEN c.nombre_etapa = 'Facturada' THEN cm.monto ELSE 0 END) AS ventas,
		SUM(CASE WHEN c.nombre_etapa != 'Facturada' THEN cm.monto ELSE 0 END) AS cotizaciones
	FROM Cotizacion AS c
	JOIN CotMontos AS cm ON cm.numero_cotizacion = c.numeroCotizacion
	JOIN todasCotEnRangoFechas(@Desde, @Hasta) AS tcerf ON tcerf.numeroCotizacion = cm.numero_cotizacion
	JOIN CotAnnoMes AS cam ON cam.fecha = c.fecha
	GROUP BY cam.annoMes
);
GO

-- Funcion para obtener las ventas por sector, devuelve el monto total
CREATE FUNCTION ventasxsector(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT CAST(SUM(p.precioEstandar) AS INT) AS Monto, sector
	FROM Cotizacion c
	JOIN ProductoXCotizacion pxc ON c.numeroCotizacion = pxc.numero_cotizacion
		JOIN Producto p ON pxc.codigo_producto = p.codigo
			JOIN ventEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = pxc.numero_cotizacion
	WHERE nombre_etapa = 'Facturada' 
	GROUP BY sector
);
GO

-- Funcion para obtener las ventas por zona y devuelve el monto total
CREATE FUNCTION ventasxzona(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT CAST(SUM(p.precioEstandar) AS INT) AS Monto, zona 
	FROM Cotizacion c
	JOIN ProductoXCotizacion pxc ON c.numeroCotizacion = pxc.numero_cotizacion
		JOIN Producto p ON pxc.codigo_producto = p.codigo
			JOIN ventEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = pxc.numero_cotizacion
	WHERE nombre_etapa = 'Facturada' 
	GROUP BY zona
);
GO

-- Funcion para obtener las ventas por departamento, muestra el monto total
CREATE FUNCTION ventasxdepartamento(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT (SELECT CONVERT(DECIMAL (5,2), (( COUNT(ct.numeroCotizacion) * 1.0 / (SELECT COUNT(numeroCotizacion) FROM Cotizacion WHERE nombre_etapa = 'Facturada' ) ) * 100 ))) AS Porcentaje, d.nombre AS departamento
	FROM Cotizacion ct
		JOIN Ejecucion e ON ct.codigo_ejecucion = e.codigo
			JOIN Departamento d ON e.codigo_departamento = d.codigo
				JOIN ventEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = ct.numeroCotizacion
	WHERE nombre_etapa = 'Facturada' 
	GROUP BY d.nombre
);
GO

-- Funcion para obtener los casos por tipo y lo muestra como porcentaje
CREATE FUNCTION casosxtipo(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT CONVERT(DECIMAL (5,2), (( COUNT(ct.codigo_caso) * 1.0 / (SELECT COUNT(codigo_caso) FROM Cotizacion ct WHERE ct.fecha BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101))) * 100 )) AS Porcentaje, c.nombre_tipo AS Tipo
	FROM Cotizacion ct
	JOIN Caso c ON ct.codigo_caso = c.codigo
		JOIN cotizacionEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = ct.numeroCotizacion
	GROUP BY c.nombre_tipo
);
GO

--Funcion para obtener los casos por estado
CREATE FUNCTION casosxestado(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT COUNT(ct.codigo_caso) AS Casos, c.nombre_estado AS Estado
	FROM Cotizacion ct
	JOIN Caso c ON ct.codigo_caso = c.codigo
		JOIN cotizacionEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = ct.numeroCotizacion
	GROUP BY c.nombre_estado
);
GO

-- Funcion para obtener las cotizaciones por tipo
CREATE FUNCTION cotizacionesxtipo(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT COUNT(ct.numeroCotizacion) AS Cotizaciones, ct.nombre_tipo AS Tipo
	FROM Cotizacion ct
		JOIN cotizacionEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = ct.numeroCotizacion
	GROUP BY ct.nombre_tipo
);
GO

-- Funcion para obtener la cantidad de contactos por usuario DESC
CREATE FUNCTION contactosXUsuarioDESC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 1000
		u.userLogin,
		u.nombre,
		u.primerApellido,
		u.segundoApellido,
		COUNT(cc.codigoCliente) AS contactos
	FROM Usuario AS u
	JOIN ContactoCliente AS cc ON cc.asesor = u.userLogin
	JOIN contAsesorRangoFechas(@Desde, @Hasta) AS carf ON carf.codigoCliente = cc.codigoCliente AND carf.motivo = cc.motivo
	GROUP BY u.userLogin, u.nombre, u.primerApellido, u.segundoApellido
	ORDER BY contactos DESC
);
GO

-- Funcion para obtener la cantidad de contactos por usuario ASC
CREATE FUNCTION contactosXUsuarioASC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 1000
		u.userLogin,
		u.nombre,
		u.primerApellido,
		u.segundoApellido,
		COUNT(cc.codigoCliente) AS contactos
	FROM Usuario AS u
	JOIN ContactoCliente AS cc ON cc.asesor = u.userLogin
	JOIN contAsesorRangoFechas(@Desde, @Hasta) AS carf ON carf.codigoCliente = cc.codigoCliente AND carf.motivo = cc.motivo
	GROUP BY u.userLogin, u.nombre, u.primerApellido, u.segundoApellido
	ORDER BY contactos ASC
);
GO

-- Funcion para obtener los usuarios con mas ventas DESC
CREATE FUNCTION usuariosMasVentasDESC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 10
		u.userLogin,
		u.nombre,
		u.primerApellido,
		u.segundoApellido,
	SUM(CASE WHEN c.nombre_etapa = 'Facturada' THEN cm.monto ELSE 0 END) AS monto
	FROM Usuario AS u
	JOIN Cotizacion AS c ON c.login_usuario = u.userLogin
	JOIN CotMontos AS cm ON cm.numero_cotizacion = c.numeroCotizacion
	JOIN ventEnRangoFechas(@Desde, @Hasta) AS tcerf ON tcerf.numeroCotizacion = cm.numero_cotizacion
	GROUP BY u.userLogin, u.nombre, u.primerApellido, u.segundoApellido
	ORDER BY monto DESC
);
GO

-- Funcion para obtener los usuarios con menos ventas ASC
CREATE FUNCTION usuariosMasVentasASC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 10
		u.userLogin,
		u.nombre,
		u.primerApellido,
		u.segundoApellido,
	SUM(CASE WHEN c.nombre_etapa = 'Facturada' THEN cm.monto ELSE 0 END) AS monto
	FROM Usuario AS u
	JOIN Cotizacion AS c ON c.login_usuario = u.userLogin
	JOIN CotMontos AS cm ON cm.numero_cotizacion = c.numeroCotizacion
	JOIN ventEnRangoFechas(@Desde, @Hasta) AS tcerf ON tcerf.numeroCotizacion = cm.numero_cotizacion
	GROUP BY u.userLogin, u.nombre, u.primerApellido, u.segundoApellido
	ORDER BY monto ASC
);
GO

-- Funcion para obtener las 15 tareas mas antiguas sin cerrar DESC
CREATE FUNCTION tareasAntiguasDESC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 15
		t.codigo,
		t.nombre,
		t.descripcion,
		t.nombre_estado,
		t.usuario_asignado,
		fechaInicio,
		CASE 
			WHEN t.codigo IN (SELECT DISTINCT codigo_tarea FROM TareaXCaso) THEN 'Caso'
			WHEN t.codigo IN (SELECT DISTINCT codigo_tarea FROM TareaXEjecucion) THEN 'Ejecucion'
			WHEN t.codigo IN (SELECT DISTINCT codigo_tarea FROM TareaXCotizacion) THEN 'Cotizacion'
			WHEN t.codigo IN (SELECT DISTINCT codigo_tarea FROM TareaXContactoCliente) THEN 'Contacto Cliente'
			ELSE 'General' 
		END AS tipo,
		DATEDIFF(DAY, fechaInicio, GETDATE()) AS dias
	FROM Tarea AS t
	WHERE t.nombre_estado != 'Finalizado'
	AND t.fechaInicio BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
	ORDER BY dias DESC
);
GO

-- Funcion para obtener las 15 tareas menos antiguas sin cerrar ASC
CREATE FUNCTION tareasAntiguasASC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 15
		t.codigo,
		t.nombre,
		t.descripcion,
		t.nombre_estado,
		t.usuario_asignado,
		fechaInicio,
		CASE 
			WHEN t.codigo IN (SELECT DISTINCT codigo_tarea FROM TareaXCaso) THEN 'Caso'
			WHEN t.codigo IN (SELECT DISTINCT codigo_tarea FROM TareaXEjecucion) THEN 'Ejecucion'
			WHEN t.codigo IN (SELECT DISTINCT codigo_tarea FROM TareaXCotizacion) THEN 'Cotizacion'
			WHEN t.codigo IN (SELECT DISTINCT codigo_tarea FROM TareaXContactoCliente) THEN 'Contacto Cliente'
			ELSE 'General' 
		END AS tipo,
		DATEDIFF(DAY, fechaInicio, GETDATE()) AS dias
	FROM Tarea AS t
	WHERE t.nombre_estado != 'Finalizado'
	AND t.fechaInicio BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
	ORDER BY dias ASC
);
GO

-- Funcion para obtener las 10 cotizaciones con diferencia entre creacion y cierre mas alta DESC
CREATE FUNCTION cotDifDiasDESC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 10
		c.numeroCotizacion,
		cl.codigo,
		cl.nombreCuenta,
		c.nombre_etapa,
		c.nombre_tipo,
		c.zona,
		c.sector,
		c.login_usuario,
		fecha, 
		fechaCierre,
		DATEDIFF(DAY, fecha, fechaCierre) AS dias
	FROM Cotizacion AS c
	JOIN Cliente AS cl ON cl.codigo = c.contacto_clienteCodigo
	JOIN todasCotEnRangoFechas(@Desde, @Hasta) AS tcerf ON tcerf.numeroCotizacion = c.numeroCotizacion
	ORDER BY dias DESC
);
GO

-- Funcion para obtener las 10 cotizaciones con diferencia entre creacion y cierre mas peque�a ASC
CREATE FUNCTION cotDifDiasASC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 10
		c.numeroCotizacion,
		cl.codigo,
		cl.nombreCuenta,
		c.nombre_etapa,
		c.nombre_tipo,
		c.zona,
		c.sector,
		c.login_usuario,
		fecha, 
		fechaCierre,
		DATEDIFF(DAY, fecha, fechaCierre) AS dias
	FROM Cotizacion AS c
	JOIN Cliente AS cl ON cl.codigo = c.contacto_clienteCodigo
	JOIN todasCotEnRangoFechas(@Desde, @Hasta) AS tcerf ON tcerf.numeroCotizacion = c.numeroCotizacion
	ORDER BY dias ASC
);
GO

-- Funcion para obtener las ventas por sector por departamaneto
CREATE FUNCTION ventasSectorDept(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT 
		d.nombre,
		SUM(CASE WHEN c.sector = 'Gobierno' THEN cm.monto ELSE 0 END) AS gobierno,
		SUM(CASE WHEN c.sector = 'Hoteleria' THEN cm.monto ELSE 0 END) AS hoteleria,
		SUM(CASE WHEN c.sector = 'Residencial' THEN cm.monto ELSE 0 END) AS residencial,
		SUM(CASE WHEN c.sector = 'Turismo' THEN cm.monto ELSE 0 END) AS turismo
	FROM CotMontos AS cm
	JOIN ventEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = cm.numero_cotizacion
	JOIN Cotizacion AS c ON c.numeroCotizacion = verf.numeroCotizacion
	JOIN Usuario AS u ON u.userLogin = c.login_usuario
	JOIN Departamento AS d ON d.codigo = u.codigo_departamento
	GROUP BY d.nombre
);
GO

-- Funcion para obtener las ventas por zona por departamaneto
CREATE FUNCTION ventasZonaDept(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT 
		d.nombre,
		SUM(CASE WHEN c.zona = 'Alajuela' THEN cm.monto ELSE 0 END) AS alajuela,
		SUM(CASE WHEN c.zona = 'Cartago' THEN cm.monto ELSE 0 END) AS cartago,
		SUM(CASE WHEN c.zona = 'Guanacaste' THEN cm.monto ELSE 0 END) AS guanacaste,
		SUM(CASE WHEN c.zona = 'Heredia' THEN cm.monto ELSE 0 END) AS heredia,
		SUM(CASE WHEN c.zona = 'Limon' THEN cm.monto ELSE 0 END) AS limon,
		SUM(CASE WHEN c.zona = 'Puntarenas' THEN cm.monto ELSE 0 END) AS puntarenas,
		SUM(CASE WHEN c.zona = 'San Jose' THEN cm.monto ELSE 0 END) AS sj
	FROM CotMontos AS cm
	JOIN ventEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = cm.numero_cotizacion
	JOIN Cotizacion AS c ON c.numeroCotizacion = verf.numeroCotizacion
	JOIN Usuario AS u ON u.userLogin = c.login_usuario
	JOIN Departamento AS d ON d.codigo = u.codigo_departamento
	GROUP BY d.nombre
);
GO

-- Funcion para obtener las tareas por usuario DESC
CREATE FUNCTION tareasPorUsuarioDESC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 1000
		u.userLogin,
		u.nombre,
		u.primerApellido,
		u.segundoApellido,
		--COUNT(DISTINCT t.codigo) AS tareas
		SUM(CASE WHEN t.nombre_estado = 'Inicio' THEN 1 ELSE 0 END) AS iniciadas,
		SUM(CASE WHEN t.nombre_estado = 'En Progreso' THEN 1 ELSE 0 END) AS enProgreso,
		SUM(CASE WHEN t.nombre_estado = 'Finalizado' THEN 1 ELSE 0 END) AS finalizadas,
		COUNT(t.codigo) AS total
	FROM Usuario AS u
	JOIN Tarea AS t ON t.usuario_asignado = u.userLogin
	JOIN tareasEnRangoFechas(@Desde, @Hasta) AS terf ON terf.codigo = t.codigo
	GROUP BY u.userLogin, u.nombre, u.primerApellido, u.segundoApellido
	ORDER BY total DESC
);
GO

-- Funcion para obtener las tareas por usuario ASC
CREATE FUNCTION tareasPorUsuarioASC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 1000
		u.userLogin,
		u.nombre,
		u.primerApellido,
		u.segundoApellido,
		--COUNT(DISTINCT t.codigo) AS tareas
		SUM(CASE WHEN t.nombre_estado = 'Inicio' THEN 1 ELSE 0 END) AS iniciadas,
		SUM(CASE WHEN t.nombre_estado = 'En Progreso' THEN 1 ELSE 0 END) AS enProgreso,
		SUM(CASE WHEN t.nombre_estado = 'Finalizado' THEN 1 ELSE 0 END) AS finalizadas,
		COUNT(t.codigo) AS total
	FROM Usuario AS u
	JOIN Tarea AS t ON t.usuario_asignado = u.userLogin
	JOIN tareasEnRangoFechas(@Desde, @Hasta) AS terf ON terf.codigo = t.codigo
	GROUP BY u.userLogin, u.nombre, u.primerApellido, u.segundoApellido
	ORDER BY total ASC
);
GO

-- Funcion para obtener las ejecuciones por usuario DESC
CREATE FUNCTION ejecPorUsuarioDESC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 1000
		u.userLogin,
		u.nombre,
		u.primerApellido,
		u.segundoApellido,
		COUNT(DISTINCT e.codigo) AS ejecuciones
	FROM Usuario AS u
	JOIN Ejecucion AS e ON e.userLogin = u.userLogin
	JOIN ejecucionEnRangoFechas(@Desde, @Hasta) AS eerf ON eerf.codigo = e.codigo
	GROUP BY u.userLogin, u.nombre, u.primerApellido, u.segundoApellido
	ORDER BY ejecuciones DESC
);
GO

-- Funcion para obtener las ejecuciones por usuario ASC
CREATE FUNCTION ejecPorUsuarioASC(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 1000
		u.userLogin,
		u.nombre,
		u.primerApellido,
		u.segundoApellido,
		COUNT(DISTINCT e.codigo) AS ejecuciones
	FROM Usuario AS u
	JOIN Ejecucion AS e ON e.userLogin = u.userLogin
	JOIN ejecucionEnRangoFechas(@Desde, @Hasta) AS eerf ON eerf.codigo = e.codigo
	GROUP BY u.userLogin, u.nombre, u.primerApellido, u.segundoApellido
	ORDER BY ejecuciones ASC
);
GO

CREATE FUNCTION cantidad_clientes_monto_x_zona(@Desde varchar(10), @Hasta varchar(10), @zona varchar(12))
RETURNS TABLE
AS
RETURN
(
	SELECT  ct.zona AS Zona, COUNT(ct.contacto_clienteCodigo) AS Clientes, (SELECT CAST(SUM(p.precioEstandar) AS INT) FROM Cotizacion c JOIN ProductoXCotizacion pxc ON c.numeroCotizacion = pxc.numero_cotizacion JOIN Producto p ON pxc.codigo_producto = p.codigo WHERE nombre_etapa = 'Facturada' AND c.zona = @zona) AS Monto
	FROM Cotizacion ct
	LEFT JOIN Cliente c ON ct.contacto_clienteCodigo = c.codigo
		LEFT JOIN ventEnRangoFechas(@Desde, @Hasta) AS verf ON verf.numeroCotizacion = ct.numeroCotizacion
	WHERE ct.zona = @zona
	GROUP BY ct.zona
);
GO

-- Funcion que muestra el top 10 de las cotizaciones con mas tareas y actividades
CREATE FUNCTION top_10_cotizaciones_con_tareas_actividades(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS 
RETURN (
SELECT TOP 10 c.numeroCotizacion, COUNT(ct.codigo_tarea) AS Tareas, COUNT(ca.codigo_actividad) AS Actividades, (COUNT(ct.codigo_tarea) + COUNT(ca.codigo_actividad)) AS Total
FROM Cotizacion c 
	LEFT JOIN TareaXCotizacion ct ON ct.numero_cotizacion = c.numeroCotizacion
			LEFT JOIN ActividadXCotizacion ca ON ct.numero_cotizacion = ca.numero_cotizacion
WHERE c.fecha BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
GROUP BY c.numeroCotizacion
ORDER BY Total DESC
);
GO

-- Funcion que muestra las ventas y cotizaciones, falta aplicarle lo del valor presente
	--PENDIENTE

--Muestra las ejecuciones por mes anno (debes enviarle como parametro una fecha)
CREATE FUNCTION cantidad_ejecuciones_mes_anno(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS 
RETURN
(
	SELECT COUNT(codigo) AS Ejecuciones
	FROM Ejecucion e
	WHERE e.fechaCierre BETWEEN CONVERT(DATETIME, @Desde, 101) AND CONVERT(DATETIME, @Hasta, 101)
);
GO

-- Funcion para seleccionar cantidad de ventas y cotizaciones por mes por a�o
--ALTER PROCEDURE cotVentasMesAnnoMonto_valorpresente(@Desde varchar(10), @Hasta varchar(10))
--AS
--DECLARE @anno VARCHAR(15),
--		@inflacion DECIMAL(3,2),
--		@ventaxinflacion INT,
--		@cotizacionxinflacion INT,
--		@counter INT = 1,
--		@max INT = 0
--BEGIN
--	BEGIN TRY
--		CREATE TABLE #TEMP (
--			id INT IDENTITY(1,1),
--			annoMes VARCHAR(15),
--			ventas DECIMAL(9,2),
--			cotizaciones DECIMAL(9,2)
--		);
--		INSERT INTO #TEMP SELECT * FROM cotVentasMesAnnoMonto(@Desde, @Hasta)

--		WHILE @counter <= @max
--			BEGIN
--				SET @anno = (SELECT SUBSTRING(annoMes, 1, 4) FROM #TEMP WHERE id = @counter);
--				SET @inflacion = (SELECT porcentaje FROM Inflacion WHERE anno = @anno);
--				SET @ventaxinflacion = (SELECT ventas * @inflacion FROM #TEMP WHERE id = @counter);
--				SET @cotizacionxinflacion = (SELECT cotizaciones * @inflacion FROM #TEMP WHERE id = @counter);
--				IF EXISTS (SELECT * FROM #TEMP2)
--					BEGIN
--						INSERT INTO #TEMP2 VALUES (@anno, @ventaxinflacion, @cotizacionxinflacion)
--					END
--				ELSE
--					BEGIN
--						CREATE TABLE #TEMP2 (
--							anno VARCHAR(15),
--							ventaxinflacion INT,
--							cotizacionxinflacion INT
--						)
--						INSERT INTO #TEMP2 VALUES (@anno, @ventaxinflacion, @cotizacionxinflacion)
--					END
--			SET @counter = @counter + 1
--			END
--		DROP TABLE #TEMP
--		SELECT * FROM #TEMP2
--	END TRY
--	BEGIN CATCH
--		PRINT 'ERROR'
--	END CATCH
--END

--EXEC cotVentasMesAnnoMonto_valorpresente @Desde = '2018-11-11', @Hasta = '2022-11-11'

--DROP TABLE #TEMP
--SELECT * FROM #TEMP

-- Funcion para obtener las ventas y cotizaciones en valor presente
CREATE FUNCTION cotVentasMesAnnoMontoPresente(@Desde varchar(10), @Hasta varchar(10))
RETURNS TABLE
AS
RETURN
(
	SELECT
	cam.annoMes,
	SUM(CASE 
			WHEN dbo.multiploValorActual(anno_inflacion) IS NULL AND c.nombre_etapa = 'Facturada' THEN cm.monto * 1 
			WHEN dbo.multiploValorActual(anno_inflacion) IS NOT NULL AND c.nombre_etapa = 'Facturada' THEN cm.monto * dbo.multiploValorActual(anno_inflacion)
			ELSE 0
		END) AS ventas,
	SUM(CASE 
			WHEN dbo.multiploValorActual(anno_inflacion) IS NULL AND c.nombre_etapa != 'Facturada' THEN cm.monto * 1 
			WHEN dbo.multiploValorActual(anno_inflacion) IS NOT NULL AND c.nombre_etapa != 'Facturada' THEN cm.monto * dbo.multiploValorActual(anno_inflacion)
			ELSE 0
		END) cotizaciones
	FROM CotAnnoMes AS cam
	JOIN Cotizacion AS c ON c.fecha = cam.fecha
	JOIN todasCotEnRangoFechas(@Desde, @Hasta) AS tcerf ON tcerf.numeroCotizacion = c.numeroCotizacion
	JOIN CotMontos AS cm ON cm.numero_cotizacion = tcerf.numeroCotizacion
	GROUP BY cam.annoMes
);
GO
