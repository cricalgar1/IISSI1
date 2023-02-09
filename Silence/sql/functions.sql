
-- RF-2-01
DELIMITER //
CREATE OR REPLACE FUNCTION
	fvinculosRevocados() 
	RETURNS INT
	BEGIN
		RETURN(
		SELECT Vinculos.vinculoId FROM Vinculos 
		WHERE Vinculos.activo=false
		);
	END //
DELIMITER ;

-- RF-3-03
DELIMITER //
CREATE OR REPLACE FUNCTION
	fNombrePersonaConFotoMasLikesAyer()
	RETURNS VARCHAR(60)
	
BEGIN
	DECLARE fechaAyer DATE;
	DECLARE idFotoConMasLikes INT;
	DECLARE idUsuarioDeLaFoto INT;
	DECLARE esPersona INT;
	DECLARE nombreUsuario VARCHAR(60);
	
	SET fechaAyer = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
	
	SET idFotoConMasLikes = 
		(SELECT fotoId FROM Likes 
		WHERE fechaLike=fechaAyer
		GROUP BY fotoId
		ORDER BY COUNT(*) DESC LIMIT 1);
		
	SET idUsuarioDeLaFoto = (SELECT usuarioId FROM fotos WHERE fotoId=idFotoConMasLikes);
	
	RETURN (SELECT nombre FROM usuarios WHERE usuarioId = idUsuarioDeLaFoto);

END //
DELIMITER ;

-- RF-4-01

DELIMITER //
CREATE OR REPLACE FUNCTION elegirMensajes(fFin DATE) RETURNS VARCHAR(500) 
	BEGIN 
		DECLARE conjMensajes VARCHAR(500);
		DECLARE id INT;
		
		SET id = (SELECT conversacionId FROM conversaciones WHERE fechaFin=fFin);
	RETURN (SELECT texto FROM mensajes WHERE conversacionId = id);
	END//
DELIMITER ;


-- RF-4-01
DELIMITER //
CREATE OR REPLACE FUNCTION ifMensajeRecibido (mnsjId INT,cnvId INT) RETURNS BOOLEAN
	BEGIN
		DECLARE resultado BOOLEAN;
		DECLARE h_r TIME;
		SET h_r = (SELECT horaRecibido FROM Mensajes WHERE mensajeId = msnjId AND conversacionId = cnvId); 
		
		IF(h_r IS NOT NULL) THEN 
			SET resultado = 1; 
		END IF;
		
		IF(h_r IS NULL) THEN
			SET resultado = 0;
		END IF;
		
		RETURN resultado;
	END//

DELIMITER ;









-- RF-4-03
DELIMITER //
CREATE OR REPLACE FUNCTION ifMensajeRecibidoLeido (mnsjId INT, cnvId INT) RETURNS BOOLEAN
	BEGIN
		DECLARE resultado BOOLEAN;
		DECLARE h_r TIME;
		DECLARE h_l TIME;
		SET h_r = (SELECT horaRecibido FROM Mensajes WHERE conversacionId = cnvId AND mensajeId = mnsjId);
		SET h_l = (SELECT horaLeido FROM Mensajes WHERE conversacionId = cnvId AND mensajeId = mnsjId);
			
		IF(h_r IS NOT NULL AND h_l IS NOT NULL) THEN 
			SET resultado = 1; 
		END IF;
		
		IF(h_r IS NOT NULL AND h_l IS NULL) THEN
			SET resultado = 0;
		END IF;
		
		RETURN resultado;
	END//
		
DELIMITER ;


