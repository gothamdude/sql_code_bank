USE AdventureWorks2008
GO 

--In order to demonstrate OUTER APPLY, I’ll insert a new row into Production.WorkOrder (see Chapter 2
-- for a review of the INSERT command):

	INSERT INTO [AdventureWorks2008].[Production].[WorkOrder]
	([ProductID]
	,[OrderQty]
	,[ScrappedQty]
	,[StartDate]
	,[EndDate]
	,[DueDate]
	,[ScrapReasonID]
	,[ModifiedDate])
	VALUES
	(1,
	1,
	1,
	GETDATE(),
	GETDATE(),
	GETDATE(),
	1,
	GETDATE())

/* 
Because this is a new row, and because Production.WorkOrder has an IDENTITY column for the
WorkOrderID, the new row will have the maximum WorkOrderID in the table. Also, this new row will
not have an associated value in the Production.WorkOrderRouting table, because it was just added.
Next, a CROSS APPLY query is executed, this time qualifying it to only return data for the newly
inserted row:
*/

	SELECT w.WorkOrderID,
			w.OrderQty,
			r.ProductID,
			r.OperationSequence
	FROM Production.WorkOrder AS w
		CROSS APPLY dbo.fn_WorkOrderRouting (w.WorkOrderID) AS r
	WHERE w.WorkOrderID IN 	(SELECT MAX(WorkOrderID) FROM Production.WorkOrder)


-- This returns nothing, because the left table’s new row is unmatched:
-- WorkOrderID OrderQty ProductID OperationSequence
-- (0 row(s) affected)

-- Now an OUTER APPLY is tried instead, which then returns the row from WorkOrder in spite 
-- of there being no associated value in the table-valued function:

	SELECT w.WorkOrderID,
		w.OrderQty,
		r.ProductID,
		r.OperationSequence
	FROM Production.WorkOrder AS w OUTER APPLY dbo.fn_WorkOrderRouting (w.WorkOrderID) AS r
	WHERE w.WorkOrderID IN 	(SELECT MAX(WorkOrderID) FROM Production.WorkOrder)

/* This returns
-------------------------------------------
WorkOrderID OrderQty ProductID OperationSequence
72592		1		NULL		NULL
(1 row(s) affected)
--------------------------------------------

How It Works
CROSS and OUTER APPLY provide a method for applying lookups against columns using a table-valued
function. CROSS APPLY was demonstrated against a row without a match in the table-valued function
results. Since CROSS APPLY works like an INNER JOIN, no rows were returned. In the second
query of this example, OUTER APPLY was used instead, this time returning unmatched NULL rows
from the table-valued function, similar to an OUTER JOIN.

*/