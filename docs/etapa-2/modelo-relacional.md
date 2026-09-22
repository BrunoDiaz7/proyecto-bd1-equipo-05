# Modelo Relacional de Base de Datos

## Esquema de Tablas y Atributos

### Tabla: `PERSONA`
*Representa la entidad supertipo con los datos generales de los individuos.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_persona` | INT | **PK** |  Identificador único de la persona |
| `dni` | VARCHAR(20) | | Documento nacional de identidad |
| `nombre` | VARCHAR(50) | | Nombre(s) |
| `apellido` | VARCHAR(50) | | Apellido(s) |
| `telefono` | VARCHAR(25) | | Teléfono de contacto |

---

### Tabla: `CLIENTE`
*Subtipo de Persona para los clientes del comercio.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_cliente` | INT | **PK, FK** |  Referencia a `PERSONA(id_persona)` |

---

### Tabla: `PERSONAL`
*Subtipo de Persona para los empleados (vendedores y técnicos).*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- |  :--- |
| `id_personal` | INT | **PK, FK** |  Referencia a `PERSONA(id_persona)` |
| `legajo` | VARCHAR(20) | |  Código de legajo laboral |

---

### Tabla: `CATEGORIA`
*Clasificación de productos.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_categoria` | INT | **PK** | Identificador de la categoría |
| `nombre_categoria` | VARCHAR(50) | | Nombre descriptivo |

---

### Tabla: `MARCA`
*Marcas/Fabricantes de componentes y productos.*

| Campo | Tipo de Dato | Clave |  Descripción |
| :--- | :--- | :--- |  :--- |
| `id_marca` | INT | **PK** |  Identificador de la marca |
| `nombre_marca` | VARCHAR(50) | | Nombre de la marca/fabricante |

---

### Tabla: `PRODUCTO`
*Catálogo de componentes y artículos a la venta.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- |  :--- |
| `id_producto` | INT | **PK** |  Identificador único del producto |
| `modelo` | VARCHAR(100) | |  Modelo/descripción del ítem |
| `precio` | DECIMAL(12,2) | |  Precio de lista actual |
| `stock` | INT | | Cantidad disponible en inventario |
| `id_categoria` | INT | **FK** |  Referencia a `CATEGORIA(id_categoria)` |
| `id_marca` | INT | **FK** |  Referencia a `MARCA(id_marca)` |

---

### Tabla: `METODO_PAGO`
*Formas de cobro habilitadas en el negocio.*

| Campo | Tipo de Dato | Clave |  Descripción |
| :--- | :--- | :--- |  :--- |
| `id_metodo` | INT | **PK** |  Identificador del método |
| `nombre` | VARCHAR(50) | | Nombre (Efectivo, Tarjeta, etc.) |
| `estado` | BOOLEAN | |  Indica si está activo (RN04) |
| `descuento` | DECIMAL(5,2) | |  Porcentaje de descuento opcional |
| `recargo` | DECIMAL(5,2) | |  Porcentaje de recargo opcional |

---

### Tabla: `OPERACION`
*Cabecera de ventas y cobros realizados.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_operacion` | INT | **PK** | Identificador de la operación |
| `fecha` | DATE | | Fecha de la transacción |
| `hora` | TIME | | Hora de la transacción |
| `monto` | DECIMAL(12,2) | |  Importe total cobrado |
| `tipo_comprobante` | VARCHAR(20) | |  Tipo de comprobante |
| `numero_comprobante` | VARCHAR(30) | |  N° fiscal/comprobante |
| `id_metodo` | INT | **FK** |  Referencia a `METODO_PAGO(id_metodo)` |
| `id_cliente` | INT | **FK** |  Referencia a `CLIENTE(id_cliente)` |
| `id_personal` | INT | **FK** |  Referencia a `PERSONAL(id_personal)` (Vendedor) |

---

### Tabla: `ORDEN_REPARACION`
*Registro de ingresos de equipos a servicio técnico.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- |  :--- |
| `id_orden` | INT | **PK**  | N° de orden de reparación |
| `fecha_recepcion` | DATETIME |   | Fecha y hora de ingreso |
| `falla` | TEXT | |  Falla declarada por el cliente |
| `descripcion` | TEXT | | Diagnóstico/observaciones |
| `tipo_servicio` | VARCHAR(50) | |  Tipo de trabajo técnico |
| `estado` | VARCHAR(30) | |  Estado actual del servicio |
| `id_cliente` | INT | **FK** |  Referencia a `CLIENTE(id_cliente)` |
| `id_personal` | INT | **FK** | Referencia a `PERSONAL(id_personal)` (Técnico) |

---

### Tabla: `MOVIMIENTO_STOCK`
*Historial de egresos/ingresos de inventario e inmutabilidad de precios.*

| Campo | Tipo de Dato | Clave |  Descripción |
| :--- | :--- | :--- |  :--- |
| `id_movimiento` | INT | **PK** |  Identificador del movimiento |
| `fecha` | DATETIME | | Fecha y hora del registro |
| `cantidad` | INT | |  Unidades que afectan el stock |
| `tipo_movimiento` | VARCHAR(30) | | Tipo ('VENTA', 'REPUESTO_SERVICIO', etc.) |
| `precio_unitario` | DECIMAL(12,2) | | Precio/tarifa cobrada (RN01) |
| `id_producto` | INT | **FK** |  Referencia a `PRODUCTO(id_producto)` |
| `id_operacion` | INT | **FK** |  Referencia a `OPERACION(id_operacion)` |
| `id_orden` | INT | **FK** | Referencia a `ORDEN_REPARACION(id_orden)` |