USE AdventureWorks2008
GO 

-- I.  SIMPLE TRY ... CATCH 
BEGIN TRY 

	PRINT 1/0; 

END TRY 
BEGIN CATCH
		PRINT 'An error has occurred'
		PRINT ERROR_NUMBER()
		PRINT ERROR_SEVERITY()
		PRINT ERROR_STATE()
		PRINT ERROR_PROCEDURE()
		PRINT ERROR_LINE() 
		PRINT ERROR_MESSAGE() 
END CATCH 


-- II. CATCHING UNTRAPPABLE ERRORS
-- TRY_CATCH cannot trap some errors. For example if the code containcs an incorrect table or column name or a database server is not available, 
-- the entire batch of statements will fail and the error will not be trapped. one way to solve this is to encapsulate calls within 
-- a  stored proc and call the sp within the try block 
--example 
PRINT 'INVALID COLUMN' 
GO 
BEGIN TRY 
	SELECT ABC FROM Sales.SalesOrderDetail
END TRY 
BEGIN CATCH 
	PRINT ERROR_NUMBER()
END CATCH 


-- III. Using RaiseError ; sometimes you can add custom error messaage 
USE master 
Go 

-- 1  this code section creates a custom error message
IF EXISTS(SELECT * FROM sys.messages WHERE message_id = 50002)
BEGIN 
	EXEC sp_dropmessage 50002; 
END 
GO 

PRINT 'CREATING a custom error message'
EXEC sp_addmessage 50002,16,N'Customer is missing.'
GO

USE AdventureWorks2008
GO 

-- 2 
IF NOT EXISTS(SELECT * FROM Sales.Customer WHERE CustomerID = -1 )
BEGIN 
	RaisError(50002, 16, 1);
END 
GO 




-- IV  TRY ... CATCH With TRANSACTIONS 
-- 1
CREATE TABLE #Test (ID NOT NULL PRIMARY KEY) 
GO 

-- 2
BEGIN TRY 
	BEGIN TRAN 
	
		-- 2.1
		INSERT INTO #Test(ID) 
		VALUES (1),(2), (3)
		
		-- 2.2
		UPDATE #Test SET ID= 2 WHERE IDENTITY = 3 
	
	COMMIT 

END TRY 
-- 3
BEGIN CATCH 
	-- 3.1 
	PRINT ERROR_MESSAGE()
	-- 3.2 
	PRINT 'Rolling back'
	ROLLBACK 
END CATCH 















