-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: projectdb
-- ------------------------------------------------------
-- Server version	8.0.22

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
-- Table structure for table `actuatorhistoriek`
--

DROP TABLE IF EXISTS `actuatorhistoriek`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actuatorhistoriek` (
  `ActuatorHistoriekId` int NOT NULL AUTO_INCREMENT,
  `Color` varchar(32) NOT NULL,
  `DateChanged` datetime(6) NOT NULL,
  PRIMARY KEY (`ActuatorHistoriekId`),
  UNIQUE KEY `idActuatorHistoriek_UNIQUE` (`ActuatorHistoriekId`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actuatorhistoriek`
--

LOCK TABLES `actuatorhistoriek` WRITE;
/*!40000 ALTER TABLE `actuatorhistoriek` DISABLE KEYS */;
INSERT INTO `actuatorhistoriek` VALUES (1,'red','2021-03-01 01:06:11.000000'),(2,'orange','2020-11-27 15:48:21.000000'),(3,'green','2020-10-20 02:43:06.000000'),(4,'orange','2022-02-19 20:04:44.000000'),(5,'red','2020-11-16 11:41:04.000000'),(6,'orange','2021-12-08 03:46:44.000000'),(7,'green','2021-03-17 04:08:26.000000'),(8,'green','2022-01-17 08:24:28.000000'),(9,'green','2020-08-19 09:57:19.000000'),(10,'red','2021-10-04 11:09:26.000000'),(11,'orange','2022-05-22 00:59:58.000000'),(12,'green','2020-06-11 04:36:42.000000'),(13,'orange','2021-11-21 12:56:55.000000'),(14,'red','2022-04-05 17:09:51.000000'),(15,'orange','2021-01-03 03:01:37.000000'),(16,'green','2022-04-17 23:56:09.000000'),(17,'red','2021-06-08 22:11:59.000000'),(18,'orange','2021-06-22 00:44:23.000000'),(19,'green','2020-09-22 00:04:23.000000'),(20,'orange','2020-10-09 11:57:19.000000'),(21,'red','2021-10-12 00:21:30.000000'),(22,'orange','2021-01-19 11:23:59.000000'),(23,'green','2020-11-07 21:30:44.000000'),(24,'green','2021-08-19 23:58:00.000000'),(25,'green','2021-07-01 15:01:31.000000'),(26,'red','2020-12-09 16:06:06.000000'),(27,'orange','2020-06-16 02:24:00.000000'),(28,'green','2021-06-28 23:01:02.000000'),(29,'orange','2020-09-13 10:13:43.000000'),(30,'red','2020-12-15 16:17:35.000000'),(31,'orange','2021-09-24 13:28:04.000000'),(32,'green','2021-10-06 14:30:12.000000'),(33,'red','2020-09-29 20:56:49.000000'),(34,'orange','2022-04-30 20:05:21.000000'),(35,'green','2020-06-11 15:27:50.000000'),(36,'orange','2021-01-06 08:56:21.000000'),(37,'red','2021-09-13 16:21:39.000000'),(38,'orange','2022-04-20 02:36:57.000000'),(39,'green','2021-06-12 13:09:02.000000'),(40,'green','2020-07-13 07:11:07.000000'),(41,'green','2021-06-26 09:56:50.000000'),(42,'red','2022-04-15 19:17:10.000000'),(43,'orange','2021-02-26 12:11:05.000000'),(44,'green','2021-12-30 22:11:11.000000'),(45,'orange','2022-04-21 02:32:02.000000'),(46,'red','2022-04-05 00:09:57.000000'),(47,'orange','2021-10-30 14:16:05.000000'),(48,'green','2020-10-31 06:04:25.000000'),(49,'red','2021-01-17 17:43:42.000000'),(51,'green','2021-01-05 14:45:38.000000');
/*!40000 ALTER TABLE `actuatorhistoriek` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meting`
--

DROP TABLE IF EXISTS `meting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meting` (
  `MetingId` int NOT NULL AUTO_INCREMENT,
  `Waarde` float NOT NULL,
  `SensorCode` varchar(45) NOT NULL,
  `DateTaken` datetime(6) NOT NULL,
  PRIMARY KEY (`MetingId`),
  UNIQUE KEY `MetingId_UNIQUE` (`MetingId`),
  KEY `SensorLink_idx` (`SensorCode`),
  CONSTRAINT `SensorLink` FOREIGN KEY (`SensorCode`) REFERENCES `sensor` (`SensorCode`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meting`
--

LOCK TABLES `meting` WRITE;
/*!40000 ALTER TABLE `meting` DISABLE KEYS */;
INSERT INTO `meting` VALUES (1,45,'TEMP','2020-06-14 16:33:56.000000'),(2,39,'HUM','2020-06-26 14:14:51.000000'),(3,100,'GAS','2020-07-09 17:14:12.000000'),(4,73,'LIGHT','2020-07-10 11:28:13.000000'),(5,5,'TEMP','2020-07-23 11:32:22.000000'),(6,37,'HUM','2020-07-28 17:55:49.000000'),(7,54,'GAS','2020-08-04 20:20:35.000000'),(8,33,'LIGHT','2020-08-06 08:07:49.000000'),(9,26,'TEMP','2020-08-12 02:58:02.000000'),(10,99,'HUM','2020-08-19 00:37:32.000000'),(11,76,'GAS','2020-08-19 01:55:28.000000'),(12,87,'LIGHT','2020-09-04 23:05:46.000000'),(13,51,'TEMP','2020-09-05 13:51:24.000000'),(14,23,'HUM','2020-09-11 00:01:30.000000'),(15,63,'GAS','2020-09-18 23:41:43.000000'),(16,70,'LIGHT','2020-09-19 11:13:58.000000'),(17,29,'TEMP','2020-09-20 02:07:22.000000'),(18,95,'HUM','2020-09-23 04:27:39.000000'),(19,19,'GAS','2020-09-26 20:58:02.000000'),(20,29,'LIGHT','2020-10-05 12:22:39.000000'),(21,70,'TEMP','2020-10-07 19:36:03.000000'),(22,92,'HUM','2020-10-16 18:51:46.000000'),(23,25,'GAS','2020-10-24 23:31:36.000000'),(24,48,'LIGHT','2020-11-11 12:31:14.000000'),(25,30,'TEMP','2020-11-12 19:24:49.000000'),(26,17,'HUM','2020-11-21 07:50:56.000000'),(27,96,'GAS','2020-11-22 14:34:37.000000'),(28,38,'LIGHT','2020-11-26 06:19:21.000000'),(29,45,'TEMP','2020-12-06 02:41:43.000000'),(30,69,'HUM','2020-12-09 01:55:53.000000'),(31,26,'GAS','2020-12-14 02:42:31.000000'),(32,25,'LIGHT','2020-12-28 03:25:34.000000'),(33,3,'TEMP','2021-01-02 00:56:25.000000'),(34,12,'HUM','2021-01-04 01:14:29.000000'),(35,10,'GAS','2021-01-08 18:37:18.000000'),(36,46,'LIGHT','2021-01-09 06:03:19.000000'),(37,79,'TEMP','2021-01-12 16:28:39.000000'),(38,63,'HUM','2021-01-22 03:28:52.000000'),(39,63,'GAS','2021-02-12 07:18:48.000000'),(40,12,'LIGHT','2021-02-19 10:18:18.000000'),(41,14,'TEMP','2021-02-28 00:37:45.000000'),(42,26,'HUM','2021-03-11 12:11:40.000000'),(43,7,'GAS','2021-03-15 16:13:03.000000'),(44,96,'LIGHT','2021-03-24 07:15:04.000000'),(45,81,'TEMP','2021-03-27 06:51:35.000000'),(46,8,'HUM','2021-04-02 15:22:10.000000'),(47,31,'GAS','2021-04-14 19:56:47.000000'),(48,69,'LIGHT','2021-04-20 04:11:08.000000'),(49,20,'TEMP','2021-04-24 01:24:02.000000'),(50,8,'HUM','2021-04-24 22:47:24.000000'),(51,75,'GAS','2021-04-30 10:20:58.000000'),(52,74,'LIGHT','2021-05-25 08:25:18.000000');
/*!40000 ALTER TABLE `meting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sensor`
--

DROP TABLE IF EXISTS `sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sensor` (
  `SensorId` int NOT NULL AUTO_INCREMENT,
  `SensorCode` varchar(45) NOT NULL,
  `MeetEenheid` varchar(45) NOT NULL,
  `Naam` varchar(45) NOT NULL,
  `Beschrijving` varchar(45) NOT NULL,
  PRIMARY KEY (`SensorId`),
  UNIQUE KEY `SensorCode_UNIQUE` (`SensorCode`),
  UNIQUE KEY `SensorId_UNIQUE` (`SensorId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensor`
--

LOCK TABLES `sensor` WRITE;
/*!40000 ALTER TABLE `sensor` DISABLE KEYS */;
INSERT INTO `sensor` VALUES (1,'TEMP','°C','Temperatuur','Meten van temperatuur'),(2,'HUM','%','Luchtvochtigheid','Meten van luchtvochtigheid'),(3,'GAS','p/m','Air Quality','Meten van deeltjes in de lucht'),(4,'LIGHT','%','Licht Sensor','Meten van lichtintensiteit');
/*!40000 ALTER TABLE `sensor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'projectdb'
--

--
-- Dumping routines for database 'projectdb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-23 17:36:46
