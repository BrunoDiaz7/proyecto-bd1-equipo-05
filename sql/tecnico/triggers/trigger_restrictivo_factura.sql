USE Proyecto_equipo5;
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

-- =========================================================================
-- DEMOSTRACION DEL TRIGGER RESTRICTIVO DE FACTURA
-- =========================================================================

-- Intentamos borrar una factura y capturamos el error para mostrarlo
BEGIN TRY
    DELETE FROM Factura WHERE id_factura = 1000;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS [Mensaje de Error];
END CATCH;

-- O sino tambien mostrarlo en mensajes
DELETE FROM Factura 
WHERE id_factura = 1000;

-- Comprobamos que la factura sigue intacta en la base de datos
SELECT id_factura, fecha_hora, id_persona_cliente 
FROM Factura 
WHERE id_factura = 1000;
GO

-- =========================================================================
-- RESTAURACION Y LIMPIEZA USANDO LAS TABLAS TEMPORALES
-- =========================================================================

-- Restauramos los valores originales del catalogo desde la tabla temporal
UPDATE c 
SET c.precio = i.precio, 
    c.activo = i.activo,
    c.descripcion = i.descripcion
FROM Catalogo AS c
INNER JOIN #catalogo_inicial AS i ON c.id_catalogo = i.id_catalogo
WHERE c.precio <> i.precio 
   OR c.activo <> i.activo
   OR c.descripcion <> i.descripcion;

-- Borramos solo los registros de auditoria generados en esta sesion
DELETE FROM Auditoria_Precio_Catalogo
WHERE id_auditoria > (SELECT ultimo_id FROM #auditoria_inicial);

-- Eliminamos las tablas temporales de la memoria
DROP TABLE #catalogo_inicial;
DROP TABLE #auditoria_inicial;
GO
