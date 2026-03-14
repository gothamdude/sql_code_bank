USE AdventureWorks2008
GO


--NOTE: CAST is compliant with ANSI SQL-99 

-- using CAST 
SELECT CAST(BusinessEntityID AS NVARCHAR) + ': ' + LastName 
	+ ', ' + FirstName  AS ID_Name 
FROM Person.Person


-- using CONVERT 
SELECT CONVERT(NVARCHAR(10),BusinessEntityID) + ': ' + LastName 
	+ ', ' + FirstName  AS ID_Name 
FROM Person.Person
