USE railway;

-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: matchday_db
-- ------------------------------------------------------
-- Server version	8.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `deportes`
--

DROP TABLE IF EXISTS `deportes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deportes` (
  `id_deporte` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id_deporte`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deportes`
--

LOCK TABLES `deportes` WRITE;
/*!40000 ALTER TABLE `deportes` DISABLE KEYS */;
INSERT INTO `deportes` VALUES (1,'Futbol'),(2,'Tenis'),(3,'Basquetbol'),(4,'Voleibol');
/*!40000 ALTER TABLE `deportes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_partida`
--

DROP TABLE IF EXISTS `estados_partida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_partida` (
  `id_estado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  PRIMARY KEY (`id_estado`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_partida`
--

LOCK TABLES `estados_partida` WRITE;
/*!40000 ALTER TABLE `estados_partida` DISABLE KEYS */;
INSERT INTO `estados_partida` VALUES (1,'Activa'),(5,'Cancelada'),(2,'Completa'),(3,'En progreso'),(4,'Finalizada');
/*!40000 ALTER TABLE `estados_partida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_solicitud`
--

DROP TABLE IF EXISTS `estados_solicitud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_solicitud` (
  `id_estado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  PRIMARY KEY (`id_estado`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_solicitud`
--

LOCK TABLES `estados_solicitud` WRITE;
/*!40000 ALTER TABLE `estados_solicitud` DISABLE KEYS */;
INSERT INTO `estados_solicitud` VALUES (2,'Aceptada'),(4,'Cancelada'),(1,'Pendiente'),(3,'Rechazada');
/*!40000 ALTER TABLE `estados_solicitud` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluaciones`
--

DROP TABLE IF EXISTS `evaluaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evaluaciones` (
  `id_evaluacion` int NOT NULL AUTO_INCREMENT,
  `id_partida` int NOT NULL,
  `id_evaluador` int NOT NULL,
  `id_evaluado` int NOT NULL,
  `compromiso` int NOT NULL,
  `puntualidad` int NOT NULL,
  `fairplay` int NOT NULL,
  `nivel_juego` int NOT NULL,
  PRIMARY KEY (`id_evaluacion`),
  KEY `id_partida` (`id_partida`),
  KEY `id_evaluador` (`id_evaluador`),
  KEY `id_evaluado` (`id_evaluado`),
  CONSTRAINT `evaluaciones_ibfk_1` FOREIGN KEY (`id_partida`) REFERENCES `partidas` (`id_partida`),
  CONSTRAINT `evaluaciones_ibfk_2` FOREIGN KEY (`id_evaluador`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `evaluaciones_ibfk_3` FOREIGN KEY (`id_evaluado`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluaciones`
--

LOCK TABLES `evaluaciones` WRITE;
/*!40000 ALTER TABLE `evaluaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `evaluaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participantes_partida`
--

DROP TABLE IF EXISTS `participantes_partida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `participantes_partida` (
  `id_participante` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `id_partida` int NOT NULL,
  PRIMARY KEY (`id_participante`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_partida` (`id_partida`),
  CONSTRAINT `participantes_partida_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `participantes_partida_ibfk_2` FOREIGN KEY (`id_partida`) REFERENCES `partidas` (`id_partida`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participantes_partida`
--

LOCK TABLES `participantes_partida` WRITE;
/*!40000 ALTER TABLE `participantes_partida` DISABLE KEYS */;
/*!40000 ALTER TABLE `participantes_partida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partidas`
--

DROP TABLE IF EXISTS `partidas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partidas` (
  `id_partida` int NOT NULL AUTO_INCREMENT,
  `id_creador` int NOT NULL,
  `id_deporte` int NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `cant_jugadores` int NOT NULL,
  `lugar` varchar(200) NOT NULL,
  `descripcion` text,
  `estado` varchar(20) NOT NULL,
  `id_estado` int DEFAULT NULL,
  `id_ubicacion` int DEFAULT NULL,
  PRIMARY KEY (`id_partida`),
  KEY `id_creador` (`id_creador`),
  KEY `id_deporte` (`id_deporte`),
  KEY `fk_partida_estado` (`id_estado`),
  KEY `fk_partidas_ubicacion` (`id_ubicacion`),
  CONSTRAINT `fk_partida_estado` FOREIGN KEY (`id_estado`) REFERENCES `estados_partida` (`id_estado`),
  CONSTRAINT `fk_partidas_ubicacion` FOREIGN KEY (`id_ubicacion`) REFERENCES `ubicaciones` (`id_ubicacion`),
  CONSTRAINT `partidas_ibfk_1` FOREIGN KEY (`id_creador`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `partidas_ibfk_2` FOREIGN KEY (`id_deporte`) REFERENCES `deportes` (`id_deporte`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partidas`
--

LOCK TABLES `partidas` WRITE;
/*!40000 ALTER TABLE `partidas` DISABLE KEYS */;
/*!40000 ALTER TABLE `partidas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preferencias_deporte`
--

DROP TABLE IF EXISTS `preferencias_deporte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preferencias_deporte` (
  `id_preferencia` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `id_deporte` int NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_preferencia`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_deporte` (`id_deporte`),
  CONSTRAINT `preferencias_deporte_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `preferencias_deporte_ibfk_2` FOREIGN KEY (`id_deporte`) REFERENCES `deportes` (`id_deporte`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preferencias_deporte`
--

LOCK TABLES `preferencias_deporte` WRITE;
/*!40000 ALTER TABLE `preferencias_deporte` DISABLE KEYS */;
INSERT INTO `preferencias_deporte` VALUES (41,8,3,1),(49,8,2,1),(50,8,1,1),(51,8,4,1);
/*!40000 ALTER TABLE `preferencias_deporte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitudes`
--

DROP TABLE IF EXISTS `solicitudes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitudes` (
  `id_solicitud` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `id_partida` int NOT NULL,
  `estado` varchar(20) NOT NULL,
  `id_estado` int DEFAULT NULL,
  PRIMARY KEY (`id_solicitud`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_partida` (`id_partida`),
  KEY `fk_solicitud_estado` (`id_estado`),
  CONSTRAINT `fk_solicitud_estado` FOREIGN KEY (`id_estado`) REFERENCES `estados_solicitud` (`id_estado`),
  CONSTRAINT `solicitudes_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `solicitudes_ibfk_2` FOREIGN KEY (`id_partida`) REFERENCES `partidas` (`id_partida`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitudes`
--

LOCK TABLES `solicitudes` WRITE;
/*!40000 ALTER TABLE `solicitudes` DISABLE KEYS */;
/*!40000 ALTER TABLE `solicitudes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ubicaciones`
--

DROP TABLE IF EXISTS `ubicaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ubicaciones` (
  `id_ubicacion` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) NOT NULL,
  `direccion` varchar(300) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `latitud` decimal(10,8) NOT NULL,
  `longitud` decimal(11,8) NOT NULL,
  PRIMARY KEY (`id_ubicacion`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ubicaciones`
--

LOCK TABLES `ubicaciones` WRITE;
/*!40000 ALTER TABLE `ubicaciones` DISABLE KEYS */;
INSERT INTO `ubicaciones` VALUES (1,'Estadio Español Cancha Fútbol #1','Av. España 802, Curicó','Curicó',-34.98610000,-71.22280000),(2,'Estadio Español Cancha Tenis #1','Av. España 802, Curicó','Curicó',-34.98620000,-71.22220000),(3,'Club de Tenis Curicó Cancha #1','Av. Manso de Velasco 810, Curicó','Curicó',-34.98200000,-71.23370000),(4,'Gimnasio Abraham Milad','Av. O\'Higgins 800, Curicó','Curicó',-34.98250000,-71.24480000),(5,'Gimnasio Municipal de Curicó','Av. O\'Higgins 807, Curicó','Curicó',-34.98280000,-71.24460000),(6,'Gimnasio Olímpico Curicó','Av. Arturo Alessandri 1430, Curicó','Curicó',-34.97440000,-71.22730000),(7,'Cancha Alameda','Alameda Manso de Velasco 102-180, Curicó','Curicó',-34.98960000,-71.23360000),(8,'Multicancha Santa Fe','Lago Lanalhue 1235, Villa Santa Fe, Curicó','Curicó',-34.97320000,-71.25410000),(9,'Cancha Sol de Septiembre','Rio Elqui 246, Pob. Sol de Septiembre, Curicó','Curicó',-34.98130000,-71.21530000),(10,'Estadio Nacional','Av. Grecia 2001, Ñuñoa','Santiago de Chile',-33.45870000,-70.60630000),(11,'Estadio Monumental','Av. Marathon 5300, Macul','Santiago de Chile',-33.50660000,-70.60590000),(12,'Club Deportivo Manquehue','Av. Vitacura 5841, Vitacura','Santiago de Chile',-33.40100000,-70.58300000),(13,'Club de Tenis Santiago','Av. El Cerro 151, Providencia','Santiago de Chile',-33.41400000,-70.61400000),(14,'Centro de Entrenamiento Olímpico','Ramón Cruz 1176, Ñuñoa','Santiago de Chile',-33.45600000,-70.61100000),(15,'Centro de Deportes Colectivos','Av. Grecia 2001, Ñuñoa','Santiago de Chile',-33.46000000,-70.60400000);
/*!40000 ALTER TABLE `ubicaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ubicaciones_deporte`
--

DROP TABLE IF EXISTS `ubicaciones_deporte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ubicaciones_deporte` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_ubicacion` int NOT NULL,
  `id_deporte` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_ubicacion` (`id_ubicacion`),
  KEY `id_deporte` (`id_deporte`),
  CONSTRAINT `ubicaciones_deporte_ibfk_1` FOREIGN KEY (`id_ubicacion`) REFERENCES `ubicaciones` (`id_ubicacion`),
  CONSTRAINT `ubicaciones_deporte_ibfk_2` FOREIGN KEY (`id_deporte`) REFERENCES `deportes` (`id_deporte`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ubicaciones_deporte`
--

LOCK TABLES `ubicaciones_deporte` WRITE;
/*!40000 ALTER TABLE `ubicaciones_deporte` DISABLE KEYS */;
INSERT INTO `ubicaciones_deporte` VALUES (1,1,1),(2,7,1),(3,8,1),(4,2,2),(5,3,2),(6,4,3),(7,5,3),(8,7,3),(9,8,3),(10,6,4),(11,8,4),(12,9,1),(13,9,3),(14,10,1),(15,11,1),(16,12,2),(17,12,3),(18,12,4),(19,13,2),(20,14,3),(21,15,3),(22,15,4);
/*!40000 ALTER TABLE `ubicaciones_deporte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `rut` varchar(12) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `nickname` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `sexo` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `correo` (`email`),
  UNIQUE KEY `nickname` (`nickname`),
  UNIQUE KEY `rut` (`rut`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (8,'18.932.246-1','Andoni','Susarte','andoni@korta.cl','andoni04','Hola1234','1994-07-15','Masculino');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-08 22:12:01
