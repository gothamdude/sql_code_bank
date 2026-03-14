
-- Determining the First Day of theWeek
SELECT @@DATEFIRST 'First Day of the Week'

/*
How It Works
The @@DATEFIRST function shows the first day of the week setting. To change the first day value, you
can use the SET DATEFIRST command. For example:

SET DATEFIRST 7

When changing this value, 7 is Sunday and 1 isMonday, and so on. This directly impacts the
returned value for the dw (day of week) code for DATEPART and DATEADD functions.
*/

-- This example returns the local language setting currently used in the current query session:
SELECT @@LANGID LanguageID, @@LANGUAGE Language


/* 
Viewing and Setting Current Connection Lock Timeout Settings
The SET LOCK_TIMEOUT command configures the number ofmilliseconds a statement will wait in the
current session for locks to be released by other connections. The @@LOCK_TIMEOUT function is used
to display the current connection lock timeout setting inmilliseconds.
This example demonstrates setting and viewing the current session’s lock timeout value: */ 

-- 1000 milliseconds, 1 second
SET LOCK_TIMEOUT 1000
SELECT @@LOCK_TIMEOUT

-- Unlimited
SET LOCK_TIMEOUT -1

-- Returning the Current SQL Server Instance Name and SQL ServerVersion
SELECT @@SERVERNAME ServerName,
@@VERSION VersionInformation 

-- Returning the Current Connection’s Session ID (SPID)
SELECT @@SPID SPID


-- Returning the Number of Open Transactions
BEGIN TRAN t1
SELECT @@TRANCOUNT -- Returns 1
BEGIN TRAN t2
SELECT @@TRANCOUNT -- Returns 2
BEGIN TRAN t3
SELECT @@TRANCOUNT -- Returns 3
COMMIT TRAN
SELECT @@TRANCOUNT -- Returns 2
ROLLBACK TRAN
SELECT @@TRANCOUNT -- After ROLLBACK, always Returns 0!

-- Retrieving the Number of Rows Affected by the Previous Statement
SELECT TOP 3 ScrapReasonID
FROM Production.ScrapReason

SELECT @@ROWCOUNT Int_RowCount, ROWCOUNT_BIG() BigInt_RowCount

/*
Retrieving SystemStatistics

SQL Server has several built-in systemstatistical functions, which are described in Table 8-9.

Table 8-9. SystemStatistical Functions
Function Description
---------------------------------------------------------------------------------------
@@CONNECTIONS Returns the number of connectionsmade to the SQL Server instance since it
was last started.
@@CPU_BUSY Shows the number of busy CPUmilliseconds since the SQL Server instance
was last started.
@@IDLE Displays the total idle time of the SQL Server instance inmilliseconds since
the instance was last started.
@@IO_BUSY Displays the number ofmilliseconds spent performing I/O operations since
the SQL Server instance was last started.
@@PACKET_ERRORS Displays the total network packet errors that have occurred since the SQL
Server instance was last started.
@@PACK_RECEIVED Returns the total input packets read fromthe network since the SQL Server
instance was last started. You canmonitor whether the number increments or
stays the same, thus surmising whether there is a network availability issue.
@@PACK_SENT Returns the total output packets sent to the network since the SQL Server
instance was last started.
@@TIMETICKS Displays the number ofmicroseconds per tick. A tick is a unit of
measurement designated by a specified number ofmilliseconds (31.25
milliseconds for theWindows OS).
@@TOTAL_ERRORS Displays read/write errors encountered since the SQL Server instance was last
started.
@@TOTAL_READ Displays the number of non-cached disk reads by the SQL Server instance
since it was last started.
@@TOTAL_WRITE Displays the number of disk writes by the SQL Server instance since it was last
started.
---------------------------------------------------------------------------------------
*/
-- This example demonstrates using systemstatistical functions in a query:
SELECT 'Connections' FunctionNM, @@CONNECTIONS Value
UNION
SELECT 'CPUBusy', @@CPU_BUSY
UNION
SELECT 'IDLE', @@IDLE
UNION
SELECT 'IOBusy', @@IO_BUSY
UNION
SELECT 'PacketErrors', @@PACKET_ERRORS
UNION
SELECT 'PackReceived', @@PACK_RECEIVED
UNION
SELECT 'PackSent', @@PACK_SENT
UNION
SELECT 'TimeTicks', @@TIMETICKS
UNION
SELECT 'TotalErrors', @@TOTAL_ERRORS
UNION
SELECT 'TotalRead', @@TOTAL_READ
UNION
SELECT 'TotalWrite', @@TOTAL_WRITE

