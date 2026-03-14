/*

Once a database is created, assuming that you have available disk space, you can add additional
data or transaction logs to it as needed. 

This allows you to expand to new drives if the current physical drive/array is close to filled up, 
or if you are looking to improve performance by spreading I/O acrossmultiple drives. 

It usually onlymakes sense to add additional data and log files to a database
if you plan on putting these files on a separate drive/array. Putting multiple files on the same
drive/array doesn’t improve performance, and may only benefit you if you plan on performing
separate file or filegroup backups for a very large database.

ALTER DATABASE database_name
{ADD FILE <filespec> [ ,...n ]
[ TO FILEGROUP { filegroup_name | DEFAULT } ]
| ADD LOG FILE <filespec> [ ,...n ] }

*/

ALTER DATABASE BookData
ADD FILE
( NAME = 'BookData2',
FILENAME = 'C:\SqlData\BD2.NDF' ,
SIZE = 1MB ,
MAXSIZE = 10MB,
FILEGROWTH = 1MB )
TO FILEGROUP [PRIMARY]
GO

ALTER DATABASE BookData
ADD LOG FILE
( NAME = 'BookData2Log',
FILENAME = 'C:\SqlData\BD2.LDF' ,
SIZE = 1MB ,
MAXSIZE = 5MB,
FILEGROWTH = 1MB )
GO