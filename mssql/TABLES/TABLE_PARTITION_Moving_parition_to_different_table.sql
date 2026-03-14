/* 
Moving a Partition to a Different Table

With SQL Server’s partitioning functionality, you can transfer partitions between different tables
with aminimumof effort or overhead. You can transfer partitions between tables using ALTER
TABLE... SWITCH. Transfers can take place in three different ways: switching a partition froma partitioned
table to another partitioned table (both needing to be partitioned on the same column),
transferring an entire table froma non-partitioned table to a partitioned table, ormoving a partition
froma partitioned table to a non-partitioned table.

The basic syntax for switching partitions between tables is as follows:
	ALTER TABLE tablename
	SWITCH [ PARTITION source_partition_number_expression ]
	TO [ schema_name. ] target_table
	[ PARTITION target_partition_number_expression ]

Table 4-24 details the arguments of this command.
Table 4-24. ALTER TABLE...SWITCH Arguments
--------------------------------------------------------------------------------------------------------------
Argument										Description
--------------------------------------------------------------------------------------------------------------
tablename										The source table tomove the partition from
source_partition_number_expression				The partition number being relocated
[ schema_name. ] target_table					The target table to receive the partition
partition.target_partition_number_expression	The destination partition number
--------------------------------------------------------------------------------------------------------------

This example demonstratesmoving a partition between Sales.WebSiteHits and a new table 
called Sales.WebSiteHitsHistory. In the first step, a new table is created to hold historical 
web site hit information:
*/

CREATE TABLE Sales.WebSiteHitsHistory(
	WebSiteHitID bigint NOT NULL IDENTITY(1,1),
	WebSitePage varchar(255) NOT NULL,
	HitDate datetime NOT NULL,
	CONSTRAINT PK_WebSiteHitsHistory PRIMARY KEY (WebSiteHitID, HitDate)
	) ON [HitDateRangeScheme] (HitDate)
	
-- Next, ALTER TABLE is used to move partition 3 from Sales.WebSiteHits to partition 3 of the new Sales.WebSiteHitsHistory table:

	ALTER TABLE Sales.WebSiteHits SWITCH PARTITION 3
	TO Sales.WebSiteHitsHistory PARTITION 3

-- Next, a query is executed using $PARTITION to view the transferred data in the new table:

SELECT HitDate, $PARTITION.HitDateRange (HitDate) Partition
FROM Sales.WebSiteHitsHistory

/*
This returns
--------------------------------------------------------------------------------------------------------------
HitDate						Partition
--------------------------------------------------------------------------------------------------------------
2008-05-09 00:00:00.000		3
--------------------------------------------------------------------------------------------------------------
*/

/*
How It Works
The first part of the recipe created a new table called Sales.WebSiteHitsHistory and used the same
partition scheme as the Sales.WebSiteHits table.
The source table and partition number to transfer was referenced in the first line of the ALTER
TABLE command:

ALTER TABLE Sales.WebSiteHits SWITCH PARTITION 3

The TO keyword designated the destination table and partition tomove the data to:

TO Sales.WebSiteHitsHistory PARTITION 3

Moving partitions between tables ismuch faster than performing amanual row operation
(INSERT..SELECT, for example) because you aren’t actuallymoving physical data. Instead, you are
only changing themetadata regarding where the partition is currently stored. Also, keep inmind
that the target partition of any existing table needs to be empty for the destination partition. If it is
a non-partitioned table, itmust also be empty.
*/