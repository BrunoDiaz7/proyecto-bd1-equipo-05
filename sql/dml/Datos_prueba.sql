USE Proyecto_equipo5;
GO

-- ============================================================================
-- 1. POBLADO DE PERSONA
-- ============================================================================
INSERT INTO Persona (DNI, nombre, apellido, telefono, email) VALUES
-- Empleados
(35123456, 'Juan', 'Sole', '3794236833', 'juan.sole@gmail.com'),
(46345678, 'Santy', 'Roca', '3794334455', 'santy.roca@gmail.com'),
(32456789, 'Bruno', 'Díaz', '3794445566', 'bruno.diaz@gmail.com'),
(41234567, 'Tiziano', 'Navas', '3794556677', 'tiziano.navas@gmail.com'),
(28765432, 'Marcos', 'Paz', '3794112233', 'marcos.paz@gmail.com'),
(39876543, 'Sofía', 'Herrera', '3794998877', 'sofia.herrera@gmail.com'),

-- Clientes
(25111222, 'Roberto', 'Álvarez', '3794001122', 'roberto.alvarez@gmail.com'),
(42333444, 'Lucía', 'Romero', '3794221122', 'lucia.romero@gmail.com'),
(18555666, 'Gonzalo', 'Torres', '3794332233', 'gonzalo.torres@gmail.com'),
(37777888, 'Elena', 'Ruiz', '3794443344', 'elena.ruiz@gmail.com'),
(44999000, 'Facundo', 'Gómez', '3794554455', 'facundo.gomez@gmail.com'),
(31222333, 'Valentina', 'Sosa', '3794665566', 'valentina.sosa@gmail.com'),
(27444555, 'Enzo', 'Fernández', '3794776677', 'enzo.f@gmail.com'),
(46666777, 'Milagros', 'Benítez', '3794887788', 'mili.benitez@gmail.com'),
(14888999, 'Julián', 'Silva', '3794990011', 'julian.silva@gmail.com'),
(39111222, 'Camila', 'Medina', '3794112244', 'camila.medina@gmail.com'),
(22333444, 'Tomás', 'López', '3794223355', 'tomas.lopez@gmail.com'),
(45555666, 'Martina', 'García', '3794334466', 'martina.garcia@gmail.com'),
(33777888, 'Lucas', 'Martínez', '3794445577', 'lucas.m@gmail.com'),
(29999000, 'Agustina', 'Rodríguez', '3794556688', 'agus.rodriguez@gmail.com'),
(41222333, 'Joaquín', 'Pérez', '3794667799', 'joaquin.perez@gmail.com'),
(26444555, 'Victoria', 'Sánchez', '3794778800', 'vicky.sanchez@gmail.com'),
(47666777, 'Mateo', 'Ramírez', '3794889911', 'mateo.ramirez@gmail.com'),
(19888999, 'Florencia', 'Cruz', '3794991122', 'flor.cruz@gmail.com'),
(38111222, 'Nicolás', 'Iglesias', '3794002233', 'nico.iglesias@gmail.com'),
(24333444, 'Micaela', 'Ríos', '3794113344', 'mica.rios@gmail.com'),
(43555666, 'Ignacio', 'Castro', '3794224455', 'nacho.castro@gmail.com'),
(35777888, 'Julieta', 'Ortiz', '3794335566', 'julieta.ortiz@gmail.com'),
(21999000, 'Bautista', 'Luna', '3794446677', 'bauti.luna@gmail.com'),
(48222333, 'Delfina', 'Vega', '3794557788', 'delfi.vega@gmail.com');
GO

INSERT INTO Empleado (id_persona_empleado, legajo) VALUES
(1, 'EMP-001'), (2, 'EMP-002'), (3, 'EMP-003'), 
(4, 'EMP-004'), (5, 'EMP-005'), (6, 'EMP-006');
GO

INSERT INTO Cliente (id_persona_cliente, fecha_alta) VALUES
(7, '2025-11-15'), (8, '2026-01-10'), (9, '2026-02-22'), (10, '2026-03-05'),
(11, '2026-04-12'), (12, '2026-05-18'), (13, '2026-06-20'), (14, '2026-07-01'),
(15, '2026-07-15'), (16, '2026-08-05'), (17, '2026-08-10'), (18, '2026-08-20'),
(19, '2026-08-25'), (20, '2026-09-01'), (21, '2026-09-05'), (22, '2026-09-10'),
(23, '2026-09-12'), (24, '2026-09-15'), (25, '2026-09-18'), (26, '2026-09-20'),
(27, '2026-09-22'), (28, '2026-09-25'), (29, '2026-09-28'), (30, '2026-09-29');
GO


-- ============================================================================
-- 2. POBLADO DE TABLAS Categoria, Marca y Metodo_Pago
-- ============================================================================
INSERT INTO Categoria (nombre_categoria) VALUES
('Procesadores'), ('Tarjetas de Video'), ('Memoria RAM'), ('Almacenamiento'), 
('Placas Madre'), ('Fuentes de Poder'), ('Periféricos'), ('Monitores'), 
('Mantenimiento Hardware'), ('Soporte de Software'), ('Gabinetes'), 
('Refrigeración'), ('Sillas Gamer'), ('Conectividad y Redes');

INSERT INTO Marca (nombre_marca) VALUES
('Intel'), ('AMD'), ('Nvidia'), ('Corsair'), ('Kingston'), 
('Asus'), ('Samsung'), ('Logitech'), ('Gigabyte'), ('MSI'),
('Redragon'), ('HyperX'), ('Cooler Master'), ('NZXT'), ('TP-Link');

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
-- 3. POBLADO DE CATALOGO
-- ============================================================================

-- PRODUCTOS
INSERT INTO Catalogo (codigo, nombre, descripcion, precio, tipo, activo, id_categoria) VALUES
('PROD-001', 'Procesador Intel Core i7-13700K', '16 núcleos y 24 hilos hasta 5.4 GHz', 450.00, 'PRODUCTO', 1, 1),
('PROD-002', 'Procesador AMD Ryzen 7 7800X3D', '8 núcleos con tecnología 3D V-Cache', 420.00, 'PRODUCTO', 1, 1),
('PROD-003', 'Placa de Video Nvidia RTX 4070', '12GB GDDR6X DLSS 3', 650.00, 'PRODUCTO', 1, 2),
('PROD-004', 'Placa de Video AMD RX 7800 XT', '16GB GDDR6 RDNA 3', 530.00, 'PRODUCTO', 1, 2),
('PROD-005', 'Memoria RAM Corsair Vengeance 32GB', 'DDR5 6000MHz Kit 2x16GB', 130.00, 'PRODUCTO', 1, 3),
('PROD-006', 'Disco SSD Samsung 990 PRO 2TB', 'NVMe M.2 PCIe 4.0', 180.00, 'PRODUCTO', 1, 4),
('PROD-007', 'Motherboard Asus ROG Strix Z790-F', 'Socket LGA1700 ATX Wi-Fi 6E', 380.00, 'PRODUCTO', 1, 5),
('PROD-008', 'Fuente Corsair RM850x 850W', '80 Plus Gold Modular', 140.00, 'PRODUCTO', 1, 6),
('PROD-009', 'Mouse Logitech G Pro X Superlight', 'Inalámbrico sensor HERO 25K', 120.00, 'PRODUCTO', 1, 7),
('PROD-010', 'Monitor Gigabyte M27Q 27"', 'QHD 170Hz IPS 0.5ms', 300.00, 'PRODUCTO', 1, 8),
('PROD-011', 'Procesador AMD Ryzen 5 5600G', '6 núcleos con gráficos integrados', 150.00, 'PRODUCTO', 1, 1),
('PROD-012', 'Placa de Video MSI RTX 3060 12GB', 'Ideal para 1080p Ultra', 320.00, 'PRODUCTO', 1, 2),
('PROD-013', 'Memoria RAM Kingston Fury 16GB', 'DDR4 3200MHz RGB', 55.00, 'PRODUCTO', 1, 3),
('PROD-014', 'Disco SSD Kingston NV2 1TB', 'NVMe M.2 PCIe 4.0 Entry', 65.00, 'PRODUCTO', 1, 4),
('PROD-015', 'Motherboard Gigabyte B550M DS3H', 'Socket AM4 Micro-ATX', 110.00, 'PRODUCTO', 1, 5),
('PROD-016', 'Teclado Mecánico Redragon Kumara K552', 'Switches Outemu Red TKL', 45.00, 'PRODUCTO', 1, 7),
('PROD-017', 'Auriculares HyperX Cloud II', 'Sonido envolvente 7.1', 95.00, 'PRODUCTO', 1, 7),
('PROD-018', 'Gabinete NZXT H510 Flow', 'Mid Tower ATX Cristal Templado', 105.00, 'PRODUCTO', 1, 11),
('PROD-019', 'Watercooler Cooler Master ML240L V2', 'Refrigeración líquida 240mm RGB', 85.00, 'PRODUCTO', 1, 12),
('PROD-020', 'Silla Gamer Corsair T3 Rush', 'Tela transpirable y cojines viscoelásticos', 320.00, 'PRODUCTO', 1, 13),
('PROD-021', 'Router TP-Link Archer AX73', 'Wi-Fi 6 Doble Banda Gigabit', 140.00, 'PRODUCTO', 1, 14),
('PROD-022', 'Monitor Samsung Odyssey G5 32"', 'Curvo 1440p 144Hz', 360.00, 'PRODUCTO', 1, 8),
('PROD-023', 'Fuente Gigabyte P650B 650W', '80 Plus Bronze', 70.00, 'PRODUCTO', 1, 6),
('PROD-024', 'Pasta Térmica Arctic MX-4', 'Jeringa de 4 gramos', 12.00, 'PRODUCTO', 1, 12),
('PROD-025', 'Mousepad Redragon Suzaku', 'Extendido 800x300mm', 20.00, 'PRODUCTO', 1, 7),

-- SERVICIOS 
('SERV-001', 'Limpieza y Cambio de Pasta Térmica', 'Mantenimiento profundo de gabinete', 35.00, 'SERVICIO', 1, 9),
('SERV-002', 'Formateo e Instalación de SO', 'Instalación limpia de Windows/Linux', 25.00, 'SERVICIO', 1, 10),
('SERV-003', 'Optimización y Eliminación de Virus', 'Limpieza de malware y registro', 30.00, 'SERVICIO', 1, 10),
('SERV-004', 'Diagnóstico General de Hardware', 'Revisión completa de fallas', 15.00, 'SERVICIO', 1, 9),
('SERV-005', 'Armado e Instalación de PC', 'Ensamble completo y gestión de cables', 40.00, 'SERVICIO', 1, 9),
('SERV-006', 'Mantenimiento preventivo PC Gamer', 'Limpieza profunda y stress test', 50.00, 'SERVICIO', 1, 9),
('SERV-007', 'Respaldo y Migración de Datos', 'Copia de seguridad hasta 1TB', 35.00, 'SERVICIO', 1, 10),
('SERV-008', 'Instalación y Configuración de Redes', 'Configuración de router y Wi-Fi', 45.00, 'SERVICIO', 1, 14),
('SERV-009', 'Actualización e Instalación de BIOS', 'Flasheo seguro de BIOS', 20.00, 'SERVICIO', 1, 9),
('SERV-010', 'Mantenimiento de Notebook/Laptop', 'Limpieza interna y lubricación', 40.00, 'SERVICIO', 1, 9),
('SERV-011', 'Cable Management Premium', 'Organización profesional de cableado', 25.00, 'SERVICIO', 1, 9),
('SERV-012', 'Undervolting y Overclocking', 'Ajuste de frecuencias de CPU/GPU', 35.00, 'SERVICIO', 1, 10),
('SERV-013', 'Instalación de Refrigeración Líquida', 'Montaje y purgado de sistemas AIO', 30.00, 'SERVICIO', 1, 9),
('SERV-014', 'Recuperación de Datos de Discos Dañados', 'Escaneo profundo de particiones', 80.00, 'SERVICIO', 1, 10),
('SERV-015', 'Configuración de Servidor NAS', 'Puesta a punto de almacenamiento en red', 60.00, 'SERVICIO', 1, 14);


-- ============================================================================
-- 4. POBLADO DE PRODUCTOS Y SERVICIOS
-- ============================================================================
INSERT INTO Producto (id_catalogo_producto, stock_actual, stock_minimo, id_marca) VALUES
(1, 15, 3, 1), (2, 10, 2, 2), (3, 8, 2, 3), (4, 6, 2, 2), (5, 25, 5, 4), 
(6, 30, 5, 7), (7, 5, 1, 6), (8, 12, 3, 4), (9, 20, 4, 8), (10, 7, 2, 9),
(11, 40, 5, 2), (12, 12, 2, 10), (13, 50, 10, 5), (14, 45, 10, 5), (15, 20, 4, 9),
(16, 35, 5, 11), (17, 18, 4, 12), (18, 10, 2, 14), (19, 15, 3, 13), (20, 5, 1, 4),
(21, 14, 3, 15), (22, 6, 2, 7), (23, 22, 4, 9), (24, 100, 15, 13), (25, 60, 10, 11);

INSERT INTO Servicio (id_categoria_servicio, dias_garantia, tiempo_estimado_horas) VALUES
(26, 30, 1.50), (27, 15, 2.00), (28, 15, 1.00), (29, 7, 0.50), (30, 90, 3.00), 
(31, 30, 2.50), (32, 30, 2.00), (33, 60, 3.50), (34, 15, 0.50), (35, 30, 2.00),
(36, 15, 1.50), (37, 15, 2.00), (38, 60, 1.50), (39, 30, 4.00), (40, 60, 3.00);


-- ============================================================================
-- 5. POBLADO DE VENTAS Y FACTURACIÓN
-- ============================================================================
INSERT INTO Factura (fecha_hora, monto_subtotal, monto_ajuste, monto_final, id_metodo_pago, id_persona_empleado, id_persona_cliente) VALUES
('2026-08-05 10:15:00', 450.00, -45.00, 405.00, 1, 1, 7),   -- F1: Efectivo (-10%)
('2026-08-10 11:30:00', 320.00, 0.00,   320.00, 3, 2, 8),   -- F2: Débito
('2026-08-15 14:00:00', 140.00, -7.00,  133.00, 2, 3, 9),   -- F3: Transferencia (-5%)
('2026-08-20 16:45:00', 830.00, 99.60,  929.60, 6, 4, 10),  -- F4: Crédito 6 Cuotas (+12%)
('2026-08-22 09:20:00', 40.00,  -4.00,  36.00,  1, 5, 11),  -- F5: Efectivo (-10%)
('2026-08-25 15:10:00', 1030.00,0.00,   1030.00,4, 6, 12),  -- F6: Crédito 1 Cuota
('2026-08-28 12:00:00', 70.00,  0.00,   70.00,  3, 1, 13),  -- F7: Débito
('2026-09-02 17:30:00', 360.00, 18.00,  378.00, 5, 2, 14),  -- F8: Crédito 3 Cuotas (+5%)
('2026-09-05 11:05:00', 185.00, 3.70,   188.70, 8, 3, 15),  -- F9: Mercado Pago (+2%)
('2026-09-08 18:00:00', 530.00, -15.90, 514.10, 9, 4, 16),  -- F10: Criptomonedas (-3%)
('2026-09-10 10:30:00', 150.00, -15.00, 135.00, 1, 5, 17),  -- F11: Efectivo (-10%)
('2026-09-12 14:20:00', 110.00, -5.50,  104.50, 2, 6, 18),  -- F12: Transferencia (-5%)
('2026-09-15 09:15:00', 1600.00,400.00, 2000.00,7, 1, 19),  -- F13: Crédito 12 Cuotas (+25%) PC Completa
('2026-09-16 11:45:00', 60.00,  0.00,   60.00,  3, 2, 20),  -- F14: Débito
('2026-09-18 16:10:00', 120.00, 6.00,   126.00, 5, 3, 21),  -- F15: Crédito 3 Cuotas (+5%)
('2026-09-20 13:00:00', 95.00,  -9.50,  85.50,  1, 4, 22),  -- F16: Efectivo (-10%)
('2026-09-22 17:20:00', 320.00, 6.40,   326.40, 8, 5, 23),  -- F17: Mercado Pago (+2%)
('2026-09-24 10:05:00', 25.00,  -2.50,  22.50,  1, 6, 24),  -- F18: Efectivo (-10%)
('2026-09-25 15:40:00', 85.00,  0.00,   85.00,  3, 1, 25),  -- F19: Débito
('2026-09-26 12:15:00', 105.00, -5.25,  99.75,  2, 2, 26),  -- F20: Transferencia (-5%)
('2026-09-28 11:30:00', 450.00, 0.00,   450.00, 4, 3, 27),  -- F21: Crédito 1 Cuota
('2026-09-29 16:50:00', 75.00,  -7.50,  67.50,  1, 4, 28),  -- F22: Efectivo (-10%)
('2026-09-30 09:40:00', 360.00, 43.20,  403.20, 6, 5, 29),  -- F23: Crédito 6 Cuotas (+12%)
('2026-10-02 14:10:00', 65.00,  1.30,   66.30,  8, 6, 30),  -- F24: Mercado Pago (+2%)
('2026-10-05 18:20:00', 420.00, -12.60, 407.40, 9, 1, 7);   -- F25: Criptomonedas (-3%)


INSERT INTO Detalle_Factura (cantidad, historico_precio_uni, id_factura, id_catalogo) VALUES
-- F1 (ID 1000): Procesador Intel i7
(1, 450.00, 1000, 1),
-- F2 (ID 1001): Placa MSI RTX 3060
(1, 320.00, 1001, 12),
-- F3 (ID 1002): Teclado Redragon + Auricular HyperX
(1, 45.00, 1002, 16),
(1, 95.00, 1002, 17),
-- F4 (ID 1003): Ryzen 7800X3D + Motherboard Asus Z790 + Armado
(1, 420.00, 1003, 2),
(1, 380.00, 1003, 7),
(1, 30.00, 1003, 30),
-- F5 (ID 1004): Servicio Mantenimiento Notebook
(1, 40.00, 1004, 35),
-- F6 (ID 1005): RTX 4070 + Monitor Samsung 32"
(1, 650.00, 1005, 3),
(1, 380.00, 1005, 22),
-- F7 (ID 1006): SSD Kingston 1TB + Instalación SO
(1, 45.00, 1006, 14),
(1, 25.00, 1006, 27),
-- F8 (ID 1007): Silla Gamer Corsair
(1, 360.00, 1007, 20),
-- F9 (ID 1008): Teclado Redragon + Router TP-Link
(1, 45.00, 1008, 16),
(1, 140.00, 1008, 21),
-- F10 (ID 1009): RX 7800 XT
(1, 530.00, 1009, 4),
-- F11 (ID 1010): Ryzen 5 5600G
(1, 150.00, 1010, 11),
-- F12 (ID 1011): Motherboard Gigabyte B550M
(1, 110.00, 1011, 15),
-- F13 (ID 1012): PC Completa 
(1, 450.00, 1012, 1),
(1, 380.00, 1012, 7),
(2, 130.00, 1012, 5),
(1, 180.00, 1012, 6),
(1, 140.00, 1012, 8),
(1, 105.00, 1012, 18),
(1, 85.00, 1012, 19),
(1, 40.00, 1012, 30),
-- F14 (ID 1013): Limpieza de Virus + Respaldo de Datos
(1, 30.00, 1013, 28),
(1, 30.00, 1013, 32),
-- F15 (ID 1014): Mouse Logitech G Pro
(1, 120.00, 1014, 9),
-- F16 (ID 1015): Auriculares HyperX Cloud II
(1, 95.00, 1015, 17),
-- F17 (ID 1016): Placa MSI RTX 3060
(1, 320.00, 1016, 12),
-- F18 (ID 1017): Formateo e Instalación SO
(1, 25.00, 1017, 27),
-- F19 (ID 1018): Watercooler Cooler Master
(1, 85.00, 1018, 19),
-- F20 (ID 1019): Gabinete NZXT H510
(1, 105.00, 1019, 18),
-- F21 (ID 1020): Procesador Intel i7
(1, 450.00, 1020, 1),
-- F22 (ID 1021): RAM Kingston 16GB + Mousepad
(1, 55.00, 1021, 13),
(1, 20.00, 1021, 25),
-- F23 (ID 1022): Monitor Samsung 32"
(1, 360.00, 1022, 22),
-- F24 (ID 1023): SSD Kingston 1TB
(1, 65.00, 1023, 14),
-- F25 (ID 1024): Ryzen 7 7800X3D
(1, 420.00, 1024, 2);