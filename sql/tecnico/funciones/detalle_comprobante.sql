USE Proyecto_equipo5;
GO

/*
===============================================================================
Función:         dbo.fn_comprobante_detalle
Descripción:     Función que genera el desglose ítem por ítem (renglón por renglón) de los
                 comprobantes emitidos en un rango opcional de facturas.
Parámetros:      
    - @id_factura_inicio INT (Opcional): ID de factura inicial para el filtro.
      Si es NULL, toma por defecto todas las facturas desde el comienzo.
    - @id_factura_fin INT (Opcional): ID de factura final para el filtro.
      Si es NULL, toma por defecto todas las facturas hasta el final.
Retorna:         
    - TABLE: Conjunto de datos con los datos de cabecera (cliente, vendedor, pago),
      numeración correlativa de renglón y detalle comercial del producto/servicio.
===============================================================================
*/
CREATE OR ALTER FUNCTION dbo.fn_comprobante_detalle
(
    @id_factura_inicio INT = NULL,
    @id_factura_fin INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        -- Información de cabecera de la factura
        f.id_factura AS Num_Comprobante,
        f.fecha_hora AS Fecha_Emision,
        mp.nombre_tipo AS Metodo_Pago,
        
        -- Datos del Cliente (Unión Factura -> Cliente -> Persona)
        cp.DNI AS DNI_Cliente,
        CONCAT(cp.apellido, ', ', cp.nombre) AS Cliente,
        
        -- Datos del Vendedor/Empleado (Unión Factura -> Empleado -> Persona)
        emp.legajo AS Legajo_Vendedor,
        CONCAT(ep.apellido, ', ', ep.nombre) AS Vendedor,
        
        -- Enumeración secuencial de ítems por comprobante
        ROW_NUMBER() OVER (PARTITION BY f.id_factura ORDER BY df.id_detalle_factura) AS Renglon_Nro,
        
        -- Detalle del producto o servicio facturado
        c.codigo AS Codigo_Producto_Servicio,
        c.nombre AS Descripcion,
        cat.nombre_categoria AS Categoria,
        df.cantidad,
        df.historico_precio_uni AS Precio_Unitario_Facturado,
        (df.cantidad * df.historico_precio_uni) AS Subtotal_Renglon
    FROM Factura f
    INNER JOIN Cliente cl ON f.id_persona_cliente = cl.id_persona_cliente
    INNER JOIN Persona cp ON cl.id_persona_cliente = cp.id_persona
    INNER JOIN Empleado emp ON f.id_persona_empleado = emp.id_persona_empleado
    INNER JOIN Persona ep ON emp.id_persona_empleado = ep.id_persona
    INNER JOIN Metodo_Pago mp ON f.id_metodo_pago = mp.id_metodo_pago
    INNER JOIN Detalle_Factura df ON f.id_factura = df.id_factura
    INNER JOIN Catalogo c ON df.id_catalogo = c.id_catalogo
    INNER JOIN Categoria cat ON c.id_categoria = cat.id_categoria
    -- Evaluación flexible de rango: Si el parámetro es NULL, se compara contra el mismo id_factura (trae todo)
    WHERE f.id_factura >= ISNULL(@id_factura_inicio, f.id_factura)
      AND f.id_factura <= ISNULL(@id_factura_fin, f.id_factura)
);
GO

/*
===============================================================================
Función:         dbo.fn_comprobante_resumen
Descripción:     Función que consolida los totales generales, conteo de renglones y
                 desglose de cantidades (Productos vs Servicios) por factura.
Parámetros:      
    - @id_factura_inicio INT (Opcional): ID de factura inicial.
    - @id_factura_fin INT (Opcional): ID de factura final.
Retorna:         
    - TABLE: Totales agrupados por comprobante (subtotal bruto, ajuste histórico
      y monto final total facturado).
===============================================================================
*/
CREATE OR ALTER FUNCTION dbo.fn_comprobante_resumen
(
    @id_factura_inicio INT = NULL,
    @id_factura_fin INT = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        -- Identificación básica del comprobante
        f.id_factura AS Num_Comprobante,
        f.fecha_hora AS Fecha_Emision,
        cp.DNI AS DNI_Cliente,
        CONCAT(cp.apellido, ', ', cp.nombre) AS Cliente,
        mp.nombre_tipo AS Metodo_Pago,
        
        -- Métricas consolidadas del detalle
        COUNT(df.id_detalle_factura) AS Cantidad_Renglones,
        SUM(CASE WHEN c.tipo = 'PRODUCTO' THEN df.cantidad ELSE 0 END) AS Cantidad_Productos,
        SUM(CASE WHEN c.tipo = 'SERVICIO' THEN df.cantidad ELSE 0 END) AS Cantidad_Servicios,
        
        -- Importes financieros
        SUM(df.cantidad * df.historico_precio_uni) AS Subtotal_Bruto,
        f.ajuste_historico AS Descuento_Recargo,
        (SUM(df.cantidad * df.historico_precio_uni) + f.ajuste_historico) AS Total_Facturado
    FROM Factura f
    INNER JOIN Cliente cl ON f.id_persona_cliente = cl.id_persona_cliente
    INNER JOIN Persona cp ON cl.id_persona_cliente = cp.id_persona
    INNER JOIN Metodo_Pago mp ON f.id_metodo_pago = mp.id_metodo_pago
    INNER JOIN Detalle_Factura df ON f.id_factura = df.id_factura
    INNER JOIN Catalogo c ON df.id_catalogo = c.id_catalogo 
    -- Filtro dinámico por rango de facturas
    WHERE f.id_factura >= ISNULL(@id_factura_inicio, f.id_factura)
      AND f.id_factura <= ISNULL(@id_factura_fin, f.id_factura)
    GROUP BY 
        f.id_factura,
        f.fecha_hora,
        cp.DNI,
        cp.apellido,
        cp.nombre,
        mp.nombre_tipo,
        f.ajuste_historico
);
GO