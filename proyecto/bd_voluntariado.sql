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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla voluntariado_upt.asistencias: ~0 rows (aproximadamente)

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla voluntariado_upt.campanas: ~5 rows (aproximadamente)
INSERT INTO `campanas` (`id_campana`, `titulo`, `descripcion`, `fecha`, `hora_inicio`, `hora_fin`, `lugar`, `cupos_total`, `cupos_disponibles`, `requisitos`, `estado`, `id_coordinador`, `fecha_creacion`) VALUES
	(1, 'ayuda a perritos', 'ayudaremos a perritos', '2025-10-30', '02:19:00', '04:21:00', 'en la misma UPT', 20, 19, 'ser estudiante de la upt', 'PUBLICADA', 3, '2025-10-03 05:16:26'),
	(2, 'qwe', 'qwe', '2025-10-17', '00:24:00', '00:27:00', 'eweq', 1, 0, 'eqwe', 'PUBLICADA', 3, '2025-10-03 05:24:14'),
	(3, 'asd', 'asd', '2025-10-16', '14:45:00', '23:45:00', 'en la misma UPT', 12, 11, 'wdwda', 'PUBLICADA', 3, '2025-10-03 19:43:42'),
	(4, 'patos', '12313', '2025-10-23', '15:47:00', '19:47:00', '123', 12, 11, '123123', 'PUBLICADA', 3, '2025-10-03 19:47:47'),
	(5, 'ayuda a gatitos', 'ayuda a los gatitos mas lindos', '2025-10-23', '03:11:00', '13:11:00', 'mi casita gaaa', 123, 122, '', 'PUBLICADA', 3, '2025-10-06 03:11:31');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla voluntariado_upt.certificados: ~0 rows (aproximadamente)

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla voluntariado_upt.inscripciones: ~5 rows (aproximadamente)
INSERT INTO `inscripciones` (`id_inscripcion`, `id_campana`, `id_estudiante`, `estado`, `fecha_inscripcion`) VALUES
	(1, 3, 1, 'INSCRITO', '2025-10-03 20:12:25'),
	(2, 2, 1, 'INSCRITO', '2025-10-03 20:30:03'),
	(3, 4, 1, 'INSCRITO', '2025-10-03 21:20:00'),
	(4, 1, 1, 'INSCRITO', '2025-10-06 02:38:10'),
	(5, 5, 1, 'INSCRITO', '2025-10-06 03:11:42');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla voluntariado_upt.usuarios: ~3 rows (aproximadamente)
INSERT INTO `usuarios` (`id_usuario`, `codigo`, `nombres`, `apellidos`, `correo`, `contrasena`, `rol`, `escuela`, `telefono`, `activo`, `fecha_registro`) VALUES
	(1, '2022073895', 'diego', 'castillo', 'dc2022073895@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '953095099', 1, '2025-09-30 03:13:27'),
	(2, '', 'joan', 'medina', 'joan@upt.pe', '123', 'ADMINISTRADOR', 'EPIS', '953095099', 1, '2025-09-30 03:18:36'),
	(3, 'elanchipa', 'victor', 'cruz', 'victor@upt.pe', '123', 'COORDINADOR', 'EPIS', '123456789', 1, '2025-09-30 04:43:19');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
