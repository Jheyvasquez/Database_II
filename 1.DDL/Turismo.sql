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
    nom_nacionalidad varchar (80) not null, 
    idpais int not null,                    
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
    codigoubigeo varchar (3) not null, 
    idpais int not null,               
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
    codigoubigeo varchar (6), 
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

USE Turismo_JSVM;
GO

-- =========================================
-- ELIMINACIÓN PREVIA (En orden inverso de dependencias)
-- =========================================
IF OBJECT_ID('Compras.Direccion_Proveedor', 'U') IS NOT NULL DROP TABLE Compras.Direccion_Proveedor;
IF OBJECT_ID('Compras.Proveedor', 'U') IS NOT NULL DROP TABLE Compras.Proveedor;
IF OBJECT_ID('Compras.Categoria_Proveedor', 'U') IS NOT NULL DROP TABLE Compras.Categoria_Proveedor;
IF OBJECT_ID('RRHH.Direccion_Empleado', 'U') IS NOT NULL DROP TABLE RRHH.Direccion_Empleado;
IF OBJECT_ID('Ventas.Direccion_Cliente', 'U') IS NOT NULL DROP TABLE Ventas.Direccion_Cliente;
IF OBJECT_ID('RRHH.Empleado', 'U') IS NOT NULL DROP TABLE RRHH.Empleado;
IF OBJECT_ID('Ventas.Cliente', 'U') IS NOT NULL DROP TABLE Ventas.Cliente;
IF OBJECT_ID('JSVM.Direccion', 'U') IS NOT NULL DROP TABLE JSVM.Direccion;
IF OBJECT_ID('RRHH.Cargo', 'U') IS NOT NULL DROP TABLE RRHH.Cargo;
IF OBJECT_ID('RRHH.Persona', 'U') IS NOT NULL DROP TABLE RRHH.Persona;
GO

-- =========================================
-- CREACIÓN DE TABLAS
-- =========================================

-- 1. Tabla Persona
CREATE TABLE RRHH.Persona (
	idpersona int identity(1,1),
	tipo_persona char(1) not null -- N: Natural, J: Juridica
	constraint CHK_tipo_persona CHECK (tipo_persona in ('N', 'J')),
	
	nombres varchar(100),
	apaterno varchar(100),
	amaterno varchar(100),

	razon_social varchar(200) not null,
	nombre_comercial varchar(200),

	idtipodocumento int not null,
	numero_documento varchar(20) not null,
	telefono varchar(20)
	constraint CHK_numero_telefono CHECK (LEN(LTRIM(RTRIM(telefono))) between 12 and 20 and telefono not like '%[^0-9+()]%'),
	email varchar(150),
	idnacionalidad int not null,
	estado varchar(20) default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_estado CHECK (estado in ('Activo', 'Inactivo')),

	constraint PK_persona primary key (idpersona),
	constraint UQ_persona_documento UNIQUE (idtipodocumento, numero_documento),
	constraint FK_Persona_tipodocumento foreign key (idtipodocumento) References RRHH.TipoDocumento (idtipodocumento),
	constraint FK_persona_nacionalidad foreign key (idnacionalidad) References JSVM.Nacionalidad (id_nacionalidad) -- Corregido esquema y columna
);
PRINT 'Tabla Persona Creada';
GO

-- 2. Tabla Cargo
CREATE TABLE RRHH.Cargo (
	idcargo int identity(1,1),
	nomcargo varchar(50) not null,
	descripcion varchar(max),
	salario_base decimal(10,2) not null,
	fecha_registro datetime default getdate(),
	constraint PK_cargo Primary key (idcargo)
);
PRINT 'Tabla Cargo Creada';
GO

-- 3. Tabla Direccion
CREATE TABLE JSVM.Direccion ( -- Corregido a JSVM
	iddireccion int identity(1,1),
	idciudad int not null,
	tipo_calle nvarchar(50) not null,
	calle nvarchar(200) not null,
	numero nvarchar(10) default 'S/N',
	referencia nvarchar(max),
	codigo_postal nvarchar(10) not null,
	constraint CHK_zip CHECK (LEN(codigo_postal) between 5 and 10),
	latitud decimal(10,8) null,
	longitud decimal(10,8) null,
	altitud decimal(10,8) null,
	fecha_registro datetime default getdate(),
	constraint PK_direccion primary key (iddireccion),
	constraint FK_direccion_ciudad foreign key (idciudad) References JSVM.Ciudad(idciudad) -- Corregido a JSVM
);
PRINT 'Tabla Direccion Creada';
GO

-- 4. Tabla Cliente
CREATE TABLE Ventas.Cliente (
	idpersona int not null,
	fecha_nacimiento date not null,
	genero varchar(20),
	preferencias_viaje varchar(150) null,
	contacto_emergencia varchar(150) null,
	telefono_emergencia varchar(20) null,
	observaciones varchar(max) null,
	puntos_fidelidad int not null default 0,
	nivel_cliente varchar(20) not null default 'Basico',
	fecha_registro datetime default getdate(),
	constraint PK_Cliente primary key (idpersona),
	constraint FK_cliente_persona Foreign key (idpersona) References RRHH.Persona (idpersona)
);
PRINT 'Tabla Cliente Creada';
GO

-- 5. Tabla Empleado
CREATE TABLE RRHH.Empleado (
	idpersona int not null,
	cod_empleado varchar(15) null,
	fecha_ingreso date not null,
	fecha_cese date null,
	tipo_contrato varchar(30) null,
	estado_laboral varchar(20) not null default 'Activo'
	constraint CHK_Estado_laboral CHECK (estado_laboral in ('Activo', 'Inactivo', 'Suspendido')),
	jornada_laboral varchar(30) null,
	regimen_laboral varchar(30) null,
	id_supervisor int null,
	contacto_emergencia varchar(150) null,
	telefono_emergencia varchar(20) null,
	observaciones varchar(max) null,
	fecha_registro datetime default getdate(),
	constraint PK_empleado primary key (idpersona),
	constraint FK_empleado_persona Foreign key (idpersona) References RRHH.Persona (idpersona),
	constraint FK_empleado_supervisor Foreign key (id_supervisor) References RRHH.Persona (idpersona)
);
PRINT 'Tabla Empleado Creada';
GO

-- 6. Tabla Direccion_Cliente
CREATE TABLE Ventas.Direccion_Cliente ( 
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion CHECK (tipo_direccion in ('Casa', 'Trabajo', 'Facturacion', 'Entrega')),
	es_principal bit not null default 0,
	estado_direccion varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Direccion_Cliente CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_cliente primary key (idpersona, iddireccion),
	constraint FK_direccion_cliente_persona foreign key (idpersona) References RRHH.Persona (idpersona),
	constraint FK_direccion_cliente foreign key (iddireccion) References JSVM.Direccion (iddireccion) -- Corregido a JSVM
);
PRINT 'Tabla Direccion Cliente Creada';
GO

-- 7. Tabla Direccion_Empleado
CREATE TABLE RRHH.Direccion_Empleado (
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion_empleado CHECK (tipo_direccion in ('Casa', 'Trabajo')),
	es_principal bit not null default 0,
	estado_direccion varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Direccion_Empleado CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_empleado primary key (idpersona, iddireccion),
	constraint FK_direccion_empleado_persona foreign key (idpersona) References RRHH.Persona (idpersona),
	constraint FK_direccion_empleado foreign key (iddireccion) References JSVM.Direccion (iddireccion) -- Corregido a JSVM
);
PRINT 'Tabla Direccion Empleado Creada';
GO

-- 8. Tabla Categoria_Proveedor
CREATE TABLE Compras.Categoria_Proveedor (
	idcat_proveedor int identity(1,1),
	nomcat_proveedor varchar(60) not null,
	descripcion varchar(max),
	fecha_registro datetime default getdate(),
	constraint PK_cat_proveedor primary key (idcat_proveedor),
	constraint UQ_nombre_cat_proveedor UNIQUE (nomcat_proveedor)
);
PRINT 'Tabla Categoria Proveedor Creada';
GO

-- 9. Tabla Proveedor
CREATE TABLE Compras.Proveedor (
	idpersona int not null,
	cod_proveedor varchar(15) null,
	fecha_inicio_relacion date not null,
	fecha_fin_relacion date null,
	sitio_web nvarchar(250) null,
	requiere_contrato bit not null default 0,
	estado_proveedor varchar(20) not null default 'Activo',
	observaciones nvarchar(max) null,
	fecha_registro datetime default getdate(),
	constraint PK_proveedor primary key (idpersona),
	constraint CHK_Estado_Proveedor CHECK (estado_proveedor in ('Activo', 'Inactivo', 'Suspendido')),
	constraint FK_proveedor_persona foreign key (idpersona) References RRHH.Persona(idpersona)
);
PRINT 'Tabla Proveedor Creada';
GO

-- 10. Tabla Direccion_Proveedor
CREATE TABLE Compras.Direccion_Proveedor (
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion_proveedor CHECK (tipo_direccion in ('Fiscal', 'Envio', 'Fisica', 'Atencion', 'Pago', 'Sucursal', 'Almacen', 'Operativa')),
	es_principal bit not null default 0,
	estado_proveedor varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Direccion_Proveedor CHECK (estado_proveedor in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_proveedor primary key (idpersona, iddireccion),
	constraint FK_direccion_proveedor_persona foreign key (idpersona) References RRHH.Persona (idpersona),
	constraint FK_direccion_proveedor foreign key (iddireccion) References JSVM.Direccion (iddireccion) -- Corregido a JSVM
);
PRINT 'Tabla Direccion Proveedor Creada';
GO









































