USE AdventureWorks2008
GO

/*
In this recipe, I’ll show you how to drop an index froma table or view.When you drop an index, it is
physically removed fromthe database. If this is a clustered index, the table’s data remains in an
unordered (heap) form. You can remove an index entirely froma database by using the DROP INDEX
command. The basic syntax is as follows:
*/

DROP INDEX HumanResources.TerminationReason.UNI_TerminationReason

/* 
How It Works

You can drop one ormore indexes for a table using the DROP INDEX command. Dropping an index
frees up the space taken up by the index and removes the index definition fromthe database. You
can’t use DROP INDEX to remove indexes that result fromthe creation of a PRIMARY KEY or UNIQUE
CONSTRAINT. If you drop a clustered index that has nonclustered indexes on it, those nonclustered
indexes will also be rebuilt in order to swap the clustered index key for a row identifier of the heap.

*/