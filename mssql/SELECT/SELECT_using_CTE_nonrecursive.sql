/*

A Common Table Expression, or CTE, is similar to a view or derived query, allowing you to create a
temporary query that can be referenced within the scope of a SELECT, INSERT, UPDATE, or DELETE
query. Unlike a derived query, you don’t need to copy the query definition multiple times each time
it is used. You can also use local variables within a CTE definition—something you can’t do in a view
definition.

The basic syntax for a CTE is as follows:

	WITH expression_name [ ( column_name [ ,...n ] ) ]
	AS ( CTE_query_definition )

The arguments of a CTE are described in the Table 1-4.
------------------------------------------------------------------------------------
Table 1-4. CTE Arguments
Argument Description
expression_name			The name of the common table expression
column_name [ ,...n ]	The unique column names of the expression
CTE_query_definition	The SELECT query that defines the common table expression
------------------------------------------------------------------------------------

A non-recursive CTE is one that is used within a query without referencing itself. It serves as a
temporary result set for the query. A recursive CTE is defined similarly to a non-recursive CTE, only
a recursive CTE returns hierarchical self-relating data. Using a CTE to represent recursive data can
minimize the amount of code needed compared to other methods.
The next two recipes will demonstrate both non-recursive and recursive CTEs.

Using a Non-Recursive Common Table Expression
This example of a common table expression demonstrates returning vendors in the
Purchasing.Vendor table—returning the first five and last five results ordered by name:

*/

WITH VendorSearch (RowNumber, VendorName, AccountNumber)
AS (
	SELECT ROW_NUMBER() OVER (ORDER BY Name) RowNum,
		Name,
		AccountNumber
	FROM Purchasing.Vendor
	)

SELECT	RowNumber,
		VendorName,
		AccountNumber
FROM VendorSearch
WHERE RowNumber BETWEEN 1 AND 5
UNION
SELECT	RowNumber,
		VendorName,
		AccountNumber
FROM VendorSearch
WHERE RowNumber BETWEEN 100 AND 104