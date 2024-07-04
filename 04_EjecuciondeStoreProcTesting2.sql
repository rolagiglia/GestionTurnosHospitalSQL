/* Script de testing DE STRORE PROC DE INSERCION MODIFICACION Y ELIMINACION DE DATOS

-- IMPORTANTE: En la ejecucion va a informar en consola los errores, ya que se prueban casos que son validados 
	por constraint pero igualmente la ejecucion es completa!

MATERIA BBDDA COMISION 5600 
GRUPO NRO 16 
ALUMNOS:
	ARAGON, RODRIGO EZEQUIEL 43509985
	LA GIGLIA RODRIGO ARIEL DNI 33334248
*/

use Com5600G16
go 

--inserta dos nuevos paciente . 
execute  datos_paciente.insertarPaciente 'carla', 'gonzalez','unapellido','07/08/1999','dni',42345678,'femenino','mujer','argentino','','juan@juan.com', 113213290,222243222,'' ,'administracion'
go
execute  datos_paciente.insertarPaciente 'juan', 'perez','apellidomaterno','07/12/1987','dni',33333333,'masculino','hombre','argentino','','juan@juan.com', 1154678900,22222222,'' ,'medico'
go
--comprobamos que no inserta dni duplicados, ni nombres, apellidos, tipo de documentos o generos no validos o vacios
execute  datos_paciente.insertarPaciente '', '','apellidomaterno','07/10/1987','nn',33333333,'genero','hombre','argentino','',' ', '','','' ,'administracion'
go
--no inserta fechas de nacimiento mayores a la fecha actual
execute  datos_paciente.insertarPaciente 'juan', 'perez','apellidomaterno','10/10/2030','dni',66666666,'masculino','hombre','argentino','','juan@juan.com', 1154678900,22222222,'' ,'medico'
go

--eliminamos paciente con borrado logico. cancela todos sus turnos
execute datos_paciente.eliminarPaciente 33333333
go

--reactivamos el paciente borrado. 
execute datos_paciente.modificarBorradoDePaciente 33333333
go
--tratamos de reactivar un paciente que no existe. nos informa que no es posible
execute datos_paciente.modificarBorradoDePaciente 22222222
go

--crea usuario web, contrasenia invalida
execute  datos_paciente.insertarUsuario 33333333, 'Novalida'
go
--crea usuario web
execute  datos_paciente.insertarUsuario 33333333, 'unaContrasenia'
go
-- no inserta usuarios duplicados
execute  datos_paciente.insertarUsuario 33333333, 'unaContrasenia'
go
--
--si el paciente no existe no lo crea el usuario
execute  datos_paciente.insertarUsuario 9999999, 'unaContrasenia'
go
-- elimina usuario
execute datos_paciente.eliminarUsuario 33333333
go
--si no existe caundo elimina lo informa
execute datos_paciente.eliminarUsuario 33333333
go
--crea usuario web
execute  datos_paciente.insertarUsuario 33333333, 'unaContrasenia'
go
--modificar contrasenia de usuario. no valida
execute datos_paciente.modificarContraseniaUsuario 33333333, ' '
go
--modificar contrasenia-valida
execute datos_paciente.modificarContraseniaUsuario 33333333, 'otraContrasenia'
go

--no inserta domicilios sin calle, pais, localidad o provincia
exec datos_paciente.insertarDomicilio  '',2222,'','',1704,'','bs as', 'la matanza', 33333333
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
--eliminar prestador
exec comercial.eliminarPrestador 'OSDEPYM'
go
--reactivar prestador
exec comercial.reactivarPrestador 'OSDEPYM'
go

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
--eliminar cobertura
exec datos_paciente.eliminarCoberturaPaciente 33333333
go
--insertarCobertura
exec datos_paciente.insertarCobertura 'dirimagen', 23456, 'OSDEPYM', 'PLAN 800', 33333333  --dir_imagen_credencial, nro_socio, prestador,plan,doc_paciente
go

-- insertarEstudio

exec servicio.insertarEstudio 33333333,'24/02/2025', 'COLONOSCOPIA','pendiente','','' --dni_paciente,fecha_estudio,nombre_estudio,autorizado, imagen_resultado,documento_resultado
go
exec servicio.insertarEstudio 42345678,'24/02/2025', 'COLONOSCOPIA','pendiente','','' 
go
exec servicio.insertarEstudio '','24/02/2025', '','','','' --no inserta valores no validos
go
exec servicio.insertarEstudio 33333333,'24/02/2025', 'COLONOSCOPIA','pendiente','','' --no inserta duplicados
go 
exec servicio.insertarEstudio 33333333,'25/02/2025', 'COLONOSCOPIA','pendiente','','' --en otra fecha si
go 

exec servicio.insertarEstudio 25111009,'28/02/2025', 'ECOCARDIOGRAMA CON STRESS CON RESERVA DE FLUJO CORONARIO','pendiente','','' 
go


--autorizar estudio  simula comunicacion con obra social, obtiene los datos de la tabla servicio.autorizacion_de_estudio importada de json 
--y actualiza la tabla estudio 
 exec servicio.autorizar_estudio 'ECOCARDIOGRAMA CON STRESS CON RESERVA DE FLUJO CORONARIO', 'OSDE 210', 25111009    --nombre de estudio, plan de cobertura ,nro_documento
 

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
--eliminarespecialidad
exec personal.eliminarEspecialidad 'OBSTETRICIA'  -- borrado logico
go
exec personal.eliminarEspecialidad 'nnn'-- indica error en especialidad que no existe
go
--vuelvo a dar de alta
exec personal.insertarEspecialidad 'OBSTETRICIA'  --como tiene borrado logico la actualiza a activo
go
exec personal.insertarEspecialidad 'TRAUMATO'
go

--insertarMedico --eliminarmedico
exec personal.insertarMedico 'alberto','gonzalez', 'OBSTETRICIA', 43256 --nombre_medico,apellido_medico,nombre_especialidad,nro_colegiado
go
exec personal.insertarMedico 'alberto','gonzalez', 'OBSTETRICIA', 43256    -- no permite insertar dos veces la misma matricula de medico 
go
exec personal.insertarMedico 'alberto','gonzalez', 'FONO', 1111    -- la especialidad no existe, la agrega y agrega la relacion
go

--eliminarmedico
exec personal.eliminarMedico 43256 --borrado logico de medico y de todo sus turnos
go
--lo vuelvo a dar de alta
exec personal.insertarMedico 'alberto','gonzalez', 'OBSTETRICIA', 43256  
go

--modificarMedico
exec personal.modificarMedico 43256,'juan','nosequiensoy'
go
--no inserta nombres ni apellidos vacios, ni matriculas que no existan
exec personal.modificarMedico 436,'',''  
go

--insertarSede
exec servicio.insertarSede 'Trinidad de Ramos Mejia', 'juan de araoz', 'Ramos Mejia', 'Bs As'  --nombre_sede,direccion_sede, localidad_sede,provincia_sede
go
exec servicio.insertarSede 'Trinidad de Ramos Mejia', 'juan de araoz', 'Ramos Mejia', 'Bs As'  --no inserta sedes duplicadas
go
exec servicio.insertarSede 'cruz celeste', '', '', 'Bs As'  --no inserta valores vacios o nulos
go

--eliminacion  logica sede
exec servicio.eliminarSede 'Trinidad de Ramos Mejia'
go
--vuelvo a dar de alta la sede
exec servicio.insertarSede 'Trinidad de Ramos Mejia', 'juan de araoz', 'Ramos Mejia', 'Bs As'  
go

--modificarDireccionSede
exec servicio.modificarDireccionSede 'Trinidad de Ramos Mejia', 'pedro goyena', 'CABA', 'Bs As'
go
--no inserta campos vacios
exec servicio.modificarDireccionSede 'Trinidad de Ramos Mejia', '', '', 'Bs As'
go

--insertarDiasporsede    crea los dias que hay atencion de un medico en una sede
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia', 'obstetricia', 'martes', '15:00','18:00' -- nro_colegiado , sede,especialidad, dia  'lunes','marte','miercoles','jueves','viernes','sabado', horario_inicio,horario_fin
go
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia', 'obstetricia', 'viernes', '15:00','23:00' --fuera de rango horario
go
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia', 'TRAUMATO', 'viernes', '15:00','12:00' -- error rango horario incorrecto
go
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia',  'TRAUMATO', 'martes', '11:00','14:00' -- error el medico ya atiende ese dia
go
exec servicio.insertarDiasPorSede 43256, 'Trinidad de Ramos Mejia',  'obstetricia', 'jueves', '18:00','19:00' -- correcto
go

exec servicio.insertarDiasPorSede 119957, 'Barrio Norte', 'TRAUMATOLOGIA', 'lunes', '09:00','15:00' -- nro_colegiado , sede,especialidad, dia  'lunes','marte','miercoles','jueves','viernes','sabado', horario_inicio,horario_fin
go
exec servicio.insertarDiasPorSede 119947, 'Caseros', 'NUTRICION', 'martes', '09:00','15:00' 
go
exec servicio.insertarDiasPorSede 119956, 'Avellaneda 2', 'OFTALMOLOGIA', 'miercoles', '09:00','15:00' 
go
exec servicio.insertarDiasPorSede 119932, 'Capital Federal', 'GASTROENTEROLOGIA', 'jueves', '09:00','15:00' 
go
exec servicio.insertarDiasPorSede 119914, 'Olivos', 'MEDICINA FAMILIAR', 'viernes', '09:00','15:00' 
go

--eliminar dias por sede 
exec servicio.eliminarDiasporsede 43256,'Trinidad de Ramos Mejia','obstetricia','martes'  --elimina la atencion de un medico en una sede en un dia 
go
--insertar reserva turno

exec servicio.insertarReservaTurno '25/07/2024','18:15',43256,'obstetricia','Trinidad de Ramos Mejia','presencial',33333333 --fecha, hora, nrocolegiado med ,especialidad,sede, tipo_turno,dni paciente 
go	
--no permite duplicados
exec servicio.insertarReservaTurno '25/07/2024','18:15',43256,'obstetricia','Trinidad de Ramos Mejia','presencial',33333333 --fecha, hora, nrocolegiado med ,especialidad,sede, tipo_turno,dni paciente 
go
--no permite turnos cada menos de 15 minutos
exec servicio.insertarReservaTurno '25/07/2024','18:20',43256,'obstetricia','Trinidad de Ramos Mejia','presencial',33333333 --fecha, hora, nrocolegiado med ,especialidad,sede, tipo_turno,dni paciente 
go 
--no permite turnos fuera de horario
exec servicio.insertarReservaTurno '25/07/2024','22:00',43256,'obstetricia','Trinidad de Ramos Mejia','presencial',33333333 --fecha, hora, nrocolegiado med ,especialidad,sede, tipo_turno,dni paciente 
go 
exec servicio.insertarReservaTurno '25/07/2024','18:15',43256,'obstetricia','Trinidad de Ramos Mejia','presencial',33333333 --fecha, hora, nrocolegiado med ,especialidad,sede, tipo_turno,dni paciente 
go

--modificarHorarioReserva
exec servicio.modificarReservaFechaHoraTurno 33333333,'25/07/2024','18:15','25/07/2024','18:45'
go

--creamos algunos turnos mas....(tienen que estar importados los archivos csv)
exec servicio.insertarReservaTurno '05/08/2024','10:00',119957,'traumatologia','Barrio Norte','presencial',25111004 --fecha, hora, nrocolegiado med ,especialidad,sede, tipo_turno,dni paciente 
go	
exec servicio.insertarReservaTurno '05/08/2024','11:00',119957,'traumatologia','Barrio Norte','presencial',25111009
go
exec servicio.insertarReservaTurno '07/08/2024','11:00',119956,'OFTALMOLOGIA','Avellaneda 2','presencial',30148116
go
exec servicio.insertarReservaTurno '08/08/2024','12:00',119932,'GASTROENTEROLOGIA','Capital Federal','presencial',31014787
go
exec servicio.insertarReservaTurno '09/08/2024','12:00',119914,'MEDICINA FAMILIAR','Olivos','presencial',32742084
go
exec servicio.insertarReservaTurno '06/08/2024','14:00',119947,'NUTRICION','Caseros','presencial',352541028
go

--insertamos cobertura de paciente

exec datos_paciente.insertarCobertura 'dirimagen', 11111, 'Medicus','Family Flex', 25111004 --direccion de la imagen credencial,nro socio,  prestador,plan ,dni paciente,
go
exec datos_paciente.insertarCobertura 'dirimagen', 22222, 'OSDE','OSDE 210', 25111009
go
exec datos_paciente.insertarCobertura 'dirimagen', 33333, 'Osecac','PMO OSECAC', 30148116
go
exec datos_paciente.insertarCobertura 'dirimagen', 44444, 'OSPOCE','Plan 800 OSPOCE Integral', 31014787
go
exec datos_paciente.insertarCobertura 'dirimagen', 55555, 'Medicus','Conecta', 32742084
go
exec datos_paciente.insertarCobertura 'dirimagen', 66666, 'Medicus','Conecta', 352541028
go


--modifico el estado del turno
exec servicio.modificarReservaEstadoTurno '08/08/2024','18:30',33333333,'cancelado'  --fecha turno, horario, dni paciente, nuevo estado
go

--marcamos algunos mas como atendidos
exec servicio.modificarReservaEstadoTurno '05/08/2024','10:00',25111004,'atendido'
go
exec servicio.modificarReservaEstadoTurno '05/08/2024','11:00',25111009,'atendido'
go
exec servicio.modificarReservaEstadoTurno '07/08/2024','11:00',30148116,'atendido'
go
exec servicio.modificarReservaEstadoTurno '08/08/2024','12:00',31014787,'atendido'
go
exec servicio.modificarReservaEstadoTurno '09/08/2024','12:00',32742084,'atendido'
go
exec servicio.modificarReservaEstadoTurno '09/08/2024','12:00',32742084,'atendido'
go
exec servicio.modificarReservaEstadoTurno '06/08/2024','14:00',352541028,'atendido'
go


--modidicarfechahorareserva turno
exec servicio.modificarReservaFechaHoraTurno 33333333,'25/07/2024','18:15','08/08/2024','18:30' --fecha anterior.hora anterior, fecha nueva, hora nueva
go

--insertar relacion medico especialidad
exec personal.insertar_relacion_medico_especialidad 43256,'TRAUMATO'




--ahora puedo reservar ese turno cancelado
exec servicio.insertarReservaTurno '08/08/2024','18:30',43256,'obstetricia','Trinidad de Ramos Mejia','presencial',33333333 
go	  

--modifica foto y registra usuario que modifico
exec datos_paciente.modificarFotoPaciente 1,'nuevadirecciondefoto','usuario_administracion'  
go

exec datos_paciente.modificarTelPaciente 33333333,'09090909', 'fijo','usuario_admin' --dni, telefono,tipo de telefono, usuario que actualiza
go


