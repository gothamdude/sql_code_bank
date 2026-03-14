-- RECOMPILE(ing) a Stored Procedure Each Time It Is Executed
/*
A recompilation occurs when a stored procedure’s plan is re-created either automatically or explicitly.
Recompilations occur automatically during stored procedure execution when underlying table
or other object changes occur to objects that are referenced within a stored procedure. They can
also occur with changes to indexes used by the plan or after a large number of updates to table keys
referenced by the stored procedure. The goal of an automatic recompilation is tomake sure the SQL
Server execution plan is using themost current information and not using out-of-date assumptions
about the schema and data.
SQL Server also uses statement-level recompiles within the stored procedure, instead of
recompiling the entire stored procedure. Since recompiles cause extra overhead in generating new
plans, statement-level recompiles help decrease this overhead by correcting only what needs to be
corrected.
Although recompilations are costly and should be avoidedmost of the time, theremay sometimes
be reasons why you would want to force a recompilation. For example, your proceduremay
produce wildly different query results based on the application calling it due to varying selectivity of
qualified columns—somuch so that the retained execution plan causes performance issues when
varying input parameters are used.
For example, if one parameter value for City returns amatch of onemillion rows, while
another value for City returns a single row, SQL Servermay not necessarily cache the correct execution
plan. SQL Servermay end up caching a plan that is optimized for the single row instead of the
million rows, causing a long query execution time. If you’re looking to use stored procedures for
benefits other than caching, you can use the WITH RECOMPILE command.

In this example, I demonstrate how to force a stored procedure to recompile each time it is
executed:*/

CREATE PROCEDURE dbo.usp_SEL_BackupMBsPerSecond (
	@BackupStartDate datetime,
	@BackupFinishDate datetime
)
WITH RECOMPILE -- Plan will never be saved
AS
-- Procedure measure db backup throughput
SELECT (SUM(backup_size)/1024)/1024 as 'MB',
DATEDIFF ( ss , MIN(backup_start_date),
MAX(backup_finish_date)) as 'seconds',
((SUM(backup_size)/1024)/1024 )/
DATEDIFF ( ss , MIN(backup_start_date) ,
MAX(backup_finish_date)) as 'MB per second'
FROM msdb.dbo.backupset
WHERE backup_start_date >= @BackupStartDate AND
backup_finish_date < @BackupFinishDate AND
type = 'd'
GO

-- Now whenever this procedure is called, a new execution plan will be created by SQL Server.