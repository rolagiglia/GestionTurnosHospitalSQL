-------------------ENTREGA 4---------------------

use Com5600G16
go

create or alter procedure importarPacientes as
begin

create table #PacientesTemporal (
	Nombre varchar(30),
	Apellido varchar(35),
	Fecha_de_nacimiento varchar(10),
	tipo_Documento varchar(10),
	Nro_documento int,
	sexo varchar(10),
	genero varchar(10),
	Telefono_fijo varchar(15),
	Nacionalidad varchar(50),
	Mail varchar(50),
	Calle_y_Nro varchar(50),
	localidad varchar(50),
	Provincia varchar(20)
)

	bulk insert #PacientesTemporal
	from 'C:\Users\Ivi\Desktop\FACU 2024\BBDD APLICADA\TP parte 3 BBDDA\Datasets---Informacion-necesaria\Dataset\Pacientes.csv' ---esto no puede estar en el tp final
	with
	(
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		codepage = 'ACP'
	)
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

--	Intente insertar los datos del domicilio en la tabla Domicilio, pero no pude lograr castear parte del varchar como direccion y la otra como numero
-- Una posible solucion seria guardar todo dentro de calle

--	insert into datos_paciente.Domicilio(calle,numero,localidad,provincia)
--		select  RTRIM(Calle_y_Nro,'1234567890'),CAST(LTRIM(Calle_y_Nro,'abcdefghijklmnopqrstuvwxyz·ÈÌÛ˙Ò
--										ABCDEFGHIJKLMNOPQRSTUVWXYZ¡…Õ”⁄—.∞ ') as int), localidad, Provincia
--		from #PacientesTemporal

select * from datos_paciente.Paciente

	drop table #PacientesTemporal

end
go

exec importarPacientes
go


create or alter procedure importarMedicos as
begin

create table #MedicosTemporal (
	Apellido varchar(35),
	Nombre varchar(30),
	Especialidad varchar(30),
	NumeroColegiado int
)

	bulk insert #MedicosTemporal
	from 'C:\Users\Ivi\Desktop\FACU 2024\BBDD APLICADA\TP parte 3 BBDDA\Datasets---Informacion-necesaria\Dataset\Medicos.csv' ---esto no puede estar en el tp final, tiene que ser una direccion general
	with
	(
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		codepage = 'ACP'
	)


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


	  
	
	insert into personal.Especialidad(nombre_especialidad)
		select Especialidad 
		from #MedicosTemporal
		where Especialidad not in(select nombre_especialidad from personal.Especialidad)   --no inserta duplicados
		group by Especialidad
	
	insert into personal.Medico(nombre_medico,apellido_medico,nro_colegiado, id_especialidad)
		select t.Nombre, t.Apellido, t.NumeroColegiado, e.id_especialidad
		from #MedicosTemporal t inner join personal.Especialidad e ON t.Especialidad=e.nombre_especialidad    --Join para obtener el id_especialidad  
		where NumeroColegiado not in (select nro_colegiado from personal.Medico)             --NO INSERTA DUPLICADOS


	drop table #MedicosTemporal

end
go


create or alter procedure importarSedes as
begin
	
	create table #SedesTemporal
	(
		sede varchar(50),
		direccion varchar(50),
		localidad varchar(50),
		provincia varchar(20)
	)

	bulk insert #SedesTemporal
	from 'C:\Users\Ivi\Desktop\FACU 2024\BBDD APLICADA\TP parte 3 BBDDA\Datasets---Informacion-necesaria\Dataset\Sedes.csv' ---esto no puede estar en el tp final, tiene que ser una direccion general
	with
	(
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		codepage = 'ACP'
	)

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

	
	insert into servicio.Sede (nombre_sede,direccion_sede, localidad_sede, provincia_sede)
	select sede,direccion, localidad, provincia
	from #SedesTemporal
	where sede not in(select nombre_sede from servicio.Sede)    --NO INSERTA DUPLICADOS




end
go


exec importarSedes
go



create or alter procedure importarPrestador as
begin
	
	create table #PrestadorTemporal
	(
		prestador varchar(30),
		planes varchar(30)
	)


	bulk insert #PrestadorTemporal
	from 'C:\Users\Ivi\Desktop\FACU 2024\BBDD APLICADA\TP parte 3 BBDDA\Datasets---Informacion-necesaria\Dataset\Prestador.csv' ---esto no puede estar en el tp final, tiene que ser una direccion general
	with
	(
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = ';;\n',
		FIRSTROW = 2,
		codepage = 'ACP'
	)


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


	insert into comercial.Prestador(nombre_prestador)
		select prestador 
		from #PrestadorTemporal
		where prestador not in (select nombre_prestador from comercial.Prestador) ----------------------------------------------------- no inserte duplicados
		group by prestador


	insert into comercial.Plan_Prestador(id_prestador,nombre_plan)
		select pres.id_prestador, temp.planes
		from #PrestadorTemporal temp join comercial.Prestador pres on pres.nombre_prestador = temp.prestador  
		where temp.planes not in (select nombre_plan from comercial.Plan_Prestador)         --no inserta duplicados


	drop table #PrestadorTemporal
end
go


exec importarPrestador
go


create or alter procedure importarEstudios as
begin

	create table #EstudiosTemp
	(
		id varchar(25),
		area nvarchar(30),
		estudio nvarchar(30),
		prestador nvarchar(30),
		plan_ nvarchar(30),
		porcentaje int,
		costo decimal(10,2),
		autorizacion bit
	)

	--drop table #EstudiosTemp

	insert into #EstudiosTemp (area,estudio,prestador,plan_,porcentaje,costo,autorizacion)
	select area,estudio,prestador,plan_,porcentaje,costo,autorizacion
	from openrowset (bulk 'D:\Primer Cuatrimestre 2024\BDD Aplicada\Datasets---Informacion-necesaria\Dataset\Centro_Autorizaciones.Estudios clinicos.json', single_clob) as j
	cross apply openjson(bulkcolumn)
	with (
			id varchar(25) '$._id."$oid"',
			area varchar(30) '$.Area',
			estudio varchar(30) '$.Estudio',
			prestador varchar(30) '$.Prestador',
			plan_ varchar(30) '$.Plan',
			porcentaje int '$.Porcentaje Cobertura',
			costo decimal(10,2) '$.Costo',
			autorizacion bit '$.Requiere autorizacion'
	) as estudio;


end