/* Script CREACION DE SP de insercion, modificacion y eliminacion 

MATERIA BBDDA COMISION 5600 
GRUPO NRO 16 fauto

ALUMNOS:
	ARAGON, RODRIGO EZEQUIEL 43509985
	LA GIGLIA RODRIGO ARIEL DNI 33334248

*/
use Com5600G16
go
--FUNCIONES--
-- función para validar números de teléfono
CREATE OR ALTER FUNCTION personal.ValidarNumeroTelefono(@numero VARCHAR(30))
RETURNS BIT
AS
BEGIN
    DECLARE @es_valido BIT
    -- Usar PATINDEX para comprobar un patrón complejo del número de teléfono con guiones y parentesis, los elimina y verfica luego la longitus
    IF PATINDEX('%[^0-9()\- ]%', @numero) = 0 
       AND LEN(REPLACE(REPLACE(REPLACE(@numero, ' ', ''), '-', ''), '(', '')) BETWEEN 8 AND 14
        SET @es_valido = 1
    ELSE
        SET @es_valido = 0
    RETURN @es_valido
END
GO
--funcion para validar mail
CREATE OR ALTER FUNCTION personal.ValidarCorreoElectronico(@correo VARCHAR(250))
RETURNS BIT
AS
BEGIN
    DECLARE @es_valido BIT
    -- Usar LIKE para comprobar el patrón del correo electrónico
    IF @correo LIKE '%_@_%_.__%'
        SET @es_valido = 1
    ELSE
        SET @es_valido = 0
    RETURN @es_valido
END
GO


-----STORED PROCEDURES------------
-----INSERTS----------------------


 
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
	declare @error varchar(150)
	set @error = ' '
	

	if(ltrim(rtrim(@Sexo_biologico)) <> 'masculino' and            
		ltrim(rtrim(@Sexo_biologico)) <> 'femenino' )
		set @error = '| sexo biologico | '

	if(ltrim(rtrim(@nombre))='' or ltrim(rtrim(@nombre)) is null)              
		set @error = @error + '| nombre | ' 
	
	if(ltrim(rtrim(@apellido))='' or ltrim(rtrim(@apellido)) is null)               
		set @error = @error +'| apellido | '

	--si se ingresa un telefono (no esta vacio y no es nulo) lo valida
	if((ltrim(rtrim(@Tel_fijo))<>'' or @Tel_fijo is not null) and 
		personal.ValidarNumeroTelefono(ltrim(rtrim(@Tel_fijo)))=0)
		set @error = @error +'| telefono fijo | '

	if((ltrim(rtrim(@Tel_alternativo))<>'' or @Tel_alternativo is not null) or 
		personal.ValidarNumeroTelefono(ltrim(rtrim(@Tel_alternativo)))=0)
		set @error = @error +'| telefono fijo | '

	if((ltrim(rtrim(@Tel_laboral))<>'' or @Tel_laboral is not null) and 
		personal.ValidarNumeroTelefono(ltrim(rtrim(@Tel_laboral)))=0)
		set @error = @error +'| telefono fijo | '

	if(@Mail is not null and personal.ValidarCorreoElectronico(LTRIM(RTRIM(@Mail)))=0) --si ingresa un mail lo valida
		set @error = @error +'| mail | '

	if(@NroDoc is null or @NroDoc<10000000 or @NroDoc>999999999)
		set @error = @error + '| nro documento | '

	if(@Fecha_nacimiento is not null and @Fecha_nacimiento>(convert(date,getdate()))) --no inserta fecha mayor a la actual
		set @error = @error + '| fecha |'

	if(exists(select 1			-- verifica que el nro doc no se repita
				from datos_paciente.Paciente
				where nro_documento=@NroDoc))
		set @error = @error + '| nro documento ya existe | '
			
	if(@Tipo_documento not in('DNI','PAS'))
		set @error = @error + '| tipo de documento | '	

	if(@error = ' ')
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
			begin
				set @error = 'Valor/es ingresado/s no valido/s:  '+ @error
				RAISERROR(@error,5,5,'')
			end

end
go



create or alter procedure datos_paciente.insertarUsuario     --recibe la dni del paciente y una contrasenia
(
    
    @dni_paciente int,
	@contrasenia varchar(20)
)
as
begin
	declare @error varchar(150)
	set @error = ' '

	declare @id_paciente int
	set @id_paciente = (select id_historia_clinica from datos_paciente.Paciente where nro_documento=@dni_paciente and borrado=0)
	if(@id_paciente is null)	
		set @error = @error + '| NO EXISTE UN PACIENTE ACTIVO CON EL DNI INGRESADO | '
	if(exists(select 1 from datos_paciente.Usuario where id_paciente=@id_paciente))  --ya existe usuario creado
		set @error = @error +'| YA EXISTE EL USUARIO |'
	if(@contrasenia is null or  len(@contrasenia)<=8)           --contrasenia de menos de 8 caracteres o null
		set @error = @error +'| PASSWORD INVALIDA |'
	if(@error = ' ')
		insert into datos_paciente.Usuario (id_usuario,contrasenia,id_paciente)
			values
			(
				@dni_paciente,   --el usuario es el nro de dni
				@contrasenia,
				@id_paciente
			)
	else
		begin
			set @error = 'ERROR:  '+ @error
			RAISERROR(@error,5,5,'')
		end	
end
go


create or alter procedure datos_paciente.insertarDomicilio
( 
    @calle varchar(50),
    @numero int,
    @piso int,
    @departamento char(1), -- puede ser letra o numero
    @cp smallint,
    @pais varchar(50),
    @provincia varchar(50),
    @localidad varchar(50),
    @dni_paciente int
    
)
as
begin
	declare @error varchar(150)
	set @error = ' '
	declare @id_paciente int
	set @id_paciente = (select id_historia_clinica
						from datos_paciente.Paciente
						where nro_documento=@dni_paciente and borrado=0)
	if (@id_paciente is null)
		set @error = @error + '| NO EXISTE UN PACIENTE ACTIVO CON EL DNI INGRESADO |'
	if (@CP is NOT null and @CP > 10000)
		set @error = @error + '| CODIGO POSTAL ERRONEO |'
	if(exists(select 1 from datos_paciente.Domicilio where id_paciente=@id_paciente))
		set @error = @error + '| YA POSEE UN DOMICILIO |'
	if(ltrim(rtrim(@pais))='' or ltrim(rtrim(@localidad))='' or ltrim(rtrim(@provincia))='' or ltrim(rtrim(@calle))='')
		set @error = @error + '| DOMICILIO NO VALIDO |'
	if(@error = ' ')
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
	else
		begin
			set @error = 'ERROR:  '+ @error
			RAISERROR(@error,5,5,'')
		end	
end
go


create or alter procedure comercial.insertarPrestador  --por default el prestador se crea activo
( 
    @nombre_prestador varchar (50)
)
as
begin
		declare @error varchar(150)
		set @error = ' '
		set @nombre_prestador = ltrim(rtrim(@nombre_prestador))
		if( @nombre_prestador is null or  ltrim(rtrim(@nombre_prestador)) ='')
			set @error = @error + '| nombre no valido |'
		if exists(select 1 from comercial.Prestador where nombre_prestador=@nombre_prestador and borrado=0)    --evito insercion de prestadores repetidos
			set @error = @error + '| ya existe el prestador |'
		if(@error=' ')
		begin
			if exists(select 1 from comercial.Prestador where nombre_prestador=@nombre_prestador and borrado=1) --si existe pero esta borrado lo reactiva
			begin
				update comercial.Prestador
				set borrado=0
				where nombre_prestador=@nombre_prestador
			end
			else                                                                  --si no existe
				insert into comercial.Prestador (nombre_prestador) values
				(
				upper(@nombre_prestador)
				)
		end
		else 
			begin
			set @error = 'ERROR:  '+ @error
			RAISERROR(@error,5,5,'')
		end	
end
go

create or alter	procedure comercial.insertarPlanPrestador 
(                
    @nombre_prestador varchar(50),
    @nombre_plan varchar (50)
)
as
begin
	declare @error varchar(150)
	set @error = ' '
	set @nombre_plan=ltrim(rtrim(@nombre_plan))
	set @nombre_prestador=ltrim(rtrim(@nombre_prestador))
	--verifico que exista el prestador, evito que se inserte un plan repetido o vacio
	declare @id_prestador int
	set @id_prestador = (select id_prestador 
						from comercial.Prestador
						where nombre_prestador=@nombre_prestador and borrado = 0 )

	if(@id_prestador is null)			--debe existir el prestador
		set @error = @error + '| no existe un prestador activo con ese nombre |'	
	if(@nombre_plan='')
		set @error = @error +'| nombre de plan no valido |'	
	if(@error=' ')
		if(@nombre_plan in(select nombre_plan 
								from comercial.Plan_Prestador 
								where id_prestador=@id_prestador and borrado=0))
			RAISERROR('| Ya existe un plan activo con ese nombre |',5,5,'')
		else
			if(@nombre_plan in(select nombre_plan 
									from comercial.Plan_Prestador 
									where id_prestador=@id_prestador and borrado=1))
				update comercial.Plan_Prestador  --si existe y esta borrado lo reactivo
				set borrado=0
				where nombre_plan=@nombre_plan
			else
				insert into comercial.Plan_Prestador (id_prestador,nombre_plan) values
				(@id_prestador, upper(@nombre_plan))
	else
		begin
			set @error = 'ERROR : ' + @error
			RAISERROR(@error,5,5,'')
		end
end
go


create or alter	procedure datos_paciente.insertarCobertura
(                
    @dir_imagen_credencial varchar(100), -- direccion de la imagen
    @nro_socio int,      
    @nombre_prestador varchar(50),
    @nombre_plan varchar(50),
    @nro_documento int
        
)
as
begin
	declare @id_prestador int,
			@id_plan int,
			@id_paciente int
	declare @error varchar(150)
	set @error = ' '
	set @id_prestador = (select id_prestador from comercial.Prestador where borrado=0 and nombre_prestador=@nombre_prestador)
	set @id_plan = (select id_plan from comercial.Plan_Prestador where borrado=0 and nombre_plan=@nombre_plan and id_prestador=@id_prestador)
	set @id_paciente = (select id_historia_clinica from datos_paciente.Paciente where borrado=0 and nro_documento=@nro_documento)
	
	--verifica que exista el prestador, el plan y el paciente
	if(@nro_socio is null or @nro_socio < 1)
		set @error = @error + '| nro de socio no valido |'
	if(@id_prestador is null)
		set @error = @error + '| nombre prestador no valido |'
	if(@id_plan is null)
		set @error = @error + '| nombre plan no valido |'
	if(@id_paciente is null)
		set @error = @error + '| dni paciente no valido |'
	if(@id_paciente in(select id_paciente from datos_paciente.Cobertura))--no permite la insercion de mas de una cobertura para un paciente
		set @error = @error + '| el paciente ya tiene cobertura |'
	if(@error=' ')
		insert into datos_paciente.Cobertura(dir_imagen_credencial,nro_socio,id_prestador,id_plan,id_paciente) values 
		(    
			ltrim(rtrim(@dir_imagen_credencial)),
			@nro_socio,      
			@id_prestador,
			@id_plan,
			@id_paciente
		)
	else
		begin
			set @error = 'ERROR : ' + @error
			RAISERROR(@error,5,5,'')
		end
end
go


create or alter	procedure servicio.insertarEstudio
(   
	@nro_documento int,
    @fecha_estudio date,
    @nombre_estudio varchar(200),
    @autorizado varchar(10),
	@imagen_resultado varchar(100),
	@documento_resultado varchar(100)
)
as
begin
	declare @id_paciente int,
			@error varchar(150)
	set @error = ' '
	set @nombre_estudio = ltrim(rtrim(@nombre_estudio))
	set @autorizado = ltrim(rtrim(@autorizado))
	set @id_paciente = (select id_historia_clinica from datos_paciente.Paciente where borrado=0 and nro_documento=@nro_documento)
	if(@nombre_estudio is null or @nombre_estudio ='')
		set @error = @error + '| nombre de estudio invalido |'
	if(@autorizado is null or @autorizado='')
		set @autorizado = 'pendiente'
	if(@id_paciente is null)
		set @error = @error + '| nro documento no valido |'
	if(@fecha_estudio is null or @fecha_estudio = '')
		set @error = @error + '| fecha no valida |'
	if(exists(select 1 from servicio.Estudio 
				where fecha_estudio=@fecha_estudio and 
				nombre_estudio=@nombre_estudio and borrado=0))  --no permite mas de un estudio igual al mismo paciente en el mismo momento, y el paciente debe estar activo
		set @error = @error + '| el paciente ya tiene otro turno asignado otro turno en la fecha indicada |'
	if(@error=' ')
		insert into servicio.Estudio(fecha_estudio,nombre_estudio,autorizado,id_paciente,imagen_resultado,documento_resultado) values 
		(    
			@fecha_estudio,
			@nombre_estudio,
			@autorizado,
			@id_paciente,
			ltrim(rtrim(@imagen_resultado)),
			ltrim(rtrim(@documento_resultado))
		)
	else
		begin
			set @error = 'ERROR : ' + @error
			RAISERROR(@error,5,5,'')
		end
end
go


create or alter	procedure servicio.insertarEstadoTurno
(                
    @nombre_estado varchar(10)
)
as
begin
		set @nombre_estado = ltrim(rtrim(@nombre_estado))
		if(@nombre_estado not in('reservado','atendido', 'ausente', 'cancelado'))
			RAISERROR('ERROR ESTADO NO VALIDO',5,5,'')
		else
		begin
			if(not exists(select 1 from servicio.Estado_turno where nombre_estado=@nombre_estado))
			insert into servicio.Estado_turno values 
			(    
				@nombre_estado    --valores validos ('reservado','atendido', 'ausente', 'cancelado')
			)
			else 
			RAISERROR('ERROR YA EXISTE EL ESTADO',5,5,'')
		end
end
go


create or alter	procedure servicio.insertarTipoTurno
(                
    @nombre_tipo_turno varchar(10)
)
as
begin
	set @nombre_tipo_turno = ltrim(rtrim(@nombre_tipo_turno))
	if(@nombre_tipo_turno is null or  @nombre_tipo_turno='' or @nombre_tipo_turno not in('presencial', 'virtual'))
		RAISERROR('Tipo de turno no valido',5,5,'')
	else
		if(exists(select 1 from servicio.Tipo_turno where nombre_tipo_turno= @nombre_tipo_turno ))
			RAISERROR('YA EXISTE EL TIPO de turno',5,5,'')
		else
			insert into servicio.Tipo_turno values 
			(    
				ltrim(rtrim(@nombre_tipo_turno))
			) 
end
go


create or alter	procedure personal.insertarEspecialidad
(                
    @nombre_especialidad varchar(30)
)
as
begin
	declare @id_especialidad int
	set @nombre_especialidad = LTRIM(rtrim(@nombre_especialidad))
	set @id_especialidad = (select id_especialidad from personal.Especialidad where nombre_especialidad=@nombre_especialidad)
	
	if(@nombre_especialidad is null or @nombre_especialidad='')
		RAISERROR('Nombre de especialidad no valido',5,5,'')
	else
	begin
	if(@id_especialidad is null)			--la especialidad no existe //no inserta duplicados
				insert into personal.Especialidad (nombre_especialidad) values 
				(    
					UPPER(@nombre_especialidad)
				)
		else --si existe
			if(exists(select 1 from personal.Especialidad where id_especialidad=@id_especialidad and borrado=1))  --si existe y esta borrada
				UPDATE personal.Especialidad
				set borrado=0
				where id_especialidad=@id_especialidad
			else --si existe y esta activa
				RAISERROR('YA EXISTE LA ESPECIALIDAD',5,5,'')
	end
end
go


create or alter	procedure personal.insertarMedico  
(                
    @nombre_medico varchar(50),
    @apellido_medico varchar(50),
    @nombre_especialidad varchar(50),
	@nro_colegiado int
)
as
begin
	set @nombre_medico = ltrim(rtrim(@nombre_medico))
	set @apellido_medico = ltrim(rtrim(@apellido_medico))
	set @nombre_especialidad = ltrim(rtrim(@nombre_especialidad))
	
	declare @id_especialidad int,
			@id_medico int,
			@error varchar(150),
			@error_medico_dupli varchar(150)
	set @error = ' '
	set @error_medico_dupli = ' '
	set @id_especialidad = (select id_especialidad from personal.Especialidad where nombre_especialidad=@nombre_especialidad and borrado=0)
	
	if(@nro_colegiado is null)
		set @error = '| Nro de colegiado no valido |'
	if(@nombre_medico is null or @nombre_medico='')
		set @error = '| Nombre de medico no valido |'
	if(@apellido_medico is null or @apellido_medico='')
		set @error = '| Apellido medico no valido |'				
	
	if(@nombre_especialidad is null or @nombre_especialidad='')
		set @error = '| Nombre de especialidad no valido |'
	else
		if(@id_especialidad is null )        --no existe la especialidad o no esta activa 
			exec personal.insertarEspecialidad @nombre_especialidad    --inserta la especialidad
	
	if(@error=' ')
	begin
		
		if(exists(select 1 from personal.Medico 
			      where nro_colegiado=@nro_colegiado and borrado=1)) --existe el medico pero esta dado de baja
			update personal.Medico
			set borrado=0
			where nro_colegiado=@nro_colegiado
		else				    --si no, puede ser que no exista o que exista y este activo						
		begin
			if(not exists(select 1 from personal.Medico		--no existe registro del medico
							where nro_colegiado=@nro_colegiado))
				insert into personal.Medico(nombre_medico,apellido_medico,nro_colegiado) values 
						(    
							@nombre_medico,
							@apellido_medico,
							@nro_colegiado
						)
			else   --el medico existe, no lo inserta duplicado, lo advierte
				set @error_medico_dupli = @error_medico_dupli + '| El nro de colegiado ya existe |' 
		end
		--en este punto ya se actualizo el medico, se inserto o ya existia entonces creo la relacion medico especialidad
		set @id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado)  

		if(not exists(select 1 from personal.medico_especialidad     --si no existe la relacion la creo
							where id_medico=@id_medico and id_especialidad=@id_especialidad))
		begin
			insert into personal.medico_especialidad (id_medico,id_especialidad) values
				(
				 @id_medico,
				 @id_especialidad
				)
			if(@error_medico_dupli<>' ')	--informa que aunque el medico ya existia con anterioridad igualmente agrego la relacion con especialidad
				set @error_medico_dupli = @error_medico_dupli + '|igualemnte se agrego la especialidad |'
		end
		if(@error_medico_dupli<>' ')
			begin
			set @error_medico_dupli = 'Advertencia: '+ @error_medico_dupli
			RAISERROR(@error_medico_dupli,5,5,'')
			end
	end
	else 
		begin
		set @error = 'Error: '+ @error
		RAISERROR(@error,5,5,'')
		end
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
	declare @error varchar(150)
	set @error = ' '
	set @nombre_sede = ltrim(rtrim(@nombre_sede))
	set @direccion_sede = ltrim(rtrim(@direccion_sede))
	set @localidad_sede = ltrim(rtrim(@localidad_sede))
	set @provincia_sede = ltrim(rtrim(@provincia_sede))
	
	if(@nombre_sede is null or @nombre_sede= ' ')
		set @error = @error + '| nombre de sede |' 
	if(@direccion_sede is null or @direccion_sede= ' ')
		set @error = @error + '| direccion de sede |' 
	if(@localidad_sede is null or @localidad_sede= ' ')
		set @error = @error + '| localidad de sede |' 
	if(@provincia_sede is null or @provincia_sede= ' ')
		set @error = @error + '| provincia de sede |' 
	if(exists(select 1 from servicio.Sede where nombre_sede=@nombre_sede and borrado=0))--existe y esta activa
		set @error = @error + '| la sede ya existe |' 
	if(@error=' ') --puede ser que exista y este inactiva o que no exista
		if(exists(select 1 from servicio.Sede where nombre_sede=@nombre_sede and borrado=1))  --si ya existia pero estaba con borrado logico la vuelve a dar de alta
			update servicio.Sede
			set borrado=0,
				direccion_sede=@direccion_sede,
				localidad_sede=@localidad_sede,
				provincia_sede=@provincia_sede
			where nombre_sede=@nombre_sede
		else	            --la sede no existe
			insert into servicio.Sede(nombre_sede, direccion_sede, localidad_sede,provincia_sede) values 
			(    
				@nombre_sede,
				@direccion_sede,
				@localidad_sede,
				@provincia_sede
			)
	else
	begin
		set @error = 'Error: ' + @error
		RAISERROR(@error,5,5,'')
	end
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
				@id_especialidad int,
				@error varchar(150)
	set @error = ' '
	set @nombre_sede = ltrim(rtrim(@nombre_sede))
	set @nombre_especialidad = ltrim(rtrim(@nombre_especialidad))
	set @dia = ltrim(rtrim(@dia))
	
	set @id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado and borrado=0)
	set @id_especialidad=(select id_especialidad from personal.Especialidad where nombre_especialidad=@nombre_especialidad and borrado=0)
	set @id_sede =(select id_sede from servicio.Sede where nombre_sede=@nombre_sede and borrado=0)

	if(@id_medico is null)
		set @error = @error + '| medico |' 
	if(@id_especialidad is null)
		set @error = @error + '| especialidad |' 
	if(@id_sede is null)
		set @error = @error + '| sede |' 
	if(@dia not in('lunes','martes','miercoles','jueves','viernes','sabado'))
		set @error = @error + '| dia |'
	if(@error = ' ' and not exists(select 1 from personal.medico_especialidad    -- el medico no atiende la especialidad
											where id_especialidad=@id_especialidad 
													and id_medico=@id_medico))
		set @error = @error + '| el medico no atiende la especialidad indicada |'
	
	if(@error=' ' and exists(select 1 from servicio.Dias_por_sede where dia=@dia)) --no inserta duplicados de atencion medico por dia
		set @error =  @error + '| el medico ya atiende ese dia en la sede indicada |'
	
	if(@horario_inicio is null or @horario_fin is null or 
		@horario_inicio>@horario_fin or (@horario_inicio not between '08:00' and '18:00')
									or (@horario_fin not between '11:00' and '20:00'))  --el rango horario de atencion es de 8 a 20 hs
		set @error = @error + '| horario inicio-fin |'
	if(@error=' ')   --los valores son validos
			insert into servicio.Dias_por_sede values 
			(    
				@id_medico,
				@id_sede,
				@id_especialidad,
				@dia,
				@horario_inicio,
				@horario_fin
			)
	else
		begin
			set @error = 'Error: ' + @error
			RAISERROR(@error,5,5,'')
		end
end
go



create or alter	procedure servicio.insertarReservaTurno
(                
    @fecha date,
    @hora time(0),
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
			@id_tipo_turno int,
			@hora_inicio time(0),
			@hora_fin time(0),
			@dia varchar(10),
			@error varchar(200),
			@id_estado_turno int
	set @error = ' '
	set @id_estado_turno = (select id_estado from servicio.Estado_turno where nombre_estado='reservado')
	set @dia = ltrim(rtrim(@dia))
	set @id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado and borrado=0)
	set @id_especialidad=(select id_especialidad from personal.Especialidad where nombre_especialidad=ltrim(rtrim(@nombre_especialidad)) and borrado=0)
	set @id_sede =(select id_sede from servicio.Sede where nombre_sede=ltrim(rtrim(@nombre_sede)) and borrado=0)
	set @id_tipo_turno =(select id_tipo_turno from servicio.Tipo_turno where nombre_tipo_turno=ltrim(rtrim(@nombre_tipo_turno)))
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

	if(@id_tipo_turno is null)
		set @error = @error + '| tipo de turno |' 
	if(@id_paciente is null)
		set @error = @error + '| paciente |' 
	if(@id_medico is null)
		set @error = @error + '| medico |' 
	if(@id_especialidad is null)
		set @error = @error + '| especialidad |' 
	if(@id_sede is null)
		set @error = @error + '| sede |' 
	if(@dia not in('lunes','martes','miercoles','jueves','viernes','sabado'))
		set @error = @error + '| dia |'
	if(@error = ' ' and not exists(select 1 from personal.medico_especialidad 
											where id_especialidad=@id_especialidad
											and id_medico=@id_medico))
		set @error = @error + '| el medico no atiende la especialidad |'
	if(@error=' ' and not exists(select 1 from servicio.Dias_por_sede 
										where id_especialidad=@id_especialidad
										and id_medico=@id_medico
										and id_sede=@id_sede))
		set @error = @error + '| el medico no atiende ese dia la especialidad indicada |'

	if(@error = ' ' )
	begin
		set @hora_inicio = (select horario_inicio from servicio.Dias_por_sede      --obtengo la hora de inicio de atencion de ese medico ese dia en la sede en esa especialidad
								where id_medico=@id_medico and id_sede=@id_sede and 
									dia=@dia and id_especialidad=@id_especialidad)  
		set @hora_fin = (select horario_fin from servicio.Dias_por_sede 
								where id_medico=@id_medico and id_sede=@id_sede and 
									dia=@dia and id_especialidad=@id_especialidad) --obtengo horario de fin de atencion

		if (@hora_inicio is null or @hora_fin is null or 
			@hora>@hora_fin or @hora<@hora_inicio or @fecha<=(convert(date,getdate()))  
			or DATEDIFF(minute,@hora_inicio, @hora)%15<>0)--verifico que el horario sea multiplo de 15 minutos,que exista lo obtenido
			set @error = @error + '| horario |'
	end  
	if(@error=' ')
	begin 
		if(not exists(select 1 from servicio.Reserva_de_turno_medico     --verifico que no este asignado el turno
							where fecha=@fecha and hora=@hora and id_medico=@id_medico and 
									id_sede=@id_sede and id_especialidad=@id_especialidad and 
									id_estado_turno=@id_estado_turno and borrado=0))   
			insert into servicio.Reserva_de_turno_medico (fecha,hora,id_medico,id_especialidad,id_sede,id_estado_turno, id_tipo_turno,id_paciente) values 
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
		else
			set @error = @error + '| el turno ya esta asignado |'
		
	end
	if(@error<>' ')
	begin
		set @error = 'Error: ' + @error
		RAISERROR(@error,5,5,'')
	end
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

create or alter procedure datos_paciente.modificarBorradoDePaciente   --reactivar paciente con borrado logico
(
	@nro_documento int
)
as
begin
		
		if(exists(select 1		
					from datos_paciente.Paciente
					where nro_documento=@nro_documento and borrado=1))
			update datos_paciente.Paciente
			set borrado=0
			where nro_documento=@nro_documento
		else
			RAISERROR('NO EXISTE UN PACIENTE DADO DE BAJA CON EL DNI INGRESADO',5,5,'')
end
go

create or alter procedure datos_paciente.modificarFotoPaciente
(
	@nro_documento int,
    @dir_foto_perfil varchar(100),
	@usuario_actualizacion varchar(30)
)
as
begin
	declare @error varchar(150)
	set @error = ' '
	if(@nro_documento is null)
		set @error = @error + '| nro de documento |'
	if(@dir_foto_perfil is null or ltrim(rtrim(@dir_foto_perfil))= '')
		set @error = @error + '| direccion de foto |'
	if(ltrim(rtrim(@usuario_actualizacion))='' or @usuario_actualizacion is null)
		set @error = @error + '| usuario |'
	if(@error=' ' and not exists(select 1 from datos_paciente.Paciente 
								where nro_documento=@nro_documento and borrado=0))
		set @error = @error + '| no existe paciente activo |'
	if(@error=' ')
		update datos_paciente.Paciente
		set dir_foto_perfil = @dir_foto_perfil,
			usuario_actualizacion = @usuario_actualizacion,
			fecha_actualizacion = convert(date,getdate())
			where nro_documento = @nro_documento and borrado=0
	else
		begin
		set @error = 'Error: ' + @error
		RAISERROR(@error,5,5,'')
		end
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
	declare @error varchar(150),
			@id_paciente int
	set @error = ' '
	set @id_paciente =(select id_historia_clinica from datos_paciente.Paciente where nro_documento=@nro_documento and borrado=0)

	if(@usuario_actualizacion is null or ltrim(rtrim(@usuario_actualizacion))='') 
		set @error = '| usuario |'
	if(ltrim(rtrim(@tipo))='' or @tipo is null or @tipo not in('fijo','alternativo','laboral'))
		set @error = '| tipo de telefono |'
	if(@id_paciente is null)
		set @error = '| nro documento paciente |'
	if(@tel is null or ltrim(rtrim(@tel))='')
		set @error = '| nro telefono |'
	if(@error = ' ')
	begin
		if(@tipo = 'fijo')
			update datos_paciente.Paciente
			set tel_fijo = @tel,
				usuario_actualizacion = @usuario_actualizacion,
				fecha_actualizacion = convert(date,getdate())
			where id_historia_clinica=@id_paciente

		if(@tipo = 'alternativo')
			update datos_paciente.Paciente
			set tel_alternativo = @tel,
				usuario_actualizacion = @usuario_actualizacion,
				fecha_actualizacion = convert(date,getdate())
			where id_historia_clinica=@id_paciente
		if(@tipo = 'laboral')
			update datos_paciente.Paciente
			set tel_laboral = @tel,
				usuario_actualizacion = @usuario_actualizacion,
				fecha_actualizacion = convert(date,getdate())
			where id_historia_clinica=@id_paciente
	end
	else
		begin
		set @error = 'Error: ' + @error
		RAISERROR(@error,5,5,'')
		end
end
go



create or alter procedure datos_paciente.modificarContraseniaUsuario
(
	@id_usuario int,
    @contrasenia varchar(15)
)
as
begin

		if(not exists(select 1 from datos_paciente.Usuario where id_usuario=@id_usuario))  --no existe usuario creado
			RAISERROR('NO EXISTE EL USUARIO',5,5,'')
		else
			if(@contrasenia is null or  len(@contrasenia)<=8)
				RAISERROR('PASSWORD INVALIDA',5,5,'')
			else
				update datos_paciente.Usuario
				set contrasenia = @contrasenia
				where id_usuario = @id_usuario
end
go


create or alter procedure datos_paciente.modificarDomicilio
(
    @calle varchar(50),
    @numero int,
    @piso int,
    @departamento char(1), -- puede ser letra o numero
    @cp smallint,
    @pais varchar(50),
    @provincia varchar(50),
    @localidad varchar(50),
    @nro_documento int
)
as
begin
	declare @id_paciente int
	set @id_paciente = (select id_historia_clinica
						from datos_paciente.Paciente
						where nro_documento=@nro_documento and borrado=0)
	if (@id_paciente is null)
		RAISERROR('NO EXISTE UN PACIENTE ACTIVO CON EL DNI INGRESADO',5,5,'')
	else
		if(not exists(select 1 from datos_paciente.Domicilio where id_paciente=@id_paciente))
			RAISERROR('NO POSEE UN DOMICILIO',5,5,'')
		else
			if(ltrim(rtrim(@pais))='' or ltrim(rtrim(@localidad))='' or ltrim(rtrim(@provincia))='' or ltrim(rtrim(@calle))='')
				RAISERROR('DOMICILIO NO VALIDO',5,5,'')
			else
				update datos_paciente.Domicilio
				set calle = ltrim(rtrim(@calle)),
					numero = @numero,
					piso = @piso,
					departamento = @departamento,
					cp = @cp,
					localidad = ltrim(rtrim(@localidad)),
					provincia = ltrim(rtrim(@provincia)),
					pais = ltrim(rtrim(@pais))
				where id_paciente = @id_paciente

end
go


create or alter procedure comercial.reactivarPrestador  --reactiva un prestador con borrado logico
(
	@nombre_prestador varchar(50)
)
as
begin
	set @nombre_prestador=ltrim(rtrim(@nombre_prestador))
	if(not exists(select 1 from comercial.Prestador where nombre_prestador=@nombre_prestador and borrado=1))
		RAISERROR('No existe un prestador con el id indicado para reactivar',5,5,'')
	else
	begin
			update comercial.Prestador
			set borrado = 0
			where nombre_prestador=@nombre_prestador
	end
end
go


create or alter procedure comercial.reactivarPlan --reactiva un plan con borrado logico
(
	@id_plan int
)
as
begin
	
	if(not exists(select 1 from comercial.Plan_Prestador where id_plan=@id_plan and borrado=1))
		RAISERROR('No existe un plan con el id indicado para reactivar',5,5,'')
	else
	begin
			update comercial.Plan_Prestador
			set borrado = 0
			where id_plan=@id_plan
	end
end
go

create or alter procedure comercial.modificarNombrePlan
(
    @nombre_plan varchar (50),
	@id_plan int
)
as
begin
	set @nombre_plan =  ltrim(rtrim(@nombre_plan))
	if(not exists (select 1 from comercial.Plan_Prestador where id_plan=@id_plan and borrado=0))
		RAISERROR('No existe el plan indicado',5,5,'')
		else 
			if(@nombre_plan='' or @nombre_plan is null)
				RAISERROR('Nombre no valido',5,5,'')
			else
				update comercial.Plan_Prestador
				set nombre_plan = @nombre_plan
				where id_plan = @id_plan
end
go


create or alter procedure datos_paciente.modificarCobertura
(   
	@nombre_prestador varchar(50),
    @nombre_plan varchar(50),
    @nro_documento int
)
as
begin
	declare @id_plan int,
			@id_prestador int,
			@id_paciente int,
			@error varchar(100)
	set @error = ' '
	set @id_prestador = (select id_prestador from comercial.Prestador  where nombre_prestador=@nombre_prestador and borrado=0)
	set @id_paciente= (select id_historia_clinica from datos_paciente.Paciente where nro_documento = @nro_documento and borrado=0)
	set @id_plan= (select id_plan from comercial.Plan_Prestador where nombre_plan=@nombre_plan 
																and  id_prestador=@id_prestador and  borrado=0)
	if(@id_prestador is null)
		set @error = @error + '| nombre de prestador no valido |'
	if(@id_plan is null)
		set @error = @error + '| nombre de plan no valido |'
	if(@id_paciente is null)
		set @error = @error + '| nro documento no valido |'
	begin
		update datos_paciente.Cobertura
		set id_plan = @id_plan,
			id_prestador=@id_prestador
		where id_paciente = @id_paciente
	end
	
end
go
create or alter procedure datos_paciente.modificarNombreEspecialidad
(
	@id_especialidad int,
	@nombre_especialidad varchar(40)
)
as
begin
	declare @error varchar(100)
	set @error = ' '
	set @nombre_especialidad = ltrim(rtrim(@nombre_especialidad))
	
	if(@nombre_especialidad is null or @nombre_especialidad='')
		set @error = '| Nombre de especialidad no valido |'
	if(@id_especialidad is null)  
			set @error = '| Id especialidad no valido |'	
	if(not exists(select 1 from personal.Especialidad where id_especialidad=@id_especialidad and borrado=0))
		set @error = '| No existe el id especialidad  |'
	if(@error=' ')
		update personal.Especialidad
		set nombre_especialidad=@nombre_especialidad
		where id_especialidad=@id_especialidad
	else
		begin
		set @error = 'Error: ' + @error
		RAISERROR(@error,5,5,'')
		end
end
go

create or alter procedure servicio.modificarEstadoTurno
(   
	@id_estado int,
    @nombre_estado varchar(10) -- check(nombre_estado in ('reservado','atendido', 'ausente', 'cancelado'))
)
as
begin
	if(not exists(select 1 from servicio.Estado_turno where id_estado=@id_estado))
		RAISERROR('no existe el id',5,5,'')
	else
		begin
		if(@nombre_estado in('reservado','atendido','ausente','cancelado'))
			update servicio.Estado_turno
			set nombre_estado = @nombre_estado
			where id_estado = @id_estado
		else 
			RAISERROR('nombre de estado no valido',5,5,'')
		end
end
go

create or alter procedure personal.modificarMedico
(
	@nro_colegiado int,
	@nombre_medico varchar(40),
	@apellido_medico varchar(40)
)
as
begin		
	declare @error varchar(150)
	set @error = ' '
	set @nombre_medico = ltrim(rtrim(@nombre_medico))
	set @apellido_medico = ltrim(rtrim(@apellido_medico))

	if(@nombre_medico is null or @nombre_medico='')
		set @error = @error + '| nombre medico no valido |'
	if(@apellido_medico is null or @apellido_medico='')
		set @error = @error + '| apellido medico no valido |'
	if(not exists(select 1 from personal.Medico where nro_colegiado=@nro_colegiado and borrado=0))
		set @error = @error + '| no existe medico activo con la matricula indicada |'
	if(@error = ' ')
		update personal.Medico
		set nombre_medico=@nombre_medico,
			apellido_medico=@apellido_medico
		where nro_colegiado=@nro_colegiado
	else
		begin
		set @error = 'Error: ' + @error
		RAISERROR(@error,5,5,'')
		end

end
go

create or alter procedure servicio.modificarDireccionSede
(   
	@nombre_sede varchar(40),
    @direccion_sede varchar(50),
	@localidad_sede varchar(50),
	@provincia_sede varchar(50)
)
as
begin
	declare @error varchar(150)
	set @error = ' '
	set @nombre_sede = ltrim(rtrim(@nombre_sede))
	set @direccion_sede = ltrim(rtrim(@direccion_sede))
	set @localidad_sede = ltrim(rtrim(@localidad_sede))
	set @provincia_sede = ltrim(rtrim(@provincia_sede))
	
	if(@nombre_sede is null or @nombre_sede= ' ')
		set @error = @error + '| nombre de sede |' 
	if(@direccion_sede is null or @direccion_sede= ' ')
		set @error = @error + '| direccion de sede |' 
	if(@localidad_sede is null or @localidad_sede= ' ')
		set @error = @error + '| localidad de sede |' 
	if(@provincia_sede is null or @provincia_sede= ' ')
		set @error = @error + '| provincia de sede |' 
	if(not exists(select 1 from servicio.Sede where nombre_sede=@nombre_sede and borrado=0))--no existe sede activa
		set @error = @error + '| no existe una sede activa con ese nombre |' 
	if(@error=' ') --existe y esta activa
		update servicio.Sede
		set direccion_sede = @direccion_sede,
			localidad_sede=@localidad_sede,
			provincia_sede=@provincia_sede
		where nombre_sede = @nombre_sede
	else
		begin
		set @error = 'Error: ' + @error
		RAISERROR(@error,5,5,'')
		end
end
go



create or alter procedure servicio.modificarReservaTipoTurno
(   
	@id_turno int,
    @id_tipo_turno int
)
as
begin
	if(not exists(select 1 from servicio.Reserva_de_turno_medico where id_tipo_turno=@id_tipo_turno))
		RAISERROR('Error: No existe el turno',5,5,'')
	if(@id_tipo_turno in (select id_tipo_turno from servicio.Tipo_turno))
	begin
		update servicio.Reserva_de_turno_medico
		set id_tipo_turno = @id_tipo_turno
		where id_turno = @id_turno
	end
	else
		RAISERROR('Error: No existe el tipo de turno',5,5,'')
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
	 declare @dia varchar(10), 
	 @hora_inicio time(0),
	 @hora_fin time(0),
	 @id_sede int,
	 @id_medico int,
	 @id_especialidad int,
	 @id_turno int,
	 @id_paciente int,
	 @id_tipo_turno int,
	 @id_estado_turno int,
	 @error varchar(150)
	 set @error = ' '

	--obtengo los datos del turno que tenia
	set @id_paciente =(select id_historia_clinica from datos_paciente.Paciente where nro_documento=@nro_documento and borrado=0)
	set @id_turno = (select id_turno from servicio.Reserva_de_turno_medico where fecha=@fecha_anterior and hora=@hora_anterior and borrado=0 and id_paciente=@id_paciente)
	set @id_medico=(select id_medico from servicio.Reserva_de_turno_medico where id_turno=@id_turno and borrado=0)
	set @id_especialidad=(select id_especialidad from servicio.Reserva_de_turno_medico where id_turno=@id_turno and borrado=0)
	set @id_sede =(select id_sede from servicio.Reserva_de_turno_medico where id_turno=@id_turno and borrado=0)
	set @id_tipo_turno =(select id_tipo_turno from servicio.Reserva_de_turno_medico where id_turno=@id_turno and borrado=0)
	set @id_estado_turno = (select @id_estado_turno from servicio.Estado_turno where nombre_estado='reservado')

	if(@id_paciente is null)
		set @error = '| paciente no existe |' 
	if(@hora_anterior is null)
		set @error = '| hora anterior |' 
	if(@fecha_anterior is null)
		set @error = '| fecha anterior |' 
	if(@hora is null)
		set @error = '| hora |' 
	if(@id_turno is null)
		set @error = '| El turno no existe |' 
	if(@fecha is null or @fecha<=(convert(date,getdate())))
		set @error = '| nueva fecha |'
	if(@error=' ')
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
								dia=@dia and id_especialidad=@id_especialidad) --obtengo horario inicio atencion
		set @hora_fin = (select horario_fin from servicio.Dias_por_sede 
								where id_medico=@id_medico and id_sede=@id_sede and 
									dia=@dia and id_especialidad=@id_especialidad) --obtengo horario de fin de atencion

		if (@hora>@hora_fin or @hora<@hora_inicio  
			or DATEDIFF(minute,@hora_inicio, @hora)%15<>0)--verifico que el horario sea multiplo de 15 minutos y que sea valido
			set @error = '| horario no valido |' 
		
		
		if(@error=' ' and not exists(select 1 from servicio.Reserva_de_turno_medico 
						where fecha=@fecha and hora=@hora and id_medico=@id_medico and 
									id_sede=@id_sede and id_especialidad=@id_especialidad and 
									id_estado_turno=@id_estado_turno and borrado=0))--verifico que no haya un turno asignado en la fecha y horario nuevos
			update servicio.Reserva_de_turno_medico
			set hora=@hora,
				fecha=@fecha,
				borrado=0
			where id_turno=@id_turno
		else
			set @error = 'horario y fecha no disponible' 
	end
	if(@error<>' ')
		RAISERROR(@error,5,5,'')	
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
	declare @id_estado_turno int,
			@id_paciente int,
			@error varchar(150)
		set @nombre_estado = ltrim(rtrim(@nombre_estado))
		set @error=' ' 
		set @id_paciente = (select id_historia_clinica 
							from datos_paciente.Paciente
							where nro_documento = @nro_documento and borrado=0)
	if(@id_paciente is null)
		set @error = @error + '| paciente no existe |'
	if(@fecha is null)
		set @error = @error + '| fecha |'
	if(@hora is null)
		set @error = @error + '| hora |'
	if(@error=' ' and not exists(select 1 from servicio.Reserva_de_turno_medico 
								where fecha=@fecha and hora=@hora and id_paciente=@id_paciente and borrado=0))
		set @error = @error + '| no existe el turno |'

	set @id_estado_turno = (select id_estado from servicio.Estado_turno where nombre_estado=@nombre_estado)
	if(@id_estado_turno is null)
		set @error = @error + '| estado de turno |'
	if(@error = ' ')
	begin
		update servicio.Reserva_de_turno_medico    --actualiza el estado del turno
		set id_estado_turno = @id_estado_turno
		where fecha=@fecha and hora=@hora and id_paciente=@id_paciente
		if(@nombre_estado='cancelado')           --si el nuevo estado del turno es cancelado hace un borrado logico
			update servicio.Reserva_de_turno_medico
			set borrado=1
			where fecha=@fecha and hora=@hora and id_paciente=@id_paciente and borrado=0
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
	set @id_paciente=(select id_historia_clinica from datos_paciente.Paciente where nro_documento=@nro_documento and borrado=0)
	set @id_estado =(select id_estado from servicio.Estado_turno where nombre_estado='cancelado')
	
	if(@id_paciente is not null)  --si existe el paciente y esta borrado
	begin
		update datos_paciente.Paciente
		set borrado=1							 -- 1 indica que el paciente esta borrado
		where id_historia_clinica=@id_paciente

		update servicio.Reserva_de_turno_medico  --borra los turnos que tenia asignados
		set borrado=1,
			id_estado_turno=@id_estado	
		where id_paciente=@id_paciente
	end
	else
		RAISERROR('NO EXISTE UN PACIENTE ACTIVO CON EL DNI INGRESADO',5,5,'')	
end
go


/*Los prestadores están conformador por Obras Sociales y Prepagas con las cuales se establece una
alianza comercial. Dicha alianza puede finalizar en cualquier momento, por lo cual debe poder ser
actualizable de forma inmediata si el contrato no está vigente. En caso de no estar vigente el contrato,
deben ser anulados todos los turnos de pacientes que se encuentren vinculados a esa prestadora y
pasar a estado disponible.*/
create or alter procedure comercial.eliminarPrestador   --utilizamos borrado logico 
(   
	@nombre_prestador varchar(50)
)
as
begin
	declare @id_prestador int,
			@id_estado int
	set @nombre_prestador = ltrim(rtrim(@nombre_prestador))
	set @id_estado =(select id_estado from servicio.Estado_turno where nombre_estado='cancelado')
	set @id_prestador = (select id_prestador 
						from comercial.Prestador
						where nombre_prestador=@nombre_prestador)

	if(@nombre_prestador is null or @nombre_prestador='')
		RAISERROR('Error: nombre de prestador no valido',5,5,'')
	else
	begin
		update comercial.Prestador      --borrado logico prestador
		set borrado=1                 
		where id_prestador=@id_prestador

		update comercial.Plan_Prestador  --borrado logico de los planes que corresponden al prestador
		set borrado=1
		where id_prestador=@id_prestador
		
		update servicio.Reserva_de_turno_medico                        
		set borrado=1,--borra los turnos asignados a ese prestador de forma logica y se pueden utilizar para otro paciente
			id_estado_turno=@id_estado
		where id_paciente in(select id_paciente from datos_paciente.Cobertura where id_prestador=@id_prestador)

	end
end
go



create or alter procedure comercial.eliminarPlan  --borrado logico
(   
	@id_plan int
)
as
begin
	declare @id_estado int
	set @id_estado =(select id_estado from servicio.Estado_turno where nombre_estado='cancelado')

	if(not exists(select 1 from comercial.Plan_Prestador where id_plan=@id_plan))
		RAISERROR('| Error plan no valido |',5,5,'')
	else
	begin
		update comercial.Plan_Prestador
		set borrado=1                  --borrado logico
		where id_plan=@id_plan

		update servicio.Reserva_de_turno_medico                        
		set borrado=1,--borra los turnos asignados a ese plan de forma logica y se pueden utilizar para otro paciente
			id_estado_turno=@id_estado
		where id_paciente in(select id_paciente from datos_paciente.Cobertura where id_plan=@id_plan)
	end
end
go



create or alter procedure servicio.eliminarEstudio  --borrado logico
(   
	@id_estudio int
)
as
begin
	if(not exists(select 1 from servicio.Estudio where id_estudio=@id_estudio))
		RAISERROR('No existe el turno',5,5,'')
	else
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
	if(exists(select 1 from datos_paciente.Usuario where id_usuario=@id_usuario))
		delete datos_paciente.Usuario
		where id_usuario = @id_usuario
	else
		RAISERROR('NO EXISTE EL USUARIO',5,5,'')
end
go



create or alter procedure datos_paciente.eliminarDomicilio
(   
	@id_domicilio int
)
as
begin
	if(@id_domicilio is null or not exists(select 1 from datos_paciente.Domicilio where id_domicilio=@id_domicilio))
		RAISERROR('NO EXISTE EL ID DE DOMICILIO',5,5,'')
	else
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
	if(@id_tipo_turno is null or not exists(select 1 from servicio.Tipo_turno where id_tipo_turno=@id_tipo_turno))
		RAISERROR('NO EXISTE EL ID DE TIPO DE TURNO INDICADO',5,5,'')
	else
	begin
		if(exists (select 1 
					from servicio.Reserva_de_turno_medico r inner join servicio.Estado_turno e on r.id_estado_turno=e.id_estado
					where r.id_tipo_turno=@id_tipo_turno and r.borrado=0 and e.nombre_estado ='reservado')) --verifica si existen turnos de ese tipo
			RAISERROR('NO SE PUEDE ELIMINAR EL TIPO. EXISTEN TURNOS VIGENTES DEL TIPO INDICADO',5,5,'')
		else
		begin
			delete servicio.Reserva_de_turno_medico
			where id_tipo_turno = @id_tipo_turno

			delete servicio.Tipo_turno
			where id_tipo_turno = @id_tipo_turno
		end
	end
end
go


create or alter procedure servicio.eliminarEstadoTurno
(   
	@id_estado int
)
as
begin
	if(not exists (select 1 from servicio.Estado_turno where id_estado=@id_estado))
		RAISERROR('ERROR no existe el id de estado',5,5,'')
	else
		if(exists(select 1 from servicio.Reserva_de_turno_medico   --no permite borrar el estado si hay turnos activos con ese estado
					where id_estado_turno=@id_estado and borrado=0))
			RAISERROR('ERROR no se puede eliminar el estado. Existen turnos activos en ese estado',5,5,'')
		else
		begin
			delete servicio.Reserva_de_turno_medico
			where id_estado_turno = @id_estado

			delete servicio.Estado_turno
			where id_estado = @id_estado
		end
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
				@id_especialidad int,
				@error varchar(150)
	set @error = ' '
	set @nombre_sede = ltrim(rtrim(@nombre_sede))
	set @nombre_especialidad = ltrim(rtrim(@nombre_especialidad))
	set @dia = ltrim(rtrim(@dia))
	
	set @id_medico=(select id_medico from personal.Medico where nro_colegiado=@nro_colegiado and borrado=0)
	set @id_especialidad=(select id_especialidad from personal.Especialidad where nombre_especialidad=@nombre_especialidad and borrado=0)
	set @id_sede =(select id_sede from servicio.Sede where nombre_sede=@nombre_sede and borrado=0)

	if(@id_medico is null)
		set @error = @error + '| medico |' 
	if(@id_especialidad is null)
		set @error = @error + '| especialidad |' 
	if(@id_sede is null)
		set @error = @error + '| sede |' 
	if(@error = ' ' and not exists(select 1 from servicio.Dias_por_sede 
											where id_especialidad=@id_especialidad and id_medico=@id_medico
													and id_sede=@id_sede))
		set @error = @error + '| no hay atencion del medico indicado en el dia y sede indicada |' 
	if(@error=' ')
		delete from servicio.Dias_por_sede
		where id_medico=@id_medico and id_especialidad=@id_especialidad and dia=ltrim(rtrim(@dia))
	else
	begin
		set @error = 'Error: ' + @error
		RAISERROR(@error,5,5,'')
	end
end
go

create or alter procedure personal.eliminarEspecialidad  --borrado logico
(   
	@nombre_especialidad varchar(50)
)
as
begin
	declare @id_especialidad int
	set @nombre_especialidad = ltrim(rtrim(@nombre_especialidad))
	set @id_especialidad = (select id_especialidad from personal.Especialidad where nombre_especialidad=@nombre_especialidad)
	
	if(@nombre_especialidad is null or @nombre_especialidad='')
		RAISERROR('Nombre de especialidad no valido',5,5,'')
	else
	begin
		if(@id_especialidad is null)  
			RAISERROR('NO EXISTE ESPECIALIDAD',5,5,'')										
		else
			if(exists(select 1   	--verifica si existen medicos activos en esa especialidad
						from personal.Medico m inner join personal.medico_especialidad me on m.id_medico=me.id_medico
						where me.id_especialidad=@id_especialidad and m.borrado=0))  
				RAISERROR('No se puede eliminar la especialidad. Existen medicos activos',5,5,'')
			else
				update personal.Especialidad
				set borrado=1
				where id_especialidad = @id_especialidad
	end
end
go



create or alter procedure personal.eliminarMedico   --BORRADO LOGICO
(   
	@nro_colegiado int
)
as
begin
	set @nro_colegiado = ltrim(rtrim(@nro_colegiado))
	if(@nro_colegiado is null or @nro_colegiado='' or not exists(select 1 from personal.Medico where nro_colegiado=@nro_colegiado))
		RAISERROR('Error: Nro de colegiado no valido',5,5,'')
	else
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
end
go



create or alter procedure servicio.eliminarSede   --borrado logico
(   
	@nombre_sede varchar(40)
)
as
begin
	declare @id_sede int,
			@id_estado int
	
	set @nombre_sede = ltrim(rtrim(@nombre_sede))
	set @id_sede =(select id_sede from servicio.Sede where nombre_sede=@nombre_sede)
	set @id_estado =(select id_estado from servicio.Estado_turno where nombre_estado='reservado')

	if(@id_sede is null)
		RAISERROR('Error: | nombre de sede no valido |',5,5,'')
	else
	begin
		if(exists(select 1 from servicio.Reserva_de_turno_medico -- no elimina la sede si hay turnos pendientes
							where borrado=0 and id_estado_turno=@id_estado and id_sede=@id_sede))
			RAISERROR('Error: | no se puede eliminar la sede, hay turnos pendientes |',5,5,'')
		else -- si no hay turnos pendiente la elimina
		begin
			update servicio.Sede
			set borrado=1
			where id_sede=@id_sede

			delete from servicio.Dias_por_sede   --borramos dias por sede, que son los dias en los que hay atencion en esa sede
			where id_sede=@id_sede
		end
	end
end
go


create or alter procedure datos_paciente.eliminarCoberturaPaciente
(   
	@nro_documento int
)
as
begin
	declare @id_paciente int,
			@error varchar(100)
	set @error = ' '
	set @id_paciente= (select id_historia_clinica from datos_paciente.Paciente where nro_documento = @nro_documento and borrado=0)
	
	if(@id_paciente is null)
		set @error = @error + '| nro de documento no valido |'
	if(not exists (select 1 from datos_paciente.Cobertura where id_paciente=@id_paciente))
		set @error = @error + '| el paciente no tiene cobertura |'
	if(@error = ' ')
		delete datos_paciente.Cobertura
		where id_paciente=@id_paciente
end
go

create or alter proc servicio.autorizar_estudio(@estudio varchar(200),@plan varchar(50),@nro_documento int)
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

