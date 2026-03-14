USE AdventureWorks2008
GO

SELECT BusinessEntityID, FirstName + ' ' + LastName AS FullName 
FROM Person.Person 