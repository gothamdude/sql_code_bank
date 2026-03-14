USE AdventureWorks2008
GO

SELECT	BusinessEntityID AS EmployeeID 
		,NationalIDNumber AS NationalID 
		,LoginID AS LoginID 
		,JobTitle AS JobTitle
		,BirthDate AS Birthday
FROM HumanResources.Employee
GO 

SELECT	BusinessEntityID AS 'Employee ID' 
		,NationalIDNumber AS 'National ID' 
		,LoginID AS 'Login ID' 
		,JobTitle AS 'Job Title'
		,BirthDate AS 'Birthday'
FROM HumanResources.Employee
GO 

SELECT	BusinessEntityID AS [Employee ID] 
		,NationalIDNumber AS [National ID]
		,LoginID AS [Login ID] 
		,JobTitle AS [Job Title]
		,BirthDate AS [Birthday]
FROM HumanResources.Employee
GO 
