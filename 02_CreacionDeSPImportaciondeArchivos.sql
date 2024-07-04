
/*STORE PROC Y FUNCIONES NECESARIAS PARA IMPORTACION DE ARCHIVOS MAESTROS */

/* MATERIA BBDDA COMISION 5600 
GRUPO NRO 16 
ALUMNOS:
	ARAGON, RODRIGO EZEQUIEL 43509985
	LA GIGLIA RODRIGO ARIEL DNI 33334248
*/



use Com5600G16
go


CREATE or alter FUNCTION importacion.ExtraerUltimosNumeros(@cadena NVARCHAR(100)) 
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @pos INT = LEN(@cadena)
    DECLARE @posUltimoNumero INT = -1
    DECLARE @startPos INT
    DECLARE @ultimosNumeros NVARCHAR(100) = ''

    -- Bucle para encontrar la posición del último número de derecha a izquierda
    WHILE @pos > 0
    BEGIN
        IF SUBSTRING(@cadena, @pos, 1) LIKE '[0-9]'
        BEGIN
            SET @posUltimoNumero = @pos
            BREAK
        END
        SET @pos = @pos - 1
    END

    -- Si no se encontró ningún número, devolver cadena vacía
    IF @posUltimoNumero = -1
        RETURN ''

    -- Inicializar la posición de inicio con la posición del último número
    SET @startPos = @posUltimoNumero

    -- Bucle para encontrar la posición del inicio de los números consecutivos
    WHILE @startPos > 0 AND SUBSTRING(@cadena, @startPos, 1) LIKE '[0-9]'
    BEGIN
        SET @startPos = @startPos - 1
    END

    -- Ajusta la posición inicial para que apunte al primer dígito del grupo
    SET @startPos = @startPos + 1

    -- Extraer los números
    DECLARE @longitud INT = @posUltimoNumero - @startPos + 1
    SET @ultimosNumeros = SUBSTRING(@cadena, @startPos, @longitud)

    RETURN @ultimosNumeros
END
GO

create or alter procedure importacion.importarPacientes
(@path nvarchar(100)) 
as
begin
	declare @sql nvarchar(max)

	create table #PacientesTemporal (
	Nombre varchar(30)collate SQL_Latin1_General_CP1_CI_AS,
	Apellido varchar(35)collate SQL_Latin1_General_CP1_CI_AS,
	Fecha_de_nacimiento varchar(10)collate SQL_Latin1_General_CP1_CI_AS,
	tipo_Documento varchar(10)collate SQL_Latin1_General_CP1_CI_AS,
	Nro_documento int,
	sexo varchar(10)collate SQL_Latin1_General_CP1_CI_AS,
	genero varchar(10)collate SQL_Latin1_General_CP1_CI_AS,
	Telefono_fijo varchar(15)collate SQL_Latin1_General_CP1_CI_AS,
	Nacionalidad varchar(50)collate SQL_Latin1_General_CP1_CI_AS,
	Mail varchar(50)collate SQL_Latin1_General_CP1_CI_AS,
	Calle_y_Nro varchar(50)collate SQL_Latin1_General_CP1_CI_AS,
	localidad varchar(50)collate SQL_Latin1_General_CP1_CI_AS,
	Provincia varchar(20)collate SQL_Latin1_General_CP1_CI_AS
)

	set @sql = N'bulk insert #PacientesTemporal
	from '''+ @path +'''
	with
	(
		FIELDTERMINATOR = '';'',
		ROWTERMINATOR = ''\n'',
		FIRSTROW = 2,
		codepage = ''65001''
	)'


	exec sp_executesql @sql

			
	insert into datos_paciente.Paciente(nombre,apellido,fecha_nacimiento,tipo_documento,
										nro_documento,sexo_biologico,genero,tel_fijo,nacionalidad,
										mail, usuario_actualizacion)
		select Nombre, Apellido,CONVERT(date,Fecha_de_nacimiento, 103) ,tipo_Documento,
				Nro_documento,lower(sexo),genero,Telefono_fijo,Nacionalidad,Mail, 'importacion'
		from #PacientesTemporal
		where Nro_documento not in (select nro_documento from datos_paciente.Paciente)   --no inserta los duplicados, el resto si


		insert into datos_paciente.Domicilio(calle, numero,localidad,provincia,id_paciente)      
			select  REPLACE(rtrim(ltrim (Calle_y_Nro)),importacion.ExtraerUltimosNumeros(Calle_y_Nro),''),  
					cast(importacion.ExtraerUltimosNumeros(Calle_y_Nro)as int),localidad,provincia,p.id_historia_clinica  --utilizo funcion para obtener el nro de calle
			from #PacientesTemporal t join datos_paciente.Paciente p on p.nro_documento=t.Nro_documento
			where p.id_historia_clinica not in(select id_paciente from datos_paciente.Domicilio)                      --no inserta duplicados

	drop table #PacientesTemporal

end
go


create or alter procedure importacion.importarMedicos(@path nvarchar(100)) as
begin

create table #MedicosTemporal (
	Apellido varchar(35)collate SQL_Latin1_General_CP1_CI_AS,
	Nombre varchar(30)collate SQL_Latin1_General_CP1_CI_AS,
	Especialidad varchar(30)collate SQL_Latin1_General_CP1_CI_AS,
	NumeroColegiado int
)

	declare @sql nvarchar(max)
	set @sql=N'
	bulk insert #MedicosTemporal
	from ''' + @path + '''
	with
	(
		FIELDTERMINATOR = '';'',
		ROWTERMINATOR = ''\n'',
		FIRSTROW = 2,
		codepage = ''65001''
	)'

	exec sp_executesql @sql

	--elimino el dr, dra, kgo ... de la cadena, me quedo solo con el apellido
	UPDATE #MedicosTemporal
	SET Apellido = SUBSTRING(Apellido, CHARINDEX(' ', Apellido) + 1, LEN(Apellido) - CHARINDEX(' ', Apellido))
	WHERE CHARINDEX(' ', Apellido) > 0;

	UPDATE #MedicosTemporal
	set Especialidad = upper(ltrim(rtrim(Especialidad)))
	where Especialidad is not null and Especialidad<>''

	 --inserta especialidades que no existan
	insert into personal.Especialidad (nombre_especialidad)          
		select Especialidad
		from #MedicosTemporal
		where NOT EXISTS(select 1 from personal.Especialidad where nombre_especialidad=Especialidad)   
		group by Especialidad

	--si existen pero tienen borrado logico las activa
	update personal.Especialidad									
	set borrado=0
	where nombre_especialidad in(select Especialidad from #MedicosTemporal where borrado=1 )

	--inserta los medicos que no existen
	insert into personal.Medico(nombre_medico,apellido_medico,nro_colegiado)
		select Nombre, Apellido, NumeroColegiado
		from #MedicosTemporal
		where NumeroColegiado not in (select nro_colegiado from personal.Medico)            

	--si existen pero tienen borrado logico las activa
	update personal.Medico
	set borrado=0
	where nro_colegiado in(select NumeroColegiado from #MedicosTemporal where borrado=1)

	--creo la relacion en tabla medico_especialidad
	insert into personal.medico_especialidad
	(id_medico,id_especialidad)
	select m.id_medico,e.id_especialidad 
	from personal.Medico m inner join #MedicosTemporal t on m.nro_colegiado=t.NumeroColegiado 
		inner join personal.Especialidad e on e.nombre_especialidad=t.Especialidad and m.borrado=0 and e.borrado=0

	drop table #MedicosTemporal

end
go


create or alter procedure importacion.importarSedes(@path varchar(100)) as
begin
	
	create table #SedesTemporal
	(
		sede varchar(50) collate SQL_Latin1_General_CP1_CI_AS,
		direccion varchar(50)collate SQL_Latin1_General_CP1_CI_AS,
		localidad varchar(50)collate SQL_Latin1_General_CP1_CI_AS,
		provincia varchar(20)collate SQL_Latin1_General_CP1_CI_AS
	)
	declare @sql nvarchar(max)
	set @sql=N'
	bulk insert #SedesTemporal
	from ''' + @path + ''' 
	with
	(
		FIELDTERMINATOR = '';'',
		ROWTERMINATOR = ''\n'',
		FIRSTROW = 2,
		codepage = ''65001''
	)'
	exec sp_executesql @sql
	
	update #SedesTemporal
	set sede = ltrim(rtrim(sede))
	where sede is not null and sede<>''

	--si no existe la inserto
	insert into servicio.Sede (nombre_sede,direccion_sede, localidad_sede, provincia_sede)
		select sede,direccion,localidad,provincia
		from #SedesTemporal
		where not exists(select 1 from servicio.Sede where sede like nombre_sede)  
		group by sede,direccion, localidad, provincia
	
	--si existe pero esta inactiva la activo
	update servicio.Sede
	set borrado=0
	where nombre_sede in (select sede from #SedesTemporal) and borrado=1

end
go


create or alter procedure importacion.importarPrestador(@path varchar(100)) as
begin
	
	create table #PrestadorTemporal
	(
		prestador varchar(50)COLLATE SQL_Latin1_General_CP1_CI_AS ,
		planes varchar(50)COLLATE SQL_Latin1_General_CP1_CI_AS
	)
	declare @sql nvarchar(max)
	set @sql = N'bulk insert #PrestadorTemporal
	from ''' + @path + '''
	with
	(
		FIELDTERMINATOR = '';'',
		ROWTERMINATOR = '';;\n'',
		FIRSTROW = 2,
		codepage = ''65001''
	)'

	exec sp_executesql @sql

	update #PrestadorTemporal
	set planes = ltrim(rtrim(planes)),
		prestador = ltrim(rtrim(prestador))

	insert into comercial.Prestador(nombre_prestador)
		select prestador 
		from #PrestadorTemporal
		where prestador not in (select nombre_prestador from comercial.Prestador) --- no inserte duplicados
		group by prestador
	
	update comercial.Prestador
	set borrado=0
	where nombre_prestador in(select prestador 
								from #PrestadorTemporal) and borrado=1


	insert into comercial.Plan_Prestador(id_prestador,nombre_plan)
		select pres.id_prestador, temp.planes
		from #PrestadorTemporal temp join comercial.Prestador pres on pres.nombre_prestador = temp.prestador  
		where temp.planes not in (select nombre_plan from comercial.Plan_Prestador)         --no inserta duplicados

	update comercial.Plan_Prestador
	set borrado=0
	where nombre_plan in(select planes from #PrestadorTemporal) and borrado=1

	drop table #PrestadorTemporal
end
go




create or alter procedure importacion.importarParametrosAutorizacionEstudio(@path varchar(100)) as
begin

	create table #AutorizacionEstudiosTemp 
	(
		area nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS,
		estudio nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,
		prestador nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS,
		plan_ nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,
		[Porcentaje Cobertura] int,
		costo decimal(10,2),
		[Requiere autorizacion] bit
	)
	declare @sql nvarchar(max)
	set @sql = N'
	insert into #AutorizacionEstudiosTemp (area,estudio,prestador,plan_,[Porcentaje Cobertura],costo,[Requiere autorizacion])
	select area,estudio,prestador,plan_,[Porcentaje Cobertura],costo,[Requiere autorizacion]
	from openrowset (bulk '''+ @path + ''', single_clob) as j
	cross apply openjson(bulkcolumn)
	with (
			
			area nvarchar(50) ''$.Area'',
			estudio nvarchar(100) ''$.Estudio'',
			prestador nvarchar(50) ''$.Prestador'',
			plan_ nvarchar(100) ''$.Plan'',
			[Porcentaje Cobertura] int,
			costo int ''$.Costo'',
			[Requiere autorizacion] bit 
	)as estudio;'

	exec sp_executesql @sql

	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'Ã¡', 'á'),
		estudio = REPLACE (estudio,'Ã¡', 'á'),
		prestador = REPLACE (prestador,'Ã¡', 'á'),
		plan_ = REPLACE(plan_,'Ã¡', 'á')
	where area like ('%Ã¡%') or estudio like ('%Ã¡%') or
			prestador like ('%Ã¡%') or plan_ like ('%Ã¡%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'Ã©','é'),
		estudio = REPLACE (estudio,'Ã©', 'é'),
		prestador = REPLACE (prestador,'Ã©', 'é'),
		plan_ = REPLACE(plan_,'Ã©', 'é')
	where area like ('%Ã©%') or estudio like ('%Ã©%') or
			prestador like ('%Ã©%') or plan_ like ('%Ã©%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'Ã­', 'í'),
		estudio = REPLACE (estudio,'Ã­', 'í'),
		prestador = REPLACE (prestador,'Ã­', 'í'),
		plan_ = REPLACE(plan_,'Ã­', 'í')
	where estudio like ('%Ã­%') or area like ('%Ã­%') or
			prestador like ('%Ã­%') or plan_ like ('%Ã­%')

	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'Ã³', 'ó'),
		prestador = REPLACE (prestador,'Ã³', 'ó'),
		estudio = REPLACE (estudio,'Ã³', 'ó'),
		plan_ = REPLACE(plan_,'Ã³', 'ó')
	where area like ('%Ã³%') or estudio like ('%Ã³%') or
			prestador like ('%Ã³%') or plan_ like ('%Ã³%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'Ãº','ú'),
		prestador = REPLACE (prestador,'Ãº', 'ú'),
		estudio = REPLACE (estudio,'Ãº', 'ú'),
		plan_ = REPLACE(plan_,'Ãº', 'ú')
	where area like ('%Ãº%') or prestador like ('%Ãº%') or
			estudio like ('%Ãº%') or plan_ like ('%Ãº%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'Ã', 'Á'),
		prestador = REPLACE (prestador,'Ã', 'Á'),
		estudio = REPLACE (estudio,'Ã', 'Á'),
		plan_ = REPLACE(plan_,'Ã', 'Á')
	where area like ('%Ã%') or prestador like ('%Ã%') or
			estudio like ('%Ã%') or plan_ like ('%Ã%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'Ã‰', 'É'),
		prestador = REPLACE (prestador,'Ã‰', 'É'),
		estudio = REPLACE (estudio,'Ã‰', 'É'),
		plan_ = REPLACE(plan_,'Ã‰', 'É')
	where area like ('%Ã‰%') or prestador like ('%Ã‰%') or
			estudio like ('%Ã‰%') or plan_ like ('%Ã‰%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'Ã','Í'),
		prestador = REPLACE (prestador,'Ã', 'Í'),
		estudio = REPLACE (estudio,'Ã', 'Í'),
		plan_ = REPLACE(plan_,'Ã', 'Í')
	where area like ('%Ã%') or prestador like ('%Ã%') or
			estudio like ('%Ã%') or plan_ like ('%Ã%')


	update #AutorizacionEstudiosTemp
	set area = replace(area,'Ã“','Ó'),
		prestador = REPLACE (prestador,'Ã“', 'Ó'),
		estudio = REPLACE (estudio,'Ã“', 'Ó'),
		plan_ = REPLACE(plan_,'Ã“', 'Ó')
	where area like ('%Ã“%') or prestador like ('%Ã“%') or
			estudio like ('%Ã“%') or plan_ like ('%Ã“%')


	update #AutorizacionEstudiosTemp
	set area = replace(area,'Ãš','Ú'),
		prestador = REPLACE (prestador,'Ãš', 'Ú'),
		estudio = REPLACE (estudio,'Ãš', 'Ú'),
		plan_ = REPLACE(plan_,'Ãš', 'Ú')
	where area like ('%Ãš%') or prestador like ('%Ãš%') or
			estudio like ('%Ãš%') or plan_ like ('%Ãš%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'Ã', 'à'),
		prestador = REPLACE (prestador,'Ã', 'à'),
		estudio = REPLACE (estudio,'Ã', 'à'),
		plan_ = REPLACE(plan_,'Ã', 'à')
	where area like ('%Ã%') or prestador like ('%Ã%') or
			estudio like ('%Ã%') or plan_ like ('%Ã%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'Ã±','ñ'),
		prestador = REPLACE (prestador,'Ã±', 'ñ'),
		estudio = REPLACE (estudio,'Ã±', 'ñ'),
		plan_ = REPLACE(plan_,'Ã±', 'ñ')
	where area like ('%Ã±%') or prestador like ('%Ã±%') or
			estudio like ('%Ã±%') or plan_ like ('%Ã±%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'Ã‘','Ñ'),
		prestador = REPLACE (prestador,'Ã‘', 'Ñ'),
		estudio = REPLACE (estudio,'Ã‘', 'Ñ'),
		plan_ = REPLACE(plan_,'Ã‘', 'Ñ')
	where area like ('%Ã‘%') or prestador like ('%Ã‘%') or
			estudio like ('%Ã‘%') or plan_ like ('%Ã‘%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'Âº','°'),
		prestador = REPLACE (prestador,'Âº', '°'),
		estudio = REPLACE (estudio,'Âº', '°'),
		plan_ = REPLACE(plan_,'Âº', '°')
	where area like ('%Âº%') or prestador like ('%Âº%') or
			estudio like ('%Âº%') or plan_ like ('%Âº%')
	
	
	delete from #AutorizacionEstudiosTemp   --elimino si hay algun null en la temporal
	where estudio is null


	insert into servicio.autorizacion_de_estudio				--inserto en la base de datos
		select area,estudio,prestador,plan_ ,[Porcentaje Cobertura],costo,[Requiere autorizacion]  
		from #AutorizacionEstudiosTemp t
		where not exists(select 1 
						from servicio.autorizacion_de_estudio a
						where (t.area=a.area and t.estudio=a.estudio and t.prestador=a.prestador and t.plan_=a.plan_) or t.area is null )   --no inserta repetidos


end
