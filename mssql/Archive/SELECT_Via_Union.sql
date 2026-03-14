USE AdventureWorks2008
GO 


-- Folding one table results to another 
-- e.g. one production table and one archive table 
-- UNION -- eliminate duplicates 
-- UNION ALL -- does not eliminate duplicate


SELECT BusinessEntityID AS ID   -- only put alias in first select 
FROM HumanResources.Employee
UNION 
SELECT BusinessEntityID
FROM Person.Person 
UNION 
SELECT SalesOrderID				-- can union with other ID, though senseless 
FROM Sales.SalesOrderHeader
ORDER BY ID						-- ORDER BY only in last line 


SELECT BusinessEntityID AS ID   -- only put alias in first select 
FROM HumanResources.Employee
UNION 
SELECT BusinessEntityID
FROM Person.Person 
UNION 
SELECT SalesOrderID				-- can union with other ID, though senseless 
FROM Sales.SalesOrderHeader
ORDER BY ID						-- ORDER BY only in last line 


-- THIS ONE PRODUCES Duplicates 
SELECT BusinessEntityID AS ID   
FROM HumanResources.Employee
UNION ALL
SELECT BusinessEntityID
FROM Person.Person 
UNION ALL
SELECT SalesOrderID				
FROM Sales.SalesOrderHeader
ORDER BY ID	