/* 

ALTER DATABASE database_name
MODIFY FILE
{NAME = logical_file_name , FILENAME = 'new_physical_file_name_and_path')

*/

USE master
GO
-- Create a default database for this example
CREATE DATABASE BookTransferHouse
GO

ALTER DATABASE BookTransferHouse
SET OFFLINE
GO

-- Next, I’llmanuallymove the file C:\Program Files\Microsoft SQL Server\MSSQL10.AUGUSTUS\
-- MSSQL\DATA\BookTransferHouse.mdf to the C:\Apress directory. After that, I’ll execute the following:

ALTER DATABASE BookTransferHouse
MODIFY FILE (NAME = 'BookTransferHouse', FILENAME = 'C:\Apress\BookTransferHouse.mdf')
GO


/*

This returns

The file "BookTransferHouse" has been modified in the system catalog.
The new path will be used the next time the database is started.

*/
