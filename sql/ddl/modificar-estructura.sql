USE Proyecto_equipo5;
GO

EXEC sp_rename 'Factura.monto_ajuste', 'ajuste_historico', 'COLUMN';
GO

ALTER TABLE Factura DROP COLUMN monto_subtotal, monto_final;
ALTER TABLE Metodo_Pago ADD CONSTRAINT DF_Metodo_Pago_Descuento DEFAULT 0.00 FOR descuento;
ALTER TABLE Metodo_Pago ADD CONSTRAINT DF_Metodo_Pago_Recargo DEFAULT 0.00 FOR recargo;
ALTER TABLE Factura ADD CONSTRAINT DF_Factura_Ajuste DEFAULT 0.00 FOR ajuste_historico;

SELECT * FROM Factura