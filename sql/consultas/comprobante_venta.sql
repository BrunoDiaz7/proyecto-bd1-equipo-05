Detalle y Resumen de Comprobantes (comprobante_venta.sql)

Descripción General
En este documento, nosotros explicamos cómo armamos las consultas para simular el sistema de facturación de nuestro local en la base de datos Proyecto_equipo5. 

Nuestro objetivo acá fue recrear cómo se vería una factura real si la tuviéramos que imprimir o mostrar en una pantalla. Para que quede bien completo, dividimos el trabajo en dos partes:
1. El cuerpo de la factura: Donde mostramos el detalle renglón por renglón de todo lo que el cliente se está llevando.
2. El pie o resumen de la factura: Donde agrupamos todo para mostrar los totales, cuántas cosas compró en total, y si le hicimos algún descuento o recargo según cómo nos pagó.

Detalle Renglón por Renglón (Cuerpo del Comprobante)

Con esta primera consulta logramos que la base de datos nos muestre exactamente qué artículos o servicios componen cada venta.
Un detalle importante fue utilizar la función especial ROW_NUMBER(). Esto nos permitió crear la columna "Renglon_Nro", que numera automáticamente los ítems (1, 2, 3...) reiniciando la cuenta cada vez que pasamos a una factura nuevas. 

USE Proyecto_equipo5;
GO

-- ============================================================================
-- REPORTE 1: DETALLE RENGLÓN POR RENGLÓN (CUERPO DEL COMPROBANTE)
-- ============================================================================
-- En esta primera consulta, nosotros logramos recrear la vista detallada de 
-- una factura. Mostramos cada artículo o servicio vendido numerándolo de 
-- forma automática, tal como se vería impreso en el ticket de nuestro local.
-- ============================================================================

SELECT 
    f.id_factura AS Num_Comprobante,
    f.fecha_hora AS Fecha_Emision,
    mp.nombre_tipo AS Metodo_Pago,
    cp.DNI AS DNI_Cliente,
    CONCAT(cp.apellido, ', ', cp.nombre) AS Cliente,
    emp.legajo AS Legajo_Vendedor,
    CONCAT(ep.apellido, ', ', ep.nombre) AS Vendedor,
    
    -- Usamos ROW_NUMBER() para generar un número de renglón automático por factura (1, 2, 3...)
    ROW_NUMBER() OVER (PARTITION BY f.id_factura ORDER BY df.id_detalle_factura) AS Renglon_Nro,
    
    c.codigo AS Codigo_Producto_Servicio,
    c.nombre AS Descripcion,
    cat.nombre_categoria AS Categoria,
    df.cantidad,
    df.historico_precio_uni AS Precio_Unitario_Facturado,
    
    -- Calculamos dinámicamente el subtotal de cada línea (Cantidad * Precio)
    (df.cantidad * df.historico_precio_uni) AS Subtotal_Renglon

FROM Factura f
JOIN Cliente cl ON f.id_persona_cliente = cl.id_persona_cliente
JOIN Persona cp ON cl.id_persona_cliente = cp.id_persona
JOIN Empleado emp ON f.id_persona_empleado = emp.id_persona_empleado
JOIN Persona ep ON emp.id_persona_empleado = ep.id_persona
JOIN Metodo_Pago mp ON f.id_metodo_pago = mp.id_metodo_pago
JOIN Detalle_Factura df ON f.id_factura = df.id_factura
JOIN Catalogo c ON df.id_catalogo = c.id_catalogo
JOIN Categoria cat ON c.id_categoria = cat.id_categoria

-- Filtramos un rango pequeño para probar y mostrar nuestros resultados
WHERE f.id_factura BETWEEN 1001 AND 1006;
