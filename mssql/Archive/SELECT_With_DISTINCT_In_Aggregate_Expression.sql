USE AdventureWorks2008
GO 

-- DISTINCT Within an aggregate expression 

SELECT SUM(TotalDue) As TotalOfAllOrders, 
	SUM (Distinct TotalDue) As TotalOfDistinctTotalDue 
FROM Sales.SalesOrderHeader

