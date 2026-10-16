USE Proyecto_equipo5;
GO

-- ============================================================================
-- ANÁLISIS DE DESEMPEÑO DE LOS VENDEDORES
-- ============================================================================
-- El objetivo de esta consulta es ver quiénes son nuestros mejores vendedores.
-- Calculamos sus ventas totales y los clasificamos según los objetivos del mes.
-- Tuvimos que usar una subconsulta para agrupar las cantidades primero, 
-- asegurándonos de que la recaudación final sea exacta y sin errores de suma.
-- ============================================================================
SELECT 
    Emp.legajo AS Legajo,
    P_Emp.DNI AS DNI_Vendedor,
    CONCAT(P_Emp.apellido, ', ', P_Emp.nombre) AS Vendedor,
    
    -- Contamos en cuántas ventas distintas participó el empleado
    COUNT(F.id_factura) AS Cantidad_Facturas,
    
    -- Traemos las cantidades ya procesadas y separadas desde nuestra subconsulta
    SUM(Resumen_Items.Cant_Productos) AS Cantidad_Productos,
    SUM(Resumen_Items.Cant_Servicios) AS Cantidad_Servicios,
    
    -- Ahora sí podemos sumar el monto_final
    SUM(F.monto_final) AS Total_Recaudado,
    
    -- Calculamos el ticket promedio por factura para ver el perfil de venta
    AVG(F.monto_final) AS Promedio_Recaudado_Por_Factura,
    
    -- Evaluamos el desempeño de nuestro equipo según las metas de negocio que definimos
    CASE 
        WHEN SUM(F.monto_final) >= 800 THEN 'Rendimiento Alto'
        WHEN SUM(F.monto_final) >= 300 THEN 'Rendimiento Esperado'
        ELSE 'Rendimiento Básico'
    END AS Categoria_Desempeno
    
FROM Empleado Emp
INNER JOIN Persona P_Emp ON Emp.id_persona_empleado = P_Emp.id_persona
INNER JOIN Factura F ON Emp.id_persona_empleado = F.id_persona_empleado

-- ============================================================================
-- SUBCONSULTA: Cuenta las unidades por cada factura ANTES de unirlas
-- Esto lo hicimos para no duplicar los montos finales al vincular los detalles
-- ============================================================================
INNER JOIN (
    SELECT 
        DF.id_factura,
        SUM(CASE WHEN C.tipo = 'PRODUCTO' THEN DF.cantidad ELSE 0 END) AS Cant_Productos,
        SUM(CASE WHEN C.tipo = 'SERVICIO' THEN DF.cantidad ELSE 0 END) AS Cant_Servicios
    FROM Detalle_Factura DF
    INNER JOIN Catalogo C ON DF.id_catalogo = C.id_catalogo
    GROUP BY DF.id_factura
) AS Resumen_Items ON F.id_factura = Resumen_Items.id_factura

-- Filtramos todas las ventas de septiembre (le agregamos 23:59:59 para no perder ventas del último día)
WHERE F.fecha_hora BETWEEN '2026-09-01' AND '2026-09-30 23:59:59'

-- Agrupamos por los datos del vendedor para poder usar las funciones de suma y promedio
GROUP BY 
    Emp.legajo, 
    P_Emp.DNI, 
    P_Emp.apellido, 
    P_Emp.nombre
    
-- Ordenamos de mayor a menor para ver a los mejores vendedores arriba del todo
ORDER BY Total_Recaudado DESC;