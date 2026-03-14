/*

In this recipe, I’ll show you how to allow query activity to continue to access the index even while an
index creation process is executing. If you are using SQL Server Enterprise Edition, you can allow
concurrent user query access to the underlying table during the index creation by using the new
ONLINE option, which is demonstrated in this next recipe:

*/

USE AdventureWorks2008
GO

CREATE NONCLUSTERED INDEX NCI_ProductVendor_MiNOrderQty 
ON Purchasing.ProductVendor(MinOrderQty) 
WITH (ONLINE=ON)
GO 


-- NOTE ONLY AVAILABLE FOR Enterprise Edition
/*
How It Works

With the new ONLINE option in the WITH clause of the index creation, long-termtable locks are not
held during the index creation. This can provide better concurrency on larger indexes that contain
frequently accessed data.When the ONLINE option is set ON, only intent share locks are held on the
source table for the duration of the index creation, instead of the default behavior of a longer-term
table lock held for the duration of the index creation.

*/