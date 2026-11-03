USE Proyecto_equipo5;
GO

-- =========================================================================
-- 1. PROCEDIMIENTO ALMACENADO (Equivalente al ejemplo de la guía)
-- =========================================================================
CREATE PROCEDURE dbo.sp_RegistrarFacturaSimple
    @monto_subtotal DECIMAL(12,2),
    @id_metodo_pago INT,
    @id_persona_empleado INT,
    @id_persona_cliente INT
AS
BEGIN
    INSERT INTO Factura (fecha_hora, monto_subtotal, monto_ajuste, monto_final, id_metodo_pago, id_persona_empleado, id_persona_cliente)
    VALUES (GETDATE(), @monto_subtotal, 0.00, @monto_subtotal, @id_metodo_pago, @id_persona_empleado, @id_persona_cliente);
END;
GO

-- =========================================================================
-- 2. PARTE 1: PERMISOS ASIGNADOS DIRECTAMENTE A USUARIOS
-- =========================================================================

-- Creación de inicios de sesión (Logins)
CREATE LOGIN usuario_admin WITH PASSWORD = 'Admin123*';
CREATE LOGIN usuario_lector WITH PASSWORD = 'Lector123*';
GO

USE Proyecto_equipo5;
GO

-- Creación de usuarios en la base de datos
CREATE USER usuario_admin FOR LOGIN usuario_admin;
CREATE USER usuario_lector FOR LOGIN usuario_lector;
GO

-- Usuario Administrador (Agregado al rol db_owner)
ALTER ROLE db_owner ADD MEMBER usuario_admin;
GO

-- Usuario con permisos limitados (Permiso de lectura y ejecución del procedimiento)
GRANT SELECT ON dbo.Factura TO usuario_lector;
GRANT EXECUTE ON dbo.sp_RegistrarFacturaSimple TO usuario_lector;
GO


-- =========================================================================
-- 3. PARTE 2: PERMISOS A NIVEL DE ROLES PERSONALIZADOS
-- =========================================================================

-- Creación de logins adicionales
CREATE LOGIN usuario_con_rol WITH PASSWORD = 'Rol123*';
CREATE LOGIN usuario_sin_rol WITH PASSWORD = 'Rol456*';
GO

USE Proyecto_equipo5;
GO

-- Creación de usuarios en la base de datos
CREATE USER usuario_con_rol FOR LOGIN usuario_con_rol;
CREATE USER usuario_sin_rol FOR LOGIN usuario_sin_rol;
GO

-- Creación de un rol personalizado para consultar productos
CREATE ROLE rol_consulta_productos;
GO

-- Asignación de permisos al rol
GRANT SELECT ON dbo.Producto TO rol_consulta_productos;
GO

-- Incorporación de usuario al rol
ALTER ROLE rol_consulta_productos ADD MEMBER usuario_con_rol;
GO
-- =========================================================================
-- 5. SCRIPT DE DEMOSTRACION Y PRUEBAS DE SEGURIDAD
-- =========================================================================

USE Proyecto_equipo5;
GO

-- -------------------------------------------------------------------------
-- 5.1. PRUEBA DEL USUARIO ADMINISTRADOR
-- -------------------------------------------------------------------------

EXECUTE AS USER = 'usuario_admin';

SELECT
    USER_NAME() AS UsuarioActual,
    IS_MEMBER('db_owner') AS EsAdministrador;

REVERT;
GO


-- -------------------------------------------------------------------------
-- 5.2. PRUEBA DEL USUARIO LECTOR
-- -------------------------------------------------------------------------

EXECUTE AS USER = 'usuario_lector';

SELECT
    USER_NAME() AS UsuarioActual,
    HAS_PERMS_BY_NAME('dbo.Factura', 'OBJECT', 'SELECT')
        AS PuedeConsultarFacturas,
    HAS_PERMS_BY_NAME('dbo.sp_RegistrarFacturaSimple', 'OBJECT', 'EXECUTE')
        AS PuedeEjecutarProcedimiento;

-- Comprobacion de consulta de facturas
SELECT * FROM dbo.Factura;

REVERT;
GO


-- -------------------------------------------------------------------------
-- 5.3. PRUEBA DEL USUARIO CON ROL PERSONALIZADO
-- -------------------------------------------------------------------------

EXECUTE AS USER = 'usuario_con_rol';

SELECT
    USER_NAME() AS UsuarioActual,
    IS_MEMBER('rol_consulta_productos') AS PerteneceAlRol,
    HAS_PERMS_BY_NAME('dbo.Producto', 'OBJECT', 'SELECT')
        AS PuedeConsultarProductos;

-- Comprobacion de consulta de productos
SELECT * FROM dbo.Producto;

REVERT;
GO


-- -------------------------------------------------------------------------
-- 5.4. PRUEBA DEL USUARIO SIN ROL
-- -------------------------------------------------------------------------

EXECUTE AS USER = 'usuario_sin_rol';

SELECT
    USER_NAME() AS UsuarioActual,
    IS_MEMBER('rol_consulta_productos') AS PerteneceAlRol,
    HAS_PERMS_BY_NAME('dbo.Producto', 'OBJECT', 'SELECT')
        AS PuedeConsultarProductos;

REVERT;
GO
