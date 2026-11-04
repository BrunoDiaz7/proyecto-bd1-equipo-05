USE Proyecto_equipo5;
GO

-- =========================================================
-- PRUEBA 1: Procedimiento registrar_cliente
-- =========================================================
PRINT '=========================================================';
PRINT '--- 1. PRUEBA: REGISTRAR CLIENTE ---';
PRINT '=========================================================';

-- A. Caso Exitoso: Registro de un cliente nuevo
PRINT '--- 1.A. PRUEBA ÉXITO: CLIENTE NUEVO ---';
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
PRINT '=========================================================';
PRINT '--- 2. PRUEBA: REGISTRAR VENTA ---';
PRINT '=========================================================';

-- A. Caso Exitoso: Registro de una venta válida
PRINT '--- 2.A. PRUEBA ÉXITO: REGISTRAR VENTA VÁLIDA ---';
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

-- B. Caso Error: Detalle de productos vacío
PRINT '--- 2.B. PRUEBA ERROR: VENTA CON DETALLE VACÍO ---';
DECLARE @ListaVacia dbo.ListaProductosTipo;
DECLARE @EmpleadoID2 INT, @ClienteID2 INT, @MetodoPagoID2 INT;

SELECT TOP 1 @EmpleadoID2 = id_persona_empleado FROM Empleado;
SELECT TOP 1 @ClienteID2 = id_persona_cliente FROM Cliente;
SELECT TOP 1 @MetodoPagoID2 = id_metodo_pago FROM Metodo_Pago WHERE activo = 1;

BEGIN TRY
    EXEC dbo.registrar_venta
        @id_empleado = @EmpleadoID2,
        @id_cliente = @ClienteID2,
        @id_metodo_pago = @MetodoPagoID2,
        @Detalle = @ListaVacia; -- Tabla sin filas
END TRY
BEGIN CATCH
    PRINT 'Error capturado correctamente: ' + ERROR_MESSAGE();
END CATCH;
GO

-- C. Caso Error: Producto inexistente en el catálogo
PRINT '--- 2.C. PRUEBA ERROR: PRODUCTO INEXISTENTE EN EL CATÁLOGO ---';
DECLARE @ListaProductoInvalido dbo.ListaProductosTipo;
DECLARE @EmpleadoID3 INT, @ClienteID3 INT, @MetodoPagoID3 INT;

SELECT TOP 1 @EmpleadoID3 = id_persona_empleado FROM Empleado;
SELECT TOP 1 @ClienteID3 = id_persona_cliente FROM Cliente;
SELECT TOP 1 @MetodoPagoID3 = id_metodo_pago FROM Metodo_Pago WHERE activo = 1;

-- Se inserta un ID de producto que no existe (-999)
INSERT INTO @ListaProductoInvalido (id_producto, cantidad)
VALUES (-999, 1);

BEGIN TRY
    EXEC dbo.registrar_venta
        @id_empleado = @EmpleadoID3,
        @id_cliente = @ClienteID3,
        @id_metodo_pago = @MetodoPagoID3,
        @Detalle = @ListaProductoInvalido;
END TRY
BEGIN CATCH
    PRINT 'Error capturado correctamente: ' + ERROR_MESSAGE();
END CATCH;
GO

-- D. Caso Error: Método de pago inactivo o inexistente
PRINT '--- 2.D. PRUEBA ERROR: MÉTODO DE PAGO INACTIVO O INEXISTENTE ---';
DECLARE @ListaVenta4 dbo.ListaProductosTipo;
DECLARE @EmpleadoID4 INT, @ClienteID4 INT;

SELECT TOP 1 @EmpleadoID4 = id_persona_empleado FROM Empleado;
SELECT TOP 1 @ClienteID4 = id_persona_cliente FROM Cliente;

INSERT INTO @ListaVenta4 (id_producto, cantidad)
SELECT TOP 1 id_catalogo_producto, 1 
FROM Producto;

BEGIN TRY
    EXEC dbo.registrar_venta
        @id_empleado = @EmpleadoID4,
        @id_cliente = @ClienteID4,
        @id_metodo_pago = -999, -- ID de método de pago inválido
        @Detalle = @ListaVenta4;
END TRY
BEGIN CATCH
    PRINT 'Error capturado correctamente: ' + ERROR_MESSAGE();
END CATCH;
GO


-- =========================================================
-- PRUEBA 3: Procedimiento EliminarFactura
-- =========================================================
PRINT '=========================================================';
PRINT '--- 3. PRUEBA: ELIMINAR FACTURA Y REINTEGRAR STOCK ---';
PRINT '=========================================================';

-- A. Caso Error: Intentar eliminar una factura inexistente
PRINT '--- 3.A. PRUEBA ERROR: ELIMINAR FACTURA INEXISTENTE ---';
BEGIN TRY
    EXEC dbo.EliminarFactura @id_factura = 999999;
END TRY
BEGIN CATCH
    PRINT 'Error capturado correctamente: ' + ERROR_MESSAGE();
END CATCH;
GO

-- B. Caso Exitoso: Eliminar la última factura creada y verificar stock
PRINT '--- 3.B. PRUEBA ÉXITO: ELIMINAR FACTURA EXISTENTE Y REINTEGRAR STOCK ---';
DECLARE @IdFacturaAEliminar INT;
SELECT TOP 1 @IdFacturaAEliminar = id_factura FROM Factura ORDER BY id_factura DESC;

-- Verificar el stock de los productos de la factura antes de la eliminación
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

-- Ejecutar la eliminación atómica
EXEC dbo.EliminarFactura @id_factura = @IdFacturaAEliminar;

-- Verificar que el stock haya aumentado según la cantidad devuelta
SELECT 
    id_catalogo_producto, 
    stock_actual AS stock_despues_de_eliminar 
FROM Producto;
GO