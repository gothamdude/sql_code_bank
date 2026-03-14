/*
Tracking Net Data Changes with Minimal Disk Overhead

CDC was intended to be used for asynchronous tracking of incremental data changes for data stores
and warehouses and also provides the ability to detect intermediate changes to data. Unlike CDC,
Change Tracking is a synchronous process that is part of the transaction of a DML operation itself
(INSERT/UPDATE/DELETE) and is intended to be used for detecting net row changes with minimal disk
storage overhead.

The synchronous behavior of Change Tracking allows for a transactionally consistent view of
modified data, as well as the ability to detect data conflicts. Applications can use this functionality
with minimal performance overhead and without the need to add supporting database object modifications
(no custom change-detection triggers or table timestamps needed).

In this recipe, I値l walk through how to use the new Change Tracking functionality to detect
DML operations. To begin with, I値l create a new database that will be used to demonstrate this
functionality:

*/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'TSQLRecipeChangeTrackDemo')
BEGIN
	CREATE DATABASE TSQLRecipeChangeTrackDemo
END
GO


/* 
To enable Change Tracking functionality for the database, I have to configure the CHANGE_
TRACKING database option. I also can configure how long changes are retained in the database and
whether or not automatic cleanup is enabled. Configuring your retention period will impact how
much Change Tracking is maintained for the database. Setting this value too high can impact storage.
Setting it too low could cause synchronization issues with the other application databases if the
remote applications do not synchronize often enough:
*/

ALTER DATABASE TSQLRecipeChangeTrackDemo
SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 36 HOURS, AUTO_CLEANUP = ON)


/* 
A best practice when using Change Tracking is to enable the database for Snapshot Isolation.
For databases and tables with significant DML activity, it will be important that you capture Change
Tracking information in a consistent fashion揚rabbing the latest version and using that version
number to pull the appropriate data.

Not using Snapshot Isolation can result in transactionally inconsistent change information:
*/


ALTER DATABASE TSQLRecipeChangeTrackDemo
SET ALLOW_SNAPSHOT_ISOLATION ON
GO


-- I can confirmthat I have properly enabled the database for Change Tracking by querying sys.change_tracking_databases:

SELECT DB_NAME(database_id) DBNM,is_auto_cleanup_on,
retention_period,retention_period_units_desc
FROM sys.change_tracking_databases

-- This returns 
-- DBNM						is_auto_cleanup_on retention_period retention_period_units_desc
-- TSQLRecipeChangeTrackDemo	1					36							HOURS


USE TSQLRecipeChangeTrackDemo
GO

CREATE TABLE dbo.BookStore
(BookStoreID int NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
BookStoreNM varchar(30) NOT NULL,
TechBookSection bit NOT NULL)
GO

/* 
Next, for each table that I wish to track changes for, I need to use the ALTER TABLE command
with the CHANGE_TRACKING option. If I also want to track which columns were updated, I need to
enable the TRACK_COLUMNS_UPDATED option, as demonstrated next:
*/ 

ALTER TABLE dbo.BookStore  
ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)


-- I can validate which tables are enabled for Change Tracking by querying the sys.change_tracking_tables catalog view:

SELECT OBJECT_NAME(object_id) ObjNM,is_track_columns_updated_on
FROM sys.change_tracking_tables

-- This returns
---------------------------------------------------
ObjNM		is_track_columns_updated_on
BookStore	1
---------------------------------------------------

-- Now I will demonstrate Change Tracking by doing an initial population of the table with three new rows:

INSERT dbo.BookStore (BookStoreNM, TechBookSection)
VALUES ('McGarnicles and Bailys', 1), ('Smith Book Store', 0), ('University Book Store',1)

/*
One new function I can use for ongoing synchronization is the CHANGE_TRACKING_CURRENT_
VERSION function, which returns the version number from the last committed transaction for the
table. Each DML operation that occurs against a change-tracked table will cause the version number
to increment. I値l be using this version number later on to determine changes:
*/

SELECT CHANGE_TRACKING_CURRENT_VERSION ()

/*
To detect changes, I can use the CHANGETABLE function. This function has two varieties of usage,
using the CHANGES keyword to detect changes as of a specific synchronization version and using the
VERSION keyword to return the latest Change Tracking version for a row.

I値l start off by demonstrating how CHANGES works. The following query demonstrates returning
the latest changes to the BookStore table as of version 0. The first parameter is the name of the
Change Tracking table, and the second parameter is the version number:

SELECT BookStoreID,SYS_CHANGE_OPERATION, SYS_CHANGE_VERSION
FROM CHANGETABLE (CHANGES dbo.BookStore, 0) AS CT


This returns the primary key of the table, followed by the DML operation type (I for INSERT, U for UPDATE, and D for DELETE), 
and the associated row version number (since all three rows were added for a single INSERT, they all share the same version number):

----------------------------------------------------------
BookStoreID SYS_CHANGE_OPERATION SYS_CHANGE_VERSION
1 I 1
2 I 1
3 I 1
----------------------------------------------------------
*/

UPDATE dbo.BookStore SET BookStoreNM = 'King Book Store' WHERE BookStoreID = 1
UPDATE dbo.BookStore SET TechBookSection = 1 WHERE BookStoreID = 2
DELETE dbo.BookStore WHERE BookStoreID = 3

-- I値l check the latest version number:
SELECT CHANGE_TRACKING_CURRENT_VERSION () 

-- This is now incremented by three (there were three operations that acted against the data):
-- 4

-- Now let痴 assume that an external application gathered information as of version 1 of the data.
-- The following query demonstrates how to detect any changes that have occurred since version 1:

SELECT BookStoreID,
SYS_CHANGE_VERSION,
SYS_CHANGE_OPERATION,
SYS_CHANGE_COLUMNS
FROM CHANGETABLE
(CHANGES dbo.BookStore, 1) AS CT


This returns information on the rows that were modified since version 1, displaying the primary
keys for the two updates I performed earlier and the primary key for the row I deleted:
BookStoreID SYS_CHANGE_VERSION SYS_CHANGE_OPERATION SYS_CHANGE_COLUMNS
1 2 U 0x0000000002000000
2 3 U 0x0000000003000000
3 4 D NULL

SELECT BookStoreID,
CHANGE_TRACKING_IS_COLUMN_IN_MASK(
COLUMNPROPERTY(
OBJECT_ID('dbo.BookStore'),'BookStoreNM', 'ColumnId') ,
SYS_CHANGE_COLUMNS) IsChanged_BookStoreNM,
CHANGE_TRACKING_IS_COLUMN_IN_MASK(
COLUMNPROPERTY(
OBJECT_ID('dbo.BookStore'), 'TechBookSection', 'ColumnId') ,
SYS_CHANGE_COLUMNS) IsChanged_TechBookSection
FROM CHANGETABLE
(CHANGES dbo.BookStore, 1) AS CT
WHERE SYS_CHANGE_OPERATION = 'U'