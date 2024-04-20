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
  FOREIGN KEY (`BranchID`) REFERENCES `Branch`(`BranchID`),
  KEY `PKey` (`EmployeeID`),
  KEY `FKey` (`BranchID`)
);
drop table Employee;

CREATE TABLE `ThirdpartyDevice` (
  `SerialNo` VARCHAR(20),
  `AssetNo` VARCHAR(12),
  `OS` VARCHAR(20),
  `Manufacturer` VARCHAR(20),
  `Description` VARCHAR(40),
  `PurchasedDate` DATE,
  `ProjectID` VARCHAR(10),
  `BranchID` VARCHAR(5),
  `EmployeeID` INT,
  foreign key (`AssetNo`) references `Device`(`AssetNo`),
  FOREIGN KEY (`EmployeeID`) REFERENCES `Employee`(`EmployeeID`),
  FOREIGN KEY (`BranchID`) REFERENCES `Branch`(`BranchID`),
  KEY `PKey` (`SerialNo`),
  KEY `FKey` (`ProjectID`, `BranchID`)
);

ALTER TABLE ThirdpartyDevice add column AssetNo VARCHAR(12);
ALTER TABLE ThirdpartyDevice ADD foreign key (`AssetNo`) references `Device`(`AssetNo`);

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
  `AssetNo` VARCHAR(12),
  `FirmwareVersion` VARCHAR(10),
  `ManufactureDate` DATE,
  `ModelNumber` VARCHAR(10),
  `EmployeeID` INT,
  `ProjectID` INT,
  foreign key (`AssetNo`) references `Device`(`AssetNo`),
  FOREIGN KEY (`EmployeeID`) REFERENCES `Employee`(`EmployeeID`),
  FOREIGN KEY (`ProjectID`) REFERENCES `Project`(`ProjectID`),
  KEY `PKey` (`SerialNo`),
  KEY `FKey` (`EmployeeID`, `ProjectID`)
);

ALTER TABLE CompanyManufacturedDevice add column AssetNo VARCHAR(12);
ALTER TABLE CompanyManufacturedDevice ADD foreign key (`AssetNo`) references `Device`(`AssetNo`);

alter table User add column username VARCHAR(45);
update User set username="admin" where UserID=1;
select * from User;

insert into Country values("USA", "USA", "SnN America");
insert into Country values("IRE", "Ireland", "Europ");
insert into Country values("UK", "England", "Europ");
insert into Country values("IND", "India", "S Asia");
insert into Country values("SL", "Sri Lanka", "S Asia");
insert into Country values("SG", "Singapore", "NE Asia");
insert into Country values("RS", "Russia", "C Asia");
insert into Country values("AUS", "Austrailia", "APAC");
insert into Branch values("USA1", "Newyork", "NY city", "USA");
insert into Branch values("IRE1", "Dublin", "Dublin", "IRE");
insert into Branch values("UK1", "London", "London city", "UK");
insert into Branch values("SL1", "Rajagiriya", "Colombo", "SL");
insert into Branch values("IND1", "India", "Bangalore", "IND");
insert into Branch values("SG1", "Orchard", "Orchard", "SG");
insert into Branch values("RS1", "Moscow", "Moscow", "RS");
insert into Project values(1, "Dragon1", date("2021/01/10"), 24, "SL1");
insert into Employee values(1, "Barak Obama", "White House", "123123123", "The boss", "Engineer", "USA-01");

Alter table Employee drop column AssetNo;

insert into CompanyManufacturedDevice (SerialNo, FirmwareVersion, ManufactureDate, ModelNumber, EmployeeID, ProjectID)
values ("11111111", "REV1", "2020/10/02", "DS8108", 1, 1),
("11111112", "REV1", "2020/10/02", "DS8108", 1, 1),
("11111113", "DEV1", "2020/10/02", "DS9208", 1, 1),
("11111114", "REV2", "2020/10/02", "DS6808", 1, 1),
("11111115", "REV2", "2020/10/02", "LI8108", 1, 1),
("11111116", "REV1", "2020/10/02", "DS7708", 1, 1),
("11111117", "REV5", "2020/10/02", "DS7708", 1, 1),
("11111118", "REV1", "2020/10/02", "DS8108", 1, 1),
("11111119", "REV6", "2020/10/02", "DS9208", 1, 1),
("11111120", "DEV1", "2020/10/02", "DS6808", 1, 1),
("11111121", "ENG1", "2020/10/02", "LI8108", 1, 1),
("11111122", "REV5", "2020/10/02", "DS7708", 1, 1),
("11111123", "REV3", "2020/10/02", "DS7708", 1, 1);

update CompanyManufacturedDevice set AssetNo = "10" where SerialNo = "11111112";
update CompanyManufacturedDevice set AssetNo = "11" where SerialNo = "11111113";
update CompanyManufacturedDevice set AssetNo = "12" where SerialNo = "11111114";
update CompanyManufacturedDevice set AssetNo = "13" where SerialNo = "11111115";
update CompanyManufacturedDevice set AssetNo = "14" where SerialNo = "11111116";
update CompanyManufacturedDevice set AssetNo = "15" where SerialNo = "11111117";
update CompanyManufacturedDevice set AssetNo = "16" where SerialNo = "11111118";
update CompanyManufacturedDevice set AssetNo = "17" where SerialNo = "11111119";
update CompanyManufacturedDevice set AssetNo = "18" where SerialNo = "11111120";
update CompanyManufacturedDevice set AssetNo = "19" where SerialNo = "11111121";
update CompanyManufacturedDevice set AssetNo = "20" where SerialNo = "11111122";
update CompanyManufacturedDevice set AssetNo = "21" where SerialNo = "11111123";

update ThirdpartyDevice set AssetNo = "22" where SerialNo = "22222221";
update ThirdpartyDevice set AssetNo = "23" where SerialNo = "22222222";
update ThirdpartyDevice set AssetNo = "24" where SerialNo = "22222223";
update ThirdpartyDevice set AssetNo = "25" where SerialNo = "22222224";
update ThirdpartyDevice set AssetNo = "26" where SerialNo = "22222225";
update ThirdpartyDevice set AssetNo = "27" where SerialNo = "22222226";
update ThirdpartyDevice set AssetNo = "28" where SerialNo = "22222227";
update ThirdpartyDevice set AssetNo = "29" where SerialNo = "22222228";
update ThirdpartyDevice set AssetNo = "30" where SerialNo = "22222229";
update ThirdpartyDevice set AssetNo = "31" where SerialNo = "22222230";
update ThirdpartyDevice set AssetNo = "32" where SerialNo = "22222231";
update ThirdpartyDevice set AssetNo = "33" where SerialNo = "22222232";
update ThirdpartyDevice set AssetNo = "34" where SerialNo = "22222233";


insert into ThirdpartyDevice (SerialNo, OS, Manufacturer, Description, PurchasedDate, ProjectID, BranchID, EmployeeID)
values ("22222221", "windows", "MS", "PC-computer","2020/10/02", 1, "SL1", 1),
("22222222", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222223", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222224", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222225", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222226", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222227", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222228", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222229", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222230", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222231", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222232", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1),
("22222233", "windows", "MS", "PC-computer", "2020/10/02", 1, "SL1", 1);

alter table Device modify column assetNo varchar(12);
insert into Device values
(10, "Computer", "new", "11111112", "2020/10/02","thirdparty"),
(11, "Computer", "used", "11111113", "2020/10/02","thirdparty"),
(12, "Computer", "faulty", "11111114", "2020/10/02","thirdparty"),
(13, "Computer", "used", "11111115", "2020/10/02","thirdparty"),
(14, "Computer", "new", "11111116", "2020/10/02","thirdparty"),
(15, "Computer", "used", "11111117", "2020/10/02","thirdparty"),
(16, "Computer", "new", "11111118", "2020/10/02","thirdparty"),
(17, "Computer", "new", "11111119", "2020/10/02","thirdparty"),
(18, "Computer", "faulty", "11111120", "2020/10/02","thirdparty"),
(19, "Computer", "used", "11111121", "2020/10/02","thirdparty"),
(20, "Computer", "new", "11111122", "2020/10/02","thirdparty"),
(21, "Computer", "used", "11111123", "2020/10/02","thirdparty"),
(22, "scanner", "new", "22222222", "2020/10/02","Enginnering"),
(23, "scanner", "new", "22222223", "2020/10/02","Enginnering"),
(24, "scanner", "new", "22222224", "2020/10/02","Enginnering"),
(25, "camera", "new", "22222225", "2020/10/02","Enginnering"),
(26, "scanner", "new", "22222226", "2020/10/02","Enginnering"),
(27, "camera board", "new", "22222227", "2020/10/02","Enginnering"),
(28, "switch", "new", "22222228", "2020/10/02","Enginnering"),
(29, "moter", "new", "22222229", "2020/10/02","Released"),
(30, "stepper", "new", "22222230", "2020/10/02","Released"),
(31, "camera", "faulty", "22222231", "2020/10/02","Dev"),
(32, "scanner", "faulty", "22222232", "2020/10/02","Dev"),
(33, "scanner", "faulty", "22222233", "2020/10/02","Enginnering");

select * from CompanyManufacturedDevice;
select * from ThirdpartyDevice;
select * from Project;
select * from Employee;
SELECT * FROM Device;


Alter table Device drop column device_serial_no;




SELECT cm.SerialNo, cm.FirmwareVersion, cm.ManufactureDate, cm.ModelNumber, cm.ManufactureDate, tp.SerialNo, tp.Manufacturer, tp.PurchasedDate, d.assetNo, d.device_name, d.device_condition, d.device_type FROM CompanyManufacturedDevice as cm, Device as d, ThirdpartyDevice as tp where cm.AssetNo = d.AssetNo or tp.AssetNo = d.assetNo;
SELECT tp.SerialNo, tp.Manufacturer, tp.PurchasedDate, d.AssetNo, d.device_name, d.device_condition, d.device_type, tp.Description FROM ThirdpartyDevice as tp, Device as d where tp.AssetNo = d.AssetNo;

SELECT cm.SerialNo, cm.FirmwareVersion as Firmware_or_os, cm.ManufactureDate, cm.ModelNumber, cm.ManufactureDate, tp.SerialNo, tp.Manufacturer, tp.PurchasedDate, d.assetNo, d.device_name, d.device_condition, d.device_type FROM CompanyManufacturedDevice as cm, Device as d, ThirdpartyDevice as tp where cm.AssetNo = d.AssetNo or tp.AssetNo = d.assetNo;

CALL getAllDevices();

SELECT cm.SerialNo, 
      cm.FirmwareVersion, 
      cm.ModelNumber, 
      cm.ManufactureDate, 
      d.assetNo, 
      d.device_name,
      d.device_condition,
      d.device_type 
      FROM CompanyManufacturedDevice as cm, Device as d
      WHERE cm.AssetNo = d.AssetNo;
      
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


CREATE DEFINER=`nishshanka`@`localhost` PROCEDURE `GetAllDevices`(
in dev_type VARCHAR(20), 
in dev_name VARCHAR(20), 
in employee_id INT, 
in department_id INT
)
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
END
    
if dev_type = 'all' and dev_name = 'all'  then
  begin
		if employee_id = 0 and department_id = 0 then
			begin
				select * from device_info;
			end;
		elseif employee_id != 0 and department_id = 0 then
			begin
				select * from device_info;
			end;
		elseif employee_id = 0 and department_id != 0 then
			begin
				select * from device_info;
			end;
		elseif employee_id != 0 and department_id != 0 then
			begin
				select * from device_info;
			end;
		end if;
  end;
elseif dev_type != 'all' and dev_name = 'all'  then
  begin
		if employee_id = 0 and department_id = 0 then
			begin
				select * from device_info;
			end;
        elseif employee_id != 0 and department_id = 0 then
			begin
				select * from device_info;
			end;
        elseif employee_id = 0 and department_id != 0 then
			begin
				select * from device_info;
			end;
        elseif employee_id != 0 and department_id != 0 then  
			begin
				select * from device_info;
			end;
  end;
elseif dev_type = 'all' and dev_name != 'all'  then
  begin
		if employee_id = 0 and department_id = 0 then
			begin
				select * from device_info;
			end;
        elseif employee_id != 0 and department_id = 0 then
			begin
				select * from device_info;
			end;
        elseif employee_id = 0 and department_id != 0 then
			begin
				select * from device_info;
			end;
        elseif employee_id != 0 and department_id != 0 then  
			begin
				select * from device_info;
			end;
		end if;
  end;
elseif dev_type = 'all' and dev_name = 'all'  then
  begin
		if employee_id = 0 and department_id = 0 then
			begin
				select * from device_info;
			end;
        elseif employee_id != 0 and department_id = 0 then
			begin
				select * from device_info;
			end;
        elseif employee_id = 0 and department_id != 0 then
			begin
				select * from device_info;
			end;
        elseif employee_id != 0 and department_id != 0 then
			begin
				select * from device_info;
			end;
		end if;
  end;
end if;