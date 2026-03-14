
-- Using a Temporary Table forMultiple LookupsWithin a Batch

CREATE TABLE #ProductCostStatistics ( 
	ProductID int NOT NULL PRIMARY KEY,
	AvgStandardCost money NOT NULL,
	ProductCount int NOT NULL
	)

INSERT #ProductCostStatistics (ProductID, AvgStandardCost, ProductCount)
SELECT ProductID, AVG(StandardCost) AvgStandardCost, COUNT(ProductID) Rowcnt
FROM Production.ProductCostHistory
GROUP BY ProductID

SELECT TOP 3 * FROM #ProductCostStatistics
ORDER BY AvgStandardCost ASC

SELECT TOP 3 * FROM #ProductCostStatistics
ORDER BY AvgStandardCost DESC

SELECT AVG(AvgStandardCost) Average_of_AvgStandardCost
FROM #ProductCostStatistics

DROP TABLE #ProductCostStatistics