# Proceso de Normalización del Modelo Relacional

---

## 1. Normalización

### Primera Forma Normal (1FN)
* **Objetivo:** Eliminación de grupos repetitivos y garantía de atomicidad en los atributos.
* **Aplicación:**
  * **Atomicidad:** Todos los atributos de las entidades contienen un único valor por celda e indivisible (por ejemplo, los datos personales en `Persona` como `DNI`, `nombre`, `apellido` están separados y no agrupados en cadenas compuestas).
  * **Eliminación de grupos repetitivos:** En el diseño inicial existía la tabla `Movimiento_stock` actuando como detalle ambiguo para varias entidades. Se eliminaron los campos repetitivos/multivaluados creando la entidad `Detalle_Factura`, donde cada registro representa una única línea de servicio realizado o ítem vendido.
  * **Identificación única:** Todas las tablas poseen una clave primaria (`PK`) bien definida (`id_*`) que identifica unívocamente a cada registro.

### Segunda Forma Normal (2FN)
* **Objetivo:** Eliminación de dependencias funcionales parciales en claves compuestas.
* **Aplicación:**
  * Para estar en 2FN, todo atributo no clave debe depender de la **totalidad** de la clave primaria (no de una parte de ella).
  * En tablas con claves simples (`id_persona`, `id_factura`, `id_catalogo`, etc.), la 2FN se cumple por definición, ya que no existen subconjuntos de claves primarias.
  * En la entidad de relación de detalle (`Detalle_Factura`), atributos como `cantidad` e `historico_precio_uni` dependen totalmente de la clave (`id_detalle_factura`) en combinación con el ítem facturado, garantizando que no existan atributos dependiendo parcialmente de otras entidades.

### Tercera Forma Normal (3FN)
* **Objetivo:** Eliminación de dependencias transitivas en atributos no clave.
* **Aplicación:**
  * Ningún atributo no clave debe determinar a otro atributo no clave.
  * **Desacoplamiento de `Metodo_Pago`:** En el análisis del modelo se detectó que propiedades como `descuento`, `recargo` o el estado `activo` del medio de cobro no dependen de la clave de la factura (`id_factura`), sino del tipo de medio de pago utilizado. Guardar estos datos en la cabecera de la factura generaba una dependencia transitiva. Se extrajo la entidad independiente `Metodo_Pago`, dejando en `Factura` únicamente la clave foránea `id_metodo_pago` y consolidados los importes monetarios definitivos.
  * **Desacoplamiento de `Marca` y `Categoria`:** De forma análoga, el nombre de un fabricante o de un rubro no depende de un producto en particular, sino de su propia entidad. Se mantuvieron las tablas maestras `Marca` y `Categoria` vinculadas por `FK` a `Producto` y `Catalogo` respectivamente.