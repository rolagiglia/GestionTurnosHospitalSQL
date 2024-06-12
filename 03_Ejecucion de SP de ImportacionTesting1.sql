/*EJECUCION DE SP DE IMPORTACION DE ARCHIVOS -TESTING-
 
MATERIA BBDDA COMISION 5600 
GRUPO NRO 16 
ALUMNOS:
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

