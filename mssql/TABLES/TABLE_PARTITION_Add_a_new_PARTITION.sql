/* 
Over time, you may decide that your partitioned table needs additional partitions (for example, you
can create a new partition for each new year). To add a new partition, the ALTER PARTITION SCHEME
and ALTER PARTITION FUNCTION commands are used.

Before a new partition can be created on an existing partition function, you must first prepare a
filegroup for use in holding the new partition data (a new or already used filegroup can be used).
The first step is designating the next partition filegroup to use with ALTER PARTITION SCHEME.

The syntax for ALTER PARTITION SCHEME is as follows:

	ALTER PARTITION SCHEME partition_scheme_name
	NEXT USED [ filegroup_name ]

Table 4-20 details the arguments of this command.
Table 4-20. ALTER PARTITION SCHEME Arguments
--------------------------------------------------------------------------------------------------------------
Argument						Description
--------------------------------------------------------------------------------------------------------------
partition_scheme_name			This specifies the name of the partition scheme tomodify.
NEXT USED [filegroup_name]		The NEXT USED keywords queues the next filegroup to be used by
								any new partition.
--------------------------------------------------------------------------------------------------------------

After adding a reference to the next filegroup, ALTER PARTITION FUNCTION is used to create
(split) the new partition (and also remove/merge a partition). The syntax for ALTER PARTITION
FUNCTION is as follows:

	ALTER PARTITION FUNCTION partition_function_name()
	{
		SPLIT RANGE ( boundary_value ) | MERGE RANGE ( boundary_value )
	}

Table 4-21 details the arguments of this command.
Table 4-21. ALTER PARTITION FUNCTION Arguments
--------------------------------------------------------------------------------------------------------------
Argument							Description
--------------------------------------------------------------------------------------------------------------
partition_function_name				This specifies the name of the partition function to add or
									remove a partition from.
SPLIT RANGE ( boundary_value ) |	SPLIT RANGE is used to create a new partition by defining
MERGE RANGE ( boundary_value )		a new boundary value. MERGE RANGE is used to remove an existing partition.
--------------------------------------------------------------------------------------------------------------

This example demonstrates how to create (split) a new partition. The first step is creating a new
filegroup to be used by the new partition. In this example, the PRIMARY filegroup is used:
*/

ALTER PARTITION SCHEME HitDateRangeScheme
NEXT USED [PRIMARY]

/*
Next, the partition function ismodified to create a new partition, defining a boundary of
January 1, 2009:
*/

ALTER PARTITION FUNCTION HitDateRange ()
SPLIT RANGE ('1/1/2009')

-- After the new partition is created, a new row is inserted to test the new partition: 

INSERT Sales.WebSiteHits (WebSitePage, HitDate)
VALUES ('Sales Page', '3/4/2009')

-- The table is queried using $PARTITION: 

SELECT HitDate, $PARTITION.HitDateRange (HitDate) Partition
FROM Sales.WebSiteHits

SELECT HitDate,
$PARTITION.HitDateRange (HitDate) Partition
FROM Sales.WebSiteHits


This shows the newly inserted row has been stored in the new partition (partition number 5):
--------------------------------------------------------------------------------------------------------------
HitDate					Partition
--------------------------------------------------------------------------------------------------------------
2000-03-04 00:00:00.000 1
2006-10-02 00:00:00.000 2
2007-10-22 00:00:00.000 3
2008-05-09 00:00:00.000 4
2009-03-04 00:00:00.000 5
--------------------------------------------------------------------------------------------------------------

/*
How It Works

In this recipe’s example, the HitDateRangeScheme was altered using ALTER PARTITION SCHEME and the
NEXT USED keywords. The NEXT USED keywords queue the next filegroup to be used by any new partition.
In this example, the default PRIMARY filegroup was selected as the destination for the new
partition:

	ALTER PARTITION SCHEME HitDateRangeScheme
	NEXT USED [PRIMARY]

ALTER PARTITION FUNCTION was then used with SPLIT RANGE in order to add a new partition
boundary:

	ALTER PARTITION FUNCTION HitDateRange ()
	SPLIT RANGE ('1/1/2006')

Only one value was used to add the new partition, which essentially splits an existing partition
range into two, using the original boundary type (LEFT or RIGHT). You can only use SPLIT RANGE for a
single split at a time—and you can’t addmultiple partitions in a statement.
This example’s split added a new partition, partition 5, as shown in Table 4-22.

Table 4-22. New Partition Layout
--------------------------------------------------------------------------------------------------------------
Partition # Lower Bound datetime	Upper Bound datetime
--------------------------------------------------------------------------------------------------------------
1			Lowest allowed datetime 1/1/2006 00:00:00
2			1/1/2006 00:00:01		1/1/2007 00:00:00
3			1/1/2007 00:00:01		1/1/2008 00:00:00
4			1/1/2008 00:00:01		1/1/2009 00:00:00
5			1/1/2009 00:00:01		Highest allowed datetime
--------------------------------------------------------------------------------------------------------------

A new row was inserted into the Sales.WebSiteHits table, which used the partition function. A
query was executed to view the partitions that each row belongs in, and it is confirmed that the new
row was inserted into the fifth partition.
*/

