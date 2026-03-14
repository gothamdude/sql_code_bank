USE AdventureWorks2008
GO 


SELECT	BusinessEntityID, 
		GETDATE() QuotaDate, 
		SalesQuota
FROM Sales.SalesPerson
WHERE SalesQuota > 0
UNION
SELECT	BusinessEntityID, 
		QuotaDate, 
		SalesQuota
FROM Sales.SalesPersonQuotaHistory
WHERE SalesQuota > 0
ORDER BY BusinessEntityID DESC, QuotaDate DESC