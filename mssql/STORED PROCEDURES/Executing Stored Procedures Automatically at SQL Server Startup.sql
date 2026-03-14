
-- Executing Stored Procedures Automatically at SQL Server Startup

/*In this example, a stored procedure is set to execute automatically whenever SQL Server is
started. First, the database context is set to themaster database (which is the only place that autoexecutable
stored procedures can be placed):*/
USE master
GO
-- Next, for the example, a startup logging table is created:
CREATE TABLE dbo.SQLStartupLog
(SQLStartupLogID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
StartupDateTime datetime NOT NULL)
GO
/*Now, a new stored procedure is created to insert a value into the new table (so you can see
whenever SQL Server was restarted using the table):*/
CREATE PROCEDURE dbo.usp_INS_TrackSQLStartups
AS
INSERT dbo.SQLStartupLog
(StartupDateTime)
VALUES (GETDATE())
GO
/*Next, the sp_procoption stored procedure is used to set this new procedure to execute when
the SQL Server service restarts:*/
EXEC sp_procoption @ProcName = 'usp_INS_TrackSQLStartups',
@OptionName = 'startup',
@OptionValue = 'true'
/*Once the service restarts, a new row is inserted into the table. To disable the stored procedure
again, the following command would need to be executed:*/
EXEC sp_procoption @ProcName = 'usp_INS_TrackSQLStartups',
@OptionName = 'startup',
@OptionValue = 'false'