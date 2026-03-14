-- using detach/attach method is a clean way to migrate a database from SQL Server instance to another
-- assuming that a copy of the database need not remain on both SQL Server instances 

/*
CREATE DATABASE database_name
ON <filespec> [ ,...n ]
FOR { ATTACH
| ATTACH_REBUILD_LOG }

<filespec> [ ,...n ] This defines the name of the primary data file and any other
database files. If the file locations of the originally detached
databasematch the existing file location, you only need to include
the primary data file reference. If file locations have changed,
however, you should designate the location of each database file.

ATTACH | ATTACH_REBUILD_LOG The ATTACH option designates that the database is created using
all original files that were used in the detached database.When
ATTACH_REBUILD_LOG is designated, and if the transaction log file or
files are unavailable, SQL Server will rebuild the transaction log
file or files.

*/

USE master 
GO


CREATE DATABASE TestAttach
ON 
( FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\TestDetach.mdf')
FOR ATTACH
GO 