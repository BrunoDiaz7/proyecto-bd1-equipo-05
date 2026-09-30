CREATE DATABASE Proyecto_equipo5;
USE Proyecto_equipo5;

CREATE TABLE Persona
(
	id_persona INT IDENTITY(1,1),
	DNI INT NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	apellido VARCHAR(100)NOT NULL,
	telefono VARCHAR(30) NOT NULL,
	email VARCHAR(150) NULL,

	CONSTRAINT PK_Persona PRIMARY KEY (id_persona),
	CONSTRAINT UQ_DNI_Persona UNIQUE (DNI)
);

CREATE TABLE Cliente
(
	id_persona_cliente INT,
	fecha_alta DATE NOT NULL CONSTRAINT DF_Cliente_Alta DEFAULT GETDATE(),

	CONSTRAINT PK_Cliente PRIMARY KEY (id_persona_cliente),
	CONSTRAINT FK_Persona_Cliente FOREIGN KEY (id_persona_cliente) REFERENCES Persona (id_persona)
);



