/*

This recipe demonstrates how to add a filegroup to an existing database using ALTER DATABASE.
Once the filegroup is created, you can then add a file or files to it.

*/

ALTER DATABASE BookTransferHouse
ADD FILEGROUP FG2
GO

ALTER DATABASE BookTransferHouse
ADD FILE (  NAME = 'BW2',
			FILENAME = 'C:\Apress\BW2.NDF' ,
			SIZE = 1MB ,
			MAXSIZE = 50MB,
			FILEGROWTH = 5MB )
TO FILEGROUP [FG2]
GO