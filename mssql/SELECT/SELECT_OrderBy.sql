USE AdventureWorks2008
GO 

SELECT p.Name,
	h.EndDate,
	h.ListPrice
FROM Production.Product p
		INNER JOIN Production.ProductListPriceHistory h ON p.ProductID = h.ProductID
ORDER BY p.Name, h.EndDate