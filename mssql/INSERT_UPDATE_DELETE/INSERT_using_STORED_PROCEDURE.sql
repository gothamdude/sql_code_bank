/* 
The syntax for inserting data from a stored procedure is as follows:
INSERT
	[ INTO]
	table_or_view_name [ ( column_list ) ]
EXEC stored_procedure_name
*/


CREATE PROCEDURE dbo.usp_SEL_Production_TransactionHistory
	@ModifiedStartDT datetime,
	@ModifiedEndDT datetime
AS
SELECT TransactionID, 
		ProductID, 
		ReferenceOrderID, 
		ReferenceOrderLineID,
		TransactionDate, 
		TransactionType, 
		Quantity, 
		ActualCost, 
		ModifiedDate
FROM Production.TransactionHistory
WHERE ModifiedDate BETWEEN @ModifiedStartDT AND @ModifiedEndDT 
		AND TransactionID NOT IN  (SELECT TransactionID FROM Production.TransactionHistoryArchive)
GO

-- Next, this example tests the stored procedures to precheck which rows will be inserted:
EXEC dbo.usp_SEL_Production_TransactionHistory '9/2/07', '9/3/07'

-- This returns 568 rows based on the date range passed to the procedure. 
-- In the next example, this stored procedure is used to insert the 568 rows into the Production.TransactionHistoryArchive table:

INSERT Production.TransactionHistoryArchive (
		TransactionID, 
		ProductID, 
		ReferenceOrderID, 
		ReferenceOrderLineID, 
		TransactionDate,
		TransactionType, 
		Quantity, 
		ActualCost, 
		ModifiedDate)
EXEC dbo.usp_SEL_Production_TransactionHistory  '9/2/07', '9/3/07'