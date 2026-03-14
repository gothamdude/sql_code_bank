USE AdventureWorks2008
GO 

SELECT s.BusinessEntityID,
		SUM(s2006.SalesQuota) Total_2006_SQ,
		SUM(s2005.SalesQuota) Total_2005_SQ
FROM Sales.SalesPerson s
	LEFT OUTER JOIN Sales.SalesPersonQuotaHistory s2006 
		ON s.BusinessEntityID = s2006.BusinessEntityID AND YEAR(s2006.QuotaDate)= 2006
	LEFT OUTER JOIN Sales.SalesPersonQuotaHistory s2005 
		ON s.BusinessEntityID = s2005.BusinessEntityID AND YEAR(s2005.QuotaDate)= 2005
GROUP BY s.BusinessEntityID