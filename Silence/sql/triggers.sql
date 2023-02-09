DELIMITER //
CREATE OR REPLACE TRIGGER 
RN02_02_trigger
AFTER INSERT ON VinculosUsuarios FOR EACH ROW
BEGIN

DECLARE numEmisor INT;
SET numEmisor = (SELECT COUNT(1) FROM VinculosUsuarios
NATURAL JOIN Vinculos WHERE emisorId = NEW.emisorId GROUP BY fecha ORDER  BY numEmisor ASC LIMIT 1); 

IF(numEmisor>1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo puede solicitar hasta 5 vínculos por día natural';
END IF;

END //
DELIMITER ;


-- Sólo un vínculo activo por cada par de usuarios
DELIMITER //
CREATE OR REPLACE TRIGGER 
RN02_04_trigger
AFTER INSERT ON VinculosUsuarios FOR EACH ROW
BEGIN 
	
	DECLARE numVinculos INT;
	SET numVinculos = (SELECT COUNT(*) FROM VinculosUsuarios
NATURAL JOIN Vinculos WHERE emisorId = NEW.receptorId AND receptorId = NEW.emisorId);
	
	IF(numVinculos>0) THEN 		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Solo puede haber un vínculo activo por cada par de usuarios';
	END IF;

END //
DELIMITER ;

-- Actualizar likes de las fotos al insertar like
DELIMITER //
CREATE OR REPLACE TRIGGER
	tActualizaLikesInsert
AFTER INSERT ON likes FOR EACH ROW
BEGIN
	DECLARE numLikes INT;
	SET numLikes = (SELECT COUNT(*) FROM likes WHERE fotoId = NEW.fotoId);
	UPDATE fotos SET numLike = numLikes WHERE fotoId = new.fotoId;
	
END //
DELIMITER ;

-- Actualizar likes de las fotos al udpate like
DELIMITER //
CREATE OR REPLACE TRIGGER
	tActualizaLikesUpdate
AFTER UPDATE ON likes FOR EACH ROW
BEGIN
	DECLARE numLikes1 INT;
	DECLARE numLikes2 INT;
	SET numLikes1 = (SELECT COUNT(*) FROM likes WHERE fotoId = old.fotoId);
	SET numLikes2 = (SELECT COUNT(*) FROM likes WHERE fotoId = new.fotoId);
	
	UPDATE fotos SET numLike = numLikes1 WHERE fotoId = old.fotoId;
	UPDATE fotos SET numLike = numLikes2 WHERE fotoId = new.fotoId;
	
END //
DELIMITER ;

-- Actualizar likes de las fotos al delete like
DELIMITER //
CREATE OR REPLACE TRIGGER
	tActualizaLikesDelete
AFTER DELETE ON likes FOR EACH ROW
BEGIN
	DECLARE numLikes INT;
	SET numLikes = (SELECT COUNT(*) FROM likes WHERE fotoId = old.fotoId);
	UPDATE fotos SET numLike = numLikes WHERE fotoId = old.fotoId;
	
END //
DELIMITER ;

-- Actualizar seguidores al insertar fila en vinculosUsuarios
DELIMITER //
CREATE OR REPLACE TRIGGER 
	tActualizarNumSeguidoresInsert
AFTER INSERT ON vinculosUsuarios FOR EACH ROW
BEGIN
	
	DECLARE numVinculosEmisor INT;
	DECLARE numVinculosReceptor INT;
	DECLARE estaActivo BOOLEAN;
	
	SET estaActivo = (SELECT activo FROM vinculos WHERE vinculoId = NEW.vinculoId);
	
	if(estaActivo=1) THEN
		SET numVinculosEmisor = (SELECT COUNT(*) 
				FROM vinculosUsuarios NATURAL JOIN vinculos
				WHERE (emisorId = NEW.emisorId OR receptorId = NEW.emisorId) AND activo=1);
				
		SET numVinculosReceptor = (SELECT COUNT(*) 
				FROM vinculosUsuarios NATURAL JOIN vinculos
				WHERE (emisorId = NEW.receptorId OR receptorId = NEW.receptorId) AND activo=1);
		
		UPDATE usuarios SET seguidores = numVinculosEmisor WHERE usuarioId = NEW.emisorId;
		UPDATE usuarios SET seguidores = numVinculosReceptor WHERE usuarioId = NEW.receptorId;
		
	END IF;

END //
DELIMITER ;

-- Actualizar seguidores al borrar fila en vinculosUsuarios
DELIMITER //
CREATE OR REPLACE TRIGGER 
	tActualizarNumSeguidoresDelete
AFTER DELETE ON vinculosUsuarios FOR EACH ROW
BEGIN
	
	DECLARE numVinculosEmisor INT;
	DECLARE numVinculosReceptor INT;
	
	SET numVinculosEmisor = (SELECT COUNT(*) 
			FROM vinculosUsuarios
			WHERE emisorId = old.emisorId OR receptorId = old.emisorId);
				
	SET numVinculosReceptor = (SELECT COUNT(*) 
			FROM vinculosUsuarios
			WHERE emisorId = old.receptorId OR receptorId = old.receptorId);
		
	UPDATE usuarios SET seguidores = numVinculosEmisor WHERE usuarioId = old.emisorId;
	UPDATE usuarios SET seguidores = numVinculosReceptor WHERE usuarioId = old.receptorId;

END //
DELIMITER ;

-- Actualizar seguidores al actualizar fila en vinculosUsuarios
DELIMITER //
CREATE OR REPLACE TRIGGER 
	tActualizarNumSeguidoresUpdate1
AFTER UPDATE ON vinculosUsuarios FOR EACH ROW
BEGIN
	
	DECLARE numVinculosEmisor INT;
	DECLARE numVinculosReceptor INT;
	
	SET numVinculosEmisor = (SELECT COUNT(*) FROM vinculosUsuarios
		WHERE emisorId = NEW.emisorId OR receptorId = NEW.emisorId);
				
	SET numVinculosReceptor = (SELECT COUNT(*) 
			FROM vinculosUsuarios
			WHERE emisorId = NEW.receptorId OR receptorId = NEW.receptorId);
		
	UPDATE usuarios SET seguidores = numVinculosEmisor WHERE usuarioId = NEW.emisorId;
	UPDATE usuarios SET seguidores = numVinculosReceptor WHERE usuarioId = NEW.receptorId;

END //
DELIMITER ;


-- Actualizar seguidores al actualizar una fila en vinculos
DELIMITER //
CREATE OR REPLACE TRIGGER 
	tActualizarNumSeguidoresUpdate2
AFTER UPDATE ON vinculos FOR EACH ROW
BEGIN
	
	DECLARE numVinculosEmisor INT;
	DECLARE numVinculosReceptor INT;		
	DECLARE emisorIdVinculoMod INT;
	DECLARE receptorIdVinculoMod INT;
	
	if(OLD.activo != NEW.activo) THEN
	
		SET emisorIdVinculoMod = (SELECT emisorId FROM vinculosusuarios WHERE vinculoId = NEW.vinculoId);
		SET receptorIdVinculoMod = (SELECT receptorId FROM vinculosusuarios WHERE vinculoId = NEW.vinculoId);
	
		SET numVinculosEmisor = (SELECT COUNT(*) 
				FROM vinculosusuarios
				WHERE (emisorId = emisorIdVinculoMod OR receptorId = emisorIdVinculoMod) AND vinculoId!=NEW.vinculoId);
					
		SET numVinculosReceptor = (SELECT COUNT(*) 
				FROM vinculosusuarios
				WHERE (emisorId = receptorIdVinculoMod OR receptorId = receptorIdVinculoMod) AND vinculoId!=NEW.vinculoId);
			
		UPDATE usuarios SET seguidores = numVinculosEmisor WHERE usuarioId = emisorIdVinculoMod;
		UPDATE usuarios SET seguidores = numVinculosReceptor WHERE usuarioId = receptorIdVinculoMod;
		
	END IF;

END //
DELIMITER ;

-- Actualizar número de publicaciones al insertar una foto
DELIMITER //
CREATE OR REPLACE TRIGGER
	tActualizarNumPublicacionInsert
AFTER INSERT ON fotos FOR EACH ROW
BEGIN

	DECLARE numFotos INT;
	SET numFotos = (SELECT COUNT(*) FROM fotos WHERE usuarioId = NEW.usuarioId);
	
	UPDATE usuarios SET numPublicacion = numFotos WHERE usuarioId = NEW.usuarioId;

END //
DELIMITER ;

-- Actualizar número de publicaciones al borrar una foto
DELIMITER //
CREATE OR REPLACE TRIGGER
	tActualizarNumPublicacionDelete
AFTER DELETE ON fotos FOR EACH ROW
BEGIN

	DECLARE numFotos INT;
	SET numFotos = (SELECT COUNT(*) FROM fotos WHERE usuarioId = old.usuarioId);
	
	UPDATE usuarios SET numPublicacion = numFotos WHERE usuarioId = old.usuarioId;

END //
DELIMITER ;

-- Actualizar número de publicaciones al actualizar una foto
DELIMITER //
CREATE OR REPLACE TRIGGER
	tActualizarNumPublicacionUpdate
AFTER UPDATE ON fotos FOR EACH ROW
BEGIN
	
	if(OLD.usuarioId != NEW.usuarioId) THEN
	
		UPDATE usuarios SET numPublicacion = numPublicacion-1 WHERE usuarioId = old.usuarioId;
		UPDATE usuarios SET numPublicacion = numPublicacion+1 WHERE usuarioId = new.usuarioId;
	
	END IF;
	
END //
DELIMITER ;

-- No se puede repetir vinculoId en la tabla vinculosUsuarios
DELIMITER //
CREATE OR REPLACE TRIGGER
	tNoVinculoIdRepetidoInsert
BEFORE INSERT ON vinculosusuarios FOR EACH ROW
BEGIN
	
	DECLARE cuentaVinculoId INT;
	
	SET cuentaVinculoId = (SELECT COUNT(*) FROM vinculosusuarios WHERE vinculoId = NEW.vinculoId);
	
	IF (cuentaVinculoId >= 1) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'No se puede insertar un vínculo cuyo vinculoId esté repetido';
	END IF;

END //
DELIMITER ;

-- No se puede repetir vinculoId en la tabla vinculosUsuarios
DELIMITER //
CREATE OR REPLACE TRIGGER
	tNoVinculoIdRepetidoUpdate
BEFORE UPDATE ON vinculosusuarios FOR EACH ROW
BEGIN
	
	DECLARE cuentaVinculoId INT;
	
	SET cuentaVinculoId = (SELECT COUNT(*) FROM vinculosusuarios WHERE vinculoId = new.vinculoId);
	
	IF (cuentaVinculoId >= 1) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'No se puede actualizar un vínculo cuyo vinculoId esté repetido';
	END IF;

END //
DELIMITER ;


-- RN-1-01	Personas registradas mayores de edad
DELIMITER //
CREATE OR REPLACE TRIGGER
	tUsuariosMayoresEdad
AFTER INSERT ON personas FOR EACH ROW
	BEGIN
		DECLARE nacimiento DATE;
		DECLARE entrada DATE;
		DECLARE edad INT;
		
		SET nacimiento= (SELECT fechaNacimiento FROM personas WHERE usuarioId= new.usuarioId);
		SET entrada= (SELECT fechaAlta FROM Usuarios WHERE usuarioId=NEW.usuarioId);
		SET edad = TIMESTAMPDIFF(YEAR,nacimiento,entrada);
		
		IF(edad<18) THEN
		
		SIGNAL SQLSTATE '45000' 
		SET message_text ='La persona de la cuenta debe ser mayor de edad para poder registrarse';
		
		END IF;
	END //
DELIMITER ;

		
-- RN-1-04 Como máximo 10 fotos por usuarios
DELIMITER //
CREATE OR REPLACE TRIGGER
	tMaximoFotos
BEFORE INSERT ON fotos FOR EACH ROW
	BEGIN
		DECLARE numFotos INT;
		SET numFotos = (SELECT numPublicacion FROM usuarios WHERE usuarioId= NEW.usuarioId);
		
		IF(numFotos>=10) THEN
		
		SIGNAL SQLSTATE '45000' 
		SET message_text ='Un usuario solo puede subir 10 fotos a su cuenta';
		
		END IF;
	END //
DELIMITER ;
		

-- Se debe establecer una fecha de revocación al romper el vínculo
DELIMITER //
CREATE OR REPLACE TRIGGER 
	tFechaRevocacionActivoUpdate
BEFORE UPDATE ON vinculos FOR EACH ROW
BEGIN

	IF(NEW.activo = 0 AND NEW.fechaRevocacion IS NULL) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'RN2-01: Un vínculo que previamente estaba activo y que ya no lo está, debe tener fecha de revocación';
	
	END IF;
	
END //

DELIMITER ; 

-- La fecha de los mensajes deben estar dentro del intervalo de las fechas de conversacion RN4_03

DELIMITER //

CREATE OR REPLACE TRIGGER
	tFechaMensajes
BEFORE INSERT ON Mensajes FOR EACH ROW 
BEGIN
		DECLARE f_inicio DATE;
		DECLARE f_fin DATE;

		SET f_inicio = (SELECT fechaInicio FROM Conversaciones WHERE conversacionId = NEW.conversacionId);

		SET f_fin = (SELECT fechaFin FROM Conversaciones WHERE conversacionId = NEW.conversacionId);

		IF (NEW.fechaMensaje < f_Inicio OR NEW.fechaMensaje > f_fin) THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha del mensaje debe ser posterior a la fecha de inicio de conversación y anterior a la fecha de fin de conversación';
		END IF;
END//
DELIMITER ;

-- Los grupos no pueden ser creados por empresas RN4_05
DELIMITER //

CREATE OR REPLACE TRIGGER
	tGrupoEmpresa
BEFORE INSERT ON Grupos FOR EACH ROW 
BEGIN
DECLARE n INT;
	SET n = (SELECT usuarioId FROM Empresas WHERE usuarioId = (SELECT usuarioId FROM Usuarios WHERE NEW.creador = nombre));
	IF (n IS NOT NULL ) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un grupo no puede ser creado por una empresa';
	END IF;
END//
DELIMITER ;



-- RN 2-05 usuarios activo solicitudes
DELIMITER //
CREATE OR REPLACE TRIGGER
	SolicitudesSoloActivosInsert
BEFORE INSERT ON VinculosUsuarios FOR EACH ROW
BEGIN
	
	DECLARE fechaDeBajaE DATE;
	DECLARE fechaDeBajaR DATE;
	
	SET fechaDeBajaE = (SELECT fechaBaja FROM Usuarios WHERE usuarioId = new.emisorId);
	SET fechaDeBajaR = (SELECT fechaBaja FROM Usuarios WHERE usuarioId = new.receptorId);
	
	IF (fechaDeBajaE != 'NULL' OR fechaDeBajaR != 'NULL') THEN
		DELETE FROM vinculos WHERE vinculos.vinculoId = new.vinculoId;
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Un usuario no activo, es decir, con fecha de baja, no puede 
		enviar una solicitud de amistad a otro usuario ni tampoco recibirla';
	END IF;

END //
DELIMITER ;


DELIMITER //
CREATE OR REPLACE TRIGGER
	SolicitudesSoloActivosUpdate
BEFORE UPDATE ON VinculosUsuarios FOR EACH ROW
BEGIN
	
	DECLARE fechaDeBajaE DATE;
	DECLARE fechaDeBajaR DATE;
	
	SET fechaDeBajaE = (SELECT fechaBaja FROM Usuarios WHERE usuarioId = new.emisorId);
	SET fechaDeBajaR = (SELECT fechaBaja FROM Usuarios WHERE usuarioId = new.receptorId);
	
	IF (fechaDeBajaE != 'NULL' OR fechaDeBajaR != 'NULL') THEN
		DELETE FROM vinculos WHERE vinculoId = NEW.vinculoId;
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Un usuario no activo, es decir, con fecha de baja, no puede 
		enviar una solicitud de amistad a otro usuario ni tampoco recibirla';
	END IF;

END //
DELIMITER ;


-- RN 4-02 conversación de chat normal solo con vinculo activo--
DELIMITER //
CREATE OR REPLACE TRIGGER
	ConversacionesSoloVinculoActivoInsert
BEFORE INSERT ON Chats FOR EACH ROW
BEGIN
	
	DECLARE vinc BOOLEAN;
	
	SET vinc = (SELECT activo FROM Vinculos WHERE vinculoId = NEW.vinculoId);
	IF (vinc = FALSE) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'No se puede iniciar una conversacion entre dos usuarios si su vinculo no es activo';
	END IF;

END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER
	ConversacionesSoloVinculoActivoUpdate
BEFORE UPDATE ON Chats FOR EACH ROW
BEGIN
	
	DECLARE vinc BOOLEAN;
	
	SET vinc = (SELECT activo FROM Vinculos WHERE vinculoId = NEW.vinculoId);
	IF (vinc = FALSE) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'No se puede iniciar una conversacion entre dos usuarios si su vinculo no es activo';
	END IF;

END //
DELIMITER ;

-- RN-3-03
DELIMITER //
CREATE OR REPLACE TRIGGER
	tNoEliminacionUsuarioFicha
BEFORE DELETE ON usuarios FOR EACH ROW
BEGIN

	DECLARE tieneFichaPreferencias INT;
	
	SET tieneFichaPreferencias = (SELECT COUNT(*) FROM fichaPreferencias WHERE usuarioId = old.usuarioId);
	
	IF(tieneFichaPreferencias>0) THEN
		
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'No se puede eliminar un usuario que tenga ficha de preferencia';
			
	END IF;

END //
DELIMITER ;

-- RN-3-04
DELIMITER //
CREATE OR REPLACE TRIGGER
	tNoEliminacionFicha
BEFORE DELETE ON fichaPreferencias FOR EACH ROW
BEGIN

	DECLARE tieneAficiones INT;
	SET tieneAficiones = (SELECT COUNT(*) FROM PersonasAficiones WHERE usuarioId = old.usuarioId);
	
	IF(tieneAficiones>0) THEN
		
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'No se puede eliminar la ficha de un usuario con aficiones';
			
	END IF;

END //
DELIMITER ;


-- No se puede borrar personas con aficiones asignadas
DELIMITER //
CREATE OR REPLACE TRIGGER
	tNoEliminacionPersona
BEFORE DELETE ON Personas FOR EACH ROW
BEGIN

	DECLARE tieneAsignados INT;
	SET  tieneAsignados= (SELECT COUNT(*) FROM PersonasAficiones WHERE usuarioId = old.usuarioId);
	
	IF(tieneAsignados>0) THEN
		
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'No se puede eliminar las personas con aficiones asignadas';
			
	END IF;

END //
DELIMITER ;

-- No se puede borrar aficiones asignadas a personas
DELIMITER //
CREATE OR REPLACE TRIGGER
	tNoEliminacionAficion
BEFORE DELETE ON Aficiones FOR EACH ROW
BEGIN

	DECLARE tieneAsignados INT;
	SET  tieneAsignados= (SELECT COUNT(*) FROM PersonasAficiones WHERE aficionId = old.aficionId);
	
	IF(tieneAsignados>0) THEN
		
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'No se puede eliminar las aficiones asignadas a usuarios';
			
	END IF;

END //
DELIMITER ;

-- No se puede borrar usuarios con fotos
DELIMITER //
CREATE OR REPLACE TRIGGER
	tNoEliminacionUsuariosFotos
BEFORE DELETE ON Usuarios FOR EACH ROW
BEGIN

	DECLARE tieneFotos INT;
	SET  tieneFotos= (SELECT numPublicacion FROM Usuarios WHERE usuarioId = old.usuarioId);
	
	IF(tieneFotos>0) THEN
		
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'No se puede borrar usuarios con fotos';
			
	END IF;

END //
DELIMITER ;
