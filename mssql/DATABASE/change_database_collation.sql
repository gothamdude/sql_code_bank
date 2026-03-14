/* 

SQL Server collations determine how data is sorted, compared, presented, and stored. 
The database collation can be different fromthe server-level collation defined when the 
SQL Server instance was installed, for those times that youmay wish to store data with 
a differing code page or sort order fromthe SQL Server instance default.

*/

CREATE DATABASE BookStoreArchive_Ukrainian
ON PRIMARY
( NAME = 'BookStoreArchive_UKR',
FILENAME = 'C:\SqlData\BookStoreArchive_UKR.mdf',
SIZE = 3MB ,
MAXSIZE = UNLIMITED,
FILEGROWTH = 10MB )
LOG ON
( NAME = 'BookStoreArchive_UKR_log',
FILENAME = 'C:\SqlData\BookStoreArchive_UKR_log.ldf',
SIZE = 504KB ,
MAXSIZE = 100MB ,
FILEGROWTH = 10%)
COLLATE Ukrainian_CI_AI  -- on CREATE 
GO

ALTER DATABASE BookStoreArchive_Ukrainian
COLLATE Ukrainian_CS_AS   -- on ALTER 
GO

/*
Caution Creating a user-defined database with a default collation different from the SQL Server instance
		default (system database) can cause collation conflicts (cross-collation data cannot be converted or joined in a
		query). For example, the tempdb system database uses the same collation as the model database, which may
		cause temporary table data operations to fail in conjunction with a different collation. Always test cross-collation
		operations thoroughly.
*/