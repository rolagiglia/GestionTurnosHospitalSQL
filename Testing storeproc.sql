/* Script de testing */


--inserta dos nuevos paciente . 
execute  datos_paciente.insertarPaciente 'carla', 'gonzalez','unapellido','07/08/1999','dni',42345678,'femenino','mujer','argentino','','juan@juan.com', 1232132,2222432222,'' ,'administracion'
go
execute  datos_paciente.insertarPaciente 'juan', 'perez','apellidomaterno','07/12/1987','dni',33333333,'masculino','hombre','argentino','','juan@juan.com', 1154678900,22222222,'' ,'medico'
go
--comprobamos que no inserta dni duplicados
execute  datos_paciente.insertarPaciente 'pedro', 'anibal','apellidomaterno','07/10/1987','dni',33333333,'masculino','hombre','argentino','',' ', '','','' ,'administracion'
go

--crea usuario web
execute  datos_paciente.insertarUsuario 33333333, 'unaContrasenia'
go
-- no inserta usuarios duplicados
execute  datos_paciente.insertarUsuario 33333333, 'unaContrasenia'
go
--si el paciente no existe no lo inserta en usuario
execute  datos_paciente.insertarUsuario 9999999, 'unaContrasenia'
go

--inserta domicilio
exec datos_paciente.insertarDomicilio  'rivadavia',2222,'','',1704,'argentina','bs as', 'la matanza', 33333333
go
--no inserta duplicados
exec datos_paciente.insertarDomicilio  'rivadavia',2222,'','',1704,'argentina','bs as', 'la matanza', 33333333  
go
--no inserta domicilios de pacientes que no existen
exec datos_paciente.insertarDomicilio  'rivadavia',2222,'','',1704,'argentina','bs as', 'la matanza', 9999999  
go


--insertar prestador

exec comercial.insertarPrestador  'OSDEPYM'    --nombre de prestador y 1 para activo 
GO
exec comercial.insertarPrestador  'OSDEPYM'   -- no los inserta repetidos
GO
exec comercial.insertarPrestador  ''   -- no inserta vacios
GO

--insertar plan
exec comercial.insertarPlanPrestador 'OSDEPYM', 'PLAN 800'  --NOMBRE prestador y nombre de plan
go
exec comercial.insertarPlanPrestador 'OSDEPYM', 'PLAN 800'  --no inserta planes repetidos
go
exec comercial.insertarPlanPrestador 'OSDEPYM', ''  --no inserta planes vacios
go
exec comercial.insertarPlanPrestador '', 'PLAN 500'  --no inserta preSTADORES vacios
go


--insertarCobertura
exec datos_paciente.insertarCobertura 'dirimagen', 23456, 'OSDEPYM', 'PLAN 800', 33333333  --dir_imagen_credencial, nro_socio, prestador,plan,doc_paciente
go
exec datos_paciente.insertarCobertura 'dirimagen', 23456, 'OSDEPYM', 'PLAN 800', 33333333 -- no inserta mas de una cobertura por paciente
go
exec datos_paciente.insertarCobertura 'dirimagen', 23456, 'OS', 'PLAN 100', 1111111 -- no inserta coberturas ni planes que no existan 
go

-- insertarEstudio

exec servicio.insertarEstudio 33333333,'24/02/2025', 'COLONOSCOPIA','pendiente','','' --dni_paciente,fecha_estudio,nombre_estudio,autorizado,imagen_resultado,documento_resultado
go
exec servicio.insertarEstudio 42345678,'24/02/2025', 'COLONOSCOPIA','pendiente','','' 
go
exec servicio.insertarEstudio 33333333,'24/02/2025', 'COLONOSCOPIA','pendiente','','' --no inserta duplicados
go 
exec servicio.insertarEstudio 33333333,'25/02/2025', 'COLONOSCOPIA','pendiente','','' --en otra fecha si
go 

--inserarEstadoTurno
exec servicio.insertarEstadoTurno 'reservado' 
go
exec servicio.insertarEstadoTurno 'ausente' 
go
exec servicio.insertarEstadoTurno 'atendido'
go
exec servicio.insertarEstadoTurno 'cancelado'
go
exec servicio.insertarEstadoTurno 'cancelado' --no inserta duplicados
go
--insertartipodeturno

exec servicio.insertarTipoTurno 'virtual'
go
exec servicio.insertarTipoTurno 'presencial'
go


--insertarEspecialidad
exec personal.insertarEspecialidad 'OBSTETRICIA'
go
exec personal.insertarEspecialidad 'OBSTETRICIA'  --no inserta duplicados
go
exec personal.eliminarEspecialidad 'OBSTETRICIA'  -- borrado logico
go
exec personal.insertarEspecialidad 'OBSTETRICIA'  --como tiene borrado logico la actualiza a activo
go
exec personal.insertarEspecialidad 'TRAUMATO'
go

--insertarMedico --eliminarmedico
exec personal.insertarMedico 'alberto','gonzalez', 'OBSTETRICIA', 43256 --nombre_medico,apellido_medico,nombre_especialidad,nro_colegiado
go
exec personal.insertarMedico 'alberto','gonzalez', 'OBSTETRICIA', 43256    -- no permite insertar dos veces la misma matricula de medico PARA LA MISMA ESPECIALIDAD
go
exec personal.insertarMedico 'alberto','PEREZ', 'TRAUMATO', 43256    --  el apellido es incorrecto para esa matricula
go
exec personal.insertarMedico 'alberto','gonzalez', 'TRAUMATO', 43256   --carga mismo medico con otra especialidad
go
exec personal.insertarMedico 'alberto','gonzalez', 'FONO', 43256    -- la especialidad no existe
go
--eliminarmedico
exec personal.eliminarMedico 43256 --borrado logico de medico y de todo sus turnos
go
--lo vuelvo a dar de alta
exec personal.insertarMedico 'alberto','gonzalez', 'OBSTETRICIA', 43256  
go


--insertarSede
exec servicio.insertarSede 'Trinidad de Ramos Mejia', 'juan de araoz', 'Ramos Mejia', 'Bs As'  --nombre_sede,direccion_sede, localidad_sede,provincia_sede
go
exec servicio.insertarSede 'Trinidad de Ramos Mejia', 'juan de araoz', 'Ramos Mejia', 'Bs As'  --no inserta sedes duplicadas
go
--eliminacion logica
exec servicio.eliminarSede 'Trinidad de Ramos Mejia'
go
select * from servicio.Sede
--vuelvo a dar de alta
exec servicio.insertarSede 'Trinidad de Ramos Mejia', 'juan de araoz', 'Ramos Mejia', 'Bs As'  --no inserta sedes duplicadas
go


--insertarDiasporsede
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia', 'obstetricia', 'martes', '15:00','18:00' -- nro_colegiado , sede,especialidad, dia  'lunes','marte','miercoles','jueves','viernes','sabado', horario_inicio,horario_fin
go
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia', 'obstetricia', 'martes', '15:00','23:00' --fuera de rango horario
go
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia', 'TRAUMATO', 'martes', '15:00','12:00' -- rango horario INCORRECTO
go
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia',  'obstetricia', 'martes', '11:00','18:00' -- se superpone el horario
go
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia',  'obstetricia', 'martes', '11:00','14:00' -- correcto
go
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia',  'obstetricia', 'martes', '18:00','19:00' -- correcto
go

--eliminar dias por sede


exec servicio.insertarReservaTurno '28/06/2024','08:30',1,1,1,1,2,1 --fecha, hora, id_medico,id_especialidad,id_sede, id_estado de turno,id_tipo_turno,id_paciente 
go																
exec servicio.insertarReservaTurno '28/06/2024','08:30',1,1,1,1,2,1 --no permite duplicados
exec servicio.insertarReservaTurno '28/06/2024','08:40',1,5,1,1,2,1 --no permite turnos cada menos de 15 minutos

exec servicio.modificarReservaEstadoTurno 1,4 -- id_turno, id_estado_turno  modifico el turno a cancelado 

exec servicio.insertarReservaTurno '28/06/2024','08:30',1,1,1,1,2,1  --ahora puedo reservar ese turno cancelado

exec datos_paciente.modificarFotoPaciente 1,'nuevadirecciondefoto','usuario_medico'  --modifica foto y registra usuario

select * from servicio.Reserva_de_turno_medico
select * from servicio.Dias_por_sede

exec servicio.modificarReservaFechaHoraTurno 3,'2024-07-05','08:30' --@id_turno @fecha @hora  --modifico la fecha y horario del turno

exec servicio.modificarReservaFechaHoraTurno 3,'2024-07-04','08:30'    -- NO LO MODIFCA PORQUE ES UN DIA QUE ESE MEDICO NO ATIENDE

