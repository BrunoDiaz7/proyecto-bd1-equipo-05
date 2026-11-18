# Tema 4: Seguridad en SQL Server Express

## 1. Definición y objetivo

La seguridad en SQL Server es el conjunto de mecanismos que permiten controlar el acceso a una base de datos, determinando qué usuarios pueden ingresar y qué operaciones pueden realizar sobre la información almacenada.

SQL Server permite administrar la seguridad mediante la creación de inicios de sesión (LOGIN), usuarios (USER), asignación de permisos y utilización de roles.

**Objetivo:**

El objetivo principal es proteger la información de la base de datos, evitando accesos no autorizados y controlando las operaciones que puede realizar cada usuario según sus responsabilidades.

## 2. Ventajas y aplicaciones

**Ventajas:**

- Protección de la información frente a accesos no autorizados.
- Control de las operaciones que puede realizar cada usuario.
- Organización de los permisos mediante roles.
- Prevención de modificaciones o eliminaciones accidentales.
- Mayor confiabilidad y protección de la base de datos.

**Aplicaciones:**

La seguridad puede aplicarse en diferentes contextos, como sistemas comerciales, administrativos y financieros, donde es necesario establecer distintos niveles de acceso a la información.

En un sistema de ventas permite diferenciar usuarios administradores, empleados y usuarios con permisos limitados, evitando que todos tengan acceso a las mismas operaciones.

## 3. Caso concreto aplicado al sistema de ventas del equipo

En nuestro proyecto de ventas, implementamos mecanismos de seguridad para controlar el acceso a la base de datos `Proyecto_equipo5`.

Para ello, definimos cuatro usuarios con diferentes niveles de permisos:

- **usuario_admin:** cuenta con permisos completos sobre la base de datos mediante su incorporación al rol `db_owner`. Puede administrar la información y los objetos de la base de datos.

- **usuario_lector:** tiene permiso para consultar los registros de la tabla `Factura` y ejecutar el procedimiento almacenado `sp_RegistrarFacturaSimple`, permitiendo consultar y registrar facturas sin disponer de permisos generales de administración.

- **usuario_con_rol:** pertenece al rol personalizado `rol_consulta_productos`, que le permite consultar los registros de la tabla `Producto`.

- **usuario_sin_rol:** no pertenece al rol personalizado y no tiene asignado el permiso específico de consulta sobre la tabla `Producto`.

De esta manera, cada usuario dispone únicamente de los permisos necesarios para realizar determinadas tareas dentro del sistema.

## Conclusión

La implementación de mecanismos de seguridad permite proteger la información de nuestra base de datos y controlar el acceso según las responsabilidades de cada usuario.

Mediante la utilización de usuarios, permisos y roles personalizados, logramos establecer diferentes niveles de acceso, mejorando la organización, protección y confiabilidad del sistema de ventas.
