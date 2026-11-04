USE Proyecto_equipo5;
GO

/* =========================================================================
   TABLA DE AUDITORIA: Auditoria_Precio_Catalogo
   Propósito: Almacenar el historial de cambios en los precios y el estado 
   (activo/inactivo) de los productos y servicios del catálogo.
   ========================================================================= */

-- Eliminamos la tabla si ya existe para poder recrearla desde cero (para pruebas)
IF OBJECT_ID('dbo.Auditoria_Precio_Catalogo') IS NOT NULL
    DROP TABLE dbo.Auditoria_Precio_Catalogo;
GO

CREATE TABLE dbo.Auditoria_Precio_Catalogo (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_catalogo INT NOT NULL,
    codigo VARCHAR(50) NOT NULL,
    precio_anterior DECIMAL(12,2) NULL,
    precio_nuevo DECIMAL(12,2) NULL,
    activo_anterior BIT NULL,
    activo_nuevo BIT NULL,
    usuario_db VARCHAR(100) NOT NULL CONSTRAINT DF_audcat_usuario DEFAULT (SYSTEM_USER), -- defaul para no tener que estar cargando obligatoriamente
    fecha_hora DATETIME NOT NULL CONSTRAINT DF_audcat_fecha DEFAULT (GETDATE()) -- defaul para no tener que estar cargando obligatoriamente
);
GO

/* =========================================================================
   TRIGGER DE AUDITORIA: trg_Auditar_Precio_Catalogo
   Proposito: Dispararse automaticamente DESPUES (AFTER) de un UPDATE en la 
   tabla Catalogo para guardar el registro histórico.
   ========================================================================= */

CREATE OR ALTER TRIGGER dbo.trg_Auditar_Precio_Catalogo
ON dbo.Catalogo
AFTER UPDATE -- En este caso el update ya se realizo antes del trigger
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(precio) OR UPDATE(activo)
    BEGIN
        INSERT INTO dbo.Auditoria_Precio_Catalogo (
            id_catalogo, 
            codigo, 
            precio_anterior, 
            precio_nuevo, 
            activo_anterior, 
            activo_nuevo
        )
        SELECT 
            i.id_catalogo,
            i.codigo,
            d.precio, -- Extraemos el precio viejo desde la tabla virtual 'deleted'
            i.precio, -- Extraemos el precio nuevo desde la tabla virtual 'inserted'
            d.activo, -- Extraemos el estado viejo desde 'deleted'
            i.activo  -- Extraemos el estado nuevo desde 'inserted'
        FROM deleted d
        INNER JOIN inserted i ON d.id_catalogo = i.id_catalogo
        -- Validacion estricta: Solo registramos si el valor realmente cambió.
        -- Se incluye logica con IS NULL para evitar resultados UNKNOWN si algun campo llega a ser nulo.
        WHERE (d.precio <> i.precio 
               OR (d.precio IS NULL AND i.precio IS NOT NULL) 
               OR (d.precio IS NOT NULL AND i.precio IS NULL))
           OR (d.activo <> i.activo 
               OR (d.activo IS NULL AND i.activo IS NOT NULL) 
               OR (d.activo IS NOT NULL AND i.activo IS NULL)); 
    END
END;
GO

/* =========================================================================
   TRIGGER RESTRICTIVO: trg_Evitar_Borrado_Factura
   Proposito: Bloquear cualquier intento de borrar registros (DELETE) en la 
   tabla Factura para asegurar la integridad de la base de datos.
   ========================================================================= */

CREATE OR ALTER TRIGGER dbo.trg_Evitar_Borrado_Factura
ON dbo.Factura 
INSTEAD OF DELETE-- En este caso con INSTEAD OF la fila todavia no se borro y el trigger decide
AS
BEGIN
    SET NOCOUNT ON;
    
    RAISERROR('Operacion denegada por el TRIGGER. No puede eliminar registros de la tabla Factura.', 16, 1);
END;
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
