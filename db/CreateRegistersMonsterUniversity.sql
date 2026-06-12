/* ---------------------------
   4) INSERT
   --------------------------- */
use Monster_University;

-- CAT�LOGOS B�SICOS -- 
-- peesc_estciv
INSERT INTO dbo.peesc_estciv (PEESC_CODIGO, PEESC_DESCRI) VALUES
('C', 'Casado/a'),
('D', 'Divorciado/a'),
('S', 'Soltero/a'),
('U', 'Uni�n Libre'),
('V', 'Viudo/a');
GO

-- pesex_sexo
INSERT INTO dbo.pesex_sexo (PESEX_CODIGO, PESEX_DESCRI) VALUES
('F', 'Femenino'),
('M', 'Masculino');
GO

-- pecar_cargo
INSERT INTO dbo.pecar_cargo (PECAR_CODIGO, PECAR_NOMBRE, PECAR_DESCRI) VALUES
('ADMIN', 'Administradora', 'Administradora del sistema');
GO

-- pedep_depa
INSERT INTO dbo.pedep_depa (PEDEP_CODIGO, PEDEP_NOMBRE, PEDEP_AREA) VALUES
('TI', 'Tecnolog�a de la Informaci�n', 'Administrativa');
GO

-- SISTEMAS, ESTADOS Y PERFILES -- 
-- xeest_estad
INSERT INTO dbo.xeest_estad (XEEST_CODIGO, XEEST_DESCRI) VALUES
('A', 'Activo'),
('B', 'Bloqueado'),
('I', 'Inactivo'),
('S', 'Suspendido');
GO

-- xesis_siste
INSERT INTO dbo.xesis_siste (XESIS_CODIGO, XESIS_DESCRI) VALUES
('A', 'Sistema Acad�mico'),
('F', 'Sistema Financiero'),
('G', 'Sistema de Gesti�n'),
('R', 'Sistema de Reportes');
GO


-- xeper_perfi
INSERT INTO dbo.xeper_perfi (XEPER_CODIGO, XEPER_DESCRI, XEPER_OBSER) VALUES
('ADMIN001', 'Administrador del Sistema', 'Acceso completo'),
('DOCEN001', 'Docente', 'Registro de notas'),
('ESTUD001', 'Estudiante', 'Consulta acad�mica'),
('SECRE001', 'Secretario Acad�mico', 'Gesti�n acad�mica');
GO

-- OPCIONES Y PERMISOS (ya existen sistemas y perfiles)--
-- xeopc_opcio
INSERT INTO dbo.xeopc_opcio (XEOPC_CODIGO, XESIS_CODIGO, XEOPC_DESCRI) VALUES
('A01','A','Gesti�n de Estudiantes'),
('A02','A','Gesti�n de Matr�culas'),
('A03','A','Gesti�n de Notas'),
('A04','A','Gesti�n de Horarios'),
('A05','A','Gesti�n de Docentes'),
('A06','A','Gesti�n de Asignaturas'),
('F01','F','Gesti�n de Pagos'),
('F02','F','Facturaci�n'),
('F03','F','Gesti�n de Becas'),
('F04','F','Reportes Financieros'),
('G01','G','Gesti�n de Usuarios'),
('G02','G','Gesti�n de Perfiles'),
('G03','G','Gesti�n de Permisos'),
('G04','G','Configuraci�n del Sistema'),
('R01','R','Reportes Acad�micos'),
('R02','R','Reportes Financieros'),
('R03','R','Reportes Estad�sticos');
GO

-- xeoxp_opcpe
INSERT INTO dbo.xeoxp_opcpe (XEOPC_CODIGO, XEPER_CODIGO, XEOXP_FECASI, XEOXP_FECRET) VALUES
('A01','ADMIN001','2025-12-08',NULL),
('A02','ADMIN001','2025-12-08',NULL),
('A03','ADMIN001','2025-12-08',NULL),
('A04','ADMIN001','2025-12-08',NULL),
('A05','ADMIN001','2025-12-08',NULL),
('A06','ADMIN001','2025-12-08',NULL),
('F01','ADMIN001','2025-12-08',NULL),
('G01','ADMIN001','2025-12-08',NULL),
('R01','ADMIN001','2025-12-08',NULL);
GO

-- PERSONAS (padre de empleados y usuarios) -- 
SET IDENTITY_INSERT dbo.xeper_persona ON;
INSERT INTO dbo.xeper_persona (
XEPER_ID, PEESC_CODIGO, PESEX_CODIGO, XEPER_CEDULA,
XEPER_NOMBRES, XEPER_APELLIDOS, XEPER_FECHANAC,
XEPER_DIRECCION, XEPER_TELEFONO, XEPER_EMAIL,
XEPER_FECREGISTRO, XEPER_TIPO_PERSONA)
VALUES
(2,'S','M','1234567890','Administrador','del Sistema','1990-01-01','Campus','0987654321','admin@monsteru.edu.ec','2025-12-08','U'),
(18,'S','M','1719150590','Hendry','Quimbiulco','2001-02-05','Carapungo','0963920840','hendry@monsteru.edu.ec','2025-12-11','U'),
(22,'S','M','1719150423','Juan Pablo','Carrion','2001-02-05','Calderon','0963924569','juanpa@monsteru.edu.ec','2025-12-12','U'),
(23,'C','M','1711300345','Pedro','Pascal','2001-02-05','Calderon','0963940569','alfred@monsteru.edu.ec','2025-12-12','U'),
(24,'C','F','1711300543','Testo','Tester','2001-02-05',NULL,NULL,'yapi@monsteru.edu.ec','2025-12-12','U'),
(25,'S','M','1711300400','Pedro','Pedrito','2001-02-05',NULL,NULL,'pedro@monsteru.edu.ec','2025-12-12','U'),
(26,'S','M','1523120934','Daniela','White','2001-03-05',NULL,NULL,'daniela@monsteru.edu.ec','2025-12-12','U'),
(27,'C','M','1922300242','Jerson','Llumiquinga','2001-02-05',NULL,NULL,'jerson@monsteru.edu.ec','2025-12-12','U'),
(28,'S','M','1711300218','Pablito','Dominguez','2004-01-02','Sangolqui','0963067515','padominguez@monsteru.edu.ec','2025-12-12','U');
SET IDENTITY_INSERT dbo.xeper_persona OFF;
GO

-- EMPLEADOS (ya existe PERSONA) -- 
INSERT INTO dbo.peemp_emple (
PEEMP_CODIGO, XEPER_ID, PEDEP_CODIGO, PECAR_CODIGO,
PEEMP_CARGAS, PEEMP_FECHAINGRESO, PEEMP_JORNADALABORAL, PEEMP_ESTADOEMPLEADO)
VALUES
('EMP001', 2, 'TI', 'ADMIN', 0, '2020-03-15', 'Tiempo Completo - 8h', 'Activo');
GO


-- USUARIOS (depende de PERSONA)--
SET IDENTITY_INSERT dbo.xeusu_usuar ON;
INSERT INTO dbo.xeusu_usuar (
XEUSU_ID_USUARIO, XEPER_ID, XEEST_CODIGO, PEEMP_CODIGO,
XEUSU_USERNAME, PASSWORDHASH, EMAIL_USUARIO,
XEUSU_FECCRE, PRIMER_INGRESO, CONTRASE�A_TEMPORAL)
VALUES
(2,2,'A',NULL,'admin','hash','admin@monsteru.edu.ec','2025-12-08','N','N'),
(15,18,'A',NULL,'hquimbiulco','092340','hendry@monsteru.edu.ec','2025-12-11','S','N'),
(19,22,'A',NULL,'juanpa','hash','juanpa@monsteru.edu.ec','2025-12-12','S','N'),
(20,23,'A',NULL,'alfred','hash','alfred@monsteru.edu.ec','2025-12-12','S','N'),
(21,24,'A',NULL,'yapi','hash','yapi@monsteru.edu.ec','2025-12-12','S','N'),
(22,25,'A',NULL,'pdrito','hash','pedro@monsteru.edu.ec','2025-12-12','S','N'),
(23,26,'A',NULL,'daniela','hash','daniela@monsteru.edu.ec','2025-12-12','S','N'),
(24,27,'A',NULL,'jerson','hash','jerson@monsteru.edu.ec','2025-12-12','S','N'),
(25,28,'A',NULL,'padominguez','hash','pdominguez@monsteru.edu.ec','2025-12-12','S','S');
SET IDENTITY_INSERT dbo.xeusu_usuar OFF;
GO

-- USUARIO ACAD�MICO (depende de USUARIO) -- 
INSERT INTO dbo.xeacu_usr_acade (XEUSU_ID_USUARIO, TIPO, ID_ACADEMICO, FECCRE)
VALUES
(15,'ESTUDIANTE','E00000002','2025-12-12'),
(23,'ADMINISTRADOR','A00000001','2025-12-12'),
(24,'SECRETARIO_ACADEMICO','S00000001','2025-12-12'),
(25,'DOCENTE','D00000002','2025-12-12');
GO

-- USUARIO <-> PERFIL -- 
INSERT INTO dbo.xeuxp_usupe (XEUSU_ID_USUARIO, XEPER_CODIGO, XEUXP_FECASI)
VALUES
(2,'ADMIN001','2025-12-08');
GO