/* Script de testing */


--inserta nuevo paciente
execute  insertarPaciente 'juan', 'perez','apellidomaterno','07/12/1987','dni',33333333,'masculino','hombre','argentino','','juan@juan.com', 1154678900,22222222,'' ,'medico'
go

select * from datos_paciente.Paciente
where nro_documento = 33333333
go

--crea usuario web
execute  insertarUsuario 33333333, 'unaContrasenia'

select * from datos_paciente.Usuario

--inserta domicilio
exec insertarDomicilio  'rivadavia',2222,'','',1704,'argentina','bs as', 'la matanza',1
		
select * from datos_paciente.Domicilio

--insertar prestador

exec insertarPrestador  'OSDEPYM', 1    --nombre de prestador y 1 para activo 

exec insertarPrestador  'OSDEPYM', 1    -- no los inserta repetidos
select * from comercial.Prestador

exec comercial.insertarPlanPrestador 1, 'PLAN 800'  --id prestador y nombre de plan
go
exec comercial.insertarPlanPrestador 1, 'PLAN 800'  --no inserta planes repetidos
go
select * from comercial.Plan_Prestador

exec datos_paciente.insertarCobertura 'dirimagen', 23456, 1, 1, 1 --dir_imagen_credencial,nro_socio,id_prestador,id_plan,id_paciente
exec datos_paciente.insertarCobertura 'dirimagen', 23456, 1, 1, 1  -- no inserta mas de una cobertura por paciente
go
select * from datos_paciente.Cobertura
go

exec servicio.insertarEstudio 1,'24/02/2025', 'COLONOSCOPIA','pendiente','','' --id_paciente,fecha_estudio,nombre_estudio,autorizado,imagen_resultado,documento_resultado
select * from servicio.Estudio

exec personal.insertarEspecialidad 'OBSTETRICIA'
exec personal.insertarEspecialidad 'OBSTETRICIA'
exec personal.insertarEspecialidad 'TRAUMATO'
select * from personal.Especialidad

exec personal.insertarMedico 'alberto','gonzalez', 1, 43256--nombre_medico,apellido_medico,id_especialidad,nro_colegiado
exec personal.insertarMedico '','', 3, 43256      -- no permite insertar dos veces la misma matricula de medico
select * from personal.Medico

exec servicio.insertarSede 'Trinidad de Ramos Mejia', 'juan de araoz', 'Ramos Mejia', 'Bs As'  --nombre_sede,direccion_sede, localidad_sede,provincia_sede
exec servicio.insertarSede 'Trinidad de Ramos Mejia', 'juan de araoz', 'Ramos Mejia', 'Bs As'  --no inserta sedes duplicadas
select * from servicio.Sede

exec servicio.insertarDiasPorSede 1, 1, 'martes', '15:00' -- id_medico int, id_sede int, dia varchar(10) 'lunes','marte','miercoles','jueves','viernes','sabado', horario_inicio time,
select * from servicio.Dias_por_sede




