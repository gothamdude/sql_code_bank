/* 
Removing a Partition

The previous recipe showed the syntax for ALTER PARTITION FUNCTION, including a description of the
MERGE RANGE functionality, which is used to remove an existing partition. Removing a partition
essentially merges two partitions into one, with rows relocating to the resultingmerged partition.
This example demonstrates removing the 1/1/2007 partition from the HitDateRange partition
function:
*/

ALTER PARTITION FUNCTION HitDateRange ()
MERGE RANGE ('1/1/2007')

-- Next, the partitioned table is queried using the $PARTITION function:
SELECT HitDate, $PARTITION.HitDateRange (HitDate) Partition
FROM Sales.WebSiteHits

/* 
This returns the following results:

--------------------------------------------------------------------------------------------------------------
HitDate						Partition
--------------------------------------------------------------------------------------------------------------
2000-03-04 00:00:00.000		1
2007-10-22 00:00:00.000		2
2006-10-02 00:00:00.000		2
2008-05-09 00:00:00.000		3
2009-03-04 00:00:00.000		4


How It Works

ALTER PARTITION FUNCTION is used for both splitting and merging partitions. In this case, the MERGE
RANGE keywords were used to eliminate the 1/1/2007 partition boundary:

	ALTER PARTITION FUNCTION HitDateRange ()
	MERGE RANGE ('1/1/2007')

A query was executed to view which rows belong to which partitions. Table 4-23 lists the
boundaries after the MERGE.

Table 4-23. New Partition Layout
--------------------------------------------------------------------------------------------------------------
Partition #			Lower Bound datetime		Upper Bound datetime
--------------------------------------------------------------------------------------------------------------
1					Lowest allowed datetime		1/1/2006 00:00:00
2					1/1/2006 00:00:01			1/1/2008 00:00:00
3					1/1/2008 00:00:01			1/1/2009 00:00:00
4					1/1/2009 00:00:01			Highest allowed datetime
--------------------------------------------------------------------------------------------------------------

Partition 2 now encompasses the data for two years instead of one. You can onlymerge one
partition per ALTER PARTITION FUNCTION execution, and you can’t convert a partitioned table into a
non-partitioned table using ALTER PARTITION