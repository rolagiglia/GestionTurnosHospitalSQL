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
										mail)
		select Nombre, Apellido,CONVERT(date,Fecha_de_nacimiento, 103) ,tipo_Documento,
				Nro_documento,sexo,genero,Telefono_fijo,Nacionalidad,Mail
		from #PacientesTemporal
		where Nro_documento not in (select nro_documento from datos_paciente.Paciente)   --no inserta los duplicados, el resto si

			
--	Intente insertar los datos del domicilio en la tabla Domicilio, pero no pude lograr castear parte del varchar como direccion y la otra como numero
-- Una posible solucion seria guardar todo dentro de calle

--	insert into datos_paciente.Domicilio(calle,numero,localidad,provincia)
--		select  RTRIM(Calle_y_Nro,'1234567890'),CAST(LTRIM(Calle_y_Nro,'abcdefghijklmnopqrstuvwxyzáéíóúñ
--										ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÚÑ.° ') as int), localidad, Provincia
--		from #PacientesTemporal



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
