# Informe de Ventas y Rendimiento (`informe_ventas.sql`)

## Descripción General
En este documento, detallamos lo que hicimos en el script `informe_ventas.sql`. Lo armamos para nuestra base de datos `Proyecto_equipo5` con la idea de procesar todas las ventas del mes y convertirlas en información fácil de entender para los dueños del local. 

Para lograr esto, armamos dos reportes principales:
1. **Rendimiento de los vendedores:** Para ver cómo le fue a cada empleado, cuánto facturaron en total y qué perfil de ventas tienen.
2. **Estadísticas de nuestros productos y servicios:** Para entender qué categorías dejan más ganancias, qué se vende más y a qué precios.


---

## 1. Análisis de Desempeño de Vendedores

Con esta consulta decidimos evaluar cómo trabajó cada vendedor de nuestro equipo. Para que los números nos den exactos y la plata total no se sume dos veces por error, armamos una subconsulta que cuenta los productos y servicios de cada factura por separado antes de sumar la plata real que entró. 

Además, le agregamos una función automática que clasifica a cada empleado en 'Rendimiento Alto', 'Esperado' o 'Básico' dependiendo de si lograron superar nuestras metas de $800 o $300 en el mes.

### Resultados de la Ejecución

| Legajo | DNI_Vendedor | Vendedor | Cantidad_Facturas | Cantidad_Productos | Cantidad_Servicios | Total_Recaudado | Promedio_Recaudado_Por_Factura | Categoria_Desempeno |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| EMP-001 | 35123456 | Sole, Juan | 2 | 9 | 1 | 2085.00 | 1042.50 | Rendimiento Alto |
| EMP-003 | 32456789 | Díaz, Bruno | 3 | 4 | 0 | 764.70 | 254.90 | Rendimiento Esperado |
| EMP-004 | 41234567 | Navas, Tiziano | 3 | 4 | 0 | 667.10 | 222.37 | Rendimiento Esperado |
| EMP-002 | 46345678 | Roca, Santy | 3 | 2 | 2 | 537.75 | 179.25 | Rendimiento Esperado |
| EMP-005 | 28765432 | Paz, Marcos | 2 | 2 | 0 | 461.40 | 230.70 | Rendimiento Esperado |
| EMP-006 | 39876543 | Herrera, Sofía | 2 | 1 | 1 | 127.00 | 63.50 | Rendimiento Básico |


---


## 2. Estadísticas Comerciales por Categoría

Con este segundo reporte quisimos tener una visión completa de todo lo que ofrece nuestro catálogo. Para que sea mucho más fácil de leer, agrupamos y separamos las ventas físicas (como teclados o placas) de los servicios técnicos (como arreglar una PC). 

Lo más importante que logramos acá es mostrar los precios mínimos, máximos y el promedio. De esta forma, podemos ver rápidamente si nuestros clientes están buscando cosas baratas o si están dispuestos a pagar por productos más caros.

### Resultados de la Ejecución

| Tipo_Articulo | Categoria | Facturas_Emitidas | Cantidad_Facturada | Precio_Minimo_Vendido | Precio_Maximo_Vendido | Precio_Promedio | Total_Recaudado |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| PRODUCTO | Periféricos | 4 | 4 | 20.00 | 120.00 | 70.00 | 280.00 |
| PRODUCTO | Memoria RAM | 2 | 3 | 55.00 | 130.00 | 92.50 | 315.00 |
| PRODUCTO | Procesadores | 3 | 3 | 150.00 | 450.00 | 350.00 | 1050.00 |
| PRODUCTO | Refrigeración | 2 | 2 | 85.00 | 85.00 | 85.00 | 170.00 |
| PRODUCTO | Gabinetes | 2 | 2 | 105.00 | 105.00 | 105.00 | 210.00 |
| PRODUCTO | Tarjetas de Video | 2 | 2 | 320.00 | 530.00 | 425.00 | 850.00 |
| PRODUCTO | Placas Madre | 2 | 2 | 110.00 | 380.00 | 245.00 | 490.00 |
| PRODUCTO | Almacenamiento | 1 | 1 | 180.00 | 180.00 | 180.00 | 180.00 |
| PRODUCTO | Conectividad y Redes | 1 | 1 | 140.00 | 140.00 | 140.00 | 140.00 |
| PRODUCTO | Fuentes de Poder | 1 | 1 | 140.00 | 140.00 | 140.00 | 140.00 |
| PRODUCTO | Sillas Gamer | 1 | 1 | 360.00 | 360.00 | 360.00 | 360.00 |
| SERVICIO | Soporte de Software | 2 | 3 | 25.00 | 30.00 | 28.33 | 85.00 |
| SERVICIO | Mantenimiento Hardware | 1 | 1 | 40.00 | 40.00 | 40.00 | 40.00 |

---