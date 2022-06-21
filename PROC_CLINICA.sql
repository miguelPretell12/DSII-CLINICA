use clinicaDSII
go

create proc LISTAR_USUARIOS 
as
	select 
	u.idusuario as Idusuario,
	u.nombre as Nombre,
	u.apellido as Apellido,
	u.dni as Dni,
	u.correo as Correo,
	u.estado as Estado, 
	c.nombre as Cargo
	from usuarios u inner join cargos c on c.idcargo = u.idcargo
GO

EXEC LISTAR_USUARIOS
go

CREATE PROC LISTAR_CARGOS 
AS
	SELECT * FROM cargos
GO

exec LISTAR_CARGOS
go

CREATE PROC PROC_STATUS_USERS @estado VARCHAR(50), @idusuario INT
AS
	update usuarios set
		estado = @estado
	where idusuario = @idusuario
GO

CREATE PROC PROC_INSERTAR_USUARIO 
@nombre VARCHAR(50), @apellido VARCHAR(50), @dni VARCHAR(50), 
@correo VARCHAR(50), @contrasenia VARCHAR(50), @idcargo int
AS

INSERT INTO usuarios values(@nombre, @apellido, @dni, @correo, @contrasenia, 'A' ,@idcargo)
GO

CREATE PROC PROC_ACTUALIZAR_USUARIO 
@nombre VARCHAR(50), @apellido VARCHAR(50), @dni VARCHAR(50), 
@correo VARCHAR(50), @contrasenia VARCHAR(50), @idcargo int, @iduser int
AS
	update usuarios set
		nombre = @nombre, apellido = @apellido, dni = @dni,
		correo = @correo, contrasenia =@contrasenia, idcargo = @idcargo
	where idusuario = @iduser
GO

CREATE PROC OBTENER_USUARIO @iduser int
AS
	SELECT * FROM usuarios where idusuario = @iduser 
go

exec OBTENER_USUARIO 1
go

CREATE PROC ELIMINAR_USUARIO @iduser int
AS
	DELETE FROM usuarios where idusuario = @iduser 
GO

-- Horario

CREATE PROC LISTAR_HORARIO 
AS
	SELECT
		idhorario,
		CONVERT(varchar,horainicio,24) as horaInicio , 
		CONVERT(varchar,horafinal,24) as horaFinal 
	FROM horarios
GO

EXEC LISTAR_HORARIO
GO

ALTER PROC OBTENER_HORARIO @idhora int
AS
	SELECT 
		idhorario,
		CONVERT(varchar,horainicio,24) as horaInicio , 
		CONVERT(varchar,horafinal,24) as horaFinal 
	FROM horarios WHERE idhorario=@idhora
GO

EXEC OBTENER_HORARIO 1
go

create proc FILTRO_HORARIO @horainicio VARCHAR(15), @horafinal VARCHAR(15)
as
	select count(*) as Exist from horarios where horainicio = @horainicio or horafinal = @horafinal
go

create proc PROC_INSERTAR_HORARIO @horainicio VARCHAR(15), @horafinal VARCHAR(15)
AS
	insert into horarios values(@horainicio, @horafinal)
GO

create proc PROC_UPDATE_HORARIO @horainicio VARCHAR(15), @horafinal VARCHAR(15), @idhorario int
AS
	UPDATE horarios SET 
	horafinal = @horafinal, horainicio=@horainicio
	where idhorario = @idhorario
GO

create proc PROC_DELETE_HORARIO @idhorario int
AS
	delete from horarios where idhorario = @idhorario
GO

alter proc PROC_OBTENER_MEDICO @dni varchar(15)
as
	declare @exist integer

	select 
		@exist = count(*)
	from especialidadMedico em
	inner join usuarios u on u.idusuario = em.idusuario
	inner join cargos c on c.idcargo = u.idcargo
	where c.nombre = 'doctor' and u.dni = @dni

	IF @exist > 0
		select 
			u.idusuario as idusuario,
			em.idespdoctor as idespmed,
			em.idespecialidad as idespecialidad,
			CONCAT(u.apellido,', ',u.nombre) as medico,
			u.dni as dni,
			u.correo as correo
		from especialidadMedico em
		inner join usuarios u on u.idusuario = em.idusuario
		inner join cargos c on c.idcargo = u.idcargo
		where c.nombre = 'doctor' and u.dni = @dni
	else
		select 
			u.idusuario as idusuario,
			0 as idespmed,
			CONCAT(u.apellido,', ',u.nombre) as medico,
			@exist as idespecialidad,
			u.dni as dni,
			u.correo as correo
		from  usuarios u 
		inner join cargos c on c.idcargo = u.idcargo
		where c.nombre = 'doctor' and u.dni = @dni
go

exec PROC_OBTENER_MEDICO '012345678' 
go

create proc PROC_LISTAR_ESPECIALIDAD 
as
	select * from especialidad
go

create proc PROC_GUARDAR_MED_ESP @idesp int, @idusuario int
as
	insert into especialidadMedico values(@idesp, @idusuario)
go

create proc PROC_ACTUALIZAR_MED_ESP @idesp int, @idusuario int, @idespmed int
as
	update especialidadMedico set
		idespecialidad = @idesp,
		idusuario = @idusuario
	where idespdoctor = @idespmed
go

alter proc PROC_LISTAR_ESPMED 
as
	select 
		concat(u.apellido,', ', u.nombre) as medico,
		u.dni as dni,
		e.nombre as especialidad,
		em.idespdoctor as idespmed
	from especialidadMedico em
	inner join especialidad e on e.idespecialidad = em.idespecialidad
	inner join usuarios u on u.idusuario = em.idusuario
	inner join cargos c on c.idcargo = u.idcargo
	where c.nombre = 'doctor'
go

alter proc PROC_BUSCAR_ESPMED @dni varchar(15)
AS
	select 
		concat(u.apellido,', ', u.nombre) as medico,
		u.dni as dni,
		e.nombre as especialidad,
		em.idespdoctor as idespmed
	from especialidadMedico em
	inner join especialidad e on e.idespecialidad = em.idespecialidad
	inner join usuarios u on u.idusuario = em.idusuario
	inner join cargos c on c.idcargo = u.idcargo
	WHERE u.dni like '%'+@dni+'%' and c.nombre = 'doctor'
GO

create proc PROC_ELIMINAR_MED_ESP @idespmed int
as
	delete from especialidadMedico where idespdoctor = @idespmed
go

alter proc PROC_LISTAR_MEDICO 
as
	select 
		CONCAT(u.apellido,', ', u.nombre) as medico,
		u.idusuario as idmedico
	from especialidadMedico em
	inner join usuarios u on em.idusuario = u.idusuario
	inner join cargos c on u.idcargo = c.idcargo
	where c.nombre = 'doctor'
go

exec PROC_LISTAR_MEDICO
go

create proc PROC_OBTENER_MED_ESP @idmedico int
as
	select 
		em.idespecialidad as idespecialidad,
		e.nombre as especialidad
	from especialidadMedico em
	inner join usuarios u on u.idusuario = em.idusuario
	inner join cargos c on c.idcargo = u.idcargo
	inner join especialidad e on em.idespecialidad = e.idespecialidad
	where c.nombre = 'doctor' and  em.idusuario = @idmedico
go

alter proc PROC_GUARDAR_CONSULTA @idmedico int, @idespecialidad int, @idhorario int, @precio decimal(8,2) 
as
	declare @exist int
	select 
		@exist = count(*)
	from consultas 
	where idmedico = @idmedico and idhorario = @idhorario
	if @exist = 0 
	BEGIN
		insert into consultas values (@idmedico, @idespecialidad, @idhorario, @precio)
		return 1
	END
	else 
	BEGIN
		return 0
	END
go

create proc PROC_EDITAR_CONSULTA @idmedico int, @idespecialidad int, @idhorario int, @precio decimal(8,2), @idcons int
as
	update consultas set
		idmedico = @idmedico,
		idespecialidad = @idespecialidad,
		idhorario = @idhorario,
		precio = @precio
	where idconsulta = @idcons
go
delete from consultas where idconsulta = 1
create proc PROC_OBTENER_CONSULTA @idconsulta int
as
	select 
		c.idconsulta as idconsulta,
		u.idusuario as idmedico,
		c.idespecialidad as idespecialidad,
		e.nombre as especialidad,
		h.idhorario as horario,
		c.precio as precio
	from consultas c 
	inner join usuarios u on u.idusuario = c.idmedico
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join horarios h on h.idhorario = c.idhorario
	inner join cargos cg on cg.idcargo = u.idcargo
	where cg.nombre = 'doctor' and c.idconsulta = @idconsulta
go

create proc PROC_LISTAR_CONSULTAS 
AS
	select 
		c.idconsulta as idconsulta,
		CONCAT(u.apellido,', ',u.nombre) as medico,
		e.nombre as especialidad,
		h.horainicio as horainicio,
		h.horafinal as horafinal,
		c.precio as precio
	from consultas c
	inner join usuarios u on u.idusuario = c.idmedico
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join horarios h on h.idhorario = c.idhorario
	inner join cargos cg on cg.idcargo = u.idcargo
GO

exec PROC_LISTAR_CONSULTAS
go

-- Paciente
alter proc PROC_INSERTAR_PACIENTE 
@nombre varchar(50), @apellido varchar(50),
@dni varchar(50), @correo varchar(50),
@fechanac varchar(50), @estadocivil varchar(50), 
@contrasenia varchar(50)
AS
	declare @count int
	select @count = count(*) from pacientes where dni = @dni or correo = @correo
	if @count = 0
		begin
			insert into pacientes values(@nombre, @apellido, @dni, @correo, @fechanac,@estadocivil, @contrasenia,0)
			return 1
		end
	else
		begin
			return 0
		end
GO

exec PROC_INSERTAR_PACIENTE 'MIGUEL','PRETELL','01235487','miguel@gmail.com','19980602','soltero','12345678'
go

create proc PROC_UPDATE_PACIENTE 
@nombre varchar(50), @apellido varchar(50),
@dni varchar(50), @correo varchar(50),
@fechanac varchar(50), @estadocivil varchar(50), 
@contrasenia varchar(50), @idpaciente int
as
	update pacientes set
	nombre=@nombre, apellido= @apellido, dni=@dni,
	correo=@correo, fechanacimiento =@fechanac, estadocivil=@estadocivil,
	contrasenia=@contrasenia
	where idpacientes = @idpaciente
go

create proc PROC_LISTAR_PACIENTE
AS
	SELECT * FROM pacientes
GO

create proc PROC_OBTENER_PACIENTE @idpaciente int
as
	select * from pacientes where idpacientes = @idpaciente
go

exec PROC_OBTENER_PACIENTE 3
go
create proc PROC_ELIMINAR_PACIENTE @idpaciente int
as
	declare @count int
	select 
		@count = count(*)
	from citamedica where idpaciente = @idpaciente

	if @count > 0
		return 0
	else 
		begin
			delete from pacientes where idpacientes =@idpaciente
			return 1
		end
go

exec PROC_ELIMINAR_PACIENTE 2002
go

alter proc PROC_BUSCAR_HORARIOS_CONSULTAS @idhorario int
AS
	declare @count int
	declare @fecha date
	set @fecha = GETDATE()
	select @count = r.idconsulta from reservas r
	inner join consultas c on c.idconsulta = r.idconsulta
	where  r.fechacita = @fecha and c.idhorario=@idhorario
	
	if @count != 0 
	begin
		select 
		CONCAT(u.apellido,', ',u.nombre) as medico,
			e.nombre as especialidad,
			h.horainicio as horainicio,
			h.horafinal as horafin,
			c.precio as precio,
			c.idconsulta as consultaid
		from consultas c
		inner join usuarios u on u.idusuario = c.idmedico
		inner join especialidad e on e.idespecialidad = c.idespecialidad
		inner join horarios h on h.idhorario = c.idhorario
		where idconsulta != @count and h.idhorario = @idhorario
	end
	else
	begin
		select 
			CONCAT(u.apellido,', ',u.nombre) as medico,
			e.nombre as especialidad,
			h.horainicio as horainicio,
			h.horafinal as horafin,
			c.precio as precio,
			c.idconsulta as consultaid
		from consultas c
		inner join usuarios u on u.idusuario = c.idmedico
		inner join especialidad e on e.idespecialidad = c.idespecialidad
		inner join horarios h on h.idhorario = c.idhorario
		where c.idhorario = @idhorario
	end
go


exec PROC_BUSCAR_HORARIOS_CONSULTAS 2
go
create proc PROC_LISTAR_HORARIO_R
AS
	declare @Existingdate time
	Set @Existingdate=GETDATE()
	select * from horarios where horainicio > @Existingdate
GO

exec PROC_LISTAR_HORARIO_R 
go

create proc PROC_OBTENER_PAC_DNI @dni varchar(50)
as
	select idpacientes, nombre, apellido, dni, correo, fechanacimiento, estadocivil, contrasenia  from pacientes where dni = @dni
go

create proc PROC_OBTENER_PAC_DNI_SALDO @dni varchar(50)
as
	select 
		idpacientes,
		CONCAT(apellido,', ',nombre) as paciente,
		dni,
		correo,
		saldo
	from pacientes
	where dni =@dni
go

exec PROC_OBTENER_PAC_DNI_SALDO '01235487'
go

create proc PROC_INSERTAR_RESERVA_TECNICO 
@idpaciente int, @idconsulta int, @fechacita date,
@montoentregado decimal(8,2), @idtransicion varchar(50)
AS
	insert into reservas values(@idpaciente, @idconsulta, GETDATE(), @fechacita, @montoentregado,@idtransicion,'CONCLUIDO','EFECTIVO')
GO

create proc PROC_LISTAR_TRANSICION_RESERVAS
AS
	select 
		concat(u.apellido,', ', u.nombre) as medico,
		CONCAT(p.apellido,', ', p.nombre) as paciente,
		e.nombre as especialidad,
		c.precio as precio,
		r.estado as estado,
		r.fechareserva as freserva,
		r.fechacita as fcita,
		r.idtransicion as transicion
	from reservas r
	inner join pacientes p on p.idpacientes = r.idpaciente
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join usuarios u on c.idmedico = u.idusuario
GO

exec PROC_LISTAR_TRANSICION_RESERVAS
go

CREATE proc PROC_LIST_TRANS_RES_BUSCAR @idtransicion varchar(50)
as
	select 
		r.idtransicion as transicion,
		concat(u.apellido,', ', u.nombre) as medico,
		CONCAT(p.apellido,', ', p.nombre) as paciente,
		e.nombre as especialidad,
		c.precio as precio,
		r.estado as estado,
		r.fechareserva as freserva,
		r.fechacita as fcita
	from reservas r
	inner join pacientes p on p.idpacientes = r.idpaciente
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join usuarios u on c.idmedico = u.idusuario 
	where r.idtransicion like '%'+@idtransicion+'%'
go

exec PROC_LIST_TRANS_RES_BUSCAR '05'
go
create proc PROC_BUSCAR_TRANSACCION @transaccion varchar(50)
as
	select 
		r.idtransicion as transaccion,
		concat(u.apellido,', ', u.nombre) as medico,
		CONCAT(p.apellido,', ', p.nombre) as paciente,
		p.dni as dni,
		e.nombre as especialidad,
		c.precio as precio,
		r.estado as estado,
		h.horainicio as horainicio,
		h.horafinal as horafinal,
		r.fechareserva as freserva,
		r.fechacita as fcita
	from reservas r
	inner join pacientes p on p.idpacientes = r.idpaciente
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join horarios h on h.idhorario = c.idhorario
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join usuarios u on c.idmedico = u.idusuario 
	where r.idtransicion = @transaccion
go

create proc PROC_BUSCAR_CONSULTA_HOR_ESP @horario int, @especialidad int, @fechacita varchar(50)
as
	declare @count int
	select @count = count(*) from reservas r
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join horarios h on h.idhorario = c.idhorario
	where r.fechacita = @fechacita and e.idespecialidad = @especialidad and h.idhorario = @horario
	
	if @count != 0
		 begin
			select concat('La consulta ya ha sido reservada para el día de ',' ', @fechacita) as Mensaje
		 end
	else 
		begin
			select 
					c.idconsulta as idconsulta,
					e.nombre as especialidad,
					CONCAT(u.apellido,', ',u.nombre) as medico,
					h.horainicio as horainicio,
					h.horafinal as horafinal,
					c.precio as precio,
					CONCAT('','') as Mensaje
			 from consultas c
			 inner join especialidad e on e.idespecialidad = c.idespecialidad
			 inner join horarios h on h.idhorario = c.idhorario
			 inner join usuarios u on u.idusuario = c.idmedico
			 where c.idhorario = @horario and c.idespecialidad = @especialidad
		end
go

exec PROC_BUSCAR_CONSULTA_HOR_ESP 1, 1, '2022-06-21'
go
create proc PROC_BUSCAR_CONSULTAS_FECHA_SUPERIOR_HOY @idesp int, @idhor int
as
declare @fecha date
set @fecha = GETDATE()
declare @count int
	select 
		@count = COUNT(*)
	from reservas r
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join horarios h on h.idhorario = c.idhorario
	inner join usuarios u on u.idusuario = c.idmedico
	where r.fechacita > @fecha and c.idespecialidad = @idesp and c.idhorario = @idhor
 
 if @count > 0
	 begin
		select concat('Ya esta registrado esta consulta para el dia',' ', @fecha) as Mensaje
	 end
 else
	 begin
		select 
			c.idconsulta as idconsulta,
			CONCAT(u.apellido,', ', u.nombre) as medico,
			e.nombre as especialidad,
			h.horainicio as horainicio,
			h.horafinal as horafinal,
			c.precio as precio,
			CONCAT('','') as Mensaje
		from consultas c
		inner join especialidad e on e.idespecialidad = c.idespecialidad
		inner join horarios h on h.idhorario = c.idhorario
		inner join usuarios u on u.idusuario = c.idmedico
		where c.idespecialidad = @idesp and c.idhorario = @idhor
	 end
go

create proc PROC_BUSCAR_CONSULTAS_FECHA_SUPERIOR_HOY_1 @idesp int, @idhor int, @fechab date
as
     declare @exist varchar(50)
	 declare @idcons int
	 select 
	      @exist = count(*),
		  @idcons = r.idconsulta
	 from reservas r
	 inner join consultas c on c.idconsulta = r.idconsulta
	 where c.idespecialidad = @idesp and c.idhorario = @idhor and r.fechacita = @fechab
	 group by r.idconsulta
	 
	 if @exist != 0
	 begin
	   select 
			c.idconsulta as idconsulta,
			CONCAT(u.apellido,', ', u.nombre) as medico,
			e.nombre as especialidad,
			h.horainicio as horainicio,
			h.horafinal as horafinal,
			c.precio as precio,
			CONCAT('existe','') as Mensaje
		from consultas c
		inner join especialidad e on e.idespecialidad = c.idespecialidad
		inner join horarios h on h.idhorario = c.idhorario
		inner join usuarios u on u.idusuario = c.idmedico
		where c.idespecialidad = @idesp and c.idhorario = @idhor and c.idconsulta !=  @idcons
	 end
	 else
	 begin
		select 
			c.idconsulta as idconsulta,
			CONCAT(u.apellido,', ', u.nombre) as medico,
			e.nombre as especialidad,
			h.horainicio as horainicio,
			h.horafinal as horafinal,
			c.precio as precio,
			CONCAT('no existe','') as Mensaje
		from consultas c
		inner join especialidad e on e.idespecialidad = c.idespecialidad
		inner join horarios h on h.idhorario = c.idhorario
		inner join usuarios u on u.idusuario = c.idmedico
		where c.idespecialidad = @idesp and c.idhorario = @idhor 
	 end
go


exec PROC_BUSCAR_CONSULTAS_FECHA_SUPERIOR_HOY_1 1,1,'20220622'
GO

create proc PROC_CREAR_RESERVA_EFECTIVO 
@idpac int, @idconsulta int, @fechacita date, 
@montoentre decimal(8,2), @idtransaccion varchar(50)
AS
	insert into reservas values (@idpac, @idconsulta, GETDATE(), @fechacita, @montoentre, @idtransaccion, 'CONCLUIDO','EFECTIVO')
GO

-- completar el listado y el filtro en el modulo reservas
-- completar mañana
create proc PROC_LISTAR_RESERVA_FILTRO_FECHA @finicio date, @ffinal date
as
	select 
		r.idtransicion as transaccion,
		CONCAT(u.apellido,', ', u.nombre) as medico,
		CONCAT(p.apellido,', ',p.nombre) as paciente,
		p.dni as dni,
		e.nombre as especialidad,
		r.estado as estado,
		h.horainicio as horainicio,
		h.horafinal as horafinal,
		r.fechareserva as freserva,
		r.fechacita as fcita,
		c.precio as precio
	from reservas r
	inner join pacientes p on p.idpacientes = r.idpaciente
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join usuarios u on c.idmedico = u.idusuario
	inner join especialidad e on c.idespecialidad = e.idespecialidad
	inner join horarios h on h.idhorario = c.idhorario
	where r.fechacita >= @finicio and r.fechacita <= @ffinal
go

exec PROC_LISTAR_RESERVA_FILTRO_FECHA '2022-06-08','2022-06-13'
go

create proc PROC_LISTAR_TRASACCION_RESERVAS 
AS
	select 
		r.idtransicion as transaccion,
		CONCAT(u.apellido,', ', u.nombre) as medico,
		CONCAT(p.apellido,', ',p.nombre) as paciente,
		p.dni as dni,
		e.nombre as especialidad,
		r.estado as estado,
		h.horainicio as horainicio,
		h.horafinal as horafinal,
		r.fechareserva as freserva,
		r.fechacita as fcita,
		c.precio as precio
	from reservas r
	inner join pacientes p on p.idpacientes = r.idpaciente
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join usuarios u on c.idmedico = u.idusuario
	inner join especialidad e on c.idespecialidad = e.idespecialidad
	inner join horarios h on h.idhorario = c.idhorario
GO

create proc PROC_LISTAR_RESERVAS_PAC @idpac int
as
	select 
		 idtransicion as transaccion,
		 CONCAT(u.apellido,', ', u.nombre) as medico,
		 e.nombre as especialidad,
		 r.fechacita as fcita,
		 h.horainicio as hinicio,
		 h.horafinal as hfinal,
		 c.precio as precio,
		 r.estado as estado
	from reservas r
	inner join pacientes p on p.idpacientes = r.idpaciente
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join usuarios u on u.idusuario = c.idmedico
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join horarios h on h.idhorario = c.idhorario
	where r.idpaciente = @idpac
go

exec PROC_LISTAR_RESERVAS_PAC 3
go

create proc PROC_GET_CONSULTA @idcons
as
	
go

create proc PROC_RESERVAR_PACIENTE_SAVE @idpac int, @idcons int, 
@fcita date, @idtransaccion varchar(50)
AS
	insert into reservas values (@idpac, @idcons, GETDATE(), @fcita, null, @idtransaccion, 'PENDIENTE','EFECTIVO');
GO

create proc PROC_RESERVA_PACIENTE_VIRTUAL @idpac int, @idcons int,
@fcita date, @idtransaccion varchar(50)
as
set nocount on
	-- variables para obtene el saldo
	declare @saldo decimal(8,2)
	declare @precio decimal(8,2)
	select @saldo = saldo from pacientes where idpacientes = @idpac
	select @precio = precio from consultas where idconsulta = @idcons

	IF @saldo >= @precio 
	begin
		update pacientes set saldo = saldo - @precio where idpacientes = @idpac
		insert into reservas values(@idpac, @idcons, GETDATE(), @fcita, @precio, @idtransaccion, 'CONCLUIDO','VIRTUAL')
		return 1
	end
	else
	begin
		return 0
	end
go

exec PROC_RESERVA_PACIENTE_VIRTUAL 2005, 1, '20220618','15200503546650'
GO
create proc PROC_MOSTRAR_SALDO_PACIENTE @idpac int
as
	select saldo from pacientes where idpacientes = @idpac
go


create proc PROC_MEDICO_SAVE_FICHA_HISTORIAL @idres int, @alergia varchar(15),
@peso decimal(5,2), @estatura decimal(3,2), @observacion text, @receta text 
AS
	declare @idultimo int
	insert into fichamedicas values (@idres, GETDATE(), @alergia, @peso, @estatura)
	set @idultimo = @@IDENTITY

	insert into historialmedicos values(@idultimo, @observacion, @receta, GETDATE())
GO

create proc PROC_RESERVAR_TRANSACCION_DNI_MEDICO @trandni varchar(50), @idmed int
as
	declare @fechactual date
	set @fechactual = GETDATE()
	select 
		r.idreserva as idreserva,
		CONCAT(m.apellido,', ',m.nombre) as medico,
		CONCAT(p.apellido,', ', p.nombre) as paciente,
		p.dni as dni,
		r.estado as estado,
		e.nombre as especialidad,
		r.idtransicion as transaccion
	from reservas r
	inner join pacientes p on p.idpacientes = r.idpaciente
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join usuarios m on m.idusuario = c.idmedico
	where c.idmedico = @idmed and ( r.idtransicion = @trandni or p.dni = @trandni )	
	and fechacita = @fechactual
go


exec PROC_RESERVAR_TRANSACCION_DNI_MEDICO '1655430825567', 3
go

create proc PROC_LISTAR_RESERVAS_MED_FILTER @fcita varchar(25), @idmed int
as
	select 
		r.idtransicion as transaccion,
		r.fechacita as fcita,
		h.horainicio as horainicio,
		h.horafinal as horafinal,
		CONCAT(p.apellido,', ',p.nombre) as paciente,
		p.dni as dni,
		r.estado as estado
	from reservas r
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join horarios h on h.idhorario = c.idhorario
	inner join pacientes p on p.idpacientes = r.idpaciente
	where  fechacita = @fcita and c.idmedico = @idmed
	order by r.fechacita asc
go

exec PROC_LISTAR_RESERVAS_MED_FILTER '2022-06-10',3
go 

create proc PROC_LISTAR_RESERVAS_MED @idmed varchar(25)
as
	select 
		r.idtransicion as transaccion,
		r.fechacita as fcita,
		h.horainicio as horainicio,
		h.horafinal as horafinal,
		CONCAT(p.apellido,', ',p.nombre) as paciente,
		p.dni as dni,
		r.estado as estado
	from reservas r
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join horarios h on h.idhorario = c.idhorario
	inner join pacientes p on p.idpacientes = r.idpaciente
	where c.idmedico = @idmed
	order by r.fechacita desc
go

exec PROC_LISTAR_RESERVAS_MED '3'
go

create proc PROC_LISTAR_RESERVA_PACIENTE_FILTER @idpac int, @transaccion varchar(50)
AS
	select 
		r.idtransicion as transaccion,
		r.fechacita as fcita,
		h.horainicio as horainicio,
		h.horafinal as horafinal,
		CONCAT(p.apellido,', ',p.nombre) as paciente,
		p.dni as dni,
		r.estado as estado
	from reservas r
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join horarios h on h.idhorario = c.idhorario
	inner join pacientes p on p.idpacientes = r.idpaciente
	where r.idpaciente = @idpac and r.idtransicion = @transaccion
GO

create proc PROC_LISTAR_RESERVA_PACIENTE @idpac int
AS
	select 
		r.idtransicion as transaccion,
		r.fechacita as fcita,
		h.horainicio as horainicio,
		h.horafinal as horafinal,
		CONCAT(u.apellido,', ',u.nombre) as medico,
		e.nombre as especialidad,
		p.dni as dni,
		r.estado as estado
	from reservas r
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join usuarios u on u.idusuario = c.idmedico
	inner join horarios h on h.idhorario = c.idhorario
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join pacientes p on p.idpacientes = r.idpaciente
	where r.idpaciente = @idpac 
	order by r.fechacita desc
GO

create proc PROC_LISTAR_RESERVA_PACIENTE_TRANS_FILTER @idpac int, @transaccion varchar(50)
AS
	select 
		r.idtransicion as transaccion,
		r.fechacita as fcita,
		h.horainicio as horainicio,
		h.horafinal as horafinal,
		CONCAT(u.apellido,', ',u.nombre) as medico,
		e.nombre as especialidad,
		p.dni as dni,
		r.estado as estado
	from reservas r
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join usuarios u on u.idusuario = c.idmedico
	inner join horarios h on h.idhorario = c.idhorario
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	inner join pacientes p on p.idpacientes = r.idpaciente
	where r.idpaciente = @idpac and r.idtransicion = @transaccion
	order by r.fechacita desc
GO

create proc PROC_MOSTRAR_FM_PACIENTE @idpac int, @transaccion varchar(50)
as
	select 
		hm.observacion as observacion,
		hm.receta as receta,
		fm.alergia as alergia,
		fm.peso as peso,
		fm.estatura as estatura,
		r.fechacita as fcita
	from historialmedicos hm
	inner join fichamedicas fm on fm.idfichamedica = hm.idfichamedica
	inner join reservas r on r.idreserva = fm.idreserva
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	where r.idpaciente = @idpac and r.idtransicion = @transaccion
go

create proc PROC_LOGIN @correo varchar(50), @contrasenia varchar(50)
as
	declare @count int
	select @count =  count(*) from usuarios where correo = @correo and contrasenia = @contrasenia
	if @count > 0
	begin
		select 
		CONCAT(u.apellido,', ', u.nombre) as usuarios,
		c.nombre as cargo,
		u.idusuario as idusuario
		from usuarios u
		inner join cargos c on c.idcargo = u.idcargo
		where correo = @correo and contrasenia = @contrasenia and estado = 'A'
	end
	else
	begin
		select
		CONCAT(apellido,', ', nombre) as usuarios,
		idpacientes as idusuario,
		'paciente' as cargo
		from pacientes where correo = @correo and contrasenia = @contrasenia 
	end
go

create proc PROC_RECARGA_PACIENTE @idpac int, @saldo decimal(8,2)
as
	update pacientes set
		saldo = saldo + @saldo
	where idpacientes = @idpac
go

exec PROC_RECARGA_PACIENTE 2005, 100.50
go

create proc PROC_CONSULTAR_RESERVA @trasanccion varchar(50)
as
	select 
		CONCAT( p.apellido, ', ', p.nombre ) as paciente,
		CONCAT( u.apellido, ', ', u.nombre ) as medico,
		r.fechacita as fechacita,
		e.nombre as especialidad,
		c.precio as precio,
		h.horainicio as horainicio,
		h.horafinal as horafinal,
		r.tipopago as tipopago,
		r.idtransicion as transaccion,
		p.dni as dni
	from reservas r
	inner join pacientes p on p.idpacientes = r.idpaciente
	inner join consultas c on c.idconsulta = r.idconsulta
	inner join horarios h on h.idhorario = c.idhorario
	inner join usuarios u on u.idusuario = c.idmedico
	inner join especialidad e on e.idespecialidad = c.idespecialidad
	where r.idtransicion = @trasanccion and r.estado = 'PENDIENTE'
go

alter proc PROC_VALIDAR_RESERVAS @transaccion varchar(50), @montoe decimal(8,2)
as
	UPDATE reservas SET
	montontoentregado = @montoe,
	estado = 'CONCLUIDO'
	where idtransicion = @transaccion
go

select * from reservas r
inner join consultas c on c.idconsulta = r.idconsulta
inner join especialidad e on e.idespecialidad = c.idespecialidad
inner join horarios h on h.idhorario = c.idhorario
where r.fechacita = '20220620' and e.idespecialidad = '1' and h.idhorario = '1'

select 
	CONCAT( p.apellido, ', ', p.nombre ) as paciente,
	CONCAT( u.apellido, ', ', u.nombre ) as medico,
	r.fechacita as fechacita,
	e.nombre as especialidad,
	c.precio as precio,
	h.horainicio as horainicio,
	h.horafinal as horafinal,
	r.tipopago as tipopago,
	r.idtransicion as transaccion,
	r.estado
from reservas r
inner join pacientes p on p.idpacientes = r.idpaciente
inner join consultas c on c.idconsulta = r.idconsulta
inner join horarios h on h.idhorario = c.idhorario
inner join usuarios u on u.idusuario = c.idmedico
inner join especialidad e on e.idespecialidad = c.idespecialidad
where r.idtransicion = '1655610292289' and r.estado = 'PENDIENTE'
