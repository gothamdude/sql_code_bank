/* 

Removing Partition Functions and Schemes

If you try to drop a partition function or scheme while it is still bound to an existing table or index,
you’ll get an errormessage. You also can’t directly remove a partition scheme or function while it is
bound to a table (unless you drop the entire table as will be done in this recipe). If you had originally
created the table as a heap (a table without a clustered index), and then created a clustered
index bound to a partition scheme, you can use the CREATE INDEX DROP_EXISTING option (see
Chapter 5) to rebuild the index without the partition scheme reference.

Dropping a partition scheme uses the following syntax:

	DROP PARTITION SCHEME partition_scheme_name

This command takes the name of the partition scheme to drop.
Dropping a partition function uses the following syntax:

	DROP PARTITION FUNCTION partition_function_name

Again, this command only takes the partition function name that should be dropped.
This example demonstrates how to drop a partition function and scheme, assuming that it is
okay in this scenario to drop the source tables (which oftentimes in a production scenario will not
be acceptable!):
*/

DROP TABLE Sales.WebSiteHitsHistory
DROP TABLE Sales.WebSiteHits

-- Dropping the partition scheme and function
DROP PARTITION SCHEME HitDateRangeScheme
DROP PARTITION FUNCTION HitDateRange