USE AdventureWorks2008
GO

/*
In this recipe, I’ll show you how to drop and re-create an index within a single execution, as well as
change the key column definition of an existing index. The ALTER INDEX can be used to change
index options, rebuild and reorganize indexes (reviewed in Chapter 23), and disable an index, but it
is not used to actually add, delete, or rearrange columns in the index.

You can, however, change the column definition of an existing index by using CREATE
INDEX...DROP_EXISTING. This option also has the advantage of dropping and re-creating an index
within a single command (instead of using both DROP INDEX and CREATE INDEX). Also, using
DROP_EXISTING on a clustered index will not cause existing nonclustered indexes to be automatically
rebuilt, unless the index column definition has changed.

This first example demonstrates just rebuilding an existing nonclustered index (no change in
the column definition):

*/

CREATE NONCLUSTERED INDEX NCI_TerminationReason_DepartmentID 
ON  HumanResources.TerminationReason (DepartmentID ASC) 
WITH (DROP_EXISTING=ON)
GO 

-- Next, a new column is added to the existing nonclustered index:
CREATE NONCLUSTERED INDEX NCI_TerminationReason_DepartmentID 
ON  HumanResources.TerminationReason (ViolationSeverityLevel, DepartmentID DESC) 
WITH(DROP_EXISTING=ON)
GO 




