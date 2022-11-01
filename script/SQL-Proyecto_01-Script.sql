-- Script para el proyecto #2 de Bases de Datos I

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
	ordenCompra smallint, -- -1 si no se ha hecho la compra todavia
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

INSERT INTO FamiliaProducto (codigo, nombre, activo, descripcion)
VALUES 
('FMPR0001', 'FamiliaP 01', 1, 'Primera familia de producto');

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
('CC', 'Tipo1'),
('CC', 'Tipo2'),
('CC', 'Tipo3'),
('Actividad', 'Tipo1'),
('Actividad', 'Tipo2'),
('Actividad', 'Tipo3'),
('Cotizacion', 'Tipo1'),
('Cotizacion', 'Tipo2'),
('Cotizacion', 'Tipo3'),
('Caso', 'Tipo1'),
('Caso', 'Tipo2'),
('Caso', 'Tipo3');

INSERT INTO Etapa (nombre)
VALUES
('Cotizacion'),
('Negociacion'),
('Pausa'),
('Finalizado');

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

-- Agregar valor a Compra para usar en Caso
-- Es un valor especifico para usar en cotizaciones que todavia no se acepta la compra
INSERT INTO Compra (ordenCompra, detalle)
VALUES
(-1, 'Placeholder para compras no realizadas todavia');
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
	@ProCodigoFamilia varchar(10),
	@Return int OUTPUT
AS
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
	@CCCategoriaEstado varchar(10),
	@CCNombreEstado varchar(12),
	@CCZona varchar(12),
	@CCCategoriaTipo varchar(10),
	@CCNombreTipo varchar(12),
	@CCAsesor varchar(10),
	@Return int OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO ContactoCliente VALUES 
		(@CCCodigoCliente, @CCMotivo, @CCNombreContacto, @CCCorreo, @CCTelefono, 
		@CCDireccion, @CCDescripcion, @CCSector, @CCCategoriaEstado, @CCNombreEstado, 
		@CCZona, @CCCategoriaTipo, @CCNombreTipo, @CCAsesor)
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
	@EjeCodigoDept varchar(10),
	@Return int OUTPUT
AS
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
	@CasoEstado varchar(12),
	@Return int OUTPUT
AS
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
	@Return int OUTPUT
AS
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

DECLARE @return AS int;
EXEC insertarProducto 'PROD001', 'Producto 01', 1, 'Primer producto', 5500, 'FMPR0001', @return OUTPUT;
SELECT @return AS retOutputProd;

SELECT * FROM Producto
GO

DECLARE @return AS int;
EXEC insertarContactoCliente 'C01', 'Acercamiento', 'Aivy', 'asd@asd.com', '88888888', 'Sabana, San Jose', 'Primer acercamiento', 'Tres Rios', 'CC', 'Inicio', 'San Jose', 'CC', 'Tipo1', 'amr', @return OUTPUT;
SELECT @return AS retOutputCC;

SELECT * FROM ContactoCliente;
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

-- Funcion para seleccionar los productos mas vendidos
CREATE FUNCTION masVendidosProductos()
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 10
	p.codigo,
	p.nombre,
	p.activo,
	p.descripcion,
	p.precioEstandar,
	p.codigo_familia,
	c.ordenCompra,
	COUNT(DISTINCT pxc.numero_cotizacion) AS ventas
	FROM Producto AS p
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN Cotizacion AS c ON c.numeroCotizacion = pxc.numero_cotizacion
	GROUP BY p.codigo, p.nombre, p.activo, p.descripcion, p.precioEstandar, p.codigo_familia, c.ordenCompra
	HAVING c.ordenCompra != -1 -- si se efectuo la venta
	ORDER BY ventas DESC
);
GO

-- Funcion para seleccionar las familias de productos mas vendidos
CREATE FUNCTION masVendidosFamProductos()
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 10
	fp.codigo,
	fp.nombre,
	fp.activo,
	fp.descripcion,
	c.ordenCompra,
	COUNT(DISTINCT pxc.numero_cotizacion) AS ventas
	FROM FamiliaProducto AS fp
	JOIN Producto AS p ON p.codigo_familia = fp.codigo
	JOIN ProductoXCotizacion AS pxc ON pxc.codigo_producto = p.codigo
	JOIN Cotizacion AS c ON c.numeroCotizacion = pxc.numero_cotizacion
	GROUP BY fp.codigo, fp.nombre, fp.activo, fp.descripcion, c.ordenCompra
	HAVING c.ordenCompra != -1 -- si se efectuo la venta
	ORDER BY ventas DESC
);
GO

-- Funcion para seleccionar los productos mas cotizados
CREATE FUNCTION masCotizadosProductos()
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 10
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
	SELECT TOP 10
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

SELECT * FROM Cliente
