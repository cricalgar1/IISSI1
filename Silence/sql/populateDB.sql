DELIMITER //
CREATE OR REPLACE PROCEDURE
populate()
BEGIN

SET FOREIGN_KEY_CHECKS=0;
DELETE FROM PersonasAficiones;
DELETE FROM aficiones;
DELETE FROM fichapreferencias;
DELETE FROM Usuarios;
DELETE FROM Personas;
DELETE FROM Empresas;
DELETE FROM Vinculos;
DELETE FROM Conversaciones;
DELETE FROM Grupos;
DELETE FROM Mensajes;
DELETE FROM Fotos;
DELETE FROM Likes;
DELETE FROM Comentarios;
DELETE FROM PersonasGrupos;
DELETE FROM VinculosUsuarios;
DELETE FROM Salas;
DELETE FROM Chats;
DELETE FROM FichaPreferenciaAficiones;

SET FOREIGN_KEY_CHECKS=1;

ALTER TABLE Usuarios AUTO_INCREMENT=1;
ALTER TABLE Personas AUTO_INCREMENT=1;
ALTER TABLE Empresas AUTO_INCREMENT=1;
ALTER TABLE FichaPreferencias AUTO_INCREMENT=1;
ALTER TABLE Vinculos AUTO_INCREMENT=1;
ALTER TABLE Conversaciones AUTO_INCREMENT=1;
ALTER TABLE Grupos AUTO_INCREMENT=1;
ALTER TABLE Mensajes AUTO_INCREMENT=1;
ALTER TABLE Fotos AUTO_INCREMENT=1;
ALTER TABLE Likes AUTO_INCREMENT=1;
ALTER TABLE Comentarios AUTO_INCREMENT=1;
ALTER TABLE Aficiones AUTO_INCREMENT=1;
ALTER TABLE PersonasAficiones AUTO_INCREMENT=1;
ALTER TABLE PersonasGrupos AUTO_INCREMENT=1;
ALTER TABLE VinculosUsuarios AUTO_INCREMENT=1;
ALTER TABLE Salas AUTO_INCREMENT=1;
ALTER TABLE Chats AUTO_INCREMENT=1;
ALTER TABLE FichaPreferenciaAficiones
AUTO_INCREMENT=1;

INSERT INTO Usuarios (email, PASSWORD, nombre, fechaAlta, fechaBaja, biografia, direccion, seguidores, numPublicacion) VALUES
('manolo10@gmail.com', 'manolo45', 'man-olo', '2016-03-12', NULL, 'MDLR', 'Avenida Reina Mercedes, 39, 1ºC', 1, 0),
('jaimeramos@gmail.com', 'jose112', 'jose_xd', '2016-06-04', NULL, 'amigo de mis amigos','Sevilla, C/ Castillo de Marchenilla 1 3ºD', 2, 3),
('luciaa6@gmail.com', 'luucii', 'luciaR', '2020-10-22', NULL, 'Estudiante de Derecho', 'Calle Tarfia, 24, 2ºA', 1, 1),
('amazon@gmail.com', 'amazon345', 'Amazon', '2018-02-07', NULL, 'vendemos cosas', 'Sevilla, C/ Perez Hernandez 1 2ºA', 3, 2),
('pepegarcia@gmail.com','abcde', 'pepeUwU', '2021-12-01',NULL,'Estudiante Derecho', 'Calle Dormitorio,4,3ºB', 5, 2),
('marialuisa@gmail.com','2345', 'Mluisa03', '2021-1-30', NULL, 'Me gusta el Betis','Urbanizacion Las Dalias, 7, 4ºA',1,0),
('support@apple.com', 'manzanita1000', 'Apple', '2019-04-05', NULL, 'Vendemos el logo', 'C/ Cupertino, 4', 3, 0),
('albertomartinez@gmail.com', 'alberto789', 'Xx_Alberto69_xX', '2019-04-20', NULL, 'futbolista', 'Alicante, Avenida de Orihuela 5 3ªA', 2, 1),
('martagomez@gmail.com', 'marta1234', 'Martita3', '2021-11-02', NULL, 'Profesora', 'Sevilla, Calle San Luis, 25, 1ªB', 1, 2),
('jimenagarcia@gmail.com','7777hola', 'Jimmy', '2020-7-18', NULL, 'Mi gato se llama Misi','Avenida Platero, 45,5ºC',1,1),
('google@gmail.com', 'GOOgle1234', 'google', '2020-05-03', NULL, 'sabemos lo que haces', 'Málaga, C/Juan Ramón  26', 1, 4);

INSERT INTO Personas (usuarioId, fechaNacimiento, altura, peso, genero, colorOjos, colorPelo) VALUES 
(1, '1980-03-12', 180, 80.0, 'Masculino', 'Negro', 'Castaño'),
(2, '1976-06-04', 170, 75.7, 'Otros', 'Azul', 'Rojo'),
(3, '1967-10-22', 155, 62.3, 'Femenino', 'Verde', 'Rubio'),
(5, '2000-12-01', 167 , 70.5 , 'Femenino', 'Verde', 'Rojo'),
(6, '2000-01-30', 175, 78.6, 'Otros', 'Negro', 'Castaño'),
(8, '1986-03-20', 190, 84.5, 'Masculino', 'Verde', 'Rubio'),
(9, '1990-11-02', 159, 55.3, 'Femenino', 'Gris', 'Gris'),
(10, '1999-7-18', 163, 67.5, 'Femenino', 'Azul', 'Rubio');


INSERT INTO Empresas (usuarioId, url, tipoEmpresa) VALUES
(4, 'www.amazon.com', 'transporte'),
(7, 'www.apple.com', 'tecnologia'),
(11, 'www.google.es', 'tecnologia');

INSERT INTO FichaPreferencias (usuarioId, rangoEdad, rangoEstatura, rangoPeso, filtroGenero, filtroOjo, filtroColorPelo, ubicacion) VALUES
(1, 23, 165, 70, 'Masculino', 'Verde', 'Negro', 'Provincia'),
(2, 24, 171, 60, 'Femenino', 'Gris', 'Rubio', 'Provincia'),
(3, 25, 175, 65, 'Masculino', 'Castaño', 'Rubio', 'Provincia'),
(4, 21, 170, 60, 'Femenino', 'Negro', 'Negro', 'Provincia'),
(5, 22, 167, 55, 'Femenino', 'Azul', 'Castaño', 'Provincia');

INSERT INTO Vinculos (activo, fecha, fechaAceptacion, fechaRevocacion) VALUES
(1, '2021-03-19', '2021-03-20', null),
(1, '2021-12-15', '2021-12-20', null),
(1, '2021-12-15', '2021-12-16', null),
(1, '2021-12-04', '2021-12-07', null),
(1, '2021-12-04', '2021-12-04', null),
(1, '2020-01-01', '2020-03-12', null),
(1, '2021-12-03', '2021-12-07', null),
(1, '2021-02-15', '2021-02-16', null),
(1, '2021-06-19', '2021-06-19', null),
(1, '2021-04-03', '2021-04-06', null),
(1, '2021-07-11', '2021-08-01', null),
(1, '2021-11-19', '2021-11-21', null),
(1, '2021-01-19', '2021-01-19', null),
(1, '2021-08-16', '2021-08-20', null),
(1, '2021-06-13', '2021-07-20', null),
(1, '2021-10-06', '2021-10-20', null),
(1, '2020-12-30', '2020-12-31', null);

INSERT INTO Conversaciones (fechaInicio, fechaFin) VALUES
('2021-02-01',NULL),
('2021-07-14',NULL),
('2020-11-27','2021-11-30'),
('2021-01-28',NULL),
('2021-12-01',NULL),
('2021-03-17','2021-12-31'),
('2020-12-27',NULL),
('2021-04-21',NULL),
('2021-10-11', '2021-12-01');

INSERT INTO Grupos (nombreGrupo, fechaCreacion, numParticipante, creador) VALUES
('Grupo amarillo', '2021-11-03', 5, 'Manolo'),
('Grupo verde', '2020-05-03', 3, 'Jimena'),
('Grupo azul', '2021-01-04', 3, 'Jaime');


INSERT INTO Mensajes (conversacionId, texto, fechaMensaje, horaMensaje, horaRecibido, horaLeido) VALUES
(1,'hola, ¿que tal?', '2021-02-17','10:54:21','10:55:07','11:45:32'),
(1,'heyy, muy bien y tu?','2021-02-17','11:46:14','11:47:08','13:57:01'),
(2,'¿has visto la nueva peli de Spiderman', '2021-08-23','23:12:31','23:13:32','12:06:45'),
(2,'si es increible!!!', '2021-08-24','12:10:21','12:10:55','14:58:12'),
(3, 'hola', '2020-11-27', '19:31:47', '19:31:49', '20:01:15'),
(3, '¿como te llamas?', '2020-11-28', '14:11:37', '14:11:39', '17:41:12'),
(3, 'adios', '2021-11-30', '13:31:56', '13:31:57', '20:01:15'),
(4, 'no tengo entradas', '2021-01-28', '08:15:47', '08:15:49', '10:01:15'),
(4, 'Una pena', '2021-01-28', '17:11:27', '17:11:28', '19:41:52'),	
(5, 'uwu', '2021-12-1', '19:00:22', '19:01:03', '20:34:56'),
(5, 'owo', '2022-01-01', '01:10:41', '01:10:43', '12:15:26'),
(6, 'hey,k tal', '2021-03-17', '14:17:22', '15:00:03', '15:34:56'),
(6, 'WoOoOoO, perdona por responder', '2021-04-15', '16:20:41', '16:21:43', '17:00:45'),
(6, 'np', '2021-12-18', '06:02:41', '06:26:59', '10:50:25'),
(7,'hola que pasa?','2021-07-13','09:08:43','09:08:50','09:15:40'),
(7,'nada','2021-07-13','09:16:35','09:16:40','09:34:41'),
(8,'como estas?','2021-10-13','12:16:15','12:16:20','12:34:00'),
(8,'bien','2021-10-13','13:04:10','13:04:20','14:50:09'),
(9, 'Hola qué pasa?', '2021-10-12', '18:30:23', '18:30:25', '19:37:00'),
(9, 'He estado ocupado', '2021-11-06', '12:05:12', '12:07:20', '12:10:00');

INSERT INTO Fotos (usuarioId, urlFoto, nombre, descripcion, numLike, fechaPublicacion, tema) VALUES
(2, 'www.iissi-friends.com/foto1', 'foto1', 'hola, uwu', 1, '2021-04-03', 
'arte'),
(2, 'www.iissi-friends.com/foto2', 'foto2', 'hey, buenas tardes', 2, 
'2021-05-03', 'naturaleza'),
(2,'www.iissi-friends.com/foto3','foto3','esquiando',1,'2020-12-31','deporte'),
(3, 'www.iissi-friends.com/foto4', 'foto4', 'año nuevo', 2, '2021-01-03', 'fiesta'),
(4, 'www.iissi-friends.com/foto5', 'foto5', 'sorpresa', 1, '2019-09-21', 'diversión'),
(4, 'www.iissi-friends.com/foto6', 'foto6', 'Amazon Prime Video', 1, '2021-12-20', 'cine'),
(7, 'www.iissi-friends.com/foto7', 'foto7', 'asi soy yo', 1, '2021-05-08', 
'deporte'),
(8, 'www.iissi-friends.com/foto8', 'foto8', 'mi jardin', 1, '2021-06-05', 
'naturaleza'),
(8,'www.iissi-friends.com/foto9','foto9','feliz cumpleaños para mi!',1,'2021-4-15','fiesta'),
(9,'www.iissi-friends.com/foto10','foto10','netflix&chill',1,'2021-10-23','chill'),
(9, 'www.iissi-friends.com/foto11', 'foto11', 'entrenando', 0, '2021-12-01', 'deporte'),
(10, 'www.iissi-friends.com/foto12', 'foto12', 'Con mis amigas', 1, '2020-09-12', 'naturaleza');

INSERT INTO Likes (fotoId, emisorId, fechaLike) VALUES
(1, 7, '2021-04-03'),
(2, 5, '2021-05-07'),
(3, 11,'2021-1-13'),
(4, 6, '2021-01-05'),
(4, 4, '2021-01-10'),
(9, 9,'2021-5-1'),
(5, 1, '2019-10-13'),
(10,10,'2021-11-4'),
(6, 3, '2021-12-30'),
(12, 8, '2021-12-29');

INSERT INTO Comentarios (usuarioId, fotoId, texto, fecha) VALUES
(5, 2, 'se vienen cositas', '2021-05-05'),
(4, 4, 'Qué guay', '2021-01-10'),
(3, 6, 'Yo soy más de Netflix','2021-12-21');

INSERT INTO Aficiones (nombre) VALUES
('Deporte'),
('Cine'),
('Surfear'),
('Pintura'),
('Musica');

INSERT INTO PersonasAficiones (usuarioId, aficionId) VALUES
(1,1),
(2,4),
(3,5),
(8,3),
(5,2);

INSERT INTO PersonasGrupos (grupoId, personaId) VALUES
(1, 1), 
(1, 3),
(1, 4),
(1, 5),
(1, 6), 
(2, 10),
(2, 9),
(2, 8),
(3, 7),
(3, 11),
(3, 2);

INSERT INTO VinculosUsuarios (vinculoId, emisorId, receptorId) VALUES
(1, 1, 4),
(2, 2, 5),
(3, 3, 5),
(4, 4, 5),
(5, 5, 6),
(6, 4, 7),
(7, 5, 8),
(8, 8, 9),
(9, 9, 10), 
(10, 7, 11), 
(11, 1, 5),
(12, 3, 6),
(13, 1, 6),
(14, 1, 3),
(15, 4, 6),
(16, 4, 3),
(17, 2, 7);

INSERT INTO Salas(grupoId,conversacionId) VALUES
(1,1),
(2,2),
(3,3);

INSERT INTO Chats(vinculoId,conversacionId) VALUES
(17,4),
(1,5),
(5,6),
(7,7),
(9,8),
(10,9);

INSERT INTO fichaPreferenciaAficiones (fichaPreferenciaId, aficionId) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

END //
DELIMITER ;

CALL populate();