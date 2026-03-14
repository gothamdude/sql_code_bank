/*
Modifying Data Through aView

As Imentioned at the beginning of the chapter, you can performinserts, updates, and deletes
against a view, just like you would a regular table. In order to do this, any INSERT/UPDATE/DELETE
operations can reference columns only froma single table. Also, the columns being referenced in
the INSERT/UPDATE/DELETE cannot be derived—for example, they can’t be calculated, based on an
aggregate function, or be affected by a GROUP BY, DISTINCT, or HAVING clause.

As a real-world best practice, view updatesmay be appropriate for situations where the underlying
data tablesmust be obscured fromthe query author. For example, if you are building a
shrink-wrapped software application that allows users to directly update the data, providing views
will allow you to filter the underlying columns that are viewed or providemore user-friendly column
names than what you find used in the base tables.

In this example, a view is created that selects fromthe Production.Location table. A calculated
column is also used in the query definition:
*/

CREATE VIEW Production.vw_Location
AS
SELECT LocationID,
Name LocationName,
CostRate,
Availability,
CostRate/Availability CostToAvailabilityRatio
FROM Production.Location
GO

-- The following insert is attempted:

INSERT Production.vw_Location
(LocationName, CostRate, Availability, CostToAvailabilityRatio)
VALUES ('Finishing Cabinet', 1.22, 75.00, 0.01626 )

-- This returns the following error:
----------------------------------------------------------------------------------------------------------------
Msg 4406, Level 16, State 1, Line 1
Update or insert of view or function 'Production.vw_Location' failed because it contains a derived or constant field.
----------------------------------------------------------------------------------------------------------------

-- This next insert is attempted, this time only referencing the columns that exist in the base table:

INSERT Production.vw_Location
(LocationName, CostRate, Availability)
VALUES ('Finishing Cabinet', 1.22, 75.00)

/*
The results show that the insert succeeded:
(1 row(s) affected)