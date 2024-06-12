
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

    -- Bucle para encontrar la posiciÛn del ˙ltimo n˙mero de derecha a izquierda
    WHILE @pos > 0
    BEGIN
        IF SUBSTRING(@cadena, @pos, 1) LIKE '[0-9]'
        BEGIN
            SET @posUltimoNumero = @pos
            BREAK
        END
        SET @pos = @pos - 1
    END

    -- Si no se encontrÛ ning˙n n˙mero, devolver cadena vacÌa
    IF @posUltimoNumero = -1
        RETURN ''

    -- Inicializar la posiciÛn de inicio con la posiciÛn del ˙ltimo n˙mero
    SET @startPos = @posUltimoNumero

    -- Bucle para encontrar la posiciÛn del inicio de los n˙meros consecutivos
    WHILE @startPos > 0 AND SUBSTRING(@cadena, @startPos, 1) LIKE '[0-9]'
    BEGIN
        SET @startPos = @startPos - 1
    END

    -- Ajusta la posiciÛn inicial para que apunte al primer dÌgito del grupo
    SET @startPos = @startPos + 1

    -- Extraer los n˙meros
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
	---dos caracteres especiales juntos, por ejemplo, OrdÛÒez. No he encontrado manera de solucionarlo
	---Pense en usar constains en vez de like pero requiere configurar el motor de base de datos y no es conveniente
	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√°', '·'),
		Apellido = REPLACE (Apellido,'√°', '·'),
		Nacionalidad = REPLACE (Nacionalidad,'√°', '·'),
		localidad = REPLACE(localidad,'√°', '·'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√°', '·')
	where Nombre like ('%√°%') or Apellido like ('%√°%') or
			Nacionalidad like ('%√°%') or localidad like ('%√°%') or
			Calle_y_Nro like ('%√°%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'√©','È'),
		Apellido = REPLACE (Apellido,'√©', 'È'),
		Nacionalidad = REPLACE (Nacionalidad,'√©', 'È'),
		localidad = REPLACE(localidad,'√©', 'È'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√©', 'È')
	where Nombre like ('%√©%') or Apellido like ('%√©%') or
			Nacionalidad like ('%√©%') or localidad like ('%√©%') or
			Calle_y_Nro like ('%√©%')

	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√≠', 'Ì'),
		Apellido = REPLACE (Apellido,'√≠', 'Ì'),
		Nacionalidad = REPLACE (Nacionalidad,'√≠', 'Ì'),
		localidad = REPLACE(localidad,'√≠', 'Ì'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√≠', 'Ì')
	where Nombre like ('%√≠%') or Apellido like ('%√≠%') or
			Nacionalidad like ('%√≠%') or localidad like ('%√≠%') or
			Calle_y_Nro like ('%√≠%')

	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√≥', 'Û'),
		Apellido = REPLACE (Apellido,'√≥', 'Û'),
		Nacionalidad = REPLACE (Nacionalidad,'√≥', 'Û'),
		localidad = REPLACE(localidad,'√≥', 'Û'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√≥', 'Û')
	where Nombre like ('%√≥%') or Apellido like ('%√≥%') or
			Nacionalidad like ('%√≥%') or localidad like ('%√≥%') or
			Calle_y_Nro like ('%√≥%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'√∫','˙'),
		Apellido = REPLACE (Apellido,'√∫', '˙'),
		Nacionalidad = REPLACE (Nacionalidad,'√∫', '˙'),
		localidad = REPLACE(localidad,'√∫', '˙'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√∫', '˙')
	where  Nombre like ('%√∫%') or Apellido like ('%√∫%') or
			Nacionalidad like ('%√∫%') or
			localidad like ('%√∫%') or Calle_y_Nro like ('%√∫%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√Å', '¡'),
		Apellido = REPLACE (Apellido,'√Å', '¡'),
		Nacionalidad = REPLACE (Nacionalidad,'√Å', '¡'),
		localidad = REPLACE(localidad,'√Å', '¡'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√Å', '¡')
	where Nombre like ('%√Å%') or Apellido like ('%√Å%') or
			Nacionalidad like ('%√Å%') or localidad like ('%√Å%') or
			Calle_y_Nro like ('%√Å%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√â', '…'),
		Apellido = REPLACE (Apellido,'√â', '…'),
		Nacionalidad = REPLACE (Nacionalidad,'√â', '…'),
		localidad = REPLACE(localidad,'√â', '…'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√â', '…')
	where Nombre like ('%√â%') or Apellido like ('%√â%') or
			Nacionalidad like ('%√â%') or localidad like ('%√â%') or
			Calle_y_Nro like ('%√â%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'√ç','Õ'),
		Apellido = REPLACE (Apellido,'√ç', 'Õ'),
		Nacionalidad = REPLACE (Nacionalidad,'√ç', 'Õ'),
		localidad = REPLACE(localidad,'√ç', 'Õ'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√ç', 'Õ')
	where Nombre like ('%√ç%') or Apellido like ('%√ç%') or
			Nacionalidad like ('%√ç%') or localidad like ('%√ç%') or
			Calle_y_Nro like ('%√ç%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'√ì','”'),
		Apellido = REPLACE (Apellido,'√ì', '”'),
		Nacionalidad = REPLACE (Nacionalidad,'√ì', '”'),
		localidad = REPLACE(localidad,'√ì', '”'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√ì', '”')
	where Nombre like ('%√ì%') or Apellido like ('%√ì%') or
			Nacionalidad like ('%√ì%') or localidad like ('%√ì%') or
			Calle_y_Nro like ('%√ì%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'√ö','⁄'),
		Apellido = REPLACE (Apellido,'√ö', '⁄'),
		Nacionalidad = REPLACE (Nacionalidad,'√ö', '⁄'),
		localidad = REPLACE(localidad,'√ö', '⁄'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√ö', '⁄')
	where Nombre like ('%√ö%') or Apellido like ('%√ö%') or
			Nacionalidad like ('%√ö%') or localidad like ('%√ö%') or
			Calle_y_Nro like ('%√ö%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√', '‡'),
		Apellido = REPLACE (Apellido,'√', '‡'),
		Nacionalidad = REPLACE (Nacionalidad,'√', '‡'),
		localidad = REPLACE(localidad,'√', '‡'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√', '‡')
	where Nombre like ('%√%') or Apellido like ('%√%') or
			Nacionalidad like ('%√%') or localidad like ('%√%') or
			Calle_y_Nro like ('%√%')

	update #PacientesTemporal
	set Nombre = replace(Nombre,'√±','Ò'),
		Apellido = REPLACE (Apellido,'√±', 'Ò'),
		Nacionalidad = REPLACE (Nacionalidad,'√±', 'Ò'),
		localidad = REPLACE(localidad,'√±', 'Ò'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√±', 'Ò')
	where Nombre like ('%√±%') or Apellido like ('%√±%') or
			Nacionalidad like ('%√±%') or localidad like ('%√±%') or
			Calle_y_Nro like ('%√±%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'√ë','—'),
		Apellido = REPLACE (Apellido,'√ë', '—'),
		Nacionalidad = REPLACE (Nacionalidad,'√ë', '—'),
		localidad = REPLACE(localidad,'√ë', '—'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√ë', '—')
	where Nombre like ('%√ë%') or Apellido like ('%√ë%') or
			Nacionalidad like ('%√ë%') or localidad like ('%√ë%') or
			Calle_y_Nro like ('%√ë%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'¬∫','∞'),
		Apellido = REPLACE (Apellido,'¬∫', '∞'),
		Nacionalidad = REPLACE (Nacionalidad,'¬∫', '∞'),
		localidad = REPLACE(localidad,'¬∫', '∞'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'¬∫', '∞')
	where Nombre like ('%¬∫%') or Apellido like ('%¬∫%') or
			Nacionalidad like ('%¬∫%') or localidad like ('%¬∫%') or
			Calle_y_Nro like ('%¬∫%')

			
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
	set Especialidad = REPLACE (Especialidad,'√°', '·'),
		Apellido = REPLACE (Apellido,'√°', '·'),
		Nombre = REPLACE (Nombre, '√°', '·')
	where Especialidad like ('%√°%') or Apellido like ('%√°%') or Nombre like('%√°%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√©','È'),
		Apellido = REPLACE (Apellido,'√©', 'È'),
		Nombre = REPLACE (Nombre,'√©', 'È')
	where Especialidad like ('%√©%') or Apellido like ('%√©%') or Nombre like('%√©%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√≠', 'Ì'),
		Apellido = REPLACE (Apellido,'√≠', 'Ì'),
		Nombre = REPLACE (Nombre,'√≠', 'Ì')
	where Especialidad like ('%√≠%') or Apellido like ('%√≠%') or Nombre like ('%√≠%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√≥', 'Û'),
		Apellido = REPLACE (Apellido,'√≥', 'Û'),
		Nombre = REPLACE (Nombre,'√≥', 'Û')
	where Especialidad like ('%√≥%') or Apellido like ('%√≥%') or Nombre like ('%√≥%') 

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√∫','˙'),
		Apellido = REPLACE (Apellido,'√∫', '˙'),
		Nombre = REPLACE (Nombre,'√∫', '˙')
	where  Especialidad like ('%√∫%') or Apellido like ('%√∫%') or Nombre like ('%√∫%')


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√Å', '¡'),
		Apellido = REPLACE (Apellido,'√Å', '¡'),
		Nombre = REPLACE (Nombre,'√Å', '¡')
	where Especialidad like ('%√Å%') or Apellido like ('%√Å%') or Nombre like ('%√Å%')


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√â', '…'),
		Apellido = REPLACE (Apellido,'√â', '…'),
		Nombre = REPLACE (Nombre,'√â', '…')
	where Especialidad like ('%√â%') or Apellido like ('%√â%')  or Nombre like ('%√â%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√ç','Õ'),
		Apellido = REPLACE (Apellido,'√ç', 'Õ'),
		Nombre = REPLACE (Nombre,'√ç', 'Õ')
	where Especialidad like ('%√ç%') or Apellido like ('%√ç%') or Nombre like ('%√ç%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√ì','”'),
		Apellido = REPLACE (Apellido,'√ì', '”'),
		Nombre = REPLACE (Nombre,'√ì', '”')
	where Especialidad like ('%√ì%') or Apellido like ('%√ì%') or Nombre like ('%√ì%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√ö','⁄'),
		Apellido = REPLACE (Apellido,'√ö', '⁄'),
		Nombre = REPLACE (Nombre,'√ö', '⁄')
	where Especialidad like ('%√ö%') or Apellido like ('%√ö%')or Nombre like ('%√ö%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√', '‡'),
		Apellido = REPLACE (Apellido,'√', '‡'),
		Nombre = REPLACE (Nombre,'√', '‡')
	where Especialidad like ('%√%') or Apellido like ('%√%') or Nombre like ('%√%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√±','Ò'),
		Apellido = REPLACE (Apellido,'√±', 'Ò'),
		Nombre = REPLACE (Nombre,'√±', 'Ò')
	where Especialidad like ('%√±%') or Apellido like ('%√±%') or Nombre like ('%√±%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√ë','—'),
		Apellido = REPLACE (Apellido,'√ë', '—'),
		Nombre = REPLACE (Nombre,'√ë', '—')
	where Especialidad like ('%√ë%') or Apellido like ('%√ë%')or Nombre like ('%√ë%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'¬∫','∞'),
		Apellido = REPLACE (Apellido,'¬∫', '∞'),
		Nombre = REPLACE (Nombre,'¬∫', '∞')
	where Especialidad like ('%¬∫%') or Apellido like ('%¬∫%') or Nombre like ('%¬∫%')

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
	set sede = REPLACE (sede,'√°', '·'),
		provincia = REPLACE (provincia,'√°', '·'),
		direccion = REPLACE (direccion,'√°', '·'),
		localidad = REPLACE(localidad,'√°', '·')
	where sede like ('%√°%') or provincia like ('%√°%') or
			direccion like ('%√°%') or localidad like ('%√°%')

	update #SedesTemporal
	set sede = replace(sede,'√©','È'),
		provincia = REPLACE (provincia,'√©', 'È'),
		direccion = REPLACE (direccion,'√©', 'È'),
		localidad = REPLACE(localidad,'√©', 'È')
	where sede like ('%√©%') or provincia like ('%√©%') or
			direccion like ('%√©%') or localidad like ('%√©%')


	update #SedesTemporal
	set sede = REPLACE (sede,'√≠', 'Ì'),
		provincia = REPLACE (provincia,'√≠', 'Ì'),
		direccion = REPLACE (direccion,'√≠', 'Ì'),
		localidad = REPLACE(localidad,'√≠', 'Ì')
	where provincia like ('%√≠%') or sede like ('%√≠%') or
			direccion like ('%√≠%') or localidad like ('%√≠%')

	update #SedesTemporal
	set sede = REPLACE (sede,'√≥', 'Û'),
		direccion = REPLACE (direccion,'√≥', 'Û'),
		provincia = REPLACE (provincia,'√≥', 'Û'),
		localidad = REPLACE(localidad,'√≥', 'Û')
	where sede like ('%√≥%') or provincia like ('%√≥%') or
			direccion like ('%√≥%') or localidad like ('%√≥%')

	update #SedesTemporal
	set sede = replace(sede,'√∫','˙'),
		direccion = REPLACE (direccion,'√∫', '˙'),
		provincia = REPLACE (provincia,'√∫', '˙'),
		localidad = REPLACE(localidad,'√∫', '˙')
	where sede like ('%√∫%') or direccion like ('%√∫%') or
			provincia like ('%√∫%') or localidad like ('%√∫%')


	update #SedesTemporal
	set sede = REPLACE (sede,'√Å', '¡'),
		direccion = REPLACE (direccion,'√Å', '¡'),
		provincia = REPLACE (provincia,'√Å', '¡'),
		localidad = REPLACE(localidad,'√Å', '¡')
	where sede like ('%√Å%') or direccion like ('%√Å%') or
			provincia like ('%√Å%') or localidad like ('%√Å%')


	update #SedesTemporal
	set sede = REPLACE (sede,'√â', '…'),
		direccion = REPLACE (direccion,'√â', '…'),
		provincia = REPLACE (provincia,'√â', '…'),
		localidad = REPLACE(localidad,'√â', '…')
	where sede like ('%√â%') or direccion like ('%√â%') or
			provincia like ('%√â%') or localidad like ('%√â%')

	update #SedesTemporal
	set sede = replace(sede,'√ç','Õ'),
		direccion = REPLACE (direccion,'√ç', 'Õ'),
		provincia = REPLACE (provincia,'√ç', 'Õ'),
		localidad = REPLACE(localidad,'√ç', 'Õ')
	where sede like ('%√ç%') or direccion like ('%√ç%') or
			provincia like ('%√ç%') or localidad like ('%√ç%')


	update #SedesTemporal
	set sede = replace(sede,'√ì','”'),
		direccion = REPLACE (direccion,'√ì', '”'),
		provincia = REPLACE (provincia,'√ì', '”'),
		localidad = REPLACE(localidad,'√ì', '”')
	where sede like ('%√ì%') or direccion like ('%√ì%') or
			provincia like ('%√ì%') or localidad like ('%√ì%')


	update #SedesTemporal
	set sede = replace(sede,'√ö','⁄'),
		direccion = REPLACE (direccion,'√ö', '⁄'),
		provincia = REPLACE (provincia,'√ö', '⁄'),
		localidad = REPLACE(localidad,'√ö', '⁄')
	where sede like ('%√ö%') or direccion like ('%√ö%') or
			provincia like ('%√ö%') or localidad like ('%√ö%')


	update #SedesTemporal
	set sede = REPLACE (sede,'√', '‡'),
		direccion = REPLACE (direccion,'√', '‡'),
		provincia = REPLACE (provincia,'√', '‡'),
		localidad = REPLACE(localidad,'√', '‡')
	where sede like ('%√%') or direccion like ('%√%') or
			provincia like ('%√%') or localidad like ('%√%')

	update #SedesTemporal
	set sede = replace(sede,'√±','Ò'),
		direccion = REPLACE (direccion,'√±', 'Ò'),
		provincia = REPLACE (provincia,'√±', 'Ò'),
		localidad = REPLACE(localidad,'√±', 'Ò')
	where sede like ('%√±%') or direccion like ('%√±%') or
			provincia like ('%√±%') or localidad like ('%√±%')

	update #SedesTemporal
	set sede = replace(sede,'√ë','—'),
		direccion = REPLACE (direccion,'√ë', '—'),
		provincia = REPLACE (provincia,'√ë', '—'),
		localidad = REPLACE(localidad,'√ë', '—')
	where sede like ('%√ë%') or direccion like ('%√ë%') or
			provincia like ('%√ë%') or localidad like ('%√ë%')

	update #SedesTemporal
	set sede = replace(sede,'¬∫','∞'),
		direccion = REPLACE (direccion,'¬∫', '∞'),
		provincia = REPLACE (provincia,'¬∫', '∞'),
		localidad = REPLACE(localidad,'¬∫', '∞')
	where sede like ('%¬∫%') or direccion like ('%¬∫%') or
			provincia like ('%¬∫%') or localidad like ('%¬∫%')
	
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
	set prestador = REPLACE (prestador,'√°', '·'),
		planes = REPLACE (planes,'√°', '·')
	where prestador like ('%√°%') or planes like ('%√°%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'√©','È'),
		planes = REPLACE (planes,'√©', 'È')
	where prestador like ('%√©%') or planes like ('%√©%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'√≠', 'Ì'),
		planes = REPLACE (planes,'√≠', 'Ì')
	where prestador like ('%√≠%') or planes like ('%√≠%')

	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'√≥', 'Û'),
		planes = REPLACE (planes,'√≥', 'Û')
	where prestador like ('%√≥%') or planes like ('%√≥%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'√∫','˙'),
		planes = REPLACE (planes,'√∫', '˙')
	where prestador like ('%√∫%') or planes like ('%√∫%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'√Å', '¡'),
		planes = REPLACE (planes,'√Å', '¡')
	where planes like ('%√Å%') or prestador like ('%√Å%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'√â', '…'),
		planes = REPLACE (planes,'√â', '…')
	where prestador like ('%√â%') or planes like ('%√â%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'√ç','Õ'),
		planes = REPLACE (planes,'√ç', 'Õ')
	where prestador like ('%√ç%') or planes like ('%√ç%')


	update #PrestadorTemporal
	set prestador = replace(prestador,'√ì','”'),
		planes = REPLACE (planes,'√ì', '”')
	where prestador like ('%√ì%') or planes like ('%√ì%')


	update #PrestadorTemporal
	set prestador = replace(prestador,'√ö','⁄'),
		planes = REPLACE (planes,'√ö', '⁄')
	where prestador like ('%√ö%') or planes like ('%√ö%')


	update #PrestadorTemporal
	set prestador = REPLACE (prestador,'√', '‡'),
		planes = REPLACE (planes,'√', '‡')
	where prestador like ('%√%') or planes like ('%√%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'√±','Ò'),
		planes = REPLACE (planes,'√±', 'Ò')
	where prestador like ('%√±%') or planes like ('%√±%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'√ë','—'),
		planes = REPLACE (planes,'√ë', '—')
	where prestador like ('%√ë%') or planes like ('%√ë%')

	update #PrestadorTemporal
	set prestador = replace(prestador,'¬∫','∞'),
		planes = REPLACE (planes,'¬∫', '∞')
	where prestador like ('%¬∫%') or planes like ('%¬∫%')

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
	set area = REPLACE (area,'√°', '·'),
		estudio = REPLACE (estudio,'√°', '·'),
		prestador = REPLACE (prestador,'√°', '·'),
		plan_ = REPLACE(plan_,'√°', '·')
	where area like ('%√°%') or estudio like ('%√°%') or
			prestador like ('%√°%') or plan_ like ('%√°%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'√©','È'),
		estudio = REPLACE (estudio,'√©', 'È'),
		prestador = REPLACE (prestador,'√©', 'È'),
		plan_ = REPLACE(plan_,'√©', 'È')
	where area like ('%√©%') or estudio like ('%√©%') or
			prestador like ('%√©%') or plan_ like ('%√©%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'√≠', 'Ì'),
		estudio = REPLACE (estudio,'√≠', 'Ì'),
		prestador = REPLACE (prestador,'√≠', 'Ì'),
		plan_ = REPLACE(plan_,'√≠', 'Ì')
	where estudio like ('%√≠%') or area like ('%√≠%') or
			prestador like ('%√≠%') or plan_ like ('%√≠%')

	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'√≥', 'Û'),
		prestador = REPLACE (prestador,'√≥', 'Û'),
		estudio = REPLACE (estudio,'√≥', 'Û'),
		plan_ = REPLACE(plan_,'√≥', 'Û')
	where area like ('%√≥%') or estudio like ('%√≥%') or
			prestador like ('%√≥%') or plan_ like ('%√≥%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'√∫','˙'),
		prestador = REPLACE (prestador,'√∫', '˙'),
		estudio = REPLACE (estudio,'√∫', '˙'),
		plan_ = REPLACE(plan_,'√∫', '˙')
	where area like ('%√∫%') or prestador like ('%√∫%') or
			estudio like ('%√∫%') or plan_ like ('%√∫%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'√Å', '¡'),
		prestador = REPLACE (prestador,'√Å', '¡'),
		estudio = REPLACE (estudio,'√Å', '¡'),
		plan_ = REPLACE(plan_,'√Å', '¡')
	where area like ('%√Å%') or prestador like ('%√Å%') or
			estudio like ('%√Å%') or plan_ like ('%√Å%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'√â', '…'),
		prestador = REPLACE (prestador,'√â', '…'),
		estudio = REPLACE (estudio,'√â', '…'),
		plan_ = REPLACE(plan_,'√â', '…')
	where area like ('%√â%') or prestador like ('%√â%') or
			estudio like ('%√â%') or plan_ like ('%√â%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'√ç','Õ'),
		prestador = REPLACE (prestador,'√ç', 'Õ'),
		estudio = REPLACE (estudio,'√ç', 'Õ'),
		plan_ = REPLACE(plan_,'√ç', 'Õ')
	where area like ('%√ç%') or prestador like ('%√ç%') or
			estudio like ('%√ç%') or plan_ like ('%√ç%')


	update #AutorizacionEstudiosTemp
	set area = replace(area,'√ì','”'),
		prestador = REPLACE (prestador,'√ì', '”'),
		estudio = REPLACE (estudio,'√ì', '”'),
		plan_ = REPLACE(plan_,'√ì', '”')
	where area like ('%√ì%') or prestador like ('%√ì%') or
			estudio like ('%√ì%') or plan_ like ('%√ì%')


	update #AutorizacionEstudiosTemp
	set area = replace(area,'√ö','⁄'),
		prestador = REPLACE (prestador,'√ö', '⁄'),
		estudio = REPLACE (estudio,'√ö', '⁄'),
		plan_ = REPLACE(plan_,'√ö', '⁄')
	where area like ('%√ö%') or prestador like ('%√ö%') or
			estudio like ('%√ö%') or plan_ like ('%√ö%')


	update #AutorizacionEstudiosTemp
	set area = REPLACE (area,'√', '‡'),
		prestador = REPLACE (prestador,'√', '‡'),
		estudio = REPLACE (estudio,'√', '‡'),
		plan_ = REPLACE(plan_,'√', '‡')
	where area like ('%√%') or prestador like ('%√%') or
			estudio like ('%√%') or plan_ like ('%√%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'√±','Ò'),
		prestador = REPLACE (prestador,'√±', 'Ò'),
		estudio = REPLACE (estudio,'√±', 'Ò'),
		plan_ = REPLACE(plan_,'√±', 'Ò')
	where area like ('%√±%') or prestador like ('%√±%') or
			estudio like ('%√±%') or plan_ like ('%√±%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'√ë','—'),
		prestador = REPLACE (prestador,'√ë', '—'),
		estudio = REPLACE (estudio,'√ë', '—'),
		plan_ = REPLACE(plan_,'√ë', '—')
	where area like ('%√ë%') or prestador like ('%√ë%') or
			estudio like ('%√ë%') or plan_ like ('%√ë%')

	update #AutorizacionEstudiosTemp
	set area = replace(area,'¬∫','∞'),
		prestador = REPLACE (prestador,'¬∫', '∞'),
		estudio = REPLACE (estudio,'¬∫', '∞'),
		plan_ = REPLACE(plan_,'¬∫', '∞')
	where area like ('%¬∫%') or prestador like ('%¬∫%') or
			estudio like ('%¬∫%') or plan_ like ('%¬∫%')
	
	
	delete from #AutorizacionEstudiosTemp   --elimino si hay algun null en la temporal
	where estudio is null


	insert into servicio.autorizacion_de_estudio				--inserto en la base de datos
		select area,estudio,prestador,plan_ ,[Porcentaje Cobertura],costo,[Requiere autorizacion]  
		from #AutorizacionEstudiosTemp t
		where not exists(select 1 
						from servicio.autorizacion_de_estudio a
						where (t.area=a.area and t.estudio=a.estudio and t.prestador=a.prestador and t.plan_=a.plan_) or t.area is null )   --no inserta repetidos


end