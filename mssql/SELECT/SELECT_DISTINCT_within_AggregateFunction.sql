USE AdventureWorks2008
GO 

SELECT DISTINCT HireDate
FROM HumanResources.Employee


-- compare below 
SELECT AVG(ListPrice)
FROM Production.Product


-- distinct within an aggregate function 
SELECT AVG(DISTINCT ListPrice)
FROM Production.Product