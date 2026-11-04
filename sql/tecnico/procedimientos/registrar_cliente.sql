USE Proyecto_equipo5;
GO

/*
===============================================================================
Procedimiento:   dbo.registrar_cliente
Descripción:     Procedimiento almacenado transaccional para la alta de nuevos 
                 clientes. Valida previamente que el DNI no esté registrado en la 
                 tabla Persona, crea el registro maestro en Persona y extiende 
                 la entidad creando la entrada correspondiente en Cliente.
Parámetros:      
    - @dni INT: Documento Nacional de Identidad del cliente (Único).
    - @nombre VARCHAR(100): Nombre(s) del cliente.
    - @apellido VARCHAR(100): Apellido(s) del cliente.
    - @telefono VARCHAR(30): Teléfono de contacto.
    - @email VARCHAR(150) (Opcional): Correo electrónico del cliente.
===============================================================================
*/
CREATE OR ALTER PROCEDURE registrar_cliente
    @dni INT,
    @nombre VARCHAR(100),
    @apellido VARCHAR(100),
    @telefono VARCHAR(30),
    @email VARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 1. Validar unicidad: Verificar si la persona ya existe mediante el DNI
        IF EXISTS (SELECT 1 FROM Persona WHERE DNI = @dni)
        BEGIN
            RAISERROR('La persona con el DNI ingresado ya existe en la base de datos.', 16, 1);
            RETURN;
        END;

        -- Inicio del bloque transaccional
        BEGIN TRANSACTION;

        -- 2. Insertar el registro base en la tabla Persona
        INSERT INTO Persona (DNI, nombre, apellido, telefono, email)
        VALUES (@dni, @nombre, @apellido, @telefono, @email);

        -- Capturar la clave primaria (IDENTITY) autogenerada para el nuevo registro
        DECLARE @id_persona_nueva INT = SCOPE_IDENTITY();

        -- 3. Crear el perfil de Cliente utilizando la clave foránea obtenida
        INSERT INTO Cliente (id_persona_cliente)
        VALUES (@id_persona_nueva);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'CLIENTE CREADO CORRECTAMENTE';
    END TRY
    BEGIN CATCH
        -- Manejo de excepciones: Control y reversión de transacciones pendientes
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Propagar el error capturado
        THROW;
    END CATCH;
END;
GO