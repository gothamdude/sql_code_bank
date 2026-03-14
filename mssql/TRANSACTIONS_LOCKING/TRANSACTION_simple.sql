USE AdventurWorks2008 
GO 

-- before count 
SELECT COUNT(*) BeforCount FROM HumanResource.Department 

-- variable to hold the latest error integer value 
DECLARE @@Error INT 

BEGIN TRANSACTION 

INSERT HumanResources.Department (Name, GroupName) 
VALUES ('Accounts Payable', 'Accounting') 
SET @Error = @@ERROR 
IF (@Error <> 0) GOTO Error_Handler 

INSERT HumanResources.Department (Name, GroupName) 
VALUES ('Engineering', 'Research and Development') 
SET @Error = @@ERROR 
IF (@Error <> 0) GOTO Error_Handler 

COMMIT TRAN 


Error_Handler:
IF @Error<>0
BEGIN 
	ROLLBACK TRANSACTION 
END 


-- after count 
SELECT COUNT(*) BeforCount FROM HumanResource.Department 

