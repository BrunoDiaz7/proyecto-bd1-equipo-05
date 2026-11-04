SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

-- ==========================================
-- ESCENARIO 1: Consulta Sin Índice
-- ==========================================
DROP INDEX IF EXISTS IX_Factura_FechaHora ON Factura;
DROP INDEX IF EXISTS IX_Factura_FechaHora_Cobertura ON Factura;
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
GO

SELECT id_factura, fecha_hora, monto_final, id_persona_empleado
FROM Factura
WHERE fecha_hora BETWEEN '2024-09-01' AND '2024-09-30 23:59:59';
GO

-- ==========================================
-- ESCENARIO 2: Con Índice Básico (No Agrupado)
-- ==========================================
CREATE NONCLUSTERED INDEX IX_Factura_FechaHora 
ON Factura (fecha_hora);
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
GO

SELECT id_factura, fecha_hora, monto_final, id_persona_empleado
FROM Factura
WHERE fecha_hora BETWEEN '2024-09-01' AND '2024-09-30 23:59:59';
GO

-- ==========================================
-- ESCENARIO 3: Con Índice de Cobertura (INCLUDE)
-- ==========================================
DROP INDEX IX_Factura_FechaHora ON Factura;
GO

CREATE NONCLUSTERED INDEX IX_Factura_FechaHora_Cobertura
ON Factura (fecha_hora)
INCLUDE (monto_final, id_persona_empleado);
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
GO

SELECT id_factura, fecha_hora, monto_final, id_persona_empleado
FROM Factura
WHERE fecha_hora BETWEEN '2024-09-01' AND '2024-09-30 23:59:59';
GO

USE proyecto_equipo5;
GO

-- 1. Obtener una categoría válida de la tabla Categoria
DECLARE @id_cat_valida INT;
SELECT TOP 1 @id_cat_valida = id_categoria FROM Categoria;

-- Si por alguna razón la tabla Categoria está totalmente vacía, asigna 1
IF @id_cat_valida IS NULL
    SET @id_cat_valida = 1;

-- 2. Insertar 50.000 registros sintéticos en Catalogo
SET NOCOUNT ON;
DECLARE @i INT = 1;

WHILE @i <= 50000
BEGIN
    INSERT INTO Catalogo (codigo, nombre, descripcion, precio, tipo, activo, id_categoria)
    VALUES (
        'COD-' + CAST(@i AS VARCHAR(10)),
        'Producto ' + CAST(@i AS VARCHAR(10)),
        'Descripción del producto ' + CAST(@i AS VARCHAR(10)),
        CAST((RAND() * 5000) + 100 AS DECIMAL(12,2)),
        CASE WHEN @i % 2 = 0 THEN 'PRODUCTO' ELSE 'SERVICIO' END,
        CASE WHEN @i % 5 = 0 THEN 0 ELSE 1 END,
        @id_cat_valida
    );
    
    SET @i = @i + 1;
END;
GO


SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

-- ==========================================
-- ESCENARIO 1: Consulta Sin Índice
-- ==========================================
DROP INDEX IF EXISTS IX_Catalogo_Categoria_Activo ON Catalogo;
DROP INDEX IF EXISTS IX_Catalogo_Categoria_Activo_Cobertura ON Catalogo;
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
GO

SELECT id_catalogo, codigo, nombre, precio
FROM Catalogo
WHERE id_categoria = 5 AND activo = 1;
GO

-- ==========================================
-- ESCENARIO 2: Con Índice Básico (No Agrupado)
-- ==========================================
CREATE NONCLUSTERED INDEX IX_Catalogo_Categoria_Activo 
ON Catalogo (id_categoria, activo);
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
GO

SELECT id_catalogo, codigo, nombre, precio
FROM Catalogo
WHERE id_categoria = 5 AND activo = 1;
GO

-- ==========================================
-- ESCENARIO 3: Con Índice de Cobertura (INCLUDE)
-- ==========================================
DROP INDEX IX_Catalogo_Categoria_Activo ON Catalogo;
GO

CREATE NONCLUSTERED INDEX IX_Catalogo_Categoria_Activo_Cobertura
ON Catalogo (id_categoria, activo)
INCLUDE (codigo, nombre, precio);
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
GO

SELECT id_catalogo, codigo, nombre, precio
FROM Catalogo
WHERE id_categoria = 5 AND activo = 1;
GO
