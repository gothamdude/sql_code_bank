USE AdventureWorks2008
GO 

-- One reason to use sa subquery is to find the rows in one table that match another table 
-- withou actually joining the second table.  If yoou do not need data from second table, use subquery

PRINT 'Products located in Tool Crib, which still have more than 20 in quantity:'
SELECT ProductID, Name, ProductNumber, ListPrice
FROM Production.Product 
WHERE ProductID IN (
		SELECT DISTINCT ProductID
		FROM Production.ProductInventory 
		WHERE Quantity > 20
			AND LocationID = 1
		)
		
		
-- Using NOT IN  ; find customer without order		
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE CustomerID NOT IN ( SELECT CustomerID FROM Sales.SalesOrderHeader)

-- NOTE: When using NOT IN, getting a NULL values will give incorrect results 
-- so make sure to to check for IS NOT NULL 
SELECT CurrencyRateID, FromCurrencyCode, ToCurrencyCode  
FROM Sales.CurrencyRate
WHERE CurrencyRateID NOT IN  (
		SELECT CurrencyRateID 
		FROM Sales.SalesOrderHeader
		WHERE CurrencyRateID IS NOT NULL)

-- THIS ONE BELOW WILL BREAK AND NOT GIVE ANYTHING BECAUSE CANNOT COMPARE TO NULL 		
SELECT CurrencyRateID, FromCurrencyCode, ToCurrencyCode  
FROM Sales.CurrencyRate
WHERE CurrencyRateID NOT IN  (
		SELECT CurrencyRateID 
		FROM Sales.SalesOrderHeader)



