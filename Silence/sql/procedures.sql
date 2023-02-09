-- RF-1-01 punto 2
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pBorrarUsuario(id INT)
BEGIN
	
	DECLARE tieneFotos INT;
	DECLARE tieneAficiones INT;
	DECLARE tieneFichaPreferencias INT;
	DECLARE tieneVinculos INT;
	DECLARE fechaBajaNueva DATE;
	
	SET tieneFotos = (SELECT COUNT(*) FROM fotos WHERE usuarioId = id);
	SET tieneAficiones = (SELECT COUNT(*) FROM personasaficiones WHERE usuarioId = id);
	SET tieneFichaPreferencias = (SELECT COUNT(*) FROM fichaPreferencias WHERE usuarioId = id);
	SET tieneVinculos = (SELECT COUNT(*) FROM vinculos WHERE emisorId = id OR receptorId = id);
	
	IF(tieneAficiones>0 OR tieneFotos>0 OR tieneFichaPreferencias>0 OR tieneVinculos>0) THEN
		
		SET fechaBajaNueva = SYSDATE();
		UPDATE Usuarios 
			SET fechaBaja = fechaBajaNueva 
			WHERE usuarioId = id;
	
	ELSE DELETE FROM usuarios WHERE usuarioId = id;
	END IF;
	
			
END //
DELIMITER ;

-- RF-1-02 Añadir fotos
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pAñadirFotos(emailUsuario VARCHAR (250), contraseña VARCHAR (50), nombre VARCHAR(60), url VARCHAR(250), descripcion VARCHAR(250), tema VARCHAR(50))
BEGIN
	
	DECLARE id INT;
	SET id = (SELECT usuarioId FROM usuarios WHERE email=emailUsuario AND PASSWORD = contraseña);
	
	INSERT INTO Fotos(usuarioId, urlFoto, nombre, descripcion, tema)
	VALUES (id, url, nombre, descripcion, tema);
	
END //
DELIMITER ;

-- RF-1-02 Modificar fotos
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pModificarFotos(emailUsuario VARCHAR (250), contraseña VARCHAR (50), nombreP VARCHAR(60), urlP VARCHAR(250), descripcionP VARCHAR(250), temaP VARCHAR(50))
	
BEGIN	
	DECLARE id INT;
	SET id = (SELECT usuarioId FROM usuarios WHERE email=emailUsuario AND PASSWORD = contraseña);

	UPDATE Fotos
	SET urlFoto = urlP, nombre = nombreP, descripcion = descripcionP, tema = temaP
	WHERE usuarioId = id;
	
END //
DELIMITER ;

-- RF-1-02 Eliminar fotos
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pEliminarFotos(emailUsuario VARCHAR(250), contraseña VARCHAR(50),
	nombre VARCHAR(60), url VARCHAR(250))

BEGIN 
	DECLARE id1 INT;
	DECLARE id2 INT;

	SET id1 = (SELECT usuarioId FROM usuarios WHERE email = emailUsuario AND PASSWORD = contraseña);	
	SET id2 = (SELECT fotoId FROM Fotos WHERE url = urlFoto);
	DELETE FROM Fotos WHERE usuarioId = id1 AND fotoId = id2;

END //
DELIMITER ;

-- RF-1-03 Añadir aficiones
DELIMITER //
CREATE OR REPLACE PROCEDURE
	pAñadirAficiones(nombreA VARCHAR(100))
BEGIN

	INSERT INTO Aficiones(nombre) VALUES (nombreA); 
END //
DELIMITER ;

-- RF-1-03 Modificar aficiones
DELIMITER //
CREATE OR REPLACE PROCEDURE
	pModificarAficiones(nombreA VARCHAR(100), nombreB VARCHAR(100))

BEGIN 
	DECLARE id INT;
	SET id = (SELECT aficionId FROM aficiones WHERE nombre=nombreA);
	UPDATE aficiones SET nombre = nombreB WHERE aficionId = id;

END// 
DELIMITER ;

-- RF-1-03 Eliminar
DELIMITER //
CREATE OR REPLACE PROCEDURE eliminaAficion (nombreAf VARCHAR(100), emailUsuario VARCHAR(250), contraseña VARCHAR(60))
	BEGIN
		DECLARE id1 INT;
		DECLARE id2 INT;
		SET id1 = (SELECT aficionId FROM Aficiones WHERE nombre = nombreAf);
		SET id2 = (SELECT usuarioId FROM Usuarios WHERE email = emailUsuario AND PASSWORD = contraseña);
		DELETE FROM PersonasAficiones WHERE usuarioId = id2 AND aficionId = id1;
	END //
DELIMITER ;

-- RF-1-04 Añadir
DELIMITER //
CREATE OR REPLACE PROCEDURE añadirComentario (texto VARCHAR(200), url VARCHAR(250), emailUsuario VARCHAR(250), contraseña VARCHAR(60))
	BEGIN
		DECLARE id1 INT;
		DECLARE fe DATE;
		DECLARE nomb VARCHAR(60);
		SET fe = SYSDATE();
		SET id1 = (SELECT fotoId FROM Fotos WHERE urlFoto = url);
		SET nomb = (SELECT usuarioId FROM Usuarios WHERE email = emailUsuario AND PASSWORD = contraseña);
		INSERT INTO Comentarios(usuarioId,fotoId,texto,fecha) VALUES (nomb,id1,texto,fe);
	END //
DELIMITER ;

-- RF-1-04 Modificar
DELIMITER //
CREATE OR REPLACE PROCEDURE modificarComentario (idCom INT, textoEntrada VARCHAR(200), emailUsuario VARCHAR(250), contraseña VARCHAR(60))
	BEGIN
		DECLARE id INT;
		SET id = (SELECT usuarioId FROM Usuarios WHERE email = emailUsuario AND PASSWORD = contraseña);
		UPDATE Comentarios SET texto = textoEntrada WHERE comentarioId = idCom AND usuarioId = id;
	END //
DELIMITER ;


#RF-1-01 que un usuario pueda darse de baja
DELIMITER //
CREATE OR REPLACE PROCEDURE
	pusuarioDeBaja(emailUsuario VARCHAR(250))
BEGIN
	DECLARE id INT;
	SET id = (SELECT usuarioId FROM usuarios WHERE email=emailUsuario); 
	DELETE FROM Usuarios WHERE usuarioId=Id;
END//
DELIMITER ;


#RF-1-01 que un usuario pueda modificar cualquiera de sus datos 
DELIMITER //
CREATE OR REPLACE PROCEDURE
	pmodificacionUsuario(nuevoNombre VARCHAR(60), emailUsuario VARCHAR(250),nuevaPASSWORD VARCHAR(50), nuevaBiografia VARCHAR(140),
	nuevaDireccion VARCHAR(150)) 
BEGIN 
	DECLARE id INT;
	SET id = (SELECT usuarioId FROM Usuarios WHERE email=emailUsuario); 
	
	UPDATE Usuarios
	
	SET nombre=nuevoNombre, biografia  =nuevaBiografia ,PASSWORD=nuevaPASSWORD, direccion=nuevaDireccion 
	WHERE usuarioId=Id;
	
END//
DELIMITER ;

-- RF-1-04 poder eliminar un comentario
DELIMITER //
CREATE OR REPLACE PROCEDURE eliminarComentario (comId INT, ftId INT)
	BEGIN 
		DELETE FROM Comentarios WHERE comentarioId = comId AND fotoId = ftId; 
	END//
	
DELIMITER ;


-- RF-4-02 poder eliminar el mensaje
DELIMITER //
CREATE OR REPLACE PROCEDURE eliminarMensaje (mnsjId INT, cnvId INT)
	BEGIN 
		DELETE FROM Mensajes WHERE mensajeId = mnsjId AND conversacionId = cnvId; 
	END//
	
DELIMITER ;
