

-- =================================================================
-- REPORTE: CLIENTES DESTACADOS Y MAYOR GASTO
-- =================================================================
-- En esta consulta, nosotros agrupamos todas las compras de cada
-- cliente para obtener el total invertido, cantidad de tickets y
-- desglose de productos/servicios. Aplicamos un filtro inteligente
-- (HAVING con subconsulta) para mostrar únicamente a los clientes VIP
-- cuyo gasto total supera el promedio general de la tienda.
-- =================================================================


SELECT 
    P_Cli.DNI,
    CONCAT(P_Cli.apellido, ', ', P_Cli.nombre) AS Cliente,
    
    -- Contamos las facturas únicas por cliente
    COUNT(DISTINCT F.id_factura) AS Cantidad_Tickets,

    -- Desglosamos ítems comprados según si son productos o servicios
    SUM(CASE WHEN C.tipo = 'PRODUCTO' THEN DF.cantidad ELSE 0 END) AS Productos_Comprados,
    SUM(CASE WHEN C.tipo = 'SERVICIO' THEN DF.cantidad ELSE 0 END) AS Servicios_Realizados,
    SUM(F.monto_final) AS Gasto_Total_Acumulado
FROM Cliente Cli
INNER JOIN Persona P_Cli ON Cli.id_persona_cliente = P_Cli.id_persona
INNER JOIN Factura F ON Cli.id_persona_cliente = F.id_persona_cliente
INNER JOIN Detalle_Factura DF ON F.id_factura = DF.id_factura
INNER JOIN Catalogo C ON DF.id_catalogo = C.id_catalogo
GROUP BY 
    P_Cli.DNI, 
    P_Cli.apellido, 
    P_Cli.nombre

    -- Filtramos automáticamente solo los clientes con gasto superior al promedio global
HAVING SUM(F.monto_final) > (
    -- Subconsulta que calcula el ticket promedio de toda la tienda
    SELECT AVG(Resumen.TotalFactura)
    FROM (
        SELECT monto_final AS TotalFactura FROM Factura
    ) AS Resumen
)
ORDER BY Gasto_Total_Acumulado DESC;
