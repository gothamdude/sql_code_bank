/* 
When following this recipe, keep inmind that shrinking
databases and database files is a relatively expensive operation, introduces fragmentation, and
should only be performed when necessary.

Database files, when auto-growth is enabled, can expand due to index rebuilds or datamodification
activity. Youmay have extra space in the database due to datamodifications and index
rebuilds. If you don’t need to free up the unused space, you should allow the database to keep it
reserved. However, if you do need the unused space and want to free it up, use DBCC SHRINKDATABASE
or DBCC SHRINKFILE.


DBCC SHRINKDATABASE
( 'database_name' | database_id | 0
[ ,target_percent ]
[ , { NOTRUNCATE | TRUNCATEONLY } ]
)
[ WITH NO_INFOMSGS ]


DBCC SHRINKFILE
(
{ ' file_name ' | file_id }
{ [ , EMPTYFILE]
| [ [ , target_size ] [ , { NOTRUNCATE | TRUNCATEONLY } ] ]
}
)
[ WITH NO_INFOMSGS ]

In this recipe, the AdventureWorks database will have its files expanded by allocating additional
space using ALTER DATABASE...MODIFY FILE and then shrunk using the two DBCC file and database
shrinking commands. In the first example, the AdventureWorks data and transaction log file are both
expanded to larger sizes and then shrunk using a single DBCC operation:
*/

ALTER DATABASE AdventureWorks
MODIFY FILE (NAME = AdventureWorks2008_Data , SIZE= 250MB)
GO

ALTER DATABASE AdventureWorks
MODIFY FILE (NAME = AdventureWorks2008_Log , SIZE= 500MB)
GO
-- The sp_spaceused systemstored procedure is then used to return the space usage for the AdventureWorks database:
USE AdventureWorks
GO

EXEC sp_spaceused
GO

-- Next, the size is reduced using DBCC SHRINKDATABASE:
DBCC SHRINKDATABASE ('AdventureWorks', 10)

-- In the second example of this recipe, only the transaction log file is expanded, and then shrunk
using DBCC SHRINKFILE:
ALTER DATABASE AdventureWorks
MODIFY FILE (NAME = AdventureWorks2008_Log , SIZE= 150MB)
GO
-- The sp_spaceused systemstored procedure is then used to return the space usage for the AdventureWorks database:

USE AdventureWorks
GO
EXEC sp_spaceused
GO

-- Next, the size is reduced using DBCC SHRINKFile:
DBCC SHRINKFILE ('AdventureWorks2008_Log', 100)