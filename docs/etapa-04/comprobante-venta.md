# Detalle y Resumen de Comprobantes (`comprobante_venta.sql`)

## Descripción General
En este documento, nosotros explicamos cómo armamos las consultas para simular el sistema de facturación de nuestro local en la base de datos `Proyecto_equipo5`. 

Nuestro objetivo acá fue recrear cómo se vería una factura real si la tuviéramos que imprimir o mostrar en una pantalla. Para que quede bien completo, dividimos el trabajo en dos partes:

1. **El cuerpo de la factura:** Donde mostramos el detalle renglón por renglón de todo lo que el cliente se está llevando.
2. **El pie o resumen de la factura:** Donde agrupamos todo para mostrar los totales, cuántas cosas compró en total, y si le hicimos algún descuento o recargo según cómo nos pagó.

---

## 1. Detalle Renglón por Renglón (Cuerpo del Comprobante)

Con esta primera consulta logramos que la base de datos nos muestre exactamente qué artículos o servicios componen cada venta. 

Un detalle técnico del que estamos muy orgullosos es que usamos una función especial llamada `ROW_NUMBER()`. Esto nos permitió crear la columna "Renglon_Nro", que numera automáticamente los ítems (1, 2, 3...) reiniciando la cuenta cada vez que pasamos a una factura nueva, tal cual como funciona en un supermercado o tienda real.

### Resultados de la Ejecución (Facturas 1001 a 1006)

| Num_Comprobante | Fecha_Emision | Metodo_Pago | DNI_Cliente | Cliente | Legajo_Vendedor | Vendedor | Renglon_Nro | Codigo | Descripcion | Categoria | cantidad | Precio_Unitario | Subtotal_Renglon |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1001 | 2026-08-10 11:30 | Tarjeta de Débito | 42333444 | Romero, Lucía | EMP-002 | Roca, Santy | 1 | PROD-012 | Placa de Video MSI RTX 3060 12GB | Tarjetas de Video | 1 | 320.00 | 320.00 |
| 1002 | 2026-08-15 14:00 | Transferencia Bancaria | 18555666 | Torres, Gonzalo | EMP-003 | Díaz, Bruno | 1 | PROD-016 | Teclado Mecánico Redragon Kumara | Periféricos | 1 | 45.00 | 45.00 |
| 1002 | 2026-08-15 14:00 | Transferencia Bancaria | 18555666 | Torres, Gonzalo | EMP-003 | Díaz, Bruno | 2 | PROD-017 | Auriculares HyperX Cloud II | Periféricos | 1 | 95.00 | 95.00 |
| 1003 | 2026-08-20 16:45 | Tarjeta de Crédito 6 Cuotas | 37777888 | Ruiz, Elena | EMP-004 | Navas, Tiziano | 1 | PROD-002 | Procesador AMD Ryzen 7 7800X3D | Procesadores | 1 | 420.00 | 420.00 |
| 1003 | 2026-08-20 16:45 | Tarjeta de Crédito 6 Cuotas | 37777888 | Ruiz, Elena | EMP-004 | Navas, Tiziano | 2 | PROD-007 | Motherboard Asus ROG Strix Z790-F | Placas Madre | 1 | 380.00 | 380.00 |
| 1003 | 2026-08-20 16:45 | Tarjeta de Crédito 6 Cuotas | 37777888 | Ruiz, Elena | EMP-004 | Navas, Tiziano | 3 | SERV-005 | Armado e Instalación de PC | Mantenimiento Hardware | 1 | 30.00 | 30.00 |
| 1004 | 2026-08-22 09:20 | Efectivo | 44999000 | Gómez, Facundo | EMP-005 | Paz, Marcos | 1 | SERV-010 | Mantenimiento de Notebook/Laptop | Mantenimiento Hardware | 1 | 40.00 | 40.00 |
| 1005 | 2026-08-25 15:10 | Tarjeta de Crédito 1 Cuota | 31222333 | Sosa, Valentina | EMP-006 | Herrera, Sofía | 1 | PROD-003 | Placa de Video Nvidia RTX 4070 | Tarjetas de Video | 1 | 650.00 | 650.00 |
| 1005 | 2026-08-25 15:10 | Tarjeta de Crédito 1 Cuota | 31222333 | Sosa, Valentina | EMP-006 | Herrera, Sofía | 2 | PROD-022 | Monitor Samsung Odyssey G5 32" | Monitores | 1 | 380.00 | 380.00 |
| 1006 | 2026-08-28 12:00 | Tarjeta de Débito | 27444555 | Fernández, Enzo | EMP-001 | Sole, Juan | 1 | PROD-014 | Disco SSD Kingston NV2 1TB | Almacenamiento | 1 | 45.00 | 45.00 |
| 1006 | 2026-08-28 12:00 | Tarjeta de Débito | 27444555 | Fernández, Enzo | EMP-001 | Sole, Juan | 2 | SERV-002 | Formateo e Instalación de SO | Soporte de Software | 1 | 25.00 | 25.00 |

---

## 2. Resumen Consolidado (Pie del Comprobante)

En esta segunda consulta, nosotros le pedimos a la base de datos que "comprima" todos esos renglones sueltos y nos devuelva una sola fila por cada comprobante. 

Acá es donde vemos la plata real. Además de contar cuántas cosas compró el cliente (separando inteligentemente los productos de los servicios), mostramos el subtotal de la compra y le aplicamos los descuentos o recargos correspondientes para llegar a la plata que el cliente efectivamente pagó.

### Resultados de la Ejecución (Facturas 1001 a 1006)

| Num_Comprobante | Fecha_Emision | DNI_Cliente | Cliente | Metodo_Pago | Cantidad_Renglones | Cantidad_Productos | Cantidad_Servicios | Subtotal_Bruto | Descuento_Recargo | Total_Facturado |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1001 | 2026-08-10 11:30 | 42333444 | Romero, Lucía | Tarjeta de Débito | 1 | 1 | 0 | 320.00 | 0.00 | 320.00 |
| 1002 | 2026-08-15 14:00 | 18555666 | Torres, Gonzalo | Transferencia Bancaria | 2 | 2 | 0 | 140.00 | -7.00 | 133.00 |
| 1003 | 2026-08-20 16:45 | 37777888 | Ruiz, Elena | Tarjeta de Crédito 6 Cuotas | 3 | 2 | 1 | 830.00 | 99.60 | 929.60 |
| 1004 | 2026-08-22 09:20 | 44999000 | Gómez, Facundo | Efectivo | 1 | 0 | 1 | 40.00 | -4.00 | 36.00 |
| 1005 | 2026-08-25 15:10 | 31222333 | Sosa, Valentina | Tarjeta de Crédito 1 Cuota | 2 | 2 | 0 | 1030.00 | 0.00 | 1030.00 |
| 1006 | 2026-08-28 12:00 | 27444555 | Fernández, Enzo | Tarjeta de Débito | 2 | 1 | 1 | 70.00 | 0.00 | 70.00 |