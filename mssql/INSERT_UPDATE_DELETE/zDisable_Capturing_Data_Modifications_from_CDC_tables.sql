
/* 
Disabling Change Data Capture from Tables and the Database

This recipe demonstrates how to remove Change Data Capture from a table. To do so, I’ll execute
the sys.sp_cdc_disable_table stored procedure. In this example, I will disable all Change Tracking
from the table that may exist:
*/


EXEC sys.sp_cdc_disable_table 'dbo', 'Equipment', 'all'

-- I can then validate that the table is truly disabled by executing the following query:

SELECT is_tracked_by_cdc
FROM sys.tables
WHERE name = 'Equipment' and schema_id = SCHEMA_ID('dbo')

/*
This returns
is_tracked_by_cdc
0
(1 row(s) affected)

To disable CDC for the database itself, I execute the following stored procedure:
*/ 


EXEC sys.sp_cdc_disable_db

/* This returns 
Command(s) completed successfully.

*/