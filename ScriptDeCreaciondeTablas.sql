/* Script de creacion de DB y tablas */
-- se crean los schemas datos_paciente, comercial, servicio, personal

/*eliminar todo
  
 drop table servicio.Reserva_de_turno_medico;
 drop table datos_paciente.Usuario;
 drop table datos_paciente.Domicilio;
 drop table datos_paciente.Cobertura;
 drop table datos_paciente.Paciente; 
 drop table comercial.Plan_Prestador;
 drop table comercial.Prestador;
 drop table servicio.Estudio;
 drop table servicio.Estado_turno;
 drop table servicio.Tipo_turno;
 drop table servicio.Dias_por_sede;
 drop table servicio.Sede;
 drop table personal.Medico;
 drop table personal.Especialidad;
 
 drop schema comercial;
 drop schema datos_paciente;
 drop schema servicio;
 drop schema personal;
 use master;
 drop database  Com5600G16;
 */
 
create database Com5600G16;
go

use Com5600G16;
go

Create Schema datos_paciente;  -- SCHEMA
go

create table datos_paciente.Paciente(
	id_historia_clinica int primary key identity(1,1),
    nombre varchar(10),
    apellido varchar(15),
    apellido_materno varchar(15),
    fecha_nacimiento date,
    tipo_documento varchar(10),
    nro_documento int NOT NULL UNIQUE,
    sexo_biologico varchar(10) check (lower(rtrim(ltrim(sexo_biologico))) in('masculino','femenino')),  -- masculino o femenino
    genero varchar(10),
    nacionalidad varchar(20),
    dir_foto_perfil varchar(100),
    mail varchar(50),
    tel_fijo varchar(15),
    tel_alternativo varchar(15),
    tel_laboral varchar(15),
    fecha_registro date default (convert(date,getdate())),
    fecha_actualizacion date,
    usuario_actualizacion varchar(20)
);
go


CREATE table datos_paciente.Usuario (
	id_usuario int PRIMARY KEY,  -- -- se deben generar a partir del dni ??
    contrasenia varchar(20), -- ------------------ checkear caract
    fecha_de_creacion date default(convert(date,getdate())),  -- fecha actual default
    id_paciente int,
    CONSTRAINT fk_paciente_usuario foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica)  
);
go

CREATE table datos_paciente.Domicilio(
	id_domicilio int PRIMARY KEY identity(1,1), 
    calle varchar(10),
    numero int,
    piso int,
    departamento char(1), -- puede ser letra o numero
    cp smallint,
    pais varchar(15),
    provincia varchar(20),
    localidad varchar(20),
    id_paciente int,
    CONSTRAINT fk_paciente_domicilio foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica)  
);
go

CREATE SCHEMA comercial; 
go

CREATE table comercial.Prestador(
	id_prestador int PRIMARY KEY identity(1,1),
    nombre_prestador varchar (20),
    estado char(3) DEFAULT 'ACT' check(estado in('ACT','INA'))            -- prestador activo
);
go

CREATE table comercial.Plan_Prestador(                        -- planes por prestador
	id_plan int identity(1,1),                    
    id_prestador int,
    nombre_plan varchar (40),
    CONSTRAINT fk_prestador_plan foreign key (id_prestador) references comercial.Prestador(id_prestador),
    CONSTRAINT pk_plan primary key  (id_plan,id_prestador)
);
go

CREATE table datos_paciente.Cobertura(
	id_cobertura int PRIMARY KEY identity(1,1),
    dir_imagen_credencial varchar(100), -- direccion de la imagen
    nro_socio int,      
    fecha_registro date,
    id_prestador int,
    id_plan int,
    id_paciente int,
    CONSTRAINT fk_prestador_cobertura foreign key  (id_prestador, id_plan) REFERENCES comercial.Plan_Prestador(id_plan,id_prestador),
    CONSTRAINT fk_paciente_cobertura foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica)  
    
);
go

CREATE schema servicio;
go

create table servicio.Estudio(
	id_estudio int primary key identity(1,1),
    fecha_estudio date,
    nombre_estudio varchar(20),
    autorizado varchar(10) default 'pendiente' check (lower(rtrim(ltrim(autorizado))) in ('si','no', 'pendiente')),
    porcentaje_autorizado int
    );
go
-- TURNOS MEDICOS ----------------------------------------------------------

create table servicio.Estado_turno(
	id_estado int primary key identity(1,1),
    nombre_estado varchar(10)  check(nombre_estado in ('reservado','atendido', 'ausente', 'cancelado'))
);
go

create table servicio.Tipo_turno(
	id_tipo_turno int primary key identity(1,1),
    nombre_tipo_turno varchar(10) check(nombre_tipo_turno in ('presencial', 'virtual'))
);
go

create schema personal;
go

create table personal.Especialidad(
	id_especialidad int primary key identity(1,1),
    nombre_especialidad varchar(20)
);
go

create table personal.Medico(
	id_medico int primary key identity(1,1),
    nombre_medico varchar(10),
    apellido_medico varchar(15),
    id_especialidad int,
    constraint fk_especialidad foreign key (id_especialidad) references personal.Especialidad(id_especialidad)
);
go

create table servicio.Sede(
	id_sede int primary key identity(1,1),
    nombre_sede varchar(30),
    direccion_sede varchar(30)
);
go

create table servicio.Dias_por_sede(                 -- la voy a usar a la hora de validar los turnos
    id_medico int,
    id_sede int,
    dia varchar(10) check(lower(rtrim(ltrim(dia))) in('lunes','marte','miercoles','jueves','viernes','sabado')),
    horario_inicio time,
    constraint fk_dia_medico foreign key (id_medico) references personal.Medico(id_medico),
    constraint fk_dia_sede foreign key (id_sede) references servicio.Sede(id_sede),
    constraint pk_dias_por_sede primary key (id_medico,id_sede)
);
go
create table servicio.Reserva_de_turno_medico(  -- hay que verificar en la insercion de un turno que se encuentre dentro de los dias que ese medico atiende y que el turno no este tomado
	id_turno int primary key identity(1,1),
    fecha date,
    hora time,
    id_medico int,
    id_sede int,
    id_estado_turno int,
    id_tipo_turno int,
    id_paciente int,
    constraint fk_turno_medico foreign key (id_medico) references personal.Medico(id_medico),
    constraint fk_turno_sede foreign key (id_sede) references servicio.Sede(id_sede),
    constraint fk_turno_estado foreign key (id_estado_turno) references servicio.Estado_turno (id_estado),
    constraint fk_turno_tipo foreign key (id_tipo_turno) references servicio.Tipo_turno(id_tipo_turno),
    constraint fk_turno_paciente foreign key (id_paciente) references datos_paciente.Paciente(id_historia_clinica)
);
go
