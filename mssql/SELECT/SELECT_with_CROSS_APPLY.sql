USE AdventureWorks2008
GO 

/* 
Using APPLY to Invoke a Table-Valued Function for Each Row

APPLY is used to invoke a table-valued function for each row of an outer query. A table-valued
function returns a result set based on one or more parameters. Using APPLY, the input of these
parameters are the columns of the left referencing table. This is useful if the left table contains
columns and rows that must be evaluated by the table-valued function and to which the results
from the function should be attached.

CROSS APPLY works like an INNER JOIN in that unmatched rows between the left table and the
table-valued function don’t appear in the result set. 

OUTER APPLY is like an OUTER JOIN, in that nonmatched rows are still returned in the result set 
with NULL values in the function results.
*/


-- In this recipe, a table-valued function is created that returns work order routing 
-- information based on the WorkOrderID passed to it:

CREATE FUNCTION dbo.fn_WorkOrderRouting 
(@WorkOrderID int) 
RETURNS TABLE
AS
RETURN
	SELECT WorkOrderID,
	ProductID,
	OperationSequence,
	LocationID
FROM Production.WorkOrderRouting
WHERE WorkOrderID = @WorkOrderID
GO

-- Next, the WorkOrderID is passed from the Production.WorkOrder table to the new function:
SELECT	w.WorkOrderID,
		w.OrderQty,
		r.ProductID,
		r.OperationSequence
FROM Production.WorkOrder w
	CROSS APPLY dbo.fn_WorkOrderRouting (w.WorkOrderID) AS r
ORDER BY w.WorkOrderID, 
		 w.OrderQty,
		 r.ProductID
/*

This returns the following (abridged) results:

-----------------------------------------------------
WorkOrderID OrderQty ProductID OperationSequence
13 4 747 1
13 4 747 2
13 4 747 3
13 4 747 4
13 4 747 6
...
72586 1 803 6
72587 19 804 1
72587 19 804 6
(67131 row(s) affected)
-----------------------------------------------------

How It Works

The first part of this recipe was the creation of a table-valued function. The function accepts a
single parameter, @WorkOrderID, and when executed, returns the WorkOrderID, ProductID,
OperationSequence, and LocationID from the Production.WorkOrderRouting table for the specified
WorkOrderID.
The next query in the example returned the WorkOrderID and OrderQty from the Production.
WorkOrder table. In addition to this, two columns from the table-valued function were selected:

	SELECT w.WorkOrderID,
	w.OrderQty,
	r.ProductID,
	r.OperationSequence

The key piece of this recipe comes next. Notice that in the FROM clause, the Production.
WorkOrder table is joined to the new table-valued function using CROSS APPLY, only unlike a JOIN
clause, there isn’t an ON followed by join conditions. Instead, in the parentheses after the function
name, the w.WorkOrderID is passed to the table-valued function from the left Production.WorkOrder
table:

	FROM Production.WorkOrder w
	CROSS APPLY dbo.fn_WorkOrderRouting
	(w.WorkOrderID) AS r

The function was aliased like a regular table, with the letter r.

Lastly, the results were sorted:

	ORDER BY w.WorkOrderID,
	w.OrderQty,
	r.ProductID

In the results for WorkOrderID 13, each associated WorkOrderRouting row was returned next to
the calling tables WorkOrderID and OrderQty. Each row of the WorkOrder table was duplicated for
each row returned from fn_WorkOrderRouting—all were based on the WorkOrderID.



