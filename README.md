<div align="center">

# 🗄️ Proyecto BD1 — Equipo 05

### Diseño y modelado de una base de datos relacional

<p>
  <img src="https://img.shields.io/badge/UNNE-Base%20de%20Datos%20I-blue" alt="UNNE">
  <img src="https://img.shields.io/badge/Etapa-02-orange" alt="Etapa 2">
  <img src="https://img.shields.io/badge/Modelo-Relacional-green" alt="Modelo Relacional">
  <img src="https://img.shields.io/badge/Estado-En%20desarrollo-yellow" alt="Estado">
</p>

</div>

---

## Objetivos generales

- Diseñar una base de datos relacional que represente correctamente el dominio seleccionado.
- Analizar y documentar los requerimientos y reglas de negocio del sistema.
- Construir el modelo conceptual y transformarlo al modelo relacional.
- Aplicar técnicas de normalización hasta alcanzar la **Tercera Forma Normal (3FN)**.
- Garantizar la integridad y consistencia de la información almacenada.
- Documentar las decisiones de diseño y los avances realizados durante las distintas etapas del proyecto.

---

## Documentación

La documentación del proyecto se encuentra organizada dentro de la carpeta `docs/`, separada por etapas de desarrollo.

### Etapa 1 - Requerimientos y dominio del negocio

En esta etapa se documentó el dominio del problema y las reglas que definen el funcionamiento del sistema.

Actualmente se incluyen:

- `descripcion_del_caso.md`
  - Contiene la descripción general del caso y del dominio seleccionado.

- `reglas-negocio.md`
  - Contiene las reglas de negocio que determinan el funcionamiento de las operaciones del sistema.

- `equipo5_etapa_1.docx`
  - Documento correspondiente a la entrega de la Etapa 1.

### Etapa 2 - Modelado conceptual y lógico

En esta etapa se comenzó con la representación formal de la información y sus relaciones.

Actualmente se incluyen:

- `decisiones-diseño.md`
  - Documenta las decisiones tomadas durante el diseño del modelo.

- `modelo-relacional.md`
  - Contiene la transformación del modelo conceptual al modelo relacional.

- `der/`
  - Contiene los archivos correspondientes al **Diagrama Entidad-Relación (DER)**.

- `rel/`
  - Contiene los archivos correspondientes al **modelo relacional**.

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
