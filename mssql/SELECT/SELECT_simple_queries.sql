USE AdventureWorks2008
GO 

-- select specific columns from a table 
SELECT NationalIDNumber, LoginID, JobTitle 
FROM [HumanResources].[Employee]

-- WHERE clause 
SELECT Title, FirstName, LastName 
From Person.Person 
WHERE Title = 'Ms.'

-- AND condition
SELECT Title, FirstName, LastName 
From Person.Person 
WHERE Title = 'Ms.' 
	AND LastName = 'Antrim'

-- OR condition
SELECT Title, FirstName, LastName 
From Person.Person 
WHERE Title = 'Ms.' 
	OR LastName = 'Antrim'

-- NOT 
SELECT Title, FirstName, LastName 
From Person.Person 
WHERE NOT Title = 'Ms.' 

-- Keeping WHERE unambiguous 
SELECT Title, FirstName, LastName 
From Person.Person 
WHERE (Title = 'Ms.' AND FirstName ='Catherine') OR LastName ='Adams'

-- BETWEEN date ranges 
SELECT	SalesOrderID, 
		ShipDate
FROM Sales.SalesOrderHeader
WHERE ShipDate BETWEEN '7/28/2005 00:00:00' AND '7/29/2005 23:59.59'

-- COMPARISON (i.e. <)
SELECT ProductID, 
		Name, 
		StandardCost
FROM Production.Product
WHERE StandardCost < 110.0000

-- check for NULL values 
SELECT ProductID, 
		Name, 
		[Weight] 
FROM Production.Product
WHERE [Weight] IS NULL 

-- returning rows based on a list of values 
SELECT  ProductID,
		Name, 
		Color 
FROM Production.Product
WHERE Color IN ('Silver', 'Black', 'Red')

-- using Wildacards with LIKE
SELECT  ProductID,
		Name 
FROM Production.Product 
WHERE Name LIKE 'B%'


-- using COLUMN Aliases 
SELECT Color AS 'Grouped Color',
		AVG(DISTINCT ListPrice) AS 'Average Distinct List Price',
		AVG(ListPrice) 'Average List Price'
FROM Production.Product
GROUP BY Color









