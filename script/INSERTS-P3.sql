USE sistemacrm;
GO

DECLARE @maxElement AS int,
@randomNombre AS int,
@randomApellido1 AS int,
@randomApellido2 AS int,
@nombre AS varchar(12),
@apellido1 AS varchar(12),
@apellido2 AS varchar(12),
@fecha1 AS date,
@fecha2 AS date,
@cliente AS varchar(10),
@codCliente AS varchar(10);

-- FamiliaProducto
SET @maxElement = 100;
WHILE @maxElement < 201
BEGIN
	INSERT INTO FamiliaProducto VALUES (
	'FAMCOD' + CAST(@maxElement AS varchar(3)),
	'Familia ' + CAST(@maxElement AS varchar(3)),
	ROUND(RAND()*1,2),
	'Desc Familia de producto: ' + CAST(@maxElement AS varchar(3))
	)

	SET @maxElement = @maxElement + 1;
END;

-- Producto
SET @maxElement = 100;
WHILE @maxElement < 351
BEGIN
	BEGIN TRY
		
		INSERT INTO Producto VALUES
		(
		'PRODCOD' + CAST(@maxElement AS varchar(3)),
		'Producto ' + CAST(@maxElement AS varchar(3)),
		ROUND(RAND()*1,2),
		'Desc del producto: PRODCOD' + CAST(@maxElement AS varchar(3)),
		ROUND(RAND()*71000,2),
		(SELECT TOP 1 codigo FROM FamiliaProducto ORDER BY NEWID())
		)

	END TRY
	BEGIN CATCH
	END CATCH
	
	SET @maxElement = @maxElement + 1;
END;

-- Usuario
SET @maxElement = 160;
WHILE @maxElement < 201
BEGIN
	BEGIN TRY

		-- random de 1 a 7
		SET @randomNombre = ROUND(RAND() * 6,0) + 1
		SET @randomApellido1 = ROUND(RAND() * 6,0) + 1
		SET @randomApellido2 = ROUND(RAND() * 6,0) + 1
		SELECT @nombre = CHOOSE(@randomNombre, 'Axel', 'Pablo', 'Ana', 'Devin', 'Oscar', 'Lucia', 'Max')
		SELECT @apellido1 = CHOOSE(@randomApellido1, 'Rojas', 'Gonzalez', 'Rios', 'Salaz', 'Gomez', 'Rodriguez', 'Azofeifa')
		SELECT @apellido2 = CHOOSE(@randomApellido2, 'Abarca', 'Aguilera', 'Ramoz', 'Alpizar', 'Saenz', 'Scott', 'Guerra')
		
		INSERT INTO Usuario VALUES
		(
		'LOG' + CAST(@maxElement AS varchar(3)),
		'116590' + CAST(@maxElement AS varchar(3)),
		@nombre,
		@apellido1,
		@apellido2,
		'PassW' + CAST(@maxElement AS varchar(3)),
		(SELECT TOP 1 nombre FROM Rol ORDER BY NEWID()),
		(SELECT TOP 1 codigo FROM Departamento ORDER BY NEWID())
		)

	END TRY
	BEGIN CATCH
	END CATCH
	
	SET @maxElement = @maxElement + 1;
END;

-- Cliente
SET @maxElement = 100;
WHILE @maxElement < 401
BEGIN
	BEGIN TRY

		INSERT INTO Cliente VALUES (
		'CLICOD' + CAST(@maxElement AS varchar(3)),
		'Cuenta ' + CAST(@maxElement AS varchar(3)),
		'cli' + CAST(@maxElement AS varchar(3)) + '@ejemplo.com',
		'22222' + CAST(@maxElement AS varchar(3)),
		'88888' + CAST(@maxElement AS varchar(3)),
		'cliente-' + CAST(@maxElement AS varchar(3)) + '.com',
		'Informacion de: CLICOD' + CAST(@maxElement AS varchar(3)),
		(SELECT TOP 1 nombre FROM Zona ORDER BY NEWID()),
		(SELECT TOP 1 nombre FROM Sector ORDER BY NEWID()),
		(SELECT TOP 1 abreviatura FROM Moneda ORDER BY NEWID()),
		(SELECT TOP 1 nombre FROM Moneda ORDER BY NEWID()),
		(SELECT TOP 1 userLogin FROM Usuario ORDER BY NEWID())
		)

	END TRY
	BEGIN CATCH
	END CATCH

	SET @maxElement = @maxElement + 1;
END;

-- ContactoCliente
SET @maxElement = 100;
WHILE @maxElement < 601
BEGIN
	BEGIN TRY

	SET @cliente = (SELECT TOP 1 codigo FROM Cliente ORDER BY NEWID());

		INSERT INTO ContactoCliente VALUES (
		@cliente,
		'Motivo ' + CAST(@maxElement AS varchar(3)),
		'Persona ' + CAST(@maxElement AS varchar(3)),
		(SELECT correo FROM Cliente WHERE codigo = @cliente),
		(SELECT telefono FROM Cliente WHERE codigo = @cliente),
		'Direccion: ' + CAST(@maxElement AS varchar(3)),
		'Descripcion: ' + CAST(@maxElement AS varchar(3)),
		(SELECT sector FROM Cliente WHERE codigo = @cliente),
		'CC',
		(SELECT TOP 1 nombre FROM Estado WHERE categoria = 'CC' ORDER BY NEWID()),
		(SELECT zona FROM Cliente WHERE codigo = @cliente),
		'CC',
		(SELECT TOP 1 nombre FROM Tipo WHERE categoria = 'CC' ORDER BY NEWID()),
		(SELECT TOP 1 userLogin FROM Usuario ORDER BY NEWID())
		)

	END TRY
	BEGIN CATCH
	END CATCH

	SET @maxElement = @maxElement + 1;
END;

-- Caso
SET @maxElement = 100;
WHILE @maxElement < 251
BEGIN
	BEGIN TRY

		INSERT INTO Caso VALUES (
		'CASOCOD' + CAST(@maxElement AS varchar(3)),
		(SELECT TOP 1 nombre FROM Origen ORDER BY NEWID()),
		'Asunto ' + CAST(@maxElement AS varchar(3)),
		'Direccion: ' + CAST(@maxElement AS varchar(3)),
		'Descripcion: ' + CAST(@maxElement AS varchar(3)),
		'Caso',
		(SELECT TOP 1 nombre FROM Tipo WHERE categoria = 'Caso' ORDER BY NEWID()), -- Tipo
		(SELECT TOP 1 tipo FROM Prioridad ORDER BY NEWID()),
		'Caso',
		(SELECT TOP 1 nombre FROM Estado WHERE categoria = 'Caso' ORDER BY NEWID()) -- Estado
		)

	END TRY
	BEGIN CATCH
	END CATCH

	SET @maxElement = @maxElement + 1;
END;

-- Proyecto
SET @maxElement = 180;
WHILE @maxElement < 201
BEGIN
	INSERT INTO Proyecto VALUES (
	'FPROCOD' + CAST(@maxElement AS varchar(3))
	)

	SET @maxElement = @maxElement + 1;
END;

-- Ejecucion
SET @maxElement = 100;
WHILE @maxElement < 251
BEGIN
	BEGIN TRY

		INSERT INTO Ejecucion VALUES (
		'CASOCOD' + CAST(@maxElement AS varchar(3)),
		'Ejec ' + CAST(@maxElement AS varchar(3)),
		(SELECT DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 30)*-1, GETDATE())), -- crea una fecha random
		(SELECT TOP 1 codigo FROM Proyecto ORDER BY NEWID()),
		(SELECT TOP 1 codigo FROM Departamento ORDER BY NEWID())
		)

	END TRY
	BEGIN CATCH
	END CATCH

	SET @maxElement = @maxElement + 1;
END;

-- Compra
SET @maxElement = 100;
WHILE @maxElement < 551
BEGIN
	INSERT INTO Compra VALUES (
	@maxElement,
	'Detalles de la orden de compra: #' + CAST(@maxElement AS varchar(3))
	)

	SET @maxElement = @maxElement + 1;
END;

-- Competencia
SET @maxElement = 180;
WHILE @maxElement < 201
BEGIN
	INSERT INTO Competencia VALUES (
	'Empresa ' + CAST(@maxElement AS varchar(3))
	)

	SET @maxElement = @maxElement + 1;
END;

-- Factura
SET @maxElement = 100;
WHILE @maxElement < 301
BEGIN
	INSERT INTO Factura VALUES (
	@maxElement,
	'Detalles de la factura: #' + CAST(@maxElement AS varchar(3))
	)

	SET @maxElement = @maxElement + 1;
END;

-- Cotizacion
SET @maxElement = 100;
WHILE @maxElement < 1000
BEGIN
	BEGIN TRY

		SET @fecha1 = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 30)*-1, GETDATE());
		SET @fecha2 = DATEADD(DAY, 20, @fecha1);

		SET @codCliente = (SELECT TOP 1 codigoCliente FROM ContactoCliente ORDER BY NEWID());

		INSERT INTO Cotizacion VALUES (
		@maxElement,
		'Oport ' + CAST(@maxElement AS varchar(3)),
		(SELECT @fecha1), -- fecha
		(SELECT CAST(DATEPART(MONTH, @fecha2) AS varchar(2)) + '-' + CAST(DATEPART(YEAR, @fecha2) AS varchar(4))), -- toma el mes y año de fecha random
		@fecha2, -- fecha cierre
		ROUND(RAND()*100,2), -- probabilidad
		'Describcion de Cotizacion: ' + CAST(@maxElement AS varchar(3)),
		'Nego ' + CAST(@maxElement AS varchar(3)),
		(SELECT TOP 1 nombre FROM Competencia ORDER BY NEWID()),
		(SELECT TOP 1 ordenCompra FROM Compra ORDER BY NEWID()),
		(SELECT TOP 1 numeroFactura FROM Factura ORDER BY NEWID()),
		(SELECT TOP 1 nombre FROM Etapa ORDER BY NEWID()),
		'Cotizacion',
		(SELECT TOP 1 nombre FROM Tipo WHERE categoria = 'Cotizacion' ORDER BY NEWID()), -- Tipo
		(SELECT TOP 1 codigo FROM Ejecucion ORDER BY NEWID()),
		(SELECT zona FROM Cliente WHERE codigo = @codCliente),
		(SELECT sector FROM Cliente WHERE codigo = @codCliente),
		(SELECT TOP 1 anno FROM Inflacion ORDER BY NEWID()),
		(SELECT TOP 1 codigo FROM Caso ORDER BY NEWID()),
		(SELECT TOP 1 userLogin FROM Usuario ORDER BY NEWID()),
		(@codCliente),
		(SELECT TOP 1 motivo FROM ContactoCliente WHERE codigoCliente = @codCliente ORDER BY NEWID())
		)

	END TRY
	BEGIN CATCH
	END CATCH

	SET @maxElement = @maxElement + 1;
END;

-- ProductoXCotizacion
SET @maxElement = 100;
WHILE @maxElement < 2101
BEGIN
	BEGIN TRY

		INSERT INTO ProductoXCotizacion VALUES (
		(SELECT TOP 1 codigo FROM Producto ORDER BY NEWID()),
		(SELECT TOP 1 numeroCotizacion FROM Cotizacion ORDER BY NEWID())
		)

	END TRY
	BEGIN CATCH
	END CATCH

	SET @maxElement = @maxElement + 1;
END;