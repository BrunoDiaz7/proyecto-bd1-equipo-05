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

CREATE TABLE Empleado
(
	id_persona_empleado INT,
	legajo VARCHAR(20) NOT NULL,

	CONSTRAINT PK_Empleado PRIMARY KEY (id_persona_empleado),
	CONSTRAINT UQ_Empleado_Legajo UNIQUE (legajo),
	CONSTRAINT FK_Persona_Empleado FOREIGN KEY (id_persona_empleado) REFERENCES Persona (id_persona)
);

CREATE TABLE Categoria
(
	id_categoria INT IDENTITY(1,1),
	nombre_categoria VARCHAR(100) NOT NULL,

	CONSTRAINT PK_Categoria PRIMARY KEY (id_categoria),
	CONSTRAINT UQ_Nombre_Categoria UNIQUE (nombre_categoria)
);

CREATE TABLE Catalogo
(
	id_catalogo INT IDENTITY(1,1),
	codigo VARCHAR(50) NOT NULL,
	nombre VARCHAR(150) NOT NULL,
	descripcion VARCHAR(250)NOT NULL,
	precio DECIMAL(12,2) NOT NULL,
	tipo VARCHAR(20)NOT NULL,
	activo BIT NOT NULL CONSTRAINT DF_Catalogo_Activo DEFAULT 1,
	id_categoria INT NOT NULL,
	

	CONSTRAINT PK_Catalogo PRIMARY KEY (id_catalogo),
	CONSTRAINT FK_Catalogo_Categoria FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria),
	CONSTRAINT UQ_Codigo_Catalogo UNIQUE (codigo),
	CONSTRAINT CHK_Catalogo_Tipo CHECK (tipo IN ('PRODUCTO', 'SERVICIO'))
);