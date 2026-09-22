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