USE Proyecto_equipo5;
GO

-- =========================================================
-- PRUEBA 1: dbo.fn_calcular_descuento (Caso Exitoso con Descuento)
-- =========================================================
PRINT '=========================================================';
PRINT '--- 1. PRUEBA FN: CALCULAR DESCUENTO (MÉTODO CON DESCUENTO) ---';
PRINT '=========================================================';

DECLARE @ListaPrueba1 dbo.ListaProductosTipo;
DECLARE @IdMetodoDescuento INT;

-- Cargar 2 productos válidos directamente de la tabla Producto
INSERT INTO @ListaPrueba1 (id_producto, cantidad)
SELECT TOP 2 id_catalogo_producto, 2 
FROM Producto;

-- Obtener un método de pago activo que tenga descuento
SELECT TOP 1 @IdMetodoDescuento = id_metodo_pago 
FROM Metodo_Pago 
WHERE activo = 1 AND ISNULL(descuento, 0) > 0;

SELECT 
    'Caso 1: Con Descuento' AS Escenario,
    subtotal,
    monto_ajuste,
    monto_final
FROM dbo.fn_calcular_descuento(@IdMetodoDescuento, @ListaPrueba1);
GO

-- =========================================================
-- PRUEBA 2: dbo.fn_calcular_descuento (Caso Exitoso con Recargo)
-- =========================================================
PRINT '=========================================================';
PRINT '--- 2. PRUEBA FN: CALCULAR DESCUENTO (MÉTODO CON RECARGO) ---';
PRINT '=========================================================';

DECLARE @ListaPrueba2 dbo.ListaProductosTipo;
DECLARE @IdMetodoRecargo INT;

INSERT INTO @ListaPrueba2 (id_producto, cantidad)
SELECT TOP 1 id_catalogo_producto, 1 
FROM Producto;

-- Obtener un método de pago activo que tenga recargo
SELECT TOP 1 @IdMetodoRecargo = id_metodo_pago 
FROM Metodo_Pago 
WHERE activo = 1 AND ISNULL(recargo, 0) > 0;

SELECT 
    'Caso 2: Con Recargo' AS Escenario,
    subtotal,
    monto_ajuste,
    monto_final
FROM dbo.fn_calcular_descuento(@IdMetodoRecargo, @ListaPrueba2);
GO

-- =========================================================
-- PRUEBA 3: dbo.fn_calcular_descuento (Casos Borde / Falla)
-- =========================================================
PRINT '=========================================================';
PRINT '--- 3. PRUEBA FN: CALCULAR DESCUENTO (CASOS DE FALLA Y BORDE) ---';
PRINT '=========================================================';

-- A. Caso Falla 1: Método de pago inactivo o inexistente (Debe retornar 0 filas)
PRINT '--- 3.A. Método Inexistente/Inactivo (Esperado: 0 filas) ---';
DECLARE @ListaPrueba3A dbo.ListaProductosTipo;

INSERT INTO @ListaPrueba3A (id_producto, cantidad)
SELECT TOP 1 id_catalogo_producto, 1 
FROM Producto;

SELECT 
    'Caso 3.A: Método Inexistente' AS Escenario,
    subtotal,
    monto_ajuste,
    monto_final
FROM dbo.fn_calcular_descuento(-999, @ListaPrueba3A);

-- B. Caso Falla 2: Lista de productos vacía (Esperado: Totales en 0.00)
PRINT '--- 3.B. Lista de Productos Vacía (Esperado: Totales en 0.00) ---';
DECLARE @ListaPrueba3B dbo.ListaProductosTipo; -- Tabla vacía
DECLARE @IdMetodoValido INT;

SELECT TOP 1 @IdMetodoValido = id_metodo_pago FROM Metodo_Pago WHERE activo = 1;

SELECT 
    'Caso 3.B: Lista Vacía' AS Escenario,
    subtotal,
    monto_ajuste,
    monto_final
FROM dbo.fn_calcular_descuento(@IdMetodoValido, @ListaPrueba3B);
GO

-- =========================================================
-- PRUEBA 4: dbo.fn_comprobante_detalle
-- =========================================================
PRINT '=========================================================';
PRINT '--- 4. PRUEBA FN: DETALLE DE COMPROBANTE ---';
PRINT '=========================================================';

-- A. Caso Exitoso: Factura existente capturada dinámicamente
PRINT '--- 4.A. Factura Existente ---';
DECLARE @IdFacturaReal INT;
SELECT TOP 1 @IdFacturaReal = id_factura FROM Factura ORDER BY id_factura ASC;

SELECT * FROM dbo.fn_comprobante_detalle(@IdFacturaReal, @IdFacturaReal);

-- B. Caso Falla: Factura inexistente (Esperado: 0 filas)
PRINT '--- 4.B. Factura Inexistente (Esperado: 0 filas) ---';
SELECT * FROM dbo.fn_comprobante_detalle(999999, 999999);
GO

-- =========================================================
-- PRUEBA 5: dbo.fn_comprobante_resumen
-- =========================================================
PRINT '=========================================================';
PRINT '--- 5. PRUEBA FN: RESUMEN Y TOTALES DE COMPROBANTE ---';
PRINT '=========================================================';

DECLARE @FacturaMin INT, @FacturaMax INT;
SELECT @FacturaMin = MIN(id_factura), @FacturaMax = MAX(id_factura) FROM Factura;

-- A. Caso Exitoso: Resumen por rango de facturas existentes
PRINT '--- 5.A. Resumen por Rango Existente ---';
SELECT * FROM dbo.fn_comprobante_resumen(@FacturaMin, @FacturaMax);

-- B. Caso Exitoso: Consulta completa usando parámetros por defecto
PRINT '--- 5.B. Resumen Completo (DEFAULT) ---';
SELECT * FROM dbo.fn_comprobante_resumen(DEFAULT, DEFAULT);

-- C. Caso Exitoso: Filtrado externo sobre la función
PRINT '--- 5.C. Resumen Filtrado Externamente (Total > 0) ---';
SELECT * 
FROM dbo.fn_comprobante_resumen(DEFAULT, DEFAULT)
WHERE Total_Facturado > 0.00;

-- D. Caso Falla: Rango de facturas inexistente (Esperado: 0 filas)
PRINT '--- 5.D. Rango Inexistente (Esperado: 0 filas) ---';
SELECT * FROM dbo.fn_comprobante_resumen(999999, 999999);
GO