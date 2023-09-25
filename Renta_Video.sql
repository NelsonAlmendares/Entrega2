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

-- Tabla de Clientes
CREATE TABLE [dbo].[Clientes] (
	DUI VARCHAR(12) PRIMARY KEY ,
	Nombres VARCHAR (100) NOT NULL,
	Apellidos VARCHAR (100) NOT NULL,
	Fecha_Afiliacion DATE NOT NULL,
	Edad INT NOT NULL,
);
SELECT * FROM [dbo].[Clientes];
-- Insercciones de la tabla de Clientes
INSERT INTO [dbo].[Clientes] (DUI, Nombres, Apellidos, Fecha_Afiliacion, Edad) VALUES ('06356534-2', 'Nelson José', 'Almendares', GETDATE(), 20);

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
SELECT * FROM [dbo].[Rentas];
GO

-- INSERCCIONES DE LA BASE DE DATOS 
INSERT INTO [dbo].[Rentas] (CodR,Fecha_Registro) VALUES (2,GETDATE());

-- Tabla de Películas
CREATE TABLE [dbo].[Peliculas] (
	CodP VARCHAR (6) PRIMARY KEY,
	Nombre VARCHAR (100) NOT NULL,
	CodT VARCHAR (6) NOT NULL,
	CodC VARCHAR (6) NOT NULL,
	Fecha_Ingreso DATE NOT NULL,
	Disponible INT NOT NULL
);
SELECT * FROM [dbo].[Peliculas];

INSERT INTO [dbo].[Peliculas] (CodP, Nombre, CodT, CodC, Fecha_Ingreso, Disponible) VALUES ();

-- Tabla de Categorías
CREATE TABLE [dbo].[Categorias] (
	CodC VARCHAR(6) PRIMARY KEY,
	Categorias VARCHAR (100) NOT NULL
);
SELECT * FROM [dbo].[Categorias]

-- Tabla para tipos de película
CREATE TABLE [dbo].[Tipos] (
	CodT VARCHAR (6) PRIMARY KEY,
	Nombre_Tipo VARCHAR (30) NOT NULL
);
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
-- --------------------------- Trigger para actualizar los ID de las tablas --------------------------- 
CREATE TRIGGER FormatoPelicula
ON [dbo].[Peliculas]
AFTER INSERT
AS 
BEGIN
	DECLARE @NewID VARCHAR (6);
END;