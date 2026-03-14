-- Displaying Database and SQL Server Settings
-- The DATABASEPROPERTYEX systemfunction allows you to retrieve information about database
-- options. DATABASEPROPERTYEX uses the following syntax:

SELECT  DATABASEPROPERTYEX('AdventureWorks', 'Collation'),
		DATABASEPROPERTYEX('AdventureWorks', 'Recovery'),
		DATABASEPROPERTYEX('AdventureWorks', 'Status')
		
		
		
/*
Returning the Current Database ID and Name
This DB_ID function returns the database integer ID, and DB_NAME returns the database name for the
current database (unless there are parameters supplied).
This example demonstrates how to retrieve the current database systemID and name:
*/
SELECT DB_ID() DatabaseID, DB_NAME() DatabaseNM


/*
Returning a Database Object Name and ID
OBJECT_ID returns the database object identifier number, as assigned internally within the database.
OBJECT_NAME returns the object’s name based on its object identifier number.
In this example, I’ll demonstrate how to return a database object’s name and ID: */ 
SELECT OBJECT_ID('AdventureWorks.HumanResources.Department'),
OBJECT_NAME(773577794, DB_ID('AdventureWorks'))


-- Returning the Application and Host for the Current User Session
SELECT APP_NAME() as 'Application',
HOST_ID() as 'Host ID',
HOST_NAME() as 'Host Name'

-- Reporting Current User and Login Context
SELECT SYSTEM_USER, -- Login
USER -- Database User


-- Viewing User Connection Options
-- In this recipe, I’ll demonstrate how to view the SET properties for the current user connection using
-- the SESSIONPROPERTY function (for information on SET options, see Chapter 22):
SELECT	SESSIONPROPERTY ('ANSI_NULLS') ANSI_NULLS,
		SESSIONPROPERTY ('ANSI_PADDING') ANSI_PADDING,
		SESSIONPROPERTY ('ANSI_WARNINGS') ANSI_WARNINGS,
		SESSIONPROPERTY ('ARITHABORT') ARITHABORT,
		SESSIONPROPERTY ('CONCAT_NULL_YIELDS_NULL') CONCAT_NULL_YIELDS_NULL,
		SESSIONPROPERTY ('NUMERIC_ROUNDABORT') NUMERIC_ROUNDABORT,
		SESSIONPROPERTY ('QUOTED_IDENTIFIER') QUOTED_IDENTIFIER
		
		
		

