# Modelo Relacional de Base de Datos

## Esquema de Tablas y Atributos

### Tabla: `Persona`
*Representa la entidad supertipo con los datos personales compartidos.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_persona` | INT | **PK** | Identificador único de la persona |
| `DNI` | INT | | Documento de identidad (Único) |
| `nombre` | VARCHAR(100) | | Nombre o razón social |
| `apellido` | VARCHAR(100) | | Apellido |
| `telefono` | VARCHAR(30) | | Teléfono de contacto |
| `email` | VARCHAR(150) | | Correo electrónico |

---

### Tabla: `Cliente`
*Subtipo de Persona para los clientes del comercio.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_persona_cliente` | INT | **PK, FK** | Referencia a `Persona(id_persona)` |
| `fecha_alta` | DATE | | Fecha de registro en el sistema |

---

### Tabla: `Empleado`
*Subtipo de Persona para el personal (vendedores y técnicos).*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_persona_empleado` | INT | **PK, FK** | Referencia a `Persona(id_persona)` |
| `legajo` | VARCHAR(20) | | Número de legajo interno (Único) |

---

### Tabla: `Categoria`
*Clasificación para los conceptos del catálogo.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_categoria` | INT | **PK** | Identificador único de la categoría |
| `nombre_categoria` | VARCHAR(100) | | Nombre descriptivo de la categoría |

---

### Tabla: `Marca`
*Marcas y fabricantes de los productos físicos.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_marca` | INT | **PK** | Identificador único de la marca |
| `nombre_marca` | VARCHAR(50) | | Nombre de la marca o fabricante |

---

### Tabla: `Catalogo`
*Supertipo unificado para productos y servicios comercializados.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_catalogo` | INT | **PK** | Identificador único del concepto |
| `codigo` | VARCHAR(50) | | Código o SKU del concepto (Único) |
| `nombre` | VARCHAR(150) | | Nombre comercial |
| `descripcion` | VARCHAR(250) | | Descripción extendida o especificación |
| `precio` | DECIMAL(12,2) | | Precio base de lista |
| `tipo` | VARCHAR(20) | | Indica el tipo ('PRODUCTO' o 'SERVICIO') |
| `activo` | INT | | Estado (`1` = Activo, `0` = Inactivo) |
| `id_categoria` | INT | **FK** | Referencia a `Categoria(id_categoria)` |

---

### Tabla: `Producto`
*Subtipo de Catálogo para componentes y artículos físicos con inventario.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_catalogo_productos` | INT | **PK, FK** | Referencia a `Catalogo(id_catalogo)` |
| `stock_actual` | INT | | Cantidad disponible en stock |
| `stock_minimo` | INT | | Umbral mínimo para reposición |
| `id_marca` | INT | **FK** | Referencia a `Marca(id_marca)` |

---

### Tabla: `Servicios`
*Subtipo de Catálogo para prestaciones de mano de obra y taller técnico.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_catalogo_servicios` | INT | **PK, FK** | Referencia a `Catalogo(id_catalogo)` |
| `dias_garantia` | INT | | Cobertura en días post-servicio |
| `tiempo_estimado_horas` | DECIMAL(4,2) | | Estimación de tiempo de trabajo |

---

### Tabla: `Metodo_Pago`
*Formas de cobro habilitadas con políticas de recargo/descuento.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_metodo_pago` | INT | **PK** | Identificador único del método de pago |
| `nombre_tipo` | VARCHAR(50) | | Nombre (Efectivo, Transferencia, etc.) |
| `recargo` | DECIMAL(5,2) | | Porcentaje de recargo aplicado |
| `descuento` | DECIMAL(5,2) | | Porcentaje de descuento aplicado |
| `activo` | INT | | Estado (`1` = Habilitado, `0` = Deshabilitado) |

---

### Tabla: `Factura`
*Cabecera de las ventas y transacciones cobradas.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_factura` | INT | **PK** | Número o identificador del comprobante |
| `fecha_hora` | DATETIME | | Fecha y hora de emisión |
| `monto_subtotal` | DECIMAL(12,2) | | Suma directa de las líneas de detalle |
| `monto_ajuste` | DECIMAL(12,2) | | Descuento (-) o recargo (+) aplicado |
| `monto_final` | DECIMAL(12,2) | | Total definitivo cobrado |
| `id_metodo_pago` | INT | **FK** | Referencia a `Metodo_Pago(id_metodo_pago)` |
| `id_persona_empleado` | INT | **FK** | Referencia a `Empleado(id_persona_empleado)` |
| `id_persona_cliente` | INT | **FK** | Referencia a `Cliente(id_persona_cliente)` |

---

### Tabla: `Detalle_Factura`
*Líneas de renglones del comprobante con inmutabilidad de precios.*

| Campo | Tipo de Dato | Clave | Descripción |
| :--- | :--- | :--- | :--- |
| `id_detalle_factura` | INT | **PK** | Identificador del renglón |
| `cantidad` | INT | | Cantidad de unidades vendidas |
| `historico_precio_uni` | DECIMAL(12,2) | | Precio cobrado al momento de la venta |
| `id_factura` | INT | **FK** | Referencia a `Factura(id_factura)` |
| `id_catalogo` | INT | **FK** | Referencia a `Catalogo(id_catalogo)` |