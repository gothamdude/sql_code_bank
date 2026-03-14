SELECT OBJECT_NAME(parent_id) AS TableName, 
	name AS TriggerName,
	create_date AS CreationDate,
	modify_date AS ModifyDate
FROM sys.triggers
