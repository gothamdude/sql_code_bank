USE AdventureWorks2008
GO 

-- Using CTE for inner join
WITH Orders AS (
	SELECT SalesOrderID, CustomerID
	FROM Sales.SalesOrderHeader
	)

SELECT c.CustomerID, orders.SalesOrderID
FROM Sales.Customer AS C
	INNER JOIN Orders ON c.CustomerID = orders.CustomerID


-- Using CTE to solve a tricky query 
-- For examples, suppose you wanted to product a list of all customers 
-- along with orders, if any places on a certain date 

SELECT c.CustomerID, s.SalesOrderID, s.OrderDate 
FROM Sales.Customer AS c
	LEFT OUTER JOIN Sales.SalesOrderHeader AS S ON c.CustomerID = s.CustomerID 
WHERE s.OrderDate = '2005/07/01';

-- A BETTER WAY 
WITH orders AS ( 
	SELECT SalesOrderID, CustomerID, OrderDate 
	FROM Sales.SalesOrderHeader 
	WHERE OrderDate = '2005/07/01')

SELECT c.CustomerID, orders.SalesOrderID, orders.OrderDate 
FROM Sales.Customer AS c
	LEFT OUTER JOIN orders  ON c.CustomerID = orders.CustomerID 
ORDER BY orders.OrderDate DESC 
