USE SwapMap 
GO 

-- SIMPLE PROC with PARAMS 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CheckLogin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CheckLogin]
GO
CREATE PROCEDURE usp_CheckLogin
(
	@pEmail VARCHAR(200),
	@pPassword VARCHAR(100)
) 
AS
BEGIN

	DECLARE @vUserID INT 
	SET @vUserID  = 0  -- NOT FOUND 
	
	IF EXISTS(SELECT UserID 
			  FROM [User] 
			  WHERE UPPER(RTRIM(LTRIM(Email)))= UPPER(RTRIM(LTRIM(@pEmail )))
					AND UPPER(RTRIM(LTRIM([Password])))= UPPER(RTRIM(LTRIM(@pPassword))))
	BEGIN 				
		SET @vUserID = (SELECT UserID 
							FROM [User] 
							WHERE UPPER(RTRIM(LTRIM(Email)))= UPPER(RTRIM(LTRIM(@pEmail)))
									AND UPPER(RTRIM(LTRIM([Password])))= UPPER(RTRIM(LTRIM(@pPassword)))) 
	END 
	
	RETURN @vUserID 
	
END
GO

-- Using Default VALUE PARAMS 
USE AdventureWorks2008;
GO
--1
IF OBJECT_ID('dbo.usp_CustomerName') IS NOT NULL BEGIN
DROP PROC dbo.usp_CustomerName;
END;
GO
--2
CREATE PROC dbo.usp_CustomerName @CustomerID INT = -1 AS
SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID
WHERE @CustomerID = CASE @CustomerID WHEN -1 THEN -1 ELSE c.CustomerID END;
RETURN 0;
GO
--3
EXEC dbo.usp_CustomerName 15128;
--4
EXEC dbo.usp_CustomerName ;


-- USING OUTPUT PARAM  ; YOu will usually use this for unit testing
USE AdventureWorks2008;
GO
--1
IF OBJECT_ID('dbo.usp_OrderDetailCount') IS NOT NULL BEGIN
	DROP PROC dbo.usp_OrderDetailCount;
END;
GO
CREATE PROC dbo.usp_OrderDetailCount @OrderID INT,
@Count INT OUTPUT AS
SELECT @Count = COUNT(*)
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = @OrderID;
RETURN 0;
GO
--3
DECLARE @OrderCount INT;
--4
EXEC usp_OrderDetailCount 71774, @OrderCount OUTPUT;
--5
PRINT @OrderCount;

--SAVING PROC Results to table 
--4
INSERT INTO dbo.tempCustomer 
EXEC dbo.usp_CustomerName;