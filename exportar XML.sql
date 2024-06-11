/* generar un archivo XML detallando
los turnos atendidos para informar a la Obra Social. El mismo debe constar de los datos del
paciente (Apellido, nombre, DNI), nombre y matrícula del profesional que lo atendió, fecha,
hora, especialidad. Los parámetros de entrada son el nombre de la obra social y un intervalo
de fechas.*/create or alter proc comercial.informeObraSocial(@obra_social varchar(100), @fecha_inicio date,@fecha_fin date)asbegin	SELECT p.apellido,p.nombre,p.nro_documento, m.nombre_medico, m.nro_colegiado, r.fecha, r.hora, e.nombre_especialidad
       from datos_paciente.Paciente p inner join servicio.Reserva_de_turno_medico r on p.id_historia_clinica=r.id_paciente
			inner join datos_paciente.Cobertura c on c.id_paciente=p.id_historia_clinica
			inner join comercial.Prestador pr on pr.id_prestador=c.id_prestador
			inner join personal.Medico m on r.id_medico=m.id_medico
			inner join personal.Especialidad e on e.id_especialidad=m.id_especialidad
			inner join servicio.Estado_turno et on et.id_estado=r.id_estado_turno
		where (r.fecha between @fecha_inicio and @fecha_fin) and pr.nombre_prestador=@obra_social and et.nombre_estado='atendido'
		FOR XML PATH('informeObraSocial');end--exec comercial.informeObraSocial 'Union Personal', '01/01/2000','11/06/2024'