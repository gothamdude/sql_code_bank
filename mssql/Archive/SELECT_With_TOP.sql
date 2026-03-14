/*

Use the TOP keyword to limit the number or percentage of rows returned from a query. TOP has been
around for a long time, but with the release of SQL Server 2005, Microsoft has added several
enhancements. TOP originally could be used in SELECT statements only. You could not use TOP in a DELETE,
UPDATE, or INSERT statement. The number or percentage specified had to be a hard-coded value.
Beginning with SQL Server 2005, you can use TOP in data manipulation statements and use a variable to
specify the number or percentage or rows. Here is the syntax:
*/

-- Listing 10-12. Limiting Results with TOP

USE AdventureWorks2008;
GO

--1
IF OBJECT_ID('dbo.Sales') IS NOT NULL BEGIN
	DROP TABLE dbo.Sales;
END;

--2
CREATE TABLE dbo.Sales (CustomerID INT, OrderDate DATE, SalesOrderID INT NOT NULL PRIMARY KEY);
GO

--3
INSERT TOP(5) INTO dbo.Sales(CustomerID,OrderDate,SalesOrderID)
	SELECT CustomerID, OrderDate, SalesOrderID
	FROM Sales.SalesOrderHeader;
--4
SELECT CustomerID, OrderDate, SalesOrderID
FROM dbo.Sales
ORDER BY SalesOrderID;
--5
DELETE TOP(2) dbo.Sales
--6
UPDATE TOP(2) dbo.Sales SET CustomerID = CustomerID + 10000;

--7
SELECT CustomerID, OrderDate, SalesOrderID
FROM dbo.Sales
ORDER BY SalesOrderID;
--8
DECLARE @Rows INT = 2;
SELECT TOP(@Rows) CustomerID, OrderDate, SalesOrderID
FROM dbo.Sales
ORDER BY SalesOrderID;