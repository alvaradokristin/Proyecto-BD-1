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

-- Se usa por cotizacion
CREATE TABLE Tipo (
	categoria varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL
)

CREATE TABLE Zona (
	nombre varchar(12) NOT NULL PRIMARY KEY
)

CREATE TABLE Sector (
	nombre varchar(12) NOT NULL PRIMARY KEY
)

CREATE TABLE Inflacion (
	anno date NOT NULL PRIMARY KEY,
	porcentaje decimal(3,2) NOT NULL,
)



CREATE TABLE Estado (
	categoria varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL
)



CREATE TABLE Moneda (
	disminutico varchar(4) NOT NULL,
	nombre varchar(12) NOT NULL
	PRIMARY KEY (disminutico, nombre)
)

CREATE TABLE Prioridad (
	tipo varchar(3) NOT NULL PRIMARY KEY -- P0, P1, ...
)

CREATE TABLE Actividad (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	descripcion varchar(30) NOT NULL
	-- Tipo
	-- Usuario asignado
	-- Tareas ?
	-- Estado
)

CREATE TABLE Proyecto (
	codigo varchar(10) NOT NULL PRIMARY KEY
	-- Actividad
	-- Cotizacion
)

-- #--------------------------------#
-- #        CREAR LAS TABLAS        #
-- #--------------------------------#

CREATE TABLE Usuario (
	userLogin varchar(10) NOT NULL PRIMARY KEY,
	cedula varchar(10) NOT NULL,
	nombre varchar(12) NOT NULL,
	primerApellido varchar(12) NOT NULL,
	segundoApellido varchar(12) NOT NULL,
	clave varchar(13) NOT NULL,
	-- Departamento
)

CREATE TABLE Departamento (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL
)

CREATE TABLE FamiliaProducto (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	activo bit NOT NULL, -- 1 si esta activo 0 si no
	descripcion varchar(30) NOT NULL
)

CREATE TABLE Producto (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	activo bit NOT NULL,
	descripcion varchar(30) NOT NULL,
	precioEstandar decimal(9,2)
	-- Familia
)

CREATE TABLE Cliente (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombreCuenta varchar(12) NOT NULL,
	correo varchar(20) NOT NULL,
	telefono varchar(10) NOT NULL,
	celular varchar(10) NOT NULL,
	sitioWeb varchar(22) NOT NULL,
	informacionAdicional varchar(30) NOT NULL,
	zona varchar(12) NOT NULL,
	sector varchar(12) NOT NULL
	-- Contacto principal
	-- Moneda
	-- Asesor
)

CREATE TABLE ContactoCliente (
	codigoCliente varchar(10) NOT NULL PRIMARY KEY,
	motivo varchar(15) NOT NULL,
	nombreContacto varchar(12) NOT NULL,
	correo varchar(20) NOT NULL,
	telefono varchar(10) NOT NULL,
	direccion varchar(35) NOT NULL,
	descripcion varchar(30) NOT NULL,
	FOREIGN KEY (codigoCliente) REFERENCES Cliente(codigo)
	-- Tipo de contacto
	-- Estado de contacto
	-- Sector
	-- Zona
	-- Asesor
)

CREATE TABLE Tarea (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	descripcion varchar(30) NOT NULL,
	fechaFinalizacion date -- puede ser null?
	-- Estado
	-- Usuario asignado
)

CREATE TABLE Cotizacion (
	numeroCotizacion smallint NOT NULL PRIMARY KEY,
	nombreOportunidad varchar(12) NOT NULL,
	fecha date NOT NULL,
	mesAnnoCierre varchar(5) NOT NULL,
	fechaCierre date NOT NULL,
	probabilidad decimal(3,2) NOT NULL,
	descripcion varchar(30) NOT NULL,
	seNego varchar(15) NOT NULL,
	contraQuien varchar(15) NOT NULL
	-- Nombre de cuenta
	-- Asesor
	-- Etapa
	-- Moneda de oportunidad
	-- Orden de compra
	-- Tipo
	-- Zona
	-- Sector
	-- Numero de contacto asociado
)

CREATE TABLE Ejecucion (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	nombre varchar(12) NOT NULL,
	fecha date
	-- Departamento
	-- Numero cotizacion
	-- Propietario de ejecucion
	-- Nombre de la cuenta
	-- Mes Anno proyectado de cierre
	-- Asesor
	-- Fecha de cierre
)

CREATE TABLE Caso (
	codigo varchar(10) NOT NULL PRIMARY KEY,
	origen varchar(12) NOT NULL,
	asunto varchar(10) NOT NULL,
	direccion varchar(35) NOT NULL,
	descripcion varchar(30) NOT NULL
	-- Propietario
	-- Nombre de cuenta
	-- Nombre de contacto
	-- Nombre de proyecto asociado
	-- Estado
	-- Tipo de caso
	-- Prioridad
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