/*
Chunking Data Modifications with TOP

	I demonstrated using TOP in Chapter 1. TOP can also be used in DELETE, INSERT, or UPDATE statements
as well. This recipe further demonstrates using TOP to “chunk” data modifications, meaning instead
of executing a very large operation in a single statement call, you can break the modification into
smaller pieces, potentially increasing performance and improving database concurrency for larger,
frequently accessed tables. This technique is often used for large data loads to reporting or data
warehouse applications.

	Large, single-set updates can cause the database transaction log to grow considerably. When
processing in chunks, each chunk is committed after completion, allowing SQL Server to potentially
reuse that transaction log space. In addition to transaction log space, on a very large data update, if
the query must be cancelled, you may have to wait a long time while the transaction rolls back. With
smaller chunks, you can continue with your update more quickly. Also, chunking allows more concurrency
against the modified table, allowing user queries to jump in, instead of waiting several
minutes for a large modification to complete.

	In this recipe, I show you how to modify data in blocks of rows in multiple executions, instead
of an entire result set in one large transaction. First, I create an example deletion table for this
recipe:

*/

USE AdventureWorks2008
GO

SELECT *
INTO Production.Example_BillOfMaterials
FROM Production.BillOfMaterials

-- Next, all rows will be deleted from the table in 500-row chunks:

WHILE (SELECT COUNT(*)FROM Production.Example_BillOfMaterials)> 0
BEGIN
	DELETE TOP(500)
	FROM Production.Example_BillOfMaterials
END

/*
This returns
(500 row(s) affected)
(500 row(s) affected)
(500 row(s) affected)
(500 row(s) affected)
(500 row(s) affected)
(179 row(s) affected)
*/