/* 

A database can be in one of three states: online, offline, or emergency.

The online state is the default,meaning that the database is open and available to be used.
When in offline status, the database is “closed” and cannot bemodified or queried by any user. You
may wish to take a database offline in situations where you need tomove the data files to a new
physical location, and then use ALTER DATABASE tomodify themetadata for that file’s new location
(demonstrated later in the chapter). Unlike detaching the database, the database is still kept in the
metadata of the SQL Server instance, and can then be taken back online later on.

Lastly, if the database is corrupted, setting a database to an emergency state allows read-only
access to the database for sysadmin server role logins, allowing you to query any database objects
that are still accessible (depending on the nature of the problem).

The syntax for configuring the database state is as follows:

ALTER DATABASE database_name
SET { ONLINE | OFFLINE | EMERGENCY }

*/

USE master
GO
ALTER DATABASE AdventureWorks2008
SET OFFLINE
GO

-- Attempt a read against a table
SELECT COUNT(*)
FROM AdventureWorks2008.HumanResources.Department
GO

/* you will get:

Msg 942, Level 14, State 4, Line 1
Database 'AdventureWorks2008' cannot be opened because it is offline.

*/

ALTER DATABASE AdventureWorks2008
SET ONLINE
GO


