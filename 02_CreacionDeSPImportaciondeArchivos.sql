
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

    -- Bucle para encontrar la posici�n del �ltimo n�mero de derecha a izquierda
    WHILE @pos > 0
    BEGIN
        IF SUBSTRING(@cadena, @pos, 1) LIKE '[0-9]'
        BEGIN
            SET @posUltimoNumero = @pos
            BREAK
        END
        SET @pos = @pos - 1
    END

    -- Si no se encontr� ning�n n�mero, devolver cadena vac�a
    IF @posUltimoNumero = -1
        RETURN ''

    -- Inicializar la posici�n de inicio con la posici�n del �ltimo n�mero
    SET @startPos = @posUltimoNumero

    -- Bucle para encontrar la posici�n del inicio de los n�meros consecutivos
    WHILE @startPos > 0 AND SUBSTRING(@cadena, @startPos, 1) LIKE '[0-9]'
    BEGIN
        SET @startPos = @startPos - 1
    END

    -- Ajusta la posici�n inicial para que apunte al primer d�gito del grupo
    SET @startPos = @startPos + 1

    -- Extraer los n�meros
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
	---dos caracteres especiales juntos, por ejemplo, Ord��ez. No he encontrado manera de solucionarlo
	---Pense en usar constains en vez de like pero requiere configurar el motor de base de datos y no es conveniente
	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'á', '�'),
		Apellido = REPLACE (Apellido,'á', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'á', '�'),
		localidad = REPLACE(localidad,'á', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'á', '�')
	where Nombre like ('%á%') or Apellido like ('%á%') or
			Nacionalidad like ('%á%') or localidad like ('%á%') or
			Calle_y_Nro like ('%á%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'é','�'),
		Apellido = REPLACE (Apellido,'é', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'é', '�'),
		localidad = REPLACE(localidad,'é', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'é', '�')
	where Nombre like ('%é%') or Apellido like ('%é%') or
			Nacionalidad like ('%é%') or localidad like ('%é%') or
			Calle_y_Nro like ('%é%')

	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'í', '�'),
		Apellido = REPLACE (Apellido,'í', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'í', '�'),
		localidad = REPLACE(localidad,'í', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'í', '�')
	where Nombre like ('%í%') or Apellido like ('%í%') or
			Nacionalidad like ('%í%') or localidad like ('%í%') or
			Calle_y_Nro like ('%í%')

	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'ó', '�'),
		Apellido = REPLACE (Apellido,'ó', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'ó', '�'),
		localidad = REPLACE(localidad,'ó', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'ó', '�')
	where Nombre like ('%ó%') or Apellido like ('%ó%') or
			Nacionalidad like ('%ó%') or localidad like ('%ó%') or
			Calle_y_Nro like ('%ó%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'ú','�'),
		Apellido = REPLACE (Apellido,'ú', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'ú', '�'),
		localidad = REPLACE(localidad,'ú', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'ú', '�')
	where  Nombre like ('%ú%') or Apellido like ('%ú%') or
			Nacionalidad like ('%ú%') or
			localidad like ('%ú%') or Calle_y_Nro like ('%ú%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'Á', '�'),
		Apellido = REPLACE (Apellido,'Á', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'Á', '�'),
		localidad = REPLACE(localidad,'Á', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Á', '�')
	where Nombre like ('%Á%') or Apellido like ('%Á%') or
			Nacionalidad like ('%Á%') or localidad like ('%Á%') or
			Calle_y_Nro like ('%Á%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'É', '�'),
		Apellido = REPLACE (Apellido,'É', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'É', '�'),
		localidad = REPLACE(localidad,'É', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'É', '�')
	where Nombre like ('%É%') or Apellido like ('%É%') or
			Nacionalidad like ('%É%') or localidad like ('%É%') or
			Calle_y_Nro like ('%É%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'Í','�'),
		Apellido = REPLACE (Apellido,'Í', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'Í', '�'),
		localidad = REPLACE(localidad,'Í', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Í', '�')
	where Nombre like ('%Í%') or Apellido like ('%Í%') or
			Nacionalidad like ('%Í%') or localidad like ('%Í%') or
			Calle_y_Nro like ('%Í%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'Ó','�'),
		Apellido = REPLACE (Apellido,'Ó', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'Ó', '�'),
		localidad = REPLACE(localidad,'Ó', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ó', '�')
	where Nombre like ('%Ó%') or Apellido like ('%Ó%') or
			Nacionalidad like ('%Ó%') or localidad like ('%Ó%') or
			Calle_y_Nro like ('%Ó%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'Ú','�'),
		Apellido = REPLACE (Apellido,'Ú', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'Ú', '�'),
		localidad = REPLACE(localidad,'Ú', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ú', '�')
	where Nombre like ('%Ú%') or Apellido like ('%Ú%') or
			Nacionalidad like ('%Ú%') or localidad like ('%Ú%') or
			Calle_y_Nro like ('%Ú%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'�', '�'),
		Apellido = REPLACE (Apellido,'�', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'�', '�'),
		localidad = REPLACE(localidad,'�', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'�', '�')
	where Nombre like ('%�%') or Apellido like ('%�%') or
			Nacionalidad like ('%�%') or localidad like ('%�%') or
			Calle_y_Nro like ('%�%')

	update #PacientesTemporal
	set Nombre = replace(Nombre,'ñ','�'),
		Apellido = REPLACE (Apellido,'ñ', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'ñ', '�'),
		localidad = REPLACE(localidad,'ñ', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'ñ', '�')
	where Nombre like ('%ñ%') or Apellido like ('%ñ%') or
			Nacionalidad like ('%ñ%') or localidad like ('%ñ%') or
			Calle_y_Nro like ('%ñ%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'Ñ','�'),
		Apellido = REPLACE (Apellido,'Ñ', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'Ñ', '�'),
		localidad = REPLACE(localidad,'Ñ', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ñ', '�')
	where Nombre like ('%Ñ%') or Apellido like ('%Ñ%') or
			Nacionalidad like ('%Ñ%') or localidad like ('%Ñ%') or
			Calle_y_Nro like ('%Ñ%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'º','�'),
		Apellido = REPLACE (Apellido,'º', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'º', '�'),
		localidad = REPLACE(localidad,'º', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'º', '�')
	where Nombre like ('%º%') or Apellido like ('%º%') or
			Nacionalidad like ('%º%') or localidad like ('%º%') or
			Calle_y_Nro like ('%º%')

			
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
	set Especialidad = REPLACE (Especialidad,'á', '�'),
		Apellido = REPLACE (Apellido,'á', '�'),
		Nombre = REPLACE (Nombre, 'á', '�')
	where Especialidad like ('%á%') or Apellido like ('%á%') or Nombre like('%á%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'é','�'),
		Apellido = REPLACE (Apellido,'é', '�'),
		Nombre = REPLACE (Nombre,'é', '�')
	where Especialidad like ('%é%') or Apellido like ('%é%') or Nombre like('%é%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'í', '�'),
		Apellido = REPLACE (Apellido,'í', '�'),
		Nombre = REPLACE (Nombre,'í', '�')
	where Especialidad like ('%í%') or Apellido like ('%í%') or Nombre like ('%í%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'ó', '�'),
		Apellido = REPLACE (Apellido,'ó', '�'),
		Nombre = REPLACE (Nombre,'ó', '�')
	where Especialidad like ('%ó%') or Apellido like ('%ó%') or Nombre like ('%ó%') 

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'ú','�'),
		Apellido = REPLACE (Apellido,'ú', '�'),
		Nombre = REPLACE (Nombre,'ú', '�')
	where  Especialidad like ('%ú%') or Apellido like ('%ú%') or Nombre like ('%ú%')


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'Á', '�'),
		Apellido = REPLACE (Apellido,'Á', '�'),
		Nombre = REPLACE (Nombre,'Á', '�')
	where Especialidad like ('%Á%') or Apellido like ('%Á%') or Nombre like ('%Á%')


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'É', '�'),
		Apellido = REPLACE (Apellido,'É', '�'),
		Nombre = REPLACE (Nombre,'É', '�')
	where Especialidad like ('%É%') or Apellido like ('%É%')  or Nombre like ('%É%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Í','�'),
		Apellido = REPLACE (Apellido,'Í', '�'),
		Nombre = REPLACE (Nombre,'Í', '�')
	where Especialidad like ('%Í%') or Apellido like ('%Í%') or Nombre like ('%Í%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ó','�'),
		Apellido = REPLACE (Apellido,'Ó', '�'),
		Nombre = REPLACE (Nombre,'Ó', '�')
	where Especialidad like ('%Ó%') or Apellido like ('%Ó%') or Nombre like ('%Ó%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ú','�'),
		Apellido = REPLACE (Apellido,'Ú', '�'),
		Nombre = REPLACE (Nombre,'Ú', '�')
	where Especialidad like ('%Ú%') or Apellido like ('%Ú%')or Nombre like ('%Ú%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'�', '�'),
		Apellido = REPLACE (Apellido,'�', '�'),
		Nombre = REPLACE (Nombre,'�', '�')
	where Especialidad like ('%�%') or Apellido like ('%�%') or Nombre like ('%�%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'ñ','�'),
		Apellido = REPLACE (Apellido,'ñ', '�'),
		Nombre = REPLACE (Nombre,'ñ', '�')
	where Especialidad like ('%ñ%') or Apellido like ('%ñ%') or Nombre like ('%ñ%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ñ','�'),
		Apellido = REPLACE (Apellido,'Ñ', '�'),
		Nombre = REPLACE (Nombre,'Ñ', '�')
	where Especialidad like ('%Ñ%') or Apellido like ('%Ñ%')or Nombre like ('%Ñ%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'º','�'),
		Apellido = REPLACE (Apellido,'º', '�'),
		Nombre = REPLACE (Nombre,'º', '�')
	where Especialidad like ('%º%') or Apellido like ('%º%') or Nombre like ('%º%')

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
	set sede = REPLACE (sede,'á', '�'),
		provincia = REPLACE (provincia,'á', '�'),
		direccion = REPLACE (direccion,'á', '�'),
		localidad = REPLACE(localidad,'á', '�')
	where sede like ('%á%') or provincia like ('%á%') or
			direccion like ('%á%') or localidad like ('%á%')

	update #SedesTemporal
	set sede = replace(sede,'é','�'),
		provincia = REPLACE (provincia,'é', '�'),
		direccion = REPLACE (direccion,'é', '�'),
		localidad = REPLACE(localidad,'é', '�')
	where sede like ('%é%') or provincia like ('%é%') or
			direccion like ('%é%') or localidad like ('%é%')


	update #SedesTemporal
	set sede = REPLACE (sede,'í', '�'),
		provincia = REPLACE (provincia,'í', '�'),
		direccion = REPLACE (direccion,'í', '�'),
		localidad = REPLACE(localidad,'í', '�')
	where provincia like ('%í%') or sede like ('%í%') or
			direccion like ('%í%') or localidad like ('%í%')

	update #SedesTemporal
	set sede = REPLACE (sede,'ó', '�'),
		direccion = REPLACE (direccion,'ó', '�'),
		provincia = REPLACE (provincia,'ó', '�'),
		localidad = REPLACE(localidad,'ó', '�')
	where sede like ('%ó%') or provincia like ('%ó%') or
			direccion like ('%ó%') or localidad like ('%ó%')

	update #SedesTemporal
	set sede = replace(sede,'ú','�'),
		direccion = REPLACE (direccion,'ú', '�'),
		provincia = REPLACE (provincia,'ú', '�'),
		localidad = REPLACE(localidad,'ú', '�')
	where sede like ('%ú%') or direccion like ('%ú%') or
			provincia like ('%ú%') or localidad like ('%ú%')


	update #SedesTemporal
	set sede = REPLACE (sede,'Á', '�'),
		direccion = REPLACE (direccion,'Á', '�'),
		provincia = REPLACE (provincia,'Á', '�'),
		localidad = REPLACE(localidad,'Á', '�')
	where sede like ('%Á%') or direccion like ('%Á%') or
			provincia like ('%Á%') or localidad like ('%Á%')


	update #SedesTemporal
	set sede = REPLACE (sede,'É', '�'),
		direccion = REPLACE (direccion,'É', '�'),
		provincia = REPLACE (provincia,'É', '�'),
		localidad = REPLACE(localidad,'É', '�')
	where sede like ('%É%') or direccion like ('%É%') or
			provincia like ('%É%') or localidad like ('%É%')

	update #SedesTemporal
	set sede = replace(sede,'Í','�'),
		direccion = REPLACE (direccion,'Í', '�'),
		provincia = REPLACE (provincia,'Í', '�'),
		localidad = REPLACE(localidad,'Í', '�')
	where sede like ('%Í%') or direccion like ('%Í%') or
			provincia like ('%Í%') or localidad like ('%Í%')


	update #SedesTemporal
	set sede = replace(sede,'Ó','�'),
		direccion = REPLACE (direccion,'Ó', '�'),
		provincia = REPLACE (provincia,'Ó', '�'),
		localidad = REPLACE(localidad,'Ó', '�')
	where sede like ('%Ó%') or direccion like ('%Ó%') or
			provincia like ('%Ó%') or localidad like ('%Ó%')


	update #SedesTemporal
	set sede = replace(sede,'Ú','�'),
		direccion = REPLACE (direccion,'Ú', '�'),
		provincia = REPLACE (provincia,'Ú', '�'),
		localidad = REPLACE(localidad,'Ú', '�')
	where sede like ('%Ú%') or direccion like ('%Ú%') or
			provincia like ('%Ú%') or localidad like ('%Ú%')


	update #SedesTemporal
	set sede = REPLACE (sede,'�', '�'),
		direccion = REPLACE (direccion,'�', '�'),
		provincia = REPLACE (provincia,'�', '�'),
		localidad = REPLACE(localidad,'�', '�')
	where sede like ('%�%') or direccion like ('%�%') or
			provincia like ('%�%') or localidad like ('%�%')

	update #SedesTemporal
	set sede = replace(sede,'ñ','�'),
		direccion = REPLACE (direccion,'ñ', '�'),
		provincia = REPLACE (provincia,'ñ', '�'),
		localidad = REPLACE(localidad,'ñ', '�')
	where sede like ('%ñ%') or direccion like ('%ñ%') or
			provincia like ('%ñ%') or localidad like ('%ñ%')

	update #SedesTemporal
	set sede = replace(sede,'Ñ','�'),
		direccion = REPLACE (direccion,'Ñ', '�'),
		provincia = REPLACE (provincia,'Ñ', '�'),
		localidad = REPLACE(localidad,'Ñ', '�')
	where sede like ('%Ñ%') or direccion like ('%Ñ%') or
			provincia like ('%Ñ%') or localidad like ('%Ñ%')

	update #SedesTemporal
	set sede = replace(sede,'º','�'),
		direccion = REPLACE (direccion,'º', '�'),
		provincia = REPLACE (provincia,'º', '�'),
		localidad = REPLACE(localidad,'º', '�')
	where sede like ('%º%') or direccion like ('%º%') or
			provincia like ('%º%') or localidad like ('%º%')
	
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
	set prestador = REPLACE (prestador,'á', '�'),
		planes = REPLACE (planes,'á', '�')
	where prestador like ('%á%') or planes like ('%á%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'é','�'),
		planes = REPLACE (planes,'é', '�')
	where prestador like ('%é%') or planes like ('%é%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'í', '�'),
		planes = REPLACE (planes,'í', '�')
	where prestador like ('%í%') or planes like ('%í%')

	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'ó', '�'),
		planes = REPLACE (planes,'ó', '�')
	where prestador like ('%ó%') or planes like ('%ó%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'ú','�'),
		planes = REPLACE (planes,'ú', '�')
	where prestador like ('%ú%') or planes like ('%ú%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'Á', '�'),
		planes = REPLACE (planes,'Á', '�')
	where planes like ('%Á%') or prestador like ('%Á%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'É', '�'),
		planes = REPLACE (planes,'É', '�')
	where prestador like ('%É%') or planes like ('%É%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'Í','�'),
		planes = REPLACE (planes,'Í', '�')
	where prestador like ('%Í%') or planes like ('%Í%')


	update #PrestadorTemporal
	set prestador = replace(prestador,'Ó','�'),
		planes = REPLACE (planes,'Ó', '�')
	where prestador like ('%Ó%') or planes like ('%Ó%')


	update #PrestadorTemporal
	set prestador = replace(prestador,'Ú','�'),
		planes = REPLACE (planes,'Ú', '�')
	where prestador like ('%Ú%') or planes like ('%Ú%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'�', '�'),
		planes = REPLACE (planes,'�', '�')
	where prestador like ('%�%') or planes like ('%�%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'ñ','�'),
		planes = REPLACE (planes,'ñ', '�')
	where prestador like ('%ñ%') or planes like ('%ñ%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'Ñ','�'),
		planes = REPLACE (planes,'Ñ', '�')
	where prestador like ('%Ñ%') or planes like ('%Ñ%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'º','�'),
		planes = REPLACE (planes,'º', '�')
	where prestador like ('%º%') or planes like ('%º%')

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
		area nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS,
		estudio nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS,
		prestador nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS,
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
	set area = REPLACE (area,'á', '�'),
		estudio = REPLACE (estudio,'á', '�'),
		prestador = REPLACE (prestador,'á', '�'),
		plan_ = REPLACE(plan_,'á', '�')
	where area like ('%á%') or estudio like ('%á%') or
			prestador like ('%á%') or plan_ like ('%á%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'é','�'),
		estudio = REPLACE (estudio,'é', '�'),
		prestador = REPLACE (prestador,'é', '�'),
		plan_ = REPLACE(plan_,'é', '�')
	where area like ('%é%') or estudio like ('%é%') or
			prestador like ('%é%') or plan_ like ('%é%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'í', '�'),
		estudio = REPLACE (estudio,'í', '�'),
		prestador = REPLACE (prestador,'í', '�'),
		plan_ = REPLACE(plan_,'í', '�')
	where estudio like ('%í%') or area like ('%í%') or
			prestador like ('%í%') or plan_ like ('%í%')

	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'ó', '�'),
		prestador = REPLACE (prestador,'ó', '�'),
		estudio = REPLACE (estudio,'ó', '�'),
		plan_ = REPLACE(plan_,'ó', '�')
	where area like ('%ó%') or estudio like ('%ó%') or
			prestador like ('%ó%') or plan_ like ('%ó%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'ú','�'),
		prestador = REPLACE (prestador,'ú', '�'),
		estudio = REPLACE (estudio,'ú', '�'),
		plan_ = REPLACE(plan_,'ú', '�')
	where area like ('%ú%') or prestador like ('%ú%') or
			estudio like ('%ú%') or plan_ like ('%ú%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'Á', '�'),
		prestador = REPLACE (prestador,'Á', '�'),
		estudio = REPLACE (estudio,'Á', '�'),
		plan_ = REPLACE(plan_,'Á', '�')
	where area like ('%Á%') or prestador like ('%Á%') or
			estudio like ('%Á%') or plan_ like ('%Á%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'É', '�'),
		prestador = REPLACE (prestador,'É', '�'),
		estudio = REPLACE (estudio,'É', '�'),
		plan_ = REPLACE(plan_,'É', '�')
	where area like ('%É%') or prestador like ('%É%') or
			estudio like ('%É%') or plan_ like ('%É%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'Í','�'),
		prestador = REPLACE (prestador,'Í', '�'),
		estudio = REPLACE (estudio,'Í', '�'),
		plan_ = REPLACE(plan_,'Í', '�')
	where area like ('%Í%') or prestador like ('%Í%') or
			estudio like ('%Í%') or plan_ like ('%Í%')


	update #AutorizacionEstudiosTemp
	set area = replace(area,'Ó','�'),
		prestador = REPLACE (prestador,'Ó', '�'),
		estudio = REPLACE (estudio,'Ó', '�'),
		plan_ = REPLACE(plan_,'Ó', '�')
	where area like ('%Ó%') or prestador like ('%Ó%') or
			estudio like ('%Ó%') or plan_ like ('%Ó%')


	update #AutorizacionEstudiosTemp
	set area = replace(area,'Ú','�'),
		prestador = REPLACE (prestador,'Ú', '�'),
		estudio = REPLACE (estudio,'Ú', '�'),
		plan_ = REPLACE(plan_,'Ú', '�')
	where area like ('%Ú%') or prestador like ('%Ú%') or
			estudio like ('%Ú%') or plan_ like ('%Ú%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'�', '�'),
		prestador = REPLACE (prestador,'�', '�'),
		estudio = REPLACE (estudio,'�', '�'),
		plan_ = REPLACE(plan_,'�', '�')
	where area like ('%�%') or prestador like ('%�%') or
			estudio like ('%�%') or plan_ like ('%�%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'ñ','�'),
		prestador = REPLACE (prestador,'ñ', '�'),
		estudio = REPLACE (estudio,'ñ', '�'),
		plan_ = REPLACE(plan_,'ñ', '�')
	where area like ('%ñ%') or prestador like ('%ñ%') or
			estudio like ('%ñ%') or plan_ like ('%ñ%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'Ñ','�'),
		prestador = REPLACE (prestador,'Ñ', '�'),
		estudio = REPLACE (estudio,'Ñ', '�'),
		plan_ = REPLACE(plan_,'Ñ', '�')
	where area like ('%Ñ%') or prestador like ('%Ñ%') or
			estudio like ('%Ñ%') or plan_ like ('%Ñ%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'º','�'),
		prestador = REPLACE (prestador,'º', '�'),
		estudio = REPLACE (estudio,'º', '�'),
		plan_ = REPLACE(plan_,'º', '�')
	where area like ('%º%') or prestador like ('%º%') or
			estudio like ('%º%') or plan_ like ('%º%')
	
	
	delete from #AutorizacionEstudiosTemp   --elimino si hay algun null en la temporal
	where estudio is null


	insert into servicio.autorizacion_de_estudio				--inserto en la base de datos
		select area,estudio,prestador,plan_ ,[Porcentaje Cobertura],costo,[Requiere autorizacion]  
		from #AutorizacionEstudiosTemp t
		where not exists(select 1 
						from servicio.autorizacion_de_estudio a
						where (t.area=a.area and t.estudio=a.estudio and t.prestador=a.prestador and t.plan_=a.plan_) or t.area is null )   --no inserta repetidos


end