# Documentación y Justificación de Restricciones (Constraints)

Este documento detalla las decisiones de diseño aplicadas en el DDL para un comercio de tecnología, computación y servicios técnicos, enfocándose en la implementación de restricciones (*constraints*). Las decisiones responden a las necesidades del alcance, aplicando las restricciones (PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK y DEFAULT).

##  Justificación de Restricciones por Tabla

### Tabla `Persona`

* **`PK_Persona PRIMARY KEY (id_persona)`**: Definimos una clave primaria subrogada y autoincremental (`IDENTITY(1,1)`). Decidimos no usar el DNI directamente como clave primaria para optimizar el rendimiento de los índices y facilitar la gestión interna de claves en el sistema.
* **`UQ_DNI_Persona UNIQUE (DNI)`**: Dado que el Documento Nacional de Identidad identifica de manera unívoca a un individuo en el mundo real, aplicamos esta restricción de unicidad para impedir que registremos por error dos veces a la misma persona.

---

### Tablas de Especialización: `Cliente` y `Empleado`

Para representar la jerarquía de personas, implementamos el patrón de herencia **Class Table Inheritance** (una tabla por subentidad).

#### `Cliente`
* **`PK_Cliente PRIMARY KEY (id_persona_cliente)`**: Define la clave primaria de la tabla hija.
* **`FK_Persona_Cliente FOREIGN KEY (id_persona_cliente) REFERENCES Persona(id_persona)`**: Establecimos esta clave foránea para conectar al cliente directamente con su registro base en `Persona`. La combinación de ser PK y FK al mismo tiempo nos garantiza una relación estricta de cardinalidad $1:1$.
* **`DF_Cliente_Alta DEFAULT GETDATE()`**: Decidimos automatizar el registro temporal mediante esta restricción por defecto, permitiendo que el servidor asigne la fecha y hora exactas al momento de dar de alta un cliente.

#### `Empleado`
* **`PK_Empleado PRIMARY KEY (id_persona_empleado)`** y **`FK_Persona_Empleado`**: Mantienen el mismo patrón de especialización $1:1$ con respecto a `Persona`.
* **`UQ_Empleado_Legajo UNIQUE (legajo)`**: Como el legajo es el identificador administrativo interno de la empresa, aplicamos esta restricción de unicidad para evitar que dos empleados compartan el mismo número de identificación laboral.

---

### Tablas Maestras: `Categoria` y `Marca`

* **`PK_Categoria` / `PK_Marca`**: Definimos claves primarias sintéticas autoincrementales para búsquedas y joins más eficientes.
* **`UQ_Nombre_Categoria UNIQUE (nombre_categoria)`** / **`UQ_Marca_Nombre UNIQUE (nombre_marca)`**: Aplicamos unicidad en ambas tablas para evitar redundancias de datos (por ejemplo, evitar registrar dos veces la marca `"Logitech"` o la categoría `"Computación"`), manteniendo limpias las tablas maestras.

---

### Tabla `Catalogo` (Jerarquía de Ítems Comercializables)

* **`PK_Catalogo PRIMARY KEY (id_catalogo)`**: Establecimos esta clave primaria como identificador único global de cualquier bien o servicio que vendamos.
* **`FK_Catalogo_Categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)`**: Obligamos a que todo ítem creado en el catálogo esté obligatoriamente clasificado dentro de una categoría existente.
* **`UQ_Codigo_Catalogo UNIQUE (codigo)`**: Implementamos esta restricción sobre el código comercial o SKU para asegurar que no existan dos productos o servicios con la misma identificación de venta.
* **`CHK_Catalogo_Tipo CHECK (tipo IN ('PRODUCTO', 'SERVICIO'))`**: Definimos esta regla de dominio como discriminador de herencia. Con ella, nos aseguramos de que solo se puedan ingresar tipos de ítems que nuestro sistema esté capacitado para procesar.
* **`DF_Catalogo_Activo DEFAULT 1`**: Adoptamos una estrategia de baja lógica. Al dar de alta un nuevo elemento en el catálogo, asumimos por defecto que estará disponible para la venta (`1 = True`).

---

### Tablas Especializadas: `Producto` y `Servicio`

#### `Producto`
* **`PK_Producto` / `FK_Catalogo_Producto`**: Relación $1:1$ con la tabla padre `Catalogo`. Garantizamos que cada producto tenga previamente su registro comercial correspondiente.
* **`FK_Producto_Marca FOREIGN KEY (id_marca) REFERENCES Marca(id_marca)`**: Forzamos la relación para que todo producto tangible tenga una marca asociada y válida.

#### `Servicio`
* **`PK_Servicio` / `FK_Catalogo_Servicio`**: Relación $1:1$ con la tabla padre `Catalogo`.
* **`CHK_Servicio_Dias_Garantia CHECK (dias_garantia >= 0)`**: Incorporamos esta regla para evitar valores ilógicos o inconsistencias, asegurando que los días de garantía no puedan ser números negativos.
* **`CHK_Servicio_Estimado CHECK (tiempo_estimado_horas >= 0.0)`**: Mismo criterio de validación de dominio: una estimación de tiempo de trabajo no puede tomar valores inferiores a cero.

---

### Tabla `Metodo_Pago`

* **`PK_Metodo_Pago PRIMARY KEY (id_metodo_pago)`**: Clave primaria autoincremental para la tabla de métodos de cobro.
* **`UQ_Metodo_Nombre UNIQUE (nombre_tipo)`**: Evitamos nombres duplicados en los medios de pago (por ejemplo, para que no existan dos filas llamadas `"Efectivo"`).
* **`DF_Metodo_Activo DEFAULT 1`**: Definimos que cualquier nuevo método de pago ingresado esté activo de inmediato para su selección en caja.

---

### Tablas Transaccionales: `Factura` y `Detalle_Factura`

#### `Factura`
* **`PK_Factura PRIMARY KEY (id_factura)`**: Clave primaria subrogada que identifica de manera única a cada comprobante emitido.
* **`FK_Factura_Pago`**: Garantiza que el cobro se registre bajo un medio de pago válido.
* **`FK_Factura_Empleado`**: Asegura la trazabilidad de nuestras ventas, obligando a vincular cada factura con el vendedor que realizó la operación.
* **`FK_Factura_Cliente`**: Asegura la integridad referencial relacionando la transacción con el cliente al cual se le emite el comprobante.

#### `Detalle_Factura`
* **`PK_Detalle_Factura PRIMARY KEY (id_detalle_factura)`**: Clave primaria para identificar individualmente cada renglón de la venta.
* **`FK_Detalle_a_Factura FOREIGN KEY (id_factura) REFERENCES Factura(id_factura)`**: Conecta en forma indivisible la línea de venta con su respectiva cabecera de factura.
* **`FK_Detalle_Catalogo FOREIGN KEY (id_catalogo) REFERENCES Catalogo(id_catalogo)`**: Garantiza que cualquier artículo facturado corresponda a un ítem registrado en nuestro catálogo.
* **`CHK_Detalle_Cantidad CHECK (cantidad > 0)`**: Implementamos esta restricción de negocio para evitar errores en las operaciones: se impide registrar renglones con cantidades nulas o negativas.
