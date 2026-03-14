USE AdventureWorks2008
GO 


-- OVER clause 
-- The OVER clause provides a way to add aggregate values to a non-aggregate query 

SELECT CustomerID, SalesOrderID, TotalDue,
	AVG(TotalDue) OVER (PARTITION BY CustomerID) AS AvgOfTotalDue,
	SUM(TotalDue) OVER (PARTITION BY CustomerID) AS SumOfTotalDue,
	--TotalDue/(SUM(TotalDue) OVER (PARTITION BY CustomerID)) * 100 AS SalesPercentPerCustomer, 
	SUM(TotalDue) OVER() AS SalesOverAll
FROM Sales.SalesOrderHeader 
ORDER BY CustomerID 