USE AdventureWorks2008
GO

SELECT	BusinessEntityID AS EmployeeID 
		,NationalIDNumber AS NationalID 
		,LoginID AS LoginID 
		,JobTitle AS JobTitle
		,BirthDate AS Birthday
FROM HumanResources.Employee
WHERE BirthDate BETWEEN '01/01/1950' AND '01/01/1975'
GO 

--NOTE: That BETWEEN is inclusive of both range values 



USE AdventureWorks2008
GO

SELECT	BusinessEntityID AS EmployeeID 
		,NationalIDNumber AS NationalID 
		,LoginID AS LoginID 
		,JobTitle AS JobTitle
		,BirthDate AS Birthday
FROM HumanResources.Employee
WHERE BirthDate NOT BETWEEN '01/01/1980' AND '01/01/1985'
GO 