
-- I won't show rowcounts in the results
SET NOCOUNT ON

DECLARE @session_id smallint
-- Declare the cursor

DECLARE session_cursor CURSOR FORWARD_ONLY READ_ONLY
FOR SELECT session_id
	FROM sys.dm_exec_requests
	WHERE status IN ('runnable', 'sleeping', 'running')

-- Open the cursor
OPEN session_cursor
-- Retrieve one row at a time from the cursor

FETCH NEXT FROM session_cursor INTO @session_id
-- Keep retrieving rows while the cursor has them
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT 'Spid #: ' + STR(@session_id)
	EXEC ('DBCC OUTPUTBUFFER (' + @session_id + ')')
	-- Grab the next row
	FETCH NEXT FROM session_cursor INTO @session_id
END

-- Close the cursor
CLOSE session_cursor

-- Deallocate the cursor
DEALLOCATE session_cursor



/* 
Table 9-2. Cursor Options
------------------------------------------------------------------------------------
Option Description
------------------------------------------------------------------------------------
LOCAL or GLOBAL If LOCAL is selected, the cursor is only available within the scope
of the SQL batch, trigger, or stored procedure. If GLOBAL is
selected, the cursor is available to the connection itself (for
example, a connection that executes a stored procedure that
creates a cursor can use the cursor that was created in the stored
procedure execution).
FORWARD_ONLY or SCROLL The FORWARD_ONLY option only allows you tomove forward from
the first row of the cursor and onward. SCROLL, on the other hand,
allows you tomove backward and forward through the cursor
result set using all fetch options (FIRST, LAST, NEXT, PRIOR,
ABSOLUTE, and RELATIVE). If performance is a consideration, stick
to using FORWARD_ONLY—as this cursor type incurs less overhead
than the SCROLL.
STATIC or KEYSET or DYNAMIC When STATIC is specified, a snapshot of the cursor data is held
or FAST_FORWARD in the DYNAMIC or FAST_FORWARD tempdb database, and any changes
made at the original data source aren’t reflected in the cursor
data. KEYSET allows you to see changes to rowsmade outside of
the cursor, although you can’t see inserts that would havemet
the cursor’s SELECT query or deletes after the cursor has been
opened. DYNAMIC allows you to see updates, inserts, and deletes
in the underlying data source while the cursor is open.
FAST_FORWARD defines two behaviors: setting the cursor to readonly
and forward-only status (this is usually the best-performing
cursor option, but the least flexible).When faced with a
performance decision, and your desired functionality is not
complicated, use this option.
READ_ONLY or SCROLL_LOCKS The READ_ONLY optionmeans that updates cannot bemade
or OPTIMISTIC through the cursor. If performance and concurrency are
considerations, use this option. SCROLL_LOCKS places locks on
rows so that updates or deletes are guaranteed to bemade after
the cursor is closed. The OPTIMISTIC option places no locks on
updated or deleted rows, and will onlymaintainmodifications if
an update has not occurred outside of the cursor since the last
data read.
TYPE_WARNINGS When TYPE_WARNINGS is specified, a warning will be sent to the
client if the cursor is implicitly converted fromone type to a
different type.
------------------------------------------------------------------------------------
*/
