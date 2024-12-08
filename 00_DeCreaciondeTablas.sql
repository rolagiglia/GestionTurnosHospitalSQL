/* Script de creacion de DB y tablas 
-se crean ademas los schemas datos_paciente, comercial, servicio, personal, importacion

	ARAGON, RODRIGO EZEQUIEL 43509985
	LA GIGLIA RODRIGO ARIEL DNI 33334248
*/

IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name = 'Com5600G16')
create database Com5600G16 collate Modern_Spanish_CI_AS;
else
	RAISERROR('| Ya existe database Com5600G16 |',5,5,'')
go

use Com5600G16;
go

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'personal' )
	exec('create schema personal')
else
	RAISERROR('| Ya existe Schema personal |',5,5,'')
go

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'datos_paciente')
	exec('Create Schema datos_paciente')  -- SCHEMA
else
	RAISERROR('| Ya existe Schema datos_paciente |',5,5,'')
go

IF NOT EXISTS ( SELECT 1 FROM sys.schemas WHERE name = N'importacion' )
	exec('create schema importacion')
else
	RAISERROR('| Ya existe Schema importacion |',5,5,'')

go

IF NOT EXISTS ( SELECT 1 FROM sys.schemas WHERE name = N'servicio' )
exec('CREATE schema servicio')
else
	RAISERROR('| Ya existe Schema servicio |',5,5,'')
go

IF NOT EXISTS ( SELECT 1 FROM sys.schemas WHERE name = N'comercial' )
exec('CREATE SCHEMA comercial')
else
	RAISERROR('| Ya existe SCHEMA comercial |',5,5,'')
go

if not exists (select * from sysobjects where name='Paciente' and xtype='U')
	create table datos_paciente.Paciente (
		id_historia_clinica int primary key identity(1,1),
		nombre varchar(30) check(ltrim(rtrim(nombre))<>''),
		apellido varchar(35) not null check(ltrim(rtrim(apellido))<>''),
		apellido_materno varchar(35),
		fecha_nacimiento date,
		tipo_documento varchar(10) check(tipo_documento in('DNI','PAS')),
		nro_documento int NOT NULL UNIQUE,
		sexo_biologico varchar(10) check (rtrim(ltrim(sexo_biologico)) in('masculino','femenino')),
		genero varchar(10),
		nacionalidad varchar(30),
		dir_foto_perfil varchar(100),
		mail varchar(50),
		tel_fijo varchar(15),
		tel_alternativo varchar(15),
		tel_laboral varchar(15),
		fecha_registro date default (convert(date,getdate())),
		fecha_actualizacion date default (convert(date,getdate())),
		usuario_actualizacion varchar(20),
		borrado bit default 0  -- paciente borrado 1, activo 0
	);
else
	RAISERROR('| Ya existe datos_paciente.Paciente |',5,5,'')
go

if not exists (select * from sysobjects where name='Usuario' and xtype='U')
	CREATE table datos_paciente.Usuario (
		id_usuario int PRIMARY KEY,  -- -- se deben generar a partir del dni
		contrasenia varchar(20) NOT NULL check( len(contrasenia)>8),--contrasenia mas de 8 caracteres
		fecha_de_creacion date default(convert(date,getdate())),  -- fecha actual default
		id_paciente int,
		CONSTRAINT fk_paciente_usuario foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica)  
	);
else
RAISERROR('| Ya existe  datos_paciente.Usuario |',5,5,'')
go

if not exists (select * from sysobjects where name='Domicilio' and xtype='U')
CREATE table datos_paciente.Domicilio(
	id_domicilio int PRIMARY KEY identity(1,1), 
    calle varchar(50) NOT NULL check(ltrim(rtrim(calle))<>''),
    numero int NOT NULL,
    piso int,
    departamento char(1), -- puede ser letra o numero
    cp smallint,
    pais varchar(50) default 'Argentina',
    provincia varchar(50) NOT NULL check(ltrim(rtrim(provincia))<>''),
    localidad varchar(50) NOT NULL check(ltrim(rtrim(localidad))<>''),
    id_paciente int,
    CONSTRAINT fk_paciente_domicilio foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica)  )
else
	RAISERROR('| Ya existe datos_paciente.Domicilio |',5,5,'')

go


if not exists (select * from sysobjects where name='Prestador' and xtype='U')
CREATE table comercial.Prestador(
	id_prestador int PRIMARY KEY identity(1,1),
    nombre_prestador varchar (50) not null check(nombre_prestador<>''),
    borrado bit default 0           --borrado logico, en 0 indica plan activo
);
else
	RAISERROR('| Ya existe comercial.Prestador |',5,5,'')
go

if not exists (select * from sysobjects where name='Plan_Prestador' and xtype='U')
CREATE table comercial.Plan_Prestador(                        -- planes por prestador
	id_plan int identity(1,1),                    
    id_prestador int,
    nombre_plan varchar (40) not null check(nombre_plan<>''),
	borrado bit default 0 --borrado logico, en 0 indica plan activo
    CONSTRAINT fk_prestador_plan foreign key (id_prestador) references comercial.Prestador(id_prestador),
    CONSTRAINT pk_plan primary key  (id_plan,id_prestador)
);
else
	RAISERROR('| Ya existe comercial.Plan_Prestador |',5,5,'')
go

if not exists (select * from sysobjects where name='Cobertura' and xtype='U')
CREATE table datos_paciente.Cobertura(
	id_cobertura int PRIMARY KEY identity(1,1),
    dir_imagen_credencial varchar(100), -- direccion de la imagen
    nro_socio int not null,      
    fecha_registro date default(convert(date,getdate())),
    id_prestador int,
    id_plan int,
    id_paciente int,
    CONSTRAINT fk_prestador_cobertura foreign key  ( id_plan,id_prestador) REFERENCES comercial.Plan_Prestador(id_plan,id_prestador),
    CONSTRAINT fk_paciente_cobertura foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica)  
    
);
else
	RAISERROR('| Ya existe  datos_paciente.Cobertura |',5,5,'')
go


if not exists (select * from sysobjects where name='Estudio' and xtype='U')
create table servicio.Estudio(
	id_estudio int primary key identity(1,1),
    fecha_estudio date not null,
    nombre_estudio nvarchar(200) not null check(nombre_estudio<>''),
    autorizado varchar(20) default 'pendiente',
	costo int default null,
	id_paciente int,
	imagen_resultado varchar(100)  ,  --direccion de la imagen
	documento_resultado varchar(100),  -- direccion del documento
	borrado bit default 0  --borrado logico en 1 estaria borrado
	CONSTRAINT fk_estudio_paciente foreign key (id_paciente) references datos_paciente.Paciente(id_historia_clinica)
    );
else
	RAISERROR('| Ya existe  servicio.Estudio |',5,5,'')
go 
-- TURNOS MEDICOS ----------------------------------------------------------
if not exists (select * from sysobjects where name='Estado_turno' and xtype='U')
create table servicio.Estado_turno(
	id_estado int primary key identity(1,1),
    nombre_estado varchar(10)  check(nombre_estado in ('reservado','atendido', 'ausente', 'cancelado'))
);
else
	RAISERROR('| Ya existe  servicio.Estado_turno |',5,5,'')
go

if not exists (select * from sysobjects where name='Tipo_turno' and xtype='U')
create table servicio.Tipo_turno(
	id_tipo_turno int primary key identity(1,1),
    nombre_tipo_turno varchar(10) check(nombre_tipo_turno in ('presencial', 'virtual'))
);
else
	RAISERROR('| Ya existe  servicio.Tipo_turno |',5,5,'')
go


if not exists (select * from sysobjects where name='Especialidad' and xtype='U')
create table personal.Especialidad(
	id_especialidad int primary key identity(1,1),
    nombre_especialidad varchar(30) not null UNIQUE check(nombre_especialidad<>''),
	borrado bit default 0  --borrado logico
);
else
	RAISERROR('| Ya existe  personal.Especialidad |',5,5,'')
go

if not exists (select * from sysobjects where name='Medico' and xtype='U')
create table personal.Medico(
	id_medico int primary key identity(1,1),
    nombre_medico varchar(50),
    apellido_medico varchar(50)not null check(rtrim(ltrim(apellido_medico))<>''),
	nro_colegiado int not null UNIQUE,
	borrado bit default 0, --borrado logico
);
else
	RAISERROR('| Ya existe  personal.Medico |',5,5,'')
go

if not exists (select * from sysobjects where name='Sede' and xtype='U')
create table servicio.Sede(
	id_sede int primary key identity(1,1),
    nombre_sede varchar(40) NOT NULL check(rtrim(ltrim(nombre_sede))<>''),
    direccion_sede varchar(50)NOT NULL check(rtrim(ltrim(direccion_sede))<>''),
	localidad_sede varchar (30)NOT NULL check(rtrim(ltrim(localidad_sede))<>''),
	provincia_sede varchar (30)NOT NULL check(rtrim(ltrim(provincia_sede))<>''),
	borrado bit default 0   -- borrado logico por defecto 0, borrado en 1
);
else
	RAISERROR('| Ya existe  servicio.Sede |',5,5,'')
go


if not exists (select * from sysobjects where name='Dias_por_sede' and xtype='U')
create table servicio.Dias_por_sede(                 -- la voy a usar a la hora de validar los turnos
    id int primary key identity(1,1),
	id_medico int,
    id_sede int,
	id_especialidad int,
    dia varchar(10) check(lower(rtrim(ltrim(dia))) in('lunes','martes','miercoles','jueves','viernes','sabado')),
    horario_inicio time(0) check(horario_inicio between '08:00' and '18:00'),
	horario_fin time(0) check(horario_fin between '11:00' and '20:00'),
    constraint fk_dia_medico foreign key (id_medico) references personal.Medico(id_medico),
    constraint fk_dia_sede foreign key (id_sede) references servicio.Sede(id_sede),
	constraint fk_dia_especialidad foreign key (id_especialidad) references personal.Especialidad(id_especialidad),
);
else
	RAISERROR('| Ya existe  servicio.Dias_por_sede |',5,5,'')
go

if not exists (select * from sysobjects where name='Reserva_de_turno_medico' and xtype='U')
create table servicio.Reserva_de_turno_medico(  -- hay que verificar en la insercion de un turno que se encuentre dentro de los dias que ese medico atiende y que el turno no este tomado
	id_turno int primary key identity(1,1),
    fecha date not null,
    hora time(0) not null,
    id_medico int,
	id_especialidad int,
    id_sede int,
    id_estado_turno int,
    id_tipo_turno int,
    id_paciente int,
	borrado bit default 0, --borrado logico, en 1 borrado
    constraint fk_turno_medico foreign key (id_medico) references personal.Medico(id_medico),
	constraint fk_turno_especialidad foreign key (id_especialidad) references personal.Especialidad(id_especialidad),
    constraint fk_turno_sede foreign key (id_sede) references servicio.Sede(id_sede),
    constraint fk_turno_estado foreign key (id_estado_turno) references servicio.Estado_turno (id_estado),
    constraint fk_turno_tipo foreign key (id_tipo_turno) references servicio.Tipo_turno(id_tipo_turno),
    constraint fk_turno_paciente foreign key (id_paciente) references datos_paciente.Paciente(id_historia_clinica)
);
else
	RAISERROR('| Ya existe  servicio.Reserva_de_turno_medico |',5,5,'')
go

if not exists (select * from sysobjects where name='autorizacion_de_estudio' and xtype='U')
create table servicio.autorizacion_de_estudio (
		id int primary key identity(1,1),
		area nvarchar(50) ,
		estudio nvarchar(200),
		prestador nvarchar(50) ,
		plan_ nvarchar(50) ,
		[Porcentaje Cobertura] int,
		costo decimal(10,2),
		[Requiere autorizacion] bit
)
else
	RAISERROR('| Ya existe  servicio.autorizacion_de_estudio |',5,5,'')
go

if not exists (select * from sysobjects where name='medico_especialidad' and xtype='U')
create table personal.medico_especialidad(
	id_medico int,
	id_especialidad int,
	constraint fk_medico_especialidad foreign key (id_medico) references personal.Medico(id_medico),
	constraint fk_especialidad_medico_especialidad foreign key (id_especialidad) references personal.Especialidad(id_especialidad),
	constraint pk_medico_especialidad primary key(id_medico,id_especialidad)
)
else
	RAISERROR('| Ya existe  personal.medico_especialidad |',5,5,'')
go
