/* Script de SP de insercion, modificacion y eliminacion */
-- se crean las stored procedures correspondientes a la insercion, modificacion y eliminacion de las distintas tablas

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

 drop procedure insertarPaciente;
 drop procedure insertarUsuario;
 drop procedure insertarDomicilio;
 drop procedure insertarPrestador;
 drop procedure insertarPlanPrestador;
 drop procedure insertarCobertura;
 drop procedure insertarEstudio;
 drop procedure insertarEstadoTurno;
 drop procedure insertarTipoTurno;
 drop procedure insertarEspecialidad;
 drop procedure insertarMedico;
 drop procedure insertarSede;
 drop procedure insertarDiasPorSede;
 drop procedure insertarReservaTurno; 




 drop procedure modificarFotoPaciente;
 drop procedure modificarTelPaciente;
 drop procedure modificarContraseniaUsuario;
 drop procedure modificarDomicilio;
 drop procedure modificarPrestador;
 drop procedure modificarPlan;
 drop procedure modificarCobertura;
 drop procedure modificarEstudio;
 drop procedure modificarEstadoTurno;
 drop procedure modificarTipoTurno;
 drop procedure modificarEspecialidadMedico;
 drop procedure modificarDireccionSede;
 drop procedure modificarDiasSede;
 drop procedure modificarReservaTipoTurno;
 drop procedure modificarReservaFechaHoraTurno;
 drop procedure modificarReservaEstadoTurno;
 drop procedure modificarReservaMedicoSede;




 drop procedure eliminarPaciente;
 drop procedure eliminarPrestador;
 drop procedure eliminarPlan;
 drop procedure eliminarEstudio;
 drop procedure eliminarTurno;
 drop procedure eliminarUsuario;
 drop procedure eliminarDomicilio;
 drop procedure eliminarTipoTurno;
 drop procedure eliminarEstadoTurno;
 drop procedure eliminarEspecialidad;
 drop procedure eliminarMedico;
 drop procedure eliminarSede;
 drop procedure eliminarCobertura;
 drop procedure eliminarDiasSede;
 */


 -----STORED PROCEDURES------------
-----INSERTS----------------------


use Com5600G16
go 
create or alter procedure insertarPaciente
(
	@Nombre varchar(30),
	@Apellido varchar(35),
	@Apellido_materno varchar(35),
    @Fecha_nacimiento date,
    @Tipo_documento varchar(10),
    @NroDoc int,
    @Sexo_biologico varchar(10),
    @Genero varchar(10),
    @Nacionalidad varchar(30),
    @Dir_foto_perfil varchar(100),
    @Mail varchar(50),
    @Tel_fijo varchar(15),
    @Tel_alternativo varchar(15),
    @Tel_laboral varchar(15),
	@Usuario_actualizacion varchar(20)
	
)
as
begin
	
	if(@Sexo_biologico = 'masculino' collate SQL_Latin1_General_CP1_CI_AI or
		@Sexo_biologico = 'femenino' collate SQL_Latin1_General_CP1_CI_AI)
		insert into datos_paciente.Paciente (nombre, apellido, apellido_materno, fecha_nacimiento, tipo_documento,
										nro_documento, sexo_biologico, genero, nacionalidad, dir_foto_perfil,
										mail,tel_fijo,tel_alternativo,tel_laboral, usuario_actualizacion) 
										values 
		(
			@Nombre,
			@Apellido,
			@Apellido_materno,
			@Fecha_nacimiento,
			@Tipo_documento,
			@NroDoc,
			@Sexo_biologico,
			@Genero,
			@Nacionalidad,
			@Dir_foto_perfil,
			@Mail,
			@Tel_fijo,
			@Tel_alternativo,
			@Tel_laboral,
			@Usuario_actualizacion
		)

end
go


create or alter procedure insertarUsuario                    --recibe la dni del paciente y una contrasenia
(
    
    @dni_paciente int,
	@contrasenia varchar(20)
)
as
begin

	if(@dni_paciente in (	
		select nro_documento
		from datos_paciente.Paciente
	))
	begin
		declare @Id_paciente int
	    set @Id_paciente = (select id_historia_clinica 
							from datos_paciente.Paciente
							where nro_documento = @dni_paciente)

		insert into datos_paciente.Usuario (id_usuario,contrasenia,id_paciente)
		values
		(
			@dni_paciente,   --el sistema genera usuario con el nro de dni
			@contrasenia,
			@Id_paciente
		)
	end

end
go


create or alter procedure insertarDomicilio
( 
    @calle varchar(10),
    @numero int,
    @piso int,
    @departamento char(1), -- puede ser letra o numero
    @cp smallint,
    @pais varchar(15),
    @provincia varchar(20),
    @localidad varchar(20),
    @id_paciente int
    --CONSTRAINT fk_paciente_domicilio foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica) 
)
as
begin

	if(@Id_paciente in (	
		select id_historia_clinica
		from datos_paciente.Paciente
	))
	begin
		insert into datos_paciente.Domicilio values
		(
		    @calle,
			@numero,
			@piso,
			@departamento,
			@cp,
			@pais,
			@provincia,
			@localidad,
			@id_paciente
		)
	end

end
go


create or alter procedure insertarPrestador
( 
    @nombre_prestador varchar (20),
    @estado bit
)
as
begin
		if not exists(select @nombre_prestador from comercial.Prestador )   --evito insercion de prestadores repetidos
		insert into comercial.Prestador values
		(
			@nombre_prestador,
			@estado
		)
end
go

create or alter	procedure comercial.insertarPlanPrestador
(                
    @id_prestador int,
    @nombre_plan varchar (40)
    --CONSTRAINT fk_prestador_plan foreign key (id_prestador) references comercial.Prestador(id_prestador),
)
as
begin
	--verifico que exista el prestador y evito que se inserte un plan repetido
	if(@id_prestador in (select id_prestador from comercial.Prestador)and @nombre_plan not in(select nombre_plan from comercial.Plan_Prestador where id_prestador=@id_prestador)) 
	begin
		insert into comercial.Plan_Prestador values (@id_prestador, @nombre_plan)
	end
end
go


create or alter	procedure insertarCobertura
(                
    @dir_imagen_credencial varchar(100), -- direccion de la imagen
    @nro_socio int,      
    @fecha_registro date,
    @id_prestador int,
    @id_plan int,
    @id_paciente int
    --CONSTRAINT fk_prestador_cobertura foreign key  (id_prestador, id_plan) REFERENCES comercial.Plan_Prestador(id_plan,id_prestador),
    --CONSTRAINT fk_paciente_cobertura foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica)     
)
as
begin
	
	if(@id_prestador in (select id_prestador from comercial.Plan_Prestador) and
		@id_plan in (select id_plan from comercial.Plan_Prestador) and
		@id_paciente in (select id_historia_clinica from datos_paciente.Paciente))
	begin
		insert into datos_paciente.Cobertura values 
			(    
				@dir_imagen_credencial,
				@nro_socio,      
				@fecha_registro,
				@id_prestador,
				@id_plan,
				@id_paciente
			)
	end
end
go


create or alter	procedure insertarEstudio
(                
    @fecha_estudio date,
    @nombre_estudio varchar(20),
    @autorizado varchar(10),
    @porcentaje_autorizado int
)
as
begin
	

	insert into servicio.Estudio values 
	(    
		@fecha_estudio,
		@nombre_estudio,
		@autorizado,
		@porcentaje_autorizado
	)
end
go


create or alter	procedure insertarEstadoTurno
(                
    @nombre_estado varchar(10)
)
as
begin
	
	insert into servicio.Estado_turno values 
	(    
		@nombre_estado
	)
end
go


create or alter	procedure insertarTipoTurno
(                
    @nombre_tipo_turno varchar(10)
)
as
begin
	
	insert into servicio.Tipo_turno values 
	(    
		@nombre_tipo_turno
	)
end
go


create or alter	procedure insertarEspecialidad
(                
    @nombre_especialidad varchar(20)
)
as
begin
	
	insert into personal.Especialidad values 
	(    
		@nombre_especialidad
	)
end
go


create or alter	procedure insertarMedico
(                
    @nombre_medico varchar(10),
    @apellido_medico varchar(15),
    @id_especialidad int
    --constraint fk_especialidad foreign key (id_especialidad) references personal.Especialidad(id_especialidad)
)
as
begin

	if(@id_especialidad in (select id_especialidad from personal.Especialidad))
	begin
		insert into personal.Medico values 
		(    
			@nombre_medico,
			@apellido_medico,
			@id_especialidad
		)
	end
end
go


create or alter	procedure insertarSede
(                
    @nombre_sede varchar(30),
    @direccion_sede varchar(30)
)
as
begin
		insert into servicio.Sede values 
		(    
		    @nombre_sede,
			@direccion_sede
		)
end
go


create or alter	procedure insertarDiasPorSede
(                
    @id_medico int,
    @id_sede int,
    @dia varchar(10),
    @horario_inicio time
    --constraint fk_dia_medico foreign key (id_medico) references personal.Medico(id_medico),
    --constraint fk_dia_sede foreign key (id_sede) references servicio.Sede(id_sede),
)
as
begin
	if(@id_medico in (select id_medico from personal.Medico) and
		@id_sede in (select id_sede from servicio.Sede))

	begin
		insert into servicio.Dias_por_sede values 
		(    
		    @id_medico,
			@id_sede,
			@dia,
			@horario_inicio
		)
	end
end
go



create or alter	procedure insertarReservaTurno
(                
    @fecha date,
    @hora time,
    @id_medico int,
    @id_sede int,
    @id_estado_turno int,
    @id_tipo_turno int,
    @id_paciente int
  --  constraint fk_turno_medico foreign key (id_medico) references personal.Medico(id_medico),
   -- constraint fk_turno_sede foreign key (id_sede) references servicio.Sede(id_sede),
    --constraint fk_turno_estado foreign key (id_estado_turno) references servicio.Estado_turno (id_estado),
    --constraint fk_turno_tipo foreign key (id_tipo_turno) references servicio.Tipo_turno(id_tipo_turno),
    --constraint fk_turno_paciente foreign key (id_paciente) references datos_paciente.Paciente(id_historia_clinica)
)
as
begin
	
	---Para poder saber si el medico atiende ese dia o no, tenemos que pasar el numero que nos devuelve weekday
	---de la fecha de a insertar a una cadena con el nombre correspondiente, 
	---por ejemplo, si nos da "3" entonces el dia es "martes" (La semana empieza el domingo)

	---Nota: verificar que este bien hecha la verificacion en el if
	
	
	declare @dia varchar(10); 
	set @dia = case 
	
	when datepart(weekday, @fecha) = 1 then 'domingo'
	when datepart(weekday, @fecha) = 2 then 'lunes'
	when datepart(weekday, @fecha) = 3 then 'martes'
	when datepart(weekday, @fecha) = 4 then 'miercoles'
	when datepart(weekday, @fecha) = 5 then 'jueves'
	when datepart(weekday, @fecha) = 6 then 'viernes'
	when datepart(weekday, @fecha) = 7 then 'sabado'
	end


	if(@id_medico in (select id_medico from servicio.Dias_por_sede) and
		@id_sede in (select id_sede from servicio.Dias_por_sede where id_medico = @id_medico) and 
		@dia in (select dia from servicio.Dias_por_sede where id_medico = @id_medico and id_sede = @id_sede) and
		@id_estado_turno in (select id_estado from servicio.Estado_turno) and						
		@id_tipo_turno in (select id_tipo_turno from servicio.Tipo_turno) and
		@id_paciente in (select id_historia_clinica from datos_paciente.Paciente))

	begin
		insert into servicio.Reserva_de_turno_medico values 
		(    
			@fecha,
			@hora,
			@id_medico,
			@id_sede,
			@id_estado_turno,
			@id_tipo_turno,
			@id_paciente
		)
	end
end
go


-----MODIFIES----------------------


create or alter procedure modificarFotoPaciente
(
	@id_historia_clinica int,
    @dir_foto_perfil varchar(100)
)
as
begin
	
	update datos_paciente.Paciente
	set dir_foto_perfil = @dir_foto_perfil
	where id_historia_clinica = @id_historia_clinica
	
end
go



create or alter procedure modificarTelPaciente
(
	@id_historia_clinica int,
    @tel varchar(15),
	@tipo varchar(11)
)
as
begin
	
	if(@tipo = 'fijo' collate SQL_Latin1_General_CP1_CI_AS)
	begin
		update datos_paciente.Paciente
		set tel_fijo = @tel
		where id_historia_clinica = @id_historia_clinica
	end

	if(@tipo = 'alternativo' collate SQL_Latin1_General_CP1_CI_AS)
	begin
		update datos_paciente.Paciente
		set tel_alternativo = @tel
		where id_historia_clinica = @id_historia_clinica
	end

	if(@tipo = 'laboral' collate SQL_Latin1_General_CP1_CI_AS)
	begin
		update datos_paciente.Paciente
		set tel_laboral = @tel
		where id_historia_clinica = @id_historia_clinica
	end
end
go



create or alter procedure modificarContraseniaUsuario
(
	@id_usuario int,
    @contrasenia varchar(15)
)
as
begin

	update datos_paciente.Usuario
	set contrasenia = @contrasenia
	where id_usuario = @id_usuario

end
go


create or alter procedure modificarDomicilio
(
    @calle varchar(10),
    @numero int,
    @piso int,
    @departamento char(1), -- puede ser letra o numero
    @cp smallint,
    @pais varchar(15),
    @provincia varchar(20),
    @localidad varchar(20),
    @id_paciente int
)
as
begin

	update datos_paciente.Domicilio
	set calle = @calle,
		numero = @numero,
		piso = @piso,
		departamento = @departamento,
		cp = @cp,
		localidad = @localidad,
		provincia = @provincia,
		pais = @pais
	where id_paciente = @id_paciente

end
go


create or alter procedure modificarPrestador
(
	@id_prestador int,
    @estado char(3)
)
as
begin

	if(@estado = 'INA' collate Latin1_General_100_CS_AS or
		@estado = 'ACT' collate Latin1_General_100_CS_AS)
	begin
			update comercial.Prestador
			set estado = @estado
			where id_prestador = @id_prestador
	end
end
go



create or alter procedure modificarPlan
(
    @nombre_plan varchar (40),
	@id_plan int
)
as
begin

	update comercial.Plan_Prestador
	set nombre_plan = @nombre_plan
	where id_plan = @id_plan

end
go


create or alter procedure modificarCobertura
(   
	@id_prestador int,
    @id_plan int,
    @id_paciente int
)
as
begin

	if(@id_plan in (select id_plan from comercial.Plan_Prestador) and
		@id_prestador in (select id_prestador from comercial.Plan_Prestador))
	begin
		update datos_paciente.Cobertura
		set id_plan = @id_plan
		where id_paciente = @id_paciente
	end
end
go


create or alter procedure modificarEstudio
(   
	@id_estudio int,
    @autorizado varchar(10), --default 'pendiente' check (lower(rtrim(ltrim(autorizado))) in ('si','no', 'pendiente')),
    @porcentaje_autorizado int
)
as
begin

	if(@autorizado = 'pendiente' collate Latin1_General_100_CI_AI or
		@autorizado = 'si' collate Latin1_General_100_CI_AI or
		@autorizado = 'no' collate Latin1_General_100_CI_AI)
	begin
		update servicio.Estudio
		set autorizado = @autorizado,
			porcentaje_autorizado = @porcentaje_autorizado
		where id_estudio = @id_estudio
	end
end
go


create or alter procedure modificarEstadoTurno
(   
	@id_estado int,
    @nombre_estado varchar(10) -- check(nombre_estado in ('reservado','atendido', 'ausente', 'cancelado'))
)
as
begin

	if(@nombre_estado = 'reservado' collate Latin1_General_100_CI_AS or
		@nombre_estado = 'atendido' collate Latin1_General_100_CI_AS or
		@nombre_estado = 'ausente' collate Latin1_General_100_CI_AS or
		@nombre_estado = 'cancelado' collate Latin1_General_100_CI_AS)
	begin
		update servicio.Estado_turno
		set nombre_estado = @nombre_estado
		where id_estado = @id_estado
	end
end
go


create or alter procedure modificarTipoTurno
(   
	@id_tipo_turno int,
    @nombre_tipo_turno varchar(10)-- check(nombre_tipo_turno in ('presencial', 'virtual'))
)
as
begin

	if(@nombre_tipo_turno = 'presencial' collate Latin1_General_100_CI_AS or
		@nombre_tipo_turno = 'virtual' collate Latin1_General_100_CI_AS)
	begin
		update servicio.Tipo_turno
		set nombre_tipo_turno = @nombre_tipo_turno
		where id_tipo_turno = @id_tipo_turno
	end
end
go



create or alter procedure modificarEspecialidadMedico
(   
	@id_medico int,
    @id_especialidad int
   -- constraint fk_especialidad foreign key (id_especialidad) references personal.Especialidad(id_especialidad)
)
as
begin

	if(@id_especialidad in (select id_especialidad from personal.Especialidad))
	begin
		update personal.Medico
		set id_especialidad = @id_especialidad
		where id_medico = @id_medico
	end
end
go



create or alter procedure modificarDireccionSede
(   
	@id_sede int,
    @direccion_sede varchar(30)
)
as
begin

		update servicio.Sede
		set direccion_sede = @direccion_sede
		where id_sede = @id_sede
end
go


create or alter procedure modificarDiasSede
(   
    @id_medico int,
    @id_sede int,
    @dia varchar(10), --check(lower(rtrim(ltrim(dia))) in('lunes','marte','miercoles','jueves','viernes','sabado')),
    @horario_inicio time
	--constraint fk_dia_medico foreign key (id_medico) references personal.Medico(id_medico),
   -- constraint fk_dia_sede foreign key (id_sede) references servicio.Sede(id_sede),
)
as
begin
	
	if((@dia = 'lunes' collate  Latin1_General_100_CI_AS or
		@dia = 'martes' collate  Latin1_General_100_CI_AS or
		@dia = 'miercoles' collate  Latin1_General_100_CI_AS or
		@dia = 'jueves' collate  Latin1_General_100_CI_AS or
		@dia = 'viernes' collate Latin1_General_100_CI_AS or
		@dia = 'sabado' collate Latin1_General_100_CI_AS) and

		@id_medico in (select id_medico from personal.Medico) and
		@id_sede in (select id_sede from servicio.Sede)
		)
	begin
		update servicio.Dias_por_sede
		set dia = @dia,
			id_medico = @id_medico,
			horario_inicio = @horario_inicio
		where id_sede = @id_sede
	end
end
go


create or alter procedure modificarReservaTipoTurno
(   
	@id_turno int,
    @id_tipo_turno int
  --  constraint fk_turno_medico foreign key (id_medico) references personal.Medico(id_medico),
  --  constraint fk_turno_sede foreign key (id_sede) references servicio.Sede(id_sede),
 --   constraint fk_turno_estado foreign key (id_estado_turno) references servicio.Estado_turno (id_estado),
   -- constraint fk_turno_tipo foreign key (id_tipo_turno) references servicio.Tipo_turno(id_tipo_turno),
   -- constraint fk_turno_paciente foreign key (id_paciente) references datos_paciente.Paciente(id_historia_clinica)
)
as
begin
	
	if(@id_tipo_turno in (select id_tipo_turno from servicio.Tipo_turno))
	begin
		update servicio.Reserva_de_turno_medico
		set id_tipo_turno = @id_tipo_turno
		where id_turno = @id_turno
	end
end
go


create or alter procedure modificarReservaFechaHoraTurno
(   
	@id_turno int,
    @fecha date,
    @hora time
  --  constraint fk_turno_medico foreign key (id_medico) references personal.Medico(id_medico),
  --  constraint fk_turno_sede foreign key (id_sede) references servicio.Sede(id_sede),
 --   constraint fk_turno_estado foreign key (id_estado_turno) references servicio.Estado_turno (id_estado),
   -- constraint fk_turno_tipo foreign key (id_tipo_turno) references servicio.Tipo_turno(id_tipo_turno),
   -- constraint fk_turno_paciente foreign key (id_paciente) references datos_paciente.Paciente(id_historia_clinica)
)
as
begin
	
		update servicio.Reserva_de_turno_medico
		set fecha = @fecha,
			hora = @hora
		where id_turno = @id_turno
end
go


create or alter procedure modificarReservaEstadoTurno
(   
	@id_turno int,
	@id_estado_turno int
   -- constraint fk_turno_medico foreign key (id_medico) references personal.Medico(id_medico),
   -- constraint fk_turno_sede foreign key (id_sede) references servicio.Sede(id_sede),
   -- constraint fk_turno_estado foreign key (id_estado_turno) references servicio.Estado_turno (id_estado),
   -- constraint fk_turno_tipo foreign key (id_tipo_turno) references servicio.Tipo_turno(id_tipo_turno),
   -- constraint fk_turno_paciente foreign key (id_paciente) references datos_paciente.Paciente(id_historia_clinica)
)
as
begin

	if(@id_estado_turno in (select id_estado from servicio.Estado_turno))
	begin
		update servicio.Reserva_de_turno_medico
		set id_estado_turno = @id_estado_turno
		where id_turno = @id_turno
	end
end
go


create or alter procedure modificarReservaMedicoSede
(   
	@id_turno int,
	@id_medico int,
    @id_sede int
   -- constraint fk_turno_medico foreign key (id_medico) references personal.Medico(id_medico),
   -- constraint fk_turno_sede foreign key (id_sede) references servicio.Sede(id_sede),
   -- constraint fk_turno_estado foreign key (id_estado_turno) references servicio.Estado_turno (id_estado),
   -- constraint fk_turno_tipo foreign key (id_tipo_turno) references servicio.Tipo_turno(id_tipo_turno),
   -- constraint fk_turno_paciente foreign key (id_paciente) references datos_paciente.Paciente(id_historia_clinica)
)
as
begin

	if(@id_medico in (select id_medico from personal.Medico) and
		@id_sede in (select id_sede from servicio.Sede))
	begin
		update servicio.Reserva_de_turno_medico
		set id_medico = @id_medico,
			id_sede = @id_sede
		where id_turno = @id_turno
	end
end
go




------DELETES--------------



create or alter procedure eliminarPaciente
(   
	@id_paciente int
)
as
begin

	delete servicio.Reserva_de_turno_medico
	where id_paciente = @id_paciente

	delete datos_paciente.Usuario
	where id_paciente = @id_paciente

	delete datos_paciente.Domicilio
	where id_paciente = @id_paciente

	delete datos_paciente.Cobertura
	where id_paciente = @id_paciente

	delete datos_paciente.Paciente
	where id_historia_clinica = @id_paciente

end
go



create or alter procedure eliminarPrestador
(   
	@id_prestador int
)
as
begin

	delete datos_paciente.Cobertura
	where id_prestador = @id_prestador

	delete comercial.Plan_Prestador
	where id_prestador = @id_prestador

	delete comercial.Prestador
	where id_prestador = @id_prestador

end
go



create or alter procedure eliminarPlan
(   
	@id_plan int
)
as
begin

	delete datos_paciente.Cobertura
	where id_plan = @id_plan

	delete comercial.Plan_Prestador
	where id_plan = @id_plan

end
go



create or alter procedure eliminarEstudio
(   
	@id_estudio int
)
as
begin

	delete servicio.Estudio
	where id_estudio = @id_estudio

end
go



create or alter procedure eliminarTurno
(   
	@id_turno int
)
as
begin

	delete servicio.Reserva_de_turno_medico
	where id_turno = @id_turno

end
go



create or alter procedure eliminarUsuario
(   
	@id_usuario int
)
as
begin

	delete datos_paciente.Usuario
	where id_usuario = @id_usuario

end
go



create or alter procedure eliminarDomicilio
(   
	@id_domicilio int
)
as
begin

	delete datos_paciente.Domicilio
	where id_domicilio = @id_domicilio

end
go



create or alter procedure eliminarTipoTurno
(   
	@id_tipo_turno int
)
as
begin

	delete servicio.Reserva_de_turno_medico
	where id_tipo_turno = @id_tipo_turno

	delete servicio.Tipo_turno
	where id_tipo_turno = @id_tipo_turno

end
go



create or alter procedure eliminarEstadoTurno
(   
	@id_estado int
)
as
begin

	delete servicio.Reserva_de_turno_medico
	where id_estado_turno = @id_estado

	delete servicio.Estado_turno
	where id_estado = @id_estado

end
go




create or alter procedure eliminarEspecialidad
(   
	@id_especialidad int
)
as
begin

	delete personal.Medico
	where id_especialidad = @id_especialidad

	delete personal.Especialidad
	where id_especialidad = @id_especialidad

end
go



create or alter procedure eliminarMedico
(   
	@id_medico int
)
as
begin

	delete servicio.Dias_por_sede
	where id_medico = @id_medico

	delete servicio.Reserva_de_turno_medico
	where id_medico = @id_medico

	delete personal.Medico
	where id_medico = @id_medico

end
go



create or alter procedure eliminarSede
(   
	@id_sede int
)
as
begin

	delete servicio.Dias_por_sede
	where id_sede = @id_sede

	delete servicio.Reserva_de_turno_medico
	where id_sede = @id_sede

	delete servicio.Sede
	where id_sede = @id_sede

end
go


create or alter procedure eliminarCobertura
(   
	@id_cobertura int
)
as
begin

	delete datos_paciente.Cobertura
	where id_cobertura = @id_cobertura

end
go


create or alter procedure eliminarDiasSede
(   
	@id_medico int,
	@id_sede int
)
as
begin

	delete servicio.Dias_por_sede
	where id_medico = @id_medico and
			id_sede = @id_sede

end
go