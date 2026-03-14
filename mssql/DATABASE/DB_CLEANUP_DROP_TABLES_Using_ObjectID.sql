USE AdventureWorks2008
GO 

IF Object_ID ('dbo.Customer') IS NOT NULL 
BEGIN 
	DROP TABLE dbo.Customers
END ;