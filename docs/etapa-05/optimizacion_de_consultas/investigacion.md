# Reporte de Investigación: Optimización de Consultas mediante Índices en SQL Server

## 1. Introducción y Propósito
El propósito de esta investigación es evaluar el impacto en el rendimiento y consumo de recursos al ejecutar consultas en una base de datos **SQL Server**. En entornos de producción con grandes volúmenes de datos, las búsquedas secuenciales (escaneos de tablas completas) elevan drásticamente la entrada/salida (E/S) de disco y el tiempo de CPU. 

La implementación de **índices no agrupados** y, específicamente, **índices de cobertura (con cláusula INCLUDE)**, sirve para mitigar estos problemas. Estas estructuras permiten al motor de base de datos localizar los registros requeridos de forma directa, eliminando la necesidad de leer la tabla entera y evitando operaciones secundarias costosas como los marcadores de búsqueda (*Key Lookups*).

---

## 2. Metodología y Pruebas Realizadas
Para medir de forma precisa los tiempos de respuesta y la carga de almacenamiento, se configuró el entorno con las directivas `SET STATISTICS TIME ON` y `SET STATISTICS IO ON`. Asimismo, antes de cada consulta de prueba, se ejecutaron los comandos `CHECKPOINT` y `DBCC DROPCLEANBUFFERS` con el fin de limpiar la caché de datos en memoria y forzar lecturas físicas reales.

Se diseñaron tres escenarios experimentales aplicados a tres entidades distintas de la base de datos `proyecto_equipo5`:

### Caso 1: Tabla `Factura` (Búsqueda por Rangos de Fecha)
* **Escenario 1 (Sin Índice):** Se ejecutó una consulta filtrando por un rango de fechas en la columna `fecha_hora` con los índices eliminados.
* **Escenario 2 (Índice Básico):** Se creó un índice no agrupado estándar en la columna de ordenamiento:
  ```sql
  CREATE NONCLUSTERED INDEX IX_Factura_FechaHora ON Factura (fecha_hora);
  ```
* **Escenario 3 (Índice de Cobertura):** Se reemplazó el anterior por un índice que incluye las columnas adicionales solicitadas en el `SELECT`:
  ```sql
  CREATE NONCLUSTERED INDEX IX_Factura_FechaHora_Cobertura
  ON Factura (fecha_hora) INCLUDE (monto_final, id_persona_empleado);
  ```

### Caso 2: Tabla `Catalogo` (Inserción Masiva y Filtros Compuestos)
Se poblaron de forma sintética **50,000 registros** mediante un bucle `WHILE` para simular una carga de datos real y evaluar la eficiencia del indexado.
* **Escenario 1 (Sin Índice):** Consulta con filtros exactos `id_categoria = 5 AND activo = 1`.
* **Escenario 2 (Índice Compuesto Básico):** Creación de un índice tradicional sobre ambas columnas de filtrado:
  ```sql
  CREATE NONCLUSTERED INDEX IX_Catalogo_Categoria_Activo ON Catalogo (id_categoria, activo);
  ```
* **Escenario 3 (Índice de Cobertura Completo):** Creación del índice compuesto agregando el resto de las columnas consultadas mediante `INCLUDE`:
  ```sql
  CREATE NONCLUSTERED INDEX IX_Catalogo_Categoria_Activo_Cobertura
  ON Catalogo (id_categoria, activo) INCLUDE (codigo, nombre, precio);
  ```

### Caso 3: Tabla `Persona` (Carga Masiva con CTE e Intersección de Tablas)
Se insertaron **100,000 registros** utilizando una Expresión de Tabla Común (`WITH Numeros AS...`) para realizar pruebas de rendimiento bajo un volumen de datos considerable, aplicando un filtro por el apellido `'Gomez'` en un `INNER JOIN` con la tabla `Cliente`.
* **Escenario 1 (Sin Índice):** Combinación de tablas escaneando los registros secuencialmente.
* **Escenario 2 (Índice Básico):** Creación y posterior descarte de un índice no agrupado en la columna de búsqueda (`apellido`).
* **Escenario 3 (Índice de Cobertura en JOIN):** Optimización final incluyendo campos proyectados en el `SELECT`:
  ```sql
  CREATE NONCLUSTERED INDEX IX_Persona_Apellido_Cobertura ON Persona(apellido) INCLUDE (nombre, telefono);
  ```

---

## 3. Utilidad y Conclusiones del Experimento
* **Reducción de Lecturas Lógicas y Físicas:** Al pasar del Escenario 1 al Escenario 3, las estadísticas de E/S muestran una disminución drástica en la cantidad de páginas de datos leídas.
* **Evitación del Key Lookup:** El índice básico (Escenario 2) ayuda a encontrar la fila, pero si la consulta solicita columnas que no forman parte del índice, SQL Server debe ir a buscar el resto de los datos a la tabla base. El uso de la cláusula `INCLUDE` (Escenario 3) resuelve esto almacenando esos datos directamente en las páginas hoja del índice, logrando un plan de ejecución óptimo de tipo *Index Seek*.
* **Mitigación del impacto de la fragmentación:** Mantener estrategias correctas de indexación ayuda a que el optimizador de consultas genere planes estables, consumiendo menos CPU y memoria interna.

---

## 4. Fuentes de Información
La fundamentación teórica sobre el comportamiento de los índices, el diseño de la arquitectura de árbol B (almacén de filas) y las estrategias de optimización para mitigar la fragmentación y la densidad de páginas se basa en la documentación oficial de Microsoft:

* **Microsoft Learn:** [Reorganización y reconstrucción de índices (Guía de optimización de SQL Server)](https://microsoft.com)

* **Microsoft Learn:** [Creación de índices con columnas incluidas (Explicación técnica de la cláusula INCLUDE y optimización del nivel hoja)](https://learn.microsoft.com/es-es/sql/relational-databases/indexes/create-indexes-with-included-columns?view=sql-server-ver17)
