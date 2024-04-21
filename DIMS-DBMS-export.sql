-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: DIMS
-- ------------------------------------------------------
-- Server version	8.0.36-0ubuntu0.22.04.1

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
-- Table structure for table `Branch`
--

DROP TABLE IF EXISTS `Branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Branch` (
  `BranchID` varchar(5) DEFAULT NULL,
  `Name` varchar(30) DEFAULT NULL,
  `Address` varchar(30) DEFAULT NULL,
  `CountryCode` varchar(5) DEFAULT NULL,
  KEY `PKey` (`BranchID`),
  KEY `FKey` (`CountryCode`),
  CONSTRAINT `Branch_ibfk_1` FOREIGN KEY (`CountryCode`) REFERENCES `Country` (`CountryCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Branch`
--

LOCK TABLES `Branch` WRITE;
/*!40000 ALTER TABLE `Branch` DISABLE KEYS */;
INSERT INTO `Branch` VALUES ('USA1','Newyork','NY city','USA'),('IRE1','Dublin','Dublin','IRE'),('USA1','Newyork','NY city','USA'),('IRE1','Dublin','Dublin','IRE'),('UK1','London','London city','UK'),('SL1','Rajagiriya','Colombo','SL'),('IND1','India','Bangalore','IND'),('SG1','Orchard','Orchard','SG'),('RS1','Moscow','Moscow','RS');
/*!40000 ALTER TABLE `Branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BranchProject`
--

DROP TABLE IF EXISTS `BranchProject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BranchProject` (
  `BranchProjetID` int DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `BranchID` varchar(5) DEFAULT NULL,
  KEY `PKey` (`BranchProjetID`),
  KEY `FKey` (`BranchID`),
  CONSTRAINT `BranchProject_ibfk_1` FOREIGN KEY (`BranchProjetID`) REFERENCES `Project` (`ProjectID`),
  CONSTRAINT `BranchProject_ibfk_2` FOREIGN KEY (`BranchID`) REFERENCES `Branch` (`BranchID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BranchProject`
--

LOCK TABLES `BranchProject` WRITE;
/*!40000 ALTER TABLE `BranchProject` DISABLE KEYS */;
/*!40000 ALTER TABLE `BranchProject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CompanyManufacturedDevice`
--

DROP TABLE IF EXISTS `CompanyManufacturedDevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CompanyManufacturedDevice` (
  `SerialNo` varchar(20) DEFAULT NULL,
  `FirmwareVersion` varchar(10) DEFAULT NULL,
  `ManufactureDate` date DEFAULT NULL,
  `ModelNumber` varchar(10) DEFAULT NULL,
  `EmployeeID` int DEFAULT NULL,
  `ProjectID` int DEFAULT NULL,
  `AssetNo` varchar(12) DEFAULT NULL,
  KEY `ProjectID` (`ProjectID`),
  KEY `PKey` (`SerialNo`),
  KEY `FKey` (`EmployeeID`,`ProjectID`),
  KEY `AssetNo` (`AssetNo`),
  CONSTRAINT `CompanyManufacturedDevice_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`),
  CONSTRAINT `CompanyManufacturedDevice_ibfk_2` FOREIGN KEY (`ProjectID`) REFERENCES `Project` (`ProjectID`),
  CONSTRAINT `CompanyManufacturedDevice_ibfk_3` FOREIGN KEY (`AssetNo`) REFERENCES `Device` (`assetNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CompanyManufacturedDevice`
--

LOCK TABLES `CompanyManufacturedDevice` WRITE;
/*!40000 ALTER TABLE `CompanyManufacturedDevice` DISABLE KEYS */;
INSERT INTO `CompanyManufacturedDevice` VALUES ('11111111','REV1','2020-10-02','DS8108',1,4,'1'),('11111112','REV1','2020-10-02','DS8108',1,2,'10'),('11111113','DEV1','2020-10-02','DS9208',1,3,'11'),('11111114','REV2','2020-10-02','DS6808',1,4,'12'),('11111115','REV2','2020-10-02','LI8108',1,2,'13'),('11111116','REV1','2020-10-02','DS7708',1,3,'14'),('11111117','REV5','2020-10-02','DS7708',1,4,'15'),('11111118','REV1','2020-10-02','DS8108',1,2,'16'),('11111119','REV6','2020-10-02','DS9208',1,3,'17'),('11111120','DEV1','2020-10-02','DS6808',1,4,'18'),('11111121','ENG1','2020-10-02','LI8108',1,2,'19'),('11111122','REV5','2020-10-02','DS7708',1,3,'20'),('11111123','REV3','2020-10-02','DS7708',1,4,'21'),('44441111','SC-7780','2024-04-08','FLAT-SC',NULL,NULL,'40'),('44441112','SC-7780','2024-04-08','FLAT-SC',NULL,NULL,'41'),('44441113','SC-7780','2024-04-08','FLAT-SC',NULL,NULL,'42'),('44441114','SC-7780','2024-04-08','FLAT-SC',NULL,NULL,'43'),('44441115','SC-7780','2024-04-08','FLAT-SC',NULL,NULL,'44'),('44441116','CAM-7780','2024-04-08','UCAM-01',NULL,NULL,'45'),('44441117','CAM-7780','2024-04-10','UCAM-01',NULL,NULL,'46'),('44441118','CAM-7780','2024-04-06','UCAM-01',NULL,NULL,'47'),('44441119','CAM-7780','2024-04-06','UCAM-01',NULL,NULL,'48'),('44441150','CAM-7780','2024-04-06','UCAM-01',NULL,NULL,'49'),('44441151','CAM-7780','2024-04-06','UCAM-01',NULL,NULL,'50');
/*!40000 ALTER TABLE `CompanyManufacturedDevice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Country`
--

DROP TABLE IF EXISTS `Country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Country` (
  `CountryCode` varchar(5) DEFAULT NULL,
  `Name` varchar(20) DEFAULT NULL,
  `Region` varchar(20) DEFAULT NULL,
  KEY `PKey` (`CountryCode`),
  KEY `FKey` (`Region`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Country`
--

LOCK TABLES `Country` WRITE;
/*!40000 ALTER TABLE `Country` DISABLE KEYS */;
INSERT INTO `Country` VALUES ('USA','USA','SnN America'),('IRE','Ireland','Europ'),('UK','England','Europ'),('IND','India','S Asia'),('SL','Sri Lanka','S Asia'),('SG','Singapore','NE Asia'),('RS','Russia','C Asia'),('AUS','Austrailia','APAC');
/*!40000 ALTER TABLE `Country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Department`
--

DROP TABLE IF EXISTS `Department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Department` (
  `DepartmentID` int DEFAULT NULL,
  `Name` varchar(20) DEFAULT NULL,
  `BranchID` varchar(5) DEFAULT NULL,
  KEY `PKey` (`DepartmentID`),
  KEY `FKey` (`BranchID`),
  CONSTRAINT `Department_ibfk_1` FOREIGN KEY (`BranchID`) REFERENCES `Branch` (`BranchID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Department`
--

LOCK TABLES `Department` WRITE;
/*!40000 ALTER TABLE `Department` DISABLE KEYS */;
/*!40000 ALTER TABLE `Department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Device`
--

DROP TABLE IF EXISTS `Device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Device` (
  `assetNo` varchar(12) NOT NULL,
  `device_name` varchar(50) DEFAULT NULL,
  `device_condition` varchar(50) DEFAULT NULL,
  `device_manufactured_date` date DEFAULT NULL,
  `device_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`assetNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Device`
--

LOCK TABLES `Device` WRITE;
/*!40000 ALTER TABLE `Device` DISABLE KEYS */;
INSERT INTO `Device` VALUES ('1','DS2250','used','2023-01-15','Manufactured'),('10','Computer','new','2020-10-02','Manufactured'),('11','Computer','used','2020-10-02','Manufactured'),('12','Computer','faulty','2020-10-02','Manufactured'),('13','Computer','used','2020-10-02','Manufactured'),('14','Computer','new','2020-10-02','Manufactured'),('15','Computer','used','2020-10-02','Manufactured'),('16','Computer','new','2020-10-02','Manufactured'),('17','Computer','new','2020-10-02','Manufactured'),('18','Computer','faulty','2020-10-02','Manufactured'),('19','Computer','used','2020-10-02','Manufactured'),('20','Computer','new','2020-10-02','Manufactured'),('21','Computer','used','2020-10-02','Manufactured'),('22','scanner','new','2020-10-02','Thirdparty'),('23','scanner','new','2020-10-02','Thirdparty'),('24','scanner','new','2020-10-02','Thirdparty'),('25','camera','new','2020-10-02','Thirdparty'),('26','scanner','new','2020-10-02','Thirdparty'),('27','camera board','new','2020-10-02','Thirdparty'),('28','switch','new','2020-10-02','Thirdparty'),('29','moter','new','2020-10-02','Thirdparty'),('3','SD5656','new','1987-09-12','Thirdparty'),('30','stepper','new','2020-10-02','Thirdparty'),('31','camera','faulty','2020-10-02','Thirdparty'),('32','scanner','faulty','2020-10-02','Thirdparty'),('33','scanner','faulty','2020-10-02','Thirdparty'),('4','SD5688','used','1987-09-10','Thirdparty'),('40','Scanner','new',NULL,'Manufactured'),('41','Scanner','new',NULL,'Manufactured'),('42','Scanner','new',NULL,'Manufactured'),('43','Scanner','new',NULL,'Manufactured'),('44','Scanner','new',NULL,'Manufactured'),('45','Camera-UVC','used',NULL,'Manufactured'),('46','Camera-UVC','used',NULL,'Manufactured'),('47','Camera-UVC','used',NULL,'Manufactured'),('48','Camera-UVC','used',NULL,'Manufactured'),('49','Camera-UVC','used',NULL,'Manufactured'),('5','Bioptic','used','2020-12-01','Thirdparty'),('50','Camera-UVC','used',NULL,'Manufactured');
/*!40000 ALTER TABLE `Device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DeviceServiceRequest`
--

DROP TABLE IF EXISTS `DeviceServiceRequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DeviceServiceRequest` (
  `RequestID` int DEFAULT NULL,
  `IssueDetail` varchar(100) DEFAULT NULL,
  `DeviceDetail` varchar(100) DEFAULT NULL,
  `IssueDate` datetime DEFAULT NULL,
  `Severity` varchar(20) DEFAULT NULL,
  `Status` varchar(40) DEFAULT NULL,
  `SerialNo` varchar(20) DEFAULT NULL,
  KEY `PKey` (`RequestID`),
  KEY `FKey` (`SerialNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DeviceServiceRequest`
--

LOCK TABLES `DeviceServiceRequest` WRITE;
/*!40000 ALTER TABLE `DeviceServiceRequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `DeviceServiceRequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ElectronicVastage`
--

DROP TABLE IF EXISTS `ElectronicVastage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ElectronicVastage` (
  `VastageID` int DEFAULT NULL,
  `Reason` varchar(40) DEFAULT NULL,
  `SubmittedDate` date DEFAULT NULL,
  `RequestID` int DEFAULT NULL,
  `AssetNo` varchar(12) DEFAULT NULL,
  KEY `PKey` (`VastageID`),
  KEY `FKey` (`RequestID`,`AssetNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ElectronicVastage`
--

LOCK TABLES `ElectronicVastage` WRITE;
/*!40000 ALTER TABLE `ElectronicVastage` DISABLE KEYS */;
/*!40000 ALTER TABLE `ElectronicVastage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee`
--

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Employee` (
  `EmployeeID` int DEFAULT NULL,
  `Name` varchar(40) DEFAULT NULL,
  `Address` varchar(60) DEFAULT NULL,
  `ContactNo` varchar(15) DEFAULT NULL,
  `Designation` varchar(15) DEFAULT NULL,
  `JobRole` varchar(20) DEFAULT NULL,
  `BranchID` varchar(10) DEFAULT NULL,
  KEY `PKey` (`EmployeeID`),
  KEY `FKey` (`BranchID`),
  CONSTRAINT `Employee_ibfk_1` FOREIGN KEY (`BranchID`) REFERENCES `Branch` (`BranchID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee`
--

LOCK TABLES `Employee` WRITE;
/*!40000 ALTER TABLE `Employee` DISABLE KEYS */;
INSERT INTO `Employee` VALUES (1,'Barak Obama','White House','123123123','The boss','Engineer','USA1'),(2,'Nilusha Max','Dublin, Ireland','123123123','The master','Engineer','SL1'),(3,'Nish Rock','Dublin','123123123','Eng.','Engineer','USA1'),(4,'Yashwan','White House','123123123','The boss','Engineer','USA1'),(5,'Wenki','White House','123123123','The boss','Engineer','USA1');
/*!40000 ALTER TABLE `Employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Project`
--

DROP TABLE IF EXISTS `Project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Project` (
  `ProjectID` int DEFAULT NULL,
  `ProjectName` varchar(20) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `DurateInMonths` int DEFAULT NULL,
  `BranchProjectID` varchar(5) DEFAULT NULL,
  KEY `PKey` (`ProjectID`),
  KEY `FKey` (`BranchProjectID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Project`
--

LOCK TABLES `Project` WRITE;
/*!40000 ALTER TABLE `Project` DISABLE KEYS */;
INSERT INTO `Project` VALUES (1,'Dragon1','2021-01-10',24,'SL1'),(2,'Lamda-1','2021-01-10',12,'SL1'),(3,'Lamda-2','2021-01-10',23,'USA1'),(4,'Killers-1','2021-01-10',12,'USA1');
/*!40000 ALTER TABLE `Project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ThirdpartyDevice`
--

DROP TABLE IF EXISTS `ThirdpartyDevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ThirdpartyDevice` (
  `SerialNo` varchar(20) DEFAULT NULL,
  `OS` varchar(20) DEFAULT NULL,
  `Manufacturer` varchar(20) DEFAULT NULL,
  `Description` varchar(40) DEFAULT NULL,
  `PurchasedDate` date DEFAULT NULL,
  `ProjectID` varchar(10) DEFAULT NULL,
  `BranchID` varchar(5) DEFAULT NULL,
  `EmployeeID` int DEFAULT NULL,
  `AssetNo` varchar(12) DEFAULT NULL,
  KEY `EmployeeID` (`EmployeeID`),
  KEY `BranchID` (`BranchID`),
  KEY `PKey` (`SerialNo`),
  KEY `FKey` (`ProjectID`,`BranchID`),
  KEY `AssetNo` (`AssetNo`),
  CONSTRAINT `ThirdpartyDevice_ibfk_1` FOREIGN KEY (`EmployeeID`) REFERENCES `Employee` (`EmployeeID`),
  CONSTRAINT `ThirdpartyDevice_ibfk_2` FOREIGN KEY (`BranchID`) REFERENCES `Branch` (`BranchID`),
  CONSTRAINT `ThirdpartyDevice_ibfk_3` FOREIGN KEY (`AssetNo`) REFERENCES `Device` (`assetNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ThirdpartyDevice`
--

LOCK TABLES `ThirdpartyDevice` WRITE;
/*!40000 ALTER TABLE `ThirdpartyDevice` DISABLE KEYS */;
INSERT INTO `ThirdpartyDevice` VALUES ('22222221','windows','MS','PC-computer','2020-10-02','2','SL1',1,'22'),('22222222','windows','MS','PC-computer','2020-10-02','3','SL1',1,'23'),('22222223','windows','MS','PC-computer','2020-10-02','4','SL1',1,'24'),('22222224','windows','MS','PC-computer','2020-10-02','2','SL1',1,'25'),('22222225','windows','MS','PC-computer','2020-10-02','3','SL1',1,'26'),('22222226','windows','MS','PC-computer','2020-10-02','4','SL1',1,'27'),('22222227','windows','MS','PC-computer','2020-10-02','2','SL1',1,'28'),('22222228','windows','MS','PC-computer','2020-10-02','3','SL1',1,'29'),('22222229','windows','MS','PC-computer','2020-10-02','4','SL1',1,'30'),('22222230','windows','MS','PC-computer','2020-10-02','2','SL1',1,'31'),('22222231','windows','MS','PC-computer','2020-10-02','3','SL1',1,'32'),('22222232','windows','MS','PC-computer','2020-10-02','4','SL1',1,'33'),('22222233','windows','MS','PC-computer','2020-10-02','4','SL1',1,'4');
/*!40000 ALTER TABLE `ThirdpartyDevice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `DIMSRole` varchar(20) DEFAULT NULL,
  `EmployeeID` int DEFAULT NULL,
  `Password` varchar(100) DEFAULT NULL,
  `username` varchar(45) DEFAULT NULL,
  KEY `PKey` (`UserID`),
  KEY `FKey` (`EmployeeID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (1,'admin',50001,'admin','kalabara'),(2,NULL,NULL,'kamal','kamal'),(3,'admin',1,'$2b$12$SiNNxe2B6.hg2LkgO9My8.s7Ugu87MeEIXriqqqfywfsguR/JJasq','admin');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'DIMS'
--
/*!50003 DROP PROCEDURE IF EXISTS `GetAllDevices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbs`@`localhost` PROCEDURE `GetAllDevices`(
in dev_type VARCHAR(20), 
in dev_name VARCHAR(20), 
in employee_id INT, 
in project_id INT
)
BEGIN
	DROP TABLE IF EXISTS device_info;
	create temporary table device_info (
			`SerialNo` VARCHAR(20),
			`OSFW` VARCHAR(20),
			`MorM` VARCHAR(20),
			`PMDate` DATE,
			`AssetNo` VARCHAR(12),
			`Name` VARCHAR(20),
			`Condition` VARCHAR(20),
			`device_type` VARCHAR(50),
			`Description` VARCHAR(40),
            `EmployeeID` INT,
            `ProjectID` INT
		);
	-- extract all device data from relavant tables.
    insert into device_info
		SELECT cm.SerialNo, 
			cm.FirmwareVersion, 
			cm.ModelNumber, 
			cm.ManufactureDate,
			d.assetNo, 
			d.device_name, 
			d.device_condition, 
			d.device_type,
			"N A",
			cm.EmployeeID,
			cm.ProjectID
		FROM CompanyManufacturedDevice as cm, 
		Device as d where cm.AssetNo = d.AssetNo;
	insert into device_info
		SELECT tp.SerialNo, 
		tp.OS, 
		tp.Manufacturer, 
		tp.PurchasedDate, 
		d.AssetNo,
		d.device_name, 
		d.device_condition, 
		d.device_type, 
		tp.Description,
        tp.EmployeeID,
        tp.ProjectID
		FROM ThirdpartyDevice as tp, Device as d 
		WHERE tp.AssetNo = d.AssetNo;
        
	-- select * from device_info;
    if dev_type = 'all' and dev_name = 'all'  then
	  begin
		if employee_id = 0 and project_id = 0 then
			begin
				-- select * from device_info;
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                order by di.SerialNo;
			end;
		elseif employee_id != 0 and project_id = 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.EmployeeID = employee_id;
			end;
		elseif employee_id = 0 and project_id != 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.ProjectID = project_id;
			end;
		elseif employee_id != 0 and project_id != 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.EmployeeID = employee_id and di.ProjectID = project_id;
			end;
		end if;
	  end;
	elseif dev_type != 'all' and dev_name = 'all'  then
	  begin
		if employee_id = 0 and project_id = 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.device_type = dev_type;
			end;
		elseif employee_id != 0 and project_id = 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.device_type = dev_type and di.EmployeeID = employee_id;
			end;
		elseif employee_id = 0 and project_id != 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.device_type = dev_type and di.ProjectID = project_id;
			end;
		elseif employee_id != 0 and project_id != 0 then  
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.device_type = dev_type and di.EmployeeID = employee_id and di.ProjectID = project_id;
			end;
		end if;
	  end;
	elseif dev_type = 'all' and dev_name != 'all'  then
	  begin
		if employee_id = 0 and project_id = 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.Name = dev_name;
			end;
		elseif employee_id != 0 and project_id = 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.Name = dev_name  and di.EmployeeID = employee_id;
			end;
		elseif employee_id = 0 and project_id != 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.Name = dev_name  and di.ProjectID = project_id;
			end;
		elseif employee_id != 0 and project_id != 0 then  
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where di.Name = dev_name  and di.EmployeeID = employee_id and di.ProjectID = project_id;
			end;
		end if;
	  end;
	elseif dev_type != 'all' and dev_name != 'all'  then
	  begin
		if employee_id = 0 and project_id = 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where  di.device_type = dev_type and di.Name = dev_name;
			end;
		elseif employee_id != 0 and project_id = 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where  di.device_type = dev_type and di.Name = dev_name  and di.EmployeeID = employee_id;
			end;
		elseif employee_id = 0 and project_id != 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where  di.device_type = dev_type and di.Name = dev_name and di.ProjectID = project_id;
			end;
		elseif employee_id != 0 and project_id != 0 then
			begin
				select di.SerialNo, 
					di.OSFW, 
                    di.MorM, 
                    di.PMDate, 
                    di.AssetNo, 
                    di.Name,
                    di.Condition,
                    di.device_type,
                    di.Description, 
                    ep.Name,
                    pj.ProjectName
				from device_info di
                left Join Employee ep on di.EmployeeID = ep.EmployeeID
                left Join Project pj on di.ProjectID = pj.ProjectID
                where  di.device_type = dev_type and di.Name = dev_name and di.EmployeeID = employee_id and di.ProjectID = project_id;
			end;
		end if;
	  end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetDevices` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`nishshanka`@`localhost` PROCEDURE `GetDevices`()
BEGIN
	SELECT tp.SerialNo, 
    tp.OS, 
    tp.Manufacturer, 
    tp.PurchasedDate, 
    d.AssetNo,
    d.device_name, 
    d.device_condition, 
    d.device_type, 
    tp.Description 
    FROM ThirdpartyDevice as tp, Device as d 
    WHERE tp.AssetNo = d.AssetNo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `new_procedure` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`dbs`@`localhost` PROCEDURE `new_procedure`()
BEGIN
	DROP TABLE IF EXISTS device_info;
	create temporary table device_info (
			`SerialNo` VARCHAR(20),
			`OSFW` VARCHAR(20),
			`MorM` VARCHAR(20),
			`PMDate` DATE,
			`AssetNo` VARCHAR(12),
			`Named` VARCHAR(20),
			`Condition` VARCHAR(20),
			`device_type` VARCHAR(50),
			`Description` VARCHAR(40),
            `EmployeeID` INT,
            `ProjectID` INT
		);
	-- extract all device data from relavant tables.
    insert into device_info
		SELECT cm.SerialNo, 
			cm.FirmwareVersion, 
			cm.ModelNumber, 
			cm.ManufactureDate,
			d.assetNo, 
			d.device_name, 
			d.device_condition, 
			d.device_type,
			"N A",
			cm.EmployeeID,
			cm.ProjectID
		FROM CompanyManufacturedDevice as cm, 
		Device as d where cm.AssetNo = d.AssetNo;
		insert into device_info
		SELECT tp.SerialNo, 
		tp.OS, 
		tp.Manufacturer, 
		tp.PurchasedDate, 
		d.AssetNo,
		d.device_name, 
		d.device_condition, 
		d.device_type, 
		tp.Description,
        tp.EmployeeID,
        tp.ProjectID
		FROM ThirdpartyDevice as tp, Device as d 
		WHERE tp.AssetNo = d.AssetNo;
        
	select * from device_info;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-21 12:23:51
