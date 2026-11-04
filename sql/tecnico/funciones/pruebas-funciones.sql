USE Proyecto_equipo5;
GO

-- =========================================================
-- PRUEBA 1: dbo.fn_calcular_descuento (Caso con Descuento)
-- =========================================================
PRINT '--- 1. PRUEBA FN: CALCULAR DESCUENTO (MÉTODO CON DESCUENTO) ---';

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
-- PRUEBA 2: dbo.fn_calcular_descuento (Caso con Recargo)
-- =========================================================
PRINT '--- 2. PRUEBA FN: CALCULAR DESCUENTO (MÉTODO CON RECARGO) ---';

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
-- PRUEBA 3: dbo.fn_calcular_descuento (Caso Borde: Método Inactivo/Inválido)
-- =========================================================
PRINT '--- 3. PRUEBA FN: CALCULAR DESCUENTO (CASO BORDE - MÉT. INEXISTENTE) ---';

DECLARE @ListaPrueba3 dbo.ListaProductosTipo;

INSERT INTO @ListaPrueba3 (id_producto, cantidad)
SELECT TOP 1 id_catalogo_producto, 1 
FROM Producto;

-- Debe retornar 0 filas debido al filtro IF (@esActivo = 1)
SELECT 
    'Caso 3: Método Inactivo/Inválido' AS Escenario,
    subtotal,
    monto_ajuste,
    monto_final
FROM dbo.fn_calcular_descuento(-999, @ListaPrueba3);
GO

-- =========================================================
-- PRUEBA 4: dbo.fn_comprobante_detalle
-- =========================================================
PRINT '--- 4. PRUEBA FN: DETALLE DE COMPROBANTE ---';

DECLARE @IdFacturaReal INT;
SELECT TOP 1 @IdFacturaReal = id_factura FROM Factura ORDER BY id_factura ASC;

-- A. Consultar el detalle de una factura existente de forma dinámica
SELECT * FROM dbo.fn_comprobante_detalle(@IdFacturaReal, @IdFacturaReal);
GO

-- =========================================================
-- PRUEBA 5: dbo.fn_comprobante_resumen
-- =========================================================
PRINT '--- 5. PRUEBA FN: RESUMEN Y TOTALES DE COMPROBANTE ---';

DECLARE @FacturaMin INT, @FacturaMax INT;
SELECT @FacturaMin = MIN(id_factura), @FacturaMax = MAX(id_factura) FROM Factura;

-- A. Resumen filtrado por el rango completo de facturas existentes
SELECT * FROM dbo.fn_comprobante_resumen(@FacturaMin, @FacturaMax);

-- B. Consultar todos los comprobantes (parámetros por defecto NULL)
SELECT * FROM dbo.fn_comprobante_resumen(DEFAULT, DEFAULT);

-- C. Filtrar desde afuera sobre el resultado de la función (Facturas con Total > $0)
SELECT * 
FROM dbo.fn_comprobante_resumen(DEFAULT, DEFAULT)
WHERE Total_Facturado > 0.00;
GO