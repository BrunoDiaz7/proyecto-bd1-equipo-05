USE Proyecto_equipo5;
GO

/*
===============================================================================
Función:         dbo.fn_calcular_descuento
Descripción:     Función de tabla multisentencia (MSTVF) que calcula el subtotal,
                 el monto de ajuste (descuento o recargo) y el total final de
                 una lista de productos en función del método de pago seleccionado.
Parámetros:      
    - @id_metodo_pago INT: Identificador único del método de pago.
    - @Detalle dbo.ListaProductosTipo READONLY: Tipo de tabla definido por el usuario
      que contiene los productos (id_producto, cantidad) a procesar.
Retorna:         
    - TABLE (@Resultado): Tabla con una sola fila que contiene:
        * subtotal DECIMAL(12, 2): Sumatoria del valor base de los ítems.
        * monto_ajuste DECIMAL(12, 2): Monto neto descontado o recargado.
        * monto_final DECIMAL(12, 2): Suma del subtotal más el ajuste.
===============================================================================
*/

-- 1. Eliminación preventiva de la función si ya existe (escalar o de tabla)
IF OBJECT_ID('dbo.fn_calcular_descuento', 'FN') IS NOT NULL 
   OR OBJECT_ID('dbo.fn_calcular_descuento', 'TF') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.fn_calcular_descuento;
END;
GO

-- 2. Definición de la función de tabla
CREATE FUNCTION dbo.fn_calcular_descuento
(
    @id_metodo_pago INT,
    @Detalle dbo.ListaProductosTipo READONLY
)
RETURNS @Resultado TABLE
(
    subtotal DECIMAL(12, 2),
    monto_ajuste DECIMAL(12, 2),
    monto_final DECIMAL(12, 2)
)
AS
BEGIN
    -- Declaración e inicialización de variables locales de control y cálculo
    DECLARE @esActivo BIT = 0;
    DECLARE @ratio_descuento DECIMAL(5, 2) = 0.00;
    DECLARE @ratio_recargo DECIMAL(5, 2) = 0.00;
    DECLARE @subtotal DECIMAL(12, 2) = 0.00;
    DECLARE @monto_ajuste DECIMAL(12, 2) = 0.00;

    -- Obtener el estado de habilitación y los porcentajes aplicables del método de pago
    SELECT 
        @esActivo = activo, 
        @ratio_descuento = ISNULL(descuento, 0.00), 
        @ratio_recargo = ISNULL(recargo, 0.00)
    FROM Metodo_Pago 
    WHERE id_metodo_pago = @id_metodo_pago;

    -- Evaluar si el método de pago especificado existe y se encuentra activo
    IF (@esActivo = 1)
    BEGIN
        -- Calcular el subtotal acumulado multiplicando el precio de catálogo por la cantidad ingresada
        SELECT 
            @subtotal = ISNULL(SUM(C.precio * D.cantidad), 0.00)
        FROM @Detalle D
        INNER JOIN Producto P ON D.id_producto = P.id_catalogo_producto
        INNER JOIN Catalogo C ON P.id_catalogo_producto = C.id_catalogo;

        -- Calcular el valor monetario del ajuste: (% recargo - % descuento) aplicado al subtotal
        SET @monto_ajuste = ((@subtotal * @ratio_recargo) / 100.00) - ((@subtotal * @ratio_descuento) / 100.00);

        -- Insertar el resultado final consolidado en la tabla de retorno
        INSERT INTO @Resultado (subtotal, monto_ajuste, monto_final)
        VALUES (@subtotal, @monto_ajuste, @subtotal + @monto_ajuste);
    END;
    -- Nota: Si el método de pago no está activo o no existe, la tabla de retorno se envía vacía (0 filas).

    RETURN;
END;
GO