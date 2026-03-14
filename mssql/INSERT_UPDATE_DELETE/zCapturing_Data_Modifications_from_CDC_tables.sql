/*
Asynchronously Capturing Table Data Modifications

SQL Server 2008 provides a built-in method for asynchronously tracking all data modifications that
occur against your user tables without your having to code your own custom triggers or queries.
Change Data Capture has minimal performance overhead and can be used for incremental updates
of other data sources, for example, migrating changes made in the OLTP database to your data
warehouse database. The next set of recipes will demonstrate how to use this new functionality.
*/

USE master
GO

-- To begin with, I’ll create a new database that will be used to demonstrate this functionality:
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'TSQLRecipe_CDC_Demo')
BEGIN
	CREATE DATABASE TSQLRecipe_CDC_Demo
END
GO

-- In this first recipe, I’ll demonstrate adding CDC to a table in the TSQLRecipe_CDC_Demo database.
-- The first step is to validate whether the database is enabled for Change Data Capture:

SELECT is_cdc_enabled
FROM sys.databases
WHERE name = 'TSQLRecipe_CDC_Demo'

-- This returns
-- is_cdc_enabled
-- 0

/* Change Data Capture is configured and managed using various stored procedures. In order to
enable the database, I’ll execute the sys.dp_cdc_enable_db stored procedure in the context of the
TSQLRecipe_CDC_Demo database:*/

USE TSQLRecipe_CDC_Demo
GO
EXEC sys.sp_cdc_enable_db
G

-- Msg 22988, Level 16, State 1, Procedure sp_cdc_enable_db, Line 14
-- This instance of SQL Server is the Standard Edition (64-bit). Change data capture is only available in the Enterprise, Developer, and Enterprise Evaluation editions.


-- In this recipe, I would like to track all changes against the following new table:

USE TSQLRecipe_CDC_Demo
GO

CREATE TABLE dbo.Equipment
(EquipmentID int NOT NULL PRIMARY KEY IDENTITY(1,1),
EquipmentDESC varchar(100) NOT NULL,
LocationID int NOT NULL)
GO

-- I would like to be able to capture all changes made to rows, as well as return just the net
-- changes for a row. For other options, I’ll be going with the default:

EXEC sys.sp_cdc_enable_table @source_schema = 'dbo', 
				@source_name = 'Equipment', 
				@role_name = NULL, 
				@capture_instance = NULL, 
				@supports_net_changes = 1,
				@index_name = NULL,
				@captured_column_list = NULL,
				@filegroup_name = default

--EXEC sys.sp_cdc_help_change_data_capture 'dbo', 'Equipment'

/*
How It Works
In this recipe, I started off by enabling CDC capabilities for the database using sp_cdc_enable_db.
Behind the scenes, enabling CDC for the database creates a new schema called cdc and a few new
tables in the database, detailed in Table 2-9. You shouldn’t need to query these tables directly, as
there are system stored procedures and functions that can return the same data in a cleaner format.

-----------------------------------------------------------------------------------------------------
Table 2-9. CDC System Tables
Table Description
cdc.captured_columns	Returns the columns tracked for a specific capture instance.
cdc.change_tables		Returns tables created when CDC is enabled for a table. Use
						sys.sp_cdc_help_change_data_capture to query this information
						rather than query this table directly.
cdc.ddl_history			Returns rows for each DDL change made to the table, once CDE is
						enabled. Use sys.sp_cdc_get_ddl_history instead of querying this
						table directly.
cdc.index_columns		Returns index columns associated with the CDC-enabled table. Query
						sys.sp_cdc_help_change_data_capture to retrieve this information
						rather than querying this table directly.
cdc.lsn_time_mapping	Helps you map the log sequence number to transaction begin and end
						times. Again, avoid querying the table directly, and instead use the
						functions sys.fn_cdc_map_lsn_to_time and sys.fn_cdc_map_time_to_lsn.
-----------------------------------------------------------------------------------------------------
*/

USE TSQLRecipe_CDC_Demo
GO

INSERT dbo.Equipment (EquipmentDESC, LocationID)
VALUES ('Projector A', 22) 

INSERT dbo.Equipment (EquipmentDESC, LocationID)
VALUES ('HR File Cabinet', 3)

UPDATE dbo.Equipment
SET EquipmentDESC = 'HR File Cabinet 1'
WHERE EquipmentID = 2

DELETE dbo.Equipment
WHERE EquipmentID = 1

/* 
After making the changes, I can now view a history of what was changed using the CDC functions.
Data changes are tracked at the log sequence number (LSN) level. An LSN is a record in the
transaction log that uniquely identifies activity.

I will now pull the minimum and maximum LSN values based on the time range I wish to pull
changes for. To determine LSN, I’ll use the sys.fn_cdc_map_time_to_lsn function, which takes two
input parameters, the relational operator, and the tracking time (there are other ways to do this,
which I demonstrate later on in the chapter). The relational operators are as follows:

• Smallest greater than
• Smallest greater than or equal
• Largest less than
• Largest less than or equal
These operators are used in conjunction with the Change Tracking time period you specify to
help determine the associated LSN value. For this recipe, I want the minimum and maximum LSN
values between two time periods:
*/ 

SELECT sys.fn_cdc_map_time_to_lsn ('smallest greater than or equal' , '2008-03-16 09:34:11') as BeginLSN
SELECT sys.fn_cdc_map_time_to_lsn ('largest less than or equal' , '2008-03-16 23:59:59') as EndLSN

/*
This returns the following results (your actual LSN if you are following along will be different):

BeginLSN
0x0000001C000001020001
(1 row(s) affected)

EndLSN
0x0000001C000001570001
(1 row(s) affected)

I now have my LSN boundaries to detect changes that occurred during the desired time range.

My next decision is whether or not I wish to see all changes or just net changes. I can call the
same functions demonstrated in the previous query in order to generate the LSN boundaries and
populate them into variables for use in the cdc.fn_cdc_get_all_changes_dbo_Equipment function.
As the name of that function suggests, I’ll demonstrate showing all changes first:

*/ 

DECLARE @FromLSN varbinary(10) = sys.fn_cdc_map_time_to_lsn ( 'smallest greater than or equal' , '2008-03-16 09:34:11')
DECLARE @ToLSN varbinary(10) = sys.fn_cdc_map_time_to_lsn ( 'largest less than or equal' , '2008-03-16 23:59:59')
SELECT __$operation,
	__	$update_mask,
		EquipmentID,
		EquipmentDESC,
		LocationID
FROM cdc.fn_cdc_get_all_changes_dbo_Equipment (@FromLSN, @ToLSN, 'all')

-- This returns the following result set:
/*
__$operation __$update_mask EquipmentID EquipmentDESC LocationID
2			0x07		1				Projector A				22
2			0x07		2				HR File Cabinet			3
4			0x02		2				HR File Cabinet	1		3
1			0x07		1				Projector A				22

This result set revealed all modifications made to the table. Notice that the function name,
cdc.fn_cdc_get_all_changes_dbo_Equipment, was based on my CDC instance capture name for the
source table. Also notice the values of __$operation and __$update_mask. The __$operation values
are interpreted as follows:

	• 1 is a delete.
	• 2 is an insert.
	• 3 is the “prior” version of an updated row (use all update old option to see—I didn’t use this in the prior query).
	• 4 is the “after” version of an updated row


demonstrate how to translate these values in a separate recipe.
Moving forward in this current recipe, I could have also used the all update old option to
show previous values of an updated row prior to the modification. I can also add logic to translate
the values seen in the result set for the operation type. For example:
*/ 

DECLARE @FromLSN varbinary(10) =  sys.fn_cdc_map_time_to_lsn ( 'smallest greater than or equal' , '2008-03-16 09:34:11')
DECLARE @ToLSN varbinary(10) = sys.fn_cdc_map_time_to_lsn ( 'largest less than or equal' , '2008-03-16 23:59:59')

SELECT
CASE __$operation
	WHEN 1 THEN 'DELETE'
	WHEN 2 THEN 'INSERT'
	WHEN 3 THEN 'Before UPDATE'
	WHEN 4 THEN 'After UPDATE'
	END Operation,
		__$update_mask,
		EquipmentID,
		EquipmentDESC,
		LocationID
FROM cdc.fn_cdc_get_all_changes_dbo_Equipment (@FromLSN, @ToLSN, 'all update old')

-- This returns Operation 

__$update_mask EquipmentID EquipmentDESC LocationID
INSERT			0x07 1 Projector A 22
INSERT			0x07 2 HR File Cabinet 3
Before UPDATE	0x02 2 HR File Cabinet 3
After UPDATE	0x02 2 HR File Cabinet 1 3
DELETE			0x07 1 Projector A 22


