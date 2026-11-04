USE Proyecto_equipo5;
GO

/* =========================================================================
   TRIGGER DE VALIDACION DE EMAIL PARA EMPLEADO: trg_Validar_Email_Empleado
   Proposito: Exigir obligatoriamente una dirección de correo electrónico en la 
   tabla Persona únicamente para el personal registrado como Empleado, 
   permitiendo omitirla opcionalmente en los Clientes.
   ========================================================================= */

CREATE OR ALTER TRIGGER dbo.trg_Validar_Email_Empleado
ON dbo.Empleado
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Comprobamos si el empleado insertado o actualizado tiene email NULL o vacío en Persona
    IF EXISTS (
        SELECT 1 
        FROM inserted AS i
        INNER JOIN dbo.Persona AS p ON i.id_persona_empleado = p.id_persona
        WHERE p.email IS NULL
    )
    BEGIN
        -- Si no tiene email, lanzamos un error y se aborta toda la transacción
        RAISERROR('Operación denegada por el TRIGGER. Es obligatorio registrar un email para el personal empleado.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO


-- =========================================================================
-- DEMOSTRACION DEL TRIGGER DE EMPLEADO
-- =========================================================================


-- =========================================================================
-- EL TRIGGER BLOQUEA AL EMPLEADO SIN EMAIL PERO PERMITE CLIENTE
-- =========================================================================

-- Creamos una persona con email NULL
INSERT INTO Persona (DNI, nombre, apellido, telefono, email) 
VALUES (99999901, 'Test', 'SinEmail', '111111', NULL);

DECLARE @id_sin_email INT = SCOPE_IDENTITY();

-- Intentamos registrarla como Empleado (El trigger debe frenarlo)
INSERT INTO Empleado (id_persona_empleado, legajo) 
VALUES (@id_sin_email, 'EMP-FAIL');


-- La registramos como Cliente 
INSERT INTO Cliente (id_persona_cliente, fecha_alta) 
VALUES (@id_sin_email, GETDATE());


-- =========================================================================
-- SE PERMITE EL REGISTRO CON EMAIL (CLIENTE Y EMPLEADO)
-- =========================================================================

-- Creamos una persona con email valido
INSERT INTO Persona (DNI, nombre, apellido, telefono, email) 
VALUES (99999902, 'Test', 'ConEmail', '222222', 'empleado@prueba.com');

DECLARE @id_con_email INT = SCOPE_IDENTITY();

-- La registramos como Cliente 
INSERT INTO Cliente (id_persona_cliente, fecha_alta) 
VALUES (@id_con_email, GETDATE());

-- La registramos como Empleado
INSERT INTO Empleado (id_persona_empleado, legajo) 
VALUES (@id_con_email, 'EMP-OK');


-- =========================================================================
-- VERIFICACION FINAL
-- =========================================================================
SELECT * 
FROM Persona p
LEFT JOIN Empleado e ON p.id_persona = e.id_persona_empleado
LEFT JOIN Cliente c ON p.id_persona = c.id_persona_cliente;


-- =========================================================================
-- LIMPIEZA: BORRAR LOS DATOS DE PRUEBA
-- =========================================================================
DELETE FROM Empleado WHERE id_persona_empleado IN (@id_sin_email, @id_con_email);
DELETE FROM Cliente WHERE id_persona_cliente IN (@id_sin_email, @id_con_email);
DELETE FROM Persona WHERE id_persona IN (@id_sin_email, @id_con_email);
GO


