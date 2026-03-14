USE AdventureWorks2008
GO

/*

In this recipe, I’ll show you how to push index creation processing to the tempdb systemdatabase.
The tempdb systemdatabase is used tomanage user connections, temporary tables, temporary
stored procedures, or temporary work tables needed to process queries on the SQL Server instance.
Depending on the database activity on your SQL Server instance, you can sometimes reap performance
benefits by isolating the tempdb database on its own disk array, separate fromother databases.
If index creation times are taking too long for what you expect, you can try to use the index option
SORT_IN_TEMPDB to improve index build performance (for larger tables). This option pushes the
intermediate index build results to the tempdb database instead of using the user database where
the index is housed.

The syntax for this option, which can be used in both CREATE INDEX and ALTER INDEX, is as
follows:

WITH (SORT_IN_TEMPDB = { ON | OFF })
The default for this option is OFF. In this example, I’ll create a new nonclustered index with the
SORT_IN_TEMPDB option enabled:
*/

CREATE NONCLUSTERED INDEX NI_Address_PostalCode 
ON Person.Address (PostalCode) 
WITH (SORT_IN_TEMPDB = ON) 
GO 