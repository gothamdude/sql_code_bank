/*
This recipe demonstrates how to remove a user-defined filegroup. 
You can remove an empty filegroup using the following syntax:

ALTER DATABASE database_name
REMOVE FILEGROUP filegroup_name

*/

-- In this recipe, I’ll add a new filegroup called FG3 to the BookTransferHouse database. 
-- A new file will then be created within the filegroup. 
-- After that, the file will be removed, and then the userdefined filegroup will be removed:

ALTER DATABASE BookTransferHouse
ADD FILEGROUP FG3
GO

ALTER DATABASE BookTransferHouse
ADD FILE
( NAME = 'BW3',
FILENAME = 'C:\Apress\BW3.NDF' ,
SIZE = 1MB ,
MAXSIZE = 10MB,
FILEGROWTH = 5MB )
TO FILEGROUP [FG3]
GO


-- Now, the file in the filegroup is removed
ALTER DATABASE BookTransferHouse
REMOVE FILE BW3
GO

-- Then the filegroup
ALTER DATABASE BookTransferHouse
REMOVE FILEGROUP FG3
GO