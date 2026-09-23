<div align="center">

# 🗄️ Proyecto BD1 — Equipo 05
# 🖥️ ComproTecno

### Sistema de gestión para un comercio de tecnología, computación y electrónica

<img src="https://img.shields.io/badge/UNNE-Base%20de%20Datos%20I-blue" alt="UNNE - Base de Datos I">
<img src="https://img.shields.io/badge/Proyecto%20Integrador-2026-orange" alt="Proyecto Integrador 2026">
<img src="https://img.shields.io/badge/Equipo-05-green" alt="Equipo 05">
<img src="https://img.shields.io/badge/Estado-En%20desarrollo-yellow" alt="Estado">

</div>

---

## <img src="https://img.shields.io/badge/01-PRESENTACIÓN%20Y%20CONTEXTO-2f81f7" height="24"> Presentación y contexto

**ComproTecno** es un sistema de gestión diseñado para un comercio especializado en **tecnología, computación y electrónica**.

El proyecto surge a partir de la necesidad de gestionar de manera integrada las operaciones comerciales y técnicas del negocio, contemplando tanto la **venta de productos tecnológicos** como la **prestación de servicios técnicos**.

El modelo de negocio comprende dos áreas principales:

- **Comercialización de productos:** venta minorista de componentes de hardware, como procesadores, placas de video y memorias; periféricos; celulares y computadoras ensambladas.
- **Prestación de servicios técnicos:** armado de PC a medida, mantenimiento preventivo, diagnóstico y reparación de equipos.

El sistema permitirá registrar y relacionar la información correspondiente a **productos, servicios, clientes, personal, operaciones, métodos de pago y stock**, proporcionando una estructura centralizada para la gestión de las actividades del comercio.

---

## <img src="https://img.shields.io/badge/02-PROBLEMÁTICA-ef4444" height="24"> Problemática

Uno de los principales problemas identificados en el negocio es la dificultad para mantener un **control preciso y actualizado del stock**.

Los productos y componentes de hardware pueden tener distintos destinos: pueden ser vendidos directamente a un cliente o utilizados como componentes durante la prestación de un servicio técnico.

La falta de un registro integrado puede generar diferencias entre el **inventario físico y el inventario registrado**, provocando problemas al momento de realizar nuevas ventas o reparaciones.

### Solución propuesta

ComproTecno propone centralizar el registro de las operaciones comerciales y técnicas, permitiendo controlar los movimientos de inventario y actualizar las cantidades disponibles como consecuencia de cada operación.

El sistema conservará además el **precio unitario de los productos y la tarifa de los servicios al momento de realizar una operación**, evitando que modificaciones posteriores afecten el historial de operaciones anteriores.

---

## <img src="https://img.shields.io/badge/03-ALCANCE-8b5cf6" height="24"> Alcance del sistema

El sistema permitirá gestionar:

| Área | Funcionalidad |
|---|---|
| **Productos** | Registro y clasificación de productos comercializados. |
| **Categorías** | Organización de los productos según su categoría. |
| **Marcas** | Asociación de productos con su marca o fabricante. |
| **Servicios** | Registro de servicios técnicos y sus tarifas. |
| **Inventario** | Control de stock y movimientos de productos. |
| **Clientes** | Registro y gestión de los clientes del comercio. |
| **Personal** | Registro del personal interviniente, diferenciando vendedores y técnicos. |
| **Operaciones** | Registro de ventas y servicios realizados. |
| **Métodos de pago** | Registro de los medios de pago utilizados en cada operación. |
| **Precios** | Conservación del precio aplicado en cada operación histórica. |

### Fuera del alcance

El sistema no contempla actualmente:

- Gestión de proveedores.
- Gestión de compras de mercadería.
- Gestión de envíos o entregas a domicilio.
- Seguimiento de envíos.
- Sistema de reclamos o atención al cliente posterior a la venta.

---

## Estructura del repositorio

```text
proyecto-bd1-equipo-05/
│
├── docs/
│   │
│   ├── etapa-01/
│   │   ├── descripcion_del_caso.md
│   │   ├── equipo5_etapa_1.docx
│   │   └── reglas-negocio.md
│   │
│   └── etapa-2/
│       ├── der/
│       ├── rel/
│       ├── decisiones-diseño.md
│       └── modelo-relacional.md
│
└── README.md
