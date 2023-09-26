CREATE DATABASE [Renta_Video]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Renta_Video', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Renta_Video.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Renta_Video_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Renta_Video_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 WITH LEDGER = OFF
GO
USE [Renta_Video]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [Renta_Video] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO
-- DROP DATABASE [Renta_Video];

-- Tabla de Clientes
CREATE TABLE [dbo].[Clientes] (
	Nombres VARCHAR (100) NOT NULL,
	Apellidos VARCHAR (100) NOT NULL,
	DUI VARCHAR(12) PRIMARY KEY,
	Fecha_Afiliacion DATE NOT NULL,
	Edad INT NOT NULL,
);
GO
SELECT * FROM [dbo].[Clientes];
GO
-- UPDATE [dbo].[Clientes] SET DUI = '00900082-9' WHERE DUI = '0090082-9';

-- DROP TABLE [dbo].[Rentas];
CREATE TABLE [dbo].[Rentas] (
	CodR VARCHAR(6) PRIMARY KEY,
	CodP VARCHAR(6) NOT NULL,
	DUI VARCHAR(12) NOT NULL,
	Fecha_Registro DATE,
	Fecha_Devolucion DATE,
	Cobro FLOAT,
	Mora FLOAT
);
GO
SELECT * FROM [dbo].[Rentas];
GO

-- Tabla de Películas
CREATE TABLE [dbo].[Peliculas] (
	CodP VARCHAR (6) PRIMARY KEY,
	Nombre VARCHAR (100) NOT NULL,
	CodT VARCHAR (6) NOT NULL,
	CodC VARCHAR (6) NOT NULL,
	Fecha_Ingreso DATE NOT NULL,
	Disponible INT NOT NULL
);
GO
SELECT * FROM [dbo].[Peliculas];
GO

-- Tabla de Categorías
CREATE TABLE [dbo].[Categorias] (
	CodC VARCHAR(6) PRIMARY KEY,
	Categorias VARCHAR (100) NOT NULL
);
GO
SELECT * FROM [dbo].[Categorias]
GO

-- Tabla para tipos de película
CREATE TABLE [dbo].[Tipos] (
	CodT VARCHAR (6) PRIMARY KEY,
	Nombre_Tipo VARCHAR (30) NOT NULL
);
GO
SELECT * FROM [dbo].[Tipos];
GO

-- --------------------------- Trigger para actualizar los ID de las tablas --------------------------- 
CREATE TRIGGER FormatoRenta
ON [dbo].[Rentas]
AFTER INSERT 
AS 
BEGIN
	DECLARE @NewID VARCHAR(6);

	SELECT @NewID = 'C' + RIGHT('000' + CAST(RIGHT(CodR, 3) AS VARCHAR(3)),3)
	FROM inserted;

	UPDATE [dbo].[Rentas]
	SET CodR = @NewID 
	WHERE CodR = (SELECT CodR FROM inserted);
END
GO
-- --------------------------- Trigger para actualizar los ID de la tabla de Películas --------------------------- 
CREATE TRIGGER FormatoPelicula
ON [dbo].[Peliculas]
AFTER INSERT
AS 
BEGIN
	DECLARE @NewID VARCHAR (6);

	SELECT @NewID = 'P' + RIGHT('000' + CAST(RIGHT(CodP, 3) AS VARCHAR(3)), 3)
	FROM inserted;

	UPDATE [dbo].[Peliculas]
	SET CodP = @NewID
	WHERE CodP = (SELECT CodP FROM inserted);
END;
GO

-- --------------------------- Trigger para actualizar los ID de la tabla de Películas --------------------------- 
CREATE TRIGGER FormatoCategoria
ON [dbo].[Categorias]
AFTER INSERT
AS
BEGIN 
	DECLARE @NewID VARCHAR (6);

	SELECT @NewID = 'C' + RIGHT('000' + CAST(RIGHT (CodC, 3) AS VARCHAR(3)), 3)
	FROM inserted;

	UPDATE [dbo].[Categorias]
	SET CodC = @NewID
	WHERE CodC = (SELECT CodC FROM inserted);
END;
GO

-- --------------------------- Trigger para actualizar los ID de la tabla de Tipo de Peliculas (FORMATO) --------------------------- 
CREATE TRIGGER FormatoTipo
ON [dbo].[Tipos]
AFTER INSERT
AS
BEGIN 
	DECLARE @NewID VARCHAR (6);

	SELECT @NewID = 'T' + RIGHT('000' + CAST(RIGHT (CodT, 3) AS VARCHAR(3)), 3)
	FROM inserted;

	UPDATE [dbo].[Tipos]
	SET CodT = @NewID
	WHERE CodT = (SELECT CodT FROM inserted);
END;
GO

-- CONSTRAINTS DE LAS TABLAS
ALTER TABLE [dbo].[Rentas] 
ADD CONSTRAINT FK_Clientes
FOREIGN KEY (DUI) REFERENCES [dbo].[Clientes] (DUI);

ALTER TABLE [dbo].[Rentas] ADD CONSTRAINT FK_Peliculas
FOREIGN KEY (CodP) REFERENCES [dbo].[Peliculas] (CodP);

ALTER TABLE [dbo].[Peliculas] ADD CONSTRAINT FK_Tipos
FOREIGN KEY (CodT) REFERENCES [dbo].[Tipos] (CodT);

ALTER TABLE [dbo].[Peliculas] 
ADD CONSTRAINT FK_Categorias
FOREIGN KEY (CodC) REFERENCES [dbo].[Categorias] (CodC);

-- ************************************* Insercciones de la tabla de Clientes *************************************

-- --> Para la tabla de Tipo de Peliculas o formato de las mismas
INSERT INTO [dbo].[Tipos] (CodT, Nombre_Tipo) VALUES (1, 'DVD');
INSERT INTO [dbo].[Tipos] (CodT, Nombre_Tipo) VALUES (2, 'VHS');
INSERT INTO [dbo].[Tipos] (CodT, Nombre_Tipo) VALUES (3, 'CASSETTE');

-- --> Para la tabla de Categorias
INSERT INTO [dbo].[Categorias] (CodC, Categorias) VALUES (1, 'Comedia');
INSERT INTO [dbo].[Categorias] (CodC, Categorias) VALUES (2, 'Infantiles');
INSERT INTO [dbo].[Categorias] (CodC, Categorias) VALUES (3, 'Suspenso');
INSERT INTO [dbo].[Categorias] (CodC, Categorias) VALUES (4, 'Drama');
INSERT INTO [dbo].[Categorias] (CodC, Categorias) VALUES (5, 'Acción');
INSERT INTO [dbo].[Categorias] (CodC, Categorias) VALUES (6, 'Juegos');
INSERT INTO [dbo].[Categorias] (CodC, Categorias) VALUES (7, 'Sonidos');
INSERT INTO [dbo].[Categorias] (CodC, Categorias) VALUES (8, 'Romance');
INSERT INTO [dbo].[Categorias] (CodC, Categorias) VALUES (9, 'Terror');
INSERT INTO [dbo].[Categorias] (CodC, Categorias) VALUES (10, 'Anime');

-- --> Para la tabla de Clientes
INSERT INTO [dbo].[Clientes] (Nombres, Apellidos, DUI, Fecha_Afiliacion, Edad) VALUES ('Miguel Armando', 'Cardoza Sosa', '00224432-3', '2008-04-21', 17);
INSERT INTO [dbo].[Clientes] (Nombres, Apellidos, DUI, Fecha_Afiliacion, Edad) VALUES ('María Elena', 'Sánchez Campos', '00278283-2', '2008-04-24', 24);
INSERT INTO [dbo].[Clientes] (Nombres, Apellidos, DUI, Fecha_Afiliacion, Edad) VALUES ('Carlos', 'Alfaro', '00455594-0', '2022-11-05', 30);
INSERT INTO [dbo].[Clientes] (Nombres, Apellidos, DUI, Fecha_Afiliacion, Edad) VALUES ('Jorge Ernersto', 'Manzanero Vásquez', '00900082-9', '2008-08-06', 28);
INSERT INTO [dbo].[Clientes] (Nombres, Apellidos, DUI, Fecha_Afiliacion, Edad) VALUES ('José Antonio', 'Juárez Blanco', '00901133-2', '2008-04-08', 19);
INSERT INTO [dbo].[Clientes] (Nombres, Apellidos, DUI, Fecha_Afiliacion, Edad) VALUES ('Herson', 'Cardoza Sosa', '01433949-8', '2008-04-21', 29);
INSERT INTO [dbo].[Clientes] (Nombres, Apellidos, DUI, Fecha_Afiliacion, Edad) VALUES ('Raúl Ernesto', 'Barraza Soto', '01503949-2', '2008-06-14', 29);
INSERT INTO [dbo].[Clientes] (Nombres, Apellidos, DUI, Fecha_Afiliacion, Edad) VALUES ('Júan José', 'Recinos Ayala', '01850173-9', '2008-03-14', 18);
INSERT INTO [dbo].[Clientes] (Nombres, Apellidos, DUI, Fecha_Afiliacion, Edad) VALUES ('Pedro Arias', 'Rivas Cisneros', '019000683-1', '2008-05-22', 17);
INSERT INTO [dbo].[Clientes] (Nombres, Apellidos, DUI, Fecha_Afiliacion, Edad) VALUES ('Ana Epifania', 'Lopéz Durango', '02829380-9', '2008-07-15', 24);

-- --> Para la tabla de Peliculas
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (1, 'Ace Ventura', 'T001', 'C001', '2003-02-12', 3);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (2, 'El Mundo de los Quien', 'T001', 'C002', '2006-10-01', 4);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (3, 'El Último Guerrero', 'T002', 'C005', '2005-12-11', 5);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (4, 'Aguas Turbias', 'T001', 'C003', '2005-11-21', 6);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (5, 'Terminator III', 'T003', 'C006', '2003-12-26', 5);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (6, 'La sociedad de los Poetas', 'T002', 'C004', '2004-09-12', 4);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (7, 'Final Fantasy III', 'T003', 'C006', '2006-08-23', 5);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (8, 'Little Frog', 'T001', 'C002', '2007-01-18', 6);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (9, 'Halo 2', 'T001', 'C006', '2007-07-07', 7);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (10, 'Ace Ventura 2', 'T001', 'C001', '2006-06-14', 4);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (11, 'Oraciones y Alabanzas', 'T003', 'C007', '2006-12-12', 3);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (12, 'Donde hay llanto hay risa', 'T003', 'C007', '2007-03-11', 3);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (13, 'Rambo III', 'T001', 'C006', '2004-08-27', 5);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (14, 'Terminator 1', 'T003', 'C006', '2003-04-22', 3);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (15, 'Como agua para chocolate', 'T001', 'C008', '2002-05-18', 2);
INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES (16, 'Black Adam', 'T003', 'C005', '2022-11-05', 2);

-- --> Para la tabla de Rentas
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (1, 'P003', '00900082-9', '2003-02-12', '2003-02-16', 1.50, 0.50); -- 1
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (2, 'P006', '00224432-3', '2006-10-01', '2006-10-08', 1.50, 0.00); 
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (3, 'P001', '00901133-2', '2005-12-11', '2005-12-14', 1.50, 0.00);
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (4, 'P007', '02829380-9', '2005-11-21', '2005-11-29', 1.50, 0.50);
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (5, 'P008', '00278283-2', '2003-12-26', '2003-12-28', 1.50, 0.00);
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (6, 'P004', '00224432-3', '2004-09-12', '2004-09-20', 1.50, 0.50);

INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (7, 'P003', '00900082-9', '2006-08-23', '2006-08-26', 1.50, 0.00); -- 1
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (8, 'P002', '01503949-2', '2007-01-18', '2007-01-21', 1.50, 0.00);
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (9, 'P007', '00901133-2', '2006-06-14', '2007-07-09', 1.50, 0.00);
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (10, 'P006', '019000683-1', '2006-12-12', '2006-06-24', 1.50, 0.50); -- 10 UPDATE DUI
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (11, 'P010', '01850173-9', '2007-03-11', '2006-12-21', 1.50, 0.50);

INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (12, 'P005', '00900082-9', '2007-03-11', '2007-03-13', 1.50, 0.00); -- 1
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (13, 'P014', '019000683-1', '2003-04-22', '2004-08-29', 1.50, 0.00); -- 10 UPDATE DUI
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (14, 'P007', '01850173-9', '2002-05-18', '2003-04-24', 1.50, 0.00);
INSERT INTO [dbo].[Rentas] (CodR, CodP, DUI, Fecha_Registro, Fecha_Devolucion, Cobro, Mora) VALUES (15, 'P015', '00224432-3', '2002-05-18', '2002-05-28', 1.50, 0.50);

-- Clientes con más de 25 años
SELECT CONCAT(Nombres, ' ', Apellidos) AS 'Nombre: ', Edad FROM [dbo].[Clientes] WHERE Edad >= 25 ORDER BY Edad ASC;

-- Categorias sin Suspenso ni Drama
SELECT CodC, Categorias FROM [dbo].[Categorias] WHERE Categorias NOT IN ('Suspenso', 'Drama');

-- Listar películas en DVD Existentes
SELECT Nombre AS 'Pelicula', Nombre_Tipo AS 'Formato'
FROM [dbo].[Peliculas] 
INNER JOIN [dbo].[Tipos] ON [dbo].[Peliculas].CodT = [dbo].[Tipos].CodT 
WHERE Nombre_Tipo LIKE '%DVD%';

-- Cuantas películas se tienen en el inventario
SELECT COUNT(*) AS 'Películas en VHS' FROM [dbo].[Peliculas]
INNER JOIN [dbo].[Tipos] ON [dbo].[Peliculas].CodT = [dbo].[Tipos].CodT 
WHERE Nombre_Tipo LIKE '%VHS%';

-- Listar los clientes con Mora
SELECT CONCAT(Nombres, ' ', Apellidos) AS Cliente, Mora, [dbo].[Rentas].DUI
FROM [dbo].[Rentas] 
INNER JOIN [dbo].[Clientes] ON [dbo].[Clientes].DUI = [dbo].[Rentas].DUI
WHERE Mora NOT IN (0) ORDER BY Nombres ASC;

-- Películas que concuerden con ACE
SELECT Nombre, Disponible FROM [dbo].[Peliculas] WHERE Nombre LIKE '%ACE%'

-- Películas que se HAN ALQUILADO y que pertenecen a la categoría COMEDIA
SELECT [dbo].[Peliculas].CodP, Nombre, Categorias, Nombre_Tipo
FROM [dbo].[Peliculas]
INNER JOIN [dbo].[Categorias] ON [dbo].[Categorias].CodC = [dbo].[Peliculas].CodC
INNER JOIN [dbo].[Tipos] ON [dbo].[Peliculas].CodT = [dbo].[Tipos].CodT
WHERE Categorias like '%Comedia%';

-- Listar el Nombre de los clientes y las fechas en que se han afiliado entre abril y junio del año 200
SELECT CONCAT(Nombres, ' ', Apellidos) AS Clientes, Fecha_Afiliacion
FROM [dbo].[Clientes] 
WHERE DATEPART(YEAR, Fecha_Afiliacion) = 2008 
	AND DATEPART(MONTH, Fecha_Afiliacion) BETWEEN 4 AND 6;