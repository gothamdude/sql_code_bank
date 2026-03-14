USE AdventureWorks2008
GO


SELECT	BusinessEntityID AS EmployeeID 
		,NationalIDNumber AS NationalID 
		,LoginID AS LoginID 
		,JobTitle AS JobTitle
		,BirthDate AS Birthday
FROM HumanResources.Employee
WHERE BirthDate > '01/01/1950'   -- ONE FILTER CONDITION
GO 

SELECT	BusinessEntityID AS EmployeeID 
		,FirstName
		,MiddleName
		,LastName 
FROM Person.Person
WHERE FirstName  = 'Ken'
		AND LastName = 'Myer' OR LastName = 'Meyer'   -- MULTIPLE LOGICAL OPERATORS 
GO 

SELECT	BusinessEntityID AS EmployeeID 
		,FirstName
		,MiddleName
		,LastName 
FROM Person.Person
WHERE FirstName  = 'Ken'
		AND NOT (LastName = 'Myer' OR LastName = 'Meyer' )  -- NOT CLAUSE
GO 
