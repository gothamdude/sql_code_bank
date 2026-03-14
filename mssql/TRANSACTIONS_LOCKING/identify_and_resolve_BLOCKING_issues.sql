/*
This recipe demonstrates how to identify blocking processes with the SQL Server Dynamic
Management View sys.dm_os_waiting_tasks. This view is intended to be used instead of the sp_who
systemstored procedure, which was used in previous versions of SQL Server.

After identifying the blocking process, this recipe will then use the sys.dm_exec_sql_text
dynamicmanagement function and sys.dm_exec_connections DMV used earlier in the chapter to
identify the SQL text of the query that is being executed—and then as a last resort, forcefully end the
process.

To forcefully shut down a wayward active query session, the KILL command is used. KILL
should only be used if othermethods are not available, including waiting for the process to stop on
its own or shutting down or canceling the operation via the calling application. The syntax for KILL
is as follows:

KILL {spid | UOW} [WITH STATUSONLY]

*/

SELECT blocking_session_id, wait_duration_ms, session_id 
FROM sys.dm_os_waiting_tasks
WHERE blocking_session_id IS NOT NULL 

/*
--This returns
-----------------------------------------------------------------------------
blocking_session_id		wait_duration_ms	session_id
-----------------------------------------------------------------------------
54						27371				55
-----------------------------------------------------------------------------

This query identified that session 54 is blocking session 55.
To see what session 54 is doing, I execute the following query in the same window as the previous
query:
*/

SELECT t.text
FROM sys.dm_exec_connections c
	CROSS APPLY sys.dm_exec_sql_text (c.most_recent_sql_handle) t
WHERE c.session_id = 54

-- Next, to forcibly shut down the session, execute this query:

KILL 54

-- This returns
-----------------------------------------------------------------------------------------------
-- Command(s) completed successfully.