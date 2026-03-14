/*

In this recipe, I’ll show you how to change the lock resource types that can be locked for a specific
index. In Chapter 3, I discussed various lock types and resources within SQL Server. Specifically, various
resources can be locked by SQL Server fromsmall (row and key locks) tomedium(page locks,
extents) to large (table, database).Multiple, smaller-grained locks help with query concurrency,
assuming there are a significant number of queries simultaneously requesting data fromthe same
table and associated indexes. Numerous locks take upmemory, however, and can lower performance
for the SQL Server instance as a whole. The trade-off is larger-grained locks, which increase
memory resource availability but also reduce query concurrency.

You can create an index that restricts certain locking types when it is queried. Specifically, you
can designate whether page or row locks are allowed.

In general you should allow SQL Server to automatically decide which locking type is best;
however, theremay be a situation where you wish to temporarily restrict certain resource locking
types, for troubleshooting or a severe performance issue.
The syntax for configuring these options for both CREATE INDEX and ALTER INDEX is as follows:

WITH ( ALLOW_ROW_LOCKS = { ON | OFF }
| ALLOW_PAGE_LOCKS = { ON | OFF })

This recipe shows you how to disable the database engine’s ability to place row or page locks on
an index, forcing it to use table locking instead:

*/

-- Disable page locks. Table and row locks can still be used.
CREATE INDEX NI_EmployeePayHistory_Rate ON
HumanResources.EmployeePayHistory (Rate)
WITH (ALLOW_PAGE_LOCKS=OFF)
-- Disable page and row locks. Only table locks can be used.
ALTER INDEX NI_EmployeePayHistory_Rate ON
HumanResources.EmployeePayHistory
SET (ALLOW_PAGE_LOCKS=OFF,ALLOW_ROW_LOCKS=OFF )
-- Allow page and row locks.
ALTER INDEX NI_EmployeePayHistory_Rate ON
HumanResources.EmployeePayHistory
SET (ALLOW_PAGE_LOCKS=ON,ALLOW_ROW_LOCKS=ON )


/*
This recipe demonstrated three variations. The first query created a new index on the table, configured
so that the database engine couldn’t issue page locks against the index:
WITH (ALLOW_PAGE_LOCKS=OFF)
In the next statement, both page and row locks were turned OFF (the default for an index is for
both to be set to ON):

ALTER INDEX NI_EmployeePayHistory_Rate ON
HumanResources.EmployeePayHistory
SET (ALLOW_PAGE_LOCKS=OFF,ALLOW_ROW_LOCKS=OFF )

In the last statement, page and row locking is reenabled:
SET (ALLOW_PAGE_LOCKS=ON,ALLOW_ROW_LOCKS=ON )
Removing locking options should only be done if you have a good reason to do so—for example,
youmay have activity that causes toomany row locks, which can eat upmemory resources.
Instead of row locks, youmay wish to have SQL Server use larger-grained page or table locks
instead.

*/