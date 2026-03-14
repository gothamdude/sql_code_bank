
-- Creating a TableVariable to Hold a Temporary Result Set

DECLARE @ProductCostStatistics TABLE ( 
	ProductID int NOT NULL PRIMARY KEY,
	AvgStandardCost money NOT NULL,
	ProductCount int NOT NULL
)

INSERT @ProductCostStatistics (ProductID, AvgStandardCost, ProductCount)
SELECT ProductID, AVG(StandardCost) AvgStandardCost, COUNT(ProductID) Rowcnt
FROM Production.ProductCostHistory
GROUP BY ProductID

SELECT TOP 3 * 
FROM @ProductCostStatistics
ORDER BY ProductCount