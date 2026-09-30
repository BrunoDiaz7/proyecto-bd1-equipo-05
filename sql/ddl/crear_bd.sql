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
