/*
Ranking Functions
Ranking functions allow you to return ranking values associated to each row in a result set. Table 8-8
describes the four ranking functions.

Table 8-8. Ranking Functions
----------------------------------------------------------------------------------------------
Function		Description
----------------------------------------------------------------------------------------------
ROW_NUMBER		ROW_NUMBER returns an incrementing integer for each row in a set.
RANK			Similar to ROW_NUMBER, RANK increments its value for each row in the set. The key
				difference is if rows with tied values exist, they will receive the same rank value.
DENSE_RANK		DENSE_RANK is almost identical to RANK, only DENSE_RANK doesn’t return gaps in the
				rank values when there are tied values.
NTILE			NTILE divides the result set into a specified number of groups, based on the
				ordering and optional partition clause.
----------------------------------------------------------------------------------------------
*/

-- Generating an Incrementing Row Number
SELECT p.ProductID, p.Name, p.RowNumber 
FROM (SELECT ProductID,
		Name,
		ROW_NUMBER() OVER (ORDER BY Name) RowNumber
		FROM Production.Product) p
WHERE p.RowNumber BETWEEN 255 AND 260

-- The optional partition_by_clause allows you to restart row numbering for each change in the
-- partitioned column. In this example, the results are partitioned by Shelf and ordered by ProductID:
SELECT Shelf, ProductID, ROW_NUMBER() OVER (PARTITION BY Shelf ORDER BY ProductID) RowNumber
FROM Production.ProductInventory


/*
Returning Rows by Rank
In this recipe, I’ll demonstrate using the RANK function to apply rank values based on a SalesQuota
value. RANK returns the rank of a row within a result set (or rank of row within a partition within a
result set, if you designate the optional partition clause). The syntax for RANK is as follows:
RANK ( ) OVER ( [ < partition_by_clause > ] < order_by_clause > )
The key difference is if rows with tied values exist, they will receive the same rank value, as this
example demonstrates: */

SELECT BusinessEntityID,
QuotaDate,
SalesQuota,
RANK() OVER (ORDER BY SalesQuota DESC) as RANK
FROM Sales.SalesPersonQuotaHistory
WHERE SalesQuota BETWEEN 266000.00 AND 319000.0

/*
The OVER clause contains an optional partition_by_clause and a required order_by_clause,
just like ROW_NUMBER. The order_by_clause determines the order that RANK values are applied to each
row, and the optional partition_by_clause is used to further divide the ranking groups, as demonstrated
in the next example: */ 
SELECT h.BusinessEntityID,
s.TerritoryID,
h.QuotaDate,
h.SalesQuota,
RANK() OVER (PARTITION BY s.TerritoryID ORDER BY h.SalesQuota DESC) as RANK
FROM Sales.SalesPersonQuotaHistory h
INNER JOIN Sales.SalesPerson s ON
h.BusinessEntityID = s.BusinessEntityID
WHERE s.TerritoryID IN (5,6,7)

-- This returns ranking of SalesQuota partitioned by the salesperson’s TerritoryID:

/* In this recipe, I’ll demonstrate DENSE_RANK, which is almost identical to RANK, only DENSE_RANK doesn’t
return gaps in the rank values: */
SELECT BusinessEntityID,
SalesQuota,
DENSE_RANK() OVER (ORDER BY SalesQuota DESC) as DENSE_RANK
FROM Sales.SalesPersonQuotaHistory
WHERE SalesQuota BETWEEN 266000.00 AND 319000.00

/*
Using NTILE
NTILE divides the result set into a specified number of groups based on the ordering and optional
partition. The syntax is very similar to the other ranking functions, only it also includes an
integer_expression:
NTILE (integer_expression) OVER ( [ < partition_by_clause > ] < order_by_clause > )
The integer_expression is used to determine the number of groups to divide the results into.
This example demonstrates the NTILE ranking function against the Sales.SalePersonQuotaHistory
table:*/ 

SELECT	BusinessEntityID,
		SalesQuota,
		NTILE(4) OVER (ORDER BY SalesQuota DESC) as NTILE
FROM Sales.SalesPersonQuotaHistory
WHERE SalesQuota BETWEEN 266000.00 AND 319000.00





