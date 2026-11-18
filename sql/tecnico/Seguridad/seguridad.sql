USE Proyecto_equipo5;
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
GRANT EXECUTE ON TYPE::dbo.ListaProductosTipo TO usuario_lector;
GRANT EXECUTE ON dbo.registrar_venta TO usuario_lector;
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
    HAS_PERMS_BY_NAME('registrar_venta', 'OBJECT', 'EXECUTE')
        AS PuedeEjecutarProcedimiento;

-- prueba de ejecucion de procedimiento
DECLARE @Carrito dbo.ListaProductosTipo;
INSERT INTO @Carrito (id_producto, cantidad) VALUES (1, 2), (2, 5);

EXEC registrar_venta
@id_empleado = 1,
@id_cliente = 10,
@id_metodo_pago = 1,
@detalle = @Carrito;

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