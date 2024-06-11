/* Script de SP de insercion, modificacion y eliminacion */

-----STORED PROCEDURES------------
-----INSERTS----------------------


use Com5600G16
go 
create or alter procedure datos_paciente.insertarPaciente
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
		else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')

end
go


create or alter procedure datos_paciente.insertarUsuario                    --recibe la dni del paciente y una contrasenia
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
	else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')

end
go


create or alter procedure datos_paciente.insertarDomicilio
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
	)and @id_paciente not in (select id_paciente from datos_paciente.Domicilio)) --no inserta duplicados
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
	else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')
end
go


create or alter procedure comercial.insertarPrestador
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
		else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')
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
		insert into comercial.Plan_Prestador (id_prestador,nombre_plan) values (@id_prestador, @nombre_plan)
	end
	else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')
end
go


create or alter	procedure datos_paciente.insertarCobertura
(                
    @dir_imagen_credencial varchar(100), -- direccion de la imagen
    @nro_socio int,      
    @id_prestador int,
    @id_plan int,
    @id_paciente int
    --CONSTRAINT fk_prestador_cobertura foreign key  (id_prestador, id_plan) REFERENCES comercial.Plan_Prestador(id_plan,id_prestador),
    --CONSTRAINT fk_paciente_cobertura foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica)     
)
as
begin
	
	if(@id_prestador in (select id_prestador from comercial.Plan_Prestador where borrado=0) and     --verifica que exista el prestador, el plan y el paciente
		@id_plan in (select id_plan from comercial.Plan_Prestador where borrado=0) and
		@id_paciente in (select id_historia_clinica from datos_paciente.Paciente where borrado=0)and 
		@id_paciente not in(select id_paciente from datos_paciente.Cobertura))       --no permite la insercion de mas de una cobertura para un paciente
		begin
			insert into datos_paciente.Cobertura(dir_imagen_credencial,nro_socio,id_prestador,id_plan,id_paciente) values 
				(    
					@dir_imagen_credencial,
					@nro_socio,      
					@id_prestador,
					@id_plan,
					@id_paciente
				)
		end
		else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')
end
go


create or alter	procedure servicio.insertarEstudio
(   
	@id_paciente int,
    @fecha_estudio date,
    @nombre_estudio varchar(50),
    @autorizado varchar(10),
	@imagen_resultado varchar(100),
	@documento_resultado varchar(100)

)
as
begin
	if(@id_paciente in(select id_historia_clinica from datos_paciente.Paciente)and
		(@id_paciente not in(select id_paciente from servicio.Estudio where fecha_estudio=@fecha_estudio)))  --non permite mas de un estudio al mismo paciente en el mismo momento

	insert into servicio.Estudio(fecha_estudio,nombre_estudio,autorizado,id_paciente,imagen_resultado,documento_resultado) values 
	(    
		@fecha_estudio,
		@nombre_estudio,
		@autorizado,
		@id_paciente,
		@imagen_resultado,
		@documento_resultado
	)else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')
end
go


create or alter	procedure servicio.insertarEstadoTurno
(                
    @nombre_estado varchar(10)
)
as
begin
		if(not exists(select 1 from servicio.Estado_turno where nombre_estado=@nombre_estado))
		insert into servicio.Estado_turno values 
		(    
			@nombre_estado    --valores validos ('reservado','atendido', 'ausente', 'cancelado')
		)
		else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')
end
go


create or alter	procedure servicio.insertarTipoTurno
(                
    @nombre_tipo_turno varchar(10)
)
as
begin
	if(not exists(select 1 from servicio.Tipo_turno where nombre_tipo_turno= @nombre_tipo_turno ))
	insert into servicio.Tipo_turno values 
	(    
		@nombre_tipo_turno
	)
	else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')
end
go


create or alter	procedure personal.insertarEspecialidad
(                
    @nombre_especialidad varchar(30)
)
as
begin
	if(@nombre_especialidad not in(select nombre_especialidad from personal.Especialidad))  --no inserta especialidades repetidas
	insert into personal.Especialidad values 
	(    
		@nombre_especialidad
	)
	else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')
end
go


create or alter	procedure personal.insertarMedico  
(                
    @nombre_medico varchar(10),
    @apellido_medico varchar(15),
    @id_especialidad int,
	@nro_colegiado int
    --constraint fk_especialidad foreign key (id_especialidad) references personal.Especialidad(id_especialidad)
)
as
begin
	if(@nro_colegiado in(select nro_colegiado from personal.Medico where borrado=1)
						and @id_especialidad in (select id_especialidad from personal.Especialidad)) --si ya existia pero estaba dado de baja lo reactivo
	begin
		update personal.Medico
		set borrado=0
		where nro_colegiado=@nro_colegiado
		
		update  personal.Medico
		set id_especialidad=@id_especialidad
		where nro_colegiado=@nro_colegiado
	end
	else
		begin
	--verifico que exista la especialidad y que el medico no este registrado 
			if(@id_especialidad in (select id_especialidad from personal.Especialidad)and @nro_colegiado not in(select nro_colegiado from personal.Medico))
			begin
				insert into personal.Medico(nombre_medico,apellido_medico,id_especialidad,nro_colegiado) values 
				(    
					@nombre_medico,
					@apellido_medico,
					@id_especialidad,
					@nro_colegiado
				)
			end
			else 
				RAISERROR('ERROR insercion NO REALIZADA',5,5,'')
		end
	
end
go


create or alter	procedure servicio.insertarSede
(                
    @nombre_sede varchar(30),
    @direccion_sede varchar(30),
	@localidad_sede varchar (30),
	@provincia_sede varchar (30)
	
)
as
begin
		if(@nombre_sede in(select nombre_sede from servicio.Sede where borrado=1))  --si ya existia pero estaba con borrado logico la vuelve a dar de alta
		begin	
			update servicio.Sede
			set borrado=0
			where nombre_sede=@nombre_sede
		end			
			
		if(@nombre_sede not in(select nombre_sede from servicio.Sede))            --verifica que la sede no exista 
		insert into servicio.Sede(nombre_sede, direccion_sede, localidad_sede,provincia_sede) values 
		(    
		    @nombre_sede,
			@direccion_sede,
			@localidad_sede,
			@provincia_sede

		)
		else 
		RAISERROR('ERROR insercion NO REALIZADA',5,5,'')
end
go


create or alter	procedure servicio.insertarDiasPorSede
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
	if(@id_medico in (select id_medico from personal.Medico where borrado=0) and
		@id_sede in (select id_sede from servicio.Sede where borrado=0))
		and (@id_medico not in(select id_medico from servicio.Dias_por_sede where id_sede=@id_sede and dia=lower(@dia)))

	begin
		insert into servicio.Dias_por_sede values 
		(    
		    @id_medico,
			@id_sede,
			@dia,
			@horario_inicio
		)
	end
	else
		RAISERROR('NO FUE POSIBLE INSERTAR',5,5,'')
end
go



create or alter	procedure servicio.insertarReservaTurno
(                
    @fecha date,
    @hora time,
    @id_medico int,
	@id_especialidad int,
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
	
	declare @hora_inicio time(0)
	select @hora_inicio = (select horario_inicio from servicio.Dias_por_sede d inner join personal.Medico m on d.id_medico=m.id_medico
						inner join servicio.Sede s on s.id_sede=d.id_sede
						where d.id_medico=@id_medico and s.id_sede=@id_sede and dia=@dia and m.id_especialidad= @id_especialidad and m.borrado=0 and s.borrado=0)  --obtengo la hora de inicio y verifico que el medico este activo

	if (@hora_inicio is not null and DATEDIFF(minute,@hora_inicio, @hora)%15=0)--verifico que el horario sea multiplo de 15 minutos y que  el medico atienda ese dia en esa sede esa especialidad
	begin 
			if(@id_estado_turno in (select id_estado from servicio.Estado_turno) and						
			@id_tipo_turno in (select id_tipo_turno from servicio.Tipo_turno) and
			@id_paciente in (select id_historia_clinica from datos_paciente.Paciente))
			begin 
				if(not exists(select 1 from servicio.Reserva_de_turno_medico t inner join servicio.Estado_turno e on t.id_estado_turno=e.id_estado
						where t.fecha=@fecha and t.hora=@hora and t.id_medico=@id_medico and t.id_sede=@id_sede and e.nombre_estado='reservado' and t.borrado=0))--verifico que no este asignado el turno
					begin
						insert into servicio.Reserva_de_turno_medico (fecha,hora,id_medico,id_especialidad,id_sede,id_estado_turno,id_tipo_turno,id_paciente) values 
						(    
							@fecha,
							@hora,
							@id_medico,
							@id_especialidad,
							@id_sede,
							@id_estado_turno,
							@id_tipo_turno,
							@id_paciente
						)
					end
					else
						RAISERROR (N'turno ya asignado',1,1,'',5)
			end
	end
	else
		RAISERROR (N'dia u horario incorrecto',1,1,'',5)
end
go



-----MODIFIES----------------------


create or alter procedure datos_paciente.modificarFotoPaciente
(
	@id_historia_clinica int,
    @dir_foto_perfil varchar(100),
	@usuario_actualizacion varchar(30)
)
as
begin
	
	update datos_paciente.Paciente
	set dir_foto_perfil = @dir_foto_perfil
	where id_historia_clinica = @id_historia_clinica
	
	update datos_paciente.Paciente
	set usuario_actualizacion = @usuario_actualizacion 
	where id_historia_clinica = @id_historia_clinica

	update datos_paciente.Paciente
	set fecha_actualizacion = convert(date,getdate())
	where id_historia_clinica = @id_historia_clinica
end
go



create or alter procedure datos_paciente.modificarTelPaciente
(
	@id_historia_clinica int,
    @tel varchar(15),
	@tipo varchar(11),
	@usuario_actualizacion varchar(20)
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
	update datos_paciente.Paciente
	set usuario_actualizacion = @usuario_actualizacion 
	where id_historia_clinica = @id_historia_clinica

	update datos_paciente.Paciente
	set fecha_actualizacion = convert(date,getdate())
	where id_historia_clinica = @id_historia_clinica
end
go



create or alter procedure datos_paciente.modificarContraseniaUsuario
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


create or alter procedure datos_paciente.modificarDomicilio
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


create or alter procedure comercial.modificarPrestador
(
	@id_prestador int,
    @estado bit 
)
as
begin

	if(@estado = 1 or
		@estado = 0)
	begin
			update comercial.Prestador
			set borrado = @estado
			where id_prestador = @id_prestador
	end
	else 
		RAISERROR('ERROR MODIFICACION NO REALIZADA',5,5,'')
end
go



create or alter procedure comercial.modificarPlan
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


create or alter procedure comercial.modificarCobertura
(   
	@id_prestador int,
    @id_plan int,
    @id_paciente int
)
as
begin

	if(@id_plan in (select id_plan from comercial.Plan_Prestador where borrado=0) and
		@id_prestador in (select id_prestador from comercial.Plan_Prestador  where borrado=0))
	begin
		update datos_paciente.Cobertura
		set id_plan = @id_plan
		where id_paciente = @id_paciente
	end
	else 
		RAISERROR('ERROR MODIFICACION NO REALIZADA',5,5,'')
end
go


create or alter procedure servicio.modificarAutorizarEstudio
(   
	@id_estudio int,
    @autorizado varchar(10)
)
as
begin
		update servicio.Estudio
		set autorizado = @autorizado
		where id_estudio = @id_estudio
end
go


create or alter procedure servicio.modificarEstadoTurno
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
	else 
		RAISERROR('ERROR MODIFICACION NO REALIZADA',5,5,'')
end
go


create or alter procedure servicio.modificarTipoTurno
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
	else 
		RAISERROR('ERROR MODIFICACION NO REALIZADA',5,5,'')
end
go



create or alter procedure personal.modificarEspecialidadMedico
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
	else 
		RAISERROR('ERROR MODIFICACION NO REALIZADA',5,5,'')
end
go



create or alter procedure servicio.modificarDireccionSede
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


create or alter procedure servicio.modificarDiasSede
(   
    @id_medico int,
    @id_sede int,
    @dia varchar(10), --check('lunes','marte','miercoles','jueves','viernes','sabado'),
    @horario_inicio time(0)
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

		@id_medico in (select id_medico from personal.Medico where borrado=0) and
		@id_sede in (select id_sede from servicio.Sede)
		)
	begin
		update servicio.Dias_por_sede
		set dia = @dia,
			id_medico = @id_medico,
			horario_inicio = @horario_inicio
		where id_sede = @id_sede
	end
	else 
		RAISERROR('ERROR MODIFICACION NO REALIZADA',5,5,'')
end
go


create or alter procedure servicio.modificarReservaTipoTurno
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


create or alter procedure servicio.modificarReservaFechaHoraTurno
(   
	@id_turno int,
    @fecha date,
    @hora time(0)
)
as
begin
	declare @dia varchar(10); 
	declare @hora_inicio time(0);
	declare @id_sede int;
	declare @id_medico int;
	declare @id_especialidad int;
		
		--obtengo los datos del turno que tenia
	set @id_sede=(select id_sede from servicio.Reserva_de_turno_medico where id_turno=@id_turno)
	set @id_medico=(select id_medico from servicio.Reserva_de_turno_medico where id_turno=@id_turno)
	set @id_especialidad=(select id_especialidad from servicio.Reserva_de_turno_medico where id_turno=@id_turno)
	
	if(@id_sede is not null and @id_medico is not null and @id_especialidad is not null)
	begin
		set @dia = case 
		when datepart(weekday, @fecha) = 1 then 'domingo'
		when datepart(weekday, @fecha) = 2 then 'lunes'
		when datepart(weekday, @fecha) = 3 then 'martes'
		when datepart(weekday, @fecha) = 4 then 'miercoles'
		when datepart(weekday, @fecha) = 5 then 'jueves'
		when datepart(weekday, @fecha) = 6 then 'viernes'
		when datepart(weekday, @fecha) = 7 then 'sabado'
		end
						
		select @hora_inicio = (select horario_inicio from servicio.Dias_por_sede d inner join personal.Medico m on d.id_medico=m.id_medico
			where d.id_medico=@id_medico and id_sede=@id_sede and dia=@dia and m.id_especialidad= @id_especialidad ) --busca horario de inicio de atencion

		if (@hora_inicio is not null and DATEDIFF(minute,@hora_inicio, @hora)%15=0)--verifico que el horario sea multiplo de 15 minutos y que  el medico atienda ese dia en esa sede esa especialidad
		begin 
			if(not exists(select 1 from servicio.Reserva_de_turno_medico t inner join servicio.Estado_turno e on t.id_estado_turno=e.id_estado
							where t.fecha=@fecha and t.hora=@hora and t.id_medico=@id_medico and t.id_sede=@id_sede and e.nombre_estado='reservado'and t.borrado=0))--verifico que no este asignado el turno
			begin
				update servicio.Reserva_de_turno_medico
				set hora=@hora
				where id_turno=@id_turno

				update servicio.Reserva_de_turno_medico
				set fecha=@fecha
				where id_turno=@id_turno
			end
			else
				RAISERROR('turno no disponible',10,5,'')
		end
		else
			RAISERROR('FECHA U HORA INCORRECTOS',10,5,'')
	end
	else 
		RAISERROR('NO EXISTE EL TURNO',10,5,'')
end
go


create or alter procedure servicio.modificarReservaEstadoTurno
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
	 RAISERROR('ERROR NO SE MODIFICO',5,5,'')
end
go


create or alter procedure servicio.modificarReservaMedicoSede
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

	if(@id_medico in (select id_medico from personal.Medico where borrado=0) and
		@id_sede in (select id_sede from servicio.Sede where borrado=0))
	begin
		update servicio.Reserva_de_turno_medico
		set id_medico = @id_medico,
			id_sede = @id_sede
		where id_turno = @id_turno
	end
	else
	 RAISERROR('ERROR NO SE MODIFICO',5,5,'')
end
go




------DELETES--------------



create or alter procedure datos_paciente.eliminarPaciente -- NO VOY A BORRAR FISICAMENTE LOS PACIENTES, UTILIZAMOS BORRADO LOGICO con el campo borrado
(   
	@id_paciente int
)
as
begin
	

	update datos_paciente.Paciente
	set borrado=1   -- 1 indica que el paciente esta borrado
	where id_historia_clinica =@id_paciente

	update servicio.Reserva_de_turno_medico  --borra los turnos que tenia asignados
	set borrado=1
	where id_paciente=@id_paciente
end
go


/*Los prestadores est�n conformador por Obras Sociales y Prepagas con las cuales se establece una
alianza comercial. Dicha alianza puede finalizar en cualquier momento, por lo cual debe poder ser
actualizable de forma inmediata si el contrato no est� vigente. En caso de no estar vigente el contrato,
deben ser anulados todos los turnos de pacientes que se encuentren vinculados a esa prestadora y
pasar a estado disponible.*/
create or alter procedure comercial.eliminarPrestador   --utilizamos borrado logico 
(   
	@id_prestador int
)
as
begin

	update comercial.Prestador
	set borrado=1                  --borrado logico
	where id_prestador = @id_prestador

	update servicio.Reserva_de_turno_medico                        
	set borrado=1									--borra los turnos asignados a ese prestador de forma logica y se pueden utilizar para otro paciente
	where id_paciente in(select id_paciente from datos_paciente.Cobertura where id_prestador=@id_prestador)

end
go



create or alter procedure comercial.eliminarPlan  --borrado logico
(   
	@id_plan int
)
as
begin

	update comercial.Plan_Prestador
	set borrado=1
	where id_plan = @id_plan

end
go



create or alter procedure servicio.eliminarEstudio  --borrado logico
(   
	@id_estudio int
)
as
begin

	update servicio.Estudio
	set borrado = 1
	where id_estudio = @id_estudio

end
go



create or alter procedure servicio.eliminarTurno  --borrado logico 
(   
	@id_turno int
)
as
begin

	update servicio.Reserva_de_turno_medico
	set borrado=1
	where id_turno = @id_turno

end
go



create or alter procedure datos_paciente.eliminarUsuario
(   
	@id_usuario int
)
as
begin

	delete datos_paciente.Usuario
	where id_usuario = @id_usuario

end
go



create or alter procedure datos_paciente.eliminarDomicilio
(   
	@id_domicilio int
)
as
begin

	delete datos_paciente.Domicilio
	where id_domicilio = @id_domicilio

end
go


create or alter procedure servicio.eliminarTipoTurno 
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
	if(not exists(select 1 from personal.Medico where id_especialidad=@id_especialidad))
		delete from personal.Especialidad
		where id_especialidad = @id_especialidad
	else
		RAISERROR('NO SE PUEDE ELIMINAR',5,5,'')

end
go



create or alter procedure eliminarMedico   --BORRADO LOGICO
(   
	@id_medico int
)
as
begin

	update personal.Medico
	set borrado=1
	where id_medico=@id_medico

	update servicio.Reserva_de_turno_medico  --borra los turnos que tenia asignados ese medico
	set borrado=1
	where id_medico=@id_medico

	

end
go



create or alter procedure eliminarSede   --borrado logico
(   
	@id_sede int
)
as
begin
	update servicio.Sede
	set borrado=1
	where id_sede=@id_sede
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

create or alter proc autorizar_estudio(@estudio varchar(max),@plan varchar(max),@nro_documento int)
as
begin
	declare @porcentaje_cobertura varchar(10)
	declare @costo int

	set @porcentaje_cobertura = (select [Porcentaje Cobertura]
								from servicio.autorizacion_de_estudio
								where estudio=@estudio and plan_=@plan)

	set @costo = (select costo
				from servicio.autorizacion_de_estudio
				where estudio=@estudio and plan_=@plan)
	if(@porcentaje_cobertura is not null)
		update servicio.Estudio
		set autorizado=@porcentaje_cobertura,
			costo=@costo
		where id_paciente in(select id_paciente from datos_paciente.Paciente where nro_documento=@nro_documento)
	
end
go