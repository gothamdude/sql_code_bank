/*
The syntax for configuring automatic database options is as follows:

ALTER DATABASE database_name
SET AUTO_CLOSE { ON | OFF } 
| AUTO_CREATE_STATISTICS { ON | OFF }
| AUTO_SHRINK { ON | OFF }
| AUTO_UPDATE_STATISTICS { ON | OFF }
| AUTO_UPDATE_STATISTICS_ASYNC { ON | OFF }

Automatic database options impact the behavior of the SQL Server database engine, enabling or
disabling automaticmaintenance ormetadata updates

NOTE:  YOU DO NOT WANT TO DO AUTO_CLOSE AND AUTO_SHRINK!!! BAD FOR PERFORMANCE
		STATISTICS should not be turned off as it helps SQL Server when compiling the best query optimization plan 
---------------------------------------------------------------------------------------------------------

AUTO_CLOSE		When this option is enabled, the database is closed and shut
				down when the last user connection to the database exits and
				all processes are completed.
AUTO_CREATE_STATISTICS	When this option is enabled, SQL Server automatically
						generates statistical information regarding the distribution
						of values in a column. This information assists the query
						processor with generating an acceptable query execution plan
						(the internal plan for returning the result set requested by the query).
AUTO_SHRINK		When this option is enabled, SQL Server shrinks data and log
				files automatically. Shrinking will only occur whenmore than
				25 percent of the file has unused space. The database is then
				shrunk to either 25 percent free, or the original data or log file
				size. For example, if you defined your primary data file to be
				100MB, a shrink operation would be unable to decrease the file
				size smaller than 100MB.

AUTO_UPDATE_STATISTICS	When this option is enabled, statistics already created for your
						tables are automatically updated.

AUTO_UPDATE_STATISTICS_ASYNC When this option is ON, if a query initiates an automatic update
							 of old statistics, the query will not wait for the statistics to be
							updated before compiling.When OFF (the default), a query that
							initiates statistics updates will wait until the update is finished
							before compiling a query plan.

---------------------------------------------------------------------------------------------------------
*/

USE master 
GO

SET NOCOUNT ON

SELECT is_auto_update_stats_async_on
FROM sys.databases
WHERE name = 'TestAttach'

ALTER DATABASE TestAttach
SET AUTO_UPDATE_STATISTICS_ASYNC ON

SELECT is_auto_update_stats_async_on
FROM sys.databases
WHERE name = 'TestAttach'

