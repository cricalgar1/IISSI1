DELIMITER //
CREATE OR REPLACE PROCEDURE
createTables()
BEGIN
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Usuarios;
DROP TABLE IF EXISTS Personas;
DROP TABLE IF EXISTS Empresas;
DROP TABLE IF EXISTS FichaPreferencias;
DROP TABLE IF EXISTS Vinculos;
DROP TABLE IF EXISTS Conversaciones;
DROP TABLE IF EXISTS Grupos;
DROP TABLE IF EXISTS Mensajes;
DROP TABLE IF EXISTS Fotos;
DROP TABLE IF EXISTS Likes;
DROP TABLE IF EXISTS Comentarios;
DROP TABLE IF EXISTS Aficiones;
DROP TABLE IF EXISTS personasaficiones;
DROP TABLE IF EXISTS PersonasGrupos;
DROP TABLE IF EXISTS VinculosUsuarios;
DROP TABLE IF EXISTS Salas;
DROP TABLE IF EXISTS Chats;
DROP TABLE IF EXISTS FichaPreferenciaAficiones;

SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE Usuarios(
	usuarioId INT NOT NULL AUTO_INCREMENT,
	email VARCHAR(250) NOT NULL,
	PASSWORD LONGTEXT NOT NULL,
	nombre VARCHAR(60) NOT NULL,
	fechaAlta DATE NOT NULL,
	fechaBaja DATE,
	biografia VARCHAR(140) NOT NULL,
	direccion VARCHAR (150) NOT NULL, 
	seguidores INT DEFAULT(0) NOT NULL,
	numPublicacion INT DEFAULT(0) NOT NULL,
	PRIMARY KEY (usuarioId),
	UNIQUE (email),
	UNIQUE (nombre),
	CONSTRAINT RN1_03fechasInconsistentes CHECK (fechaBaja>fechaAlta)
);

CREATE TABLE Personas(
	usuarioId INT NOT NULL AUTO_INCREMENT,
	fechaNacimiento DATE NOT NULL,
	altura INT DEFAULT(170) NOT NULL,
	peso DOUBLE DEFAULT(75) NOT NULL, 
	genero VARCHAR(20) NOT NULL, 
	colorOjos VARCHAR(10) NOT NULL,
	colorPelo VARCHAR(10) DEFAULT('Negro') NOT NULL,
	PRIMARY KEY (usuarioId),
	FOREIGN KEY (usuarioId) REFERENCES Usuarios (usuarioId) ON DELETE CASCADE,
	CONSTRAINT invalidGenero CHECK (genero IN ('Masculino', 'Femenino', 'Otros')),
	CONSTRAINT invalidColorOjos CHECK (colorOjos IN ('Negro', 'Castaño', 'Azul', 'Verde', 'Gris')),
	CONSTRAINT invalidColorPelo CHECK (colorPelo IN ('Negro', 'Castaño', 'Rubio', 'Rojo', 'Blanco', 'Gris')),
	CONSTRAINT RN1_0b_PesoNegativo CHECK (peso>0),
	CONSTRAINT RN1_0b_AlturaNegativa CHECK (altura>0)
);

CREATE TABLE Empresas(
	usuarioId INT NOT NULL AUTO_INCREMENT,
	url VARCHAR (250) NOT NULL,
	tipoEmpresa VARCHAR (50) NOT NULL,
	UNIQUE (url),
	PRIMARY KEY (usuarioId),
	FOREIGN KEY (usuarioId) REFERENCES Usuarios (usuarioId) ON DELETE CASCADE,
	CONSTRAINT invalidTipoEmpresa CHECK (tipoEmpresa IN ('Salud', 'Educacion', 'Hosteleria', 'Ocio', 'Viaje', 'Comida', 'Ropa', 'Construcción', 'Transporte', 'Deporte', 'Tecnologia'))
);

CREATE TABLE FichaPreferencias(
	fichaPreferenciaId INT NOT NULL AUTO_INCREMENT,
	usuarioId INT NOT NULL,
	rangoEdad INT,
	rangoEstatura INT,
	rangoPeso INT,
	filtroGenero VARCHAR(60),
	filtroOjo VARCHAR(60),
	filtroColorPelo VARCHAR(60),
	ubicacion VARCHAR(60),
	PRIMARY KEY(fichaPreferenciaId),
	FOREIGN KEY(usuarioId) REFERENCES Usuarios(usuarioId) ON DELETE CASCADE,
	CONSTRAINT edadNegativa CHECK(rangoEdad>0),
	CONSTRAINT estaturaNegativa CHECK(rangoEstatura>0),
	CONSTRAINT pesoNegativo CHECK(rangoPeso>0),
	CONSTRAINT invalidcolorOjo CHECK (filtroOjo IN ('Negro', 'Castaño', 'Azul', 'Verde', 'Gris')),
	CONSTRAINT invalidGenero CHECK (filtroGenero IN ('Masculino', 'Femenino', 'Otros')),
	CONSTRAINT invalidColorPelo CHECK (filtroColorPelo IN ('Negro','Castaño', 'Rubio', 'Rojo', 'Blanco', 'Gris')),
	CONSTRAINT invalidUbicacion CHECK(ubicacion IN ('Codigo Postal', 'Municipio', 'Provincia'))
);

CREATE TABLE Vinculos(
	vinculoId INT NOT NULL AUTO_INCREMENT,
	activo BOOLEAN NOT NULL,
	fecha DATE NOT NULL,
	fechaAceptacion DATE,
	fechaRevocacion DATE,
	PRIMARY KEY (vinculoId),
	CONSTRAINT Rn2_01a CHECK (fecha<=fechaAceptacion),
	CONSTRAINT Rn2_01b CHECK (fechaAceptacion<=fechaRevocacion)
);


CREATE TABLE Conversaciones(
	conversacionId INT NOT NULL AUTO_INCREMENT,
	fechaInicio DATE NOT NULL,
	fechaFin DATE,
	PRIMARY KEY (conversacionId),
	CONSTRAINT RN4_01 CHECK(fechaInicio <= fechaFin)
);


CREATE TABLE Grupos(
	grupoId INT NOT NULL AUTO_INCREMENT,
	nombreGrupo VARCHAR(100) NOT NULL,
	fechaCreacion DATE NOT NULL,
	numParticipante INT NOT NULL,
	creador VARCHAR(100) NOT NULL,
	PRIMARY KEY(grupoId),
	CONSTRAINT RN4_04_masDeTresParticipantes CHECK(numParticipante > 2),
	CONSTRAINT RN4_04_menosDeOnceParticipantes CHECK(numParticipante < 11)
);

CREATE TABLE Mensajes(
	mensajeId INT NOT NULL AUTO_INCREMENT,
	conversacionId INT NOT NULL,
	texto VARCHAR (300) NOT NULL,
	fechaMensaje DATE NOT NULL,
	horaMensaje TIME NOT NULL,
	horaRecibido TIME,
	horaLeido TIME,
	PRIMARY KEY (mensajeId),
	FOREIGN KEY (conversacionId) REFERENCES Conversaciones (conversacionId) ON DELETE CASCADE
);


CREATE TABLE Fotos(
	fotoId INT NOT NULL AUTO_INCREMENT,
	usuarioId INT NOT NULL,
	urlFoto VARCHAR(250) NOT NULL,
	nombre VARCHAR(60),
	descripcion VARCHAR(250),
	numLike INT DEFAULT (0) NOT NULL,
	fechaPublicacion DATE DEFAULT (SYSDATE())NOT NULL,
	tema VARCHAR(50) NOT NULL,
	PRIMARY KEY (fotoId),
	FOREIGN KEY(usuarioId) REFERENCES Usuarios(usuarioId) ON DELETE CASCADE,
	UNIQUE (urlFoto),
	CONSTRAINT invalidTema CHECK(tema IN ('naturaleza', 'arte', 'deporte', 'comida', 'baile', 'fiesta', 'chill', 'navidad', 'lluvia', 'nieve', 'verano', 'amor', 'diversión','gaming', 'cine', 'moda', 'saludable'))
);
	
CREATE TABLE Likes(
	likeId INT NOT NULL AUTO_INCREMENT,
	fotoId INT NOT NULL,
	emisorId INT NOT NULL,
	fechaLike DATE NOT NULL,
	PRIMARY KEY(likeId),
	FOREIGN KEY (fotoId) REFERENCES Fotos(fotoId) ON DELETE CASCADE,
	FOREIGN KEY (emisorId) REFERENCES usuarios(usuarioId) ON DELETE CASCADE
);

CREATE TABLE Comentarios(
	comentarioId INT NOT NULL AUTO_INCREMENT,
	usuarioId INT NOT NULL,
	fotoId INT NOT NULL,
	texto VARCHAR(200) NOT NULL,
	fecha DATE NOT NULL,
	PRIMARY KEY(comentarioId),
	FOREIGN KEY(usuarioId) REFERENCES Usuarios(usuarioId) ON DELETE CASCADE,
	FOREIGN KEY(fotoId) REFERENCES Fotos(fotoId) ON DELETE CASCADE
);

CREATE TABLE Aficiones(
	aficionId INT NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL,
	PRIMARY KEY(aficionId),
	UNIQUE(nombre)
);


CREATE TABLE PersonasAficiones(
	personaAficionId INT NOT NULL AUTO_INCREMENT,
	usuarioId INT NOT NULL,
	aficionId INT NOT NULL,
	PRIMARY KEY(personaAficionId),
	FOREIGN KEY(usuarioId) REFERENCES Personas(usuarioId) ON DELETE CASCADE,
	FOREIGN KEY(aficionId) REFERENCES Aficiones(aficionId) ON DELETE CASCADE,
	UNIQUE(usuarioId, aficionId)
);
		
CREATE TABLE FichaPreferenciaAficiones(
	fichaPreferenciaAficionId INT NOT NULL AUTO_INCREMENT,
	fichaPreferenciaid INT NOT NULL,
	aficionId INT NOT NULL,
	PRIMARY KEY(fichaPreferenciaAficionId),
	FOREIGN KEY (fichaPreferenciaid) REFERENCES fichapreferencias(fichaPreferenciaId) ON DELETE CASCADE,
	FOREIGN KEY (aficionId) REFERENCES aficiones(aficionId) ON DELETE CASCADE,
	UNIQUE(fichaPreferenciaid, aficionId)
); 

CREATE TABLE PersonasGrupos(
	personaGrupoId INT NOT NULL AUTO_INCREMENT,
	grupoId INT NOT NULL,
	personaId INT NOT NULL,
	PRIMARY KEY(personaGrupoId),
	FOREIGN KEY(grupoId) REFERENCES Grupos(grupoId) ON DELETE CASCADE,
	FOREIGN KEY(personaId) REFERENCES Usuarios(usuarioId) ON DELETE CASCADE,
	UNIQUE (personaId, grupoId)
);

CREATE TABLE VinculosUsuarios(
	vinculoUsuarioId INT NOT NULL AUTO_INCREMENT,
	vinculoId INT NOT NULL,
	emisorId INT NOT NULL,
	receptorId INT NOT NULL,
	PRIMARY KEY (vinculoUsuarioId),
	FOREIGN KEY (vinculoId) REFERENCES Vinculos (vinculoId) ON DELETE CASCADE,
	FOREIGN KEY (emisorId) REFERENCES Usuarios (usuarioId) ON DELETE CASCADE,
	FOREIGN KEY (receptorId) REFERENCES Usuarios (usuarioId) ON DELETE CASCADE,
	UNIQUE (emisorId, receptorId),
	CONSTRAINT Rn3_02b CHECK(emisorId != receptorId)
);

CREATE TABLE Salas(
	salaId INT NOT NULL AUTO_INCREMENT,
	grupoId INT NOT NULL,
	conversacionId INT NOT NULL,
	PRIMARY KEY(salaId),
	FOREIGN KEY(grupoId) REFERENCES grupos(grupoId) ON DELETE CASCADE,
	FOREIGN KEY(conversacionId) REFERENCES conversaciones(conversacionId) ON DELETE CASCADE
);

CREATE TABLE Chats(
	chatId INT NOT NULL AUTO_INCREMENT,
	vinculoId INT NOT NULL,
	conversacionId INT NOT NULL,
	PRIMARY KEY(chatId),
	FOREIGN KEY(vinculoId) REFERENCES vinculos(vinculoId) ON DELETE CASCADE,
	FOREIGN KEY(conversacionId) REFERENCES conversaciones(conversacionId) ON DELETE CASCADE
);

END //
DELIMITER ;

CALL createTables();
