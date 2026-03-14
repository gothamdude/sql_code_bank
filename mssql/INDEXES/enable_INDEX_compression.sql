/*
Reducing Index Size

As I covered in Chapter 4, the SQL Server 2008 Enterprise and Developer Editions introduce pageand
row-level compression for tables, indexes, and the associated partitions. In that chapter, I
demonstrated how to enable compression using the DATA_COMPRESSION clause in conjunction with
the CREATE TABLE and ALTER TABLE commands. That covered how you compress clustered indexes
and heaps. For nonclustered indexes, you use CREATE INDEX and ALTER INDEX to implement compression.
The syntax remains the same, designating the DATA_COMPRESSION option along with a value
of either NONE, ROW, or PAGE. The following example demonstrates adding a nonclustered index with
PAGE-level compression (based on the example table ArchiveJobPosting that I created in Chapter 4):
*/
CREATE NONCLUSTERED INDEX NCI_SalesOrderDetail_CarrierTrackingNumber
ON Sales.SalesOrderDetail (CarrierTrackingNumber)
WITH (DATA_COMPRESSION = PAGE)


-- I canmodify the compression level after the fact by using ALTER INDEX. In this example, I use
-- ALTER INDEX to change the compression level to row-level compression:

ALTER INDEX NCI_SalesOrderDetail_CarrierTrackingNumber
ON Sales.SalesOrderDetail
REBUILD
WITH (DATA_COMPRESSION = ROW)

/*

How It Works

This recipe demonstrated enabling row and page compression for a nonclustered index. The
process for adding compression is almost identical to that of adding compression for the clustered
index or heap, using the DATA_COMPRESSION index option.When creating a new index, the WITH clause
follows the index key definition.Whenmodifying an existing index, the WITH clause follows the
REBUILD keyword.
*/