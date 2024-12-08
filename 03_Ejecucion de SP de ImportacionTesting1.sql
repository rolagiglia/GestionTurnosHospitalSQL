/*EJECUCION DE SP DE IMPORTACION DE ARCHIVOS -TESTING-
 
	ARAGON, RODRIGO EZEQUIEL 43509985
	LA GIGLIA RODRIGO ARIEL DNI 33334248

NINGUNO DE LOS SP DE IMPORTACION GENERAN DUPLICADOS AUNQUE SE EJECUTEN MAS DE UNA VEZ
*/

use Com5600G16
go 
--Importacion de pacientes
exec importacion.importarPacientes N'C:\Dataset\Pacientes.csv'   
go
--Importacion de medicos, Actualizacion de especialidades y relacion medico especialidad
exec importacion.importarMedicos N'C:\Dataset\Medicos.csv'
go
--Importacion de sedes
exec importacion.importarSedes N'C:\Dataset\Sedes.csv'
go
--Importacion de prestadores y planes
exec importacion.importarPrestador N'C:\Dataset\Prestador.csv'
go

--Importacion de Parametros de autorizacion
exec importacion.importarParametrosAutorizacionEstudio N'C:\Dataset\Centro_Autorizaciones.Estudios clinicos.json'
go

 

/*
VER TABLAS CON IMPORTADOS

select * from datos_paciente.Paciente, datos_paciente.Domicilio where id_historia_clinica=id_paciente

select * from personal.Medico m, personal.Especialidad e,personal.medico_especialidad me
where m.id_medico=me.id_medico and e.id_especialidad=me.id_especialidad

select * from comercial.Prestador p, comercial.Plan_Prestador pl where p.id_prestador=pl.id_prestador

select * from servicio.Sede

select * from servicio.autorizacion_de_estudio

*/
