/* 
Implementing Table Partitioning

In this recipe, I’ll demonstrate how to

	• Create a filegroup or filegroups to hold the partitions.
	• Add files to each filegroup used in the partitioning.
	• Use the CREATE PARTITION FUNCTION command to determine how the table’s data will be
	partitioned.
	• Use the CREATE PARTITION SCHEME command to bind the PARTITION FUNCTION to the specified
	filegroups.
	• Create the table, binding a specific partitioning column to a PARTITION SCHEME.

The recipe creates a table called Sales.WebSiteHits, which is used to track each hit to a hypothetical
web site. In this scenario, the table is expected to grow large quickly. Because of the
potential size, queriesmay not performas well as they could, and backup operations against the
entire database take longer than the currentmaintenance window allows.

To address this application scenario, the data fromthis table will be partitioned horizontally,
whichmeans that groups of rows based on a selected column (in this case HitDate) will be mapped
into separate underlying physical files on the disk. 

The first part of this example demonstrates adding the new filegroups to the AdventureWorks database:

*/
USE AdventureWorks2008
GO 

ALTER DATABASE AdventureWorks2008
ADD FILEGROUP hitfg1 

ALTER DATABASE AdventureWorks2008
ADD FILEGROUP hitfg2

ALTER DATABASE AdventureWorks2008
ADD FILEGROUP hitfg3

ALTER DATABASE AdventureWorks2008
ADD FILEGROUP hitfg4

-- Next, for each new filegroup created, a new database file is added to it:

ALTER DATABASE AdventureWorks2008
ADD FILE 
	(NAME = awhitfg1, 
	 FILENAME = 'C:\SQLData\aw_hitfg1.ndf',
	 SIZE = 1MB
	 )
TO FILEGROUP hitfg1 
GO 

ALTER DATABASE AdventureWorks2008 
ADD FILE 
	( NAME = awhitfg2,
	  FILENAME = 'C:\SQLData\aw_hitfg2.ndf',
	  SIZE = 1MB
	  )
TO FILEGROUP hitfg2 
GO 

ALTER DATABASE AdventureWorks2008 
ADD FILE 
	( NAME = awhitfg3,
	  FILENAME = 'C:\SQLData\aw_hitfg3.ndf',
	  SIZE = 1MB
	  )
TO FILEGROUP hitfg3 
GO 

ALTER DATABASE AdventureWorks2008 
ADD FILE 
	( NAME = awhitfg4,
	  FILENAME = 'C:\SQLData\aw_hitfg4.ndf',
	  SIZE = 1MB
	  )
TO FILEGROUP hitfg4 
GO 

/*
Now that the filegroups are ready for their partitioned data, the partition function will be created, 
which determines how the table will have its data horizontally partitioned (in this case, by date range):
*/

CREATE PARTITION FUNCTION HitDateRange(datetime)
AS RANGE LEFT FOR VALUES ('1/1/2006', '1/1/2007', '1/1/2008')
GO 

/*
After creating the partition function, I create the partition scheme in order to bind the partition
function to the new filegroups:
*/

CREATE PARTITION SCHEME HitDateRangeScheme 
AS PARTITION HitDateRange TO (hitfg1, hitfg2, hitfg3, hitfg4) 

-- Lastly, I create a table that uses the partition scheme on the HitDate column in the ON clause of the CREATE TABLE statement:

CREATE TABLE Sales.WebSiteHits(
	WebSiteHitID bigint NOT NULL IDENTITY(1,1),
	WebSitePage varchar(255) NOT NULL,
	HitDate datetime NOT NULL,
	CONSTRAINT PK_WebSiteHits PRIMARY KEY (WebSiteHitID, HitDate)
)
ON [HitDateRangeScheme] (HitDate)


/*
How It Works

In the first part of the recipe, four new filegroups were added to the AdventureWorks database. After
that, a database file was added to each filegroup.

Next, a partition function was created that defined the partition boundaries for the partition
function and the expected partition column data type. On the first line of the CREATE PARTITION
FUNCTION command, the datetime data type was selected:

	CREATE PARTITION FUNCTION HitDateRange (datetime)

The next line defined the ranges for values for the partition function, creating partitions
by year:

	AS RANGE LEFT FOR VALUES ('1/1/2006', '1/1/2007', '1/1/2008')

You can define up to 999 partitions (however, thatmany isn’t recommended due to potential
performance concerns). The number of values you choose amounts to a total of n + 1 partitions. You
also have a choice of LEFT or RIGHT, which defines the boundary that the defined values belong to. In
this recipe, LEFT was chosen. Table 4-17 shows the partition boundaries (or partitions where rows
will be placed) in this case.

Table 4-17. LEFT Boundaries
--------------------------------------------------------------------------------------------------------------
Partition #		Lower Bound datetime		Upper Bound datetime
--------------------------------------------------------------------------------------------------------------
1				Lowest allowed datetime		1/1/2006 00:00:00
2				1/1/2006 00:00:01			1/1/2007 00:00:00
3				1/1/2007 00:00:01			1/1/2008 00:00:00
4				1/1/2008 00:00:01			Highest allowed datetime
--------------------------------------------------------------------------------------------------------------

Had RIGHT been chosen instead, the partition boundaries would have been as shown in
Table 4-18.

Table 4-18. RIGHT Boundaries
--------------------------------------------------------------------------------------------------------------
Partition #		Lower Bound datetime		Upper Bound datetime
--------------------------------------------------------------------------------------------------------------
1				Lowest allowed datetime		12/31/2005 12:59:59
2				1/1/2006 00:00:00			12/31/2006 12:59:59
3				1/1/2007 00:00:00			12/31/2007 12:59:59
4				1/1/2008 00:00:00			Highest allowed datetime
--------------------------------------------------------------------------------------------------------------


Once a partition function is created, it can be used with one ormore partition schemes. A partition
schememaps the partitions defined in a partition function to actual filegroups. The first line
of the new partition scheme defined the partition scheme name:

	CREATE PARTITION SCHEME HitDateRangeScheme

The second line of code defined the partition function of the partition scheme it is bound to
(the function created in the previous step):

	AS PARTITION HitDateRange

The TO clause defines which filegroupsmap to the four partitions defined in the partition function,
in order of partition sequence:

	TO ( hitfg1, hitfg2, hitfg3, hitfg4 )

After a partition scheme is created, it can then be bound to a table. In the CREATE TABLE statement’s
ON clause (last row of the table definition), the partition scheme is designated with the
column to partition in parentheses:

	CREATE TABLE Sales.WebSiteHits	(
		WebSiteHitID bigint NOT NULL IDENTITY(1,1),
		WebSitePage varchar(255) NOT NULL,
		HitDate datetime NOT NULL,
		CONSTRAINT PK_WebSiteHits
		PRIMARY KEY (WebSiteHitID, HitDate)
	) ON [HitDateRangeScheme] (HitDate)

Notice that the primary key ismade up of both the WebSiteHitID and HitDate. The partitioned
key column (HitDate)must be part of the primary key. 
The Sales.WebSiteHits table is now partitioned—and can be worked with just like a single regular
table. You needn’t do anything special to your SELECT, INSERT, UPDATE, or DELETE statements. In
the background, as data is added, rows are inserted into the appropriate filegroups based on the
partition function and scheme.









