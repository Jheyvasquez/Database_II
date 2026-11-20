-- Base de datos para sector turismo
-- USA BASE MODELO 

USE master;
GO

-- Validar existencia de base de datos y forzar cierre de conexiones
IF DB_ID('Turismo_JSVM') IS NOT NULL 
BEGIN 
    -- Cortar conexiones activas para evitar error de "Base de datos en uso"
    ALTER DATABASE Turismo_JSVM SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Turismo_JSVM; 
    PRINT 'Base de datos eliminada';
END 
GO 

-- Crear la base de datos
CREATE DATABASE Turismo_JSVM;
PRINT 'Se ha creado la base de datos';
GO

-- IMPORTANTE: Entrar a la base de datos recién creada
USE Turismo_JSVM;
GO

-- Creación de esquemas 
IF SCHEMA_ID(N'RRHH') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA RRHH AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de RRHH';
END 
ELSE 
BEGIN 
    PRINT 'Esquema RRHH creado';
END
GO

IF SCHEMA_ID(N'Compras') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA Compras AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de COMPRAS';
END 
ELSE 
BEGIN 
    PRINT 'Esquema Compras creado';
END
GO

IF SCHEMA_ID(N'Ventas') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA Ventas AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de Ventas';
END 
ELSE 
BEGIN 
    PRINT 'Esquema Ventas creado';
END
GO

IF SCHEMA_ID(N'UNC') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA UNC AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de UNC';
END 
ELSE 
BEGIN 
    PRINT 'Esquema UNC creado';
END
GO

IF SCHEMA_ID(N'JSVM') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA JSVM AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de JSVM';
END 
ELSE 
BEGIN 
    PRINT 'Esquema JSVM creado';
END
GO

-- =========================================
-- CREACIÓN DE TABLAS
-- =========================================

-- 1. Tabla Pais
IF OBJECT_ID('JSVM.Pais', 'U') IS NOT NULL
BEGIN 
    DROP TABLE JSVM.Pais;
    PRINT 'Tabla JSVM.Pais eliminada';
END 
GO 

CREATE TABLE JSVM.Pais (
    idpais int primary key identity (1,1),
    nombrepais varchar(40) not null,
    codigoiso varchar (3) not null, 
    constraint UQ_nombrepais UNIQUE(nombrepais),
    constraint UQ_codigoiso UNIQUE(codigoiso)
);
PRINT 'Tabla JSVM.Pais creada exitosamente';
GO


-- 2. Tabla Nacionalidad
IF OBJECT_ID('JSVM.Nacionalidad', 'U') IS NOT NULL
BEGIN 
    DROP TABLE JSVM.Nacionalidad;
    PRINT 'Tabla JSVM.Nacionalidad eliminada';
END 
GO 

CREATE TABLE JSVM.Nacionalidad (
    id_nacionalidad int identity (1,1),
    nom_nacionalidad varchar (80) not null, -- Falta la coma agregada
    idpais int not null,                    -- Falta esta columna agregada
    constraint PK_nacionalidad primary key (id_nacionalidad),
    constraint UQ_nacionalidad UNIQUE (nom_nacionalidad),
    constraint FK_pais_nacionalidad foreign key (idpais) references JSVM.Pais (idpais)
);
PRINT 'Tabla JSVM.Nacionalidad creada exitosamente';
GO


-- 3. Tabla Region
IF OBJECT_ID('JSVM.Region', 'U') IS NOT NULL
BEGIN 
    DROP TABLE JSVM.Region;
    PRINT 'Tabla JSVM.Region eliminada';
END 
GO 

CREATE TABLE JSVM.Region (
    idregion int identity(1,1), 
    nomregion varchar (80) not null,
    codigoubigeo varchar (3) not null, -- Falta la coma agregada
    idpais int not null,               -- Coma final eliminada
    constraint PK_region primary key (idregion),
    constraint UQ_nomregion UNIQUE (nomregion),
    constraint FK_region_pais
    foreign key (idpais) references JSVM.Pais (idpais)
);
PRINT 'Tabla JSVM.Region creada exitosamente';
GO 

--subregion 

IF OBJECT_ID('JSVM.SubRegion', 'U') IS NOT NULL
BEGIN 
    DROP TABLE JSVM.SubRegion;
    PRINT 'Tabla JSVM.SubRegion eliminada';
END 
GO 

CREATE TABLE subregion (
idsubregion int identity (1,1),
nomsubregion varchar (100) not null, 
codigo_ubigeo varchar(4),
idregion int not null
constraint PK_subregion primary key (idsubregion),
constraint FK_Subregion_region 
foreign key (idregion) 
references JSVM.region (idregion)

);
print 'tabla subregion creada'
go


-- Validar existencia de la tabla Ciudad
IF OBJECT_ID('JSVM.Ciudad', 'U') IS NOT NULL
BEGIN 
    DROP TABLE JSVM.Ciudad; -- Corregido: Ahora sí elimina Ciudad
    PRINT 'Tabla JSVM.Ciudad eliminada';
END 
GO 

-- Crear la tabla Ciudad
CREATE TABLE JSVM.Ciudad (
    idciudad int identity (1,1), 
    nomciudad varchar(80) not null,
    codigoubigeo varchar (6), -- Corregido el nombre de la columna
    idsubregion int not null,
    constraint PK_ciudad primary key (idciudad),
    constraint FK_ciudad_subregion foreign key (idsubregion) references JSVM.SubRegion (idsubregion)
);
PRINT 'Tabla JSVM.Ciudad creada exitosamente';
GO


IF OBJECT_ID('RRHH.TipoDocumento', 'U') IS NOT NULL
BEGIN 
    DROP TABLE RRHH.TipoDocumento;
    PRINT 'Tabla RRHH.TipoDocumento eliminada';
END 
GO 

CREATE TABLE RRHH.TipoDocumento (
idtipodocumento int identity (1,1), 
nombredoc varchar(50) not null,
abreviatura char(10) not null,
constraint PK_tipodocumento
primary key (idtipodocumento),
constraint UQ_nombredoc UNIQUE (nombredoc),
constraint UQ_abreviatura UNIQUE (abreviatura)
);

print 'Tabla tipodocumento creado'
go 

-- tabla persona 
IF OBJECT_ID('RRHH.Persona', 'U') IS NOT NULL
BEGIN 
    DROP TABLE RRHH.T;
    PRINT 'Tabla RRHH.TipoDocumento eliminada';
END 
GO 










































