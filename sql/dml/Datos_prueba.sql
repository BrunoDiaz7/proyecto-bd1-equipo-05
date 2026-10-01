USE Proyecto_equipo5;





-- 1. POBLADO DE TABLAS SECUNDARIAS (Categorías, Marcas y Métodos de Pago)


INSERT INTO Categoria (nombre_categoria) VALUES
('Procesadores'),
('Tarjetas de Video'),
('Memoria RAM'),
('Almacenamiento'),
('Placas Madre'),
('Fuentes de Poder'),
('Periféricos'),
('Monitores'),
('Mantenimiento Hardware'),
('Soporte de Software');

INSERT INTO Marca (nombre_marca) VALUES
('Intel'),
('AMD'),
('Nvidia'),
('Corsair'),
('Kingston'),
('Asus'),
('Samsung'),
('Logitech'),
('Gigabyte'),
('MSI');

INSERT INTO Metodo_Pago (nombre_tipo, recargo, descuento, activo) VALUES
('Efectivo', 0.00, 10.00, 1),
('Transferencia Bancaria', 0.00, 5.00, 1),
('Tarjeta de Débito', 0.00, 0.00, 1),
('Tarjeta de Crédito 1 Cuota', 0.00, 0.00, 1),
('Tarjeta de Crédito 3 Cuotas', 5.00, 0.00, 1),
('Tarjeta de Crédito 6 Cuotas', 12.00, 0.00, 1),
('Tarjeta de Crédito 12 Cuotas', 25.00, 0.00, 1),
('Mercado Pago', 2.00, 0.00, 1),
('Criptomonedas (USDT)', 0.00, 3.00, 1),
('Cheque Comercial', 5.00, 0.00, 0);


-- ============================================================================
-- 2. POBLADO DE CATÁLOGO (Padre de Producto y Servicio)
-- ============================================================================

-- Ítems del 1 al 10: PRODUCTOS | Ítems del 11 al 20: SERVICIOS
INSERT INTO Catalogo (codigo, nombre, descripcion, precio, tipo, activo, id_categoria) VALUES
-- Productos (1 a 10)
('PROD-001', 'Procesador Intel Core i7-13700K', '16 núcleos y 24 hilos hasta 5.4 GHz', 450.00, 'PRODUCTO', 1, 1),
('PROD-002', 'Procesador AMD Ryzen 7 7800X3D', '8 núcleos con tecnología 3D V-Cache', 420.00, 'PRODUCTO', 1, 1),
('PROD-003', 'Placa de Video Nvidia RTX 4070', '12GB GDDR6X DLSS 3', 650.00, 'PRODUCTO', 1, 2),
('PROD-004', 'Placa de Video AMD RX 7800 XT', '16GB GDDR6 RDNA 3', 530.00, 'PRODUCTO', 1, 2),
('PROD-005', 'Memoria RAM Corsair Vengeance 32GB', 'DDR5 6000MHz Kit 2x16GB', 130.00, 'PRODUCTO', 1, 3),
('PROD-006', 'Disco SSD Samsung 990 PRO 2TB', 'NVMe M.2 PCIe 4.0 hasta 7450 MB/s', 180.00, 'PRODUCTO', 1, 4),
('PROD-007', 'Motherboard Asus ROG Strix Z790-F', 'Socket LGA1700 ATX Wi-Fi 6E', 380.00, 'PRODUCTO', 1, 5),
('PROD-008', 'Fuente Corsair RM850x 850W', '80 Plus Gold Modular', 140.00, 'PRODUCTO', 1, 6),
('PROD-009', 'Mouse Logitech G Pro X Superlight', 'Inalámbrico sensor HERO 25K', 120.00, 'PRODUCTO', 1, 7),
('PROD-010', 'Monitor Gigabyte M27Q 27"', 'QHD 170Hz IPS 0.5ms', 300.00, 'PRODUCTO', 1, 8),

-- Servicios (11 a 20)
('SERV-001', 'Limpieza y Cambio de Pasta Térmica', 'Mantenimiento profundo de gabinete y componentes', 35.00, 'SERVICIO', 1, 9),
('SERV-002', 'Formateo e Instalación de SO', 'Instalación limpia de Windows/Linux con drivers', 25.00, 'SERVICIO', 1, 10),
('SERV-003', 'Optimización y Eliminación de Virus', 'Limpieza de malware y ajuste de rendimiento', 30.00, 'SERVICIO', 1, 10),
('SERV-004', 'Diagnóstico General de Hardware', 'Revisión completa de fallas en componentes', 15.00, 'SERVICIO', 1, 9),
('SERV-005', 'Armado e Instalación de PC', 'Ensamble completo de componentes y orden de cables', 40.00, 'SERVICIO', 1, 9),
('SERV-006', 'Mantenimiento preventivo PC Gamer', 'Limpieza profunda, calibración de fans y stress test', 50.00, 'SERVICIO', 1, 9),
('SERV-007', 'Respaldo y Migración de Datos', 'Copia de seguridad hasta 1TB entre discos', 35.00, 'SERVICIO', 1, 10),
('SERV-008', 'Instalación y Configuración de Redes', 'Configuración de router, Wi-Fi mesh y cableado', 45.00, 'SERVICIO', 1, 10),
('SERV-009', 'Actualización e Instalación de BIOS', 'Flasheo seguro de BIOS para compatibilidad CPU', 20.00, 'SERVICIO', 1, 9),
('SERV-010', 'Mantenimiento de Notebook/Laptop', 'Limpieza interna, lubricación de fan y pasta térmica', 40.00, 'SERVICIO', 1, 9);


-- ============================================================================
-- 3. POBLADO DE ESPECIALIZACIONES (Producto y Servicio)
-- ============================================================================

-- Referencian a los id_catalogo de PRODUCTO (IDs del 1 al 10)
INSERT INTO Producto (id_catalogo_producto, stock_actual, stock_minimo, id_marca) VALUES
(1, 15, 3, 1),   -- Intel Core i7 (Intel)
(2, 10, 2, 2),   -- Ryzen 7 (AMD)
(3, 8,  2, 3),   -- RTX 4070 (Nvidia)
(4, 6,  2, 2),   -- RX 7800 XT (AMD)
(5, 25, 5, 4),   -- RAM Corsair (Corsair)
(6, 30, 5, 7),   -- SSD Samsung (Samsung)
(7, 5,  1, 6),   -- Motherboard Asus (Asus)
(8, 12, 3, 4),   -- Fuente Corsair (Corsair)
(9, 20, 4, 8),   -- Mouse Logitech (Logitech)
(10, 7, 2, 9);   -- Monitor Gigabyte (Gigabyte)

-- Referencian a los id_catalogo de SERVICIO (IDs del 11 al 20)
INSERT INTO Servicio (id_categoria_servicio, dias_garantia, tiempo_estimado_horas) VALUES
(11, 30,  1.50), -- Limpieza y Pasta Térmica
(12, 15,  2.00), -- Formateo e Instalación SO
(13, 15,  1.00), -- Limpieza de Virus
(14, 7,   0.50), -- Diagnóstico General
(15, 90,  3.00), -- Armado de PC
(16, 30,  2.50), -- Mantenimiento PC Gamer
(17, 30,  2.00), -- Respaldo de Datos
(18, 60,  3.50), -- Configuración Redes
(19, 15,  0.50), -- Actualización BIOS
(20, 30,  2.00); -- Mantenimiento Notebook


-- ============================================================================
-- 4. POBLADO DE VENTAS Y FACTURACIÓN (Factura y Detalle_Factura)
-- ============================================================================
-- NOTA: Se asume la existencia predeterminada de los IDs 1 al 10 en las tablas 
-- Empleado y Cliente (referenciando a id_persona_empleado y id_persona_cliente).

INSERT INTO Factura (fecha_hora, monto_subtotal, monto_ajuste, monto_final, id_metodo_pago, id_persona_empleado, id_persona_cliente) VALUES
('2026-09-01 10:15:00', 450.00, -45.00, 405.00, 1, 1, 1), -- Pago Efectivo (-10%)
('2026-09-02 11:30:00', 650.00, 0.00,   650.00, 3, 2, 2), -- Tarjeta Débito
('2026-09-05 14:00:00', 130.00, -6.50,  123.50, 2, 1, 3), -- Transferencia (-5%)
('2026-09-10 16:45:00', 180.00, 21.60,  201.60, 6, 3, 4), -- Crédito 6 Cuotas (+12%)
('2026-09-12 09:20:00', 40.00,  -4.00,  36.00,  1, 2, 5), -- Efectivo (-10%)
('2026-09-15 15:10:00', 830.00, 0.00,   830.00, 4, 4, 6), -- Crédito 1 Cuota
('2026-09-18 12:00:00', 35.00,  0.00,   35.00,  3, 1, 7), -- Tarjeta Débito
('2026-09-20 17:30:00', 300.00, 15.00,  315.00, 5, 5, 8), -- Crédito 3 Cuotas (+5%)
('2026-09-22 11:05:00', 160.00, 3.20,   163.20, 8, 3, 9), -- Mercado Pago (+2%)
('2026-09-25 18:00:00', 530.00, -15.90, 514.10, 9, 2, 10);-- Criptomonedas (-3%)

INSERT INTO Detalle_Factura (cantidad, historico_precio_uni, id_factura, id_catalogo) VALUES
-- Factura 1: Procesador Intel
(1, 450.00, 1, 1),
-- Factura 2: RTX 4070
(1, 650.00, 2, 3),
-- Factura 3: RAM Corsair
(1, 130.00, 3, 5),
-- Factura 4: SSD Samsung 2TB
(1, 180.00, 4, 6),
-- Factura 5: Servicio de Armado de PC
(1, 40.00, 5, 15),
-- Factura 6: Intel i7 + Motherboard Asus (Venta combinada)
(1, 450.00, 6, 1),
(1, 380.00, 6, 7),
-- Factura 7: Servicio de Limpieza
(1, 35.00, 7, 11),
-- Factura 8: Monitor Gigabyte
(1, 300.00, 8, 10),
-- Factura 9: Mouse Logitech + Servicio de Formateo
(1, 120.00, 9, 9),
(1, 40.00,  9, 20),
-- Factura 10: Placa AMD RX 7800 XT
(1, 530.00, 10, 4);