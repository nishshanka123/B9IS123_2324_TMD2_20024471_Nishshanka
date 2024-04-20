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
        
	
END