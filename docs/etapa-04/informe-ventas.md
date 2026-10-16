# Informe de Ventas y Rendimiento (`informe_ventas.sql`)

## Descripción General
En este documento, detallamos lo que hicimos en el script `informe_ventas.sql`. Lo armamos para nuestra base de datos `Proyecto_equipo5` con la idea de procesar todas las ventas del mes y convertirlas en información fácil de entender para los dueños del local. 

Para lograr esto, armamos dos reportes principales:
1. **Rendimiento de los vendedores:** Para ver cómo le fue a cada empleado, cuánto facturaron en total y qué perfil de ventas tienen.


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