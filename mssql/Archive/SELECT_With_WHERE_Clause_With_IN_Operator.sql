USE AdventureWorks2008
GO


SELECT	BusinessEntityID AS EmployeeID 
		,NationalIDNumber AS NationalID 
		,LoginID AS LoginID 
		,JobTitle AS JobTitle
		,BirthDate AS Birthday
FROM HumanResources.Employee
WHERE JobTitle IN ('Design Engineer', 'Chief Executive Officer', 'Marketing Manager')
GO 
