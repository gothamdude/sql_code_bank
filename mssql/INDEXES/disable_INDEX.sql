USE AdventureWorks2008
GO

/*
In this recipe, I’ll show you how to disable an index from being used in SQL Server queries. Disabling
an index retains the metadata definition data in SQL Server butmakes the index unavailable
for use. Consider disabling an index as an index troubleshooting technique or if a disk error has
occurred and you would like to defer the index’s re-creation.

■ Caution If you disable a clustered index, keep in mind that the table index data will no longer be accessible.
This is because the leaf level of a clustered index is the actual table data itself. Also, reenabling the index means
either re-creating or rebuilding it (see the “How It Works” section for more information).

An index is disabled by using the ALTER INDEX command. The syntax is as follows:

ALTER INDEX index_name ON
table_or_view_name DISABLE

The command takes two arguments, the name of the index, and the name of the table or view
that the index is created on.

In this example, I will disable the UNI_TerminationReason index on the TerminationReason table:

*/

ALTER INDEX UNI_TerminationReason ON HumanResources.TerminationReason DISABLE 

/*

How It Works

This recipe demonstrated how to disable an index. If an index is disabled, the index definition
remains in the systemtables, although the user can no longer use the index. For nonclustered
indexes on a table, the index data is actually removed fromthe database. For a clustered index on a
table, the data remains on disk, but because the index is disabled, you can’t query it. For a clustered
or nonclustered index on the view, the index data is removed fromthe database.

To reenable the index, you can use either the CREATE INDEX with DROP_EXISTING command (see
later in this chapter) or ALTER INDEX REBUILD (described in Chapter 23). Rebuilding a disabled nonclustered
index reuses the existing space used by the original index.
*/


