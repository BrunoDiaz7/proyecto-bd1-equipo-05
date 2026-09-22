# Justificación de Decisiones de Diseño del Diagrama Entidad-Relación (DER)

Este documento detalla las decisiones de diseño aplicadas en el modelo conceptual de base de datos para el comercio de tecnología, computación y servicios técnicos. Las decisiones responden a las necesidades del alcance y aseguran el cumplimiento de todas las Reglas de Negocio planteadas.

---

## 1. Entidad Supertipo: `Persona` y Subtipos (`Cliente`, `Personal`)

### Decisión de Diseño
Se aplicó un patrón de jerarquía/especialización con **disyunción restringida (d)** entre la entidad supertipo `Persona` y sus subtipos `Cliente` y `Personal`.

* **Atributos Generales (`Persona`):** `dni`, `nombre_completo` (compuesto por `nombre` y `apellido`) y `telefono`.
* **`Cliente`:** Subtipo de persona enfocado en las transacciones comerciales y servicios.
* **`Personal`:** Subtipo de persona que engloba a los empleados del comercio.

### Justificación Técnica y Reglas de Negocio
* **Polivalencia del Personal (RN05):** Se optó por mantener a `Personal` como un único subtipo unificado en lugar de dividirlo rígidamente en "Vendedor" y "Técnico". Dado que en un comercio especializado de tecnología los empleados poseen conocimientos técnicos y comerciales, el rol que desempeñan se define dinámicamente según el proceso en el que intervienen: actúan como asesores/vendedores en la relación `atiende` con `Operacion` y como técnicos en la relación `recibe` con `Orden_reparacion`.
* **Registro Obligatorio (RN03):** Permite vincular de forma unívoca a los clientes en cada operación realizada sin duplicar atributos personales.

---

## 2. Entidad: `Operacion`

### Decisión de Diseño
`Operacion` representa el evento transaccional central del negocio (venta de productos y/o facturación de servicios prestados).

* **Atributos:** `fecha`, `hora`, `monto`, `tipo_comprobante` y `numero_comprobante`.

### Justificación Técnica y Reglas de Negocio
* **Unificación de Facturación:** En lugar de crear entidades redundantes como `Factura` o `Venta`, se unificó la transacción comercial en `Operacion`. Los atributos `tipo_comprobante` y `numero_comprobante` garantizan la validez legal y el registro administrativo del cobro.
* **Integridad Transaccional (RN08):** La entidad actúa como nodo central que conecta obligatoriamente al cliente (`realiza`), al personal responsable (`atiende`), al método de cobro (`abona_con`) y a los ítems involucrados a través del inventario (`genera` -> `Movimiento_stock`).

---

## 3. Entidad: `Orden_reparacion`

### Decisión de Diseño
Se incorporó la entidad `Orden_reparacion` para gestionar de forma independiente los servicios técnicos de recepción, mantenimiento y reparación de equipos de clientes.

* **Atributos:** `fecha_recepcion`, `falla`, `descripcion`, `tipo_servicio` y `estado`.

### Justificación Técnica y Reglas de Negocio
* **Separación de Catálogo y Objetos de Servicio:** Un equipo a reparar (ej. una notebook de un cliente) no pertenece al inventario a la venta. Esta entidad abstrae el ingreso al taller con el registro de su `falla` y `estado` (*En diagnóstico*, *En reparación*, *Finalizado*).
* **Registro de Servicios Técnicos (RN09):** Conecta directamente con la persona que deja el equipo (`pertenece` a `Cliente`), con el empleado a cargo (`recibe` por `Personal`) y con los componentes utilizados del inventario mediante la relación `genera` hacia `Movimiento_stock`.

---

## 4. Entidad Intermedia y Auditoría: `Movimiento_stock`

### Decisión de Diseño
`Movimiento_stock` actúa como el registro transaccional detallado para la gestión e historial del inventario.

* **Atributos:** `fecha`, `cantidad`, `tipo_movimiento` y `precio_unitario`.

### Justificación Técnica y Reglas de Negocio
* **Inmutabilidad de Precios (RN01):** La inclusión del atributo `precio_unitario` en esta entidad garantiza que el importe cobrado o aplicado en la fecha de la transacción quede congelado e inmutable, evitando variaciones históricas si el valor del producto cambia a futuro en el catálogo.
* **Control de Inventario y Trazabilidad (RN02 y RN09):** Permite registrar las salidas de stock por venta directa (`genera` desde `Operacion`), los egresos de repuestos/componentes consumidos durante un servicio técnico (`genera` desde `Orden_reparacion`), así como eventuales ingresos por compras a proveedores mediante el atributo `tipo_movimiento`.

---

## 5. Entidad: `Producto`

### Decisión de Diseño
Representa el catálogo de componentes de hardware, periféricos, equipos ensamblados y productos disponibles para la venta o uso en reparaciones.

* **Atributos:** `modelo`, `precio`, `stock` y `categoria`.

### Justificación Técnica y Reglas de Negocio
* **Identificación y Clasificación (RN06 y RN07):** Mantiene el estado del stock disponible (`stock`) para la validación previa de ventas y consumo de componentes (RN02). Se categoriza según el tipo de hardware comercializado.
* **Trazabilidad de Stock:** Se vincula con `Movimiento_stock` mediante la relación `afecta` con cardinalidad `(1,1)` a `(0,N)`, garantizando que cada cambio de stock quede asentado en una línea de movimiento.

---

## 6. Entidad: `Metodo_pago`

### Decisión de Diseño
Entidad de soporte que parametriza las formas de pago habilitadas en el comercio.

* **Atributos:** `nombre`, `estado`, `descuento (O)` y `recargo (O)`.

### Justificación Técnica y Reglas de Negocio
* **Métodos de Pago Activos (RN04):** El atributo `estado` permite habilitar o deshabilitar opciones de pago (efectivo, transferencia, tarjeta). Al relacionarse directamente con `Operacion` (`abona_con`), garantiza que el cliente pueda seleccionar libremente cualquier medio activo en cada transacción.
* **Gestión Financiera:** Incluye atributos opcionales `descuento` y `recargo` para soportar políticas comerciales asociadas al método de cobro.

# Justificación de Decisiones de Diseño del Modelo Relacional

Este documento detalla las decisiones de diseño aplicadas en la transformación del Diagrama Entidad-Relación (DER) al **Modelo Relacional** de la base de datos para el comercio de tecnología, computación y servicios técnicos. Se explica el criterio de mapeo a tablas, la selección de Claves Primarias (PK) y Claves Foráneas (FK), y las reglas de integridad referencial para dar cumplimiento a todas las Reglas de Negocio (RN).

---

## 1. Mapeo de la Jerarquía `Persona` (`Cliente` y `Personal`)

### Decisión de Diseño
Para la especialización de `Persona` se implementó la estrategia de **Mapeo a Tablas Separadas para Supertipo y Subtipos con Clave Compartida**.

* **Tabla `PERSONA`:** Actúa como tabla base que contiene la clave primaria generada (`id_persona`) y los datos personales comunes (`dni`, `nombre`, `apellido`, `telefono`).
* **Tablas `CLIENTE` y `PERSONAL`:** Heredan la clave primaria `id_persona` como su propia Clave Primaria (PK) y a la vez Clave Foránea (FK) referenciando a `PERSONA(id_persona)`.

### Justificación Técnica y Reglas de Negocio
* **Integridad y No Redundancia:** Evita la duplicación de columnas de información personal y garantiza que un individuo exista primeramente en la tabla general.
* **Garantía de Herencia Exclusiva/Relación 1:1:** En la tabla `PERSONAL`, la clave foránea `id_persona` incluye una restricción `UNIQUE (U)`, obligando a que la relación entre `Persona` y sus subtipos sea estrictamente 1:1.
* **Polivalencia del Personal (RN05):** La tabla `PERSONAL` no se dividió en subsistemas de vendedores o técnicos. La FK `id_personal` dentro de `OPERACION` representa al empleado que vendió, mientras que en `ORDEN_REPARACION` representa al empleado que reparó.

---

## 2. Tabla `OPERACION`

### Decisión de Diseño
Se definió `OPERACION` como una tabla independiente que consolida la cabecera transaccional y el comprobante legal de cobro.

* **Clave Primaria:** `id_operacion`.
* **Claves Foráneas:** `id_cliente` (ref. `CLIENTE`), `id_personal` (ref. `PERSONAL`), `id_metodo` (ref. `METODO_PAGO`).

### Justificación Técnica y Reglas de Negocio
* **Atributo Único Fiscal:** El campo `numero_comprobante` posee una restricción `UNIQUE (U)` para evitar la duplicación de facturas o tickets emitidos.
* **Cumplimiento de Integridad Transaccional (RN03, RN04, RN05, RN08):** La inclusión obligatoria (`NOT NULL`) de las claves foráneas `id_cliente`, `id_personal` e `id_metodo` asegura que no puedan registrarse ventas ni cobrar operaciones anónimas, sin método de pago asignado o sin un empleado responsable registrado.

---

## 3. Tabla `ORDEN_REPARACION`

### Decisión de Diseño
Tabla creada para administrar de forma aislada los objetos de servicio (equipos dejados por clientes para diagnóstico o reparación).

* **Clave Primaria:** `id_orden`.
* **Claves Foráneas:** `id_cliente` (ref. `CLIENTE`), `id_personal` (ref. `PERSONAL`).

### Justificación Técnica y Reglas de Negocio
* **Desacoplamiento de Catálogo:** Almacena la trazabilidad del servicio técnico (`falla`, `descripcion`, `tipo_servicio`, `estado`) sin alterar las tablas de productos a la venta.
* **Asignación de Responsabilidades (RN05 y RN09):** Contiene `id_cliente` (propietario del equipo) e `id_personal` (técnico encargado) como FKs obligatorias.

---

## 4. Tabla `MOVIMIENTO_STOCK` (Resolución N:M e Inmutabilidad)

### Decisión de Diseño
Funciona como la tabla intermedia que resuelve la relación Muchos a Muchos (N:M) entre las transacciones (`OPERACION` o `ORDEN_REPARACION`) y la tabla `PRODUCTO`, incorporando además la lógica de auditoría de inventario.

* **Clave Primaria:** `id_movimiento`.
* **Claves Foráneas:** `id_producto` (ref. `PRODUCTO`), `id_operacion` (ref. `OPERACION`), `id_orden` (ref. `ORDEN_REPARACION`).

### Justificación Técnica y Reglas de Negocio
* **Inmutabilidad del Precio de Venta (RN01):** La inclusión de la columna `precio_unitario` en esta tabla congela el valor monetario aplicado al producto o componente en la fecha exacta del movimiento. Los cambios de precio posteriores en la tabla `PRODUCTO` no afectan el historial de ventas.
* **Soporte de Exclusión Mutua en Orígenes (RN02 y RN09):** `id_operacion` e `id_orden` son claves foráneas opcionales (`NULL`). Un movimiento por venta directa referenciará a `id_operacion`, un repuesto consumido en taller referenciará a `id_orden`, y un ingreso por compra a proveedores mantendrá ambas FKs en nulo.
* **Trazabilidad de Unidades:** La columna `cantidad` registra el impacto numérico exacto para actualizar o conciliar el stock.

---

## 5. Tabla `PRODUCTO` y Normalización de Catálogos (`CATEGORIA` y `MARCA`)

### Decisión de Diseño
Se aplicó la **Tercera Forma Normal (3FN)** extrayendo la categoría y la marca de la tabla `PRODUCTO` hacia tablas de catálogo independientes.

* **Tabla `PRODUCTO`:** Contiene `id_producto` (PK), `modelo`, `precio`, `stock`.
* **Claves Foráneas:** `id_categoria` (ref. `CATEGORIA`), `id_marca` (ref. `MARCA`).

### Justificación Técnica y Reglas de Negocio
* **Clasificación Obligatoria y Única (RN06):** La presencia de `id_categoria` e `id_marca` como `FK NOT NULL` en `PRODUCTO` fuerza a que cada producto pertenezca estrictamente a una única categoría y a una única marca o fabricante.
* **Identificación Única (RN07):** La Clave Primaria `id_producto` garantiza la unicidad del artículo dentro del sistema.
* **Eliminación de Redundancia:** Evita repetir nombres de marcas o categorías como texto plano en cada fila de producto.

---

## 6. Tabla `METODO_PAGO`

### Decisión de Diseño
Tabla de parametrización para gestionar las alternativas de pago.

* **Clave Primaria:** `id_metodo`.
* **Atributos Operativos:** `nombre`, `estado`, `descuento (O)` y `recargo (O)`.

### Justificación Técnica y Reglas de Negocio
* **Control de Métodos Habilitados (RN04):** El campo booleano `estado` permite deshabilitar formas de cobro. Las consultas del sistema filtrarán únicamente los métodos donde `estado = TRUE` al registrar una nueva fila en `OPERACION`.