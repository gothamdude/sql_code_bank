/*
The syntax for removing a file (data or transaction log) is as follows:

ALTER DATABASE database_name
REMOVE FILE logical_file_name
*/

USE BookData
GO

SELECT name
FROM sys.database_files

DBCC SHRINKFILE(BookData2, EMPTYFILE)

ALTER DATABASE BookData
REMOVE FILE BookData2