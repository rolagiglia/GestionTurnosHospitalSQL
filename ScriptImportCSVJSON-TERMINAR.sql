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
	---dos caracteres especiales juntos, por ejemplo, Ord��ez. No he encontrado manera de solucionarlo
	---Pense en usar constains en vez de like pero requiere configurar el motor de base de datos y no es conveniente
	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'á', '�'),
		Apellido = REPLACE (Apellido,'á', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'á', '�'),
		Localidad = REPLACE(Localidad,'á', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'á', '�')
	where Nombre like ('%á%') or Apellido like ('%á%') or
			Nacionalidad like ('%á%') or Localidad like ('%á%') or
			Calle_y_Nro like ('%á%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'é','�'),
		Apellido = REPLACE (Apellido,'é', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'é', '�'),
		Localidad = REPLACE(Localidad,'é', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'é', '�')
	where Nombre like ('%é%') or Apellido like ('%é%') or
			Nacionalidad like ('%é%') or Localidad like ('%é%') or
			Calle_y_Nro like ('%é%')

	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'í', '�'),
		Apellido = REPLACE (Apellido,'í', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'í', '�'),
		Localidad = REPLACE(Localidad,'í', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'í', '�')
	where Nombre like ('%í%') or Apellido like ('%í%') or
			Nacionalidad like ('%í%') or Localidad like ('%í%') or
			Calle_y_Nro like ('%í%')

	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'ó', '�'),
		Apellido = REPLACE (Apellido,'ó', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'ó', '�'),
		Localidad = REPLACE(Localidad,'ó', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'ó', '�')
	where Nombre like ('%ó%') or Apellido like ('%ó%') or
			Nacionalidad like ('%ó%') or Localidad like ('%ó%') or
			Calle_y_Nro like ('%ó%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'ú','�'),
		Apellido = REPLACE (Apellido,'ú', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'ú', '�'),
		Localidad = REPLACE(Localidad,'ú', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'ú', '�')
	where  Nombre like ('%ú%') or Apellido like ('%ú%') or
			Nacionalidad like ('%ú%') or
			Localidad like ('%ú%') or Calle_y_Nro like ('%ú%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'Á', '�'),
		Apellido = REPLACE (Apellido,'Á', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'Á', '�'),
		Localidad = REPLACE(Localidad,'Á', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Á', '�')
	where Nombre like ('%Á%') or Apellido like ('%Á%') or
			Nacionalidad like ('%Á%') or Localidad like ('%Á%') or
			Calle_y_Nro like ('%Á%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'É', '�'),
		Apellido = REPLACE (Apellido,'É', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'É', '�'),
		Localidad = REPLACE(Localidad,'É', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'É', '�')
	where Nombre like ('%É%') or Apellido like ('%É%') or
			Nacionalidad like ('%É%') or Localidad like ('%É%') or
			Calle_y_Nro like ('%É%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'Í','�'),
		Apellido = REPLACE (Apellido,'Í', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'Í', '�'),
		Localidad = REPLACE(Localidad,'Í', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Í', '�')
	where Nombre like ('%Í%') or Apellido like ('%Í%') or
			Nacionalidad like ('%Í%') or Localidad like ('%Í%') or
			Calle_y_Nro like ('%Í%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'Ó','�'),
		Apellido = REPLACE (Apellido,'Ó', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'Ó', '�'),
		Localidad = REPLACE(Localidad,'Ó', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ó', '�')
	where Nombre like ('%Ó%') or Apellido like ('%Ó%') or
			Nacionalidad like ('%Ó%') or Localidad like ('%Ó%') or
			Calle_y_Nro like ('%Ó%')


	update #PacientesTemporal
	set Nombre = replace(nombre,'Ú','�'),
		Apellido = REPLACE (Apellido,'Ú', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'Ú', '�'),
		Localidad = REPLACE(Localidad,'Ú', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ú', '�')
	where Nombre like ('%Ú%') or Apellido like ('%Ú%') or
			Nacionalidad like ('%Ú%') or Localidad like ('%Ú%') or
			Calle_y_Nro like ('%Ú%')


	update #PacientesTemporal
	set Nombre = REPLACE (Nombre,'�', '�'),
		Apellido = REPLACE (Apellido,'�', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'�', '�'),
		Localidad = REPLACE(Localidad,'�', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'�', '�')
	where Nombre like ('%�%') or Apellido like ('%�%') or
			Nacionalidad like ('%�%') or Localidad like ('%�%') or
			Calle_y_Nro like ('%�%')

	update #PacientesTemporal
	set Nombre = replace(Nombre,'ñ','�'),
		Apellido = REPLACE (Apellido,'ñ', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'ñ', '�'),
		Localidad = REPLACE(Localidad,'ñ', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'ñ', '�')
	where Nombre like ('%ñ%') or Apellido like ('%ñ%') or
			Nacionalidad like ('%ñ%') or Localidad like ('%ñ%') or
			Calle_y_Nro like ('%ñ%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'Ñ','�'),
		Apellido = REPLACE (Apellido,'Ñ', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'Ñ', '�'),
		Localidad = REPLACE(Localidad,'Ñ', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'Ñ', '�')
	where Nombre like ('%Ñ%') or Apellido like ('%Ñ%') or
			Nacionalidad like ('%Ñ%') or Localidad like ('%Ñ%') or
			Calle_y_Nro like ('%Ñ%')

	update #PacientesTemporal
	set Nombre = replace(nombre,'º','�'),
		Apellido = REPLACE (Apellido,'º', '�'),
		Nacionalidad = REPLACE (Nacionalidad,'º', '�'),
		Localidad = REPLACE(Localidad,'º', '�'),
		Calle_y_Nro = REPLACE(Calle_y_Nro,'º', '�')
	where Nombre like ('%º%') or Apellido like ('%º%') or
			Nacionalidad like ('%º%') or Localidad like ('%º%') or
			Calle_y_Nro like ('%º%')

	insert into datos_paciente.Paciente(nombre,apellido,fecha_nacimiento,tipo_documento,
										nro_documento,sexo_biologico,genero,tel_fijo,nacionalidad,
										mail)
		select Nombre, Apellido,CONVERT(date,Fecha_de_nacimiento, 103) ,tipo_Documento,
				Nro_documento,sexo,genero,Telefono_fijo,Nacionalidad,Mail
		from #PacientesTemporal

--	Intente insertar los datos del domicilio en la tabla Domicilio, pero no pude lograr castear parte del varchar como direccion y la otra como numero
-- Una posible solucion seria guardar todo dentro de calle

--	insert into datos_paciente.Domicilio(calle,numero,localidad,provincia)
--		select  RTRIM(Calle_y_Nro,'1234567890'),CAST(LTRIM(Calle_y_Nro,'abcdefghijklmnopqrstuvwxyz������
--										ABCDEFGHIJKLMNOPQRSTUVWXYZ������.� ') as int), Localidad, Provincia
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
	set Especialidad = REPLACE (Especialidad,'á', '�'),
		Apellido = REPLACE (Apellido,'á', '�')
	where Especialidad like ('%á%') or Apellido like ('%á%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'é','�'),
		Apellido = REPLACE (Apellido,'é', '�')
	where Especialidad like ('%é%') or Apellido like ('%é%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'í', '�'),
		Apellido = REPLACE (Apellido,'í', '�')
	where Especialidad like ('%í%') or Apellido like ('%í%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'ó', '�'),
		Apellido = REPLACE (Apellido,'ó', '�')
	where Nombre like ('%ó%') or Apellido like ('%ó%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'ú','�'),
		Apellido = REPLACE (Apellido,'ú', '�')
	where  Especialidad like ('%ú%') or Apellido like ('%ú%')


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'Á', '�'),
		Apellido = REPLACE (Apellido,'Á', '�')
	where Especialidad like ('%Á%') or Apellido like ('%Á%')


	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'É', '�'),
		Apellido = REPLACE (Apellido,'É', '�')
	where Especialidad like ('%É%') or Apellido like ('%É%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Í','�'),
		Apellido = REPLACE (Apellido,'Í', '�')
	where Especialidad like ('%Í%') or Apellido like ('%Í%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ó','�'),
		Apellido = REPLACE (Apellido,'Ó', '�')
	where Especialidad like ('%Ó%') or Apellido like ('%Ó%')


	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ú','�'),
		Apellido = REPLACE (Apellido,'Ú', '�')
	where Especialidad like ('%Ú%') or Apellido like ('%Ú%')

	update #MedicosTemporal
	set Especialidad = REPLACE (Especialidad,'�', '�'),
		Apellido = REPLACE (Apellido,'�', '�')
	where Nombre like ('%�%') or Apellido like ('%�%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'ñ','�'),
		Apellido = REPLACE (Apellido,'ñ', '�')
	where Especialidad like ('%ñ%') or Apellido like ('%ñ%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'Ñ','�'),
		Apellido = REPLACE (Apellido,'Ñ', '�')
	where Especialidad like ('%Ñ%') or Apellido like ('%Ñ%')

	update #MedicosTemporal
	set Especialidad = replace(Especialidad,'º','�'),
		Apellido = REPLACE (Apellido,'º', '�')
	where Especialidad like ('%º%') or Apellido like ('%º%') 


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
	set sede = REPLACE (sede,'á', '�'),
		provincia = REPLACE (provincia,'á', '�'),
		direccion = REPLACE (direccion,'á', '�'),
		Localidad = REPLACE(Localidad,'á', '�')
	where sede like ('%á%') or provincia like ('%á%') or
			direccion like ('%á%') or Localidad like ('%á%')

	update #SedesTemporal
	set sede = replace(sede,'é','�'),
		provincia = REPLACE (provincia,'é', '�'),
		direccion = REPLACE (direccion,'é', '�'),
		Localidad = REPLACE(Localidad,'é', '�')
	where sede like ('%é%') or provincia like ('%é%') or
			direccion like ('%é%') or Localidad like ('%é%')


	update #SedesTemporal
	set sede = REPLACE (sede,'í', '�'),
		provincia = REPLACE (provincia,'í', '�'),
		direccion = REPLACE (direccion,'í', '�'),
		Localidad = REPLACE(Localidad,'í', '�')
	where provincia like ('%í%') or sede like ('%í%') or
			direccion like ('%í%') or Localidad like ('%í%')

	update #SedesTemporal
	set sede = REPLACE (sede,'ó', '�'),
		direccion = REPLACE (direccion,'ó', '�'),
		provincia = REPLACE (provincia,'ó', '�'),
		Localidad = REPLACE(Localidad,'ó', '�')
	where sede like ('%ó%') or provincia like ('%ó%') or
			direccion like ('%ó%') or Localidad like ('%ó%')

	update #SedesTemporal
	set sede = replace(sede,'ú','�'),
		direccion = REPLACE (direccion,'ú', '�'),
		provincia = REPLACE (provincia,'ú', '�'),
		Localidad = REPLACE(Localidad,'ú', '�')
	where sede like ('%ú%') or direccion like ('%ú%') or
			provincia like ('%ú%') or Localidad like ('%ú%')


	update #SedesTemporal
	set sede = REPLACE (sede,'Á', '�'),
		direccion = REPLACE (direccion,'Á', '�'),
		provincia = REPLACE (provincia,'Á', '�'),
		Localidad = REPLACE(Localidad,'Á', '�')
	where sede like ('%Á%') or direccion like ('%Á%') or
			provincia like ('%Á%') or Localidad like ('%Á%')


	update #SedesTemporal
	set sede = REPLACE (sede,'É', '�'),
		direccion = REPLACE (direccion,'É', '�'),
		provincia = REPLACE (provincia,'É', '�'),
		Localidad = REPLACE(Localidad,'É', '�')
	where sede like ('%É%') or direccion like ('%É%') or
			provincia like ('%É%') or Localidad like ('%É%')

	update #SedesTemporal
	set sede = replace(sede,'Í','�'),
		direccion = REPLACE (direccion,'Í', '�'),
		provincia = REPLACE (provincia,'Í', '�'),
		Localidad = REPLACE(Localidad,'Í', '�')
	where sede like ('%Í%') or direccion like ('%Í%') or
			provincia like ('%Í%') or Localidad like ('%Í%')


	update #SedesTemporal
	set sede = replace(sede,'Ó','�'),
		direccion = REPLACE (direccion,'Ó', '�'),
		provincia = REPLACE (provincia,'Ó', '�'),
		Localidad = REPLACE(Localidad,'Ó', '�')
	where sede like ('%Ó%') or direccion like ('%Ó%') or
			provincia like ('%Ó%') or Localidad like ('%Ó%')


	update #SedesTemporal
	set sede = replace(sede,'Ú','�'),
		direccion = REPLACE (direccion,'Ú', '�'),
		provincia = REPLACE (provincia,'Ú', '�'),
		Localidad = REPLACE(Localidad,'Ú', '�')
	where sede like ('%Ú%') or direccion like ('%Ú%') or
			provincia like ('%Ú%') or Localidad like ('%Ú%')


	update #SedesTemporal
	set sede = REPLACE (sede,'�', '�'),
		direccion = REPLACE (direccion,'�', '�'),
		provincia = REPLACE (provincia,'�', '�'),
		Localidad = REPLACE(Localidad,'�', '�')
	where sede like ('%�%') or direccion like ('%�%') or
			provincia like ('%�%') or Localidad like ('%�%')

	update #SedesTemporal
	set sede = replace(sede,'ñ','�'),
		direccion = REPLACE (direccion,'ñ', '�'),
		provincia = REPLACE (provincia,'ñ', '�'),
		Localidad = REPLACE(Localidad,'ñ', '�')
	where sede like ('%ñ%') or direccion like ('%ñ%') or
			provincia like ('%ñ%') or Localidad like ('%ñ%')

	update #SedesTemporal
	set sede = replace(sede,'Ñ','�'),
		direccion = REPLACE (direccion,'Ñ', '�'),
		provincia = REPLACE (provincia,'Ñ', '�'),
		Localidad = REPLACE(Localidad,'Ñ', '�')
	where sede like ('%Ñ%') or direccion like ('%Ñ%') or
			provincia like ('%Ñ%') or Localidad like ('%Ñ%')

	update #SedesTemporal
	set sede = replace(sede,'º','�'),
		direccion = REPLACE (direccion,'º', '�'),
		provincia = REPLACE (provincia,'º', '�'),
		Localidad = REPLACE(Localidad,'º', '�')
	where sede like ('%º%') or direccion like ('%º%') or
			provincia like ('%º%') or Localidad like ('%º%')

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