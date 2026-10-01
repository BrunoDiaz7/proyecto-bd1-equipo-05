## 1. Traslado del Modelo Lógico al SGBD (Implementación DDL)

El traslado del modelo lógico al SGBD (SQL Server) se llevó a cabo mediante scripts DDL estructurados en bloques o consultas de creación de tablas (`CREATE TABLE`). Este proceso implicó transformar entidades y atributos en tablas físicas y columnas con sus respectivos tipos de datos y propiedades de almacenamiento.

### A. Organización del Script en Consultas/Bloques

La ejecución del código se organizó en bloques secuenciales para respetar el orden de dependencias lógicas:

1. **Primer Bloque (Personas y Roles):** Creación de la tabla base `Persona` y sus extensiones `Cliente` y `Empleado`.
2. **Segundo Bloque (Catálogo y Productos):** Creación de `Categoria`, `Catalogo`, `Marca` y la derivación en `Producto` y `Servicio`.
3. **Tercer Bloque (Operaciones y Transacciones):** Creación de `Metodo_Pago`, `Factura` y `Detalle_Factura`.

### B. Mapeo Físico de Tipos de Datos y Propiedades SGBD

Para garantizar el rendimiento y uso correcto de memoria en el SGBD, cada atributo lógico fue mapeado a un tipo de dato nativo en T-SQL:

* **Autoincrementales (`IDENTITY(1,1)`):** Se utilizó la propiedad `IDENTITY(1,1)` del SGBD para la generación automática de claves numéricas secuenciales en las tablas primarias (`Persona`, `Categoria`, `Catalogo`, `Marca`, `Metodo_Pago`, `Factura`, `Detalle_Factura`).
* **Textos de Longitud Variable (`VARCHAR`):** Se parametrizó la capacidad máxima según el dominio: `VARCHAR(100)` para nombres y apellidos, `VARCHAR(150)` para emails y nombres de producto, `VARCHAR(250)` para descripciones amplias y `VARCHAR(20)` / `VARCHAR(30)` para legajos y teléfonos.
* **Precisión Numérica Monetaria (`DECIMAL`):** Precios, importes y subtotales se definieron como `DECIMAL(12,2)` para garantizar precisión en operaciones monetarias. Para porcentajes de recargos/descuentos y horas estimadas se emplearon `DECIMAL(5,2)` y `DECIMAL(4,2)`.
* **Manejo de Fechas y Estados:** Se empleó `DATE` para `fecha_alta` y `DATETIME` para registrar el momento exacto de emisión en `Factura`. Los estados se manejaron con el tipo de dato `BIT` (1/0).

---

## 2. Implementación de Jerarquías y Subtipos en el SGBD

Uno de los aspectos centrales del paso al SGBD fue cómo representar la herencia o especialización del modelo lógico:

### A. Jerarquía Persona (Cliente y Empleado)
* Se creó `Persona` como tabla padre que agrupa los datos personales universales.
* Las tablas `Cliente` y `Empleado` se crearon definiendo sus claves primarias (`id_persona_cliente` e `id_persona_empleado`) de modo que referencien directamente a `Persona(id_persona)`. 
* **Efecto en el SGBD:** Permite que una misma fila de `Persona` pueda estar vinculada a la vez en `Cliente` y en `Empleado`, resolviendo técnicamente la posibilidad de que un empleado sea también cliente del negocio.

### B. Jerarquía Catálogo (Producto y Servicio)
* La tabla `Catalogo` consolida los ítems comercializables.
* `Producto` y `Servicio` heredan la identidad de `Catalogo` mediante `id_catalogo_producto` e `id_categoria_servicio`, agregando únicamente los atributos específicos de cada dominio (como `stock_actual` y `id_marca` para productos, o `dias_garantia` y `tiempo_estimado_horas` para servicios).

---

## 3. Registro e Integridad en el SGBD

La integridad del sistema y las reglas de negocio se aseguraron mediante la declaración explícita de restricciones nativas del SGBD:

* **Claves Primarias y Foráneas (`PRIMARY KEY`, `FOREIGN KEY`):** Garantizan la identificación única de cada registro y vinculan las relaciones entre tablas (ej. asociar la factura al cliente, al empleado y al método de pago).
* **Restricciones de Unicidad (`UNIQUE`):** Evitan valores duplicados en el SGBD para campos clave como `DNI`, `legajo`, `codigo` de catálogo y nombres de categorías o marcas.
* **Restricciones de Validaciones (`CHECK`):** Fuerzan al SGBD a verificar reglas de dominio, como `tipo IN ('PRODUCTO', 'SERVICIO')`, cantidades mayores a cero (`cantidad > 0`), y tiempos o días de garantía no negativos.
* **Valores por Defecto (`DEFAULT`):** Asignan automáticamente valores desde el SGBD al insertar registros, tales como la fecha actual (`GETDATE()`) en `Cliente` o el estado activo (`1`) en `Catalogo` y `Metodo_Pago`.
* **Inmutabilidad de Precios:** Se implementó guardando el campo `historico_precio_uni` en `Detalle_Factura`, haciendo que la transacción persista el precio del momento de la venta de forma independiente a cambios futuros en la tabla `Catalogo`.
