# Investigación: Triggers (desencadenadores) en SQL Server

---

## 1. Definición y objetivo

### Definición

Un **trigger** (desencadenador) es un tipo especial de procedimiento almacenado que **se ejecuta automáticamente** cuando ocurre un evento en la base de datos. No se invoca con `EXEC`: lo dispara el propio motor.

Los más usados son los **triggers DML**, que se activan cuando alguien intenta modificar datos con `INSERT`, `UPDATE` o `DELETE` sobre una tabla o vista. También existen los triggers DDL (responden a `CREATE`, `ALTER`, `DROP`, etc.) y los de inicio de sesión (`LOGON`). Este trabajo se centra en los DML.

### Cómo "ve" los datos un trigger

Aunque no haya triggers definidos, cada vez que se modifica una tabla el motor maneja dos estructuras temporales con la **misma estructura que la tabla**: `inserted` y `deleted`. 

| Operación | `inserted` | `deleted` |
|---|---|---|
| `INSERT` | filas nuevas | vacía |
| `DELETE` | vacía | filas eliminadas |
| `UPDATE` | valores **nuevos** | valores **anteriores** |

Un `UPDATE` funciona como un borrado de la fila vieja más una inserción de la nueva, y los triggers aprovechan esas dos tablas para saber **qué cambió**. Microsoft las describe como tablas lógicas (conceptuales). 

### Tipos de trigger DML

- **`AFTER`**: se ejecuta después de que la operación se completó correctamente, incluidas las restricciones y las acciones en cascada. 
- **`INSTEAD OF`**: se ejecuta **en lugar de** la operación; la reemplaza. Si el trigger no ejecuta la operación, esta no ocurre. 

### Objetivo

Que la base de datos **haga cumplir reglas por sí misma**, sin depender de que cada aplicación o cada usuario las respete. Los objetivos típicos son:

- Aplicar **reglas de negocio** y mantener la **integridad de los datos**. 
- Registrar **auditorías**: quién cambió qué, cuándo y qué valor tenía antes. 
- **Bloquear** operaciones que no deben permitirse.

---

## 2. Ventajas y aplicaciones

### Ventajas

| Ventaja | Explicación |
|---|---|
| **Automatización** | Se ejecutan solos ante el evento; nadie tiene que acordarse de llamarlos. |
| **Reglas centralizadas** | La regla vive en la base de datos y se cumple venga la operación de donde venga (aplicación, script o consulta manual). |
| **Reglas entre tablas** | Un `CHECK` solo puede mirar las columnas de su propia tabla. Para reglas que cruzan tablas, Microsoft indica que hay que definirlas como triggers. |
| **Auditoría automática** | Permiten guardar el historial de cambios sin modificar las aplicaciones.  |
| **Protección de datos críticos** | Con `INSTEAD OF` se puede impedir por completo una operación, como borrar registros contables. |
| **Valores anteriores disponibles** | `deleted` conserva lo que había antes del cambio, algo que la tabla ya no tiene. |

### Aplicaciones comunes

- **Auditoría** de cambios en precios, stock o datos sensibles.
- **Validaciones** complejas que no caben en una restricción (por ejemplo, depender de otra tabla). 
- **Bloqueo de borrados** o modificaciones en tablas protegidas.
- **Actualización automática** de datos relacionados.
- **Control de eventos del servidor** con triggers DDL y de inicio de sesión (por ejemplo, evitar que se borren sinónimos o limitar conexiones). 

### Limitaciones y precauciones

Los triggers también tienen costos, y conviene mencionarlos:

- **Se ejecutan dentro de la transacción** y mantienen bloqueos hasta el `COMMIT` o `ROLLBACK`, así que un trigger lento puede frenar a otros procesos. 
- Se disparan **una vez por instrucción, no por fila**, por lo que deben programarse pensando en varias filas a la vez. 
- Son **menos visibles** que una restricción: la lógica queda "escondida" en la base de datos.
- **No hay orden garantizado** entre varios triggers del mismo evento, salvo que se use `sp_settriggerorder`.
- Microsoft recomienda **no devolver resultados** (`SELECT`) desde un trigger. 
- Si una restricción declarativa (`CHECK`, `FOREIGN KEY`, `UNIQUE`) alcanza, es preferible a un trigger. 

---

## 4. Caso concreto aplicado al sistema de ventas del equipo

### Contexto del sistema

La base `Proyecto_equipo5` modela una tienda de hardware y servicios técnicos con estas tablas principales:

- `Persona`, con `Cliente` y `Empleado` como especializaciones.
- `Categoria`, `Marca`, `Catalogo` (precios), y `Producto` / `Servicio` (stock y datos propios).
- `Metodo_Pago`, `Factura` y `Detalle_Factura` (ventas).

En un sistema de ventas hay datos que **no pueden perderse ni cambiar sin dejar rastro**: precios, stock, facturas y datos del personal. Para protegerlos se implementaron cuatro triggers.

| # | Trigger | Tabla | Tipo | Regla que resuelve |
|---|---|---|---|---|
| 1 | `trg_Auditar_Precio_Catalogo` | `Catalogo` | `AFTER UPDATE` | Registrar cambios de precio y de estado |
| 2 | `trg_Evitar_Borrado_Factura` | `Factura` | `INSTEAD OF DELETE` | Impedir el borrado de facturas |
| 3 | `trg_Validar_Email_Empleado` | `Empleado` | `AFTER INSERT, UPDATE` | Exigir email al personal |
| 4 | `trg_Auditoria_Producto_UpdateDelete` | `Producto` | `AFTER UPDATE, DELETE` | Registrar cambios o borrados de stock |

### 4.1 Auditoría de precios y estado del catálogo

**Problema:** el precio de un producto cambia con el tiempo y, si alguien lo modifica, no queda registro de cuál era el valor anterior ni quién lo cambió.

**Solución:** un trigger `AFTER UPDATE` sobre `Catalogo` que guarda en `Auditoria_Precio_Catalogo` el valor anterior y el nuevo de `precio` y `activo`.

**Cómo funciona:**
- `deleted` aporta los valores viejos e `inserted` los nuevos; se unen por `id_catalogo`.
- `IF UPDATE(precio) OR UPDATE(activo)` evita auditar cuando se tocan otras columnas.
- El `WHERE` solo inserta si el valor realmente cambió.
- Es `AFTER` porque el cambio ya se aplicó y el trigger solo necesita registrarlo.

```sql
CREATE TABLE dbo.Auditoria_Precio_Catalogo (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_catalogo INT NOT NULL,
    codigo VARCHAR(50) NOT NULL,
    precio_anterior DECIMAL(12,2) NULL,
    precio_nuevo DECIMAL(12,2) NULL,
    activo_anterior BIT NULL,
    activo_nuevo BIT NULL,
    usuario_db VARCHAR(100) NOT NULL DEFAULT (SYSTEM_USER),
    fecha_hora DATETIME NOT NULL DEFAULT (GETDATE())
);
GO

CREATE OR ALTER TRIGGER dbo.trg_Auditar_Precio_Catalogo
ON dbo.Catalogo
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(precio) OR UPDATE(activo)
    BEGIN
        INSERT INTO dbo.Auditoria_Precio_Catalogo
            (id_catalogo, codigo, precio_anterior, precio_nuevo, activo_anterior, activo_nuevo)
        SELECT i.id_catalogo, i.codigo, d.precio, i.precio, d.activo, i.activo
        FROM deleted d
        INNER JOIN inserted i ON d.id_catalogo = i.id_catalogo
        WHERE d.precio <> i.precio OR d.activo <> i.activo;
    END
END;
GO
```

**Demostración:**

```sql
UPDATE Catalogo SET precio = 999.99 WHERE id_catalogo = 1;               -- se audita
UPDATE Catalogo SET activo = 0 WHERE id_catalogo = 2;                    -- se audita
UPDATE Catalogo SET descripcion = descripcion + '(Test)' WHERE id_catalogo = 3;  -- NO se audita

SELECT * FROM Auditoria_Precio_Catalogo;
```

**Resultado esperado:** dos filas de auditoría (el precio del producto 1 pasa de 450.00 a 999.99, y el producto 2 pasa de activo a inactivo). El cambio de descripción del producto 3 se aplica en `Catalogo`, pero no genera auditoría.

### 4.2 Bloqueo del borrado de facturas

**Problema:** una factura emitida es un registro contable; borrarla rompería la integridad de las ventas.

**Solución:** un trigger `INSTEAD OF DELETE` sobre `Factura`.

**Cómo funciona:** al ser `INSTEAD OF`, el trigger corre **en lugar del** `DELETE`. Como no contiene ninguna sentencia `DELETE`, la fila nunca se borra; solo se informa el error.

```sql
CREATE OR ALTER TRIGGER dbo.trg_Evitar_Borrado_Factura
ON dbo.Factura
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    RAISERROR('Operacion denegada por el TRIGGER. No puede eliminar registros de la tabla Factura.', 16, 1);
END;
GO
```

**Demostración:**

```sql
BEGIN TRY
    DELETE FROM Factura WHERE id_factura = 1000;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS [Mensaje de Error];
END CATCH;

SELECT id_factura, fecha_hora, id_persona_cliente FROM Factura WHERE id_factura = 1000;
```

**Resultado esperado:** se muestra el mensaje de error y la factura 1000 sigue en la tabla.

### 4.3 Email obligatorio para empleados

**Problema:** en `Persona` el email es opcional (los clientes pueden no tenerlo), pero el personal sí debe tenerlo. Un `CHECK` no sirve, porque la tabla `Persona` no sabe si esa persona es empleado o cliente. Es una **regla entre tablas**, justo el caso que Microsoft señala para usar triggers.

**Solución:** un trigger `AFTER INSERT, UPDATE` sobre `Empleado` que consulta el email en `Persona`.

**Cómo funciona:**
- `inserted` tiene los empleados que se están registrando; se unen con `Persona` para revisar el email.
- Como es `AFTER`, el registro **ya se insertó** cuando el trigger corre. Por eso hay que deshacerlo con `ROLLBACK TRANSACTION`; mostrar el error con `RAISERROR` solo informa y el empleado quedaría guardado igual.
- Primero se hace el `ROLLBACK` y después el `THROW`, para que el error se pueda capturar con `TRY/CATCH`.

```sql
CREATE OR ALTER TRIGGER dbo.trg_Validar_Email_Empleado
ON dbo.Empleado
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN dbo.Persona AS p ON i.id_persona_empleado = p.id_persona
        WHERE p.email IS NULL OR LTRIM(RTRIM(p.email)) = ''
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'Operación denegada por el TRIGGER. Es obligatorio registrar un email para el personal empleado.', 1;
    END
END;
GO
```

**Demostración** (pasos separados con `GO`, porque el `ROLLBACK` dentro de un trigger aborta el lote en curso):

```sql
-- Persona sin email
INSERT INTO Persona (DNI, nombre, apellido, telefono, email)
VALUES (99999901, 'Test', 'SinEmail', '111111', NULL);
GO

-- Como Empleado: el trigger lo frena
BEGIN TRY
    INSERT INTO Empleado (id_persona_empleado, legajo)
    SELECT id_persona, 'EMP-FAIL' FROM Persona WHERE DNI = 99999901;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS [Mensaje de Error];
END CATCH;
GO

-- Como Cliente: se permite
INSERT INTO Cliente (id_persona_cliente, fecha_alta)
SELECT id_persona, GETDATE() FROM Persona WHERE DNI = 99999901;
GO

-- Persona con email: se permite como Empleado
INSERT INTO Persona (DNI, nombre, apellido, telefono, email)
VALUES (99999902, 'Test', 'ConEmail', '222222', 'empleado@prueba.com');
GO
INSERT INTO Empleado (id_persona_empleado, legajo)
SELECT id_persona, 'EMP-OK' FROM Persona WHERE DNI = 99999902;
GO

-- Limpieza
DELETE FROM Empleado WHERE id_persona_empleado IN (SELECT id_persona FROM Persona WHERE DNI IN (99999901, 99999902));
DELETE FROM Cliente  WHERE id_persona_cliente  IN (SELECT id_persona FROM Persona WHERE DNI IN (99999901, 99999902));
DELETE FROM Persona  WHERE DNI IN (99999901, 99999902);
GO
```

**Resultado esperado:** la persona sin email no puede ser empleado pero sí cliente; la persona con email puede ser ambas cosas.

**Limitación:** este trigger solo se activa al modificar `Empleado`. Si alguien hace `UPDATE Persona SET email = NULL` sobre un empleado ya existente, no se entera. Para cubrir ese caso haría falta un segundo trigger `AFTER UPDATE` en `Persona`.

### 4.4 Auditoría de stock en `Producto`

**Problema:** el stock es un dato sensible: cambios o borrados sin registro hacen imposible rastrear diferencias de inventario.

**Solución:** un trigger `AFTER UPDATE, DELETE` sobre `Producto` que guarda en `Auditoria_Producto` el stock **anterior**, el usuario y la fecha.

**Cómo funciona:** distingue la operación mirando qué tablas tienen filas: si hay filas en `inserted` y en `deleted`, es un `UPDATE`; si solo hay en `deleted`, es un `DELETE`. Siempre lee los valores de `deleted`, que son los anteriores al cambio.

```sql
CREATE TABLE Auditoria_Producto (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    operacion VARCHAR(20) NOT NULL,
    id_catalogo_producto INT NOT NULL,
    stock_actual_anterior INT,
    stock_minimo_anterior INT,
    usuario_db VARCHAR(100) NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TRIGGER trg_Auditoria_Producto_UpdateDelete
ON Producto
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @operacion VARCHAR(20);

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @operacion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
        SET @operacion = 'DELETE';
    ELSE
        RETURN;

    INSERT INTO Auditoria_Producto
        (operacion, id_catalogo_producto, stock_actual_anterior, stock_minimo_anterior, usuario_db, fecha_hora)
    SELECT @operacion, d.id_catalogo_producto, d.stock_actual, d.stock_minimo, SYSTEM_USER, GETDATE()
    FROM deleted d;
END;
GO
```

---

## Fuentes

1. Excel y Más, *Triggers | Curso de SQL Server #19* (YouTube, 2016): https://www.youtube.com/watch?v=jLk4BtAKZUM
2. Data with Baraa, *SQL Triggers (Visually Explained) | Audit Logs Use Case | SQL Course 34* (YouTube, 2024): https://www.youtube.com/watch?v=V81Smc6xrBY
3. Microsoft Learn, *CREATE TRIGGER (Transact-SQL)*: https://learn.microsoft.com/es-es/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver17