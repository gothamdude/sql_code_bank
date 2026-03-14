/*
A column defined within a CREATE TABLE or ALTER TABLE statement can be derived froma freestanding
or column-based calculation. Computed columns are sometimes useful when a calculation
must be recomputed on the same data repeatedly in referencing queries. A computed column is
based on an expression defined when you create or alter the table, and is not physically stored in
the table unless you use the PERSISTED keyword.

In this recipe, I’ll give a demonstration of creating a computed column, as well as presenting
ways to take advantage of SQL Server 2005’s PERSISTED option. The syntax for adding a computed
column either by CREATE or ALTER TABLE is as follows:

column_name AS computed_column_expression
[ PERSISTED ]

The column_name is the name of the new column. The computed_column_expression is the
calculation you wish to be performed in order to derive the column’s value. Adding the PERSISTED
keyword actually causes the results of the calculation to be physically stored.
In this example, a new, calculated column is added to an existing table:

*/

ALTER TABLE Production.TransactionHistory
ADD CostPerUnit AS (ActualCost/Quantity)

-- The previous example created a calculated column called CostPerUnit. This next query takes
-- advantage of it, returning the highest CostPerUnit for quantities over 10:

SELECT * 
FROM Production.TransactionHistory

-- YOU CAN SEE COMPUTED COLUMN APPEARS AS 0.00's 

SELECT TOP 1 CostPerUnit, Quantity, ActualCost
FROM Production.TransactionHistory
WHERE Quantity > 10
ORDER BY ActualCost DESC