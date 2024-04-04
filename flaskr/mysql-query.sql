CREATE TABLE `Project` (
  `ProjectID` INT,
  `ProjectName` VARCHAR(20),
  `StartDate` DATE,
  `DurateInMonths` INT,
  `BranchProjectID` VARCHAR(5),
  KEY `PKey` (`ProjectID`),
  KEY `FKey` (`BranchProjectID`)
);

CREATE TABLE `Country` (
  `CountryCode` VARCHAR(5),
  `Name` VARCHAR(20),
  `Region` VARCHAR(20),
  KEY `PKey` (`CountryCode`),
  KEY `FKey` (`Region`)
);

CREATE TABLE `Branch` (
  `BranchID` VARCHAR(5),
  `Name` VARCHAR(30),
  `Address` VARCHAR(30),
  `CountryCode` VARCHAR(5),
  FOREIGN KEY (`CountryCode`) REFERENCES `Country`(`CountryCode`),
  KEY `PKey` (`BranchID`),
  KEY `FKey` (`CountryCode`)
);

CREATE TABLE `BranchProject` (
  `BranchProjetID` INT,
  `StartDate` DATE,
  `BranchID` VARCHAR(5),
  FOREIGN KEY (`BranchProjetID`) REFERENCES `Project`(`ProjectID`),
  FOREIGN KEY (`BranchID`) REFERENCES `Branch`(`BranchID`),
  KEY `PKey` (`BranchProjetID`),
  KEY `FKey` (`BranchID`)
);

CREATE TABLE `Department` (
  `DepartmentID` INT,
  `Name` VARCHAR(20),
  `BranchID` VARCHAR(5),
  FOREIGN KEY (`BranchID`) REFERENCES `Branch`(`BranchID`),
  KEY `PKey` (`DepartmentID`),
  KEY `FKey` (`BranchID`)
);

CREATE TABLE `DeviceDepartment` (
  `BranchDepCode` INT,
  `SerialNo` VARCHAR(5),
  `DepartmentID` VARCHAR(5),
  FOREIGN KEY (`DepartmentID`) REFERENCES `Department`(`DepartmentID`),
  KEY `PKey` (`BranchDepCode`),
  KEY `FKey` (`SerialNo`, `DepartmentID`)
);

CREATE TABLE `Device` (
  `AssetNo` VARCHAR(12),
  `Named` VARCHAR(20),
  `Condition` VARCHAR(20),
  `BranchDepCode` INT,
  FOREIGN KEY (`BranchDepCode`) REFERENCES `DeviceDepartment`(`BranchDepCode`),
  KEY `PKey` (`AssetNo`),
  KEY `FKey` (`BranchDepCode`)
);

CREATE TABLE `DeviceServiceRequest` (
  `RequestID` INT,
  `IssueDetail` VARCHAR(100),
  `DeviceDetail` VARCHAR(100),
  `IssueDate` DATETIME,
  `Severity` VARCHAR(20),
  `Status` VARCHAR(40),
  `SerialNo` VARCHAR(20),
  KEY `PKey` (`RequestID`),
  KEY `FKey` (`SerialNo`)
);

CREATE TABLE `User` (
  `UserID` INT auto_increment,
  `DIMSRole` VARCHAR(20),
  `EmployeeID` INT,
  `Password` VARCHAR(20),
  KEY `PKey` (`UserID`),
  KEY `FKey` (`EmployeeID`)
);

CREATE TABLE `Employee` (
  `EmployeeID` INT,
  `Name` VARCHAR(40),
  `Address` VARCHAR(60),
  `ContactNo` VARCHAR(15),
  `Designation` VARCHAR(15),
  `JobRole` VARCHAR(20),
  `BranchID` VARCHAR(10),
  `AssetNo` VARCHAR(12),
  FOREIGN KEY (`BranchID`) REFERENCES `Branch`(`BranchID`),
  KEY `PKey` (`EmployeeID`),
  KEY `FKey` (`BranchID`, `AssetNo`)
);

CREATE TABLE `ThirdpartyDevice` (
  `SerialNo` VARCHAR(20),
  `OS` VARCHAR(20),
  `Manufacturer` VARCHAR(20),
  `Description` VARCHAR(40),
  `PurchasedDate` DATE,
  `ProjectID` VARCHAR(10),
  `BranchID` VARCHAR(5),
  `EmployeeID` INT,
  FOREIGN KEY (`EmployeeID`) REFERENCES `Employee`(`EmployeeID`),
  FOREIGN KEY (`BranchID`) REFERENCES `Branch`(`BranchID`),
  KEY `PKey` (`SerialNo`),
  KEY `FKey` (`ProjectID`, `BranchID`)
);

CREATE TABLE `ElectronicVastage` (
  `VastageID` INT,
  `Reason` VARCHAR(40),
  `SubmittedDate` DATE,
  `RequestID` INT,
  `AssetNo` VARCHAR(12),
  KEY `PKey` (`VastageID`),
  KEY `FKey` (`RequestID`, `AssetNo`)
);

CREATE TABLE `CompanyManufacturedDevice` (
  `SerialNo` VARCHAR(20),
  `FirmwareVersion` VARCHAR(10),
  `ManufactureDate` DATE,
  `ModelNumber` VARCHAR(10),
  `EmployeeID` INT,
  `ProjectID` INT,
  FOREIGN KEY (`EmployeeID`) REFERENCES `Employee`(`EmployeeID`),
  FOREIGN KEY (`ProjectID`) REFERENCES `Project`(`ProjectID`),
  KEY `PKey` (`SerialNo`),
  KEY `FKey` (`EmployeeID`, `ProjectID`)
);


