USE AdventureWorks2008
GO 


-- all other columns should be in GroupBy clause  except the column being grouped by  
-- must include exact expression in SELECT clause 

-- 1
SELECT CustomerID, SUM(TotalDue) As TotalPerCustomer 
FROM Sales.SalesOrderHeader 
GROUP BY CustomerID 

--2
SELECT CustomerID, AVG(TotalDue) As TotalPerCustomer 
FROM Sales.SalesOrderHeader 
GROUP BY TerritoryID 


--- GROUP BY on expressions 
SELECT	COUNT(*) As CountOfOrders, 
		YEAR(OrderDate) AS OrderYear 
FROM Sales.SalesOrderHeader 
GROUP By OrderDate


SELECT	COUNT(*) As CountOfOrders, 
		YEAR(OrderDate) AS OrderYear 
FROM Sales.SalesOrderHeader 
GROUP By YEAR(OrderDate)


-- with WHERE clause 

SELECT CustomerID, SUM(TotalDue) As TotalPerCustomer
FROM Sales.SalesOrderHeader 
WHERE TerritoryID IN (5,6) 
GROUP BY CustomerID

--  with HAVING clause 
SELECT CustomerID, SUM(TotalDue) As TotalPerCustomer 
FROM Sales.SalesOrderHeader 
GROUP BY CustomerID 
HAVING COUNT(*) = 10 AND SUM(TotalDue) > 5000 









