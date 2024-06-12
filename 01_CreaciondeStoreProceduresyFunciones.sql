/* Script CREACION DE SP de insercion, modificacion y eliminacion 

MATERIA BBDDA COMISION 5600 
GRUPO NRO 16 
ALUMNOS:
	ARAGON, RODRIGO EZEQUIEL 43509985
	LA GIGLIA RODRIGO ARIEL DNI 33334248

*/

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
	if(@Sexo_biologico = 'masculino' collate SQL_Latin1_General_CP1_CI_AS or
		@Sexo_biologico = 'femenino' collate SQL_Latin1_General_CP1_CI_AS)
		insert into datos_paciente.Paciente (nombre, apellido, apellido_materno, fecha_nacimiento, tipo_documento,
										nro_documento, sexo_biologico, genero, nacionalidad, dir_foto_perfil,
										mail,tel_fijo,tel_alternativo,tel_laboral, usuario_actualizacion) 
										values 
		(
			 (ltrim(rtrim(@Nombre))),
			(ltrim(rtrim(@Apellido))),
			(ltrim(rtrim(@Apellido_materno))),
			@Fecha_nacimiento,
			@Tipo_documento,
			@NroDoc,
			(ltrim(rtrim(@Sexo_biologico))),
			(ltrim(rtrim(@Genero))),
			(ltrim(rtrim(@Nacionalidad))),
			(ltrim(rtrim(@Dir_foto_perfil))),
			(ltrim(rtrim(@Mail))),
			(ltrim(rtrim(@Tel_fijo))),
			(ltrim(rtrim(@Tel_alternativo))),
			(ltrim(rtrim(@Tel_laboral))),
			(ltrim(rtrim(@Usuario_actualizacion)))
		)
		else 
		RAISERROR('ERROR NO SE AGREGO EL PACIENTE',5,5,'')

end
go


create or alter procedure datos_paciente.insertarUsuario     --recibe la dni del paciente y una contrasenia
(
    
    @dni_paciente int,
	@contrasenia varchar(20)
)
as
begin

	if(@dni_paciente in (	
		select nro_documento
		from datos_paciente.Paciente))
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
		RAISERROR('DNI INEXISTENTE',5,5,'')
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
    @dni_paciente int
    --CONSTRAINT fk_paciente_domicilio foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica) 
)
as
begin
	declare @id_paciente int
	set @id_paciente = (select id_historia_clinica
						from datos_paciente.Paciente
						where nro_documento=@dni_paciente)
	if (@id_paciente is not null)
	and @id_paciente not in (select id_paciente
							 from datos_paciente.Domicilio) --no inserta duplicados
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
		RAISERROR('ERROR PACIENTE NO EXISTE O YA TIENE DOMICILIO',5,5,'')
end
go


create or alter procedure comercial.insertarPrestador  --por default el prestador se crea activo
( 
    @nombre_prestador varchar (50)
)
as
begin
		if not exists(select @nombre_prestador from comercial.Prestador ) and @nombre_prestador is not null and  @nombre_prestador <>''   --evito insercion de prestadores repetidos
		insert into comercial.Prestador (nombre_prestador) values
		(
			 upper(ltrim(rtrim(@nombre_prestador)))
		)
		else 
		RAISERROR('ERROR EL PRESTADOR YA EXISTE o el NOMBRE ES INVALIDO',5,5,'')
end
go

create or alter	procedure comercial.insertarPlanPrestador 
(                
    @nombre_prestador varchar(50),
    @nombre_plan varchar (50)
    --CONSTRAINT fk_prestador_plan foreign key (id_prestador) references comercial.Prestador(id_prestador),
)
as
begin
	--verifico que exista el prestador, evito que se inserte un plan repetido o vacio
	declare @id_prestador int
	set @id_prestador = (select id_prestador 
						from comercial.Prestador
						where nombre_prestador=@nombre_prestador and borrado = 0 )
	if(@id_prestador is not null)
	begin		
		if( @nombre_plan not in(select nombre_plan 
								from comercial.Plan_Prestador 
								where id_prestador=@id_prestador) )
			insert into comercial.Plan_Prestador (id_prestador,nombre_plan) values (@id_prestador, upper(ltrim(rtrim(@nombre_plan))))
		else
			if(@nombre_plan in(select nombre_plan 
								from comercial.Plan_Prestador 
								where id_prestador=@id_prestador and borrado=1))
				update comercial.Plan_Prestador
				set borrado=0
				where nombre_plan=@nombre_plan
			else
				RAISERROR('YA EXISTE EL PLAN',5,5,'')
	end
	else 
		RAISERROR('ERROR NO EXISTE EL PRESTADOR',5,5,'')
end
go


create or alter	procedure datos_paciente.insertarCobertura
(                
    @dir_imagen_credencial varchar(100), -- direccion de la imagen
    @nro_socio int,      
    @nombre_prestador varchar(50),
    @nombre_plan varchar(50),
    @nro_documento int
    --CONSTRAINT fk_prestador_cobertura foreign key  (id_prestador, id_plan) REFERENCES comercial.Plan_Prestador(id_plan,id_prestador),
    --CONSTRAINT fk_paciente_cobertura foreign key  (id_paciente) REFERENCES datos_paciente.Paciente(id_historia_clinica)     
)
as
begin
	declare @id_prestador int,
			@id_plan int,
			@id_paciente int

	set @id_prestador = (select id_prestador from comercial.Prestador where borrado=0 and nombre_prestador=@nombre_prestador)
	set @id_plan = (select id_plan from comercial.Plan_Prestador where borrado=0 and nombre_plan=@nombre_plan and id_prestador=@id_prestador)
	set @id_paciente = (select id_historia_clinica from datos_paciente.Paciente where borrado=0 and nro_documento=@nro_documento)
	
	--verifica que exista el prestador, el plan y el paciente
	if(@id_prestador is not null and     
		@id_plan is not null and
		@id_paciente is not null and 
		@id_paciente not in(select id_paciente from datos_paciente.Cobertura))       --no permite la insercion de mas de una cobertura para un paciente
		begin
			insert into datos_paciente.Cobertura(dir_imagen_credencial,nro_socio,id_prestador,id_plan,id_paciente) values 
				(    
					ltrim(rtrim(@dir_imagen_credencial)),
					@nro_socio,      
					@id_prestador,
					@id_plan,
					@id_paciente
				)
		end
		else 
		RAISERROR('ERROR VALORES INGRESADOS INCORRECTOS o DUPLICADOS',5,5,'')
end
go


create or alter	procedure servicio.insertarEstudio
(   
	@nro_documento int,
    @fecha_estudio date,
    @nombre_estudio nvarchar(max),
    @autorizado varchar(10),
	@imagen_resultado varchar(100),
	@documento_resultado varchar(100)

)
as
begin
	declare @id_paciente int
	set @id_paciente = (select id_historia_clinica from datos_paciente.Paciente where borrado=0 and nro_documento=@nro_documento)
	if(@id_paciente is not null and (@id_paciente not in(select id_paciente from servicio.Estudio where fecha_estudio=@fecha_estudio and nombre_estudio=@nombre_estudio and borrado=0)))  --no permite mas de un estudio igual al mismo paciente en el mismo momento, y el paciente debe estar activo

	insert into servicio.Estudio(fecha_estudio,nombre_estudio,autorizado,id_paciente,imagen_resultado,documento_resultado) values 
	(    
		@fecha_estudio,
		ltrim(rtrim(@nombre_estudio)),
		ltrim(rtrim(@autorizado)),
		@id_paciente,
		ltrim(rtrim(@imagen_resultado)),
		ltrim(rtrim(@documento_resultado))
	)else 
		RAISERROR('ERROR NO EXISTE EL PACIENTE O ESTUDIO DUPLICADO',5,5,'')
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
			lower(ltrim(rtrim(@nombre_estado)))    --valores validos ('reservado','atendido', 'ausente', 'cancelado')
		)
		else 
		RAISERROR('ERROR YA EXISTE EL ESTADO',5,5,'')
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
		ltrim(rtrim(@nombre_tipo_turno))
	)
	else 
		RAISERROR('YA EXISTE EL TIPO',5,5,'')
end
go


create or alter	procedure personal.insertarEspecialidad
(                
    @nombre_especialidad varchar(30)
)
as
begin
	declare @id_especialidad int
	set @id_especialidad = (select id_especialidad from personal.Especialidad where nombre_especialidad=@nombre_especialidad)
	if(@id_especialidad is null)			--la especialidad no existe //no inserta duplicados
			insert into personal.Especialidad (nombre_especialidad) values 
			(    
				UPPER(ltrim(rtrim(@nombre_especialidad)))
			)
	else --si existe
		if(exists(select 1 from personal.Especialidad where id_especialidad=@id_especialidad and borrado=1))  --si existe y esta borrada
			UPDATE personal.Especialidad
			set borrado=0
			where id_especialidad=@id_especialidad
		else --si existe y esta activa
			RAISERROR('YA EXISTE LA ESPECIALIDAD',5,5,'')
end
go


create or alter	procedure personal.insertarMedico  
(                
    @nombre_medico varchar(50),
    @apellido_medico varchar(50),
    @nombre_especialidad varchar(50),
	@nro_colegiado int
    --constraint fk_especialidad foreign key (id_especialidad) references personal.Especialidad(id_especialidad)
)
as
begin
	declare @id_especialidad int
	set @id_especialidad = (select id_especialidad from personal.Especialidad where nombre_especialidad=rtrim(rtrim(@nombre_especialidad)) and borrado=0)
	declare @id_medico int

	if(@id_especialidad is not null ) --la especialidad debe existir
	begin
		if(@nro_colegiado in(select nro_colegiado from personal.Medico where borrado=1)) --existe el medico pero esta dado de baja
		begin
			update personal.Medico
			set borrado=0
			where nro_colegiado=@nro_colegiado
		end
		else																			--no existe registro del medico
			insert into personal.Medico(nombre_medico,apellido_medico,nro_colegiado) values 
					(    
						ltrim(rtrim(@nombre_medico)),
						ltrim(rtrim(@apellido_medico)),
						@nro_colegiado
					)
		set @id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado)
		if(not exists(select 1 from personal.medico_especialidad where id_medico=@id_medico and id_especialidad=@id_especialidad))--creo la relacion medico especialidad
			insert into personal.medico_especialidad (id_medico,id_especialidad) values
				(@id_especialidad,
				@id_medico			
				)
	end
	else 
		RAISERROR('NO EXISTE LA ESPECIALIDAD',5,5,'')
end
go


create or alter	procedure servicio.insertarSede
(                
    @nombre_sede varchar(40),
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
		else	
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
    @nro_colegiado int,
    @nombre_sede varchar(50),
	@nombre_especialidad varchar(50),
    @dia varchar(10),
    @horario_inicio time(0),
	@horario_fin time(0)
)
as
begin
		declare @id_medico int,
				@id_sede int,
				@id_especialidad int
		set @id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado and borrado=0)
		set @id_especialidad=(select id_especialidad from personal.Especialidad where nombre_especialidad=ltrim(rtrim(@nombre_especialidad)) and borrado=0)
		set @id_sede =(select id_sede from servicio.Sede where nombre_sede=ltrim(rtrim(@nombre_sede)) and borrado=0)

		if(@id_medico is not null and @id_sede is not null and @id_especialidad is not null  --que exista la sede y el medico
			and @horario_fin>@horario_inicio 
			and @id_medico not in(select id_medico 
									from servicio.Dias_por_sede 
									where id_sede=@id_sede and dia=ltrim(rtrim(@dia))))  --que el medico no atienda ese dia en esa sede
		begin

			insert into servicio.Dias_por_sede values 
			(    
				@id_medico,
				@id_sede,
				@id_especialidad,
				@dia,
				@horario_inicio,
				@horario_fin
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
    @nro_colegiado int,
	@nombre_especialidad varchar(50),
    @nombre_sede varchar(50),
    @nombre_tipo_turno varchar(20),
    @nro_documento int
)
as
begin
	declare @id_medico int,
			@id_paciente int,
			@id_sede int,
			@id_especialidad int,
			@id_estado int,
			@id_tipo_turno int,
			@hora_inicio time(0),
			@hora_fin time(0),
			@dia varchar(10);
			
	set @id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado and borrado=0)
	set @id_especialidad=(select id_especialidad from personal.Especialidad where nombre_especialidad=ltrim(rtrim(@nombre_especialidad)) and borrado=0)
	set @id_sede =(select id_sede from servicio.Sede where nombre_sede=ltrim(rtrim(@nombre_sede)) and borrado=0)
	set @id_tipo_turno =(select id_tipo_turno from servicio.Tipo_turno where nombre_tipo_turno=ltrim(rtrim(@nombre_tipo_turno)))
	set @id_estado =(select id_estado from servicio.Estado_turno where nombre_estado='reservado')
	set @id_paciente =(select id_historia_clinica from datos_paciente.Paciente where nro_documento=@nro_documento and borrado=0)
	---Para poder saber si el medico atiende ese dia o no, tenemos que pasar el numero que nos devuelve weekday
	---de la fecha de a insertar a una cadena con el nombre correspondiente, 
	---por ejemplo, si nos da "3" entonces el dia es "miercoles" (por defecto 1 para lunes)	
	
	set @dia = case 
	when datepart(weekday, @fecha) = 1 then 'lunes'
	when datepart(weekday, @fecha) = 2 then 'martes'
	when datepart(weekday, @fecha) = 3 then 'miercoles'
	when datepart(weekday, @fecha) = 4 then 'jueves'
	when datepart(weekday, @fecha) = 5 then 'viernes'
	when datepart(weekday, @fecha) = 6 then 'sabado'
	when datepart(weekday, @fecha) = 7 then 'domingo'
	end
	
	set @hora_inicio = (select horario_inicio from servicio.Dias_por_sede 
							where id_medico=@id_medico and id_sede=@id_sede and 
								dia=ltrim(rtrim(@dia)) and id_especialidad=@id_especialidad)  --obtengo la hora de inicio de atencion de ese medico ese dia en la sede en esa especialidad
	set @hora_fin = (select horario_fin from servicio.Dias_por_sede 
							where id_medico=@id_medico and id_sede=@id_sede and 
								dia=ltrim(rtrim(@dia)) and id_especialidad=@id_especialidad) --obtengo horario de fin de atencion

	if (@hora_inicio is not null and @hora_fin is not null and 
		@hora<@hora_fin and @hora>@hora_inicio and @fecha>(convert(date,getdate()))  
		and DATEDIFF(minute,@hora_inicio, @hora)%15=0)--verifico que el horario sea multiplo de 15 minutos,que exista lo obtenido
	begin 
			if(@id_estado is not null and						
			@id_tipo_turno is not null and
			@id_paciente is not null)
			begin 
				if(not exists(select 1 from servicio.Reserva_de_turno_medico t inner join servicio.Estado_turno e on t.id_estado_turno=e.id_estado
						where t.fecha=@fecha and t.hora=@hora and t.id_medico=@id_medico and 
								t.id_sede=@id_sede and t.id_especialidad=@id_especialidad and 
								e.nombre_estado='reservado' and t.borrado=0))--verifico que no este asignado el turno
					begin
						insert into servicio.Reserva_de_turno_medico (fecha,hora,id_medico,id_especialidad,id_sede,id_estado_turno,id_tipo_turno,id_paciente) values 
						(    
							@fecha,
							@hora,
							@id_medico,
							@id_especialidad,
							@id_sede,
							@id_estado,
							@id_tipo_turno,
							@id_paciente
						)
					end
					else
						RAISERROR (N'turno ya asignado',5,5,'')
			end
			else
				RAISERROR (N'Error en valor de paciente, estado o tipo de turno',5,5,'')
	end
	else
		RAISERROR (N'dia u horario de atencion de especialidad y medico incorrecto',5,5,'')
end
go

create or alter proc personal.insertar_relacion_medico_especialidad
	(
		@nro_colegiado int,
		@nombre_especialidad varchar(50)
	)
AS
BEGIN
	declare @id_medico int,
			@id_especialidad int

	set @id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado and borrado=0)
	set @id_especialidad=(select id_especialidad from personal.Especialidad where nombre_especialidad=@nombre_especialidad and borrado=0)
	if(@id_medico is not null and @id_especialidad is not null)
		insert into personal.medico_especialidad values
		(
			@id_medico,
			@id_especialidad
		)
	else
		RAISERROR('ERROR EN CREAR RELACION',5,5,'')
END
go
-----MODIFIES----------------------


create or alter procedure datos_paciente.modificarFotoPaciente
(
	@nro_documento int,
    @dir_foto_perfil varchar(100),
	@usuario_actualizacion varchar(30)
)
as
begin
	
	update datos_paciente.Paciente
	set dir_foto_perfil = @dir_foto_perfil
	where nro_documento = @nro_documento
	
	update datos_paciente.Paciente
	set usuario_actualizacion = @usuario_actualizacion 
	where nro_documento = @nro_documento

	update datos_paciente.Paciente
	set fecha_actualizacion = convert(date,getdate())
	where nro_documento = @nro_documento
end
go



create or alter procedure datos_paciente.modificarTelPaciente
(
	@nro_documento int,
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
		where nro_documento = @nro_documento
	end

	if(@tipo = 'alternativo' collate SQL_Latin1_General_CP1_CI_AS)
	begin
		update datos_paciente.Paciente
		set tel_alternativo = @tel
		where nro_documento = @nro_documento
	end

	if(@tipo = 'laboral' collate SQL_Latin1_General_CP1_CI_AS)
	begin
		update datos_paciente.Paciente
		set tel_laboral = @tel
		where nro_documento = @nro_documento
	end
	update datos_paciente.Paciente
	set usuario_actualizacion = @usuario_actualizacion 
	where nro_documento = @nro_documento

	update datos_paciente.Paciente
	set fecha_actualizacion = convert(date,getdate())
	where nro_documento = @nro_documento
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
    @nro_documento int
)
as
begin
	declare @id_paciente int
	set @id_paciente= (select id_historia_clinica from datos_paciente.Paciente where nro_documento = @nro_documento)
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
	@nombre_prestador int,
    @estado bit 
)
as
begin

	if(@estado = 1 or
		@estado = 0)
	begin
			update comercial.Prestador
			set borrado = @estado
			where nombre_prestador=ltrim(rtrim(@nombre_prestador))
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
	@nombre_prestador varchar(50),
    @nombre_plan varchar(50),
    @nro_documento int
)
as
begin
	declare @id_plan int,
			@id_prestador int,
			@id_paciente int
	set @id_plan= (select id_plan from comercial.Plan_Prestador where nombre_plan=@nombre_plan and  borrado=0)
	set @id_prestador = (select id_prestador from comercial.Prestador  where nombre_prestador=@nombre_prestador and borrado=0)
	set @id_paciente= (select id_historia_clinica from datos_paciente.Paciente where nro_documento = @nro_documento)
	
	if(@id_plan is not null and @id_prestador is not null)
	begin
		update datos_paciente.Cobertura
		set id_plan = @id_plan,
			id_prestador=@id_prestador
		where id_paciente = @id_paciente
	end
	else 
		RAISERROR('ERROR MODIFICACION NO REALIZADA',5,5,'')
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


create or alter procedure servicio.modificarDireccionSede
(   
	@nombre_sede varchar(50),
    @direccion_sede varchar(30)
)
as
begin
		update servicio.Sede
		set direccion_sede = @direccion_sede
		where nombre_sede = ltrim(rtrim(@nombre_sede))
end
go



create or alter procedure servicio.modificarReservaTipoTurno
(   
	@id_turno int,
    @id_tipo_turno int
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
	@nro_documento int,
	@fecha_anterior date,
	@hora_anterior time(0),
    @fecha date,
    @hora time(0)
)
as
begin
	declare @dia varchar(10); 
	declare @hora_inicio time(0);
	declare @hora_fin time(0)
	declare @id_sede int;
	declare @id_medico int;
	declare @id_especialidad int;
	declare @id_turno int
	declare @id_paciente int
	declare @id_tipo_turno int

	--obtengo los datos del turno que tenia
	set @id_paciente =(select id_historia_clinica from datos_paciente.Paciente where nro_documento=@nro_documento and borrado=0)
	set @id_turno = (select id_turno from servicio.Reserva_de_turno_medico where fecha=@fecha_anterior and hora=@hora_anterior and borrado=0 and id_paciente=@id_paciente)
	set @id_medico=(select id_medico from servicio.Reserva_de_turno_medico where id_turno=@id_turno and borrado=0)
	set @id_especialidad=(select id_especialidad from servicio.Reserva_de_turno_medico where id_turno=@id_turno and borrado=0)
	set @id_sede =(select id_sede from servicio.Reserva_de_turno_medico where id_turno=@id_turno and borrado=0)
	set @id_tipo_turno =(select id_tipo_turno from servicio.Reserva_de_turno_medico where id_turno=@id_turno and borrado=0)
	
		
	
	if(@id_sede is not null and @id_medico is not null and @id_especialidad is not null)
	begin
		set @dia = case 
		when datepart(weekday, @fecha) = 1 then 'lunes'
		when datepart(weekday, @fecha) = 2 then 'martes'
		when datepart(weekday, @fecha) = 3 then 'miercoles'
		when datepart(weekday, @fecha) = 4 then 'jueves'
		when datepart(weekday, @fecha) = 5 then 'viernes'
		when datepart(weekday, @fecha) = 6 then 'sabado'
		when datepart(weekday, @fecha) = 7 then 'domingo'
		end
						
		set @hora_inicio = (select horario_inicio from servicio.Dias_por_sede 
							where id_medico=@id_medico and id_sede=@id_sede and 
								dia=ltrim(rtrim(@dia)) and id_especialidad=@id_especialidad) --obtengo horario inicio atencion
		set @hora_fin = (select horario_fin from servicio.Dias_por_sede 
							where id_medico=@id_medico and id_sede=@id_sede and 
								dia=ltrim(rtrim(@dia)) and id_especialidad=@id_especialidad) --obtengo horario de fin de atencion

		if (@hora_inicio is not null and @hora_fin is not null and 
		@hora<@hora_fin and @hora>@hora_inicio and @fecha>(convert(date,getdate()))  
		and DATEDIFF(minute,@hora_inicio, @hora)%15=0)--verifico que el horario sea multiplo de 15 minutos,que exista lo obtenido
		begin 
			if(	
			@id_tipo_turno is not null and
			@id_paciente is not null)
			begin 
				if(not exists(select 1 from servicio.Reserva_de_turno_medico t inner join servicio.Estado_turno e on t.id_estado_turno=e.id_estado
						where t.fecha=@fecha and t.hora=@hora and t.id_medico=@id_medico and 
								t.id_sede=@id_sede and t.id_especialidad=@id_especialidad and 
								e.nombre_estado='reservado' and t.borrado=0))--verifico que no este asignado el turno
				
				begin
				update servicio.Reserva_de_turno_medico
				set hora=@hora,
					fecha=@fecha,
					borrado=0
				where id_turno=@id_turno
				end
				else
					RAISERROR('Error fecha y hora no disponible',10,5,'')
			end
			else
				RAISERROR('error nro documento',10,5,'')
		end
		else
		   RAISERROR('fecha u hora incorrectos',10,5,'')
	end
	else 
		RAISERROR('medico, sede o especialidad inexistente',10,5,'')
end
go


create or alter procedure servicio.modificarReservaEstadoTurno
(   
	@fecha date,
	@hora time(0),
	@nro_documento int,
	@nombre_estado varchar(10)
)
as
begin
	declare @id_estado_turno int
	declare @id_paciente int
		set @id_paciente = (select id_historia_clinica 
							from datos_paciente.Paciente
							where nro_documento = @nro_documento)
	set @id_estado_turno = (select id_estado from servicio.Estado_turno where nombre_estado=@nombre_estado)
	update servicio.Reserva_de_turno_medico
	set id_estado_turno = @id_estado_turno
	where fecha=@fecha and hora=@hora and id_paciente=@id_paciente
	if(@nombre_estado='cancelado')
	begin
		update servicio.Reserva_de_turno_medico
		set borrado=1
		where fecha=@fecha and hora=@hora and id_paciente=@id_paciente
	end
end
go


------DELETES--------------



create or alter procedure datos_paciente.eliminarPaciente -- NO VOY A BORRAR FISICAMENTE LOS PACIENTES, UTILIZAMOS BORRADO LOGICO con el campo borrado
(   
	@nro_documento int
)
as
begin
	declare @id_paciente int,
			@id_estado int
	set @id_paciente=(select id_historia_clinica from datos_paciente.Paciente where nro_documento=@nro_documento)
	set @id_estado =(select id_estado from servicio.Estado_turno where nombre_estado='cancelado')
	
	update datos_paciente.Paciente
	set borrado=1							 -- 1 indica que el paciente esta borrado
	where id_historia_clinica=@id_paciente

	update servicio.Reserva_de_turno_medico  --borra los turnos que tenia asignados
	set borrado=1,
		id_estado_turno=@id_estado	
	where id_paciente=@id_paciente
end
go


/*Los prestadores están conformador por Obras Sociales y Prepagas con las cuales se establece una
alianza comercial. Dicha alianza puede finalizar en cualquier momento, por lo cual debe poder ser
actualizable de forma inmediata si el contrato no está vigente. En caso de no estar vigente el contrato,
deben ser anulados todos los turnos de pacientes que se encuentren vinculados a esa prestadora y
pasar a estado disponible.*/
create or alter procedure comercial.eliminarPrestador   --utilizamos borrado logico 
(   
	@nombre_prestador int
)
as
begin
	declare @id_prestador int,
			@id_estado int
	set @id_estado =(select id_estado from servicio.Estado_turno where nombre_estado='cancelado')
	set @id_prestador = (select id_prestador 
						from comercial.Prestador
						where nombre_prestador=@nombre_prestador)
	update comercial.Prestador
	set borrado=1                  --borrado logico
	where id_prestador=@id_prestador

	update servicio.Reserva_de_turno_medico                        
	set borrado=1,--borra los turnos asignados a ese prestador de forma logica y se pueden utilizar para otro paciente
		id_estado_turno=@id_estado
	where id_paciente in(select id_paciente from datos_paciente.Cobertura where id_prestador=@id_prestador)
end
go



create or alter procedure comercial.eliminarPlan  --borrado logico
(   
	@nombre_plan varchar(50)
)
as
begin

	declare @id_plan int,
			@id_estado int
	set @id_estado =(select id_estado from servicio.Estado_turno where nombre_estado='cancelado')
	set @id_plan = (select id_plan 
						from comercial.Plan_Prestador
						where nombre_plan =@nombre_plan )
	update comercial.Plan_Prestador
	set borrado=1                  --borrado logico
	where id_plan=@id_plan

	update servicio.Reserva_de_turno_medico                        
	set borrado=1,--borra los turnos asignados a ese prestador de forma logica y se pueden utilizar para otro paciente
		id_estado_turno=@id_estado
	where id_paciente in(select id_paciente from datos_paciente.Cobertura where id_plan=@id_plan)
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
	@fecha date,
	@hora time(0),
	@nro_documento int
)
as
begin
	declare @id_paciente int,
			@id_estado int
	set @id_paciente=(select id_historia_clinica from datos_paciente.Paciente where nro_documento=@nro_documento)
	set @id_estado =(select id_estado from servicio.Estado_turno where nombre_estado='cancelado')
	update servicio.Reserva_de_turno_medico
	set borrado=1,
		id_estado_turno=@id_estado
	where fecha=@fecha and hora=@hora and id_paciente=@id_paciente

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



create or alter procedure servicio.eliminarEstadoTurno
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
create or alter proc servicio.eliminarDiasporsede(
	@nro_colegiado int,
    @nombre_sede varchar(50),
	@nombre_especialidad varchar(50),
    @dia varchar(10)
)
as
begin
		declare @id_medico int,
				@id_sede int,
				@id_especialidad int
		set @id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado and borrado=0)
		set @id_especialidad=(select id_especialidad from personal.Especialidad where nombre_especialidad=ltrim(rtrim(@nombre_especialidad)) and borrado=0)
		set @id_sede =(select id_sede from servicio.Sede where nombre_sede=ltrim(rtrim(@nombre_sede)) and borrado=0)
		
		delete from servicio.Dias_por_sede
		where id_medico=@id_medico and id_especialidad=@id_especialidad and dia=ltrim(rtrim(@dia))
end
go

create or alter procedure personal.eliminarEspecialidad  --borrado logico
(   
	@nombre_especialidad varchar(50)
)
as
begin
	declare @id_especialidad int
	set @id_especialidad = (select id_especialidad from personal.Especialidad where nombre_especialidad=@nombre_especialidad)

	if(@id_especialidad is not null and not exists(select 1 from personal.Medico m inner join personal.medico_especialidad me  --verifica que exista la especialidad y que no haya medicos activos en esa especialidad
													on m.id_medico=me.id_medico
													where me.id_especialidad=@id_especialidad and m.borrado=0))  
		update personal.Especialidad
		set borrado=1
		where id_especialidad = @id_especialidad
	else
		RAISERROR('NO SE PUEDE ELIMINAR',5,5,'')

end
go



create or alter procedure personal.eliminarMedico   --BORRADO LOGICO ok
(   
	@nro_colegiado int
)
as
begin
	
	update personal.Medico
	set borrado=1
	where nro_colegiado=@nro_colegiado;

	update servicio.Reserva_de_turno_medico   --borrado logico de turnos
	set borrado=1
	where id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado)

	delete from personal.medico_especialidad                                             --borramos la relacion medico_especialidad
	where id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado)
	
	delete from servicio.Dias_por_sede														--borramos dias por sede
	where id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado)
	
end
go



create or alter procedure servicio.eliminarSede   --borrado logico
(   
	@nombre_sede varchar(40)
)
as
begin
	declare @id_sede int
	set @id_sede =(select id_sede from servicio.Sede where nombre_sede=@nombre_sede)
	update servicio.Sede
	set borrado=1
	where id_sede=@id_sede

	delete from servicio.Dias_por_sede														--borramos dias por sede
	where id_sede=@id_sede
end
go


create or alter procedure datos_paciente.eliminarCoberturaPaciente
(   
	@nro_documento int
)
as
begin

	delete datos_paciente.Cobertura
	where id_paciente in(select id_historia_clinica from datos_paciente.Paciente where nro_documento=@nro_documento)

end
go

create or alter proc servicio.autorizar_estudio(@estudio varchar(max),@plan varchar(max),@nro_documento int)
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
		set autorizado=@porcentaje_cobertura + ' %',
			costo=@costo
		where id_paciente in(select id_paciente from datos_paciente.Paciente where nro_documento=@nro_documento) and nombre_estudio=@estudio 
		
	else
		update servicio.Estudio
		set autorizado='no autoriza'
		where id_paciente in(select id_paciente from datos_paciente.Paciente where nro_documento=@nro_documento)and nombre_estudio=@estudio
end
go

