# Investigación y Documentación: Procedimientos Almacenados y Funciones en SQL Server

---

## 1. Definición y objetivo

### Definición

En SQL Server (T-SQL), los **procedimientos almacenados (Stored Procedures)** y las **funciones definidas por el usuario (User-Defined Functions - UDF)** son objetos programables del lado del servidor que permiten encapsular lógica de negocio y consultas reutilizables.

Aunque ambos ejecutan código dentro del motor de la base de datos, tienen propósitos, comportamientos y capacidades técnicas fundamentalmente distintas:

- **Procedimientos Almacenados (`CREATE PROCEDURE`)**: Son rutinas imperativas que se ejecutan mediante la sentencia `EXEC` o `EXECUTE`. Tienen la capacidad de modificar el estado físico de la base de datos mediante sentencias DML (`INSERT`, `UPDATE`, `DELETE`), gestionar bloques transaccionales explícitos (`BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK`) y manipular el control de errores con bloques `TRY...CATCH`.
- **Funciones de Usuario (`CREATE FUNCTION`)**: Son bloques declarativos diseñados para realizar cálculos o transformar conjuntos de datos sin alterar el estado de la base de datos (libre de efectos secundarios). Se dividen en:
  - **Funciones Escalares**: Retornan un único valor (`INT`, `DECIMAL`, `VARCHAR`, etc.).
  - **Funciones de Tabla en Línea (iTVF - Inline Table-Valued Functions)**: Retornan una estructura tabular definida por una única sentencia `SELECT`. El optimizador de SQL Server las expande directamente en el plan de ejecución como si fueran una vista con parámetros.
  - **Funciones de Tabla Multisentencia (MSTVF - Multi-Statement Table-Valued Functions)**: Retornan una tabla de retorno explícita declarada en su encabezado y permiten lógica algorítmica compleja interna (`IF`, `WHILE`, declaraciones de variables).

### Diferencias estructurales clave

| Característica | Procedimiento Almacenado (`PROCEDURE`) | Función de Tabla en Línea (`iTVF`) | Función Multisentencia (`MSTVF`) |
|---|---|---|---|
| **Forma de invocación** | Independiente mediante `EXEC` | Integrada en `FROM` / `JOIN` | Integrada en `FROM` / `JOIN` |
| **Operaciones DML (`INSERT`/`UPDATE`/`DELETE`)** | Permite modificar tablas físicas | Prohibido | Prohibido (solo modifica su tabla de retorno) |
| **Manejo de Transacciones** | Permite `BEGIN TRAN`, `COMMIT`, `ROLLBACK` | No permitido | No permitido |
| **Control de Errores** | Soporta bloques `TRY...CATCH` | No permitido | No permitido |
| **Parámetros de Entrada/Salida** | Soporta `INPUT` y `OUTPUT` | Soporta solo parámetros de entrada | Soporta solo parámetros de entrada |
| **Optimización de Rendimiento** | Reutiliza planes de ejecución compilados | Excelente (se expande como una Vista) | Moderado (usa estimaciones fijas de filas) |

### Objetivo

- **Procedimientos Almacenados**: Garantizar operaciones atómicas y consistentes (cumplimiento de propiedades ACID) para la modificación de datos críticos del sistema (ventas, altas de clientes, anulaciones), aislando a las aplicaciones clientes de la complejidad interna de las tablas.
- **Funciones**: Encapsular reglas de cálculo financiero repetibles y parametrizar reportes o vistas de datos complejos sin duplicar sentencias `SELECT` en el código de la aplicación.

---

## 2. Ventajas y aplicaciones

### Ventajas

| Ventaja | Explicación |
|---|---|
| **Modularidad y Reutilización** | La lógica de cálculo o consulta se escribe una sola vez en la base de datos y puede ser invocada por cualquier aplicación o reporte. |
| **Centralización de Reglas de Negocio** | Si el cálculo de un descuento o recargo cambia, se actualiza la función en la base de datos sin necesidad de redesplegar o compilar aplicaciones cliente. |
| **Rendimiento y Menor Tráfico de Red** | Las aplicaciones envían únicamente los parámetros de invocación en lugar de scripts T-SQL extensos, aprovechando la caché de planes de ejecución compilados de SQL Server. |
| **Seguridad por Capa de Abstracción** | Permite conceder permisos de ejecución (`GRANT EXECUTE`) sobre un SP a un usuario sin otorgarle permisos directos de lectura o escritura sobre las tablas base. |
| **Integridad Transaccional Atómica** | Los SPs garantizan que si un proceso compuesto por múltiples pasos falla (ej. insertar factura y descontar stock), ningún cambio parcial persista en la base de datos. |

### Aplicaciones comunes

- **Control transaccional de ventas e inventario** mediante Procedimientos Almacenados.
- **Cálculo de importes, impuestos, descuentos o recargos** mediante Funciones Escalares o Multisentencia.
- **Generación de comprobantes, facturación y reportes analíticos** mediante Funciones de Tabla en Línea (iTVF).
- **Abstracción de operaciones DDL/DML complejas** mediante Parametrización con Tipos Definidos por el Usuario (`User-Defined Table Types`).

### Limitaciones y precauciones

- **UDFs sin efectos secundarios**: En T-SQL, las funciones **no pueden** modificar datos de tablas físicas, ni llamar a procedimientos almacenados, ni ejecutar SQL dinámico (`EXEC()`), ni manejar transacciones.
- **Restricción de manejo de errores en UDFs**: No se permite el uso de `RAISERROR`, `THROW` o bloques `TRY...CATCH` dentro de funciones. Si ocurre un error no controlado, la consulta falla completamente.
- **Rendimiento de Funciones Multisentencia (MSTVF)**: Las funciones multisentencia pueden convertirse en cuellos de botella si procesan grandes volúmenes de datos, ya que SQL Server crea una tabla temporal interna en `tempdb` y suele estimar incorrectamente el número de filas procesadas. Siempre que sea posible, se prefieren las funciones en línea (iTVF).

---

## 3. Caso concreto aplicado al sistema de ventas del equipo

### Contexto del sistema

La base `Proyecto_equipo5` modela una tienda de hardware y servicios técnicos. Para garantizar la integridad operativa, la consistencia financiera y la emisión modular de comprobantes, se diseñaron 5 objetos programables principales:

| # | Objeto | Tipo | Propósito / Regla de Negocio |
|---|---|---|---|
| 1 | `dbo.fn_calcular_descuento` | Function (`MSTVF`) | Calcula subtotal, ajustes (descuento/recargo) y total final según el método de pago activo. |
| 2 | `dbo.fn_comprobante_detalle` | Function (`iTVF`) | Genera la grilla detallada renglón por renglón de facturas en un rango dado. |
| 3 | `dbo.fn_comprobante_resumen` | Function (`iTVF`) | Consolida totales, resumen de cantidades y montos finales por factura. |
| 4 | `dbo.registrar_venta` | Stored Procedure | Proceso transaccional completo de registro de venta, validación de ítems, emisión de factura y descuento de stock. |
| 5 | `dbo.EliminarFactura` | Stored Procedure | Anulación transaccional de comprobantes con reintegro automático de stock de productos físicos. |
| 6 | `dbo.registrar_cliente` | Stored Procedure | Alta de clientes en dos capas (`Persona` + `Cliente`) con validación de DNI único. |

---

### 3.1 Función de Cálculo Financiero de Descuentos y Recargos

**Problema:** Al registrar una venta, el cálculo del subtotal, los recargos o descuentos según el método de pago debe ser exacto y reutilizable tanto en el registro de la transacción como en la simulación previa del carrito de compras.

**Solución:** Una función de tabla multisentencia `dbo.fn_calcular_descuento` que recibe la lista de productos mediante un tipo de tabla (`dbo.ListaProductosTipo`) y el ID del método de pago, retornando una tabla con una sola fila consolidada.

```sql
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
    DECLARE @esActivo BIT = 0;
    DECLARE @ratio_descuento DECIMAL(5, 2) = 0.00;
    DECLARE @ratio_recargo DECIMAL(5, 2) = 0.00;
    DECLARE @subtotal DECIMAL(12, 2) = 0.00;
    DECLARE @monto_ajuste DECIMAL(12, 2) = 0.00;

    SELECT 
        @esActivo = activo, 
        @ratio_descuento = ISNULL(descuento, 0.00), 
        @ratio_recargo = ISNULL(recargo, 0.00)
    FROM Metodo_Pago 
    WHERE id_metodo_pago = @id_metodo_pago;

    IF (@esActivo = 1)
    BEGIN
        SELECT 
            @subtotal = ISNULL(SUM(C.precio * D.cantidad), 0.00)
        FROM @Detalle D
        INNER JOIN Producto P ON D.id_producto = P.id_catalogo_producto
        INNER JOIN Catalogo C ON P.id_catalogo_producto = C.id_catalogo;

        SET @monto_ajuste = ((@subtotal * @ratio_recargo) / 100.00) - ((@subtotal * @ratio_descuento) / 100.00);

        INSERT INTO @Resultado (subtotal, monto_ajuste, monto_final)
        VALUES (@subtotal, @monto_ajuste, @subtotal + @monto_ajuste);
    END;

    RETURN;
END;
GO
```

**Demostración:**

```sql
DECLARE @ListaPrueba dbo.ListaProductosTipo;
DECLARE @IdMetodoDescuento INT;

INSERT INTO @ListaPrueba (id_producto, cantidad)
SELECT TOP 2 id_catalogo_producto, 2 FROM Producto;

SELECT TOP 1 @IdMetodoDescuento = id_metodo_pago 
FROM Metodo_Pago 
WHERE activo = 1 AND ISNULL(descuento, 0) > 0;

SELECT * FROM dbo.fn_calcular_descuento(@IdMetodoDescuento, @ListaPrueba);
```

**Resultado esperado:** Devuelve 1 fila con el `subtotal` bruto acumulado, el `monto_ajuste` (negativo por tratarse de un descuento) y el `monto_final` neto a cobrar.

---

### 3.2 Procedimiento Transaccional de Registro de Venta

**Problema:** Insertar una venta implica modificar múltiples tablas (`Factura`, `Detalle_Factura` y `Producto`). Si la inserción del detalle falla o no hay stock, la factura no debe guardarse.

**Solución:** El procedimiento `dbo.registrar_venta` encapsula toda la operación dentro de un bloque `BEGIN TRANSACTION` / `COMMIT TRANSACTION` con manejo de excepciones `TRY...CATCH`. Invoca a `dbo.fn_calcular_descuento` para obtener los montos finales y actualiza el inventario solo para los productos físicos.

```sql
CREATE OR ALTER PROCEDURE registrar_venta
    @id_empleado INT, 
    @id_cliente INT, 
    @id_metodo_pago INT,
    @Detalle dbo.ListaProductosTipo READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM @Detalle)
        BEGIN
            RAISERROR('Debe incluir al menos un ítem en el detalle de la venta.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

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

        DECLARE @ajuste_historico DECIMAL(12, 2);
        DECLARE @subtotal DECIMAL(12, 2);

        SELECT 
            @subtotal = subtotal,
            @ajuste_historico = monto_ajuste
        FROM dbo.fn_calcular_descuento(@id_metodo_pago, @Detalle);

        IF (@subtotal IS NULL AND @ajuste_historico IS NULL)
        BEGIN
            RAISERROR('El método de pago no se encuentra activo o no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        INSERT INTO Factura (fecha_hora, ajuste_historico, id_metodo_pago, id_persona_empleado, id_persona_cliente)
        VALUES (GETDATE(), @ajuste_historico, @id_metodo_pago, @id_empleado, @id_cliente);

        DECLARE @id_factura_nueva INT = SCOPE_IDENTITY();

        INSERT INTO Detalle_Factura (cantidad, historico_precio_uni, id_factura, id_catalogo)
        SELECT D.cantidad, C.precio, @id_factura_nueva, C.id_catalogo
        FROM @Detalle D
        INNER JOIN Catalogo C ON D.id_producto = C.id_catalogo;

        UPDATE P
        SET P.stock_actual = P.stock_actual - D.cantidad
        FROM Producto P
        INNER JOIN @Detalle D ON P.id_catalogo_producto = D.id_producto;

        COMMIT TRANSACTION;
        PRINT('FACTURA CREADA CORRECTAMENTE');
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
```

**Demostración:**

```sql
DECLARE @ListaVenta dbo.ListaProductosTipo;
DECLARE @EmpleadoID INT, @ClienteID INT, @MetodoPagoID INT;

SELECT TOP 1 @EmpleadoID = id_persona_empleado FROM Empleado;
SELECT TOP 1 @ClienteID = id_persona_cliente FROM Cliente;
SELECT TOP 1 @MetodoPagoID = id_metodo_pago FROM Metodo_Pago WHERE activo = 1;

INSERT INTO @ListaVenta (id_producto, cantidad)
SELECT TOP 1 id_catalogo_producto, 1 FROM Producto;

EXEC dbo.registrar_venta
    @id_empleado = @EmpleadoID,
    @id_cliente = @ClienteID,
    @id_metodo_pago = @MetodoPagoID,
    @Detalle = @ListaVenta;
```

**Resultado esperado:** Se crea la cabecera en `Factura`, los ítems en `Detalle_Factura`, se descuenta la cantidad vendida del `stock_actual` en `Producto` y se confirma la transacción mediante `COMMIT`.

---

### 3.3 Anulación de Comprobantes con Reintegro de Inventario

**Problema:** Al cancelar una factura, la eliminación física de registros sin control genera inconsistencias de inventario.

**Solución:** El procedimiento almacenado `dbo.EliminarFactura` repone automáticamente el stock de los productos devueltos utilizando un `UPDATE ... FROM` cruzado antes de remover las filas hijas y padres.

```sql
CREATE OR ALTER PROCEDURE EliminarFactura
    @id_factura INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Factura WHERE id_factura = @id_factura)
        BEGIN
            RAISERROR('La factura especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- 1. Reponer stock únicamente de productos físicos
        UPDATE P
        SET P.stock_actual = P.stock_actual + DF.cantidad
        FROM Producto P
        INNER JOIN Detalle_Factura DF ON P.id_catalogo_producto = DF.id_catalogo
        WHERE DF.id_factura = @id_factura;

        -- 2. Eliminar tabla hija
        DELETE FROM Detalle_Factura WHERE id_factura = @id_factura;

        -- 3. Eliminar tabla padre
        DELETE FROM Factura WHERE id_factura = @id_factura;

        COMMIT TRANSACTION;
        PRINT 'Factura eliminada correctamente y stock reintegrado.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
```

---

### 3.4 Funciones de Tabla en Línea para Reportes y Comprobantes

**Problema:** Generar vistas de comprobantes para sistemas de impresión o pantallas de consulta requiere parametrización por rango de facturas y posibilidad de filtrado dinámico externo.

**Solución:** Dos Funciones de Tabla en Línea (iTVF): `dbo.fn_comprobante_detalle` para el desglose ítem por ítem y `dbo.fn_comprobante_resumen` para totales agrupados.

```sql
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
        f.id_factura AS Num_Comprobante,
        f.fecha_hora AS Fecha_Emision,
        cp.DNI AS DNI_Cliente,
        CONCAT(cp.apellido, ', ', cp.nombre) AS Cliente,
        mp.nombre_tipo AS Metodo_Pago,
        COUNT(df.id_detalle_factura) AS Cantidad_Renglones,
        SUM(CASE WHEN c.tipo = 'PRODUCTO' THEN df.cantidad ELSE 0 END) AS Cantidad_Productos,
        SUM(CASE WHEN c.tipo = 'SERVICIO' THEN df.cantidad ELSE 0 END) AS Cantidad_Servicios,
        SUM(df.cantidad * df.historico_precio_uni) AS Subtotal_Bruto,
        f.ajuste_historico AS Descuento_Recargo,
        (SUM(df.cantidad * df.historico_precio_uni) + f.ajuste_historico) AS Total_Facturado
    FROM Factura f
    INNER JOIN Cliente cl ON f.id_persona_cliente = cl.id_persona_cliente
    INNER JOIN Persona cp ON cl.id_persona_cliente = cp.id_persona
    INNER JOIN Metodo_Pago mp ON f.id_metodo_pago = mp.id_metodo_pago
    INNER JOIN Detalle_Factura df ON f.id_factura = df.id_factura
    INNER JOIN Catalogo c ON df.id_catalogo = c.id_catalogo 
    WHERE f.id_factura >= ISNULL(@id_factura_inicio, f.id_factura)
      AND f.id_factura <= ISNULL(@id_factura_fin, f.id_factura)
    GROUP BY 
        f.id_factura, f.fecha_hora, cp.DNI, cp.apellido, cp.nombre, mp.nombre_tipo, f.ajuste_historico
);
GO
```

**Demostración de Integración Externa:**

```sql
-- Consultar comprobantes consolidados cuyo monto total supere los $50,000.00
SELECT 
    Num_Comprobante,
    Cliente,
    Metodo_Pago,
    Total_Facturado
FROM dbo.fn_comprobante_resumen(DEFAULT, DEFAULT)
WHERE Total_Facturado > 50000.00;
```

**Resultado esperado:** A diferencia de un procedimiento almacenado, la función en línea permite encadenar cláusulas `WHERE`, `ORDER BY` o hacer `JOIN` con otras tablas desde la consulta externa, optimizándose de forma nativa en el motor de SQL Server.

---

## Fuentes

1. Microsoft Learn, *CREATE PROCEDURE (Transact-SQL)*: https://learn.microsoft.com/es-es/sql/t-sql/statements/create-procedure-transact-sql
2. Microsoft Learn, *CREATE FUNCTION (Transact-SQL)*: https://learn.microsoft.com/es-es/sql/t-sql/statements/create-function-transact-sql
3. Redgate Simple Talk, *User-Defined Functions in SQL Server: Pros and Cons*: https://www.red-gate.com/simple-talk/databases/sql-server/t-sql-programming-sql-server/sql-server-user-defined-functions/