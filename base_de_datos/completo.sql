-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.4.32-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para voluntariado_upt
CREATE DATABASE IF NOT EXISTS `voluntariado_upt` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `voluntariado_upt`;

-- Volcando estructura para tabla voluntariado_upt.asistencias
CREATE TABLE IF NOT EXISTS `asistencias` (
  `id_asistencia` int(11) NOT NULL AUTO_INCREMENT,
  `id_inscripcion` int(11) NOT NULL,
  `id_campana` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `tipo_registro` enum('QR','MANUAL') DEFAULT 'MANUAL',
  `presente` tinyint(1) DEFAULT 1,
  `observaciones` text DEFAULT NULL,
  PRIMARY KEY (`id_asistencia`),
  KEY `id_inscripcion` (`id_inscripcion`),
  KEY `id_campana` (`id_campana`),
  KEY `id_estudiante` (`id_estudiante`),
  CONSTRAINT `asistencias_ibfk_1` FOREIGN KEY (`id_inscripcion`) REFERENCES `inscripciones` (`id_inscripcion`),
  CONSTRAINT `asistencias_ibfk_2` FOREIGN KEY (`id_campana`) REFERENCES `campanas` (`id_campana`),
  CONSTRAINT `asistencias_ibfk_3` FOREIGN KEY (`id_estudiante`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla voluntariado_upt.asistencias: ~13 rows (aproximadamente)
INSERT INTO `asistencias` (`id_asistencia`, `id_inscripcion`, `id_campana`, `id_estudiante`, `fecha_registro`, `tipo_registro`, `presente`, `observaciones`) VALUES
	(1, 1, 3, 1, '2025-10-16 02:23:47', 'QR', 1, NULL),
	(2, 6, 6, 4, '2025-10-19 00:54:47', 'QR', 1, NULL),
	(3, 7, 5, 4, '2025-10-19 00:58:23', 'QR', 1, NULL),
	(4, 8, 1, 20, '2025-10-19 01:06:19', 'QR', 1, NULL),
	(5, 10, 6, 20, '2025-10-19 01:15:17', 'QR', 1, NULL),
	(6, 14, 7, 8, '2025-10-19 01:33:11', 'QR', 1, NULL),
	(7, 13, 7, 7, '2025-10-19 01:33:22', 'QR', 1, NULL),
	(8, 12, 7, 6, '2025-10-19 01:33:32', 'QR', 1, NULL),
	(9, 11, 7, 5, '2025-10-19 01:33:40', 'QR', 1, NULL),
	(10, 15, 7, 11, '2025-10-19 02:07:22', 'QR', 1, NULL),
	(11, 16, 7, 18, '2025-10-19 02:11:28', 'QR', 1, NULL),
	(12, 17, 7, 19, '2025-10-19 02:28:21', 'QR', 1, NULL),
	(13, 18, 7, 20, '2025-10-19 02:38:28', 'QR', 1, NULL);

-- Volcando estructura para tabla voluntariado_upt.campanas
CREATE TABLE IF NOT EXISTS `campanas` (
  `id_campana` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `lugar` varchar(200) NOT NULL,
  `cupos_total` int(11) NOT NULL,
  `cupos_disponibles` int(11) NOT NULL,
  `requisitos` text DEFAULT NULL,
  `estado` enum('PUBLICADA','CERRADA','CANCELADA') DEFAULT 'PUBLICADA',
  `id_coordinador` int(11) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_campana`),
  KEY `id_coordinador` (`id_coordinador`),
  CONSTRAINT `campanas_ibfk_1` FOREIGN KEY (`id_coordinador`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla voluntariado_upt.campanas: ~6 rows (aproximadamente)
INSERT INTO `campanas` (`id_campana`, `titulo`, `descripcion`, `fecha`, `hora_inicio`, `hora_fin`, `lugar`, `cupos_total`, `cupos_disponibles`, `requisitos`, `estado`, `id_coordinador`, `fecha_creacion`) VALUES
	(1, 'ayuda a perritos', 'ayudaremos a perritos', '2025-10-30', '02:19:00', '04:21:00', 'en la misma UPT', 20, 18, 'ser estudiante de la upt', 'PUBLICADA', 3, '2025-10-03 05:16:26'),
	(2, 'qwe', 'qwe', '2025-10-17', '00:24:00', '00:27:00', 'eweq', 1, 0, 'eqwe', 'PUBLICADA', 3, '2025-10-03 05:24:14'),
	(3, 'asd', 'asd', '2025-10-16', '14:45:00', '23:45:00', 'en la misma UPT', 12, 11, 'wdwda', 'PUBLICADA', 3, '2025-10-03 19:43:42'),
	(4, 'patos', '12313', '2025-10-23', '15:47:00', '19:47:00', '123', 12, 11, '123123', 'PUBLICADA', 3, '2025-10-03 19:47:47'),
	(5, 'ayuda a gatitos', 'ayuda a los gatitos mas lindos', '2025-10-23', '03:11:00', '13:11:00', 'mi casita gaaa', 123, 120, '', 'PUBLICADA', 3, '2025-10-06 03:11:31'),
	(6, 'ayuda a capibaras', 'ayuda a muchos capibaras', '2025-10-24', '01:59:00', '04:59:00', 'boca del rio', 12, 10, '', 'PUBLICADA', 3, '2025-10-16 04:00:32'),
	(7, 'limpieza de playas', 'vamos a limpiar todos juntos como equipo', '2036-01-31', '01:19:00', '02:19:00', 'UPT', 12, 4, '', 'PUBLICADA', 3, '2025-10-19 01:19:34');

-- Volcando estructura para tabla voluntariado_upt.certificados
CREATE TABLE IF NOT EXISTS `certificados` (
  `id_certificado` int(11) NOT NULL AUTO_INCREMENT,
  `id_estudiante` int(11) NOT NULL,
  `id_campana` int(11) NOT NULL,
  `codigo_verificacion` varchar(50) NOT NULL,
  `hash_qr` varchar(255) DEFAULT NULL,
  `fecha_emision` timestamp NOT NULL DEFAULT current_timestamp(),
  `horas_acreditadas` int(11) NOT NULL,
  `ruta_archivo` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id_certificado`),
  UNIQUE KEY `codigo_verificacion` (`codigo_verificacion`),
  KEY `id_estudiante` (`id_estudiante`),
  KEY `id_campana` (`id_campana`),
  CONSTRAINT `certificados_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `certificados_ibfk_2` FOREIGN KEY (`id_campana`) REFERENCES `campanas` (`id_campana`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla voluntariado_upt.certificados: ~4 rows (aproximadamente)
INSERT INTO `certificados` (`id_certificado`, `id_estudiante`, `id_campana`, `codigo_verificacion`, `hash_qr`, `fecha_emision`, `horas_acreditadas`, `ruta_archivo`, `activo`) VALUES
	(1, 1, 3, 'CERT-B9D67A5F-10', 'CERTIFICADO|1|3|CERT-B9D67A5F-10|1760582037799', '2025-10-16 02:33:57', 9, NULL, 1),
	(2, 4, 6, 'CERT-F5A07E6D-92', 'CERTIFICADO|4|6|CERT-F5A07E6D-92|1760835344803', '2025-10-19 00:55:44', 3, NULL, 1),
	(3, 4, 5, 'CERT-B73B2A21-20', 'CERTIFICADO|4|5|CERT-B73B2A21-20|1760835547634', '2025-10-19 00:59:07', 10, NULL, 1),
	(4, 20, 1, 'CERT-8A89F5EB-38', 'CERTIFICADO|20|1|CERT-8A89F5EB-38|1760836043054', '2025-10-19 01:07:23', 2, NULL, 1),
	(5, 20, 6, 'CERT-A7CF8EDB-75', 'CERTIFICADO|20|6|CERT-A7CF8EDB-75|1760838932045', '2025-10-19 01:55:32', 3, NULL, 1),
	(6, 8, 7, 'CERT-3CDB954D-2A', 'CERTIFICADO|8|7|CERT-3CDB954D-2A|1760838932070', '2025-10-19 01:55:32', 1, NULL, 1),
	(7, 7, 7, 'CERT-269C85BD-8C', 'CERTIFICADO|7|7|CERT-269C85BD-8C|1760838932077', '2025-10-19 01:55:32', 1, NULL, 1),
	(8, 6, 7, 'CERT-82E1C800-02', 'CERTIFICADO|6|7|CERT-82E1C800-02|1760838932084', '2025-10-19 01:55:32', 1, NULL, 1),
	(9, 5, 7, 'CERT-9B230FC3-1C', 'CERTIFICADO|5|7|CERT-9B230FC3-1C|1760838932090', '2025-10-19 01:55:32', 1, NULL, 1);

-- Volcando estructura para tabla voluntariado_upt.inscripciones
CREATE TABLE IF NOT EXISTS `inscripciones` (
  `id_inscripcion` int(11) NOT NULL AUTO_INCREMENT,
  `id_campana` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `estado` enum('INSCRITO','LISTA_ESPERA','CANCELADO','CONFIRMADO') DEFAULT 'INSCRITO',
  `fecha_inscripcion` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_inscripcion`),
  UNIQUE KEY `unique_inscripcion` (`id_campana`,`id_estudiante`),
  KEY `id_estudiante` (`id_estudiante`),
  CONSTRAINT `inscripciones_ibfk_1` FOREIGN KEY (`id_campana`) REFERENCES `campanas` (`id_campana`),
  CONSTRAINT `inscripciones_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla voluntariado_upt.inscripciones: ~9 rows (aproximadamente)
INSERT INTO `inscripciones` (`id_inscripcion`, `id_campana`, `id_estudiante`, `estado`, `fecha_inscripcion`) VALUES
	(1, 3, 1, 'INSCRITO', '2025-10-03 20:12:25'),
	(2, 2, 1, 'INSCRITO', '2025-10-03 20:30:03'),
	(3, 4, 1, 'INSCRITO', '2025-10-03 21:20:00'),
	(4, 1, 1, 'INSCRITO', '2025-10-06 02:38:10'),
	(5, 5, 1, 'INSCRITO', '2025-10-06 03:11:42'),
	(6, 6, 4, 'INSCRITO', '2025-10-19 00:49:23'),
	(7, 5, 4, 'INSCRITO', '2025-10-19 00:57:17'),
	(8, 1, 20, 'INSCRITO', '2025-10-19 01:04:12'),
	(9, 5, 20, 'INSCRITO', '2025-10-19 01:10:37'),
	(10, 6, 20, 'INSCRITO', '2025-10-19 01:14:08'),
	(11, 7, 5, 'INSCRITO', '2025-10-19 01:20:01'),
	(12, 7, 6, 'INSCRITO', '2025-10-19 01:28:55'),
	(13, 7, 7, 'INSCRITO', '2025-10-19 01:29:33'),
	(14, 7, 8, 'INSCRITO', '2025-10-19 01:30:14'),
	(15, 7, 11, 'INSCRITO', '2025-10-19 02:05:08'),
	(16, 7, 18, 'INSCRITO', '2025-10-19 02:10:20'),
	(17, 7, 19, 'INSCRITO', '2025-10-19 02:20:05'),
	(18, 7, 20, 'INSCRITO', '2025-10-19 02:37:28');

-- Volcando estructura para tabla voluntariado_upt.usuarios
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) DEFAULT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `rol` enum('ESTUDIANTE','COORDINADOR','ADMINISTRADOR') NOT NULL,
  `escuela` varchar(50) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla voluntariado_upt.usuarios: ~21 rows (aproximadamente)
INSERT INTO `usuarios` (`id_usuario`, `codigo`, `nombres`, `apellidos`, `correo`, `contrasena`, `rol`, `escuela`, `telefono`, `activo`, `fecha_registro`) VALUES
	(1, '2022073895', 'diego', 'castillo', 'dc2022073895@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '953095099', 1, '2025-09-30 03:13:27'),
	(2, '', 'joan', 'medina', 'joan@upt.pe', '123', 'ADMINISTRADOR', 'EPIS', '953095099', 1, '2025-09-30 03:18:36'),
	(3, 'elanchipa', 'victor', 'cruz', 'victor@upt.pe', '123', 'COORDINADOR', 'EPIS', '123456789', 1, '2025-09-30 04:43:19'),
	(4, '23000', 'castillo', 'Estrella', 'estrella@upt.pe', '123', 'ESTUDIANTE', 'EPIS', '123123123', 1, '2025-10-16 04:20:42'),
	(5, '2019062986', 'Sebastian Rodrigo', 'Arce Bracamonte', 'sa2019062986@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(6, '2017057578', 'Alexsander Wilson', 'Challo Coaquera', 'ac2017057578@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(7, '2020067577', 'Brant Antony', 'Chata Choque', 'bc2020067577@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(8, '2022073903', 'Victor Williams', 'Cruz Mamani', 'vc2022073903@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(9, '2019065161', 'Christian Dennis', 'Hinojosa Mucho', 'ch2019065161@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(10, '2021072615', 'Renzo Fernando', 'Loyola Vilca Choque', 'rl2021072615@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(11, '2012042779', 'Gilmer Donaldo', 'Mamani Condori', 'gm2012042779@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(12, '2022075474', 'Junior', 'Mamani Estaña', 'jm2022075474@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(13, '2022074255', 'Joan Cristian', 'Medina Quispe', 'jm2022074255@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(14, '2022075743', 'Richard Alexis', 'Podesta Condori', 'rp2022075743@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(15, '2022075745', 'Nicole Luciana', 'Rios Cohaila', 'nr2022075745@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(16, '2022073505', 'Augusto Joaquin', 'Rivera Muñoz', 'ar2022073505@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(17, '2022075751', 'Patrick Elvis', 'Rodriguez Cardenas', 'pr2022075751@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(18, '2021072618', 'Jefferson Ronaldihño', 'Rosas Chambilla', 'jr2021072618@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(19, '2022075747', 'Nestor Juice Yomar', 'Serrano Ibañez', 'ns2022075747@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(20, '2022075480', 'Hashira Belen', 'Vargas Candia', 'hv2022075480@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),
	(21, '2021071090', 'Royser Alonsso', 'Villanueva Mamani', 'rv2021071090@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
