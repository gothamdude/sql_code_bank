/*
SQL Server 2008 introduces the new FILESTREAM attribute, which can be applied to the
varbinary(max) data type. Using FILESTREAM, you can exceed the 2GB limit on stored values and take
advantage of relational handling of files via SQL Server, while actually storing the files on the file
system. BACKUP and RESTORE operations maintain both the database data as well as the files saved on
the file system, thus handling end-to-end data recoverability for applications that store both structured
and unstructured data. FILESTREAM marries the transactional consistency capabilities of SQL
Server with the performance advantages of NT file system streaming.

T-SQL is used to define the FILESTREAM attribute and can be used to handle the data; however,
Win32 streaming APIs are the preferred method from the application perspective when performing
actual read and write operations (specifically using the OpenSqlFilestream API). Although demonstrating
Win32 and the implementation of applicable APIs is outside of the scope of this book, I will
use this recipe to walk you through how to set up a database and table with the FILESTREAM attribute,
INSERT a new row, and use a query to pull path and transaction token information that is
necessary for the OpenSqlFilestream API call.

To confirm whether FILESTREAM is configured for the SQL Server instance, I can validate the setting
using the SERVERPROPERTY function and three different properties that describe the file share
name of the filestream share and the associated effective and actual configured values:

*/

SELECT  SERVERPROPERTY('FilestreamShareName') ShareName,
		SERVERPROPERTY('FilestreamEffectiveLevel') EffectiveLevel,
		SERVERPROPERTY('FilestreamConfiguredLevel') ConfiguredLevel


-- if filestream is configured... will return below
-----------------------------------------------------
-- ShareName	EffectiveLevel ConfiguredLevel
 -- NALA		3				3
 -----------------------------------------------------

 CREATE DATABASE PhotoRepository ON PRIMARY
( NAME = N'PhotoRepository',
FILENAME = N'C:\Apress\MDF\PhotoRepository.mdf' ,
SIZE = 3048KB ,
FILEGROWTH = 1024KB ),
FILEGROUP FS_PhotoRepository CONTAINS FILESTREAM
(NAME = 'FG_PhotoRepository',
FILENAME = N'C:\Apress\FILESTREAM')
LOG ON
( NAME = N'PhotoRepository_log',
FILENAME = N'C:\Apress\LDF\PhotoRepository_log.ldf' ,
SIZE = 1024KB ,
FILEGROWTH = 10%)
GO
Now I can create a new table that will be used to store photos for book covers. I will designate
the BookPhotoFile column as a varbinary(max) data type, followed by the FILESTREAM attribute:
USE PhotoRepository
GO
CREATE TABLE dbo.BookPhoto
(BookPhotoID uniqueidentifier ROWGUIDCOL NOT NULL PRIMARY KEY,
BookPhotoNM varchar(50) NOT NULL,
BookPhotoFile varbinary(max) FILESTREAM)
GO
Now that the table is created, I can INSERT a new row using the regular INSERT command and
importing a file using OPENROWSET (demonstrated in the previous recipe):
INSERT dbo.BookPhoto
(BookPhotoID, BookPhotoNM, BookPhotoFile)
SELECT NEWID(),
'SQL Server 2008 Transact-SQL Recipes cover',BulkColumn
FROM OPENROWSET(BULK
'C:\Apress\TSQL2008Recipes.bmp', SINGLE_BLOB) AS x
If I look under the C:\Apress\FILESTREAM directory, I will see a new subdirectory and a new file.
In this case, on my server, I see a new file called 00000012-000000e1-0002 under the path C:\Apress\
FILESTREAM\33486315-2ca1-43ea-a50e-0f84ad8c3fa6\e2f310f3-cd21-4f29-acd1-a0a3ffb1a681. Files
created using FILESTREAM should only be accessed within the context of T-SQL and the associated
Win32 APIs.
After inserting the value, I will now issue a SELECT to view the contents of the table:
SELECT BookPhotoID, BookPhotoNM, BookPhotoFile
FROM dbo.BookPhoto
This returns
BookPhotoID BookPhotoNM BookPhotoFile
236E5A69-53B3-4CB6-9F11- SQL Server 2008 T-SQL 0x424D36560000000000003604000028000
EF056082F542 Recipes cover 0007D000000A40000000100080000000000
005200000000000000000000000100000001
0000276B8E0026B0ED005B5D6900EEEEEE00
528CA2000E0A0B001C597900B3B3B3008B8A
8D00D1D1D1002AC6FF002394C7002280AB00
2C2A2B00193F560066ADBD0025A4DC001128
34005E
Now assuming I have an application that uses OLEDB to query the SQL Server instance, I need
to now collect the appropriate information about the file system file in order to stream it using my
application.
I’ll begin by opening up a transaction and using the new PathName() method of the varbinary
column to retrieve the logical path name of the file:
BEGIN TRAN
SELECT BookPhotoFile.PathName()
FROM dbo.BookPhoto
WHERE BookPhotoNM = 'SQL Server 2008 Transact-SQL Recipes cover'
This returns
\\CAESAR\AUGUSTUS\v1\PhotoRepository\dbo\BookPhoto\BookPhotoFile\
236E5A69-53B3-4CB6-9F11-EF056082F542
Next, I need to retrieve the transaction token, which is also needed by the Win 32 API:
SELECT GET_FILESTREAM_TRANSACTION_CONTEXT()
This returns
0x57773034AFA62746966EE30DAE70B344

After I have retrieved this information, the application can use the OpenSQLFileStream API with
the path and transaction token to perform functions such as ReadFile and WriteFile and then close
the handle to the file.
After the application is finished with its work, I can either roll back or commit the transaction:

COMMIT TRAN

If I wish to delete the file, I can set the column value to NULL:

UPDATE dbo.BookPhoto
SET BookPhotoFile = NULL
WHERE BookPhotoNM = 'SQL Server 2008 Transact-SQL Recipes cover'

You may not see the underlying file on the file system removed right away; however, it will be
removed eventually by the garage collector process.

How It Works
In this recipe, I demonstrated how to use the new SQL Server 2008 FILESYSTEM attribute of the
varbinary(max) data type to store unstructured data on the file system. This enables SQL Server
functionality to control transactions within SQL Server and recoverability (files get backed up with
BACKUP and restored with RESTORE), while also being able to take advantage of high-speed streaming
performance using Win 32 APIs.
In this recipe, I started off by checking whether FILESTREAM was enabled on the SQL Server
instance. After that, I created a new database, designating the location of the FILESTREAM filegroup
and file name (which is actually a path and not a file):
...
FILEGROUP FS_PhotoRepository CONTAINS FILESTREAM
(NAME = 'FG_PhotoRepository',
FILENAME = N'C:\Apress\FILESTREAM')
...
Keep in mind that the path up to the last folder has to exist, but the last folder referenced cannot
exist. For example, C:\Apress\ existed on my server; however, FILESTREAM can’t exist prior to the
database creation.
After creating the database, I then created a new table to store book cover images. For the
BookPhotoFile column, I designated the varbinary(max) type followed by the FILESTREAM attribute:
...
BookPhotoFile varbinary(max) FILESTREAM)
...
Had I left off the FILESTREAM attribute, any varbinary data stored would have been contained
within the database data file, and not stored on the file system. The column maximum size would
also have been capped at 2GB.
Next, I inserted a new row into the table that held the BMP file of the SQL Server 2008 Transact-
SQL Recipes book cover. The varbinary(max) value was generated using the OPENROWSET technique I
demonstrated in the previous recipe:
INSERT dbo.BookPhoto
(BookPhotoID, BookPhotoNM, BookPhotoFile)
SELECT NEWID(),
'SQL Server 2008 Transact-SQL Recipes cover',
BulkColumn
FROM OPENROWSET(BULK
'C:\Apress\TSQL2008Recipes.bmp', SINGLE_BLOB) AS x
From an application perspective, I needed a couple of pieces of information in order to
take advantage of streaming capabilities using Win 32 APIs. I started off by opening up a new
transaction:
BEGIN TRAN
After that, I referenced the path name of the stored file using the PathName() method:
SELECT BookPhotoFile.PathName()
...
This function returned a path as a token, which the application can then use to grab a Win32
handle and perform operations against the value.
Next, I called the GET_FILESTREAM_TRANSACTION_CONTEXT function to return a token representing
the current session’s transaction context:
SELECT GET_FILESTREAM_TRANSACTION_CONTEXT()
This was a token used by the application to bind file system operations to an actual
transaction.
After that, I committed the transaction and then demonstrated how to “delete” the file by
updating the BookPhotoFile column to NULL for the specific row I had added earlier. Keep in mind
that deleting the actual row would serve the same purpose (deleting the file on the file system).