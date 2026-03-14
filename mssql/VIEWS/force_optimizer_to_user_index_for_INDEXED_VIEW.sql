/*
Forcing the Optimizer to Use an Index for an IndexedView

Once you’ve created an indexed view, if you’re running on SQL Server Enterprise Edition, the Query
Optimizer will automatically decide whether or not to use the indexed view in a query. For other
editions, however, in order tomake SQL Server use a specific indexed view, youmust use the
NOEXPAND keyword.

*/

-- This recipe demonstrates how to force an indexed view’s index to be used for a query:
SELECT ProductID
FROM dbo.v_Product_Sales_By_LineTotal
WITH (NOEXPAND)
WHERE ProductName = 'Short-Sleeve Classic Jersey, L'

-- NOEXPAND also allows you to specify one ormore indexes to be used for the query, using the
-- INDEX option. For example:

SELECT ProductID
FROM dbo.v_Product_Sales_By_LineTotal
WITH (NOEXPAND, INDEX(NI_v_Product_Sales_By_LineTotal))
WHERE ProductName = 'Short-Sleeve Classic Jersey, L'