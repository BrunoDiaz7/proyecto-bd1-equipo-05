# Informe de Clientes Destacados y Mayor Gasto (`consulta_avanzada.sql`)

## Descripción General

En este script, nosotros quisimos armar una consulta de inteligencia comercial enfocada puramente en nuestros clientes. El objetivo principal es descubrir quiénes son nuestros **clientes VIP** o más importantes.

Para lograrlo, le pedimos a la base de datos que agrupe todas las compras de cada cliente, cuente cuántos tickets tienen, separe cuántos productos y servicios compraron, y sume el gasto total acumulado. Lo más interesante de este reporte es que le pusimos un filtro inteligente (`HAVING` con una subconsulta): **la base de datos calcula automáticamente el promedio general de todas las facturas de la tienda, y solo nos muestra a aquellos clientes cuyo gasto total acumulado supera ese promedio**. De esta manera, filtramos únicamente a los compradores que realmente mueven el negocio.

## Resultados de la Ejecución (Clientes Destacados)

| DNI | Cliente | Cantidad_Tickets | Productos_Comprados | Servicios_Realizados | Gasto_Total_Acumulado | 
| ----- | ----- | ----- | ----- | ----- | ----- | 
| 33777888 | Martínez, Lucas | 1 | 8 | 1 | 16000.00 | 
| 37777888 | Ruiz, Elena | 1 | 2 | 1 | 2788.80 | 
| 31222333 | Sosa, Valentina | 1 | 2 | 0 | 2060.00 | 
| 25111222 | Álvarez, Roberto | 2 | 2 | 0 | 812.40 | 
| 39111222 | Medina, Camila | 1 | 1 | 0 | 514.10 | 
| 43555666 | Castro, Ignacio | 1 | 1 | 0 | 450.00 | 
| 21999000 | Luna, Bautista | 1 | 1 | 0 | 403.20 | 
| 46666777 | Benítez, Milagros | 1 | 1 | 0 | 378.00 | 
| 14888999 | Silva, Julián | 1 | 2 | 0 | 377.40 | 

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
    
    git-- Contamos las facturas únicas por cliente
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
