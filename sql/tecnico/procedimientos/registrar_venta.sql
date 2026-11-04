USE Proyecto_equipo5;
GO

/*
===============================================================================
Procedimiento:   dbo.registrar_venta
Descripción:     Procedimiento almacenado transaccional para el registro de ventas.
                 Valida la existencia de productos/servicios y del método de pago,
                 calcula el ajuste financiero mediante la función auxiliar
                 dbo.fn_calcular_descuento, inserta la cabecera (Factura) y sus 
                 detalles (Detalle_Factura), y actualiza automáticamente el stock
                 de los ítems físicos.
Parámetros:      
    - @id_empleado INT: Identificador del empleado/vendedor que registra la venta.
    - @id_cliente INT: Identificador del cliente receptor de la factura.
    - @id_metodo_pago INT: Identificador del método de pago seleccionado.
    - @Detalle dbo.ListaProductosTipo READONLY: Tipo de tabla definido por el usuario
      que contiene el listado de ítems (id_producto, cantidad).
===============================================================================
*/
CREATE OR ALTER PROCEDURE registrar_venta
    @id_empleado INT, 
    @id_cliente INT, 
    @id_metodo_pago INT,
    @Detalle dbo.ListaProductosTipo READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Inicio del bloque transaccional
        BEGIN TRANSACTION;

        -- 1. Validar que la lista de productos no esté vacía
        IF NOT EXISTS (SELECT 1 FROM @Detalle)
        BEGIN
            RAISERROR('Debe incluir al menos un ítem en el detalle de la venta.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- 2. Validar la existencia de la totalidad de los ítems en el catálogo general
        IF EXISTS (
            SELECT 1 
            FROM @Detalle D 
            LEFT JOIN Catalogo C ON D.id_producto = C.id_catalogo 
            WHERE C.id_catalogo IS NULL
        )
        BEGIN
            RAISERROR('Uno o más ítems no existen en el catálogo. Se cancela la venta.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- 3. Declarar variables locales para capturar los montos calculados
        DECLARE @ajuste_historico DECIMAL(12, 2);
        DECLARE @subtotal DECIMAL(12, 2);

        -- 4. Invocación de la función de tabla para obtener subtotal y ajuste (descuento/recargo)
        SELECT 
            @subtotal = subtotal,
            @ajuste_historico = monto_ajuste
        FROM dbo.fn_calcular_descuento(@id_metodo_pago, @Detalle);

        -- Validar la vigencia y existencia del método de pago (retorno NULL por inactividad)
        IF (@subtotal IS NULL AND @ajuste_historico IS NULL)
        BEGIN
            RAISERROR('El método de pago no se encuentra activo o no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- 5. Insertar el registro principal en la cabecera de Factura
        INSERT INTO Factura (fecha_hora, ajuste_historico, id_metodo_pago, id_persona_empleado, id_persona_cliente)
        VALUES (GETDATE(), @ajuste_historico, @id_metodo_pago, @id_empleado, @id_cliente);

        -- Capturar la clave primaria autogenerada (IDENTITY) del comprobante emitido
        DECLARE @id_factura_nueva INT = SCOPE_IDENTITY();

        -- 6. Insertar el desglose de productos y servicios en Detalle_Factura
        INSERT INTO Detalle_Factura (cantidad, historico_precio_uni, id_factura, id_catalogo)
        SELECT 
            D.cantidad,
            C.precio,
            @id_factura_nueva,
            C.id_catalogo
        FROM @Detalle D
        INNER JOIN Catalogo C ON D.id_producto = C.id_catalogo;

        -- 7. Actualización de inventario: Descontar stock únicamente a ítems físicos (tabla Producto)
        UPDATE P
        SET P.stock_actual = P.stock_actual - D.cantidad
        FROM Producto P
        INNER JOIN @Detalle D ON P.id_catalogo_producto = D.id_producto;

        -- Confirmación definitiva de los cambios en la base de datos
        COMMIT TRANSACTION;
        PRINT('FACTURA CREADA CORRECTAMENTE');
    END TRY
    BEGIN CATCH
        -- Manejo de excepciones: Control y reversión de transacciones pendientes
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Propagar la excepción original capturada
        THROW;
    END CATCH;
END;
GO