/* how to change the owner of an existing database using the sp_changedbowner systemstored procedure.

The syntax for this systemstored procedure is as follows:

sp_changedbowner [ @loginame = ] 'login'
[ , [ @map= ] remap_alias_flag ]

----------------------------------------------------------------------------------------------------

'login' This specifies the new SQL Server login that will own the database. This login
		cannot already bemapped to an existing database user (without dropping
		this user first).

remap_alias_flag	The optional flag references alias functionality, which was used in previous
					versions of SQL Server and allowed you tomap users to a database. Alias
					functionality is going to be removed in a future version of SQL Server, so don’t
					use it.

----------------------------------------------------------------------------------------------------
*/

USE master 
GO 

CREATE LOGIN NewBossInTown WITH PASSWORD = 'HereGoesTheNeighborhood10'
GO

USE [BookMart]
GO

SELECT p.name
FROM sys.databases d
INNER JOIN sys.server_principals p ON
d.owner_sid = p.sid
WHERE d.name = 'BookMart'

EXEC sp_changedbowner 'NewBossInTown'
GO

SELECT p.name
FROM sys.databases d
INNER JOIN sys.server_principals p ON
d.owner_sid = p.sid
WHERE d.name = 'BookMart'

