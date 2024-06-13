
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
		codepage = ''ACP''
	)'


	exec sp_executesql @sql

	---Los siguientes updates son para poder arreglar caracteres especiales, como vocales con tilde. Solamente no funciona cuando hay
	---dos caracteres especiales juntos, por ejemplo, Ordóñez. No he encontrado manera de solucionarlo
	---Pense en usar constains en vez de like pero requiere configurar el motor de base de datos y no es conveniente
	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'Ã¡', 'á'),
		Apellido = REPLACE (Apellido,'Ã¡', 'á'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã¡', 'á'),
		localidad = REPLACE(localidad,'Ã¡', 'á'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã¡', 'á')
	where Nombre like ('%Ã¡%') or Apellido like ('%Ã¡%') or
			Nacionalidad like ('%Ã¡%') or localidad like ('%Ã¡%') or
			Calle_y_Nro like ('%Ã¡%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'Ã©','é'),
		Apellido = REPLACE (Apellido,'Ã©', 'é'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã©', 'é'),
		localidad = REPLACE(localidad,'Ã©', 'é'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã©', 'é')
	where Nombre like ('%Ã©%') or Apellido like ('%Ã©%') or
			Nacionalidad like ('%Ã©%') or localidad like ('%Ã©%') or
			Calle_y_Nro like ('%Ã©%')

	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'Ã­', 'í'),
		Apellido = REPLACE (Apellido,'Ã­', 'í'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã­', 'í'),
		localidad = REPLACE(localidad,'Ã­', 'í'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã­', 'í')
	where Nombre like ('%Ã­%') or Apellido like ('%Ã­%') or
			Nacionalidad like ('%Ã­%') or localidad like ('%Ã­%') or
			Calle_y_Nro like ('%Ã­%')

	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'Ã³', 'ó'),
		Apellido = REPLACE (Apellido,'Ã³', 'ó'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã³', 'ó'),
		localidad = REPLACE(localidad,'Ã³', 'ó'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã³', 'ó')
	where Nombre like ('%Ã³%') or Apellido like ('%Ã³%') or
			Nacionalidad like ('%Ã³%') or localidad like ('%Ã³%') or
			Calle_y_Nro like ('%Ã³%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'Ãº','ú'),
		Apellido = REPLACE (Apellido,'Ãº', 'ú'),
		Nacionalidad = REPLACE (Nacionalidad,'Ãº', 'ú'),
		localidad = REPLACE(localidad,'Ãº', 'ú'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ãº', 'ú')
	where  Nombre like ('%Ãº%') or Apellido like ('%Ãº%') or
			Nacionalidad like ('%Ãº%') or
			localidad like ('%Ãº%') or Calle_y_Nro like ('%Ãº%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'Ã', 'Á'),
		Apellido = REPLACE (Apellido,'Ã', 'Á'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã', 'Á'),
		localidad = REPLACE(localidad,'Ã', 'Á'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã', 'Á')
	where Nombre like ('%Ã%') or Apellido like ('%Ã%') or
			Nacionalidad like ('%Ã%') or localidad like ('%Ã%') or
			Calle_y_Nro like ('%Ã%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'Ã‰', 'É'),
		Apellido = REPLACE (Apellido,'Ã‰', 'É'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã‰', 'É'),
		localidad = REPLACE(localidad,'Ã‰', 'É'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã‰', 'É')
	where Nombre like ('%Ã‰%') or Apellido like ('%Ã‰%') or
			Nacionalidad like ('%Ã‰%') or localidad like ('%Ã‰%') or
			Calle_y_Nro like ('%Ã‰%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'Ã','Í'),
		Apellido = REPLACE (Apellido,'Ã', 'Í'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã', 'Í'),
		localidad = REPLACE(localidad,'Ã', 'Í'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã', 'Í')
	where Nombre like ('%Ã%') or Apellido like ('%Ã%') or
			Nacionalidad like ('%Ã%') or localidad like ('%Ã%') or
			Calle_y_Nro like ('%Ã%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'Ã“','Ó'),
		Apellido = REPLACE (Apellido,'Ã“', 'Ó'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã“', 'Ó'),
		localidad = REPLACE(localidad,'Ã“', 'Ó'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã“', 'Ó')
	where Nombre like ('%Ã“%') or Apellido like ('%Ã“%') or
			Nacionalidad like ('%Ã“%') or localidad like ('%Ã“%') or
			Calle_y_Nro like ('%Ã“%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'Ãš','Ú'),
		Apellido = REPLACE (Apellido,'Ãš', 'Ú'),
		Nacionalidad = REPLACE (Nacionalidad,'Ãš', 'Ú'),
		localidad = REPLACE(localidad,'Ãš', 'Ú'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ãš', 'Ú')
	where Nombre like ('%Ãš%') or Apellido like ('%Ãš%') or
			Nacionalidad like ('%Ãš%') or localidad like ('%Ãš%') or
			Calle_y_Nro like ('%Ãš%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'Ã', 'à'),
		Apellido = REPLACE (Apellido,'Ã', 'à'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã', 'à'),
		localidad = REPLACE(localidad,'Ã', 'à'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã', 'à')
	where Nombre like ('%Ã%') or Apellido like ('%Ã%') or
			Nacionalidad like ('%Ã%') or localidad like ('%Ã%') or
			Calle_y_Nro like ('%Ã%')

	update #PacientesTemporal
	set Nombre = replace(Nombre,'Ã±','ñ'),
		Apellido = REPLACE (Apellido,'Ã±', 'ñ'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã±', 'ñ'),
		localidad = REPLACE(localidad,'Ã±', 'ñ'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã±', 'ñ')
	where Nombre like ('%Ã±%') or Apellido like ('%Ã±%') or
			Nacionalidad like ('%Ã±%') or localidad like ('%Ã±%') or
			Calle_y_Nro like ('%Ã±%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'Ã‘','Ñ'),
		Apellido = REPLACE (Apellido,'Ã‘', 'Ñ'),
		Nacionalidad = REPLACE (Nacionalidad,'Ã‘', 'Ñ'),
		localidad = REPLACE(localidad,'Ã‘', 'Ñ'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ã‘', 'Ñ')
	where Nombre like ('%Ã‘%') or Apellido like ('%Ã‘%') or
			Nacionalidad like ('%Ã‘%') or localidad like ('%Ã‘%') or
			Calle_y_Nro like ('%Ã‘%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'Âº','°'),
		Apellido = REPLACE (Apellido,'Âº', '°'),
		Nacionalidad = REPLACE (Nacionalidad,'Âº', '°'),
		localidad = REPLACE(localidad,'Âº', '°'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Âº', '°')
	where Nombre like ('%Âº%') or Apellido like ('%Âº%') or
			Nacionalidad like ('%Âº%') or localidad like ('%Âº%') or
			Calle_y_Nro like ('%Âº%')

			
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
		codepage = ''ACP''
	)'

	exec sp_executesql @sql


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'Ã¡', 'á'),
		Apellido = REPLACE (Apellido,'Ã¡', 'á'),
		Nombre = REPLACE (Nombre, 'Ã¡', 'á')
	where Especialidad like ('%Ã¡%') or Apellido like ('%Ã¡%') or Nombre like('%Ã¡%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ã©','é'),
		Apellido = REPLACE (Apellido,'Ã©', 'é'),
		Nombre = REPLACE (Nombre,'Ã©', 'é')
	where Especialidad like ('%Ã©%') or Apellido like ('%Ã©%') or Nombre like('%Ã©%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'Ã­', 'í'),
		Apellido = REPLACE (Apellido,'Ã­', 'í'),
		Nombre = REPLACE (Nombre,'Ã­', 'í')
	where Especialidad like ('%Ã­%') or Apellido like ('%Ã­%') or Nombre like ('%Ã­%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'Ã³', 'ó'),
		Apellido = REPLACE (Apellido,'Ã³', 'ó'),
		Nombre = REPLACE (Nombre,'Ã³', 'ó')
	where Especialidad like ('%Ã³%') or Apellido like ('%Ã³%') or Nombre like ('%Ã³%') 

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ãº','ú'),
		Apellido = REPLACE (Apellido,'Ãº', 'ú'),
		Nombre = REPLACE (Nombre,'Ãº', 'ú')
	where  Especialidad like ('%Ãº%') or Apellido like ('%Ãº%') or Nombre like ('%Ãº%')


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'Ã', 'Á'),
		Apellido = REPLACE (Apellido,'Ã', 'Á'),
		Nombre = REPLACE (Nombre,'Ã', 'Á')
	where Especialidad like ('%Ã%') or Apellido like ('%Ã%') or Nombre like ('%Ã%')


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'Ã‰', 'É'),
		Apellido = REPLACE (Apellido,'Ã‰', 'É'),
		Nombre = REPLACE (Nombre,'Ã‰', 'É')
	where Especialidad like ('%Ã‰%') or Apellido like ('%Ã‰%')  or Nombre like ('%Ã‰%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ã','Í'),
		Apellido = REPLACE (Apellido,'Ã', 'Í'),
		Nombre = REPLACE (Nombre,'Ã', 'Í')
	where Especialidad like ('%Ã%') or Apellido like ('%Ã%') or Nombre like ('%Ã%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ã“','Ó'),
		Apellido = REPLACE (Apellido,'Ã“', 'Ó'),
		Nombre = REPLACE (Nombre,'Ã“', 'Ó')
	where Especialidad like ('%Ã“%') or Apellido like ('%Ã“%') or Nombre like ('%Ã“%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ãš','Ú'),
		Apellido = REPLACE (Apellido,'Ãš', 'Ú'),
		Nombre = REPLACE (Nombre,'Ãš', 'Ú')
	where Especialidad like ('%Ãš%') or Apellido like ('%Ãš%')or Nombre like ('%Ãš%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'Ã', 'à'),
		Apellido = REPLACE (Apellido,'Ã', 'à'),
		Nombre = REPLACE (Nombre,'Ã', 'à')
	where Especialidad like ('%Ã%') or Apellido like ('%Ã%') or Nombre like ('%Ã%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ã±','ñ'),
		Apellido = REPLACE (Apellido,'Ã±', 'ñ'),
		Nombre = REPLACE (Nombre,'Ã±', 'ñ')
	where Especialidad like ('%Ã±%') or Apellido like ('%Ã±%') or Nombre like ('%Ã±%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ã‘','Ñ'),
		Apellido = REPLACE (Apellido,'Ã‘', 'Ñ'),
		Nombre = REPLACE (Nombre,'Ã‘', 'Ñ')
	where Especialidad like ('%Ã‘%') or Apellido like ('%Ã‘%')or Nombre like ('%Ã‘%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Âº','°'),
		Apellido = REPLACE (Apellido,'Âº', '°'),
		Nombre = REPLACE (Nombre,'Âº', '°')
	where Especialidad like ('%Âº%') or Apellido like ('%Âº%') or Nombre like ('%Âº%')

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
		codepage = ''ACP''
	)'
	exec sp_executesql @sql

	update #SedesTemporal
	set sede = REPLACE (sede,'Ã¡', 'á'),
		provincia = REPLACE (provincia,'Ã¡', 'á'),
		direccion = REPLACE (direccion,'Ã¡', 'á'),
		localidad = REPLACE(localidad,'Ã¡', 'á')
	where sede like ('%Ã¡%') or provincia like ('%Ã¡%') or
			direccion like ('%Ã¡%') or localidad like ('%Ã¡%')

	update #SedesTemporal
	set sede = replace(sede,'Ã©','é'),
		provincia = REPLACE (provincia,'Ã©', 'é'),
		direccion = REPLACE (direccion,'Ã©', 'é'),
		localidad = REPLACE(localidad,'Ã©', 'é')
	where sede like ('%Ã©%') or provincia like ('%Ã©%') or
			direccion like ('%Ã©%') or localidad like ('%Ã©%')


	update #SedesTemporal
	set sede = REPLACE (sede,'Ã­', 'í'),
		provincia = REPLACE (provincia,'Ã­', 'í'),
		direccion = REPLACE (direccion,'Ã­', 'í'),
		localidad = REPLACE(localidad,'Ã­', 'í')
	where provincia like ('%Ã­%') or sede like ('%Ã­%') or
			direccion like ('%Ã­%') or localidad like ('%Ã­%')

	update #SedesTemporal
	set sede = REPLACE (sede,'Ã³', 'ó'),
		direccion = REPLACE (direccion,'Ã³', 'ó'),
		provincia = REPLACE (provincia,'Ã³', 'ó'),
		localidad = REPLACE(localidad,'Ã³', 'ó')
	where sede like ('%Ã³%') or provincia like ('%Ã³%') or
			direccion like ('%Ã³%') or localidad like ('%Ã³%')

	update #SedesTemporal
	set sede = replace(sede,'Ãº','ú'),
		direccion = REPLACE (direccion,'Ãº', 'ú'),
		provincia = REPLACE (provincia,'Ãº', 'ú'),
		localidad = REPLACE(localidad,'Ãº', 'ú')
	where sede like ('%Ãº%') or direccion like ('%Ãº%') or
			provincia like ('%Ãº%') or localidad like ('%Ãº%')


	update #SedesTemporal
	set sede = REPLACE (sede,'Ã', 'Á'),
		direccion = REPLACE (direccion,'Ã', 'Á'),
		provincia = REPLACE (provincia,'Ã', 'Á'),
		localidad = REPLACE(localidad,'Ã', 'Á')
	where sede like ('%Ã%') or direccion like ('%Ã%') or
			provincia like ('%Ã%') or localidad like ('%Ã%')


	update #SedesTemporal
	set sede = REPLACE (sede,'Ã‰', 'É'),
		direccion = REPLACE (direccion,'Ã‰', 'É'),
		provincia = REPLACE (provincia,'Ã‰', 'É'),
		localidad = REPLACE(localidad,'Ã‰', 'É')
	where sede like ('%Ã‰%') or direccion like ('%Ã‰%') or
			provincia like ('%Ã‰%') or localidad like ('%Ã‰%')

	update #SedesTemporal
	set sede = replace(sede,'Ã','Í'),
		direccion = REPLACE (direccion,'Ã', 'Í'),
		provincia = REPLACE (provincia,'Ã', 'Í'),
		localidad = REPLACE(localidad,'Ã', 'Í')
	where sede like ('%Ã%') or direccion like ('%Ã%') or
			provincia like ('%Ã%') or localidad like ('%Ã%')


	update #SedesTemporal
	set sede = replace(sede,'Ã“','Ó'),
		direccion = REPLACE (direccion,'Ã“', 'Ó'),
		provincia = REPLACE (provincia,'Ã“', 'Ó'),
		localidad = REPLACE(localidad,'Ã“', 'Ó')
	where sede like ('%Ã“%') or direccion like ('%Ã“%') or
			provincia like ('%Ã“%') or localidad like ('%Ã“%')


	update #SedesTemporal
	set sede = replace(sede,'Ãš','Ú'),
		direccion = REPLACE (direccion,'Ãš', 'Ú'),
		provincia = REPLACE (provincia,'Ãš', 'Ú'),
		localidad = REPLACE(localidad,'Ãš', 'Ú')
	where sede like ('%Ãš%') or direccion like ('%Ãš%') or
			provincia like ('%Ãš%') or localidad like ('%Ãš%')


	update #SedesTemporal
	set sede = REPLACE (sede,'Ã', 'à'),
		direccion = REPLACE (direccion,'Ã', 'à'),
		provincia = REPLACE (provincia,'Ã', 'à'),
		localidad = REPLACE(localidad,'Ã', 'à')
	where sede like ('%Ã%') or direccion like ('%Ã%') or
			provincia like ('%Ã%') or localidad like ('%Ã%')

	update #SedesTemporal
	set sede = replace(sede,'Ã±','ñ'),
		direccion = REPLACE (direccion,'Ã±', 'ñ'),
		provincia = REPLACE (provincia,'Ã±', 'ñ'),
		localidad = REPLACE(localidad,'Ã±', 'ñ')
	where sede like ('%Ã±%') or direccion like ('%Ã±%') or
			provincia like ('%Ã±%') or localidad like ('%Ã±%')

	update #SedesTemporal
	set sede = replace(sede,'Ã‘','Ñ'),
		direccion = REPLACE (direccion,'Ã‘', 'Ñ'),
		provincia = REPLACE (provincia,'Ã‘', 'Ñ'),
		localidad = REPLACE(localidad,'Ã‘', 'Ñ')
	where sede like ('%Ã‘%') or direccion like ('%Ã‘%') or
			provincia like ('%Ã‘%') or localidad like ('%Ã‘%')

	update #SedesTemporal
	set sede = replace(sede,'Âº','°'),
		direccion = REPLACE (direccion,'Âº', '°'),
		provincia = REPLACE (provincia,'Âº', '°'),
		localidad = REPLACE(localidad,'Âº', '°')
	where sede like ('%Âº%') or direccion like ('%Âº%') or
			provincia like ('%Âº%') or localidad like ('%Âº%')
	
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
		codepage = ''ACP''
	)'

	exec sp_executesql @sql

	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'Ã¡', 'á'),
		planes = REPLACE (planes,'Ã¡', 'á')
	where prestador like ('%Ã¡%') or planes like ('%Ã¡%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'Ã©','é'),
		planes = REPLACE (planes,'Ã©', 'é')
	where prestador like ('%Ã©%') or planes like ('%Ã©%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'Ã­', 'í'),
		planes = REPLACE (planes,'Ã­', 'í')
	where prestador like ('%Ã­%') or planes like ('%Ã­%')

	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'Ã³', 'ó'),
		planes = REPLACE (planes,'Ã³', 'ó')
	where prestador like ('%Ã³%') or planes like ('%Ã³%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'Ãº','ú'),
		planes = REPLACE (planes,'Ãº', 'ú')
	where prestador like ('%Ãº%') or planes like ('%Ãº%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'Ã', 'Á'),
		planes = REPLACE (planes,'Ã', 'Á')
	where planes like ('%Ã%') or prestador like ('%Ã%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'Ã‰', 'É'),
		planes = REPLACE (planes,'Ã‰', 'É')
	where prestador like ('%Ã‰%') or planes like ('%Ã‰%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'Ã','Í'),
		planes = REPLACE (planes,'Ã', 'Í')
	where prestador like ('%Ã%') or planes like ('%Ã%')


	update #PrestadorTemporal
	set prestador = replace(prestador,'Ã“','Ó'),
		planes = REPLACE (planes,'Ã“', 'Ó')
	where prestador like ('%Ã“%') or planes like ('%Ã“%')


	update #PrestadorTemporal
	set prestador = replace(prestador,'Ãš','Ú'),
		planes = REPLACE (planes,'Ãš', 'Ú')
	where prestador like ('%Ãš%') or planes like ('%Ãš%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'Ã', 'à'),
		planes = REPLACE (planes,'Ã', 'à')
	where prestador like ('%Ã%') or planes like ('%Ã%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'Ã±','ñ'),
		planes = REPLACE (planes,'Ã±', 'ñ')
	where prestador like ('%Ã±%') or planes like ('%Ã±%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'Ã‘','Ñ'),
		planes = REPLACE (planes,'Ã‘', 'Ñ')
	where prestador like ('%Ã‘%') or planes like ('%Ã‘%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'Âº','°'),
		planes = REPLACE (planes,'Âº', '°')
	where prestador like ('%Âº%') or planes like ('%Âº%')

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
		plan_ nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS,
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
			
			area nvarchar(max) ''$.Area'',
			estudio nvarchar(max) ''$.Estudio'',
			prestador nvarchar(max) ''$.Prestador'',
			plan_ nvarchar(max) ''$.Plan'',
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
