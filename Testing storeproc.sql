/* Script de testing */

-- nombre, apellido, apellido_materno, fecha_nacimiento, tipo_documento, nro_documento, sexo_biologico, genero, nacionalidad, dir_foto_perfil,
-- mail,tel_fijo,tel_alternativo,tel_laboral, usuario_actualizacion
--inserta nuevo paciente
execute  insertarPaciente 'juan', 'perez','materno','07/12/1987','dni',33333333,'masculino','hombre','argentino','','juan@juan.com', 1154678900,22222222,'' ,'medico'
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