/*
The syntax for configuring cursor options is as follows:

ALTER DATABASE database_name
SET CURSOR_CLOSE_ON_COMMIT { ON | OFF }
| CURSOR_DEFAULT { LOCAL | GLOBAL }

The statement takes two arguments, the database name you want tomodify and the option
that you want to configure on and off.

CURSOR_CLOSE_ON_COMMIT	When CURSOR_CLOSE_ON_COMMIT is enabled, Transact-SQL
						cursors automatically close once a transaction is
						committed.

CURSOR_DEFAULT { LOCAL | GLOBAL }	If CURSOR_DEFAULT LOCAL is enabled, cursors created without
									explicitly setting scope as GLOBAL will default to local access.
									If CURSOR_DEFAULT GLOBAL is enabled, cursors created
									without explicitly setting scope as LOCAL will default to
									GLOBAL access.

*/
USE master 
GO

SET NOCOUNT ON

SELECT is_cursor_close_on_commit_on
FROM sys.databases
WHERE name = 'AdventureWorks'

ALTER DATABASE AdventureWorks
SET CURSOR_CLOSE_ON_COMMIT ON

SELECT is_cursor_close_on_commit_on
FROM sys.databases
WHERE name = 'AdventureWorks'

