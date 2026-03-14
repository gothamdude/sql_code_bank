USE AdventureWorks2008
GO 


SELECT DISTINCT s.PurchaseOrderNumber
FROM Sales.SalesOrderHeader s
	INNER JOIN (SELECT SalesOrderID
				FROM Sales.SalesOrderDetail 
				WHERE UnitPrice BETWEEN 1000 AND 2000) d ON s.SalesOrderID = d.SalesOrderID