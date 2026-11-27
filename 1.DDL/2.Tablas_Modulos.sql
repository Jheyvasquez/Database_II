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