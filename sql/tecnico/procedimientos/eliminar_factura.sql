USE Proyecto_equipo5;
GO

/*
===============================================================================
Procedimiento:   dbo.EliminarFactura
Descripción:     Procedimiento almacenado transaccional para la cancelación y 
                 eliminación física de comprobantes de venta. Reintegra de 
                 forma automática el stock de los productos físicos involucrados 
                 en la venta antes de remover los registros en Detalle_Factura 
                 y la cabecera en Factura.
Parámetros:      
    - @id_factura INT: Identificador único de la factura a eliminar.
===============================================================================
*/
CREATE OR ALTER PROCEDURE EliminarFactura
    @id_factura INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Inicio del bloque transaccional atómico
        BEGIN TRANSACTION;

        -- 1. Validar la existencia de la factura en la base de datos
        IF NOT EXISTS (SELECT 1 FROM Factura WHERE id_factura = @id_factura)
        BEGIN
            RAISERROR('La factura especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- 2. Restablecer el inventario: Reintegrar el stock únicamente para ítems físicos (tabla Producto)
        UPDATE P
        SET P.stock_actual = P.stock_actual + DF.cantidad
        FROM Producto P
        INNER JOIN Detalle_Factura DF ON P.id_catalogo_producto = DF.id_catalogo
        WHERE DF.id_factura = @id_factura;

        -- 3. Eliminar los registros asociados en la tabla hija (Detalle_Factura)
        DELETE FROM Detalle_Factura 
        WHERE id_factura = @id_factura;

        -- 4. Eliminar el registro principal en la tabla padre (Factura)
        DELETE FROM Factura 
        WHERE id_factura = @id_factura;

        -- Confirmación definitiva de los cambios en la base de datos
        COMMIT TRANSACTION;
        PRINT 'Factura eliminada correctamente y stock reintegrado.';
    END TRY
    BEGIN CATCH
        -- Manejo de excepciones: Control y reversión de transacciones pendientes
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Propagar la excepción original capturada hacia la aplicación
        THROW;
    END CATCH;
END;
GO