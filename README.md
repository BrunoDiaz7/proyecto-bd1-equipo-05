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

--

## <img src="https://img.shields.io/badge/04-OBJETIVOS%20GENERALES-10b981" height="24"> Objetivos generales

1. **Diseñar una base de datos relacional** que represente adecuadamente el funcionamiento de ComproTecno.

2. **Modelar el dominio del negocio**, identificando las entidades, atributos, relaciones y restricciones necesarias.

3. **Definir las reglas de negocio** que regulan las operaciones comerciales y técnicas del sistema.

4. **Construir el modelo conceptual** mediante un Diagrama Entidad-Relación (DER), utilizando las entidades, relaciones y cardinalidades correspondientes.

5. **Transformar el modelo conceptual al modelo relacional**, definiendo correctamente las claves primarias y foráneas.

6. **Normalizar el esquema hasta la Tercera Forma Normal (3FN)**, reduciendo redundancias y evitando dependencias funcionales incorrectas.

7. **Garantizar la integridad y consistencia de los datos**, estableciendo relaciones y restricciones adecuadas.

8. **Documentar las decisiones de diseño** tomadas durante las distintas etapas del desarrollo.

9. **Mantener un repositorio organizado**, que permita seguir la evolución del proyecto y consultar los diferentes entregables.

---
## <img src="https://img.shields.io/badge/05-REGLAS%20DE%20NEGOCIO-f59e0b" height="24"> Reglas de negocio principales

El funcionamiento de ComproTecno se encuentra definido mediante un conjunto de reglas de negocio.

Entre las principales se encuentran:

- **Historial e inmutabilidad de precios:** cada línea de una operación conserva el precio aplicado al momento de realizarla.
- **Control de stock:** un producto solo puede venderse o utilizarse en un servicio si existe stock suficiente.
- **Registro de clientes:** toda operación debe estar asociada a un cliente previamente registrado.
- **Métodos de pago:** toda operación que implique un cobro debe utilizar un método de pago habilitado.
- **Personal interviniente:** las operaciones deben identificar al personal responsable correspondiente.
- **Clasificación de productos:** cada producto pertenece a una única categoría y está asociado a una marca o fabricante.
- **Identificación única:** cada producto posee un identificador único.
- **Integridad de las operaciones:** las operaciones deben registrar la información necesaria para representar correctamente la transacción.
- **Registro de servicios:** cada servicio técnico debe estar asociado a un cliente y a un técnico responsable.

La definición completa de las reglas se encuentra en:

[`docs/etapa-01/reglas-negocio.md`](docs/etapa-01/reglas-negocio.md)

---
## <img src="https://img.shields.io/badge/06-DOCUMENTACIÓN-0ea5e9" height="24"> Documentación

La documentación se encuentra organizada dentro de la carpeta [`docs/`](docs/), separada de acuerdo con las etapas del proyecto.

### Etapa 01 — Requerimientos y dominio del negocio

Esta etapa comprende el análisis inicial del problema, la descripción del caso, el alcance y las reglas que definen el funcionamiento de ComproTecno.

| Documento | Descripción |
|---|---|
| [`descripcion_del_caso.md`](docs/etapa-01/descripcion_del_caso.md) | Descripción del caso, modelo de negocio, alcance, problemática y solución propuesta. |
| [`reglas-negocio.md`](docs/etapa-01/reglas-negocio.md) | Definición de las reglas de negocio que rigen el funcionamiento del sistema. |
| [`equipo5_etapa_1.docx`](docs/etapa-01/equipo5_etapa_1.docx) | Documento correspondiente a la entrega de la Etapa 01. |

### Etapa 02 — Modelado conceptual y lógico

Esta etapa comprende la representación conceptual del sistema y su transformación hacia el modelo relacional.

| Documento | Descripción |
|---|---|
| [`decisiones-diseño.md`](docs/etapa-2/decisiones-diseño.md) | Registro y justificación de las decisiones tomadas durante el diseño del modelo. |
| [`modelo-relacional.md`](docs/etapa-2/modelo-relacional.md) | Desarrollo del modelo relacional a partir del modelo conceptual. |
| [`der/`](docs/etapa-2/der/) | Recursos correspondientes al Diagrama Entidad-Relación. |
| [`rel/`](docs/etapa-2/rel/) | Recursos correspondientes al modelo relacional. |

---
## <img src="https://img.shields.io/badge/07-ESTRUCTURA%20DEL%20REPOSITORIO-64748b" height="24"> Estructura del repositorio

```text
proyecto-bd1-equipo-05/
│
├── 📁 docs/
│   │
│   ├── 📁 etapa-01/
│   │   ├── 📄 descripcion_del_caso.md
│   │   ├── 📄 equipo5_etapa_1.docx
│   │   └── 📄 reglas-negocio.md
│   │
│   └── 📁 etapa-2/
│       │
│       ├── 📁 der/
│       │   └── ...
│       │
│       ├── 📁 rel/
│       │   └── ...
│       │
│       ├── 📄 decisiones-diseño.md
│       └── 📄 modelo-relacional.md
│
└── 📄 README.md
