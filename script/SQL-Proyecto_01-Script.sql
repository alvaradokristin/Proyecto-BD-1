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
		('Heredia');

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


INSERT INTO Ejecucion (codigo, nombre, fecha, codigo_proyecto, codigo_departamento)
VALUES	('E001', 'Ejecucion1', '2022-10-10', 'P003', 'DP02'),
		('E002', 'Ejecucion2', '2021-11-11', 'P002', 'DP03');

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

INSERT INTO Cotizacion (numeroCotizacion, nombreOportunidad, fecha, mesAnnoCierre, fechaCierre, 
probabilidad, descripcion, seNego, nombre_competencia, ordenCompra, numero_factura, nombre_etapa, 
categoria_tipo, nombre_tipo, codigo_ejecucion, zona, sector, anno_inflacion, codigo_caso, login_usuario)
VALUES	(01, 'oport01', '2019-8-8', '09-2022', '2023-8-8', 20.3, 'descrip1', 'si', 'Compet1', 01, 001, 'Negociacion', 'Cotizacion', 'Tipo 1', 'E001',
		'Cartago', 'Turismo', '2019', 'C001', 'amr'),
		(02, 'oport02', '2020-9-9', '08-2022', '2024-9-9', 30.3, 'descrip2', 'si', 'Compet2', 02, 002, 'Cotizacion', 'Cotizacion', 'Tipo 2', 'E002',
		'Heredia', 'Gobierno', '2020', 'C002', 'amr'),
		(03, 'oport03', '2021-10-10', '10-2022', '2025-10-10', 40.3, 'descrip3', 'no', 'Compet3', 04, 001, 'Facturada', 'Cotizacion', 'Tipo 3', 'E001',
		'San Jose', 'Residencial', '2021', 'C001', 'jsm'),
		(04, 'oport04', '2018-11-11', '11-2022', '2016-11-11', 60.3, 'descrip4', 'no', 'Compet2', 03, 002 , 'Pausa', 'Cotizacion', 'Tipo 1', 'E002',
		'Heredia', 'Hoteleria', '2022', 'C002', 'jsm');
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
		(@CCCodigoCliente, @CCMotivo, @CCNombreContacto, @CCCorreo, @CCTelefono, 
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
	@EjeCodigoProyecto varchar(10),
	@EjeCodigoDept varchar(10)
AS
DECLARE @Return int
BEGIN
	BEGIN TRY
		INSERT INTO Ejecucion VALUES 
		(@EjeCodigo, @EjeNombre, @EjeFecha, @EjeCodigoProyecto, @EjeCodigoDept)
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
	@CotUsuario varchar(10) -- asesor
AS
DECLARE @Return int
BEGIN
	BEGIN TRY
		INSERT INTO Factura VALUES (@CotNumeroFactura, @FactDetalle)
		INSERT INTO Cotizacion VALUES 
		(@CotNumero, @CotNombreOportunidad, @CotFecha, @CotMesAnnoCierre, @CotFechaCierre, 
		@CotProbabilidad, @CotDescripcion, @CotSeNego, @CotNombreCompetencia, -1, @CotNumeroFactura, 
		@CotEtapa, 'Cotizacion', @CotTipo, @CotCodigoEjecucion, @CotZona, @CotSector,
		@CotAnnoInflacion, @CotCaso, @CotUsuario)
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

EXEC insertarContactoCliente 'C01', 'Acercamiento', 'Aivy', 'asd@asd.com', '88888888', 'Sabana, San Jose', 'Primer acercamiento', 'Tres Rios', 'Inicio', 'San Jose', 'Tipo1', 'amr';
GO

-- #------------------------------#
-- #          FUNCIONES           #
-- #------------------------------#
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

-- Vista para tomar las cotizaciones con compras
CREATE VIEW CotizacionesCompra AS (
	SELECT DISTINCT
		pxc.codigo_producto
	FROM ProductoXCotizacion AS pxc
	JOIN Cotizacion AS c ON c.numeroCotizacion = pxc.numero_cotizacion
	WHERE c.nombre_etapa = 'Facturada' -- si se efectuo la venta
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
	COUNT(DISTINCT pxc.numero_cotizacion) AS ventas
	FROM Producto AS p
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	GROUP BY p.codigo, p.nombre, p.activo, p.descripcion, p.precioEstandar, p.codigo_familia
	HAVING p.codigo IN (SELECT * FROM CotizacionesCompra) -- si se efectuo la venta
	ORDER BY ventas DESC
);
GO

-- Funcion para seleccionar las cotizaciones y ventas por departamento
CREATE FUNCTION cotVentaXDepartamento()
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
	GROUP BY d.codigo, d.nombre
);
GO

------------------------ FIX ---------------------------
--------------------------------------------------------
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
CREATE FUNCTION ventasFamProductos()
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT
	fp.codigo,
	fp.nombre,
	COUNT(DISTINCT pxc.numero_cotizacion) AS ventas
	FROM FamiliaProducto AS fp
	JOIN Producto AS p ON p.codigo_familia = fp.codigo
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN CotizacionesCompra AS cc ON cc.codigo_producto = pxc.codigo_producto
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
	COUNT(DISTINCT pxc.numero_cotizacion) AS cotizaciones
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
END

GO
CREATE PROCEDURE sp_getClientsBySector @param_sector VARCHAR(12)
AS 
BEGIN
	SELECT * FROM Cliente
	WHERE sector = @param_sector
END

GO
CREATE PROCEDURE sp_getClientsByZone @param_zona VARCHAR(12)
AS 
BEGIN
	SELECT * FROM Cliente
	WHERE zona = @param_zona
END
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
END


SELECT * FROM cotVentaXDepartamento()