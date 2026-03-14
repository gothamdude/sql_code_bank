USE AdventureWorks2008
GO

SELECT	BusinessEntityID AS EmployeeID 
		,NationalIDNumber AS NationalID 
		,LoginID AS LoginID 
		,JobTitle AS JobTitle
		,BirthDate AS Birthday
FROM HumanResources.Employee
WHERE JobTitle like '%Engineer%'
GO 

SELECT DISTINCT LastName 
FROM Person.Person
WHERE LastName LIKE 'Ki[m-p]';

SELECT DISTINCT LastName 
FROM Person.Person
WHERE LastName LIKE 'Ki[m,n,o,p]';


SELECT DISTINCT LastName 
FROM Person.Person
WHERE LastName LIKE 'Ki[^m]';  -- '^' means exlcude 'm' from pattern match


SELECT LastName 
FROM Person.Person
WHERE LastName LIKE 'Ber[r,g]%'


SELECT LastName 
FROM Person.Person
WHERE LastName LIKE 'Ber[^r]%'

SELECT LastName 
FROM Person.Person
WHERE LastName LIKE 'Be%n_'  -- '_'  means one character after
