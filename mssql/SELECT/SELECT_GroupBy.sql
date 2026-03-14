USE AdventureWorks2008
GO 


SELECT OrderDate,
	SUM(TotalDue) TotalDueByOrderDate 
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '7/1/2005' AND '7/31/2005' 
GROUP BY  OrderDate