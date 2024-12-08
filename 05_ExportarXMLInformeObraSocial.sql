/* CREACION DE STORE PROC PARA  generar un archivo XML detallando
los turnos atendidos para informar a la Obra Social. El mismo consta de los datos del
paciente (Apellido, nombre, DNI), nombre y matrícula del profesional que lo atendió, fecha,
hora, especialidad. Los parámetros de entrada son el nombre de la obra social y un intervalo
de fechas */
use Com5600G16
go 

create or alter proc comercial.informeObraSocial(@obra_social varchar(100), @fecha_inicio date,@fecha_fin date)
as
begin
	SELECT p.apellido +', '+ p.nombre ApellidoyNombrePaciente,p.nro_documento NroDocumentoPaciente, 
			m.apellido_medico + ', ' + m.nombre_medico ApellidoyNombreMedico, m.nro_colegiado, r.fecha FechadeAtencion, r.hora HorarioAtencion, e.nombre_especialidad Especialidad
	   from datos_paciente.Paciente p inner join servicio.Reserva_de_turno_medico r on p.id_historia_clinica=r.id_paciente
			inner join datos_paciente.Cobertura c on c.id_paciente=p.id_historia_clinica
			inner join comercial.Prestador pr on pr.id_prestador=c.id_prestador
			inner join personal.Medico m on r.id_medico=m.id_medico
			inner join personal.medico_especialidad me on r.id_medico=me.id_medico
			inner join personal.Especialidad e on e.id_especialidad=me.id_especialidad
			inner join servicio.Estado_turno et on et.id_estado=r.id_estado_turno
		where (r.fecha between @fecha_inicio and @fecha_fin) and pr.nombre_prestador=@obra_social and et.nombre_estado='atendido'
		FOR XML RAW('AtenciondePaciente'), ROOT('DocInformeObraSocial'),ELEMENTS;
end
