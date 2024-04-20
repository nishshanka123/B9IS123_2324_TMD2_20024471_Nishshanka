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
                left Join Project pj on di.ProjectID = pj.ProjectID;
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
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
                INNER Join Employee ep on di.EmployeeID = ep.EmployeeID
                INNER Join Project pj on di.ProjectID = pj.ProjectID
                where  di.device_type = dev_type and di.Name = dev_name and di.EmployeeID = employee_id and di.ProjectID = project_id;
			end;
		end if;
	  end;
	end if;
END