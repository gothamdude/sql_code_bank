USE AdventureWorks2008
GO 


-- CORRELATED SubQuery in WHERE Clause 
SELECT CustomerID, SalesOrderID, TotalDue
FROM Sales.SalesOrderHeader AS soh 
WHERE 1000 < (
	SELECT SUM(TotalDue) 
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = soh.CustomerID )
	
	
-- Performance of INLINE correlated subquery is very bad 	
-- INLINE CORRELATED SubQuery 
SELECT CustomerID, 
	(SELECT COUNT(*) 
	 FROM Sales.SalesOrderHeader 
	 WHERE CustomerID = c.CustomerID) As CountOfSales
FROM Sales.Customer AS c 
ORDER BY CountOfSales DESC

	