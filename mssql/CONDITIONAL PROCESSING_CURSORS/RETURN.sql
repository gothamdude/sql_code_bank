
-- This example demonstrates how to use RETURN to unconditionally stop a query:
IF NOT EXISTS (SELECT ProductID FROM Production.Product WHERE Color = 'Pink')
BEGIN
	RETURN
END
-- Won't execute
SELECT ProductID
FROM Production.Product
WHERE Color = 'Pink'


/*
RETURN also allows for an optional integer expression:

RETURN [ integer_expression ]

This integer value can be used in a stored procedure to communicate issues to the calling
application. For example:
*/

-- Create a temporary Stored Procedure that raises a logical error
CREATE PROCEDURE #usp_TempProc
AS
SELECT 1/0
RETURN @@ERROR
GO

-- Next, the stored procedure is executing, capturing the RETURN code in a local variable:
DECLARE @ErrorCode int
EXEC @ErrorCode = #usp_TempProc
PRINT @ErrorCode

/* 
This returns the divide-by-zero error, followed by the error number that was printed:
Msg 8134, Level 16, State 1, Procedure #usp_TempProc________00000B72,
Line 4
Divide by zero error encountered.
8134
*/