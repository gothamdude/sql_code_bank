USE AdventureWorks2008
GO 

SELECT TOP 10 v.Name,
		v.CreditRating
FROM Purchasing.Vendor v
ORDER BY v.CreditRating DESC, 
		v.Name