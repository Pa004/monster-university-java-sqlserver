SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `monster_university`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aeasi_asign`
--

CREATE TABLE `aeasi_asign` (
  `AEASI_ID` varchar(10) NOT NULL,
  `AEPRER_IDREQUISITO` int(11) DEFAULT NULL,
  `AEASI_CODIGO` varchar(10) NOT NULL,
  `AEASI_NOMBRE` varchar(50) NOT NULL,
  `AEASI_CREDITOS` int(11) NOT NULL,
  `DESCRIPCIONASIGNATURA` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aecar_carrer`
--

CREATE TABLE `aecar_carrer` (
  `IDCARRERA` varchar(10) NOT NULL,
  `NOMBRECARRERA` varchar(50) NOT NULL,
  `CODIGOCARRERA` varchar(10) NOT NULL,
  `MAX_CREDITOSCARRERA` decimal(12,0) NOT NULL,
  `MIN_CREDITOSCARRERA` decimal(12,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aedet_detmatri`
--

CREATE TABLE `aedet_detmatri` (
  `AEDET_ID_DETLL` varchar(10) NOT NULL,
  `AEMAT_ID_MATRICULA` varchar(10) NOT NULL,
  `AEGRU_CODIGO` varchar(20) NOT NULL,
  `AEDET_NOTAFINAL` decimal(10,2) DEFAULT NULL,
  `AEDET_ESTADOASIGNATURA` varchar(32) NOT NULL,
  `AEDET_FECHAINSCRIPCION` date NOT NULL,
  `AEDET_FECHARETIRO` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aeest_estud`
--

CREATE TABLE `aeest_estud` (
  `AEEST_ID` varchar(10) NOT NULL,
  `XEPER_ID` int(11) NOT NULL,
  `IDCARRERA` varchar(10) NOT NULL,
  `AEEST_CODIGO_EST` varchar(9) NOT NULL,
  `AEEST_FECHA_ING_EST` date NOT NULL,
  `AEEST_PROMEDIO` decimal(3,2) NOT NULL,
  `AEEST_ESTADO_PAGO` tinyint(1) NOT NULL,
  `AEEST_ESTUDI` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aegru_grupo`
--

CREATE TABLE `aegru_grupo` (
  `AEGRU_CODIGO` varchar(20) NOT NULL,
  `AEASI_ID` varchar(10) NOT NULL,
  `IDPERIODO` varchar(10) NOT NULL,
  `PEDOC_ID` varchar(10) NOT NULL,
  `AEGRU_AULA` varchar(20) NOT NULL,
  `AEGRU_CUPO_MAX` int(11) NOT NULL,
  `AEGRU_CUPO_ACTUAL` int(11) NOT NULL,
  `HORARIOGRUPO` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aemat_matri`
--

CREATE TABLE `aemat_matri` (
  `AEMAT_ID_MATRICULA` varchar(10) NOT NULL,
  `AEEST_ID` varchar(10) NOT NULL,
  `IDPERIODO` varchar(10) NOT NULL,
  `AEMAT_FECHA_MATRI` date NOT NULL,
  `AEMAT_ESTADO_MATRICULA` varchar(20) NOT NULL,
  `AEMAT_TOTAL_CREDIT_MATRI` int(11) NOT NULL,
  `AEMAT_TOTAL_ASIGNA_MATRI` int(11) NOT NULL,
  `IDCARRERA` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aeper_period`
--

CREATE TABLE `aeper_period` (
  `IDPERIODO` varchar(10) NOT NULL,
  `NOMBREPERIODO` varchar(50) NOT NULL,
  `FECHA_INICIOPERIODO` date NOT NULL,
  `FECHA_FINPERIODO` date NOT NULL,
  `ACTIVOPERIODO` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aeprer_prerre`
--

CREATE TABLE `aeprer_prerre` (
  `AEPRER_IDREQUISITO` int(11) NOT NULL,
  `AEPRER_NOMBREREQUISITO` varchar(64) NOT NULL,
  `AEPRER_TIPO_REQUI` varchar(16) NOT NULL,
  `AEPRER_DESCRIPCIONREQUISITO` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `febec_beca`
--

CREATE TABLE `febec_beca` (
  `FEBEC_CODIGOBECA` char(10) NOT NULL,
  `FEBEC_NOMBREBECA` varchar(50) NOT NULL,
  `FEBEC_DESCRIPCIONB` varchar(100) DEFAULT NULL,
  `FEBEC_PORCENTAJE` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fecaf_cabfac`
--

CREATE TABLE `fecaf_cabfac` (
  `FECAF_NUMFAC` char(6) NOT NULL,
  `FEBEC_CODIGOBECA` char(10) DEFAULT NULL,
  `AEEST_ID` varchar(10) NOT NULL,
  `FECAF_FECEMI` date NOT NULL,
  `FECAF_AUTSRI` varchar(50) DEFAULT NULL,
  `FECAF_FEASRI` datetime DEFAULT NULL,
  `FECAF_IVA` decimal(10,2) NOT NULL,
  `FECAF_DESCUES` decimal(10,2) DEFAULT NULL,
  `FECAF_TOTPAG` decimal(10,2) NOT NULL,
  `FECAF_SUBTOT` decimal(10,2) NOT NULL,
  `FECAF_ESTADO` varchar(25) NOT NULL,
  `IDCARRERA` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fecpo_cpag`
--

CREATE TABLE `fecpo_cpag` (
  `FECPO_CODIGO` char(10) NOT NULL,
  `FECPO_NOMBRE` varchar(50) NOT NULL,
  `FECPO_DESCRIPCION` varchar(100) NOT NULL,
  `FECPO_VALOR` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fedet_deta`
--

CREATE TABLE `fedet_deta` (
  `FEDET_CODIGO` char(10) NOT NULL,
  `FECAF_NUMFAC` char(6) NOT NULL,
  `FECPO_CODIGO` char(10) NOT NULL,
  `FEDET_CANTIDAD` int(11) NOT NULL,
  `FEDET_TOTAL` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fefpg_fpag`
--

CREATE TABLE `fefpg_fpag` (
  `FEFPG_CODIGO` char(10) NOT NULL,
  `FEPAG_CODIGO` char(10) NOT NULL,
  `FEFPG_NOMBRE` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fepag_pago`
--

CREATE TABLE `fepag_pago` (
  `FEPAG_CODIGO` char(10) NOT NULL,
  `FECAF_NUMFAC` char(6) NOT NULL,
  `FEPAG_MONTO` decimal(10,2) NOT NULL,
  `FEPAG_FECHAPAGO` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pecar_cargo`
--

CREATE TABLE `pecar_cargo` (
  `PECAR_CODIGO` varchar(10) NOT NULL,
  `PECAR_NOMBRE` varchar(20) NOT NULL,
  `PECAR_DESCRI` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pecar_cargo`
--

INSERT INTO `pecar_cargo` (`PECAR_CODIGO`, `PECAR_NOMBRE`, `PECAR_DESCRI`) VALUES
('ADMIN', 'Administradora', 'Administradora del s');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedep_depa`
--

CREATE TABLE `pedep_depa` (
  `PEDEP_CODIGO` varchar(10) NOT NULL,
  `PEDEP_NOMBRE` varchar(50) NOT NULL,
  `PEDEP_AREA` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pedep_depa`
--

INSERT INTO `pedep_depa` (`PEDEP_CODIGO`, `PEDEP_NOMBRE`, `PEDEP_AREA`) VALUES
('TI', 'Tecnología de la Información', 'Administrativa');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedoc_docen`
--

CREATE TABLE `pedoc_docen` (
  `PEDOC_ID` varchar(10) NOT NULL,
  `XEPER_ID` int(11) NOT NULL,
  `PEDOC_ESPECIALIDAD` varchar(32) DEFAULT NULL,
  `PEDOC_NIVEL` varchar(32) DEFAULT NULL,
  `PEDOC_ESTADO` varchar(16) DEFAULT NULL,
  `PEDOC_FCH_INICIO` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `peemp_emple`
--

CREATE TABLE `peemp_emple` (
  `PEEMP_CODIGO` varchar(10) NOT NULL,
  `XEPER_ID` int(11) NOT NULL,
  `PEDEP_CODIGO` varchar(10) NOT NULL,
  `PECAR_CODIGO` varchar(10) NOT NULL,
  `PEEMP_CARGAS` decimal(2,0) NOT NULL,
  `PEEMP_FECHAINGRESO` date NOT NULL,
  `PEEMP_JORNADALABORAL` varchar(64) NOT NULL,
  `PEEMP_ESTADOEMPLEADO` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `peemp_emple`
--

INSERT INTO `peemp_emple` (`PEEMP_CODIGO`, `XEPER_ID`, `PEDEP_CODIGO`, `PECAR_CODIGO`, `PEEMP_CARGAS`, `PEEMP_FECHAINGRESO`, `PEEMP_JORNADALABORAL`, `PEEMP_ESTADOEMPLEADO`) VALUES
('EMP001', 1, 'TI', 'ADMIN', 0, '2020-03-15', 'Tiempo Completo - 8h', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `peesc_estciv`
--

CREATE TABLE `peesc_estciv` (
  `PEESC_CODIGO` char(1) NOT NULL,
  `PEESC_DESCRI` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `peesc_estciv`
--

INSERT INTO `peesc_estciv` (`PEESC_CODIGO`, `PEESC_DESCRI`) VALUES
('C', 'Casado/a'),
('D', 'Divorciado/a'),
('S', 'Soltero/a'),
('U', 'Unión Libre'),
('V', 'Viudo/a');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pesex_sexo`
--

CREATE TABLE `pesex_sexo` (
  `PESEX_CODIGO` varchar(10) NOT NULL,
  `PESEX_DESCRI` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pesex_sexo`
--

INSERT INTO `pesex_sexo` (`PESEX_CODIGO`, `PESEX_DESCRI`) VALUES
('F', 'Femenino'),
('M', 'Masculino');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xeacu_usr_acade`
--

CREATE TABLE `xeacu_usr_acade` (
  `XEUSU_ID_USUARIO` int(11) NOT NULL,
  `TIPO` varchar(20) NOT NULL,
  `ID_ACADEMICO` varchar(20) NOT NULL,
  `FECCRE` timestamp NOT NULL DEFAULT current_timestamp(),
  `FECMOD` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `xeacu_usr_acade`
--

INSERT INTO `xeacu_usr_acade` (`XEUSU_ID_USUARIO`, `TIPO`, `ID_ACADEMICO`, `FECCRE`, `FECMOD`) VALUES
(15, 'ESTUDIANTE', 'E00000002', '2025-12-12 01:56:58', NULL),
(23, 'ADMINISTRADOR', 'A00000001', '2025-12-12 06:22:09', NULL),
(24, 'SECRETARIO_ACADEMICO', 'S00000001', '2025-12-12 06:30:40', '2025-12-12 06:38:08'),
(25, 'DOCENTE', 'D00000002', '2025-12-12 13:13:16', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xeest_estad`
--

CREATE TABLE `xeest_estad` (
  `XEEST_CODIGO` char(1) NOT NULL,
  `XEEST_DESCRI` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `xeest_estad`
--

INSERT INTO `xeest_estad` (`XEEST_CODIGO`, `XEEST_DESCRI`) VALUES
('A', 'Activo'),
('B', 'Bloqueado'),
('I', 'Inactivo'),
('S', 'Suspendido');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xeopc_opcio`
--

CREATE TABLE `xeopc_opcio` (
  `XEOPC_CODIGO` char(3) NOT NULL,
  `XESIS_CODIGO` char(1) NOT NULL,
  `XEOPC_DESCRI` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `xeopc_opcio`
--

INSERT INTO `xeopc_opcio` (`XEOPC_CODIGO`, `XESIS_CODIGO`, `XEOPC_DESCRI`) VALUES
('A01', 'A', 'Gestión de Estudiantes'),
('A02', 'A', 'Gestión de Matrículas'),
('A03', 'A', 'Gestión de Notas'),
('A04', 'A', 'Gestión de Horarios'),
('A05', 'A', 'Gestión de Docentes'),
('A06', 'A', 'Gestión de Asignaturas'),
('F01', 'F', 'Gestión de Pagos'),
('F02', 'F', 'Facturación'),
('F03', 'F', 'Gestión de Becas'),
('F04', 'F', 'Reportes Financieros'),
('G01', 'G', 'Gestión de Usuarios'),
('G02', 'G', 'Gestión de Perfiles'),
('G03', 'G', 'Gestión de Permisos'),
('G04', 'G', 'Configuración del Sistema'),
('R01', 'R', 'Reportes Académicos'),
('R02', 'R', 'Reportes Financieros'),
('R03', 'R', 'Reportes Estadísticos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xeoxp_opcpe`
--

CREATE TABLE `xeoxp_opcpe` (
  `XEOPC_CODIGO` char(3) NOT NULL,
  `XEPER_CODIGO` char(8) NOT NULL,
  `XEOXP_FECASI` date NOT NULL,
  `XEOXP_FECRET` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `xeoxp_opcpe`
--

INSERT INTO `xeoxp_opcpe` (`XEOPC_CODIGO`, `XEPER_CODIGO`, `XEOXP_FECASI`, `XEOXP_FECRET`) VALUES
('A01', 'ADMIN001', '2025-12-08', NULL),
('A01', 'SECRE001', '2025-12-08', NULL),
('A02', 'ADMIN001', '2025-12-08', NULL),
('A02', 'ESTUD001', '2025-12-08', NULL),
('A02', 'SECRE001', '2025-12-08', NULL),
('A03', 'ADMIN001', '2025-12-08', NULL),
('A03', 'DOCEN001', '2025-12-08', NULL),
('A04', 'ADMIN001', '2025-12-08', NULL),
('A04', 'DOCEN001', '2025-12-08', NULL),
('A04', 'ESTUD001', '2025-12-08', NULL),
('A04', 'SECRE001', '2025-12-08', NULL),
('A05', 'ADMIN001', '2025-12-08', NULL),
('A06', 'ADMIN001', '2025-12-08', NULL),
('F01', 'ADMIN001', '2025-12-08', NULL),
('F02', 'ADMIN001', '2025-12-08', NULL),
('F03', 'ADMIN001', '2025-12-08', NULL),
('F04', 'ADMIN001', '2025-12-08', NULL),
('G01', 'ADMIN001', '2025-12-08', NULL),
('G02', 'ADMIN001', '2025-12-08', NULL),
('G03', 'ADMIN001', '2025-12-08', NULL),
('G04', 'ADMIN001', '2025-12-08', NULL),
('R01', 'ADMIN001', '2025-12-08', NULL),
('R01', 'DOCEN001', '2025-12-08', NULL),
('R01', 'SECRE001', '2025-12-08', NULL),
('R02', 'ADMIN001', '2025-12-08', NULL),
('R03', 'ADMIN001', '2025-12-08', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xeper_perfi`
--

CREATE TABLE `xeper_perfi` (
  `XEPER_CODIGO` char(8) NOT NULL,
  `XEPER_DESCRI` varchar(100) NOT NULL,
  `XEPER_OBSER` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `xeper_perfi`
--

INSERT INTO `xeper_perfi` (`XEPER_CODIGO`, `XEPER_DESCRI`, `XEPER_OBSER`) VALUES
('ADMIN001', 'Administrador del Sistema', 'Acceso completo a todas las funcionalidades'),
('DOCEN001', 'Docente', 'Registro de notas y consulta de información académica'),
('ESTUD001', 'Estudiante', 'Consulta de notas, horarios y matrículas'),
('SECRE001', 'Secretario Académico', 'Gestión de matrículas y estudiantes');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xeper_persona`
--

CREATE TABLE `xeper_persona` (
  `XEPER_ID` int(11) NOT NULL,
  `PEESC_CODIGO` char(1) NOT NULL,
  `PESEX_CODIGO` varchar(10) NOT NULL,
  `XEPER_CEDULA` varchar(10) DEFAULT NULL,
  `XEPER_NOMBRES` varchar(128) NOT NULL,
  `XEPER_APELLIDOS` varchar(128) NOT NULL,
  `XEPER_FECHANAC` date NOT NULL,
  `XEPER_DIRECCION` varchar(264) DEFAULT NULL,
  `XEPER_TELEFONO` varchar(10) DEFAULT NULL,
  `XEPER_EMAIL` varchar(128) NOT NULL,
  `XEPER_FECREGISTRO` datetime NOT NULL,
  `XEPER_TIPO_PERSONA` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `xeper_persona`
--

INSERT INTO `xeper_persona` (`XEPER_ID`, `PEESC_CODIGO`, `PESEX_CODIGO`, `XEPER_CEDULA`, `XEPER_NOMBRES`, `XEPER_APELLIDOS`, `XEPER_FECHANAC`, `XEPER_DIRECCION`, `XEPER_TELEFONO`, `XEPER_EMAIL`, `XEPER_FECREGISTRO`, `XEPER_TIPO_PERSONA`) VALUES
(2, 'S', 'M', '1234567890', 'Administrador', 'del Sistema', '1990-01-01', 'Monster University Campus', '0987654321', 'admin@monsteru.edu.ec', '2025-12-08 10:27:32', 'U'),
(3, 'S', 'F', '0987654321', 'María', 'González', '1985-05-15', NULL, NULL, 'maria.gonzalez@monsteru.edu.ec', '2025-12-08 10:27:33', 'U'),
(4, 'C', 'M', '1122334455', 'Carlos', 'Rodríguez', '1980-08-20', 'Guayaquil, Ecuador', '0998765432', 'carlos.rodriguez@monsteru.edu.ec', '2025-12-08 10:27:34', 'U'),
(5, 'S', 'F', '2233445566', 'Ana', 'Martínez', '2002-03-10', NULL, NULL, 'ana.martinez@estudiante.monsteru.edu.ec', '2025-12-08 10:27:34', 'U'),
(12, 'S', 'M', '1719150499', 'Juan Diego', 'Quimbiulco', '2001-02-05', 'Calderon', '0963920341', 'juandiegoq21@gmail.com', '2025-12-09 23:07:55', 'U'),
(14, 'S', 'M', '1711300348', 'Pablo Alejandro', 'Dominguez', '2003-02-05', 'Calderon', '0963920350', 'pablitz@gmail.com', '2025-12-09 23:54:03', 'U'),
(15, 'S', 'M', '1711300343', 'Pablito Diego', 'Lopez Dominguez', '2004-02-05', NULL, NULL, 'pablitoz@gmail.com', '2025-12-09 23:56:56', 'U'),
(16, 'U', 'M', '1716300342', 'Steven Gusttavo', 'Guaico Molinas', '2001-09-11', 'CarapungoCity', '0963920312', 'guaico@gmail.com', '2025-12-10 12:41:47', 'U'),
(17, 'S', 'M', '1711300349', 'Alfredo Isai', 'Palacios Mercedes', '2001-02-05', 'Calderon', '0963920360', 'juan_quimbiu@gmai.com', '2025-12-11 19:15:44', 'U'),
(18, 'S', 'M', '1719150590', 'Hendry David', 'Quimbiulco Carrion', '2001-02-05', 'Carapungo', '0963920840', 'hemdri@gmail.com', '2025-12-11 20:56:57', 'U'),
(19, 'S', 'M', '1711300328', 'Person Hash', 'Hasher', '2003-02-05', 'Sangolqui', '0963982345', 'personalNuevo@gmail.com', '2025-12-11 21:28:34', 'U'),
(20, 'C', 'M', '1711300453', 'Juanito Dereck', 'Alfredo', '2005-02-05', 'Sangolquis', '0963920342', 'jdquimbiulco@espe.edu.ec', '2025-12-11 21:36:38', 'U'),
(21, 'C', 'M', '1719150480', 'Juanito', 'Testo', '2001-02-05', NULL, NULL, 'jdquimbiulco@espe.edu.ec', '2025-12-11 23:48:43', 'U'),
(22, 'S', 'M', '1719150423', 'Juan Pablo', 'Carrioncin', '2001-02-05', 'Calderon', '0963924569', 'jdquimbiulco@espe.edu.ec', '2025-12-12 00:20:09', 'U'),
(23, 'C', 'M', '1711300345', 'Pedro', 'Pascal', '2001-02-05', 'Calderon', '0963940569', 'jdquimbiulco@espe.edu.ec', '2025-12-12 00:27:16', 'U'),
(24, 'C', 'F', '1711300543', 'Testo Tester', 'Alfreds', '2001-02-05', NULL, NULL, 'jdquimbiulco@espe.edu.ec', '2025-12-12 00:58:21', 'U'),
(25, 'S', 'M', '1711300400', 'Pedro', 'Pedrito', '2001-02-05', NULL, NULL, 'jdquimbiulco@espe.edu.ec', '2025-12-12 01:12:30', 'U'),
(26, 'S', 'M', '1523120934', 'Daniela', 'white', '2001-03-05', NULL, NULL, 'jdquimbiulco@espe.edu.co', '2025-12-12 01:22:08', 'U'),
(27, 'C', 'M', '1922300242', 'Jerson', 'Llumiquinga', '2001-02-05', NULL, NULL, 'jdquimbiulco@espe', '2025-12-12 01:30:38', 'U'),
(28, 'S', 'M', '1711300218', 'Pablito Alejo', 'Dominguez de las Mercedes', '2004-01-02', 'Sangolqui', '0963067515', 'padominguez@espe.edu.ec', '2025-12-12 08:13:15', 'U');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xesec_secuencias`
--

CREATE TABLE `xesec_secuencias` (
  `TIPO` varchar(20) NOT NULL,
  `ULTIMO_NUMERO` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `xesec_secuencias`
--

INSERT INTO `xesec_secuencias` (`TIPO`, `ULTIMO_NUMERO`) VALUES
('ADMINISTRADOR', 1),
('DOCENTE', 2),
('ESTUDIANTE', 3),
('SECRETARIO', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xesis_siste`
--

CREATE TABLE `xesis_siste` (
  `XESIS_CODIGO` char(1) NOT NULL,
  `XESIS_DESCRI` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `xesis_siste`
--

INSERT INTO `xesis_siste` (`XESIS_CODIGO`, `XESIS_DESCRI`) VALUES
('A', 'Sistema Académico'),
('F', 'Sistema Financiero'),
('G', 'Sistema de Gestión'),
('R', 'Sistema de Reportes');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xetrec_tokenrec`
--

CREATE TABLE `xetrec_tokenrec` (
  `XETREC_ID` int(11) NOT NULL,
  `XEUSU_ID_USUARIO` int(11) NOT NULL,
  `XETREC_TOKEN` varchar(255) NOT NULL,
  `XETREC_CREACION` datetime DEFAULT current_timestamp(),
  `XETREC_EXPIRACION` datetime NOT NULL,
  `XETREC_USADO` char(1) DEFAULT 'N' COMMENT 'S = Usado, N = No usado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xeusu_usuar`
--

CREATE TABLE `xeusu_usuar` (
  `XEUSU_ID_USUARIO` int(11) NOT NULL,
  `XEPER_ID` int(11) NOT NULL,
  `XEEST_CODIGO` char(1) NOT NULL,
  `PEEMP_CODIGO` varchar(10) DEFAULT NULL,
  `XEUSU_USERNAME` varchar(32) NOT NULL,
  `PASSWORDHASH` varchar(255) NOT NULL,
  `EMAIL_USUARIO` varchar(128) DEFAULT NULL,
  `XEUSU_PIEFIR` varchar(100) DEFAULT NULL,
  `XEUSU_FECCRE` datetime NOT NULL,
  `XEUSU_FECMOD` datetime DEFAULT NULL,
  `FOTO_PATH` varchar(300) DEFAULT NULL,
  `PRIMER_INGRESO` char(1) DEFAULT 'S' COMMENT 'S=Primer ingreso, N=No es primer ingreso',
  `CONTRASEÑA_TEMPORAL` char(1) DEFAULT 'N' COMMENT 'S=Contraseña temporal, N=Contraseña normal'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `xeusu_usuar`
--

INSERT INTO `xeusu_usuar` (`XEUSU_ID_USUARIO`, `XEPER_ID`, `XEEST_CODIGO`, `PEEMP_CODIGO`, `XEUSU_USERNAME`, `PASSWORDHASH`, `EMAIL_USUARIO`, `XEUSU_PIEFIR`, `XEUSU_FECCRE`, `XEUSU_FECMOD`, `FOTO_PATH`, `PRIMER_INGRESO`, `CONTRASEÑA_TEMPORAL`) VALUES
(2, 2, 'A', NULL, 'admin', 'PBKDF2$120000$y+pSoMv1+Xc9M7eSq8j6Rw==$uxJpFyzSMyiKSMG5gElIGMoZ5U59RBnKhbq/WDucZHk=', 'admin@monsteru.edu.ec', NULL, '2025-12-08 10:27:33', '2025-12-11 23:42:06', NULL, 'N', 'N'),
(15, 18, 'A', NULL, 'hquimbiulco', '092340', 'hendry@monsteru.edu.ec', NULL, '2025-12-11 20:56:58', NULL, 'uploads/fotos/68152c6e-f12d-47cd-b33a-5d438bd0151c.jpg', 'S', 'N'),
(19, 22, 'A', NULL, 'juanpa', 'PBKDF2$120000$kc7X95UnEuatm09ORbRxCQ==$qey7YcTnhV85eqicTW9sEiUWR844iLVwh5grbYYOzKs=', 'juanpa@monsteru.edu.ec', NULL, '2025-12-12 00:20:10', NULL, 'uploads/fotos/69deacb4-b0a3-46ef-84d2-c634f2248592.jpg', 'S', 'N'),
(20, 23, 'A', NULL, 'alfred', 'PBKDF2$120000$inoWry1D9IcoaUEu/BOnGg==$sfajGC3YGKHuv5n0M9HPpCkzA51x2RD9iONAVUDCuks=', 'alfred@monsteru.edu.ec', NULL, '2025-12-12 00:27:17', NULL, 'uploads/fotos/e8fca41c-13fd-482c-926c-37076afb5f75.jpg', 'S', 'N'),
(21, 24, 'A', NULL, 'yapi', 'PBKDF2$120000$oyvgpTjdZ+ecallQctLEfg==$KPy9B6lMbXrrHkcSDcrSp17Km6ICdt/fBvwh5Toaua0=', 'yapi@monsteru.edu.ec', NULL, '2025-12-12 00:58:22', '2025-12-12 00:59:00', 'uploads/fotos/f81270bb-75a9-4cad-b9de-08c0e4d891b0.jpg', 'S', 'N'),
(22, 25, 'A', NULL, 'pdrito', 'PBKDF2$120000$cJP5buqx37Ul4W6QLpwU7Q==$3GGLwerIYpCUzb4vpndwio3qytgmS1Y1M4V2gczL7LQ=', 'pedro@monsteru.edu.ec', NULL, '2025-12-12 01:12:31', '2025-12-12 01:28:21', 'uploads/fotos/6014e997-4861-4b3c-a878-5ae88d3776fd.jpg', 'S', 'N'),
(23, 26, 'A', NULL, 'daniela', 'PBKDF2$120000$vrOS23XaLajVlL4Yi9m71g==$VFkBfPnGGOo/8yx1lQeEjb9NgVBa2pt0LB4PdHlKcWQ=', 'daniela@monsteru.edu.ec', NULL, '2025-12-12 01:22:09', '2025-12-12 01:23:14', 'uploads/fotos/f68a7054-1a71-4324-ba51-dfd292500a63.jpg', 'S', 'N'),
(24, 27, 'A', NULL, 'jerson', 'PBKDF2$120000$yyM3DMoVw6sNzKM27FQukQ==$gzQbbszxhhd0hUgWRR2NTn/at+59mhsX2wc51Jnb6Ko=', 'jseron@monsteru.edu.ec', NULL, '2025-12-12 01:30:40', '2025-12-12 01:38:07', 'uploads/fotos/7cfbabab-5888-44f0-b82f-555381e1c83e.jpg', 'S', 'N'),
(25, 28, 'A', NULL, 'padominguez', 'PBKDF2$120000$udSUPzajr/inuFuuYhW5QQ==$V+Z/ek8K+S3NdglZmPZUQ/X42sxXJ6Grne8Q83ZAj4o=', 'pdominguez@monsteru.edu.ec', NULL, '2025-12-12 08:13:16', '2025-12-12 08:15:45', 'uploads/fotos/7cd8a6fe-77da-48d8-ac90-221daa61c08b.jpg', 'S', 'S');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xeuxp_usupe`
--

CREATE TABLE `xeuxp_usupe` (
  `XEUSU_ID_USUARIO` int(11) NOT NULL,
  `XEPER_CODIGO` char(8) NOT NULL,
  `XEUXP_FECASI` date NOT NULL,
  `XEUXP_FECRET` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `xeuxp_usupe`
--

INSERT INTO `xeuxp_usupe` (`XEUSU_ID_USUARIO`, `XEPER_CODIGO`, `XEUXP_FECASI`, `XEUXP_FECRET`) VALUES
(2, 'ADMIN001', '2025-12-08', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `aeasi_asign`
--
ALTER TABLE `aeasi_asign`
  ADD PRIMARY KEY (`AEASI_ID`),
  ADD UNIQUE KEY `UK_ASIGN_CODIGO` (`AEASI_CODIGO`),
  ADD KEY `FK_ASIGN_PREREQ` (`AEPRER_IDREQUISITO`);

--
-- Indices de la tabla `aecar_carrer`
--
ALTER TABLE `aecar_carrer`
  ADD PRIMARY KEY (`IDCARRERA`),
  ADD UNIQUE KEY `UK_CARRERA_CODIGO` (`CODIGOCARRERA`);

--
-- Indices de la tabla `aedet_detmatri`
--
ALTER TABLE `aedet_detmatri`
  ADD PRIMARY KEY (`AEDET_ID_DETLL`),
  ADD KEY `FK_DETMAT_MATRI` (`AEMAT_ID_MATRICULA`),
  ADD KEY `FK_DETMAT_GRUPO` (`AEGRU_CODIGO`);

--
-- Indices de la tabla `aeest_estud`
--
ALTER TABLE `aeest_estud`
  ADD PRIMARY KEY (`AEEST_ID`),
  ADD UNIQUE KEY `UK_ESTUDIANTE_CODIGO` (`AEEST_CODIGO_EST`),
  ADD KEY `FK_ESTU_PERSONA` (`XEPER_ID`),
  ADD KEY `FK_ESTU_CARRERA` (`IDCARRERA`);

--
-- Indices de la tabla `aegru_grupo`
--
ALTER TABLE `aegru_grupo`
  ADD PRIMARY KEY (`AEGRU_CODIGO`),
  ADD KEY `FK_GRUPO_ASIGN` (`AEASI_ID`),
  ADD KEY `FK_GRUPO_PERIODO` (`IDPERIODO`),
  ADD KEY `FK_GRUPO_DOCENTE` (`PEDOC_ID`);

--
-- Indices de la tabla `aemat_matri`
--
ALTER TABLE `aemat_matri`
  ADD PRIMARY KEY (`AEMAT_ID_MATRICULA`),
  ADD KEY `FK_MATRI_ESTU` (`AEEST_ID`),
  ADD KEY `FK_MATRI_PERIODO` (`IDPERIODO`),
  ADD KEY `FK_MATRI_CARRERA` (`IDCARRERA`);

--
-- Indices de la tabla `aeper_period`
--
ALTER TABLE `aeper_period`
  ADD PRIMARY KEY (`IDPERIODO`);

--
-- Indices de la tabla `aeprer_prerre`
--
ALTER TABLE `aeprer_prerre`
  ADD PRIMARY KEY (`AEPRER_IDREQUISITO`);

--
-- Indices de la tabla `febec_beca`
--
ALTER TABLE `febec_beca`
  ADD PRIMARY KEY (`FEBEC_CODIGOBECA`);

--
-- Indices de la tabla `fecaf_cabfac`
--
ALTER TABLE `fecaf_cabfac`
  ADD PRIMARY KEY (`FECAF_NUMFAC`),
  ADD KEY `FK_CABFAC_ESTU` (`AEEST_ID`),
  ADD KEY `FK_CABFAC_BECA` (`FEBEC_CODIGOBECA`),
  ADD KEY `FK_CABFAC_CARRERA` (`IDCARRERA`);

--
-- Indices de la tabla `fecpo_cpag`
--
ALTER TABLE `fecpo_cpag`
  ADD PRIMARY KEY (`FECPO_CODIGO`);

--
-- Indices de la tabla `fedet_deta`
--
ALTER TABLE `fedet_deta`
  ADD PRIMARY KEY (`FEDET_CODIGO`),
  ADD KEY `FK_DETA_CABFAC` (`FECAF_NUMFAC`),
  ADD KEY `FK_DETA_CONCEP` (`FECPO_CODIGO`);

--
-- Indices de la tabla `fefpg_fpag`
--
ALTER TABLE `fefpg_fpag`
  ADD PRIMARY KEY (`FEFPG_CODIGO`),
  ADD KEY `FK_FPAG_PAGO` (`FEPAG_CODIGO`);

--
-- Indices de la tabla `fepag_pago`
--
ALTER TABLE `fepag_pago`
  ADD PRIMARY KEY (`FEPAG_CODIGO`),
  ADD KEY `FK_PAGO_CABFAC` (`FECAF_NUMFAC`);

--
-- Indices de la tabla `pecar_cargo`
--
ALTER TABLE `pecar_cargo`
  ADD PRIMARY KEY (`PECAR_CODIGO`);

--
-- Indices de la tabla `pedep_depa`
--
ALTER TABLE `pedep_depa`
  ADD PRIMARY KEY (`PEDEP_CODIGO`);

--
-- Indices de la tabla `pedoc_docen`
--
ALTER TABLE `pedoc_docen`
  ADD PRIMARY KEY (`PEDOC_ID`),
  ADD KEY `FK_DOCENTE_PERSONA` (`XEPER_ID`);

--
-- Indices de la tabla `peemp_emple`
--
ALTER TABLE `peemp_emple`
  ADD PRIMARY KEY (`PEEMP_CODIGO`),
  ADD KEY `FK_EMPLE_PERSONA` (`XEPER_ID`),
  ADD KEY `FK_EMPLE_DEPA` (`PEDEP_CODIGO`),
  ADD KEY `FK_EMPLE_CARGO` (`PECAR_CODIGO`);

--
-- Indices de la tabla `peesc_estciv`
--
ALTER TABLE `peesc_estciv`
  ADD PRIMARY KEY (`PEESC_CODIGO`);

--
-- Indices de la tabla `pesex_sexo`
--
ALTER TABLE `pesex_sexo`
  ADD PRIMARY KEY (`PESEX_CODIGO`);

--
-- Indices de la tabla `xeacu_usr_acade`
--
ALTER TABLE `xeacu_usr_acade`
  ADD PRIMARY KEY (`XEUSU_ID_USUARIO`),
  ADD UNIQUE KEY `UQ_XEACU_ID_ACADEMICO` (`ID_ACADEMICO`),
  ADD KEY `IDX_XEACU_TIPO` (`TIPO`);

--
-- Indices de la tabla `xeest_estad`
--
ALTER TABLE `xeest_estad`
  ADD PRIMARY KEY (`XEEST_CODIGO`);

--
-- Indices de la tabla `xeopc_opcio`
--
ALTER TABLE `xeopc_opcio`
  ADD PRIMARY KEY (`XEOPC_CODIGO`),
  ADD KEY `FK_XESIS_OPC` (`XESIS_CODIGO`);

--
-- Indices de la tabla `xeoxp_opcpe`
--
ALTER TABLE `xeoxp_opcpe`
  ADD PRIMARY KEY (`XEOPC_CODIGO`,`XEPER_CODIGO`),
  ADD KEY `FK_PERFIL_OPCPER` (`XEPER_CODIGO`);

--
-- Indices de la tabla `xeper_perfi`
--
ALTER TABLE `xeper_perfi`
  ADD PRIMARY KEY (`XEPER_CODIGO`);

--
-- Indices de la tabla `xeper_persona`
--
ALTER TABLE `xeper_persona`
  ADD PRIMARY KEY (`XEPER_ID`),
  ADD UNIQUE KEY `UK_PERSONA_CEDULA` (`XEPER_CEDULA`),
  ADD KEY `FK_PERSONA_ESTCIV` (`PEESC_CODIGO`),
  ADD KEY `FK_PERSONA_SEXO` (`PESEX_CODIGO`);

--
-- Indices de la tabla `xesec_secuencias`
--
ALTER TABLE `xesec_secuencias`
  ADD PRIMARY KEY (`TIPO`);

--
-- Indices de la tabla `xesis_siste`
--
ALTER TABLE `xesis_siste`
  ADD PRIMARY KEY (`XESIS_CODIGO`);

--
-- Indices de la tabla `xetrec_tokenrec`
--
ALTER TABLE `xetrec_tokenrec`
  ADD PRIMARY KEY (`XETREC_ID`),
  ADD UNIQUE KEY `XETREC_TOKEN` (`XETREC_TOKEN`),
  ADD KEY `IDX_TOKEN_USUARIO` (`XEUSU_ID_USUARIO`),
  ADD KEY `IDX_TOKEN_CODIGO` (`XETREC_TOKEN`),
  ADD KEY `IDX_TOKEN_EXPIRACION` (`XETREC_EXPIRACION`);

--
-- Indices de la tabla `xeusu_usuar`
--
ALTER TABLE `xeusu_usuar`
  ADD PRIMARY KEY (`XEUSU_ID_USUARIO`),
  ADD UNIQUE KEY `UK_USUARIO_USERNAME` (`XEUSU_USERNAME`),
  ADD KEY `FK_USU_PERSONA` (`XEPER_ID`),
  ADD KEY `FK_USU_ESTADO` (`XEEST_CODIGO`),
  ADD KEY `FK_USU_EMPLE` (`PEEMP_CODIGO`);

--
-- Indices de la tabla `xeuxp_usupe`
--
ALTER TABLE `xeuxp_usupe`
  ADD PRIMARY KEY (`XEUSU_ID_USUARIO`,`XEPER_CODIGO`),
  ADD KEY `FK_USUPE_PERFIL` (`XEPER_CODIGO`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `xeper_persona`
--
ALTER TABLE `xeper_persona`
  MODIFY `XEPER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `xetrec_tokenrec`
--
ALTER TABLE `xetrec_tokenrec`
  MODIFY `XETREC_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `xeusu_usuar`
--
ALTER TABLE `xeusu_usuar`
  MODIFY `XEUSU_ID_USUARIO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `aeasi_asign`
--
ALTER TABLE `aeasi_asign`
  ADD CONSTRAINT `FK_ASIGN_PREREQ` FOREIGN KEY (`AEPRER_IDREQUISITO`) REFERENCES `aeprer_prerre` (`AEPRER_IDREQUISITO`);

--
-- Filtros para la tabla `aedet_detmatri`
--
ALTER TABLE `aedet_detmatri`
  ADD CONSTRAINT `FK_DETMAT_GRUPO` FOREIGN KEY (`AEGRU_CODIGO`) REFERENCES `aegru_grupo` (`AEGRU_CODIGO`),
  ADD CONSTRAINT `FK_DETMAT_MATRI` FOREIGN KEY (`AEMAT_ID_MATRICULA`) REFERENCES `aemat_matri` (`AEMAT_ID_MATRICULA`) ON DELETE CASCADE;

--
-- Filtros para la tabla `aeest_estud`
--
ALTER TABLE `aeest_estud`
  ADD CONSTRAINT `FK_ESTU_CARRERA` FOREIGN KEY (`IDCARRERA`) REFERENCES `aecar_carrer` (`IDCARRERA`),
  ADD CONSTRAINT `FK_ESTU_PERSONA` FOREIGN KEY (`XEPER_ID`) REFERENCES `xeper_persona` (`XEPER_ID`);

--
-- Filtros para la tabla `aegru_grupo`
--
ALTER TABLE `aegru_grupo`
  ADD CONSTRAINT `FK_GRUPO_ASIGN` FOREIGN KEY (`AEASI_ID`) REFERENCES `aeasi_asign` (`AEASI_ID`),
  ADD CONSTRAINT `FK_GRUPO_DOCENTE` FOREIGN KEY (`PEDOC_ID`) REFERENCES `pedoc_docen` (`PEDOC_ID`),
  ADD CONSTRAINT `FK_GRUPO_PERIODO` FOREIGN KEY (`IDPERIODO`) REFERENCES `aeper_period` (`IDPERIODO`);

--
-- Filtros para la tabla `aemat_matri`
--
ALTER TABLE `aemat_matri`
  ADD CONSTRAINT `FK_MATRI_CARRERA` FOREIGN KEY (`IDCARRERA`) REFERENCES `aecar_carrer` (`IDCARRERA`),
  ADD CONSTRAINT `FK_MATRI_ESTU` FOREIGN KEY (`AEEST_ID`) REFERENCES `aeest_estud` (`AEEST_ID`),
  ADD CONSTRAINT `FK_MATRI_PERIODO` FOREIGN KEY (`IDPERIODO`) REFERENCES `aeper_period` (`IDPERIODO`);

--
-- Filtros para la tabla `fecaf_cabfac`
--
ALTER TABLE `fecaf_cabfac`
  ADD CONSTRAINT `FK_CABFAC_BECA` FOREIGN KEY (`FEBEC_CODIGOBECA`) REFERENCES `febec_beca` (`FEBEC_CODIGOBECA`),
  ADD CONSTRAINT `FK_CABFAC_CARRERA` FOREIGN KEY (`IDCARRERA`) REFERENCES `aecar_carrer` (`IDCARRERA`),
  ADD CONSTRAINT `FK_CABFAC_ESTU` FOREIGN KEY (`AEEST_ID`) REFERENCES `aeest_estud` (`AEEST_ID`);

--
-- Filtros para la tabla `fedet_deta`
--
ALTER TABLE `fedet_deta`
  ADD CONSTRAINT `FK_DETA_CABFAC` FOREIGN KEY (`FECAF_NUMFAC`) REFERENCES `fecaf_cabfac` (`FECAF_NUMFAC`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_DETA_CONCEP` FOREIGN KEY (`FECPO_CODIGO`) REFERENCES `fecpo_cpag` (`FECPO_CODIGO`);

--
-- Filtros para la tabla `fefpg_fpag`
--
ALTER TABLE `fefpg_fpag`
  ADD CONSTRAINT `FK_FPAG_PAGO` FOREIGN KEY (`FEPAG_CODIGO`) REFERENCES `fepag_pago` (`FEPAG_CODIGO`);

--
-- Filtros para la tabla `fepag_pago`
--
ALTER TABLE `fepag_pago`
  ADD CONSTRAINT `FK_PAGO_CABFAC` FOREIGN KEY (`FECAF_NUMFAC`) REFERENCES `fecaf_cabfac` (`FECAF_NUMFAC`);

--
-- Filtros para la tabla `pedoc_docen`
--
ALTER TABLE `pedoc_docen`
  ADD CONSTRAINT `FK_DOCENTE_PERSONA` FOREIGN KEY (`XEPER_ID`) REFERENCES `xeper_persona` (`XEPER_ID`);

--
-- Filtros para la tabla `peemp_emple`
--
ALTER TABLE `peemp_emple`
  ADD CONSTRAINT `FK_EMPLE_CARGO` FOREIGN KEY (`PECAR_CODIGO`) REFERENCES `pecar_cargo` (`PECAR_CODIGO`),
  ADD CONSTRAINT `FK_EMPLE_DEPA` FOREIGN KEY (`PEDEP_CODIGO`) REFERENCES `pedep_depa` (`PEDEP_CODIGO`),
  ADD CONSTRAINT `FK_EMPLE_PERSONA` FOREIGN KEY (`XEPER_ID`) REFERENCES `xeper_persona` (`XEPER_ID`);

--
-- Filtros para la tabla `xeacu_usr_acade`
--
ALTER TABLE `xeacu_usr_acade`
  ADD CONSTRAINT `FK_XEACU_USR` FOREIGN KEY (`XEUSU_ID_USUARIO`) REFERENCES `xeusu_usuar` (`XEUSU_ID_USUARIO`) ON DELETE CASCADE;

--
-- Filtros para la tabla `xeopc_opcio`
--
ALTER TABLE `xeopc_opcio`
  ADD CONSTRAINT `FK_XESIS_OPC` FOREIGN KEY (`XESIS_CODIGO`) REFERENCES `xesis_siste` (`XESIS_CODIGO`);

--
-- Filtros para la tabla `xeoxp_opcpe`
--
ALTER TABLE `xeoxp_opcpe`
  ADD CONSTRAINT `FK_OPCION_OPCPER` FOREIGN KEY (`XEOPC_CODIGO`) REFERENCES `xeopc_opcio` (`XEOPC_CODIGO`),
  ADD CONSTRAINT `FK_PERFIL_OPCPER` FOREIGN KEY (`XEPER_CODIGO`) REFERENCES `xeper_perfi` (`XEPER_CODIGO`);

--
-- Filtros para la tabla `xeper_persona`
--
ALTER TABLE `xeper_persona`
  ADD CONSTRAINT `FK_PERSONA_ESTCIV` FOREIGN KEY (`PEESC_CODIGO`) REFERENCES `peesc_estciv` (`PEESC_CODIGO`),
  ADD CONSTRAINT `FK_PERSONA_SEXO` FOREIGN KEY (`PESEX_CODIGO`) REFERENCES `pesex_sexo` (`PESEX_CODIGO`);

--
-- Filtros para la tabla `xetrec_tokenrec`
--
ALTER TABLE `xetrec_tokenrec`
  ADD CONSTRAINT `FK_TOKEN_USUARIO` FOREIGN KEY (`XEUSU_ID_USUARIO`) REFERENCES `xeusu_usuar` (`XEUSU_ID_USUARIO`) ON DELETE CASCADE;

--
-- Filtros para la tabla `xeusu_usuar`
--
ALTER TABLE `xeusu_usuar`
  ADD CONSTRAINT `FK_USU_EMPLE` FOREIGN KEY (`PEEMP_CODIGO`) REFERENCES `peemp_emple` (`PEEMP_CODIGO`),
  ADD CONSTRAINT `FK_USU_ESTADO` FOREIGN KEY (`XEEST_CODIGO`) REFERENCES `xeest_estad` (`XEEST_CODIGO`),
  ADD CONSTRAINT `FK_USU_PERSONA` FOREIGN KEY (`XEPER_ID`) REFERENCES `xeper_persona` (`XEPER_ID`);

--
-- Filtros para la tabla `xeuxp_usupe`
--
ALTER TABLE `xeuxp_usupe`
  ADD CONSTRAINT `FK_USUPE_PERFIL` FOREIGN KEY (`XEPER_CODIGO`) REFERENCES `xeper_perfi` (`XEPER_CODIGO`),
  ADD CONSTRAINT `FK_USUPE_USUARIO` FOREIGN KEY (`XEUSU_ID_USUARIO`) REFERENCES `xeusu_usuar` (`XEUSU_ID_USUARIO`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
