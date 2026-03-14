/* 

You can use ALTER DATABASE to set the database or specific user-defined filegroup to read-only
access.Making a database or filegroup read-only prevents datamodifications fromtaking place and
is often used for static reporting databases. Using read-only options can improve query performance,
because SQL Server no longer needs to lock objects queried within the database due to the
fact that data and objectmodification in the database or user-defined filegroup is not allowed
(although this isn’t a replacement for setting up appropriate security permissions for data and
objectmodifications)

The syntax for changing a database’s updateability is as follows:
ALTER DATABASE database_name
SET { READ_ONLY | READ_WRITE }

*/


USE master
GO
-- Make the database read only
ALTER DATABASE BookTransferHouse
SET READ_ONLY
GO
-- Allow updates again
ALTER DATABASE BookTransferHouse
SET READ_WRITE
GO

-- Add a new filegroup
ALTER DATABASE BookTransferHouse
ADD FILEGROUP FG4
GO

-- Add a file to the filegroup
ALTER DATABASE BookTransferHouse
ADD FILE
( NAME = 'BW4',
FILENAME = 'C:\Apress\BW4.NDF' ,
SIZE = 1MB ,
MAXSIZE = 50MB,
FILEGROWTH = 5MB )
TO FILEGROUP [FG4]
GO

-- Make a specific filegroup read-only
ALTER DATABASE BookTransferHouse
MODIFY FILEGROUP FG4 READ_ONLY
GO

-- Allow updates again
ALTER DATABASE BookTransferHouse
MODIFY FILEGROUP FG4 READ_WRITE
GO