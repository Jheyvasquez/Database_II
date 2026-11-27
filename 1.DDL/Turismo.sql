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
    PRINT 'Esquema RRHH ya existe';
END
GO

IF SCHEMA_ID(N'Compras') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA Compras AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de COMPRAS';
END 
ELSE 
BEGIN 
    PRINT 'Esquema Compras ya existe';
END
GO

IF SCHEMA_ID(N'Ventas') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA Ventas AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de Ventas';
END 
ELSE 
BEGIN 
    PRINT 'Esquema Ventas ya existe';
END
GO

IF SCHEMA_ID(N'UNC') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA UNC AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de UNC';
END 
ELSE 
BEGIN 
    PRINT 'Esquema UNC ya existe';
END
GO

IF SCHEMA_ID(N'JSVM') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA JSVM AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de JSVM';
END 
ELSE 
BEGIN 
    PRINT 'Esquema JSVM ya existe';
END
GO

-- CORREGIDO: antes creaba el esquema RRHH en lugar de Hospedaje
IF SCHEMA_ID(N'Hospedaje') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA Hospedaje AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema Hospedaje';
END 
ELSE 
BEGIN 
    PRINT 'Esquema Hospedaje ya existe';
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

-- 4. Tabla SubRegion
IF OBJECT_ID('JSVM.SubRegion', 'U') IS NOT NULL
BEGIN 
    DROP TABLE JSVM.SubRegion;
    PRINT 'Tabla JSVM.SubRegion eliminada';
END 
GO 

-- CORREGIDO: faltaba el esquema JSVM. y la coma después de "idregion int not null"
CREATE TABLE JSVM.SubRegion (
    idsubregion int identity (1,1),
    nomsubregion varchar (100) not null, 
    codigoubigeo varchar(4),
    idregion int not null,
    constraint PK_subregion primary key (idsubregion),
    constraint FK_subregion_region 
    foreign key (idregion) 
    references JSVM.Region (idregion)
);
PRINT 'Tabla JSVM.SubRegion creada exitosamente';
GO


-- 5. Tabla Ciudad
IF OBJECT_ID('JSVM.Ciudad', 'U') IS NOT NULL
BEGIN 
    DROP TABLE JSVM.Ciudad;
    PRINT 'Tabla JSVM.Ciudad eliminada';
END 
GO 

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


-- 6. Tabla TipoDocumento
IF OBJECT_ID('RRHH.TipoDocumento', 'U') IS NOT NULL
BEGIN 
    DROP TABLE RRHH.TipoDocumento;
    PRINT 'Tabla RRHH.TipoDocumento eliminada';
END 
GO 

-- CORREGIDO: abreviatura char(10) rellenaba con espacios -> varchar(10)
CREATE TABLE RRHH.TipoDocumento (
    idtipodocumento int identity (1,1), 
    nombredoc varchar(50) not null,
    abreviatura varchar(10) not null,
    constraint PK_tipodocumento primary key (idtipodocumento),
    constraint UQ_nombredoc UNIQUE (nombredoc),
    constraint UQ_abreviatura UNIQUE (abreviatura)
);
PRINT 'Tabla RRHH.TipoDocumento creada exitosamente';
GO 

-- CORREGIDO: se eliminó el bloque "tabla persona" que hacía DROP TABLE RRHH.T (tabla inexistente)
-- y el USE Turismo_JSVM repetido. La eliminación de Persona ya está en la sección siguiente.

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
-- CORREGIDO: razon_social ya no es obligatoria para personas naturales;
-- un CHECK exige nombres/apaterno si es 'N' y razon_social si es 'J'.
CREATE TABLE RRHH.Persona (
	idpersona int identity(1,1),
	tipo_persona char(1) not null, -- N: Natural, J: Juridica
	constraint CHK_tipo_persona CHECK (tipo_persona in ('N', 'J')),
	
	nombres varchar(100),
	apaterno varchar(100),
	amaterno varchar(100),

	razon_social varchar(200) null,
	nombre_comercial varchar(200),

	constraint CHK_datos_persona CHECK (
		(tipo_persona = 'N' and nombres is not null and apaterno is not null)
		or
		(tipo_persona = 'J' and razon_social is not null)
	),

	idtipodocumento int not null,
	numero_documento varchar(20) not null,
	telefono varchar(20) null,
	constraint CHK_numero_telefono CHECK (telefono is null or (LEN(LTRIM(RTRIM(telefono))) between 12 and 20 and telefono not like '%[^0-9+()]%')),
	email varchar(150),
	idnacionalidad int not null,
	estado varchar(20) default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_estado CHECK (estado in ('Activo', 'Inactivo')),

	constraint PK_persona primary key (idpersona),
	constraint UQ_persona_documento UNIQUE (idtipodocumento, numero_documento),
	constraint FK_Persona_tipodocumento foreign key (idtipodocumento) References RRHH.TipoDocumento (idtipodocumento),
	constraint FK_persona_nacionalidad foreign key (idnacionalidad) References JSVM.Nacionalidad (id_nacionalidad)
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
-- CORREGIDO: longitud (±180) y altitud no cabían en decimal(10,8)
CREATE TABLE JSVM.Direccion (
	iddireccion int identity(1,1),
	idciudad int not null,
	tipo_calle nvarchar(50) not null,
	calle nvarchar(200) not null,
	numero nvarchar(10) default 'S/N',
	referencia nvarchar(max),
	codigo_postal nvarchar(10) not null,
	constraint CHK_zip CHECK (LEN(codigo_postal) between 5 and 10),
	latitud decimal(10,8) null,
	longitud decimal(11,8) null,
	altitud decimal(8,2) null,
	fecha_registro datetime default getdate(),
	constraint PK_direccion primary key (iddireccion),
	constraint FK_direccion_ciudad foreign key (idciudad) References JSVM.Ciudad(idciudad)
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
-- CORREGIDO: el supervisor ahora debe ser un empleado (referencia a RRHH.Empleado)
CREATE TABLE RRHH.Empleado(
	idpersona int not null,
	constraint PK_empleado primary key (idpersona),
	idcargo int not null,
	constraint FK_cargo_empleado foreign key(idcargo) 
	references RRHH.Cargo(idcargo),
	cod_empleado varchar(15) null,
	fecha_ingreso date not null,
	fecha_cese date null,
	tipo_contrato varchar(30) null,
	estado_laboral varchar(20) not null default 'Activo',
	constraint CHK_Estado_Laboral
	CHECK (estado_laboral in ('Activo', 'Inactivo', 'Suspendido')),
	jornada_laboral varchar(30) null,
	regimen_laboral varchar(30) null,
	id_supervisor int null,
	contacto_emergencia varchar(150) null,
	telefono_emergencia varchar(20) null,
	observaciones varchar(max) null, --Informacion adicional
	fecha_registro datetime default getdate(),
	constraint FK_empleado_persona
	foreign key (idpersona) references RRHH.Persona(idpersona),
	constraint FK_empleado_supervisor
	foreign key (id_supervisor) references RRHH.Persona(idpersona)
);
print 'Tabla Empleado creada';
go

-- 6. Tabla Direccion_Cliente
-- CORREGIDO: la FK apunta a Ventas.Cliente (antes a Persona)
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
	constraint FK_direccion_cliente_cliente foreign key (idpersona) References Ventas.Cliente (idpersona),
	constraint FK_direccion_cliente foreign key (iddireccion) References JSVM.Direccion (iddireccion)
);
PRINT 'Tabla Direccion Cliente Creada';
GO

-- 7. Tabla Direccion_Empleado
-- CORREGIDO: la FK apunta a RRHH.Empleado (antes a Persona)
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
	constraint FK_direccion_empleado_empleado foreign key (idpersona) References RRHH.Empleado (idpersona),
	constraint FK_direccion_empleado foreign key (iddireccion) References JSVM.Direccion (iddireccion)
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
-- CORREGIDO: se agregó idcat_proveedor (Categoria_Proveedor no estaba relacionada con ninguna tabla)
CREATE TABLE Compras.Proveedor (
	idpersona int not null,
	cod_proveedor varchar(15) null,
	fecha_inicio_relacion date not null,
	fecha_fin_relacion date null,
	sitio_web nvarchar(250) null,
	requiere_contrato bit not null default 0,
	estado_proveedor varchar(20) not null default 'Activo',
	observaciones nvarchar(max) null,
	idcat_proveedor int not null,
	fecha_registro datetime default getdate(),
	constraint PK_proveedor primary key (idpersona),
	constraint CHK_Estado_Proveedor CHECK (estado_proveedor in ('Activo', 'Inactivo', 'Suspendido')),
	constraint FK_proveedor_persona 
	foreign key (idpersona) References RRHH.Persona(idpersona),
	constraint FK_proveedor_categoria 
	foreign key (idcat_proveedor) References 
		Compras.Categoria_Proveedor (idcat_proveedor)
);
PRINT 'Tabla Proveedor Creada';
GO

-- 10. Tabla Direccion_Proveedor
-- CORREGIDO: estado_proveedor renombrado a estado_direccion (igual que en las otras tablas de direcciones)
-- CORREGIDO: la FK apunta a Compras.Proveedor (antes a Persona)
CREATE TABLE Compras.Direccion_Proveedor (
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion_proveedor CHECK (tipo_direccion in ('Fiscal', 'Envio', 'Fisica', 'Atencion', 'Pago', 'Sucursal', 'Almacen', 'Operativa')),
	es_principal bit not null default 0,
	estado_direccion varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Direccion_Proveedor CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_proveedor primary key (idpersona, iddireccion),
	constraint FK_direccion_proveedor_proveedor foreign key (idpersona) References Compras.Proveedor (idpersona),
	constraint FK_direccion_proveedor foreign key (iddireccion) References JSVM.Direccion (iddireccion)
);
PRINT 'Tabla Direccion Proveedor Creada';
GO



-- =========================================
-- HOSPEDAJE
-- =========================================

-- CORREGIDO: se elimina primero Alojamiento (depende de Tipo_Alojamiento)
-- y antes este bloque borraba Tipo_Alojamiento en lugar de Alojamiento
IF OBJECT_ID('Hospedaje.Alojamiento', 'U') IS NOT NULL
BEGIN 
    DROP TABLE Hospedaje.Alojamiento;
    PRINT 'Tabla Hospedaje.Alojamiento eliminada';
END 
GO 

IF OBJECT_ID('Hospedaje.Tipo_Alojamiento', 'U') IS NOT NULL
BEGIN 
    DROP TABLE Hospedaje.Tipo_Alojamiento;
    PRINT 'Tabla Hospedaje.Tipo_Alojamiento eliminada';
END 
GO 

-- CORREGIDO: faltaba la coma antes de "constraint PK_tipo_alojamiento" y "incono_url" -> "icono_url"
CREATE TABLE Hospedaje.Tipo_Alojamiento (
	idtipoalojamiento int identity (1,1),
	nombre_tipo varchar(50) not null, -- hotel, casa de campo, hostal, cabaña
	descripcion nvarchar(max) null,
	icono_url varchar(255),
	
	constraint PK_tipo_alojamiento primary key (idtipoalojamiento),

	constraint UQ_nombre_tipo_aloj UNIQUE (nombre_tipo)
);
PRINT 'Tabla Tipo_Alojamiento creada';
GO

-- CORREGIDO: la FK referenciaba (idalojamiento) de Tipo_Alojamiento; la columna correcta es idtipoalojamiento
CREATE TABLE Hospedaje.Alojamiento (
	idalojamiento int identity (1,1),
	constraint PK_alojamiento primary key (idalojamiento),

	idtipoalojamiento int not null,
	constraint FK_tipoalojamiento
	foreign key (idtipoalojamiento) references 
	Hospedaje.Tipo_Alojamiento (idtipoalojamiento),

	nombre varchar (100) not null,
	telefono varchar (20),
	correo varchar (100),
	Categoria_Estrellas tinyint,
	fecha_registro datetime default getdate(),
	constraint CHK_categoria_estrellas 
	check (Categoria_Estrellas between 1 and 5) -- solo a hoteles 
);
PRINT 'Tabla Alojamiento creada';
GO

IF OBJECT_ID('Hospedaje.Direccion_Alojamiento', 'U') IS NOT NULL
BEGIN 
    DROP TABLE Hospedaje.Direccion_Alojamiento;
    PRINT 'Tabla Hospedaje.Direccion_Alojamiento eliminada';
END 
GO 

CREATE TABLE Hospedaje.Direccion_Alojamiento (
    idalojamiento int NOT NULL,
    iddireccion int NOT NULL,
    tipo_direccion varchar(20) NOT NULL DEFAULT 'Fisica',
    referencia varchar(max),
    es_principal bit DEFAULT 0,
    fecha_registro datetime DEFAULT GETDATE(),
    CONSTRAINT PK_dire_alojamiento PRIMARY KEY (idalojamiento, iddireccion),
    CONSTRAINT FK_id_alojamiento FOREIGN KEY (idalojamiento) 
        REFERENCES Hospedaje.Alojamiento (idalojamiento),
    CONSTRAINT FK_id_direccion FOREIGN KEY (iddireccion) 
        REFERENCES jsvm.direccion (iddireccion)
);
PRINT 'Tabla Direccion_Alojamiento creada';
GO

-- CREAR TABLA PROVEEDOR_ALOJAMIENTO
IF OBJECT_ID('Hospedaje.Proveedor_Alojamiento', 'U') IS NOT NULL
BEGIN 
    DROP TABLE Hospedaje.Proveedor_Alojamiento;
    PRINT 'Tabla Hospedaje.Proveedor_Alojamiento eliminada';
END 
GO 

CREATE TABLE Hospedaje.Proveedor_Alojamiento (
    idproveedoralojamiento int NOT NULL IDENTITY(1,1),
    idpersona int NOT NULL,
	fecha_registro datetime default getdate(),
    idalojamiento int NOT NULL,
    CONSTRAINT PK_ProveedorAlojamiento PRIMARY KEY (idproveedoralojamiento),
    CONSTRAINT FK_idpersona_provee_alojamiento FOREIGN KEY (idpersona) 
        REFERENCES rrhh.persona (idpersona),
    CONSTRAINT FK_idalojamiento_provee_alojamiento FOREIGN KEY (idalojamiento) 
        REFERENCES Hospedaje.Alojamiento (idalojamiento)

);
PRINT 'Tabla Proveedor_Alojamiento creada';
GO


IF OBJECT_ID('Hospedaje.Tipo_Habitacion', 'U') IS NOT NULL
BEGIN 
    DROP TABLE Hospedaje.Tipo_Habitacion;
    PRINT 'Tabla Hospedaje.Tipo_Habitacion eliminada';
END 
GO 

CREATE TABLE Hospedaje.Tipo_Habitacion (

	idtipohabitacion int not null identity (1,1),
	nombrehabitacion varchar (50) not null,
	constraint PK_idtipohabitacion primary key (idtipohabitacion),
	constraint UQ_nomhabitacion UNIQUE (nombrehabitacion),
	capacidad_persona int not null, 
	descripcion varchar (max),
	fecha_registro datetime default getdate()
);
print 'tabla tipo_habitacion creada'
go

IF OBJECT_ID('Hospedaje.Habitacion', 'U') IS NOT NULL
BEGIN 
    DROP TABLE Hospedaje.Habitacion;
    PRINT 'Tabla Hospedaje.Habitacion eliminada';
END 
GO 

CREATE TABLE Hospedaje.Habitacion (
	idhabitacion int identity (1,1),
	idpersona int not null,
	idalojamiento int not null,
	numero_habitacion varchar(10) not null,
	idtipohabitacion int not null,
	precio_noche decimal(10,2) not null,
	estado varchar(20) default 'Disponible'
	constraint CHK_estado_habitacion 
	check(estado in ('Disponible', 'Ocupado' , 'Mantenimiento', 'Fuera de servicio' )),
	descripcion varchar(max),
	fecha_registro datetime default getdate(),
	constraint PK_habitacion primary key (idhabitacion),
	constraint UQ_habitacion 
	UNIQUE (idpersona , numero_habitacion , idalojamiento),
	constraint FK_id_persona_habitacion 
	foreign key (idpersona) references RRHH.persona (idpersona),
	constraint FK_id_alojamiento_habitacion 
	foreign key (idalojamiento) references Hospedaje.Alojamiento(idalojamiento),
	constraint FK_id_tipo_habitacion 
	foreign key (idtipohabitacion) references Hospedaje.Tipo_Habitacion (idtipohabitacion),

);
print 'tabla habitacion creada'
go

IF SCHEMA_ID(N'Lugar') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA Lugar AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de Lugar';
END 
ELSE 
BEGIN 
    PRINT 'Esquema lugar ya existe';
END
GO

IF SCHEMA_ID(N'Transporte') IS NULL
BEGIN 
    EXEC (N'CREATE SCHEMA Transporte AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema de Transporte';
END 
ELSE 
BEGIN 
    PRINT 'Esquema Transporte ya existe';
END
GO


-- tabla lugar turistico 

IF OBJECT_ID('Lugar.Lugar_turistico', 'U') IS NOT NULL
BEGIN 
    DROP TABLE Lugar.Lugar_turistico;
    PRINT 'Tabla Lugar_turistico eliminada';
END 
GO 

CREATE TABLE Lugar.Lugar_turistico(
	idlugarturistico int identity (1,1),
	nombre varchar (200) not null,
	descripcion varchar(max) null,
	fecha_registro datetime default getdate(),
	precio_entrada decimal (10,2) default 0.00,
	horario_apretura time not null,
	horario_cierre time not null,
	calificacion decimal (3,2) default 0.00,
	estado varchar (20) default 'Activo',
	constraint pk_lugar_turistico primary key (idlugarturistico),
	constraint CHK_estado_lugar 
	CHECK (estado in ('activo', 'Inactivo' , 'Temporalmente cerrado'))

);
print 'tabla Lugar_turistico creada'
go

IF OBJECT_ID('Lugar.Direccion_Lugar_turistico', 'U') IS NOT NULL
BEGIN 
    DROP TABLE Lugar.Direccion_Lugar_turistico;
    PRINT 'Tabla Direccion_Lugar_turistico eliminada';
END 
GO 

CREATE TABLE Lugar.Direccion_LugarTuristico (
	idlugarturistico int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not  null default 'Fisica',
	Referencia varchar (max),
	es_principal bit default 0,
	fecha_registro datetime default getdate(),
	constraint PK_dre_lugarturistico
	primary key (idlugarturistico, iddireccion),
	constraint Fk_id_lugar_turistico
	foreign key (idlugarturistico) references Lugar.Lugar_Turistico (idlugarturistico),
	constraint FK_id_lugar_t 
	foreign key(iddireccion) references jsvm.direccion (iddireccion)
);
print 'tabla direccion_Lugarturistico creada'
go

-- tabla tipo_transporte 

IF OBJECT_ID('Transporte.Tipo_Transporte', 'U') IS NOT NULL
BEGIN 
    DROP TABLE Transporte.Tipo_Transporte;
    PRINT 'Tabla Tipo_Transporte eliminada';
END 
GO 

CREATE TABLE Transporte.Tipo_Transporte (
	idtipotransporte int identity(1,1) ,
	nombre varchar(50) not null,
	descripcion varchar(max),
	fecha_registro datetime default getdate(),
	constraint PK_tipotransporte primary key (idtipotransporte),
	constraint UQ_nombre_transporte UNIQUE (nombre)
);
print 'tabla Tipo_Transporte creada'
go

-- tabla vehiculo

IF OBJECT_ID('Transporte.Vehiculo', 'U') IS NOT NULL
BEGIN 
    DROP TABLE Transporte.Vehiculo;
    PRINT 'Tabla Transporte.Vehiculo eliminada';
END 
GO 

CREATE TABLE Transporte.Vehiculo (
	idvehiculo int identity (1,1), 
	constraint pk_vehiculo primary key (idvehiculo),
	idproveedor int not null,
	constraint fk_vehiculo_proveedor
	foreign key (idproveedor) references Compras.Proveedor
	 (idpersona),
	placa varchar (10) not null,
	constraint UQ_placa UNIQUE (placa),
	marca varchar(50),
	modelo varchar (50),
	capacidad_pasajeros int not null,
	anio_fabricacion int not null 
	constraint CHK_anio_fabricacion 
	CHECK (anio_fabricacion between 2000 and year (getdate())),
	precio_km decimal (10,2),
	precio_hora decimal (10,2),
	precio_dia decimal (10,2),
	estado_vehiculo varchar(20) default 'Disponible',
	fecha_registro datetime default getdate(),
	constraint CHK_estado_vehiculo 
	CHECK ( estado_vehiculo in ('disponible' , 'en servicio' , 'en mantenimiento' , 'fuera servicio' ) )
);
print 'tabla vehiculo creada'
go

