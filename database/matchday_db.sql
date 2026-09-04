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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_partida`
--

LOCK TABLES `estados_partida` WRITE;
/*!40000 ALTER TABLE `estados_partida` DISABLE KEYS */;
INSERT INTO `estados_partida` VALUES (1,'Activa'),(3,'Cancelada'),(2,'Finalizada');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_solicitud`
--

LOCK TABLES `estados_solicitud` WRITE;
/*!40000 ALTER TABLE `estados_solicitud` DISABLE KEYS */;
INSERT INTO `estados_solicitud` VALUES (2,'Aceptada'),(1,'Pendiente'),(3,'Rechazada');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partidas`
--

LOCK TABLES `partidas` WRITE;
/*!40000 ALTER TABLE `partidas` DISABLE KEYS */;
INSERT INTO `partidas` VALUES (1,1,3,'2026-08-27','22:40:27',10,'string','string','string',NULL,NULL),(2,1,1,'2026-09-01','19:00:00',10,'Estadio Municipal','Partido amistoso','Activa',NULL,NULL),(4,1,4,'2026-08-27','22:39:33',4,'string','string','string',NULL,NULL);
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
  PRIMARY KEY (`id_preferencia`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_deporte` (`id_deporte`),
  CONSTRAINT `preferencias_deporte_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `preferencias_deporte_ibfk_2` FOREIGN KEY (`id_deporte`) REFERENCES `deportes` (`id_deporte`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preferencias_deporte`
--

LOCK TABLES `preferencias_deporte` WRITE;
/*!40000 ALTER TABLE `preferencias_deporte` DISABLE KEYS */;
INSERT INTO `preferencias_deporte` VALUES (7,8,1),(8,8,2),(10,9,4),(11,9,3),(12,1,1),(13,1,2),(14,1,4);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitudes`
--

LOCK TABLES `solicitudes` WRITE;
/*!40000 ALTER TABLE `solicitudes` DISABLE KEYS */;
INSERT INTO `solicitudes` VALUES (1,1,1,'Aceptada',NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ubicaciones`
--

LOCK TABLES `ubicaciones` WRITE;
/*!40000 ALTER TABLE `ubicaciones` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ubicaciones_deporte`
--

LOCK TABLES `ubicaciones_deporte` WRITE;
/*!40000 ALTER TABLE `ubicaciones_deporte` DISABLE KEYS */;
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
  UNIQUE KEY `nickname` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'12345678-9','Ignacio','Susarte','ignacio@test.cl','ignacio01','1234','2000-01-01','Masculino'),(7,'12345678-9','Pepito','El Bandolero','bandolero@test.cl','El_bandolero','1234','2026-08-27','Masculino'),(8,'18.932.246-1','Andoni','Susarte','andoni@korta.cl','andoni04','Hola1234','1994-07-15','Masculino'),(9,'13.457.368-0','Benito','Gonzalez','Benito@ben.cl','benito','Hola1234','2000-01-01','Masculino');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'matchday_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-03  2:52:44
