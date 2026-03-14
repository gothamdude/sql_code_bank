/*
Inserting a Row into a Table with a uniqueidentifier Column

In this recipe, I’ll show you how to insert data into a table that uses a uniqueidentifier column.
This data type is useful in scenarios where your identifier must be unique across several SQL Server
instances. For example, if you have ten remote SQL Server instances generating records that are
then consolidated on a single SQL Server instance, using an IDENTITY value generates the risk of primary
key conflicts. Using a uniqueidentifier data type would allow you to avoid this.

A uniqueidentifier data type stores a 16-byte globally unique identifier (GUID) that is often
used to ensure uniqueness across tables within the same or a different database. GUIDs offer an
alternative to integer value keys, although their width compared to integer values can sometimes
result in slower query performance for bigger tables.

To generate this value for a new INSERT, the NEWID system function is used. NEWID generates a
unique uniqueidentifier data type value, as this recipe demonstrates:

*/

INSERT Purchasing.ShipMethod (Name, ShipBase, ShipRate, rowguid)
VALUES('MIDDLETON CARGO TS1', 8.99, 1.22, NEWID())

SELECT RowGuid, Name 
FROM Purchasing.ShipMethod
WHERE Name = 'MIDDLETON CARGO TS1'

-- This returns the following (if you are following along, note that your Rowguid value will be different from mine):

------------------------------------------------------------------------
-- Rowguid									Name
-- 174BE850-FDEA-4E64-8D17-C019521C6C07	MIDDLETON CARGO TS1
------------------------------------------------------------------------
