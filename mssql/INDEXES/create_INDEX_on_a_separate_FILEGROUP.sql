-- This example demonstrates how to explicitly define which filegroup an index is stored on. First,
-- I’ll create a new filegroup on the AdventureWorks database:

ALTER DATABASE AdventureWorks2008 
ADD FILEGROUP FG2

-- Next, I’ll add a new file to the database and the newly created filegroup

ALTER DATABASE AdventureWorks2008 
ADD FILE ( 	NAME = AW2,
			FILENAME = 'c:\SQLData\aw2.ndf',
			SIZE=1MB
) TO FILEGROUP FG2

-- Lastly, I’ll create a new index, designating that it be stored on the newly created filegroup:

CREATE INDEX NI_ProductPhoto_ThumbNailPhotoFileName ON 
Production.ProductPhoto(ThumbnailPhotoFileName)
ON [FG2]


/*

Filegroups can be used to helpmanage very large databases, both by allowing separate backups
by filegroup, as well as improving I/O performance if the filegroup has files that exist on a
separate array.

*/