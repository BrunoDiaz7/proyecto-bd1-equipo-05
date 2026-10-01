USE Proyecto_equipo5;
go

INSERT INTO Persona (DNI, nombre, apellido, telefono, email) VALUES
(11111111, 'Juan', 'Sole', '42368331444', 'juan.sole@gmail.com'),
(22222222, 'Santy', 'Roca', '1133445566', 'santy.roca@gmail.com'),
(33333333, 'Bruno', 'diaz', '1144556677', 'bruno.diaz@gmail.com'),
(44444444, 'tiziano', 'navas', '1155667788', 'tiziano.navas@gmail.com'),
(55555555, 'Roberto', 'Álvarez', '1100112233', 'roberto.alvarez@gmail.com'),
(66666666, 'Lucía', 'Romero', '1122112233', 'lucia.romero@gmail.com'),
(77777777, 'Gonzalo', 'Torres', '1133223344', 'gonzalo.torres@gmail.com'),
(88888888, 'Elena', 'Ruiz', '1144334455', 'elena.ruiz@gmail.com');
GO

INSERT INTO Empleado (id_persona_empleado, legajo) VALUES
(1, 'EMP-001'),
(2, 'EMP-002'),
(3, 'EMP-003'),
(4, 'EMP-004');
GO

INSERT INTO Cliente (id_persona_cliente, fecha_alta) VALUES
(5, '2026-28-09'),
(6, '2026-28-09'),
(7, '2026-29-09'),
(8, '2026-29-09');
GO


