
-- Replacing a NULLValue with an AlternativeValue
SELECT JobCandidateID,BusinessEntityID, ISNULL(BusinessEntityID, 0) Cleaned_BusinessEntityID
FROM HumanResources.JobCandidate


/*
In this recipe, I’ll demonstrate how to performflexible, dynamic searches in a query when the variablesmay
ormay not be populated. This recipe declares three local search variables for ProductID,
StartDate, and StandardCost. By using this technique, your query can return results based on all,
some, or none of the parameters being used. In this example, only a ProductID is supplied: */
-- Local variables used for searches
DECLARE @ProductID int
DECLARE @StartDate datetime
DECLARE @StandardCost money
-- Only @ProductID is used
SET @ProductID = 711
SELECT ProductID, StartDate, StandardCost
FROM Production.ProductCostHistory
WHERE	ProductID = ISNULL(@ProductID, ProductID) AND
		StartDate = ISNULL(@StartDate, StartDate) AND
		StandardCost = ISNULL(@StandardCost, StandardCost)


-- In this second example, a search is performed by aminimumandmaximumStandardCost range:
-- Local variables used for searches
DECLARE @ProductID int
DECLARE @MinStandardCost money
DECLARE @MaxStandardCost money
SET @MinStandardCost = 3.3963
SET @MaxStandardCost = 10.0000
SELECT ProductID, StartDate, StandardCost
FROM Production.ProductCostHistory
WHERE	ProductID = ISNULL(@ProductID, ProductID) 
		AND StandardCost BETWEEN ISNULL(@MinStandardCost, StandardCost) 
		AND ISNULL(@MaxStandardCost, StandardCost)
ORDER BY StandardCost


-- The COALESCE function returns the first non-NULL value froma provided list of expressions. The syntax is as follows:
DECLARE @Value1 int
DECLARE @Value2 int
DECLARE @Value3 int
SET @Value2 = 22
SET @Value3 = 955
SELECT COALESCE(@Value1, @Value2, @Value3)

-- NULLIF returns a NULL value when the two provided expressions have the same value; 
-- otherwise, the first expression is returned.
DECLARE @Value1 int
DECLARE @Value2 int
SET @Value1 = 55
SET @Value2 = 955
SELECT NULLIF(@Value1, @Value2)

DECLARE @Value1 int
DECLARE @Value2 int
SET @Value1 = 55
SET @Value2 = 55
SELECT NULLIF(@Value1, @Value2)