-------------------ENTREGA 4---------------------


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
	Localidad varchar(50),
	Provincia varchar(20)
)

	bulk insert #PacientesTemporal
	from 'D:\Primer Cuatrimestre 2024\BDD Aplicada\Datasets---Informacion-necesaria\Dataset\Pacientes.csv' ---esto no puede estar en el tp final
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
		Localidad = REPLACE(Localidad,'√°', '·'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√°', '·')
	where Nombre like ('%√°%') or Apellido like ('%√°%') or
			Nacionalidad like ('%√°%') or Localidad like ('%√°%') or
			Calle_y_Nro like ('%√°%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'√©','È'),
		Apellido = REPLACE (Apellido,'√©', 'È'),
		Nacionalidad = REPLACE (Nacionalidad,'√©', 'È'),
		Localidad = REPLACE(Localidad,'√©', 'È'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√©', 'È')
	where Nombre like ('%√©%') or Apellido like ('%√©%') or
			Nacionalidad like ('%√©%') or Localidad like ('%√©%') or
			Calle_y_Nro like ('%√©%')

	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√≠', 'Ì'),
		Apellido = REPLACE (Apellido,'√≠', 'Ì'),
		Nacionalidad = REPLACE (Nacionalidad,'√≠', 'Ì'),
		Localidad = REPLACE(Localidad,'√≠', 'Ì'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√≠', 'Ì')
	where Nombre like ('%√≠%') or Apellido like ('%√≠%') or
			Nacionalidad like ('%√≠%') or Localidad like ('%√≠%') or
			Calle_y_Nro like ('%√≠%')

	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√≥', 'Û'),
		Apellido = REPLACE (Apellido,'√≥', 'Û'),
		Nacionalidad = REPLACE (Nacionalidad,'√≥', 'Û'),
		Localidad = REPLACE(Localidad,'√≥', 'Û'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√≥', 'Û')
	where Nombre like ('%√≥%') or Apellido like ('%√≥%') or
			Nacionalidad like ('%√≥%') or Localidad like ('%√≥%') or
			Calle_y_Nro like ('%√≥%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'√∫','˙'),
		Apellido = REPLACE (Apellido,'√∫', '˙'),
		Nacionalidad = REPLACE (Nacionalidad,'√∫', '˙'),
		Localidad = REPLACE(Localidad,'√∫', '˙'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√∫', '˙')
	where  Nombre like ('%√∫%') or Apellido like ('%√∫%') or
			Nacionalidad like ('%√∫%') or
			Localidad like ('%√∫%') or Calle_y_Nro like ('%√∫%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√Å', '¡'),
		Apellido = REPLACE (Apellido,'√Å', '¡'),
		Nacionalidad = REPLACE (Nacionalidad,'√Å', '¡'),
		Localidad = REPLACE(Localidad,'√Å', '¡'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√Å', '¡')
	where Nombre like ('%√Å%') or Apellido like ('%√Å%') or
			Nacionalidad like ('%√Å%') or Localidad like ('%√Å%') or
			Calle_y_Nro like ('%√Å%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√â', '…'),
		Apellido = REPLACE (Apellido,'√â', '…'),
		Nacionalidad = REPLACE (Nacionalidad,'√â', '…'),
		Localidad = REPLACE(Localidad,'√â', '…'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√â', '…')
	where Nombre like ('%√â%') or Apellido like ('%√â%') or
			Nacionalidad like ('%√â%') or Localidad like ('%√â%') or
			Calle_y_Nro like ('%√â%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'√ç','Õ'),
		Apellido = REPLACE (Apellido,'√ç', 'Õ'),
		Nacionalidad = REPLACE (Nacionalidad,'√ç', 'Õ'),
		Localidad = REPLACE(Localidad,'√ç', 'Õ'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√ç', 'Õ')
	where Nombre like ('%√ç%') or Apellido like ('%√ç%') or
			Nacionalidad like ('%√ç%') or Localidad like ('%√ç%') or
			Calle_y_Nro like ('%√ç%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'√ì','”'),
		Apellido = REPLACE (Apellido,'√ì', '”'),
		Nacionalidad = REPLACE (Nacionalidad,'√ì', '”'),
		Localidad = REPLACE(Localidad,'√ì', '”'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√ì', '”')
	where Nombre like ('%√ì%') or Apellido like ('%√ì%') or
			Nacionalidad like ('%√ì%') or Localidad like ('%√ì%') or
			Calle_y_Nro like ('%√ì%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'√ö','⁄'),
		Apellido = REPLACE (Apellido,'√ö', '⁄'),
		Nacionalidad = REPLACE (Nacionalidad,'√ö', '⁄'),
		Localidad = REPLACE(Localidad,'√ö', '⁄'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√ö', '⁄')
	where Nombre like ('%√ö%') or Apellido like ('%√ö%') or
			Nacionalidad like ('%√ö%') or Localidad like ('%√ö%') or
			Calle_y_Nro like ('%√ö%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'√', '‡'),
		Apellido = REPLACE (Apellido,'√', '‡'),
		Nacionalidad = REPLACE (Nacionalidad,'√', '‡'),
		Localidad = REPLACE(Localidad,'√', '‡'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√', '‡')
	where Nombre like ('%√%') or Apellido like ('%√%') or
			Nacionalidad like ('%√%') or Localidad like ('%√%') or
			Calle_y_Nro like ('%√%')

	update #PacientesTemporal
	set Nombre = replace(Nombre,'√±','Ò'),
		Apellido = REPLACE (Apellido,'√±', 'Ò'),
		Nacionalidad = REPLACE (Nacionalidad,'√±', 'Ò'),
		Localidad = REPLACE(Localidad,'√±', 'Ò'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√±', 'Ò')
	where Nombre like ('%√±%') or Apellido like ('%√±%') or
			Nacionalidad like ('%√±%') or Localidad like ('%√±%') or
			Calle_y_Nro like ('%√±%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'√ë','—'),
		Apellido = REPLACE (Apellido,'√ë', '—'),
		Nacionalidad = REPLACE (Nacionalidad,'√ë', '—'),
		Localidad = REPLACE(Localidad,'√ë', '—'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'√ë', '—')
	where Nombre like ('%√ë%') or Apellido like ('%√ë%') or
			Nacionalidad like ('%√ë%') or Localidad like ('%√ë%') or
			Calle_y_Nro like ('%√ë%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'¬∫','∞'),
		Apellido = REPLACE (Apellido,'¬∫', '∞'),
		Nacionalidad = REPLACE (Nacionalidad,'¬∫', '∞'),
		Localidad = REPLACE(Localidad,'¬∫', '∞'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'¬∫', '∞')
	where Nombre like ('%¬∫%') or Apellido like ('%¬∫%') or
			Nacionalidad like ('%¬∫%') or Localidad like ('%¬∫%') or
			Calle_y_Nro like ('%¬∫%')

	insert into datos_paciente.Paciente(nombre,apellido,fecha_nacimiento,tipo_documento,
										nro_documento,sexo_biologico,genero,tel_fijo,nacionalidad,
										mail)
		select Nombre, Apellido,CONVERT(date,Fecha_de_nacimiento, 103) ,tipo_Documento,
				Nro_documento,sexo,genero,Telefono_fijo,Nacionalidad,Mail
		from #PacientesTemporal

--	Intente insertar los datos del domicilio en la tabla Domicilio, pero no pude lograr castear parte del varchar como direccion y la otra como numero
-- Una posible solucion seria guardar todo dentro de calle

--	insert into datos_paciente.Domicilio(calle,numero,localidad,provincia)
--		select  RTRIM(Calle_y_Nro,'1234567890'),CAST(LTRIM(Calle_y_Nro,'abcdefghijklmnopqrstuvwxyz·ÈÌÛ˙Ò
--										ABCDEFGHIJKLMNOPQRSTUVWXYZ¡…Õ”⁄—.∞ ') as int), Localidad, Provincia
--		from #PacientesTemporal



	drop table #PacientesTemporal

end
go

exec importarPacientes
go


create or alter procedure importarMedicos as
begin

create table #MedicosTemporal (
	Nombre varchar(30),
	Apellido varchar(35),
	Especialidad varchar(30),
	NumeroColegiado int
)

	bulk insert #MedicosTemporal
	from 'D:\Primer Cuatrimestre 2024\BDD Aplicada\Datasets---Informacion-necesaria\Dataset\Medicos.csv' ---esto no puede estar en el tp final, tiene que ser una direccion general
	with
	(
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2,
		codepage = 'ACP'
	)


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√°', '·'),
		Apellido = REPLACE (Apellido,'√°', '·')
	where Especialidad like ('%√°%') or Apellido like ('%√°%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√©','È'),
		Apellido = REPLACE (Apellido,'√©', 'È')
	where Especialidad like ('%√©%') or Apellido like ('%√©%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√≠', 'Ì'),
		Apellido = REPLACE (Apellido,'√≠', 'Ì')
	where Especialidad like ('%√≠%') or Apellido like ('%√≠%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√≥', 'Û'),
		Apellido = REPLACE (Apellido,'√≥', 'Û')
	where Nombre like ('%√≥%') or Apellido like ('%√≥%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√∫','˙'),
		Apellido = REPLACE (Apellido,'√∫', '˙')
	where  Especialidad like ('%√∫%') or Apellido like ('%√∫%')


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√Å', '¡'),
		Apellido = REPLACE (Apellido,'√Å', '¡')
	where Especialidad like ('%√Å%') or Apellido like ('%√Å%')


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√â', '…'),
		Apellido = REPLACE (Apellido,'√â', '…')
	where Especialidad like ('%√â%') or Apellido like ('%√â%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√ç','Õ'),
		Apellido = REPLACE (Apellido,'√ç', 'Õ')
	where Especialidad like ('%√ç%') or Apellido like ('%√ç%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√ì','”'),
		Apellido = REPLACE (Apellido,'√ì', '”')
	where Especialidad like ('%√ì%') or Apellido like ('%√ì%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√ö','⁄'),
		Apellido = REPLACE (Apellido,'√ö', '⁄')
	where Especialidad like ('%√ö%') or Apellido like ('%√ö%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'√', '‡'),
		Apellido = REPLACE (Apellido,'√', '‡')
	where Nombre like ('%√%') or Apellido like ('%√%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√±','Ò'),
		Apellido = REPLACE (Apellido,'√±', 'Ò')
	where Especialidad like ('%√±%') or Apellido like ('%√±%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'√ë','—'),
		Apellido = REPLACE (Apellido,'√ë', '—')
	where Especialidad like ('%√ë%') or Apellido like ('%√ë%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'¬∫','∞'),
		Apellido = REPLACE (Apellido,'¬∫', '∞')
	where Especialidad like ('%¬∫%') or Apellido like ('%¬∫%') 


	insert into personal.Medico(nombre_medico,apellido_medico)
		select Apellido, Nombre
		from #MedicosTemporal

	insert into personal.Especialidad(nombre_especialidad)
		select Especialidad 
		from #MedicosTemporal
		group by Especialidad


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
	from 'D:\Primer Cuatrimestre 2024\BDD Aplicada\Datasets---Informacion-necesaria\Dataset\Sedes.csv' ---esto no puede estar en el tp final, tiene que ser una direccion general
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
		Localidad = REPLACE(Localidad,'√°', '·')
	where sede like ('%√°%') or provincia like ('%√°%') or
			direccion like ('%√°%') or Localidad like ('%√°%')

	update #SedesTemporal
	set sede = replace(sede,'√©','È'),
		provincia = REPLACE (provincia,'√©', 'È'),
		direccion = REPLACE (direccion,'√©', 'È'),
		Localidad = REPLACE(Localidad,'√©', 'È')
	where sede like ('%√©%') or provincia like ('%√©%') or
			direccion like ('%√©%') or Localidad like ('%√©%')


	update #SedesTemporal
	set sede = REPLACE (sede,'√≠', 'Ì'),
		provincia = REPLACE (provincia,'√≠', 'Ì'),
		direccion = REPLACE (direccion,'√≠', 'Ì'),
		Localidad = REPLACE(Localidad,'√≠', 'Ì')
	where provincia like ('%√≠%') or sede like ('%√≠%') or
			direccion like ('%√≠%') or Localidad like ('%√≠%')

	update #SedesTemporal
	set sede = REPLACE (sede,'√≥', 'Û'),
		direccion = REPLACE (direccion,'√≥', 'Û'),
		provincia = REPLACE (provincia,'√≥', 'Û'),
		Localidad = REPLACE(Localidad,'√≥', 'Û')
	where sede like ('%√≥%') or provincia like ('%√≥%') or
			direccion like ('%√≥%') or Localidad like ('%√≥%')

	update #SedesTemporal
	set sede = replace(sede,'√∫','˙'),
		direccion = REPLACE (direccion,'√∫', '˙'),
		provincia = REPLACE (provincia,'√∫', '˙'),
		Localidad = REPLACE(Localidad,'√∫', '˙')
	where sede like ('%√∫%') or direccion like ('%√∫%') or
			provincia like ('%√∫%') or Localidad like ('%√∫%')


	update #SedesTemporal
	set sede = REPLACE (sede,'√Å', '¡'),
		direccion = REPLACE (direccion,'√Å', '¡'),
		provincia = REPLACE (provincia,'√Å', '¡'),
		Localidad = REPLACE(Localidad,'√Å', '¡')
	where sede like ('%√Å%') or direccion like ('%√Å%') or
			provincia like ('%√Å%') or Localidad like ('%√Å%')


	update #SedesTemporal
	set sede = REPLACE (sede,'√â', '…'),
		direccion = REPLACE (direccion,'√â', '…'),
		provincia = REPLACE (provincia,'√â', '…'),
		Localidad = REPLACE(Localidad,'√â', '…')
	where sede like ('%√â%') or direccion like ('%√â%') or
			provincia like ('%√â%') or Localidad like ('%√â%')

	update #SedesTemporal
	set sede = replace(sede,'√ç','Õ'),
		direccion = REPLACE (direccion,'√ç', 'Õ'),
		provincia = REPLACE (provincia,'√ç', 'Õ'),
		Localidad = REPLACE(Localidad,'√ç', 'Õ')
	where sede like ('%√ç%') or direccion like ('%√ç%') or
			provincia like ('%√ç%') or Localidad like ('%√ç%')


	update #SedesTemporal
	set sede = replace(sede,'√ì','”'),
		direccion = REPLACE (direccion,'√ì', '”'),
		provincia = REPLACE (provincia,'√ì', '”'),
		Localidad = REPLACE(Localidad,'√ì', '”')
	where sede like ('%√ì%') or direccion like ('%√ì%') or
			provincia like ('%√ì%') or Localidad like ('%√ì%')


	update #SedesTemporal
	set sede = replace(sede,'√ö','⁄'),
		direccion = REPLACE (direccion,'√ö', '⁄'),
		provincia = REPLACE (provincia,'√ö', '⁄'),
		Localidad = REPLACE(Localidad,'√ö', '⁄')
	where sede like ('%√ö%') or direccion like ('%√ö%') or
			provincia like ('%√ö%') or Localidad like ('%√ö%')


	update #SedesTemporal
	set sede = REPLACE (sede,'√', '‡'),
		direccion = REPLACE (direccion,'√', '‡'),
		provincia = REPLACE (provincia,'√', '‡'),
		Localidad = REPLACE(Localidad,'√', '‡')
	where sede like ('%√%') or direccion like ('%√%') or
			provincia like ('%√%') or Localidad like ('%√%')

	update #SedesTemporal
	set sede = replace(sede,'√±','Ò'),
		direccion = REPLACE (direccion,'√±', 'Ò'),
		provincia = REPLACE (provincia,'√±', 'Ò'),
		Localidad = REPLACE(Localidad,'√±', 'Ò')
	where sede like ('%√±%') or direccion like ('%√±%') or
			provincia like ('%√±%') or Localidad like ('%√±%')

	update #SedesTemporal
	set sede = replace(sede,'√ë','—'),
		direccion = REPLACE (direccion,'√ë', '—'),
		provincia = REPLACE (provincia,'√ë', '—'),
		Localidad = REPLACE(Localidad,'√ë', '—')
	where sede like ('%√ë%') or direccion like ('%√ë%') or
			provincia like ('%√ë%') or Localidad like ('%√ë%')

	update #SedesTemporal
	set sede = replace(sede,'¬∫','∞'),
		direccion = REPLACE (direccion,'¬∫', '∞'),
		provincia = REPLACE (provincia,'¬∫', '∞'),
		Localidad = REPLACE(Localidad,'¬∫', '∞')
	where sede like ('%¬∫%') or direccion like ('%¬∫%') or
			provincia like ('%¬∫%') or Localidad like ('%¬∫%')

	insert into servicio.Sede (nombre_sede,direccion_sede)
	select sede,direccion
	from #SedesTemporal


	drop table #SedesTemporal

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
	from 'D:\Primer Cuatrimestre 2024\BDD Aplicada\Datasets---Informacion-necesaria\Dataset\Prestador.csv' ---esto no puede estar en el tp final, tiene que ser una direccion general
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
	group by prestador


	insert into comercial.Plan_Prestador(id_prestador,nombre_plan)
	select pres.id_prestador, temp.planes
	from #PrestadorTemporal temp
	join comercial.Prestador pres
	on pres.nombre_prestador = temp.prestador


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