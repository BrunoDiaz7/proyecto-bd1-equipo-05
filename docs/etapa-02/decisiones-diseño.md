# Justificación de Decisiones de Diseño del Diagrama Entidad-Relación (DER)

Este documento detalla las decisiones de diseño aplicadas en el modelo conceptual de base de datos para el comercio de tecnología, computación y servicios técnicos. Las decisiones responden a las necesidades del alcance y aseguran el cumplimiento de todas las Reglas de Negocio planteadas.

### 1. Entidad Supertipo: Persona y Subtipos (Cliente, Personal)

**Decisión de Diseño**
Se aplicó un patrón de jerarquía/especialización con disyunción restringida (d) entre la entidad supertipo Persona y sus subtipos Cliente y Personal.
*   **Atributos Generales (Persona):** id_persona, dni, nombre, apellido, telefono, email y direccion.
*   **Cliente:** Subtipo enfocado en transacciones comerciales, incorpora el atributo propio cuit_cuil.
*   **Personal:** Subtipo que engloba a los empleados del comercio, con su atributo nro_legajo.

**Justificación Técnica y Reglas de Negocio**
*   **Polivalencia del Personal (RN05):** Se optó por mantener a Personal como un único subtipo unificado. El rol del empleado queda definido dinámicamente al intervenir en el sistema mediante la relación *emite* hacia la entidad *Factura*.
*   **Registro Obligatorio (RN03):** Permite vincular de forma unívoca a los clientes a través de la relación *recibe* con *Factura*, sin duplicar datos personales en las operaciones.

### 2. Entidad: Factura

**Decisión de Diseño**
Factura representa el evento transaccional central del negocio, reemplazando conceptos abstractos por un documento concreto.
*   **Atributos:** numero_factura (PK), fecha_emision, monto_total, tipo_comprobante y estado.

**Justificación Técnica y Reglas de Negocio**
*   **Unificación Transaccional:** Se consolidan las ventas comerciales y cobros de servicios bajo una misma entidad. Los atributos garantizan la validez legal y el estado del cobro.
*   **Integridad Transaccional (RN08):** La entidad actúa como nodo central que conecta obligatoriamente al cliente (*recibe*), al personal responsable (*emite*), al método de cobro (*utiliza* hacia Metodo_pago) y a los ítems involucrados mediante la entidad débil Detalle_factura (*contiene*).

### 3. Entidad Supertipo: Catalogo y Subtipos (Producto, Servicio)

**Decisión de Diseño**
Se incorporó una jerarquía con disyunción (d) para el catálogo comercial, abstrayendo los bienes y servicios en el supertipo.
*   **Atributos Catalogo:** id_catalogo (PK), descripcion, tipo, precio, nombre, codigo(U) y tipo.
*   **Servicio:** Subtipo que representa los servicios técnicos prestados (atributo: tarifa_hora).
*   **Producto:** Subtipo para bienes físicos (atributos: codigo_barras, modelo, stock_actual, stock_minimo).

**Justificación Técnica y Reglas de Negocio**
*   **Abstracción de Comercialización:** Permite que una misma factura pueda incluir tanto productos físicos como servicios de reparación de forma transparente y unificada.
*   **Clasificación Específica:** El producto mantiene control de inventario y trazabilidad de fabricante (relación *fabricado* con Marca), mientras que ambos subtipos comparten la categorización general mediante la relación *pertenece* a Categoria.

### 4. Entidad Débil: Detalle_Factura

**Decisión de Diseño**
Detalle_Factura actúa como una entidad débil que depende existencialmente de Factura (mediante la relación *contiene*).
*   **Atributos:** id_detalle (Clave Parcial), cantidad, precio_unitario y subtotal.

**Justificación Técnica y Reglas de Negocio**
*   **Inmutabilidad de Precios (RN01):** La inclusión del atributo precio_unitario garantiza que el importe cobrado quede congelado en la fecha de la transacción, evitando que un cambio futuro en el precio_actual del Item afecte el histórico.
*   **Resolución y Trazabilidad (RN02 y RN09):** Resuelve la vinculación entre la factura y los ítems (relación *incluye*), permitiendo asentar exactamente qué cantidad de productos o servicios se vendieron para actualizar el stock o registrar la mano de obra.

### 5. Entidades de Catálogo: Categoria y Marca

**Decisión de Diseño**
Entidades independientes que normalizan y tipifican las características de los ítems.
*   **Categoria:** id_categoria (PK), nombre_categoria. Se vincula con el supertipo Catalogo.
*   **Marca:** id_marca (PK), nombre_marca. Se vincula exclusivamente con el subtipo Producto.

**Justificación Técnica y Reglas de Negocio**
*   **Identificación y Clasificación (RN06 y RN07):** Evita la redundancia de datos. Al relacionar Categoria directamente con Catalogo, se permite que tanto los servicios como los productos estén organizados lógicamente, mientras que la Marca queda restringida únicamente a los bienes físicos (hardware).

### 6. Entidad: Metodo_pago

**Decisión de Diseño**
Entidad de soporte que parametriza las formas de pago habilitadas en el comercio.
*   **Atributos:** nombre, estado, descuento (O) y recargo (O).

**Justificación Técnica y Reglas de Negocio**
*   **Métodos de Pago Activos (RN04):** El atributo estado permite habilitar o deshabilitar opciones de pago (efectivo, transferencia, tarjeta). Al relacionarse directamente con Factura (relación *utiliza*), garantiza que el cliente pueda seleccionar libremente cualquier medio activo en cada transacción.
*   **Gestión Financiera:** Incluye atributos opcionales descuento y recargo para soportar políticas comerciales asociadas al método de cobro.

---

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
