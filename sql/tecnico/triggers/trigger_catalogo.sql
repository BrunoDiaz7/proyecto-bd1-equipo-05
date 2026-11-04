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


-- =========================================================================
-- DEMOSTRACION DEL TRIGGER DE CATALOGO
-- =========================================================================


-- =========================================================================
-- GUARDAR EL ESTADO INICIAL EN TABLAS TEMPORALES
-- =========================================================================
DROP TABLE IF EXISTS #catalogo_inicial;
SELECT id_catalogo, precio, activo, descripcion 
INTO #catalogo_inicial 
FROM Catalogo;

DROP TABLE IF EXISTS #auditoria_inicial;
SELECT ISNULL(MAX(id_auditoria), 0) AS ultimo_id 
INTO #auditoria_inicial
FROM Auditoria_Precio_Catalogo;
GO

-- =========================================================================
-- DEMOSTRACION DEL TRIGGER DE AUDITORIA DE PRECIO O ESTADO DE CATALOGO
-- =========================================================================

-- Muestramos la tabla temporal sin datos 
SELECT 
    id_auditoria AS [ID], 
    codigo AS [Cod], 
    precio_anterior AS [Precio Viejo], 
    precio_nuevo AS [Precio Nuevo], 
    activo_anterior AS [Activo Viejo], 
    activo_nuevo AS [Activo Nuevo], 
    usuario_db AS [Usuario], 
    fecha_hora AS [Fecha]
FROM Auditoria_Precio_Catalogo;

-- Modificamos el precio del producto ID 1
UPDATE Catalogo 
SET precio = 999.99 
WHERE id_catalogo = 1;

-- Modificamos el estado del producto ID 2
UPDATE Catalogo 
SET activo = 0 
WHERE id_catalogo = 2;

-- Modificamos una columna no auditada (descripcion) en el producto ID 3
UPDATE Catalogo 
SET descripcion = descripcion + '(Test)' 
WHERE id_catalogo = 3;


-- Mostramos las descripciones de los 3 registros para ver que si se coloco el (test) en la columna no auditada (en la de id_catalogo = 3)
SELECT id_catalogo, descripcion 
FROM Catalogo
WHERE id_catalogo IN (1, 2, 3);

-- Mostramos registros de auditoria generados
SELECT 
    id_auditoria AS [ID], 
    codigo AS [Cod], 
    precio_anterior AS [Precio Viejo], 
    precio_nuevo AS [Precio Nuevo], 
    activo_anterior AS [Activo Viejo], 
    activo_nuevo AS [Activo Nuevo], 
    usuario_db AS [Usuario], 
    fecha_hora AS [Fecha]
FROM Auditoria_Precio_Catalogo
GO

-- =========================================================================
-- RESTAURACION Y LIMPIEZA
-- =========================================================================

-- Restauramos los valores originales del catalogo
UPDATE c
SET c.precio = i.precio,
    c.activo = i.activo,
    c.descripcion = i.descripcion
FROM Catalogo AS c
INNER JOIN #catalogo_inicial AS i ON c.id_catalogo = i.id_catalogo
WHERE c.precio <> i.precio
   OR c.activo <> i.activo
   OR c.descripcion <> i.descripcion;
DELETE FROM Auditoria_Precio_Catalogo
WHERE id_auditoria > (SELECT ultimo_id FROM #auditoria_inicial);

-- Eliminamos las tablas temporales
DROP TABLE #catalogo_inicial;
DROP TABLE #auditoria_inicial;
GO

SELECT * FROM Catalogo WHERE id_catalogo IN (1,2,3)