## 2. Resumen Consolidado (Pie del Comprobante)

En esta segunda consulta, nosotros le pedimos a la base de datos que "comprima" todos esos renglones sueltos y nos devuelva una sola fila por cada comprobante. 

Acá es donde vemos la plata real. Además de contar cuántas cosas compró el cliente (separando inteligentemente los productos de los servicios), mostramos el subtotal de la compra y le aplicamos los descuentos o recargos correspondientes para llegar a la plata que el cliente efectivamente pagó.

## Resultados de la Ejecución (Facturas 1001 a 1006)

| Num_Comprobante | Fecha_Emision | DNI_Cliente | Cliente | Metodo_Pago | Cantidad_Renglones | Cantidad_Productos | Cantidad_Servicios | Subtotal_Bruto ($) | Descuento_Recargo | Total_Facturado |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1001 | 2026-08-10 11:30 | 42333444 | Romero, Lucía | Tarjeta de Débito | 1 | 1 | 0 | 320.00 | 0.00 | 320.00 |
| 1002 | 2026-08-15 14:00 | 18555666 | Torres, Gonzalo | Transferencia Bancaria | 2 | 2 | 0 | 140.00 | -7.00 | 133.00 |
| 1003 | 2026-08-20 16:45 | 37777888 | Ruiz, Elena | Tarjeta de Crédito 6 Cuotas | 3 | 2 | 1 | 830.00 | 99.60 | 929.60 |
| 1004 | 2026-08-22 09:20 | 44999000 | Gómez, Facundo | Efectivo | 1 | 0 | 1 | 40.00 | -4.00 | 36.00 |
| 1005 | 2026-08-25 15:10 | 31222333 | Sosa, Valentina | Tarjeta de Crédito 1 Cuota | 2 | 2 | 0 | 1030.00 | 0.00 | 1030.00 |
| 1006 | 2026-08-28 12:00 | 27444555 | Fernández, Enzo | Tarjeta de Débito | 2 | 1 | 1 | 70.00 | 0.00 | 70.00 |
