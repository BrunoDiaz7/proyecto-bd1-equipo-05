USE Proyecto_equipo5;
GO

-- =========================================================
-- PRUEBA 1: Procedimiento registrar_cliente
-- =========================================================
PRINT '--- 1. PRUEBA: REGISTRAR CLIENTE ---';

-- A. Caso Exitoso: Registro de un cliente nuevo
DECLARE @DNI_Prueba INT = 45123456;

-- Aseguramos que el DNI no exista previamente para la prueba limpia
DELETE FROM Cliente WHERE id_persona_cliente IN (SELECT id_persona FROM Persona WHERE DNI = @DNI_Prueba);
DELETE FROM Persona WHERE DNI = @DNI_Prueba;

EXEC dbo.registrar_cliente
    @dni = @DNI_Prueba,
    @nombre = 'Juan',
    @apellido = 'Pérez',
    @telefono = '3794112233',
    @email = 'juan.perez@email.com';

-- Verificar que se creó el registro en Persona y Cliente
SELECT P.id_persona, P.DNI, P.nombre, P.apellido, C.fecha_alta
FROM Persona P
INNER JOIN Cliente C ON P.id_persona = C.id_persona_cliente
WHERE P.DNI = @DNI_Prueba;
GO

-- B. Caso Error: Intentar registrar una persona con DNI duplicado
PRINT '--- 1.B. PRUEBA ERROR: REGISTRAR CLIENTE DUPLICADO ---';
BEGIN TRY
    EXEC dbo.registrar_cliente
        @dni = 45123456, -- DNI recién insertado
        @nombre = 'Juan',
        @apellido = 'Pérez',
        @telefono = '3794112233',
        @email = 'juan.perez@email.com';
END TRY
BEGIN CATCH
    PRINT 'Error capturado correctamente: ' + ERROR_MESSAGE();
END CATCH;
GO


-- =========================================================
-- PRUEBA 2: Procedimiento registrar_venta
-- =========================================================
PRINT '--- 2. PRUEBA: REGISTRAR VENTA ---';

DECLARE @ListaVenta dbo.ListaProductosTipo;
DECLARE @EmpleadoID INT, @ClienteID INT, @MetodoPagoID INT;

-- Obtener IDs válidos directamente de la base de datos poblada
SELECT TOP 1 @EmpleadoID = id_persona_empleado FROM Empleado;
SELECT TOP 1 @ClienteID = id_persona_cliente FROM Cliente;
SELECT TOP 1 @MetodoPagoID = id_metodo_pago FROM Metodo_Pago WHERE activo = 1;

-- Cargar 1 unidad de un producto existente
INSERT INTO @ListaVenta (id_producto, cantidad)
SELECT TOP 1 id_catalogo_producto, 1 
FROM Producto;

-- Ejecutar el procedimiento de venta
EXEC dbo.registrar_venta
    @id_empleado = @EmpleadoID,
    @id_cliente = @ClienteID,
    @id_metodo_pago = @MetodoPagoID,
    @Detalle = @ListaVenta;

-- Consultar la última factura generada para verificar resultados
SELECT TOP 1 * FROM Factura ORDER BY id_factura DESC;
SELECT TOP 1 * FROM Detalle_Factura ORDER BY id_detalle_factura DESC;
GO


-- =========================================================
-- PRUEBA 3: Procedimiento EliminarFactura
-- =========================================================
PRINT '--- 3. PRUEBA: ELIMINAR FACTURA Y REINTEGRAR STOCK ---';

DECLARE @IdFacturaAEliminar INT;
SELECT TOP 1 @IdFacturaAEliminar = id_factura FROM Factura ORDER BY id_factura DESC;

-- A. Verificar el stock de un producto antes de borrar la factura
SELECT 
    DF.id_factura, 
    P.id_catalogo_producto, 
    C.nombre, 
    DF.cantidad AS cantidad_facturada, 
    P.stock_actual AS stock_antes_de_eliminar
FROM Detalle_Factura DF
INNER JOIN Producto P ON DF.id_catalogo = P.id_catalogo_producto
INNER JOIN Catalogo C ON P.id_catalogo_producto = C.id_catalogo
WHERE DF.id_factura = @IdFacturaAEliminar;

-- B. Probar eliminación de factura inexistente (Debe lanzar error)
BEGIN TRY
    EXEC dbo.EliminarFactura @id_factura = 999999;
END TRY
BEGIN CATCH
    PRINT 'Error capturado correctamente: ' + ERROR_MESSAGE();
END CATCH;

-- C. Probar eliminación de la factura existente capturada
EXEC dbo.EliminarFactura @id_factura = @IdFacturaAEliminar;

-- D. Verificar que el stock haya aumentado según la cantidad devuelta
SELECT 
    id_catalogo_producto, 
    stock_actual AS stock_despues_de_eliminar 
FROM Producto;
GO