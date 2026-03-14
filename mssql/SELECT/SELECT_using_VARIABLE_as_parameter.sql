USE AdventureWorks2008
GO 

DECLARE @AddressLine1 nvarchar(60)
SET @AddressLine1 = 'Heiderplatz'


SELECT AddressID, AddressLine1 
FROM Person.Address 
WHERE AddressLine1 LIKE '%' + @AddressLine1 + '%'