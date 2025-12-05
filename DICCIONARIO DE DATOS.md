<center>

[comment]: <img src="./media/media/image1.png" style="width:1.088in;height:1.46256in" alt="escudo.png" />

![./media/media/image1.png](./media/logo-upt.png)

## **UNIVERSIDAD PRIVADA DE TACNA**

## **FACULTAD DE INGENIERIA**

## **Escuela Profesional de Ingeniería de Sistemas**<br>

<br>

# **Proyecto *"Implementación de Sistema de Voluntariado UPT"***

<br>

Curso: *Calidad y Pruebas de Software*

Docente: *Patrick José Cuadros Quiroga*


Integrantes:

***Cruz Mamani, Victor Williams (2022073903)***  
***Castillo Mamani, Diego Fernando (2022073895)***  
***Medina Quispe, Joan Cristian (202207394255)***

**Tacna – Perú**

***2025-II***

**  
**
</center>
<div style="page-break-after: always; visibility: hidden">\pagebreak</div>


<br>












<a name="_heading=h.52nyfmm3yjan"></a>**Implementación de Sistema de Voluntariado UPT**

**Diccionario de Datos**

**Versión *1.0***




































**ÍNDICE GENERAL**

[**1.**](#_heading=h.gjdgxs)[	](#_heading=h.gjdgxs)[**Modelo Entidad / relación**	4](#_heading=h.gjdgxs)

[**1.1.**](#_heading=h.30j0zll)[	](#_heading=h.30j0zll)[**Diseño lógico**	4](#_heading=h.30j0zll)

[**1.2.**](#_heading=h.1fob9te)[	](#_heading=h.1fob9te)[**Diseño Físico**	4](#_heading=h.1fob9te)

[**2.**](#_heading=h.3znysh7)[	](#_heading=h.3znysh7)[**DICCIONARIO DE DATOS**	4](#_heading=h.3znysh7)

[**2.1.**](#_heading=h.2et92p0)[	](#_heading=h.2et92p0)[**Tablas**	4](#_heading=h.2et92p0)

[**1.1.**](#_heading=h.tyjcwt)[	](#_heading=h.tyjcwt)[**Procedimientos Almacenados**	4](#_heading=h.tyjcwt)

[**1.2.**](#_heading=h.3dy6vkm)[	](#_heading=h.3dy6vkm)[**Lenguaje de Definición de Datos (DDL)**	5](#_heading=h.3dy6vkm)

[**1.3.**](#_heading=h.1t3h5sf)[	](#_heading=h.1t3h5sf)[**Lenguaje de Manipulación de Datos (DML)**	5](#_heading=h.1t3h5sf)

































**Diccionario de Datos**



1. # <a name="_heading=h.gjdgxs"></a>**Modelo Entidad / relación**

1. <a name="_heading=h.30j0zll"></a>**Diseño lógico**

![](Aspose.Words.8f25a3ab-1230-40da-9dce-479ae3ec161f.002.png)


1. <a name="_heading=h.1fob9te"></a>**Diseño Físico**


![](Aspose.Words.8f25a3ab-1230-40da-9dce-479ae3ec161f.003.png)







1. # <a name="_heading=h.3znysh7"></a>**DICCIONARIO DE DATOS**

   1. <a name="_heading=h.2et92p0"></a>**Tablas**

|**Nombre de la Tabla:**|usuarios||||||
| - | - | :- | :- | :- | :- | :- |
|**Descripción de la Tabla:**|Registra los datos de los usuarios del sistema.||||||
|**Objetivo:**|poder proveer de la data a las otras tablas relacionadas.||||||
|**Relaciones con otras Tablas:**|se relaciona con las tablas: inscripciones, asistencias, campanas y certificados.||||||
|**Descripción de los campos**|||||||
|**Nro.**|**Nombre del campo**|**Tipo dato longitud**|**Permite nulos**|**Clave primaria**|**Clave foránea**|**Descripción del campo**|
||||||||
|1|id\_usuario|int(11)|no|si|no|Posee función auto\_increment|
|2|codigo|varchar(20)|si|no|no|dato que ayuda a diferenciarse entre estudiantes.|
|3|nombres|varchar(100)|no|no|no|guarda nombres de estudiantes.|
|4|apellidos|varchar(100)|no|no|no|guarda los apellidos de estudiantes.|
|5|correo|varchar(100)|no|no|no|posee restricción UNIQUE.|
|6|contrasena|varchar(255)|no|no|no|guarda la contraseña de los estudiantes.|
|7|rol|enum(‘ESTUDIANTE’,’COORDINADOR’,’ADMINISTRADOR’)|no|no|no|permite escoger el rol a registrar.|
|8|escuela|varchar(50)|si|no|no|refiere al reconocimiento de la escuela profesional a la cual pertenece el estudiante.|
|9|telefono|varchar(15)|si|no|no|guardar el número de celular del estudiante.|
|10|activo|TINYINT(1)|si|no|no|indica el estado actual del estudiante, coordinador y administrador  1 es activo y 0 es inactivo. Modificable.|
|11|fecha\_registro|TIMESTAMP|no|no|no|guarda la fecha en la cual fue registrado el estudiante.|



|**Nombre de la Tabla:**|asistencias||||||
| - | - | :- | :- | :- | :- | :- |
|**Descripción de la Tabla:**|Registra los datos de las asistencias del sistema.||||||
|**Objetivo:**|poder registrar las asistencias a las campañas.||||||
|**Relaciones con otras Tablas:**|se relaciona con las tablas: inscripciones, campanas y usuarios.||||||
|**Descripción de los campos**|||||||
|**Nro.**|**Nombre del campo**|**Tipo dato longitud**|**Permite nulos**|**Clave primaria**|**Clave foránea**|**Descripción del campo**|
||||||||
|1|id\_asistencia|int(11)|no|si|no|Posee función auto\_increment|
|2|id\_inscripcion|int(11)|no|no|si|registra la inscripción hacia las campañas|
|3|id\_campana|int(11)|no|no|si|guarda el id de las campañas.|
|4|id\_estudiante|int(11)|no|no|si|guarda el id del estudiante. |
|5|fecha\_registro|TIMESTAMP|no|no|no|guarda la fecha de registro.|
|6|tipo\_registro|ENUM(‘QR’,’MANUAL’)|si|no|no|guarda el tipo de registro|
|7|presente|TINYINT(1)|si|no|no|guarda si estuvo presente o no con 1 si es si, y 0 si es que no.|
|8|observaciones|TEXT|si|no|no|guarda las observaciones que hubieron en las campañas.|



|**Nombre de la Tabla:**|campanas||||||
| - | - | :- | :- | :- | :- | :- |
|**Descripción de la Tabla:**|Registra los datos de los usuarios del sistema.||||||
|**Objetivo:**|poder proveer de la data a las otras tablas relacionadas.||||||
|**Relaciones con otras Tablas:**|se relaciona con las tablas: inscripciones, asistencias, campanas y certificados.||||||
|**Descripción de los campos**|||||||
|**Nro.**|**Nombre del campo**|**Tipo dato longitud**|**Permite nulos**|**Clave primaria**|**Clave foránea**|**Descripción del campo**|
||||||||
|1|id\_campana|int(11)|no|si|no|Posee función auto\_increment|
|2|titulo|VARCHAR(200|no|no|no|guarda el titulo de la campaña.|
|3|descripcion|TEXT|si|no|no|describe de que trata la campaña.|
|4|fecha|DATE|no|no|no|guarda la fecha  en la cual se llevará a cabo la campaña.|
|5|hora\_inicio|TIME|no|no|no|guarda la hora en la cual dará inicio la campaña.|
|6|hora\_fin|TIME|no|no|no|guarda la hora en la cual finalizará la campaña.|
|7|lugar|VARCHAR(200)|no|no|no|guarda el lugar donde se llevará a cabo la campaña.|
|8|cupos\_total|int(11)|no|no|no|guarda la cantidad de cupos para la campaña.|
|9|cupos\_disponibles|int(11)|no|no|no|indica los cupos disponibles.|
|10|requisitos|TEXT|si|no|no|indica que requisitos se solicitan para la participación en dicha campaña.|
|11|estado|ENUM('PUBLICADA','CERRADA','CANCELADA')|si|no|no|indica el estado de la campaña.|
|12|id\_coordinador|int(11)|no|no|si|indica el id del coordinador|
|13|fecha\_creacion|TIMESTAMP|no|no|no|indica la fecha de creación.|


|**Nombre de la Tabla:**|inscripciones||||||
| - | - | :- | :- | :- | :- | :- |
|**Descripción de la Tabla:**|Registra los datos de los estudiantes que se inscriban al sistema.||||||
|**Objetivo:**|poder registrar las inscripciones a campañas.||||||
|**Relaciones con otras Tablas:**|se relaciona con las tablas: usuarios, asistencias y campanas.||||||
|**Descripción de los campos**|||||||
|**Nro.**|**Nombre del campo**|**Tipo dato longitud**|**Permite nulos**|**Clave primaria**|**Clave foránea**|**Descripción del campo**|
||||||||
|1|id\_inscripcion|int(11)|no|si|no|Posee función auto\_increment|
|2|id\_campana|int(11)|no|no|si|guarda el id de las campañas.|
|3|id\_estudiante|int(11)|no|no|si|guarda el id de los estudiantes.|
|4|estado|ENUM('INSCRITO','LISTA\_ESPERA','CANCELADO','CONFIRMADO')|si|no|no|indica que posibilidad de elegir una opción de las que hay.|
|5|fecha\_inscripcion|TIMESTAMP|no|no|no|guarda la fecha de inscripción.|




|**Nombre de la Tabla:**|certificados||||||
| - | - | :- | :- | :- | :- | :- |
|**Descripción de la Tabla:**|Registra los datos de los estudiantes que se inscriban al sistema.||||||
|**Objetivo:**|poder validarla participación en las campañas durante ciertas horas predeterminadas para su obtención.||||||
|**Relaciones con otras Tablas:**|se relaciona con las tablas: usuarios y campanas.||||||
|**Descripción de los campos**|||||||
|**Nro.**|**Nombre del campo**|**Tipo dato longitud**|**Permite nulos**|**Clave primaria**|**Clave foránea**|**Descripción del campo**|
||||||||
|1|id\_certificado|int(11)|no|si|no|Posee función auto\_increment|
|2|id\_estudiante|int(11)|no|no|si|guarda el id del estudiante.|
|3|id\_campana|int(11)|no|no|si|guarda el id de la campaña.|
|4|codigo\_verificacion|varchar(50)|no|no|no|guarda el código de verificación.|
|5|hash\_qr|varchar(255)|si|no|no|guarda el hash QR.|
|6|fecha\_emision|TIMESTAMP|no|no|no|guarda la fecha de emisión del certificado.|
|7|horas\_acreditadas|int(11)|no|no|no|guarda las horas acreditadas por participación en campañas.|
|8|ruta\_archivo|varchar(255)|si|no|no|guarda la ruta del archivo.|
|9|activo|TINYINT(1)|si|no|no|indica 1 si esta activo y 0 si está inactivo.|

1. <a name="_heading=h.tyjcwt"></a>**Procedimientos Almacenados**

-No se cuenta con procedimientos almacenados.


1. <a name="_heading=h.3dy6vkm"></a>**Lenguaje de Definición de Datos (DDL) y Lenguaje de Manipulación de Datos (DML)**



CREATE DATABASE IF NOT EXISTS `voluntariado\_upt` /\*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4\_general\_ci \*/;

USE `voluntariado\_upt`;

-- Volcando estructura para tabla voluntariado\_upt.asistencias

CREATE TABLE IF NOT EXISTS `asistencias` (

`  ``id\_asistencia` int(11) NOT NULL AUTO\_INCREMENT,

`  ``id\_inscripcion` int(11) NOT NULL,

`  ``id\_campana` int(11) NOT NULL,

`  ``id\_estudiante` int(11) NOT NULL,

`  ``fecha\_registro` timestamp NOT NULL DEFAULT current\_timestamp(),

`  ``tipo\_registro` enum('QR','MANUAL') DEFAULT 'MANUAL',

`  ``presente` tinyint(1) DEFAULT 1,

`  ``observaciones` text DEFAULT NULL,

`  `PRIMARY KEY (`id\_asistencia`),

`  `KEY `id\_inscripcion` (`id\_inscripcion`),

`  `KEY `id\_campana` (`id\_campana`),

`  `KEY `id\_estudiante` (`id\_estudiante`),

`  `CONSTRAINT `asistencias\_ibfk\_1` FOREIGN KEY (`id\_inscripcion`) REFERENCES `inscripciones` (`id\_inscripcion`),

`  `CONSTRAINT `asistencias\_ibfk\_2` FOREIGN KEY (`id\_campana`) REFERENCES `campanas` (`id\_campana`),

`  `CONSTRAINT `asistencias\_ibfk\_3` FOREIGN KEY (`id\_estudiante`) REFERENCES `usuarios` (`id\_usuario`)

) ENGINE=InnoDB AUTO\_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4\_general\_ci;

-- Volcando datos para la tabla voluntariado\_upt.asistencias: ~13 rows (aproximadamente)

INSERT INTO `asistencias` (`id\_asistencia`, `id\_inscripcion`, `id\_campana`, `id\_estudiante`, `fecha\_registro`, `tipo\_registro`, `presente`, `observaciones`) VALUES

`	`(1, 1, 3, 1, '2025-10-16 02:23:47', 'QR', 1, NULL),

`	`(2, 6, 6, 4, '2025-10-19 00:54:47', 'QR', 1, NULL),

`	`(3, 7, 5, 4, '2025-10-19 00:58:23', 'QR', 1, NULL),

`	`(4, 8, 1, 20, '2025-10-19 01:06:19', 'QR', 1, NULL),

`	`(5, 10, 6, 20, '2025-10-19 01:15:17', 'QR', 1, NULL),

`	`(6, 14, 7, 8, '2025-10-19 01:33:11', 'QR', 1, NULL),

`	`(7, 13, 7, 7, '2025-10-19 01:33:22', 'QR', 1, NULL),

`	`(8, 12, 7, 6, '2025-10-19 01:33:32', 'QR', 1, NULL),

`	`(9, 11, 7, 5, '2025-10-19 01:33:40', 'QR', 1, NULL),

`	`(10, 15, 7, 11, '2025-10-19 02:07:22', 'QR', 1, NULL),

`	`(11, 16, 7, 18, '2025-10-19 02:11:28', 'QR', 1, NULL),

`	`(12, 17, 7, 19, '2025-10-19 02:28:21', 'QR', 1, NULL),

`	`(13, 18, 7, 20, '2025-10-19 02:38:28', 'QR', 1, NULL);

-- Volcando estructura para tabla voluntariado\_upt.campanas

CREATE TABLE IF NOT EXISTS `campanas` (

`  ``id\_campana` int(11) NOT NULL AUTO\_INCREMENT,

`  ``titulo` varchar(200) NOT NULL,

`  ``descripcion` text DEFAULT NULL,

`  ``fecha` date NOT NULL,

`  ``hora\_inicio` time NOT NULL,

`  ``hora\_fin` time NOT NULL,

`  ``lugar` varchar(200) NOT NULL,

`  ``cupos\_total` int(11) NOT NULL,

`  ``cupos\_disponibles` int(11) NOT NULL,

`  ``requisitos` text DEFAULT NULL,

`  ``estado` enum('PUBLICADA','CERRADA','CANCELADA') DEFAULT 'PUBLICADA',

`  ``id\_coordinador` int(11) NOT NULL,

`  ``fecha\_creacion` timestamp NOT NULL DEFAULT current\_timestamp(),

`  `PRIMARY KEY (`id\_campana`),

`  `KEY `id\_coordinador` (`id\_coordinador`),

`  `CONSTRAINT `campanas\_ibfk\_1` FOREIGN KEY (`id\_coordinador`) REFERENCES `usuarios` (`id\_usuario`)

) ENGINE=InnoDB AUTO\_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4\_general\_ci;

-- Volcando datos para la tabla voluntariado\_upt.campanas: ~6 rows (aproximadamente)

INSERT INTO `campanas` (`id\_campana`, `titulo`, `descripcion`, `fecha`, `hora\_inicio`, `hora\_fin`, `lugar`, `cupos\_total`, `cupos\_disponibles`, `requisitos`, `estado`, `id\_coordinador`, `fecha\_creacion`) VALUES

`	`(1, 'ayuda a perritos', 'ayudaremos a perritos', '2025-10-30', '02:19:00', '04:21:00', 'en la misma UPT', 20, 18, 'ser estudiante de la upt', 'PUBLICADA', 3, '2025-10-03 05:16:26'),

`	`(2, 'qwe', 'qwe', '2025-10-17', '00:24:00', '00:27:00', 'eweq', 1, 0, 'eqwe', 'PUBLICADA', 3, '2025-10-03 05:24:14'),

`	`(3, 'asd', 'asd', '2025-10-16', '14:45:00', '23:45:00', 'en la misma UPT', 12, 11, 'wdwda', 'PUBLICADA', 3, '2025-10-03 19:43:42'),

`	`(4, 'patos', '12313', '2025-10-23', '15:47:00', '19:47:00', '123', 12, 11, '123123', 'PUBLICADA', 3, '2025-10-03 19:47:47'),

`	`(5, 'ayuda a gatitos', 'ayuda a los gatitos mas lindos', '2025-10-23', '03:11:00', '13:11:00', 'mi casita gaaa', 123, 120, '', 'PUBLICADA', 3, '2025-10-06 03:11:31'),

`	`(6, 'ayuda a capibaras', 'ayuda a muchos capibaras', '2025-10-24', '01:59:00', '04:59:00', 'boca del rio', 12, 10, '', 'PUBLICADA', 3, '2025-10-16 04:00:32'),

`	`(7, 'limpieza de playas', 'vamos a limpiar todos juntos como equipo', '2036-01-31', '01:19:00', '02:19:00', 'UPT', 12, 4, '', 'PUBLICADA', 3, '2025-10-19 01:19:34');

-- Volcando estructura para tabla voluntariado\_upt.certificados

CREATE TABLE IF NOT EXISTS `certificados` (

`  ``id\_certificado` int(11) NOT NULL AUTO\_INCREMENT,

`  ``id\_estudiante` int(11) NOT NULL,

`  ``id\_campana` int(11) NOT NULL,

`  ``codigo\_verificacion` varchar(50) NOT NULL,

`  ``hash\_qr` varchar(255) DEFAULT NULL,

`  ``fecha\_emision` timestamp NOT NULL DEFAULT current\_timestamp(),

`  ``horas\_acreditadas` int(11) NOT NULL,

`  ``ruta\_archivo` varchar(255) DEFAULT NULL,

`  ``activo` tinyint(1) DEFAULT 1,

`  `PRIMARY KEY (`id\_certificado`),

`  `UNIQUE KEY `codigo\_verificacion` (`codigo\_verificacion`),

`  `KEY `id\_estudiante` (`id\_estudiante`),

`  `KEY `id\_campana` (`id\_campana`),

`  `CONSTRAINT `certificados\_ibfk\_1` FOREIGN KEY (`id\_estudiante`) REFERENCES `usuarios` (`id\_usuario`),

`  `CONSTRAINT `certificados\_ibfk\_2` FOREIGN KEY (`id\_campana`) REFERENCES `campanas` (`id\_campana`)

) ENGINE=InnoDB AUTO\_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4\_general\_ci;

-- Volcando datos para la tabla voluntariado\_upt.certificados: ~4 rows (aproximadamente)

INSERT INTO `certificados` (`id\_certificado`, `id\_estudiante`, `id\_campana`, `codigo\_verificacion`, `hash\_qr`, `fecha\_emision`, `horas\_acreditadas`, `ruta\_archivo`, `activo`) VALUES

`	`(1, 1, 3, 'CERT-B9D67A5F-10', 'CERTIFICADO|1|3|CERT-B9D67A5F-10|1760582037799', '2025-10-16 02:33:57', 9, NULL, 1),

`	`(2, 4, 6, 'CERT-F5A07E6D-92', 'CERTIFICADO|4|6|CERT-F5A07E6D-92|1760835344803', '2025-10-19 00:55:44', 3, NULL, 1),

`	`(3, 4, 5, 'CERT-B73B2A21-20', 'CERTIFICADO|4|5|CERT-B73B2A21-20|1760835547634', '2025-10-19 00:59:07', 10, NULL, 1),

`	`(4, 20, 1, 'CERT-8A89F5EB-38', 'CERTIFICADO|20|1|CERT-8A89F5EB-38|1760836043054', '2025-10-19 01:07:23', 2, NULL, 1),

`	`(5, 20, 6, 'CERT-A7CF8EDB-75', 'CERTIFICADO|20|6|CERT-A7CF8EDB-75|1760838932045', '2025-10-19 01:55:32', 3, NULL, 1),

`	`(6, 8, 7, 'CERT-3CDB954D-2A', 'CERTIFICADO|8|7|CERT-3CDB954D-2A|1760838932070', '2025-10-19 01:55:32', 1, NULL, 1),

`	`(7, 7, 7, 'CERT-269C85BD-8C', 'CERTIFICADO|7|7|CERT-269C85BD-8C|1760838932077', '2025-10-19 01:55:32', 1, NULL, 1),

`	`(8, 6, 7, 'CERT-82E1C800-02', 'CERTIFICADO|6|7|CERT-82E1C800-02|1760838932084', '2025-10-19 01:55:32', 1, NULL, 1),

`	`(9, 5, 7, 'CERT-9B230FC3-1C', 'CERTIFICADO|5|7|CERT-9B230FC3-1C|1760838932090', '2025-10-19 01:55:32', 1, NULL, 1);

-- Volcando estructura para tabla voluntariado\_upt.inscripciones

CREATE TABLE IF NOT EXISTS `inscripciones` (

`  ``id\_inscripcion` int(11) NOT NULL AUTO\_INCREMENT,

`  ``id\_campana` int(11) NOT NULL,

`  ``id\_estudiante` int(11) NOT NULL,

`  ``estado` enum('INSCRITO','LISTA\_ESPERA','CANCELADO','CONFIRMADO') DEFAULT 'INSCRITO',

`  ``fecha\_inscripcion` timestamp NOT NULL DEFAULT current\_timestamp(),

`  `PRIMARY KEY (`id\_inscripcion`),

`  `UNIQUE KEY `unique\_inscripcion` (`id\_campana`,`id\_estudiante`),

`  `KEY `id\_estudiante` (`id\_estudiante`),

`  `CONSTRAINT `inscripciones\_ibfk\_1` FOREIGN KEY (`id\_campana`) REFERENCES `campanas` (`id\_campana`),

`  `CONSTRAINT `inscripciones\_ibfk\_2` FOREIGN KEY (`id\_estudiante`) REFERENCES `usuarios` (`id\_usuario`)

) ENGINE=InnoDB AUTO\_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4\_general\_ci;

-- Volcando datos para la tabla voluntariado\_upt.inscripciones: ~9 rows (aproximadamente)

INSERT INTO `inscripciones` (`id\_inscripcion`, `id\_campana`, `id\_estudiante`, `estado`, `fecha\_inscripcion`) VALUES

`	`(1, 3, 1, 'INSCRITO', '2025-10-03 20:12:25'),

`	`(2, 2, 1, 'INSCRITO', '2025-10-03 20:30:03'),

`	`(3, 4, 1, 'INSCRITO', '2025-10-03 21:20:00'),

`	`(4, 1, 1, 'INSCRITO', '2025-10-06 02:38:10'),

`	`(5, 5, 1, 'INSCRITO', '2025-10-06 03:11:42'),

`	`(6, 6, 4, 'INSCRITO', '2025-10-19 00:49:23'),

`	`(7, 5, 4, 'INSCRITO', '2025-10-19 00:57:17'),

`	`(8, 1, 20, 'INSCRITO', '2025-10-19 01:04:12'),

`	`(9, 5, 20, 'INSCRITO', '2025-10-19 01:10:37'),

`	`(10, 6, 20, 'INSCRITO', '2025-10-19 01:14:08'),

`	`(11, 7, 5, 'INSCRITO', '2025-10-19 01:20:01'),

`	`(12, 7, 6, 'INSCRITO', '2025-10-19 01:28:55'),

`	`(13, 7, 7, 'INSCRITO', '2025-10-19 01:29:33'),

`	`(14, 7, 8, 'INSCRITO', '2025-10-19 01:30:14'),

`	`(15, 7, 11, 'INSCRITO', '2025-10-19 02:05:08'),

`	`(16, 7, 18, 'INSCRITO', '2025-10-19 02:10:20'),

`	`(17, 7, 19, 'INSCRITO', '2025-10-19 02:20:05'),

`	`(18, 7, 20, 'INSCRITO', '2025-10-19 02:37:28');

-- Volcando estructura para tabla voluntariado\_upt.usuarios

CREATE TABLE IF NOT EXISTS `usuarios` (

`  ``id\_usuario` int(11) NOT NULL AUTO\_INCREMENT,

`  ``codigo` varchar(20) DEFAULT NULL,

`  ``nombres` varchar(100) NOT NULL,

`  ``apellidos` varchar(100) NOT NULL,

`  ``correo` varchar(100) NOT NULL,

`  ``contrasena` varchar(255) NOT NULL,

`  ``rol` enum('ESTUDIANTE','COORDINADOR','ADMINISTRADOR') NOT NULL,

`  ``escuela` varchar(50) DEFAULT NULL,

`  ``telefono` varchar(15) DEFAULT NULL,

`  ``activo` tinyint(1) DEFAULT 1,

`  ``fecha\_registro` timestamp NOT NULL DEFAULT current\_timestamp(),

`  `PRIMARY KEY (`id\_usuario`),

`  `UNIQUE KEY `correo` (`correo`)

) ENGINE=InnoDB AUTO\_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4\_general\_ci;

-- Volcando datos para la tabla voluntariado\_upt.usuarios: ~21 rows (aproximadamente)

INSERT INTO `usuarios` (`id\_usuario`, `codigo`, `nombres`, `apellidos`, `correo`, `contrasena`, `rol`, `escuela`, `telefono`, `activo`, `fecha\_registro`) VALUES

`	`(1, '2022073895', 'diego', 'castillo', 'dc2022073895@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '953095099', 1, '2025-09-30 03:13:27'),

`	`(2, '', 'joan', 'medina', 'joan@upt.pe', '123', 'ADMINISTRADOR', 'EPIS', '953095099', 1, '2025-09-30 03:18:36'),

`	`(3, 'elanchipa', 'victor', 'cruz', 'victor@upt.pe', '123', 'COORDINADOR', 'EPIS', '123456789', 1, '2025-09-30 04:43:19'),

`	`(4, '23000', 'castillo', 'Estrella', 'estrella@upt.pe', '123', 'ESTUDIANTE', 'EPIS', '123123123', 1, '2025-10-16 04:20:42'),

`	`(5, '2019062986', 'Sebastian Rodrigo', 'Arce Bracamonte', 'sa2019062986@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(6, '2017057578', 'Alexsander Wilson', 'Challo Coaquera', 'ac2017057578@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(7, '2020067577', 'Brant Antony', 'Chata Choque', 'bc2020067577@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(8, '2022073903', 'Victor Williams', 'Cruz Mamani', 'vc2022073903@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(9, '2019065161', 'Christian Dennis', 'Hinojosa Mucho', 'ch2019065161@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(10, '2021072615', 'Renzo Fernando', 'Loyola Vilca Choque', 'rl2021072615@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(11, '2012042779', 'Gilmer Donaldo', 'Mamani Condori', 'gm2012042779@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(12, '2022075474', 'Junior', 'Mamani Estaña', 'jm2022075474@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(13, '2022074255', 'Joan Cristian', 'Medina Quispe', 'jm2022074255@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(14, '2022075743', 'Richard Alexis', 'Podesta Condori', 'rp2022075743@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(15, '2022075745', 'Nicole Luciana', 'Rios Cohaila', 'nr2022075745@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(16, '2022073505', 'Augusto Joaquin', 'Rivera Muñoz', 'ar2022073505@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(17, '2022075751', 'Patrick Elvis', 'Rodriguez Cardenas', 'pr2022075751@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(18, '2021072618', 'Jefferson Ronaldihño', 'Rosas Chambilla', 'jr2021072618@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(19, '2022075747', 'Nestor Juice Yomar', 'Serrano Ibañez', 'ns2022075747@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(20, '2022075480', 'Hashira Belen', 'Vargas Candia', 'hv2022075480@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00'),

`	`(21, '2021071090', 'Royser Alonsso', 'Villanueva Mamani', 'rv2021071090@virtual.upt.pe', '123', 'ESTUDIANTE', 'EPIS', '', 1, '2025-10-17 05:00:00');









